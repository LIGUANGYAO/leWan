<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/4/2
 * Time: 9:31
 * 直卖活动控制器
 * 肖亚子
 */

namespace app\system\controller;
use app\common\AdminBaseController;

use app\system\model\DirectsaleModel;
use think\Request;


class DirectsaleController extends AdminBaseController{

    public function DireCtsaleList(){

        $Psize           = $this->get("page", 1);
        $Title           = $this->get("title", '');
        $Status          = $this->get("status",'');
        $Starttime       = $this->get("starttime", '');
        $Endtime         = $this->get("endtime", '');
        $Finishstarttime = $this->get("finishstarttime", '');
        $Finishendtime   = $this->get("finishendtime", '');
        $Upstarttime     = $this->get("upstarttime", '');
        $Upendtime       = $this->get("upendtime", '');

        $Condition = array();

        if ($Title) {
            $Condition["u.nickname|u.mobile"] = array("like", "%$Title%");
        }
        if($Status){
            $Condition["d.status"] = $Status==5?0:$Status;
        }

        if ($Starttime) {
            $Condition["d.firsttime"] = array('egt', strtotime($Starttime));
        }
        if ($Endtime) {
            $Condition["d.firsttime"] = array('elt', strtotime($Endtime));
        }

        if ($Finishstarttime) {
            $Condition["d.finishtime"] = array('egt', strtotime($Finishstarttime));
        }
        if ($Finishendtime) {
            $Condition["d.finishtime"] = array('elt', strtotime($Finishendtime));
        }
        if ($Upstarttime) {
            $Condition["d.uptime"] = array('egt', strtotime($Upstarttime));
        }
        if ($Upendtime) {
            $Condition["d.uptime"] = array('elt', strtotime($Upendtime));
        }

        $List = DirectsaleModel::DireList($Condition,$Psize,50);

        $Query = array("title"=>$Title,"status"=>$Status,"starttime"=>$Starttime,
            "endtime"=>$Endtime,"finishstarttime"=>$Finishstarttime,"finishendtime"=>$Finishendtime,
            "upstarttime"=>$Upstarttime,"upendtime"=>$Upendtime);

        $this->assign("query",$Query);
        $this->assign('data', $List);
        return $this->display('index', true);
    }
}
