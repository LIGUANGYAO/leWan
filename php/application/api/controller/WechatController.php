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
use Think\Crypt\Driver\Base64;
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
     * 微信公众号授权
     * 通过code换取网页授权access_token 用户信息
     */
    public function WechatAuthorize(){
        try{
            $Code    = input("post.code","","htmlspecialchars,strip_tags");//微信code码
            $Recode  = input("post.recode","","htmlspecialchars,strip_tags");//用户推荐码

            if($this->headerData["product"] != "wechat"){
                $this->returnApiData('授权失败7', 400);
            }
            parent::Tpl_Empty($Code,"授权失败6",2);
            //网页授权的Access_token
            $AccUrl          = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=". WX_APPID . "&secret=".WX_APPSECRET."&code=".$Code."&grant_type=authorization_code";
            $Access_token    = json_decode(curlGet($AccUrl),true);

            if ($Access_token['errcode']){
                $this->returnApiData("授权失败4", 400, $Access_token);
            }else{
                $Expire = time();
                $userinfo = "https://api.weixin.qq.com/sns/userinfo?access_token=".$Access_token['access_token']."&openid=".$Access_token['openid']."&lang=zh_CN";
                $userinfo = json_decode(curlGet($userinfo),true);

                if (isset($userinfo["errcode"])){
                    $this->returnApiData("授权失败5", 400);
                }else{
                    $where1['union_id'] = $userinfo["unionid"];
                    $where1['platform'] = 'wechat';

                    $hasUser = Db::name('user_connect')->where($where1)->order('addtime desc')->find();

                    if (!$hasUser){
                        $where1['platform'] = 'wxapp';
                        $hasUser = Db::name('user_connect')->where($where1)->find();
                    }

                    Db::startTrans();//开启事务
                    if(!$hasUser){
                        //注册新用户
                        if ($Recode){
                            $ReUser = Db::name('user')->where(['recode'=>$Recode])->find();
                            if ($ReUser){
                                $UserData["sid"]  = $ReUser["user_id"];
                            }
                        }
                        $UserData["token"]        = Md5Help::getToken($userinfo["openid"]);
                        $UserData["nickname"]     = self::FilterEmoji($userinfo["nickname"]);
                        $UserData["avatar"]       = $userinfo["headimgurl"];
                        $UserData["level"]        = 1;
                        $UserData["status"]       = 1;
                        $UserData["wxgpsaddr"]    = $userinfo["country"].$userinfo["province"].$userinfo["city"];
                        $UserData["reg_time"]     = time();
                        $UserData["upgrade_time"] = time();
                        $Uid = UserModel::UserAdd($UserData);
                        if (!$Uid){
                            Db::rollback();//失败回滚exit;
                            $this->returnApiData('授权失败2', 400);
                        }
                    }else{
                        $Uid = $hasUser['user_id'];

                        $UserData["nickname"] = self::FilterEmoji($userinfo["nickname"]);
                        $UserData["avatar"]   = $userinfo["headimgurl"];
                        $UserData["up_time"]  = time();

                        $UserUp = UserModel::UserUpdate(array("user_id"=>array("eq",$Uid)),$UserData);

                        if (!$UserUp){
                            Db::rollback();//失败回滚exit;
                            $this->returnApiData('授权失败1', 400);
                        }
                    }

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

                    if (!$hasUser){
                        $Connect = UserModel::UserConnectAdd($ConnectData);
                    }else{
                        if ($hasUser["platform"] == "wechat"){
                            $Condition["user_id"]  = array("eq",$Uid);
                            $Condition["platform"] = array("eq","wechat");

                            $Connect = UserModel::UserConnectUpdate($Condition,$ConnectData);
                        }else{
                            $Connect = UserModel::UserConnectAdd($ConnectData);
                        }
                    }

                    if (!$Connect){
                        Db::rollback();//失败回滚exit;
                        $this->returnApiData('登录失败', 400);
                    }

                    Db::commit();//成功提交事务
                }
            }
            $return = Db::name('user u')->field('u.user_id,u.token,u.recode,u.avatar,u.userthumb,u.nickname,u.username,u.`level`,c.subscribe')
                    ->join('jay_user_connect c', 'c.user_id = u.user_id', 'left')->where(['u.user_id'=>$Uid])->find();

            if ($return["userthumb"]){
                $return["avatar"] = $return["userthumb"];
                unset($return["userthumb"]);
            }
            if ($return["username"]){
                $return["nickname"] = $return["username"];
                unset($return["username"]);
            }

            $this->returnApiData('授权成功', 200, $return);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * 用户关注
     */
    public function checkUserSubscribe(){
        $Token = input("post.token","","htmlspecialchars,strip_tags");
        $Punfu = new PubfunController();

        $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
        $Data = Db::name('user u')
            ->join('user_connect c','u.user_id=c.user_id')
            ->field('u.user_id,c.subscribe,c.openid')
            ->where(array('u.token'=>$Token,'c.platform'=>'wechat','c.subscribe'=>0))
            ->find();

        //验证是否关注
        if($Data){
            $accessToken =  Db::name('access_token')->value('access_token');
            $suburl = "https://api.weixin.qq.com/cgi-bin/user/info?access_token=".$accessToken."&openid=".$Data["openid"]."&lang=zh_CN";
            $hasSubsribe = json_decode(curlGet($suburl), true);
            $rs = Db::name('user_connect')->where(['user_id'=>$Data['user_id'], 'platform'=>'wechat'])->update(['subscribe'=>$hasSubsribe['subscribe']]);
            if($rs){
                $this->returnApiData('已关注', 200);
            }else{
                $this->returnApiData('未关注', 400);
            }
        }else{
            $this->returnApiData('已关注', 200);
        }
    }

    /**
     * 第三方微信登陆
     * 肖亚子
     */
    public function WechatThirdParty(){
        try{
            $Wechat  = input("post.wechat");//第三方微信登陆信息
            $Wechat  = json_decode($Wechat,true);

            if($this->headerData["product"] != "app"){
                $this->returnApiData('登录失败', 400);
            }

            $hasUser = Db::name('user_connect')->where(['union_id'=>$Wechat["unionid"],"platform" => "wxapp"])->find();

            if (!$hasUser){
                $hasUser = Db::name('user_connect')->where(['union_id'=>$Wechat["unionid"],"platform" => "wechat"])->find();
            }

            Db::startTrans();//开启事务
            $Expire = time();

            if(!$hasUser){
                $UserData["token"]        = Md5Help::getToken($Wechat["openid"]);
                $UserData["nickname"]     = self::FilterEmoji($Wechat["nickname"]);
                $UserData["avatar"]       = $Wechat["headimgurl"];
                $UserData["level"]        = 1;
                $UserData["status"]       = 1;
                $UserData["wxgpsaddr"]    = $Wechat["country"].$Wechat["province"].$Wechat["city"];
                $UserData["reg_time"]     = time();
                $UserData["upgrade_time"] = time();
                $Uid = UserModel::UserAdd($UserData);
                if (!$Uid){
                    Db::rollback();//失败回滚exit;
                    $this->returnApiData('登录失败', 400);
                }
            }else{
                $Uid = $hasUser['user_id'];

                $UserData["nickname"] = $Wechat["nickname"];
                $UserData["avatar"]   = $Wechat["headimgurl"];
                $UserData["up_time"]  = time();

                UserModel::UserUpdate(array("user_id" => $Uid),$UserData);
            }

            //关联第三方账号
            $ConnectData["openid"]              = $Wechat["openid"];
            $ConnectData["user_id"]             = $Uid;
            $ConnectData["platform"]            = "wxapp";
            $ConnectData["union_id"]            = $Wechat["unionid"];
            $ConnectData["accesstoken"]         = $Wechat["access_token"];
            $ConnectData["refresh_token"]       = $Wechat["refresh_token"];
            $ConnectData["accesstoken_expired"] = parent::Tpl_Time($Expire,7,2);//过期时间当前时间2小时
            $ConnectData["data"]                = json_encode($Wechat);
            $ConnectData["addtime"]             = $Expire;

            if(!$hasUser){
                $Connect = UserModel::UserConnectAdd($ConnectData);
            }else{
                if ($hasUser["platform"] == "wxapp"){
                    $Condition["user_id"]  = array("eq",$Uid);
                    $Condition["platform"] = array("eq","wxapp");

                    $Connect = UserModel::UserConnectUpdate($Condition,$ConnectData);
                }else{
                    $Connect = UserModel::UserConnectAdd($ConnectData);
                }
            }

            if (!$Connect){
                Db::rollback();//失败回滚exit;
                $this->returnApiData('登录失败', 400);
            }

            Db::commit();//成功提交事务

            $UserData = UserModel::UserDataFind(array("u.user_id"=>array("eq",$Uid)),"u.token,u.recode,u.nickname,u.username,u.avatar,u.userthumb,u.level,u.auth");

            $UserCondition["user_id"]   = $Uid;
            $UserCondition["subscribe"] = 1;

            $Subscribe = UserModel::UserConnectFind($UserCondition);

            if ($Subscribe){
                $UserData["subscribe"] = 1;
            }else{
                $UserData["subscribe"] = 0;
            }

            switch ($UserData["level"]){
                case 1:$UserData["username"] = "普通用户"; break;
                case 2:$UserData["username"] = "超级会员"; break;
                case 3:$UserData["username"] = "分享达人"; break;
                case 4:$UserData["username"] = "运营达人"; break;
                case 5:$UserData["username"] = "玩主"; break;
            }
            if ($UserData["userthumb"]){
                $UserData["avatar"] = $UserData["userthumb"];
                unset($UserData["userthumb"]);
            }
            if ($UserData["username"]){
                $UserData["nickname"] = $UserData["username"];
                unset($UserData["username"]);
            }

            $this->returnApiData("获取成功", 200,$UserData);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }

    /**
     * @param $Str  用户昵称
     * @return null|string|string[]
     * 去掉微信昵称特殊符号
     * 肖亚子
     */
    private function FilterEmoji($Str)
    {
        $Str = preg_replace_callback( '/./u',
            function (array $Match) {
                return strlen($Match[0]) >= 4 ? '' : $Match[0];
            },
            $Str);
        return $Str;
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


    /**
     * 判断token是否有效
     */
    public function hasToken(){
        $token = $this->post('token', '');
        $count = Db::name('user')->where(['token'=>$token])->count();
        $this->returnApiData('查询成功', 200, ['count'=>$count]);
    }

}

