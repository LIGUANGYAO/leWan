<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/7
 * Time: 16:17
 */

namespace app\api\controller;
use think\Db;

/**
 * 系统工具
 * Class SmsController
 * @package app\api\controller
 */
class SysController extends ApiBaseController
{

    /**
     * 发送短信
     */
    public function sendSms(){
        $type = $this->post('type', 1);
        if($type == 1){
            //注册
            $mobile = $this->post('mobile', '');
            $has = Db::name('phonecode')->field("id, addtime")->where(['mobile'=>$mobile])->order('id desc')->find();
            if($has && $has["addtime"] > time()-60){
                $this->returnApiData('请不要频繁操作');
            }else{
                $code = rand(111111,999999);
                $templatecode = config('aliyun_sms.templatecode_5');
                $param = ['code'=>$code];
                $res = sendSmsAliyun($mobile, $templatecode, $param);
                if($res){
                    $vo['mobile']  = $mobile;
                    $vo['code']    = $code;
                    $vo['addtime'] = time();
                    if ($has){
                        Db::name("phonecode")->where(array("mobile"=>array("eq",$mobile)))->update($vo);
                    }else{
                        Db::name('phonecode')->insert($vo);
                    }
                    $this->returnApiData('短信已发送', 200);
                }else{
                    $this->returnApiData('短信发送失败', 400);
                }
            }
        }else{
            //重置登录密码
        }
    }

}