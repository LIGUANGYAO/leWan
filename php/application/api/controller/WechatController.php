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
use phpDocumentor\Reflection\DocBlockFactory;
use think\Db;
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

            parent::Tpl_Empty($Code,"授权失败1",2);
            //网页授权的Access_token
            $AccUrl          = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=". WX_APPID . "&secret=".WX_APPSECRET."&code=".$Code."&grant_type=authorization_code";
            $Access_token    = json_decode(curlGet($AccUrl),true);

            if ($Access_token['errcode']){
                $this->returnApiData("授权失败2", 400, $Access_token);
            }else{
                $Expire = time();
                $userinfo = "https://api.weixin.qq.com/sns/userinfo?access_token=".$Access_token['access_token']."&openid=".$Access_token['openid']."&lang=zh_CN";
                $userinfo = json_decode(curlGet($userinfo),true);

                if (isset($userinfo["errcode"])){
                    $this->returnApiData("授权失败3", 400);
                }else{
                    $hasUser = Db::name('user_connect')->where(['union_id'=>$userinfo["unionid"]])->find();
                    Db::startTrans();//开启事务
                    if(!$hasUser){
                        //注册新用户
                        if ($Recode){
                            $ReUser = Db::name('user')->where(['recode'=>$Recode])->find();
                            if ($ReUser){
                                $UserData["sid"]  = $ReUser["user_id"];
                            }
                        }
                        $UserData["token"]    = Md5Help::getToken($userinfo["openid"]);
                        $UserData["nickname"] = $userinfo["nickname"];
                        $UserData["avatar"]   = $userinfo["headimgurl"];
                        $UserData["level"]    = 1;
                        $UserData["status"]   = 1;
                        $UserData["wxgpsaddr"]= $userinfo["country"].$userinfo["province"].$userinfo["city"];
                        $UserData["reg_time"] = time();
                        $Uid = UserModel::UserAdd($UserData);
                        if (!$Uid){
                            Db::rollback();//失败回滚exit;
                            $this->returnApiData('授权失败4', 400);
                        }
                    }else{
                        $Uid = $hasUser['user_id'];
                    }
                    if(!$hasUser || $hasUser['platform']=='wxapp'){
                        //关联第三方账号
                        $ConnectData["openid"]                  = $Access_token["openid"];
                        $ConnectData["user_id"]                 = $Uid;
                        $ConnectData["platform"]                = "wechat";
                        $ConnectData["union_id"]                = $userinfo["unionid"];
                        $ConnectData["accesstoken"]             = $Access_token["access_token"];
                        $ConnectData["refresh_token"]           = $Access_token["refresh_token"];
                        $ConnectData["accesstoken_expired"]     = parent::Tpl_Time($Expire,7,2);//过期时间当前时间2小时
                        $ConnectData["data"]                    = json_encode($userinfo);
                        $ConnectData["addtime"]                 = $Expire;
                        $Connect = UserModel::UserConnectAdd($ConnectData);
                        if (!$Connect){
                            Db::rollback();//失败回滚exit;
                            $this->returnApiData('授权失败5', 400);
                        }
                    }
//                    //验证是否关注
//                    if($hasUser && $hasUser['subscribe'] == 0){
//                        $accessToken = HelpModel::getAccessToken();
//                        $suburl = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=".$accessToken."&openid=".$Access_token["openid"]."&lang=zh_CN";
//                        $hasSubsribe = json_decode(curlGet($suburl), true);
//                        Db::name('user_connect')->where(['user_id'=>$Uid, 'platform'=>'wechat'])->update(['subscribe'=>$hasSubsribe['subscribe']]);
//                    }
                    Db::commit();//成功提交事务
                }
            }
            $return = Db::name('user u')->field('u.user_id,u.token,u.recode,u.avatar,u.nickname,u.`level`,c.subscribe')
                    ->join('jay_user_connect c', 'c.user_id = u.user_id', 'left')->where(['u.user_id'=>$Uid])->find();
            $this->returnApiData('授权成功', 200, $return);
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
            $Url   = input("post.url");
            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

//            if(!$Url){
//                // 注意 URL 一定要动态获取，不能 hardcode.
//                $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443) ? "https://" : "http://";
//                $Url = "$protocol$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
//            }
//
//            $Ticket = HelpModel::getAccessToken();
//            $Ticket = $Ticket['ticket'];
//
//            $NonceStr   = Func_Random(16);
//            $TimesTamp  = time();
//            $String     = "jsapi_ticket=$Ticket&noncestr=$NonceStr&timestamp=$TimesTamp&url=$Url";
//            $SignaTure  = sha1($String);
//
//            $SignPackage = array (
//                                "appId"       => WX_APPID,
//                                "nonceStr"    => $NonceStr,
//                                "timestamp"   => $TimesTamp,
//                                "url"         => $Url,
//                                "signature"   => $SignaTure,
//                                "rawString"   => $String,
//                            );

            Vendor('WxPay.jssdk');
            $jssdk = new \JSSDK(WX_APPID, WX_APPSECRET,$Url);
            $SignPackage = $jssdk->getSignPackage();

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

