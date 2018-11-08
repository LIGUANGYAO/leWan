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
            $has = Db::name('phonecode')->where(['mobile'=>$mobile, 'addtime'=>['gt', time()-60]])->find();
            if($has){
                $this->returnApiData('请不要频繁操作');
            }else{
                $code = rand(1234,9999);
                $content = config('cdxx_sms.content_regisiter');
                $content = str_replace('{code}', $code, $content);
                $res = sendSmsCdxx($mobile, $content);
                if($res){
                    $vo['mobile'] = $mobile;
                    $vo['code'] = $code;
                    $vo['addtime'] = time();
                    Db::name('phonecode')->insert($vo);
                }
                $this->returnApiData('短信已发送', 200);
            }
        }else{
            //重置登录密码
        }
    }

}