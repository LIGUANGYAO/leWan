<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/19
 * Time: 17:00
 */

namespace app\system\controller;

use think\Request;
use think\Db;
use app\common\AdminBaseController;
use app\system\model\UserwithdrawModel;

class UserwithdrawController extends AdminBaseController{


    public function CashList(){
        $Condition = array();//定义查询条件默认空

        $Status    = $this->get("status",0);//审核状态默认待审核
        $Psize     = $this->get("page",1);//当前分页页数默认第一页
        $Title     = $this->get("title");//搜索栏数据
        $StartTime = strtotime($this->get("starttime"));//提现开始时间
        $EndTime   = strtotime($this->get("endtime"));//提现结束时间

        $Condition["w.withdraw_status"] = array("eq",$Status);

        if ($Title){
            $Condition["u.mobile|u.nickname"] = array("like","%$Title%");
        }

        $Condition = self::TimeContrast($StartTime,$EndTime,"w.withdraw_addtime",$Condition);

        $DataList = UserwithdrawModel::UserCashList($Condition,$Psize,50);

        $Number["stay"]    = UserwithdrawModel::UserCashCount(array("withdraw_status"=>0));
        $Number["rebut"]   = UserwithdrawModel::UserCashCount(array("withdraw_status"=>1));
        $Number["adopt"]   = UserwithdrawModel::UserCashCount(array("withdraw_status"=>2));
        $Number["queue"]   = UserwithdrawModel::UserCashCount(array("withdraw_status"=>3));
        $Number["success"] = UserwithdrawModel::UserCashCount(array("withdraw_status"=>6));
        $Number["fail"]    = UserwithdrawModel::UserCashCount(array("withdraw_status"=>7));

        $Query     = array("title" => $Title);
        $Query     = self::Time($StartTime,"starttime",$Query);
        $Query     = self::Time($EndTime,"endtime",$Query);

        $this->assign("status",$Status);
        $this->assign("query",$Query);
        $this->assign("data",$DataList);
        $this->assign("number",$Number);

        return $this->display('list', true);
    }

    public function CashData(){
        $Condition = array();

        if(Request()->isGet()){
            $Id     = $this->get("id");
            $Status = $this->get("status",0);

            $this->assign("id",$Id);
            $this->assign("status",$Status);

            return $this->display('cashdata', false);
        }else{
            $Id     = $this->post("id");
            $Status = $this->post("status");
            $Remark = $this->post("remark");

            parent::Tpl_NoSpaces($Status,"请选择提现流程");

            if ($Status == 1 || $Status == 7){
                parent::Tpl_NoSpaces($Remark,"请填写失败原因");
                parent::Tpl_StringLength($Remark,"失败原因10-40字",3,10,40);

                $Data["withdraw_reason"] = $Remark;
            }

            if ($Status == 6){
                $Data["withdraw_code"] = "success";
            }elseif ($Status == 1 || $Status == 7){
                $Data["withdraw_code"] = "fail";
            }

            $Condition["withdraw_id"] = array("eq",$Id);

            $Data["withdraw_status"]  = $Status;
            $Data["withdraw_uptime"]  = time();

            $Cash  =  UserwithdrawModel::TableName();
            $Cash->startTrans();//开启事务

            $CachUp = UserwithdrawModel::UserCashUpdate($Condition,$Data);

            switch ($Status){
                case 1:$Change = "提现驳回";break;
                case 2:$Change = "审核通过";break;
                case 3:$Change = "进入提现队列";break;
                case 6:$Change = "提现成功";break;
                case 7:$Change = "提现失败";break;
            }

            if ($CachUp) {

                 if ($Status == 1 || $Status == 7){
                    $DataFind =  UserwithdrawModel::UserCashFind($Condition);

                    $AcData["account_cash_balance"] =  array("exp","account_cash_balance+".$DataFind["withdraw_amount"]);

                    $AcUp =  UserwithdrawModel::UserAcUpdate(array("user_id"=>$DataFind["user_id"]),$AcData);

                    if($AcUp){
                        $Cash->commit();//成功提交事务
                        $this->log("用户提现失败：[ID:".$Id."提现流程更改为".$Change."退回金额".$DataFind["withdraw_amount"]."]");
                    }else{
                        $Cash->rollback();//失败回滚exit;
                        $this->toError("用户提现失败");
                    }
                 }elseif ($Status == 6){
                     $DataFind =  UserwithdrawModel::UserCashFind($Condition);
                     $AcData["account_cash_expenditure"] =  array("exp","account_cash_expenditure+".$DataFind["withdraw_amount"]);

                     $AcUp =  UserwithdrawModel::UserAcUpdate(array("user_id"=>$DataFind["user_id"]),$AcData);

                     if($AcUp){
                         $Cash->commit();//成功提交事务
                         $this->log("用户提现成功：[ID:".$Id."提现流程更改为".$Change."支出总额加".$DataFind["withdraw_amount"]."]");
                     }else{
                         $Cash->rollback();//失败回滚exit;
                         $this->toError("用户提现失败");
                     }
                 }

                $Cash->commit();//成功提交事务
                $this->log("用户提现：[ID:".$Id."提现流程更改为".$Change."]");
                $this->toSuccess("用户提现流程更改成功", '', 2);
            }else{
                $Cash->rollback();//失败回滚exit;
                $this->toError("用户提现失败");
            }

        }
    }

    /**
     * @param $StartTime  开始时间
     * @param $EndTime    结束时间
     * @param $Key        字段
     * @param $Condition  返回组合
     * @return mixed
     */
    public  function TimeContrast($StartTime,$EndTime,$Key,$Condition){

        if (!empty($StartTime) && empty($EndTime)) {
            parent::Tpl_NotGtTime($StartTime,"开始时间不能大于当前时间"); //开始时间不为空和当前时间对比
            $Condition[$Key] = array(array('egt', $StartTime));
        } else if (empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_NotGtTime($EndTime,"结束时间不能大于当前时间"); //结束时间不为空和当前时间对比
            $Condition[$Key] = array(array('lt', $EndTime));
        } else if (!empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_TimeContrast1($StartTime,$EndTime); //开始和结束时间都不为空进行判断
            $Condition[$Key] = array(array('egt', $StartTime), array('elt', $EndTime));
        }

        return $Condition;
    }

    /**
     * @param $Time  转换时间
     * @param $Key   返回字段
     * @param $Query 组合数组
     * @return mixed
     */
    public function Time($Time,$Key,$Query){
        if(!empty($Time)){
            $Query[$Key] = date("Y-m-d H:i:s",$Time);
        }

        return $Query;
    }
}