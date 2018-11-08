<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/8
 * Time: 14:41
 */

namespace app\api\controller;
use app\api\model\HelpModel;
use app\common\model\Paymodel;
use think\Db;

/**
 * 预约中心
 * Class YuyueController
 * @package app\api\controller
 */
class YuyueController extends ApiBaseController
{

    /**
     * 查询订单
     */
    public function search(){
        $code = $this->post('code', '');
        $user = getUserByToken();
        $where['c.consume_code'] = $code;
        $where['c.status'] = 1;
        $where['c.user_id'] = $user['user_id'];
        $where['o.order_status'] = 2;
        $order = Db::name('order_consume_code c')
                ->field('o.order_id, o.order_no, o.order_paytime, o.order_addtime, p.product_name, p.product_property, p.`num`, p.product_startusetime, p.product_endusetime, m.product_info, m.product_useinfo, m.product_notice')
                ->join('jay_order o', 'o.order_id = c.order_id', 'left')
                ->join('jay_order_product p', 'p.order_id = o.order_id', 'left')
                ->join('jay_product m', 'm.product_id = p.product_id', 'left')
                ->where($where)
                ->find();
        if($order){
            $order['order_paytime'] = date('Y-m-d H:i:s', $order['order_paytime']);
            $order['order_addtime'] = date('Y-m-d H:i:s', $order['order_addtime']);
            $order['product_endusetime'] = date('Y-m-d H:i:s', $order['product_endusetime']);
            $order['product_startusetime'] = date('Y-m-d H:i:s', $order['product_startusetime']);
            $this->returnApiData('查询成功', 200, $order);
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }


    /**
     * 万年历表
     */
    public function calandar()
    {
        $code = $this->post('code', '');
        $user = getUserByToken();
        $where['c.consume_code'] = $code;
        $where['c.status'] = 1;
        $where['c.user_id'] = $user['user_id'];
        $where['o.order_status'] = 2;
        $order = Db::name('order_consume_code c')
            ->field('o.order_id, o.order_no, o.order_paytime, o.order_addtime, p.product_name, p.price_id, p.product_property, p.product_id, p.product_startusetime, p.product_endusetime')
            ->join('jay_order o', 'o.order_id = c.order_id', 'left')
            ->join('jay_order_product p', 'p.op_id = c.op_id', 'left')
            ->where($where)
            ->find();
        if($order){
            if($order['product_startusetime'] > time()){
                $this->returnApiData('暂时没到开放预约时间：'.date('Y-m-d', $order['product_startusetime']), 400);
            }
            if($order['product_endusetime'] < time()){
                $this->returnApiData('预约已经结束', 400);
            }
            //获取日历信息
            $w2['r.product_id'] = $order['product_id'];
            $w2['r.price_id'] = $order['price_id'];
            $calendarlist = Db::name('product_reservationday r')
                            ->field('r.*, sum(`p`.`totalnum`) totalnum, sum(`p`.`usenum`) usenum')
                            ->join('jay_product_reservationprice p', 'p.reservationday_id = r.reservationday_id', 'left')
                            ->where($w2)->group('p.reservationday_id')
                            ->order('r.reservationday_id asc')
                            ->select();
            foreach ($calendarlist as $k=>$v){
                $calendarlist[$k]['day'] = date('m月d日', $v['calendar']);
                $calendarlist[$k]['status'] = $v['totalnum'] <= $v['usenum']?0:1;
            }
            $this->returnApiData('查询成功', 200, $calendarlist);
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }

    /**
     * 获取套餐
     */
    public function getCase(){
        $reservationday_id = $this->post('reservationday_id', 0);
        $user = getUserByToken();
        $pricelist = Db::name('product_reservationprice')
                    ->field('id, reservationday_id, property, addprice, totalnum,  usenum')
                    ->where(['reservationday_id'=>$reservationday_id])
                    ->select();
        $this->returnApiData('获取成功', 200, $pricelist);
    }


    public function submit(){
        $reservationprice_id = $this->post('reservationprice_id', 0);
        $code = $this->post('code', '');
        $user = getUserByToken();
        $where['c.consume_code'] = $code;
        $where['c.status'] = 1;
        $where['c.user_id'] = $user['user_id'];
        $where['o.order_status'] = 2;
        $order = Db::name('order_consume_code c')
            ->field('c.consume_code_id, o.order_id, o.order_no, o.order_paytime, o.order_addtime, p.product_name, p.price_id, p.product_property, p.product_id, p.product_startusetime, p.product_endusetime')
            ->join('jay_order o', 'o.order_id = c.order_id', 'left')
            ->join('jay_order_product p', 'p.op_id = c.op_id', 'left')
            ->where($where)
            ->find();
        if($order){
            if($order['product_startusetime'] > time()){
                $this->returnApiData('暂时没到开放预约时间：'.date('Y-m-d', $order['product_startusetime']), 400);
            }
            if($order['product_endusetime'] < time()){
                $this->returnApiData('预约已经结束', 400);
            }
            Db::startTrans();
            $reservationprice = Db::name('product_reservationprice')->lock(true)->find($reservationprice_id);
            if($reservationprice){
                if($reservationprice['usenum'] >= $reservationprice['totalnum']){
                    $this->returnApiData('当日预约名额已被抢完，请重新选择其他日期预约', 400);
                }
                $reserDay = Db::name('product_reservationday')->find($reservationprice['reservationday_id']);
                //是否已经预约过
                $rw['order_id'] = $order['order_id'];
                $rw['user_id'] = $user['user_id'];
                $rw['consume_code_id'] = $order['consume_code_id'];
                $hasReservation = Db::name('order_user_reservation')->where($rw)->find();
                if($hasReservation['reservation_status'] > 0){
                    $this->returnApiData('该电子码'.$code.'已经预约成功了，不可重复预约', 400);
                }
                $hm = new HelpModel();
                $rwdata['order_id'] = $order['order_id'];
                $rwdata['user_id'] = $user['user_id'];
                $rwdata['consume_code_id'] = $order['consume_code_id'];
                $rwdata['reservationday_id'] = $reservationprice['reservationday_id'];
                $rwdata['reservationprice_id'] = $reservationprice['id'];
                $rorder_no = $hm->makeROrderNumber();
                $reback['orderNo'] = $rorder_no;
                $rwdata['reservation_no'] = $rorder_no;
                $rwdata['reservation_calendar'] = $reserDay['calendar'];
                $rwdata['reservation_week'] = $reserDay['week'];
                $rwdata['reservation_property'] = $reservationprice['property'];
                $rwdata['reservation_addprice'] = $reservationprice['addprice'];
                $rwdata['reservation_uptime'] = time();
                $rwdata['reservation_addtime'] = time();
                if($reservationprice['addprice'] > 0){
                    $rwdata['reservation_status'] = 0;
                    $reback['needpay'] = 1;
                }else{
                    $rwdata['reservation_status'] = 1;
                    $reback['needpay'] = 0;
                }
                if($hasReservation){
                    $res = Db::name('order_user_reservation')->where($rw)->update($rwdata);
                }else{
                    $res = Db::name('order_user_reservation')->insert($rwdata);
                }
                if($res !== false){
                    Db::commit();
                    $this->returnApiData('预约成功', 200, $reback);
                }else{
                    Db::rollback();
                    $this->returnApiData('预约失败', 400);
                }
            }else{
                Db::rollback();
                $this->returnApiData('预约日期不存在', 400);
            }
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }

    /**
     * 立即支付
     */
    public function payNow(){
        $user = getUserByToken();
        $orderNo = $this->post('orderNo', '');
        $payway = $this->post('payway', 1); //1微信公众号支付 2支付宝app；3银行卡；4微信APP
        $order = Db::name('order_user_reservation')->where(['user_id'=>$user['user_id'], 'reservation_no'=>$orderNo])->find();
        if($order){
            if($order['reservation_addprice'] == 0){
                $this->returnApiData('订单不需要支付', 400);
            }
            if($order['reservation_status'] != 0){
                $this->returnApiData('订单状态异常', 400);
            }
            if($payway == 1){
                $openId = Db::name('user_connect')->where(['user_id'=>$user['user_id'], 'platform'=>'wechat'])->value('openid');
                if(!$openId){
                    $this->returnApiData('账号未授权登录服务号', 400);
                }
                $pm = new Paymodel();
                $res = $pm->wxJsPay($openId, $orderNo, $order['reservation_addprice'], 'Notify/yuyue');
                $this->returnApiData('获取成功', 200, ['jsApiParameters'=>$res]);
            }elseif($payway == 2){
                $this->returnApiData('支付宝支付尚未开通', 400);
            }elseif($payway == 3){
                $this->returnApiData('银行卡支付尚未开通', 400);
            }elseif($payway == 4){
                $this->returnApiData('微信app支付尚未开通', 400);
            }
        }else{
            $this->returnApiData('没有查询到订单信息', 400);
        }
    }


}