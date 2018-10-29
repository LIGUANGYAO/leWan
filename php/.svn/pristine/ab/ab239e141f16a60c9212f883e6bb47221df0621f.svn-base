<?php
/**
 * Created by PhpStorm.
 * User: jay
 * Date: 2018/8/2
 * Time: 10:29
 */

namespace app\wechat\controller;


use app\common\RegExpression;
use app\common\WechatBaseController;
use think\Db;
use think\Session;

class OrderController extends WechatBaseController{

    /**
     * 创建订单
     */
    public function build(){
        if(!Session::has('plan')){
            $this->ajaxReturn('请选择入住日期', 0);
        }
        $username = $this->post('inputname', '', RegExpression::REQUIRED);
        $tel = $this->post('inputtel', '', RegExpression::REQUIRED);
        $beizhu = $this->post('inputbz');
        $serviceIds = $this->post('serviceIds', '');
        $exchange = $this->post('exchange', 0);
        $roomid = $this->post('roomid', 0);
        $room = Db::name('room')->find($roomid);
        if(!$room){
            $this->ajaxReturn('房间不存在', 0);
        }
        $roomservice = Db::name('roomservice')->where(['id'=>['in',$serviceIds]])->select();
        //1.计算订单总金额
        $totalfee = 0;
        $payamount = 0;
        $discountfee = 0;
        $discountpoints = 0;
        $totalfee = $room['price'] * Session::get('plan.rooomnum') * Session::get('plan.NumDate');
        foreach ($roomservice as $service){
            $totalfee += $service['price'];
        }
        if($exchange > 0){
            //积分抵扣优惠
        }
        $payamount = $totalfee - $discountfee;
        $user = Db::name('member')->find(Session::get('user.id'));
        Db::startTrans();
        try{
            //保存用户资料
            if($user['username'] == '' || $user['phone'] == ''){
                Db::name('member')->where(['id'=>Session::get('user.id')])->update(['username'=>$username,'truename'=>$username, 'phone'=>$tel]);
            }
            $orderId = $this->insertorder($totalfee, $payamount, $discountfee, $discountpoints, Session::get('plan.startDate'), Session::get('plan.endDate'));
            $this->insertorderroom($orderId, $roomid, Session::get('plan.rooomnum'), Session::get('plan.NumDate'), $room['price'], $username, $tel, $beizhu);
            foreach ($roomservice as $service){
                $this->insertorderservice($orderId, $service);
            }
            Db::commit();
            $this->ajaxReturn('下单成功', 1, ['url'=>urlwx('pay/index', ['order_id'=>$orderId])]);
        } catch (\Exception $e) {
            Db::rollback();
        }
    }


    public function list1(){
        $this->assign('dropdown_url', url('order/loadlist'));
        $cat_id = $this->get('cat_id', 1);
        if($cat_id == 1){//未使用
            $where = ['o.`status`'=>['in', '0,1'], 'o.user_id'=>Session::get('user.id')];
        }else{//全部
            $where = ['o.`status`'=>['egt', 0], 'o.user_id'=>Session::get('user.id')];
        }
        $list = Db::name('order o')->field('o.id, o.order_no, o.totalfee, o.`status`, o.starttime, o.endtime, o.addtime, m.title, m.beizhu, m.feature, r.num, r.night, m.descp')
                ->join('jay_order_room r', 'r.order_id = o.id', 'left')
                ->join('jay_room m', 'm.id = r.room_id', 'left')
                ->where($where)
                ->order('o.id desc')->limit(0,10)->select();
        $this->assign('list', $list);
        $this->assign('cat_id', $cat_id);
        return $this->displaySingle('index:orderlist');
    }

