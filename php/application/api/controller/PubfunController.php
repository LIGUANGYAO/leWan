<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/3
 * Time: 14:18
 */

namespace app\api\controller;
use app\api\model\HelpModel;
use app\api\model\UserModel;
use app\api\model\UsercommunityleaderModel;
use app\api\controller\ApiBaseController;
use think\Db;

class PubfunController extends ApiBaseController{

    /**
     * @param $Token     用户token
     * @param $Header    header头
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 用户判断
     * 肖亚子
     */
    public function UserLoginStatus($Token,$Header){

        $Condition["u.token"] = array("eq",$Token);

        $Finde = "u.user_id,u.status";

        $UserProving = UserModel::UserDataFind($Condition,$Finde);
        $Uid = $UserProving["user_id"];

        if (!$UserProving){
            self::returnApiData("账号不存在,请重新登录", 400);
        }
        if ($UserProving["status"] != 1){
            self::returnApiData("账号已被禁止", 400);
        }

        UserModel::UserUpdateTime($Uid);

        if ($Header["product"] == "wechat"){
            $Time = time();

            $UCondition["user_id"]  = array("eq",$Uid);
            $UCondition["platform"] = array("eq","wechat");

            $UserCon = UserModel::UserConnectFind(array("user_id"=>array("eq",$Uid)));

            if ($Time >= $UserCon["accesstoken_expired"]){//微信授权过期默认获取
                $RenewCondition["user_id"] = array("eq",$Uid);
                $RenewCondition["platform"] = 'wechat';

                $BaseAccesstoken = HelpModel::getAccessToken();

                $BaseDetails     = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=".WX_APPID."&grant_type=refresh_token&refresh_token=".$UserProving['refresh_token'];
                $BaseDetails     = json_decode(curlGet($BaseDetails),true);

                $ConnectData["accesstoken"]             = $BaseAccesstoken["access_token"];
                $ConnectData["refresh_token"]           = $BaseAccesstoken["refresh_token"];
                $ConnectData["accesstoken_expired"]     = parent::Tpl_Time($Time,7,2);//过期时间当前时间2小时
                $ConnectData["addtime"]                 = $Time;
                $ConnectUp = UserModel::UserConnectUpdate($RenewCondition,$ConnectData);

            }
        }

    }

    /**
     * @param array $Condition 查询条件
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取用户信息
     * 肖亚子
     */
    public static function UserInfo($Condition = array()){

        $Fied = "u.user_id,u.token,u.recode,u.nickname,u.username,u.avatar,u.userthumb,u.level,u.auth,u.ownerstatus";

        $UserData  = UserModel::UserDataFind($Condition,$Fied);
        $ApplyFind = UsercommunityleaderModel::LeaderFind(array("a.user_id"=>$UserData["user_id"]),"a.status");

        $UserCondition["user_id"]   = $UserData["user_id"];
        $UserCondition["subscribe"] = 1;

        $Subscribe = UserModel::UserConnectFind($UserCondition);

        if ($Subscribe){
            $UserData["subscribe"] = 1;
        }else{
            $UserData["subscribe"] = 0;
        }

        if ($UserData["userthumb"]){
            $UserData["avatar"] = $UserData["userthumb"];
            unset($UserData["userthumb"]);
        }else{
            unset($UserData["userthumb"]);
        }
        if ($UserData["username"]){
            $UserData["nickname"] = $UserData["username"];
        }

        switch ($UserData["level"]){
            case 1:$UserData["username"] = "普通用户"; break;
            case 2:$UserData["username"] = "超级会员"; break;
            case 3:$UserData["username"] = "分享达人"; break;
            case 4:$UserData["username"] = "运营达人"; break;
            case 5:$UserData["username"] = "玩主"; break;
        }
        if (empty($ApplyFind)){
            $UserData["applystatus"] = 3;
        }else{
            $UserData["applystatus"] = $ApplyFind["status"];
        }

        unset($UserData["user_id"]);

        return $UserData;
    }

    /**
     * @param $Token    用户token
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 验证用户权限
     * 肖亚子
     */
    public function UserLevelPower($Token){
        $Condition["u.token"] = array("eq",$Token);

        $Level = UserModel::UserDataFind($Condition,"u.level");

        if ($Level["level"] <= 1){
            self::returnApiData("账号权限不足", 400);
        }
    }

    /**
     * @param $Token  用户token
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 验证用户是否进行实名认证
     * 肖亚子
     */
    public function UserRealName($Token){
        $Condition["u.token"] = array("eq",$Token);

        $UserProving = UserModel::UserDataFind($Condition,"u.user_id,u.auth");

        if ($UserProving["auth"] == 1){
            self::returnApiData("请进行实名认证", 400);
        }
    }

    /**
     * @param $Phone        手机号
     * @param $ProvingCode  验证码
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 验证短信验证码是否正确
     * 肖亚子
     */
    public function PhoneVerification($Phone,$ProvingCode){
        $Condition["mobile"] = array("eq",$Phone);
        $Condition["status"] = array("eq",1);

        $PhoneData = Db::name("phonecode")->field("id,code,addtime")->where($Condition)->find();

        if ($PhoneData){
            $Addtime = strtotime("+10 minutes", $PhoneData["addtime"]);
            $Time    = time();

            if ($Time >= $Addtime){
                Db::name("phonecode")->delete(array("id"=>array("eq",$PhoneData["id"])));
                self::returnApiData("验证码已过期,请重新获取", 400);
            }else{
                if ($ProvingCode == $PhoneData["code"]){
                    Db::name("phonecode")->delete(array("id"=>array("eq",$PhoneData["id"])));
                }else{
                    self::returnApiData("验证码错误,请重新输入", 400);
                }
            }

        }else{
            self::returnApiData("请输入正确的验证码", 400);
        }
    }

}