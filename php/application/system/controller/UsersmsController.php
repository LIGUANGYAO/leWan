<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/12
 * Time: 13:47
 * 用户短信推送
 * 肖亚子
 */
namespace app\system\controller;

use app\common\AdminBaseController;
use Think\Db;

class UsersmsController extends AdminBaseController{
    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 后台进行用户短信推送
     * 肖亚子
     */
    public function SmsPush(){
        if (request()->isGet()){
            return $this->display('push', true);
        }else{
            $Status  = $this->post("status");
            $Mobile  = $this->post("mobile");
            $Level   = $this->post("level");
            $Message = $this->post("message");

            parent::Tpl_Empty($Message,"请输入短信内容");
            parent::Tpl_FullSpace($Message,"请输入短信内容");

            $MobileString = "";
            if ($Status == 1){
                parent::Tpl_Empty($Mobile,"请输入需要推送的用户电话");
                $MobileString = $MobileString;
                $Mobile = array_chunk(explode(",",$Mobile),20);
            }else{
                parent::Tpl_Empty($Level,"请选择推送用户等级");
                $Condition["level"]    = array("eq",$Level);
                $Condition["user_id"]     = array("neq",1);
                $Condition["reg_type"] = array("eq",1);

                $UserMobile = Db::name("user")->field("mobile")->where($Condition)->select();
                $UserMobile[]['mobile'] = '15828218481';

                $UserMobile = array_reduce($UserMobile, function ($result, $value) {
                    return array_merge($result, array_values($value));
                }, array());

                $MobileString = implode(",",$MobileString);
                $Mobile = array_chunk($UserMobile,10);
            }

            foreach ($Mobile as $Key => $Val){
                foreach ($Val as &$v){
                    $v=trim($v);
                }
                $MobileStr = implode(",",$Val);
                $res = sendSmsCdxx($MobileStr,$Message,true);
                if(!$res){
                    $this->error('发送失败');
                }
                $Data["admin_id"]   = session('admin.id');
                $Data["admin_name"] = session('admin.jname');
                $Data["mobile"]     = $MobileStr;
                $Data["sendmsg"]    = $Message;
                $Data["addtime"]    = time();

                Db::name("msg_sendlog")->insert($Data);
            }

            $this->log("用户短信推送:推送电话[".$MobileString."]推送内容[".$Message."]");
            $this->toSuccess('推送成功', url("Usersms/SmsPush"), 1);
        }
    }

}