<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/4/9
 * Time: 15:54
 * 分销商管理控制器
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\RetailadminuserModel;

class RetailadminuserController extends AdminBaseController{

    public function AdminUserList(){
        $Page    = $this->get("page",1);
        $Title   = $this->get("title","");
        $BizType = $this->get("biztype",0);
        $Status  = $this->get("status",0);

        $Condition = array();

        $Condition["a.pid"]  = 0;
        $Condition["a.type"] = 2;

        if ($Title){
            $Condition["a.username|a.company|a.concat|a.mobile"] = array("like","%$Title%");
        }
        if ($BizType){
            $Condition["a.biztype"] = $BizType;
        }
        if ($Status){
            $Condition["a.status"] = $Status == 1?1:0;
        }

        $List = RetailadminuserModel::AdminList($Condition,$Page,10);

        $Query = array("title"=>$Title,"status"=>$Status,"biztype"=>$BizType);

        $this->assign("query",$Query);
        $this->assign("data",$List);
        return $this->display("list",true);
    }

    /**
     * @return string
     * 查看分销商资金流水信息
     * 肖亚子
     */
    public function AdminUserCapitalFlowList(){

        $Id   = $this->get("id",0);
        $Time = $this->get("time","");

        if (!$Id){
            $this->toError("请选择正确的分销商");
        }

        if (!$Time){
            $Month = date("Ym",time());
        }else{
            $Month = date("Ym",strtotime($Time));
        }

        $Condition["user_id"] = $Id;
        $List = RetailadminuserModel::AccountCashList($Condition,$Month);
        $this->assign("id",$Id);
        $this->assign("time",$Time);
        $this->assign("data",$List);
        return $this->display("accountcashlist",true);
    }
}