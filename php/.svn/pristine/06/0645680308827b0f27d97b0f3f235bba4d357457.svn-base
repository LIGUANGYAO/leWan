<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/12
 * Time: 14:56
 * 手机添加短信验证码
 * 肖亚子
 */
namespace app\system\controller;

use app\common\AdminBaseController;
use Think\Db;

class UserphoneController extends AdminBaseController{

    /**
     * @return string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 用户手机号码获取验证码
     * 肖亚子
     */
    public function PhoneSms(){
        if (request()->isGet()){
            return $this->display('push', true);
        }else{
            $Mobile  = $this->post("mobile");

            parent::Tpl_Empty($Mobile,"请输入手机号码");
            parent::Tpl_FullSpace($Mobile,"请输入手机号码");
            parent::Tpl_Phone($Mobile,"请输入正确的手机号码");

            $Code = substr($Mobile,-6);

            $Data["mobile"] = $Mobile;
            $Data["code"] = $Code;
            $Data["addtime"] = time();
            $Data["status"] = 1;

            $UserCode = Db::name('phonecode')->where("mobile","=",$Mobile)->value("id");

            if ($UserCode){
                Db::name("phonecode")->where("id","=",$UserCode)->update($Data);
            }else{
                Db::name("phonecode")->insert($Data);
            }

            $this->log("用户短信验证码获取,手机号[".$Mobile."]");
            $this->toSuccess('验证码获取成功', url("Userphone/PhoneSms"), 1);
        }
    }
}