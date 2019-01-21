<?php
namespace app\api\controller;

use app\api\model\NotifyModel;
use app\common\BaseController;
use app\common\model\PayMethod;
use app\common\model\ProcedureModel;
use think\Db;

/**
 * 支付回调
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
            file_put_contents('./log.txt', "\r\nxml:".$xml, FILE_APPEND);
            try {
                $this->notifyparams = \WxPayNotifyResults::Init(new \WxPayConfig(), $xml)->GetValues();
            }catch (\WxPayException $e){
                file_put_contents('./log.txt', "\r\nexception:".$e->getMessage(), FILE_APPEND);
                $this->output('FAIL', PayMethod::WxJSApi);
            }
            //$this->notifyparams = notifytest();
        }elseif($payway == PayMethod::WxAppNative){
            $this->paymethod = PayMethod::WxAppNative;
            Vendor('WxPay.WxPay#ConfigApp');
            Vendor('WxPay.WxPay#Api');
            $this->WxPay = new \WxPayNotifyResults();
            $xml = $GLOBALS['HTTP_RAW_POST_DATA'];
            if(!$xml){
                $xml = file_get_contents('php://input');
            }
            file_put_contents('./log.txt', "\r\nxml:".$xml, FILE_APPEND);
            try {
                $this->notifyparams = \WxPayNotifyResults::Init(new \WxPayConfigApp(), $xml)->GetValues();
            }catch (\WxPayException $e){
                file_put_contents('./log.txt', "\r\nexception:".$e->getMessage(), FILE_APPEND);
                $this->output('FAIL', PayMethod::WxAppNative);
            }
            //$this->notifyparams = notifytest();
        }
    }

    private function output($status='FAIL'){
        if($this->paymethod == PayMethod::AlipayNative){
            //$this->alieturn(strtolower($status));
        }elseif($this->paymethod == PayMethod::WxJSApi){
            $this->wxreturn($status);
        }elseif($this->paymethod == PayMethod::WxAppNative){
            $this->wxreturn($status);
        }
    }

    /**
     * 微信支付回复通知
     * @param $status 状态
     */
    private function wxreturn($status='FAIL'){
        $this->WxPay->SetData('return_code', $status);
        echo $this->WxPay->ToXml();
        exit;
    }

    /*  ----------------------业务部分----------------------------  */
    /**
     * 商城购物通知
     */
    public function mall(){
        $order = Db::name('order o')
                ->field('o.*,p2.distributiontag, p.product_name, p.product_returnall, p.product_id, p.price_id, p.op_id, p.commission, p.num, p.product_startusetime, p.product_endusetime, m.merchant_contactmobile')
                ->join('jay_order_product p', 'p.order_id = o.order_id', 'left')
                ->join('jay_product p2', 'p2.product_id = p.product_id', 'left')
                ->join('jay_merchant m', 'm.merchant_id = o.merchant_id', 'left')
                ->where(['order_no'=>$this->notifyparams['out_trade_no']])->find();
        if($order){
            if($order['order_status'] == 1){
                $nm = new NotifyModel();
                $pm = new ProcedureModel();
                Db::startTrans();
                //锁表
                Db::name('order')->where(['order_no'=>$this->notifyparams['out_trade_no']])->lock(true)->find();
                $res = $nm->notifyMall($order, $this->notifyparams, $this->paymethod, $this->CFG);
                $res2 = $pm->execute('lewan_order_income', $order['order_id'], '@error');
                $res3 = $pm->execute('lewan_user_performance', $order['order_id'], '@error');
                if($res['res'] && $res2 && $res3){
                    Db::commit();
                    if($res['code'] != ''){
                        //短信通知
                        $nm->sendOrderSms($order, $res['code'], $this->CFG);
                    }
                    $this->output('SUCCESS');
                }else{
                    GLog('微信支付回调---提交处理res2:',json_encode($res2));
                    GLog('微信支付回调---提交处理res3:',json_encode($res3));
                    Db::rollback();
                    $this->output();
                }
            }else{
                GLog('微信支付回调---订单状态异常:',json_encode($order));
                $this->output();
            }
        }else{
            GLog('微信支付回调---订单查询异常:','err');
            $this->output();
        }
    }

    /**
     * 预约加价回调
     */
    public function yuyue(){
        $order = Db::name('order_user_reservation')->where(['reservation_no'=>$this->notifyparams['out_trade_no']])->find();
        if($order){
            if($order['reservation_status'] == 0){
                Db::startTrans();
                $pm = new ProcedureModel();
                $data['reservation_transaction_id'] = $this->notifyparams['transaction_id'];
                $data['reservation_paytime'] = time();
                $data['reservation_status'] = 1;
                $res1 = Db::name('order_user_reservation')->where(['reservation_no'=>$this->notifyparams['out_trade_no']])->update($data);
                $res2 = Db::name('product_reservationprice')->where(['id'=>$order['reservationprice_id']])->update(['usenum'=>['exp','usenum+1']]);
                $res3 = $pm->execute('lewan_orderyuyue_income', $order['reservation_id'], '@error');
                if($res1 !== false && $res2 !== false && $res3){
                    Db::commit();
                    $this->output('SUCCESS');
                }else{
                    Db::rollback();
                    $this->output();
                }
            }else{
                $this->output();
            }
        }else{
            $this->output();
        }
    }

}
