<?php
/**
 * Created by PhpStorm.
 * User: jay
 * Date: 2018/7/31
 * Time: 14:05
 */

namespace app\wechat\controller;


use app\common\model\Paymodel;
use app\common\WechatBaseController;
use think\Db;
use think\Session;

class PayController extends WechatBaseController {


    /**
     * 订单支付
     */
    public function index(){
        $order_id = $this->get('order_id', 0);
        $order = Db::name('order')->where(['user_id'=>Session::get('user.id'), 'id'=>$order_id])->find();
        if(!$order){
            $this->error('订单不存在');
        }
        if($order['status'] != 0){
            $this->error('订单状态不支持付款');
        }
        $pay = new Paymodel();
        $order['jsApiParameters'] = $pay->wxJsPay(Session::get('user.openid'), $order['order_no'], $order['payamount'], 'notify/yuding');
        $this->assign('order', $order);
        return $this->displaySingle('index:paynow');
    }

    /**
     * 申请退款
     */
    public function refundask(){
        $order_no = $this->get('order_no', '');
        $order = Db::name('order')->where(['user_id'=>Session::get('user.id'), 'order_no'=>$order_no])->find();
        if(!$order){
            alert('订单不存在');exit;
        }
        if($order['status'] != 1){
            alert('订单状态不支持付款');exit;
        }
        //调用JSAPI
        Vendor("WxPay.WxPay#Api");
        Vendor("WxPay.WxPay#JsApiPay");
        $input = new \WxPayRefund();
        $input->SetTransaction_id($order['transaction_id']);
        $input->SetTotal_fee($order["payamount"]*100);
        $input->SetRefund_fee($order["payamount"]*100);
        $input->SetOut_refund_no(WX_MCHID.$order_no);
        $input->SetOp_user_id(WX_MCHID);
        $result = \WxPayApi::refund(new \WxPayConfig(), $input);

        if($result['return_code'] != 'SUCCESS'){
            alert($result['return_msg']);exit;
        }
        if($result['result_code'] != 'SUCCESS'){
            alert($result['err_code_des']);exit;
        }
        $update['refund_id'] = $result['out_refund_no'];
        $update['refundtime'] = time();
        $update['status'] = 6;
        $res = Db::name('order')->where(['user_id'=>Session::get('user.id'), 'order_no'=>$order_no])->update($update);
        if($res !== false){
            alert('退款成功');exit;
        }else{
            alert('退款失败');exit;
        }
    }


}