    public function loadlist(){
        $ps = 10;
        $pn = $this->get('pn', 2);
        $pn++;
        if($pn < 1){
            $pn = 1;
        }
        $cat_id = $this->get('cat_id', 1);
        if($cat_id == 1){//未使用
            $where = ['o.id'=>['in', '0,1']];
        }else{//全部
            $where = ['o.id'=>['egt', 0]];
        }

        $return['pn'] = $pn;
        $return['hasmore'] = 1;
        $limit = (($pn-1)*$ps) . ','.$ps;
        $list = Db::name('order o')->field('o.id, o.order_no, o.totalfee, o.`status`, o.starttime, o.endtime, o.addtime, m.title, m.beizhu, m.feature, r.num, r.night')
            ->join('jay_order_room r', 'r.order_id = o.id', 'left')
            ->join('jay_room m', 'm.id = r.room_id', 'left')
            ->where($where)
            ->order('o.id desc')->limit($limit)->select();
        if(count($list) == 0){
            $return['hasmore'] = 0;
        }
        $this->assign('list', $list);
        $return['html'] = $this->fetch('index:orderlist_tpl');
        $this->ajaxReturn('ok', 1, $return);
    }


    public function info(){
        $order_id = $this->get('order_id', 0);
        $order = Db::name('order o')->field('o.*, m.title, m.beizhu, m.feature, r.*')
            ->join('jay_order_room r', 'r.order_id = o.id', 'left')
            ->join('jay_room m', 'm.id = r.room_id', 'left')
            ->where(['o.id'=>$order_id])
            ->find();

        if(!$order){
            $this->error('订单不存在');
        }
        $order['services'] = Db::name('order_service')->where(['order_id'=>$order['id']])->select();
        //是否可以退款,前3天可退款
        $order['canrefund'] = 0;
        if($order['status'] == 1 && strtotime($order['starttime'])-strtotime(date('Y-m-d')) > 86400*3){
            $order['canrefund'] = 1;
        }
        if($order['status'] == 6){
            $order['txt'] = '订单已取消';
        }elseif($order['status'] == 2){
            $order['txt'] = '已入住';
        }else{
            $order['txt'] = '订单不可取消';
        }
        $this->assign('order', $order);
        $this->assign('page', Db::name('page')->find(3));
        return $this->displaySingle('index:orderinfo');
    }


    /**
     * 创建订单
     * @param $totalfee
     * @param $payamount
     * @param $discountfee
     * @param $discountpoints
     * @param $starttime
     * @param $endtime
     * @return int|string
     */
    private function insertorder($totalfee=0, $payamount=0, $discountfee=0, $discountpoints=0, $starttime='', $endtime=''){
        $vo['order_no'] = $this->getOrderNo();
        $vo['user_id'] = Session::get('user')['id'];
        $vo['totalfee'] = $totalfee;
        $vo['payamount'] = $payamount;
        $vo['discountfee'] = $discountfee;
        $vo['discountpoints'] = $discountpoints;
        $vo['starttime'] = $starttime;
        $vo['endtime'] = $endtime;
        $vo['addtime'] = time();
        return Db::name('order')->insertGetId($vo);
    }

    /**
     * 创建订单房间
     * @param $order_id
     * @param $room_id
     * @param int $num
     * @param $price
     * @param $username
     * @param $mobile
     * @param string $remark
     * @return int|string
     */
    private function insertorderroom($order_id, $room_id, $num=1, $night, $price, $username, $mobile, $remark=''){
        $vo['order_id'] = $order_id;
        $vo['room_id'] = $room_id;
        $vo['num'] = $num;
        $vo['night'] = $night;
        $vo['price'] = $price;
        $vo['username'] = $username;
        $vo['mobile'] = $mobile;
        $vo['remark'] = $remark;
        $vo['user_id'] = Session::get('user')['id'];
        return Db::name('order_room')->insertGetId($vo);
    }


    private function insertorderservice($order_id, $service){
        $vo['user_id'] = Session::get('user')['id'];
        $vo['order_id'] = $order_id;
        $vo['service_id'] = $service['id'];
        $vo['servicename'] = $service['title'];
        $vo['price'] = $service['price'];
        return Db::name('order_service')->insertGetId($vo);
    }

    private function getOrderNo(){
        $count = Db::name('order')->where("order_no like '".date('ymdH')."%'")->count();
        $str = '';
        for($i=0; $i<3-strlen($count); $i++){
            $str.='0';
        }
        return date('ymdH').$str.($count+1);
    }
}