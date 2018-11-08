<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/7
 * Time: 15:39
 * 用户提现接口
 * 肖亚子
 */

namespace app\api\controller;
use Think\Exception;
use app\api\model\UserModel;
use app\api\model\UserwithdrawModel;
use app\api\model\UserbankModel;

class UserwithdrawController extends ApiBaseController{

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取提现列表
     * 肖亚子
     */
    public function UserwithdrawAll(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Page  = intval(input("post.page","1"));

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);  //权限验证

            $Uid = UserModel::UserFindUid($Token);
            $Condition["user_id"] = array("eq",$Uid);

            $List = UserwithdrawModel::WithdrawList($Condition,$Page,20);

            $this->returnApiData("获取成功", 200,$List);
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
     * 用户提现获取余额
     * 肖亚子
     */
    public function UserCashBalance(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);  //权限验证

            $Uid = UserModel::UserFindUid($Token);
            $Condition["user_id"]     = array("eq",$Uid);
            $Condition["account_tag"] = array("eq",0);

            $Multiple = UserwithdrawModel::ParameterFind(array("key"=>array("eq","tixian_bei")));
            $MoneyMin = UserwithdrawModel::ParameterFind(array("key"=>array("eq","tixian_min")));

            $CashBalance = UserModel::UserAccount($Condition,"account_cash_balance as cashbalance");

            $Data["cashbalance"] = $CashBalance["cashbalance"];
            $Data["multiple"]    = $Multiple;
            $Data["moneymin"]    = $MoneyMin;

            $this->returnApiData("获取成功", 200,$CashBalance);
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
     * 用户提现申请
     * 肖亚子
     */
    public function UserApplicationForCash(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Type  = intval(input("post.type","1"));
            $Ubid  = intval(input("post.ub_id"));
            $Money = input("post.money","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);  //权限验证

            if (!in_array($Type,array(1,2,3))){
                $this->returnApiData("请选择收钱方式", 400);
            }

            parent::Tpl_Empty($Money,"请输入提现金额",2);
            parent::Tpl_FullSpace($Money,"请输入提现金额",2);
            parent::Tpl_Money($Money,"请输入正确的提现金额格式",2);

            $Uid = UserModel::UserFindUid($Token);

            if ($Type == 2){
                $UbCondition["user_id"] = array("eq",$Uid);
                $UbCondition["ub_id"] = array("eq",$Ubid);

                $Bank = UserbankModel::UserBankFind($UbCondition);

                if (!$Bank){
                    $this->returnApiData("请选择你的提现银行卡", 400);
                }
            }

            $Condition["user_id"]     = array("eq",$Uid);
            $Condition["account_tag"] = array("eq",0);

            $Multiple = UserwithdrawModel::ParameterFind(array("key"=>array("eq","tixian_bei")));
            $MoneyMin = UserwithdrawModel::ParameterFind(array("key"=>array("eq","tixian_min")));

            if ($Money < $MoneyMin){
                $this->returnApiData("提现最少{$MoneyMin}元", 400);
            }
            if ($Money%$Multiple==0){
                $this->returnApiData("提现至少是{$Multiple}的倍数", 400);
            }

            $CashBalance = UserModel::UserAccount($Condition,"account_cash_balance as cashbalance");

            if ($CashBalance["cashbalance"] < $Money){
                $this->returnApiData("你的金额不足进行提现", 400);
            }

            if ($Type == 1){
                $KeyCondition["key"] = array("eq","taxfee_wxtixian");
            }elseif ($Type == 2){
                $KeyCondition["key"] = array("eq","taxfee_banktixian");
            }elseif ($Type == 3){
                $KeyCondition["key"] = array("eq","taxfee_alitixian");
            }

            $Cash  = UserwithdrawModel::TableName();
            $Cash->startTrans();//开启事务

            $Procedures = UserwithdrawModel::ParameterFind(array("key"=>array("eq","taxfee_alitixian")));

            $AcData["account_cash_balance"] = array("exp","account_cash_balance - ".$Money);

            $AcUp = UserwithdrawModel::UserAccountUpdate($Condition,$AcData);

            if (!$AcUp){
                $Cash->rollback();
                $this->returnApiData("提现申请失败", 400);
            }

            if ($Procedures){
                $Brokerage = number_format($Money*($Procedures/100),2);
                $Brokerage = $Money - $Brokerage;
            }else{
                $Brokerage = 0;
                $Actual    = $Money;
            }

            $Withdraw["user_id"]             = $Uid;
            $Withdraw["ub_id"]               = $Ubid;
            $Withdraw["withdraw_amount"]     = $Money;
            $Withdraw["withdraw_handfee"]    = $Brokerage;
            $Withdraw["withdraw_realamount"] = $Actual;
            $Withdraw["withdraw_type"]       = $Type;
            $Withdraw["withdraw_balance"]    = $CashBalance["cashbalance"] - $Money;
            $Withdraw["withdraw_status"]     = 0;
            $Withdraw["withdraw_addtime"]    = time();

            $Data = UserwithdrawModel::WithdrawAdd($Withdraw);

            if ($Data){
                $Cash->commit();//成功提交事务
                $this->returnApiData("提现申请成功", 200);
            }else{
                $Cash->rollback();
                $this->returnApiData("提现申请失败", 400);
            }

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }
}