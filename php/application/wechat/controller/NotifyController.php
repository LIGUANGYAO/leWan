<?php
namespace app\wechat\controller;

use app\common\BaseController;
use app\common\model\PayMethod;
use think\Request;
use think\Db;

/**
 * 用户
 * Enter description here ...
 * @author Administrator
 *
 */
class NotifyController extends BaseController
{

    private $paymethod;
    private $WxPay;
    private $notifyparams;

    public function __construct()
    {
        parent::__construct();
        $payway = $this->get('payway','');
        if($payway == PayMethod::WxJSApi){
            $this->paymethod = PayMethod::WxJSApi;
            Vendor('WxPay.WxPay#Config');
            Vendor('WxPay.WxPay#Api');
            $this->WxPay = new \WxPayNotifyResults();
            $xml = $GLOBALS['HTTP_RAW_POST_DATA'];
            if(!$xml){
                $xml = file_get_contents('php://input');
            }
            //file_put_contents('./log.txt', "\r\nxml:".$xml, FILE_APPEND);
            try {
                $this->notifyparams = \WxPayNotifyResults::Init(new \WxPayConfig(), $xml)->GetValues();
            }catch (\WxPayException $e){
                //file_put_contents('./log.txt', "\r\nexception:".$e->getMessage(), FILE_APPEND);
                $this->output('FAIL', PayMethod::WxJSApi);
            }

        }
    }

    private function output($status='FAIL', $payway='alipay_app'){
        if($payway == PayMethod::AlipayNative){
            //$this->alieturn(strtolower($status));
        }else{
            $this->wxreturn($status);
        }
    }

    private function wxreturn($status='FAIL'){
        $this->WxPay->SetData('return_code', $status);
        echo $this->WxPay->ToXml();
        exit;
    }


    /**
     * 预定酒店回调
     */
    public function yuding(){
        $order = Db::name('order')->where(['order_no'=>$this->notifyparams['out_trade_no']])->find();
        if($order){
            if($order['status'] == 0){
                $payinfo['status'] = 1;
                $payinfo['paytime'] = time();
                $payinfo['transaction_id'] = $this->notifyparams['transaction_id'];
                Db::name('order')->where(['order_no'=>$this->notifyparams['out_trade_no']])->update($payinfo);
                //发送短信通知
                $room = Db::name('order_room o')->field('o.*, r.title')
                        ->join('jay_room r', 'r.id = o.room_id', 'left')
                        ->where(['o.order_id'=>$order['id']])->find();
                if($room){
                    $smsdata['orderno'] = $order['order_no'];
                    $smsdata['ruzhu'] = $order['starttime'];
                    $smsdata['likai'] = $order['endtime'];
                    $smsdata['price'] = $room['price'];
                    $smsdata['num'] = $room['num'];
                    $smsdata['name'] = $room['username'];
                    $smsdata['room'] = $room['title'];
                    $res = sendSms($room['mobile'], config('aliyun_sms.templatecode_yudingok'), $smsdata);
                }
                $this->wxreturn('SUCCESS');
            }else{
                $this->wxreturn();
            }
        }else{
            $this->wxreturn();
        }
    }

}
