<?php
namespace app\api\controller;

use app\api\model\NotifyModel;
use app\common\BaseController;
use app\common\model\PayMethod;
use app\common\model\ProcedureModel;
use app\tapi\model\OrderModel;
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
                ->field('o.*,p2.distributiontag, p.product_name, p.product_returnall, p.product_id, p.price_id, p.op_id, p.commission, p.num, p.product_startusetime, p.product_endusetime, m.merchant_contactmobile,m.dboss_id')
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
                    if($order['distributiontag'] == 0){
                        //短信通知
                        $nm->sendOrderSms($order, $res['code'], $this->CFG);
                    }

                    if ($order["dboss_id"]==2){ //123门票(欢乐谷)网对接
                        $this->createOrderToHappyValley($order);
                    }
                    $this->output('SUCCESS');
                }else{
                    GLog('微信支付回调---提交处理res2:',json_encode($res2));
                    GLog('微信支付回调---提交处理res3:',json_encode($res3));
                    Db::rollback();
                    $this->output();
                }
            }else{
                if($order['order_status'] == 2){
                    $this->output('SUCCESS');
                }
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

    /**
     * 123门票网对接
     * @param $order
     * @return bool
     */
    public function createOrderToHappyValley($order){
        GLog('123门票网分销star:',1);
        $price = Db::name('product_price')->field('pnumber,gnumber')->where(['price_id'=>$order['price_id']])->find();
        if($price){
            GLog('123门票网分销star:',2);
            $data['partner_order_number'] = $order['order_id'];//此订单在接入方系统中的唯一ID，用来防止重复下单
            $data['arrival_date'] = date('Y-m-d', $order['order_plainday']);//游玩日期
            $data['idnumber'] = $order['order_idcard'];//身份证号码
            $data['send_sms'] = $this->post('send_sms',true);//是否由123发送短信，默认是: true, 只对123自营项目有效，对123分销第三方产品的无效
            $data['name'] = $order['order_fullname'];//订票人姓名
            $data['tel'] = $order['order_mobile'];//联系电话
            $data['product_number'] = $price['pnumber'];//商品编号
            $line_items[0]['variant_number'] = $price['gnumber'];//门票编码
            $line_items[0]['quantity'] = $order['num'];
            $data['line_items'] = json_encode($line_items,true);//门票编码和数量
            OrderModel::createOrderToHappyValley($data);
        }else{
            GLog('123门票网分销商品码规格码错误！！',2);
        }
    }
}
