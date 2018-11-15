<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/3
 * Time: 13:58
 * 用户接口
 * 肖亚子
 */

namespace app\api\controller;
use app\api\model\OrderModel;
use app\api\model\UserModel;
use Think\Exception;
use app\api\model\HelpModel;
use app\api\model\UserUpgradeModel;
use app\api\model\UserauthModel;

class UserController extends ApiBaseController{
    /**
     * 用户注册
     */
    public function UserRegister(){
        try{
            $Token       = input("post.token","","htmlspecialchars,strip_tags");
            $Recode      = input("post.recode","","htmlspecialchars,strip_tags");//推荐码
            $Mobile      = input("post.mobile","","htmlspecialchars,strip_tags");//注册电话
            $ProvingCode = input("post.provingcode","","htmlspecialchars,strip_tags");//验证码

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->PhoneVerification($Mobile,$ProvingCode);

            parent::Tpl_Empty($Recode,"请输入推荐码",2);
            parent::Tpl_FullSpace($Recode,"请输入推荐码",2);
            parent::Tpl_NoSpaces($Recode,"请输入正确的推荐码",2);
            parent::Tpl_Alphanumeric($Recode,"请输入正确的推荐码",2);
            parent::Tpl_Lengths($Recode,"推荐码正确长度为8位",8,8,2);
            parent::Tpl_Empty($Mobile,"请输入手机号",2);
            parent::Tpl_FullSpace($Mobile,"请输入正确的手机号",2);
            parent::Tpl_Phone($Mobile,"请输入正确的手机号码",2);
            parent::Tpl_Empty($ProvingCode,"请输入验证码",2);
            parent::Tpl_FullSpace($ProvingCode,"请输入正确的验证码",2);
            parent::Tpl_Lengths($ProvingCode,"验证码为6位",6,6,2);

            $UserEnroll = UserModel::UserDataFind(array("u.token"=>array("eq",$Token)),"u.user_id,u.level");

            if ($UserEnroll){
                if ($UserEnroll["level"] > 1){
                    $this->returnApiData("您已经注册,请勿重复", 400);
                }
            }else{
                $this->returnApiData("请先授权", 400);
            }

            $Referee = UserModel::UserDataFind(array("u.recode"=>array("eq",$Recode)),"u.user_id,u.path,u.floor");

            if ($Referee){
                $Data["reid"]  = $Referee["user_id"];
                $Data["path"]  = $Referee["path"].$Referee["user_id"].",";
                $Data["floor"] = $Referee["floor"] + 1;
                $Data["floor"] = 1;
            }else{
                $this->returnApiData("推荐人不存在", 400);
            }

            $Locus = self::UserMobileArea($Mobile);
            $User  = UserModel::UserDataFind(array("u.mobile"=>array("eq",$Mobile)),"u.user_id");
            if ($User){
                $this->returnApiData("该手机号已被注册,请重新输入", 400);
            }
            $Random = Func_Random(6);

            $Data["recode"]     = HelpModel::makeUserCode();
            $Data["mobile"]     = $Mobile;
            $Data["password"]   = func_user_hash(substr($Mobile,-8),$Random);
            $Data["dllkey"]     = $Random;
            $Data["level"]      = 2;
            $Data["mobileaddr"] = $Locus["prov"]."/".$Locus["city"]."/".$Locus["type"];

            $Condition["token"] = array("eq",$Token);

            $UserData = UserModel::UserUpdate($Condition,$Data);

            if ($UserData){
                UserUpgradeModel::check($User["user_id"],1);//用户升级检测
                $this->returnApiData("注册成功", 200);
            }else{
                $this->returnApiData("注册失败", 400);
            }

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * 注册用户个人信息
     * 肖亚子
     */
    public function UserPersonal(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            //获取我的好友

            $UserData = UserModel::UserDataFind(array("u.token"=>array("eq",$Token)),"u.token,u.recode,u.nickname,u.avatar,u.level,u.auth");

            switch ($UserData["level"]){
                case 1:$UserData["username"] = "普通用户"; break;
                case 2:$UserData["username"] = "超级会员"; break;
                case 3:$UserData["username"] = "分享达人"; break;
                case 4:$UserData["username"] = "运营达人"; break;
                case 5:$UserData["username"] = "玩主"; break;
            }

            $this->returnApiData("获取成功", 200,$UserData);
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
     * 获取注册用户我的好友
     * 肖亚子
     */
    public function UserFriends(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);//用户权限验证

            //获取我的好友
            $Time   = strtotime(date("Y-m-d",time()));
            $Fecode = UserModel::UserDataFind(array("u.token"=>array("eq",$Token)),"u.user_id,u.recode,u.floor,u.level");
            $Uid    = $Fecode["user_id"];

            $C_Condition["sid"]      = array("eq",$Uid);
            $C_Condition["reg_time"] = array("gt",$Time);
            $D_Condition["reid"]     = array("eq",$Uid);
            $D_Condition["reg_time"] = array("gt",$Time);
            $D_Condition[]           = array("exp","(level = 2 or level = 3)");

            if (in_array($Fecode["level"],array(2,3))){//超级达人/营销达人 全部好友 查推荐的下两级用户
                $WholeCondition[] = array("exp","FIND_IN_SET({$Uid},path) and (level = 2 or level = 3) ");
                $NewCondition[]   = array("exp","FIND_IN_SET({$Uid},path) and (level = 2 or level = 3) and reg_time > {$Time}");
            }elseif($Fecode["level"] > 3){//运营达人/玩主查看全部的推荐用户
                $WholeCondition[] = array("exp","FIND_IN_SET({$Uid},path) ");
                $NewCondition[]   = array("exp","FIND_IN_SET({$Uid},path) and reg_time > {$Time}");
            }

            $Customer    = UserModel::UserCount(array("sid"=>array("eq",$Uid)));//获取客户人数
            $NewCustomer = UserModel::UserCount($C_Condition);//获取最新客户人数
            $Directly    = UserModel::UserCount(array("reid"=>array("eq",$Uid),"level"=>array("elt",3)));//获取直属好友人数并且没独立出去
            $NewDirectly = UserModel::UserCount($D_Condition);//获取最新直属好友人数
            $Whole       = UserModel::UserCount($WholeCondition);//获取全部好友人数
            $NewWhole    = UserModel::UserCount($NewCondition);//获取最新全部好友人数

            $UseFriendsr["customer"]    = $Customer;
            $UseFriendsr["newcustomer"] = $NewCustomer;
            $UseFriendsr["directly"]    = $Directly;
            $UseFriendsr["newdirectly"] = $NewDirectly;
            $UseFriendsr["whole"]       = $Whole;
            $UseFriendsr["newwhole"]    = $NewWhole;

            $this->returnApiData("获取成功", 200,$UseFriendsr);
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
     * 获取注册用户钱包
     * 肖亚子
     */
    public function UserWallet(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);//用户权限验证

            $Uid = UserModel::UserFindUid($Token);

            $UserData = array();

            //获取我的钱包
            $AccCondition["user_id"]     = array("eq",$Uid);
            $AccCondition["account_tag"] = array("eq",0);
            $AcfCondition["user_id"]     = array("eq",$Uid);
            $AcfCondition["finance_tag"] = array("eq",0);

            $Acc = UserModel::UserAccount($AccCondition,"account_cash_balance,account_commission_balance");
            $Acf = UserModel::UserAccountFinance($AcfCondition,"finance_withdraw,finance_first,finance_second,finance_operations,finance_operationchilds,finance_playerhost");

            if ($Acf){
                $Sumup = $Acf["finance_first"]+$Acf["finance_second"]+$Acf["finance_operations"]+$Acf["finance_operationchilds"]+$Acf["finance_playerhost"] ;
            }else{
                $Sumup = 0;
            }

            $UserReward["putforward"] = $Acc?$Acc["account_cash_balance"]:0;
            $UserReward["pending"]    = $Acc?$Acc["account_commission_balance"]:0;
            $UserReward["grandtotal"] = $Acf?$Acf["finance_withdraw"]:0;
            $UserReward["sumup"]      = $Sumup;

            $UserData["reward"] = $UserReward;

            //获取收入指南
            $TodayTime     = strtotime(date("Ymd",time()));
            $YesterdayTime = strtotime(date("Ymd",strtotime("-1 day",time())));

            $TodayCondition["user_id"]         = array("eq",$Uid);
            $TodayCondition["account_tag"]     = array("eq",date("Ymd",time()));
            $YesterdayCondition["user_id"]     = array("eq",$Uid);
            $YesterdayCondition[]              = array("exp","record_action=802 or record_action=803 and  record_addtime > {$YesterdayTime} and record_addtime < {$TodayTime}");
            $ThismonthCondition["user_id"]     = array("eq",$Uid);
            $ThismonthCondition["account_tag"] = array("eq",date("Ym",time()));
            $LastmonthCondition["user_id"]     = array("eq",$Uid);
            $LastmonthCondition["finance_tag"] = array("eq",date("Ym",time()));

            $Today     = UserModel::UserAccount($TodayCondition,"account_commission_balance");//今日待结算
            $Yesterday = UserModel::UserAccountCash($YesterdayCondition,date("Ym",time()),"record_amount as mount");//昨日已结算
            $Thismonth = UserModel::UserAccount($ThismonthCondition,"account_commission_balance");//本月待结算
            $Lastmonth = UserModel::UserFinance($LastmonthCondition,"finance_settle");

           // $this->returnApiData("获取成功", 200,$Acc["finance_withdraw"]);
            $Income["today"]     = $Today?$Today["account_commission_balance"]:0;
            $Income["yesterday"] = $Yesterday?$Yesterday["mount"]:0;
            $Income["thismonth"] = $Thismonth?$Thismonth["account_commission_balance"]:0;
            $Income["lastmonth"] = $Lastmonth?$Lastmonth["finance_settle"]:0;

            $UserData["income"] = $Income;

            $this->returnApiData("获取成功", 200,$UserData);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * 获取推荐码用户详细
     * 肖亚子
     */
    public function UserReferee(){
        try{
            $Recode = input("post.recode","","htmlspecialchars,strip_tags");//用户推荐码

            parent::Tpl_Empty($Recode,"请输入推荐码",2);
            parent::Tpl_FullSpace($Recode,"请输入推荐码",2);
            parent::Tpl_NoSpaces($Recode,"请输入正确的推荐码",2);
            parent::Tpl_Alphanumeric($Recode,"请输入正确的推荐码",2);
            parent::Tpl_Lengths($Recode,"推荐码正确长度为8位",8,8,2);

            $Condition["u.recode"] = array("eq",$Recode);

            $Referee = UserModel::UserDataFind($Condition,"u.nickname,u.avatar");

            if (!$Referee){
                $this->returnApiData("推荐人不存在", 400);
            }

            $this->returnApiData("获取成功", 200,$Referee);
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
     * 获取用户邀请注册二维码
     * 肖亚子
     */
    public function UserInviteQRCode(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Type  = intval(input("post.type"));
            $Url   = input("post.url","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);//用户权限验证
           // $Punfu->UserRealName($Token);//验证用户是否实名认证

            if (!in_array($Type,array(1,2,3,4,5,6,7,8))){
                $this->returnApiData("请选择邀请函背景", 400);
            }

            $Uid      = UserModel::UserFindUid($Token);
            $User     = UserModel::UserFinds($Token);
            $TrueName = UserauthModel::UserAuthFind($Uid);

            $Data["url"]         = $Url."?recode={$User['recode']}";
            $Data["truename"]    = $TrueName;
            $Data["Picturename"] = $User["recode"];
            $Data["type"]        = $Type;

            $Invitation = QrCode($Data,2);//生成邀请海报

            $this->returnApiData("获取成功", 200,array("url"=>$Invitation));
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @param $Mobile   手机号
     * @return mixed
     * 获取用户手机号归属
     * 肖亚子
     */
    private function UserMobileArea($Mobile){
        $MobileUrl = "https://sp0.baidu.com/8aQDcjqpAAV3otqbppnN2DJv/api.php?query={$Mobile}&resource_id=6004&ie=utf8&oe=utf8&format=json";
        $MobileUrl = json_decode(curlGet($MobileUrl),true);

        if (!$MobileUrl){
            $this->returnApiData("请输入正确的手机号", 400);
        }else{
            $Locus = $MobileUrl["data"][0];
            return $Locus;
           // $Data["mobileaddr"] = $Locus["prov"]."/".$Locus["city"]."/".$Locus["type"];
        }
    }


    /**
     *  获取注册用户我的好友列表
     * author@yihong
     */
    public function UserFriendsList(){
        try{
            $Token  = input("post.token","","htmlspecialchars,strip_tags");
            $Status = intval(input("post.type",1));//状态 1全部好友，2 我的客户 ，3直属好友
            $Page   = intval(input("post.page",1));//分页默认第一页
            $Psize  = intval(input("post.psize",10));//分页条数默认10条
            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);//用户权限验证
            //获取我的好友
            $Fecode = UserModel::UserDataFind(array("u.token"=>array("eq",$Token)),"u.user_id,u.recode,u.floor,u.level");
            $Uid    = $Fecode["user_id"];
            if($Status == UserModel::ALL_USER_FRIEND){ //全部好友
                if (in_array($Fecode["level"],array(2,3))){//超级达人/营销达人 全部好友 查推荐的下两级用户
                    $Where[] = array("exp","FIND_IN_SET({$Uid},path) and (level = 2 or level = 3) ");
                }elseif($Fecode["level"] > 3){//运营达人/玩主查看全部的推荐用户
                    $Where[] = array("exp","FIND_IN_SET({$Uid},path) ");
                }
            }elseif ($Status == UserModel::USER_CUSTOMER){ //我的客户
                $Where = array("sid"=>array("eq",$Uid));
            }else{ //我的直属好友
                $Where = array("reid"=>array("eq",$Uid),"level"=>array("elt",3));
            }
            $Filed = "user_id,nickname,avatar,level";
            $List    = UserModel::getUserFriendList($Where,$Filed, $Page,$Psize);//获取我的好友
            $Count    = UserModel::UserCount($Where);//获取我的好友
            $this->returnApiData("获取成功", 200,array('list'=>$List,'count'=>$Count));
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }


    /**
     *  获取注册用户我的订单
     * author@yihong
     */
    public function UserOrderList(){
        try{
            $Token  = input("post.token","","htmlspecialchars,strip_tags");
            $Page   = intval(input("post.page",1));//分页默认第一页
            $Psize  = intval(input("post.psize",10));//分页条数默认10条
            $Status = intval(input("post.status",''));//订单状态
            $Punfu  = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);//用户权限验证
            $Userid = UserModel::UserFindUid($Token);
            $Condition["o.user_id"] = $Userid;
            if ($Status){
                $Condition["o.order_status"] = $Status;
            }

            $OrderList = OrderModel::OrderList($Condition,$Page,$Psize);
            $this->returnApiData("获取成功", 200,$OrderList);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }


    /**
     *  获取注册用户我的订单->订单详情
     * author@yihong
     */
    public function UserOrderInfo(){
        try{
            $Token   = input("post.token","","htmlspecialchars,strip_tags");
            $Orderid = intval(input("post.order_id",0));//订单ID
            $Punfu   = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);//用户权限验证
            $OrderInfo = OrderModel::getOrderInfoByOrderId($Orderid);
            if($OrderInfo){
                $this->returnApiData("获取成功", 200,$OrderInfo);
            }else{
                $this->returnApiData("订单不存在", 400);
            }
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }



}