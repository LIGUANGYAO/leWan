<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/2
 * Time: 10:57
 * 微信公众号授权控制器
 * 肖亚子
 */

namespace app\api\controller;
use app\api\controller\ApiBaseController;
use think\Request;
use Think\Exception;
use app\api\model\UserModel;
use app\api\model\HelpModel;
use app\common\Md5Help;

class WechatController extends ApiBaseController{

    /**
     * 用户同意授权，获取code
     */
    public function WechatAuthorizeCode(){
        try {

            $Redirect_url = input("post.redirect_url","","htmlspecialchars,strip_tags");

            if (!self::is_WechAt()) {
                $this->returnApiData('请在微信端进行访问', 400);
            }

            $Url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" . WX_APPID . "&redirect_uri={$Redirect_url}&response_type=code&scope=snsapi_userinfo&connect_redirect=1#wechat_redirect";
            $this->returnApiData("授权失败", 400,$Url);
            $authorize = curlGet($Url);

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * 通过code换取网页授权access_token 用户信息
     */
    public function WechatAuthorize(){
        try{
            $Code    = input("post.code","","htmlspecialchars,strip_tags");//微信code码
            $Recode  = input("post.recode","","htmlspecialchars,strip_tags");//用户推荐码
//            $Lng     = input("post.lng","","htmlspecialchars,strip_tags");//用户经度
//            $Lat     = input("post.alt","","htmlspecialchars,strip_tags");//用户纬度

            parent::Tpl_Empty($Code,"授权失败",2);
//            parent::Tpl_Empty($Lng,"授权失败",2);
//            parent::Tpl_Empty($Lat,"授权失败",2);

            $AccUrl          = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=". WX_APPID . "&secret=".WX_APPSECRET."&code=".$Code."&grant_type=authorization_code";
            $Access_token    = json_decode(curlGet($AccUrl),true);
            $BaseUrl         = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=". WX_APPID . "&secret=".WX_APPSECRET;
            $BaseAccesstoken = json_decode(curlGet($BaseUrl),true);

            if (isset($Access_token["errcode"]) ||isset($BaseAccesstoken["errcode"]) ){
                $this->returnApiData("授权失败", 400);
            }else{
                $Expire = time();

                $BaseDetails = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=".$BaseAccesstoken["access_token"]."&openid=".$Access_token["openid"];
                $BaseDetails = json_decode(curlGet($BaseDetails),true);

                if (isset($BaseDetails["errcode"])){
                    $this->returnApiData("授权失败", 400);
                }else{
                    $UserCondition["uc.openid"] = array("eq",$BaseDetails["openid"]);
                    $User = UserModel::UserDataFind($UserCondition,"u.user_id,u.token");

                    $UserName = UserModel::TableName();
                    $UserName->startTrans();//开启事务

                    if(!$User){
                        if ($Recode){
                            $ReUser = UserModel::UserDataFind(array("u.recode",array("eq",$Recode)),"u.user_id");
                            if ($ReUser){
                                $UserData["sid"]  = $ReUser["user_id"];
                            }
                        }

                        $UserData["token"]    = Md5Help::getToken($BaseDetails["openid"]);
                        //$UserData["recode"]   = HelpModel::makeUserCode();
                        $UserData["nickname"] = $BaseDetails["nickname"];
                        $UserData["avatar"]   = $BaseDetails["headimgurl"];
                        $UserData["level"]    = 1;
                        $UserData["status"]   = 1;
//                        $UserData["lat"]      = $Lat;
//                        $UserData["lng"]      = $Lng;
                        $UserData["wxgpsaddr"]= $BaseDetails["country"].$BaseDetails["province"].$BaseDetails["city"];
                        $UserData["reg_time"] = time();

                        $Uid = UserModel::UserAdd($UserData);

                        if (!$Uid){
                            $UserName->rollback();//失败回滚exit;
                            $this->returnApiData('授权失败', 400);
                        }

                        $ConnectData["openid"]                  = $Access_token["openid"];
                        $ConnectData["user_id"]                 = $Uid;
                        $ConnectData["subscribe"]               = $BaseDetails["subscribe"];
                        $ConnectData["platform"]                = "wechat";
                        $ConnectData["union_id"]                = $BaseDetails["unionid"];
                        $ConnectData["accesstoken"]             = $BaseAccesstoken["access_token"];
                        $ConnectData["accesstoken_expired"]     = parent::Tpl_Time($Expire,7,2);//过期时间当前时间2小时
                        $ConnectData["data"]                    = json_encode($BaseDetails);
                        $ConnectData["addtime"]                 = $Expire;

                        $Connect = UserModel::UserConnectAdd($ConnectData);

                        if (!$Connect){
                            $UserName->rollback();//失败回滚exit;
                            $this->returnApiData('授权失败', 400);
                        }
                    }else{
                        $Condition["user_id"] =  array("eq",$User["user_id"]);

                        $UserData["nickname"] = $BaseDetails["nickname"];
                        $UserData["avatar"]   = $BaseDetails["headimgurl"];

                        $UserUp = UserModel::UserUpdate($Condition,$UserData);

                        $ConnectData["subscribe"]               = $BaseDetails["subscribe"];
                        $ConnectData["union_id"]                = $BaseDetails["unionid"];
                        $ConnectData["accesstoken"]             = $BaseAccesstoken["access_token"];
                        $ConnectData["accesstoken_expired"]     = parent::Tpl_Time($Expire,7,2);//过期时间当前时间2小时
                        $ConnectData["data"]                    = json_encode($BaseDetails);
                        $ConnectData["addtime"]                 = $Expire;

                        $ConnectUp = UserModel::UserConnectUpdate($Condition,$ConnectData);

                        if (!$ConnectUp){
                            $UserName->rollback();//失败回滚exit;
                            $this->returnApiData('授权失败', 400);
                        }
                    }
                    $UserName->commit();//成功提交事务
                }
            }

            $Users["token"]     = empty($User)?$UserData["token"]:$User["token"];
            $Users["nickname"]  = $BaseDetails["nickname"];
            $Users["avatar"]    = $BaseDetails["headimgurl"];
            $Users["subscribe"] = $BaseDetails["subscribe"];
            $Users["level"]     = 1;

            $this->returnApiData('授权成功', 200, $Users);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取用户定位
     * 肖亚子
     */
    public function WechatPosition(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Url   = input("post.url","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            $Uid = UserModel::UserFindUid($Token);

            $Condition["u.user_id"] = array("eq",$Uid);
            $User = UserModel::UserDataFind($Condition,"uc.accesstoken,uc.openid");


            $TicketList = self::JsApiTicket($User["accesstoken"]);
            $Ticket     = $TicketList ['ticket'];
            $NonceStr   = Func_Random(16);
            $TimesTamp  = time();
            $String     = "jsapi_ticket=$Ticket&noncestr=$NonceStr&tamp=$TimesTamp&url=$Url";
            $SignaTure  = sha1($String);

            $SignPackage = array (
                                "appId"       => WX_APPID,
                                "nonceStr"    => $NonceStr,
                                "timestamp"   => $TimesTamp,
                                "url"         => $Url,
                                "signature"   => $SignaTure,
                                "rawString"   => $String,
                            );

            $this->returnApiData('获取成功', 200, $SignPackage);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 用户确定定位，录入经纬度
     * 肖亚子
     */
    public function WechatGeography(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Lng   = input("post.lng","","htmlspecialchars,strip_tags");//用户经度
            $Lat   = input("post.alt","","htmlspecialchars,strip_tags");//用户纬度

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($Lng,"授权失败",2);
            parent::Tpl_Empty($Lat,"授权失败",2);

            $UserData["lat"] = $Lat;
            $UserData["lng"] = $Lng;

            $Uid = UserModel::UserFindUid($Token);

            $Condition["user_id"] = array("eq",$Uid);

            $UserUp = UserModel::UserUpdate($Condition,$UserData);

            $this->returnApiData('获取成功', 200);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }

    /**
     * @param $AccessToken  用户acctoken
     * @return mixed
     * 获取用户jsapi数据
     * 肖亚子
     */
    private function JsApiTicket($AccessToken) {

        $url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=$AccessToken&&type=jsapi";
        // 微信返回的信息
        $returnData = json_decode(curlGet($url),true);
       // $returnData = json_decode($this->curlHttp($url));

        $resData['ticket'] = $returnData["ticket"];
        $resData['expiresIn'] = $returnData["expires_in"];
        $resData['time'] = date("Y-m-d H:i",time());
        $resData['errcode'] = $returnData["errcode"];

        return $resData;
    }

    /**
     * @return bool
     * 获取来源是不是微信客户端
     * 肖亚子
     */
    public function is_Wechat(){
        if ( strpos($_SERVER['HTTP_USER_AGENT'], 'MicroMessenger') !== false ) {
            return true;
        }
        return false;
    }

}

