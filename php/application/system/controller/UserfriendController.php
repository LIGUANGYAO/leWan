<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/14
 * Time: 11:10
 * 获取用户好友查询
 * 肖亚子
 */
namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\UserfriendModel;

class UserfriendController extends AdminBaseController{

    public function FriendList(){
        $Mobile    = $this->get("mobile");
        $Starttime = $this->get("starttime");
        $Endtime   = $this->get("endtime");

        if ($Mobile){
           parent::Tpl_Phone($Mobile,"请输入正确的用户手机号码");

           $Stime = strtotime($Starttime);
           $Etime = strtotime($Endtime);

           parent::Tpl_Contrast($Stime,$Etime,"开始时间不能等于结束时间",5);
           parent::Tpl_Contrast($Stime,$Etime,"开始时间不能大于结束时间",1);

           $Friend =  UserfriendModel::UserFind($Mobile,$Stime,$Etime);

           $this->assign("friend",$Friend);
        }



        $this->assign("mobile",$Mobile);
        $this->assign("starttime",$Starttime);
        $this->assign("endtime",$Endtime);
        return $this->display('list', true);
    }

}