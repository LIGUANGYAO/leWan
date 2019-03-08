<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/2/26
 * Time: 13:51
 * 小区盟主管理
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\UserownerapplyModel;
use app\system\model\UserModel;
use think\Request;
use think\Config;

class UserownerapplyController extends AdminBaseController{
    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取盟主数据列表
     * 肖亚子
     */
    public function UserOwnerApplyList(){
        $Page      = $this->get("page", 1);
        $Type      = $this->get("type",0);
        $Title     = $this->get("title","");
        $Status    = $this->get("ownerstatus","");
        $Tst       = strtotime($this->get("trialstarttime"));//审核开始时间
        $Tet       = strtotime($this->get("trialendtime"));//审核结束时间
        $StartTime = strtotime($this->get("starttime"));//申请开始时间
        $EndTime   = strtotime($this->get("endtime"));//申请结束时间

        $Condition = array();
        $Condition["a.status"] = $Type;

        if ($Title){
            $Condition["a.realname|a.phone|u.nickname|u.username|c.community_name|r.fullname"] = array("like","%$Title%");
        }
        if ($Status){
            $Condition["u.ownerstatus"] = $Status;
        }

        $Condition = self::TimeContrast($Tst,$Tet,"a.uptime",$Condition);
        $Condition = self::TimeContrast($StartTime,$EndTime,"a.addtime",$Condition);

        $List = UserownerapplyModel::UserOwnerApplyList($Condition,$Page,50);
        $Count = UserownerapplyModel::UserOwnerApplyCount();

        $Query     = array("title" => $Title,"ownerstatus" => $Status);
        $Query     = self::Time($Tst,"trialstarttime",$Query);
        $Query     = self::Time($Tet,"trialendtime",$Query);
        $Query     = self::Time($StartTime,"starttime",$Query);
        $Query     = self::Time($EndTime,"endtime",$Query);

        $this->assign("data",$List);
        $this->assign("count",$Count);
        $this->assign("query",$Query);
        $this->assign("type",$Type);
        return $this->display("list",true);
    }

    /**
     * @return string
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 盟主审核,升级
     * 肖亚子
     */
    public function UserownerapplyEdit(){

        if (Request::instance()->isPost()){
            $Type   = $this->post("type",0);
            $Id     = $this->post("id",0);
            $UserId = $this->post("user_id",0);
            $ComId  = $this->post("community_id",0);
            $Owner  = $this->post("ownerstatus",0);
            $Status = $this->post("status",0);
            $Remark = $this->post("remark","");

            if ($Type == 0){
                $ApplyData["uptime"] = time();
                $Applicant           = Applicant;

                if ($Status == 2){
                    $ApplyCount = UserownerapplyModel::UserOwnerApplyTotal(array("community_id"=>$ComId,"status"=>2));
                    $UserCount  = UserownerapplyModel::UserOwnerApplyTotal(array("user_id"=>$UserId,"status"=>2));

                    if ($ApplyCount+1 > $Applicant){
                        $this->toError("此小区盟主已满,每个小区最多只能有{$Applicant}位盟主");
                    }

                    if ($UserCount > 0){
                        $this->toError("该用户已经是盟主,不能在成为此小区盟主");
                    }
                }

                if ($Status == 1){
                    parent::Tpl_Empty($Remark,"请输入驳回原因");
                    parent::Tpl_FullSpace($Remark,"请输入驳回原因");
                    parent::Tpl_StringLength($Remark,"驳回原因10-30字",3,10,30);

                    $ApplyData["status"] = $Status;
                    $ApplyData["remark"] = $Remark;
                }else{
                    $ApplyData["status"] = $Status;
                }

                $Cash = UserownerapplyModel::TableName();
                $Cash->startTrans();//开启事务

                $DataUp = UserownerapplyModel::UserOwnerApplyUpdate(array("apply_id"=>$Id),$ApplyData);

                if ($DataUp === false){
                    $Cash->rollback();//失败回滚exit;
                    $this->toError("审核失败");
                }

                if ($Status == 2){
                    $UserData["ownertype"]   = 2;
                    $UserData["ownerstatus"] = 1;
                    $UserUp = UserModel::UserUpdate(array("user_id"=>$UserId),$UserData);

                    if ($UserUp === false){
                        $Cash->rollback();//失败回滚exit;
                        $this->toError("审核失败");
                    }
                }

                $Cash->commit();//成功提交事务

                $this->log("用户审核成功,申请ID[{$Id}],用户id[{$UserId}]");

                $this->toSuccess("审核成功", '', 2);
            }elseif ($Type == 2){

                $UserData["ownerstatus"] = $Owner;
                $UserUp = UserModel::UserUpdate(array("user_id"=>$UserId),$UserData);

                if ($UserUp){
                    $this->log("用户审核成功,用户id[{$UserId}]");

                    $this->toSuccess("盟主编辑成功", '', 2);
                }else{
                    $this->toError("盟主编辑失败");
                }
            }
        }

        $ID   = $this->get("id",0);
        $Type = $this->get("type",0);

        $Data = UserownerapplyModel::UserOwnerApplyFind(array("apply_id"=>$ID));

        $this->assign("data",$Data);
        $this->assign("type",$Type);
        return $this->display("edit",false);
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