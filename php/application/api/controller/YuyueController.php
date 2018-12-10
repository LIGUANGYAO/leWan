<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/8
 * Time: 14:41
 */

namespace app\api\controller;
use think\Db;
use Think\Exception;
use app\api\model\HelpModel;
use app\common\model\Paymodel;
use app\api\model\UserModel;
use app\api\model\OrderModel;
use app\api\model\UserAddressModel;

/**
 * 预约中心
 * Class YuyueController
 * @package app\api\controller
 */
class YuyueController extends ApiBaseController
{
    /**
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取预约中心未预约列表
     * 肖亚子
     */
    public function ConsumeBespokeAll(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Page  = intval(input("post.page","1"));//分页默认第一页

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            $OrderAll = array();

            $Uid = UserModel::UserFindUid($Token);

            $Condition[] = array("exp","o.order_status >= 2 and o.order_status <= 4");
            $Condition["o.user_id"]           = $Uid;
            $Condition["o.order_reservation"] = 1;

            //获取预约订单
            $Orders = OrderModel::OrderReservationList($Condition,$Page,10);

            foreach ($Orders as $Key => $Val){
                if ($Val["product_endusetime"] < time()){
                    $EndTime = 2;//订单商品结束时间过期等于2
                }else{
                    $EndTime = 1;//订单商品结束时间未过期等于1
                }

                if ($Val["express"] == 1){//获取预约到店电子消费码

                    $OrderCode = array();

                    $CodeCondition["cc.order_id"] = array("eq",$Val["order_id"]);
                    $CodeCondition["cc.user_id"]  = array("eq",$Uid);

                    $CodeList  = OrderModel::OrderConsumeCodeList($CodeCondition);

                    if ($CodeList){
                        foreach ($CodeList as $K => $V){
                            if (!$V["reservation_id"] || ($V["reservation_status"] == 0 || $V["reservation_status"] > 2)){
                                $Codes["consume_code"] = $V["consume_code"];
                                $Codes["status"]       = $V["status"];
                                $OrderCode[]           = $Codes;
                            }
                        }
                    }

                    $Count = count($OrderCode);

                    if ($Count){
                        $Data["order_id"]     = $Val["order_id"];
                        $Data["ordernumber"]  = $Val["ordernumber"];
                        $Data["express"]      = $Val["express"];
                        $Data["product_name"] = $Val["product_name"];
                        $Data["startusetime"] = $Val["product_startusetime"];
                        $Data["endusetime"]   = $Val["product_endusetime"];
                        $Data["endtime"]      = $EndTime;
                        $Data["code_count"]   = $Count;
                        $Data["code"]         = $OrderCode;

                        $OrderAll[] = $Data;
                    }

                    unset($CodeList);
                    unset($OrderCode);
                } else{//获取订单预约快递信息

                    $FahuoCondition["rf.order_id"] = array("eq",$Val["order_id"]);
                    $FahuoCondition["rf.user_id"]  = array("eq",$Uid);

                    $Express = OrderModel::OrderReservationFahuoFind($FahuoCondition);

                    $Data["order_id"]     = $Val["order_id"];
                    $Data["ordernumber"]  = $Val["ordernumber"];
                    $Data["express"]      = $Val["express"];
                    $Data["product_name"] = $Val["product_name"];
                    $Data["startusetime"] = $Val["product_startusetime"];
                    $Data["endusetime"]   = $Val["product_endusetime"];
                    $Data["endtime"]      = $EndTime;

                    if (!$Express){
                        $OrderAll[] = $Data;
                    }

                    unset($Express);
                }
            }

            unset($Orders);

            $this->returnApiData("获取成功", 200,$OrderAll);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }


    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取已预约列表数据
     * 肖亚子
     */
    public function ConsumeBookedAll(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Page  = intval(input("post.page","1"));//分页默认第一页

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            $OrderAll = array();

            $Uid = UserModel::UserFindUid($Token);

            $Condition[] = array("exp"," (o.order_isexpress = 1 or o.order_isexpress = 2 and o.order_reservation = 1) and o.order_status >= 2 and o.order_status <= 4");
            $Condition["o.user_id"]           = $Uid;
            $Condition["o.order_reservation"] = 1;

            //获取预约订单
            $Orders = OrderModel::OrderReservationList($Condition,$Page,10);

            foreach ($Orders as $Key => $Val){
                if ($Val["product_endusetime"] < time()){
                    $EndTime = 2;//订单商品结束时间过期等于2
                }else{
                    $EndTime = 1;//订单商品结束时间未过期等于1
                }

                if ($Val["express"] == 1 && $Val["reservation"] == 1){//获取预约到店电子消费码
                    $CodeCondition["cc.order_id"] = array("eq",$Val["order_id"]);
                    $CodeCondition["cc.user_id"]  = array("eq",$Uid);

                    $CodeList  = OrderModel::OrderConsumeCodeList($CodeCondition);

                    if ($CodeList){
                        foreach ($CodeList as $K => $V){
                            if ($V["reservation_status"] == 1 || $V["reservation_status"] == 2){
                                $Data["order_id"]     = $Val["order_id"];
                                $Data["ordernumber"]  = $Val["ordernumber"];
                                $Data["express"]      = $Val["express"];
                                $Data["product_name"] = $Val["product_name"];
                                $Data["startusetime"] = $Val["product_startusetime"];
                                $Data["endusetime"]   = $Val["product_endusetime"];
                                $Data["endtime"]      = $EndTime;
                                $Data["consume_code"] = $V["consume_code"];
                                $Data["status"]       = $V["status"];

                                $OrderAll[] = $Data;
                            }
                        }
                    }

                    unset($CodeList);
                }elseif($Val["express"] == 2 && $Val["reservation"] == 1){//获取订单预约快递信息

                    $FahuoCondition["rf.order_id"] = array("eq",$Val["order_id"]);
                    $FahuoCondition["rf.user_id"]  = array("eq",$Uid);

                    $Express = OrderModel::OrderReservationFahuoFind($FahuoCondition);

                    if ($Express){
                        $Data["order_id"]     = $Val["order_id"];
                        $Data["ordernumber"]  = $Val["ordernumber"];
                        $Data["express"]      = $Val["express"];
                        $Data["product_name"] = $Val["product_name"];
                        $Data["startusetime"] = $Val["product_startusetime"];
                        $Data["endusetime"]   = $Val["product_endusetime"];
                        $Data["endtime"]      = $EndTime;
                        $Data["deliveryid"]   = $Express["yy_id"];

                        $OrderAll[] = $Data;
                    }

                    unset($Express);
                }
            }

            unset($Orders);

//        elseif ($Val["express"] == 1 && $Val["reservation"] == 2){//获取到店免预约电子消费码
//            $CodeCondition["cc.order_id"] = array("eq",$Val["order_id"]);
//            $CodeCondition["cc.user_id"]  = array("eq",$Uid);
//
//            $CodeList = OrderModel::OrderConsumeCodeNoList($CodeCondition);
//
//            if ($CodeList){
//                foreach ($CodeList as $K => $V){
//                    $Data["order_id"]     = $Val["order_id"];
//                    $Data["ordernumber"]  = $Val["ordernumber"];
//                    $Data["express"]      = $Val["express"];
//                    $Data["product_name"] = $Val["product_name"];
//                    $Data["startusetime"] = $Val["product_startusetime"];
//                    $Data["endusetime"]   = $Val["product_endusetime"];
//                    $Data["endtime"]      = $EndTime;
//                    $Data["consume_code"] = $V["consume_code"];
//                    $Data["status"]       = $V["status"];
//
//                    $OrderAll[] = $Data;
//                }
//            }
//
//            unset($CodeList);
//        }
            $this->returnApiData("获取成功", 200,$OrderAll);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取电子码预约详情
     * 肖亚子
     */
    public function ConsumeBookedReservation(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Code  = input("post.code","","htmlspecialchars,strip_tags");;//电子码

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($Code,"获取失败",2);

            $Uid = UserModel::UserFindUid($Token);

            $Condition["cc.user_id"] = array("eq",$Uid);
            $Condition["cc.consume_code"] = array("eq",$Code);

            $Order = OrderModel::OrderCodeFind($Condition);

            if (!$Order){
                $this->returnApiData("获取失败", 400);
            }

            if ($Order["isexpress"] == 1 && $Order["reservation"] == 1){
                $ReCondition["user_id"]         = array("eq",$Uid);
                $ReCondition["order_id"]        = array("eq",$Order["order_id"]);
                $ReCondition["consume_code_id"] = array("eq",$Order["consume_code_id"]);

                $ReservationData = OrderModel::OrderReservationFind($ReCondition);

                if (!$ReservationData){
                    $this->returnApiData("未预约", 400);
                }
            }else{
                $ReCondition["order_id"] = array("eq",$Order["order_id"]);

                $PriceData = OrderModel::OrderProductFind($ReCondition,"price_type,product_property");

                if (!$PriceData){
                    $this->returnApiData("未预约", 400);
                }else{
                    $ReservationData["property"] = $PriceData["product_property"];
                }
            }

            $this->returnApiData("获取成功", 200,$ReservationData);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取快递预约商品发货信息
     * 肖亚子
     */
    public function ConsumeBookedDelivery(){
        try{
            $Token   = input("post.token","","htmlspecialchars,strip_tags");
            $OrderId = intval(input("post.order_id"));//订单id

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断

            parent::Tpl_Empty($OrderId,"获取失败",2);

            $Uid = UserModel::UserFindUid($Token);

            $Condition["o.order_id"]          = array("eq",$OrderId);
            $Condition["o.user_id"]           = array("eq",$Uid);
            $Condition["o.order_isexpress"]   = array("eq",2);
            $Condition["o.order_reservation"] = array("eq",1);

            $OrderFind = OrderModel::OrderFind($Condition,"o.order_id");

            if (!$OrderFind){
                $this->returnApiData("订单未找到", 400);
            }

            $RfCondition["rf.order_id"] = array("eq",$OrderId);
            $RfCondition["rf.user_id"] = array("eq",$Uid);

            $Delivery = OrderModel::OrderReservationFahuoFind($RfCondition,"rf.day as calendar,rf.remark");

            if (!$Delivery){
                $this->returnApiData("未预约发货", 400);
            }

            $this->returnApiData("获取成功", 200,$Delivery);

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }
    /**
     * 查询订单
     */
    public function search(){
        $code = $this->post('code', '');
        $user = getUserByToken();
        $where['c.consume_code'] = $code;
        $where['c.status'] = 1;
        $where['c.user_id'] = $user['user_id'];
        $where[] = array("exp","o.order_status >=2 and o.order_status <= 4 and o.order_reservation = 1");

        $order = Db::name('order_consume_code c')
                ->field('o.order_id, o.order_no, o.order_paytime, o.order_addtime, p.product_name, p.product_property, p.`num`, p.product_startusetime, p.product_endusetime, m.product_info, m.product_useinfo, m.product_notice')
                ->join('jay_order o', 'o.order_id = c.order_id', 'left')
                ->join('jay_order_product p', 'p.order_id = o.order_id', 'left')
                ->join('jay_product m', 'm.product_id = p.product_id', 'left')
                ->where($where)
                ->find();
        if($order){
            $this->verifyCode($order, $code, $user);
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
        $where['c.status']       = 1;
        $where['c.user_id']      = $user['user_id'];
        $where[] = array("exp","o.order_status >=2 and o.order_status <= 4 and o.order_reservation = 1");
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
            $this->verifyCode($order, $code, $user);
            //获取日历信息
            $w2['r.product_id'] = $order['product_id'];
            $w2['r.price_id'] = $order['price_id'];
            $w2['r.calendar'] = ['gt', time()];
            $w2['p.product_id'] = ['exp', 'is not null '];
            $calendarlist = Db::name('product_reservationday r')
                            ->field('r.*, sum(`p`.`totalnum`) totalnum, sum(`p`.`usenum`) usenum')
                            ->join('jay_product_reservationprice p', 'p.reservationday_id = r.reservationday_id', 'left')
                            ->where($w2)->group('p.reservationday_id')
                            ->order('r.reservationday_id asc')
                            ->limit(0,30)
                            ->select();
            foreach ($calendarlist as $k=>$v){
                $calendarlist[$k]['day'] = date('m月d日', $v['calendar']);
                $calendarlist[$k]['status'] = $v['totalnum'] <= $v['usenum']?0:1;
                $calendarlist[$k]['lastnumber'] = $v['totalnum']-$v['usenum'];
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
        foreach ($pricelist as $k=>$v){
            $pricelist[$k]['lastnumber'] = $v['totalnum']-$v['usenum'];
        }
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
            $this->verifyCode($order, $code, $user);
            Db::startTrans();
            $reservationprice = Db::name('product_reservationprice')->lock(true)->find($reservationprice_id);
            if($reservationprice){
                if($reservationprice['usenum'] >= $reservationprice['totalnum']){
                    $this->returnApiData('当日预约名额已被抢完，请重新选择其他日期预约', 400);
                }
                $reserDay = Db::name('product_reservationday')->find($reservationprice['reservationday_id']);
                //提前预约
                if($reserDay['preday']*24*60*60+strtotime(date('Y-m-d',time())) > $reserDay['calendar']){
                    $this->returnApiData('请提前'.$reserDay['preday'].'天预约', 400);
                }
                //是否已经预约过
                $rw['order_id'] = $order['order_id'];
                $rw['user_id'] = $user['user_id'];
                $rw['consume_code_id'] = $order['consume_code_id'];
                $hasReservation = Db::name('order_user_reservation')->where($rw)->find();
                if($hasReservation['reservation_status']==1 || $hasReservation['reservation_status']==2){
                    $this->returnApiData('该电子码'.$code.'已经预约成功了，不可重复预约', 400);
                }
                if($hasReservation['reservation_status']==3){
                    $this->returnApiData('该电子码'.$code.'已过期', 400);
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
                    //减库存
                    Db::name('product_reservationprice')->where(['id'=>$reservationprice_id])->update(['usenum'=>['exp','usenum+1']]);
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
                Db::name('order_user_reservation')->where(['reservation_no'=>$orderNo])->update(['reservation_payment'=>$payway]);
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

    /**
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 预约制快递商品预约发货时间
     * 肖亚子
     */
    public function ExpressReservation(){
        try{
            $Token      = input("post.token","","htmlspecialchars,strip_tags");
            $OrderId    = intval(input("post.order_id"));
            $Address_id = intval(input("post.address_id"));
            $Day        = intval(input("post.day"));
            $Remark     = input("post.remark","","htmlspecialchars,strip_tags");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            parent::Tpl_Empty($OrderId,"请求错误",2);
            parent::Tpl_Empty($Address_id,"请选择收货地址",2);
            parent::Tpl_Empty($Day,"请选择发货日期",2);

            if ($Day < time()){
                $this->returnApiData("预约发货日期不能小于当前日期", 400);
            }
            if ($Remark){
                parent::Tpl_StringLength($Remark,"备注不能小于6字大于30字",3,6,30,2);
            }

            $Uid = UserModel::UserFindUid($Token);

            $RessCondition["address_id"] = array("eq",$Address_id);
            $RessCondition["user_id"] = array("eq",$Uid);
            $RessCondition["status"] = array("eq",1);

            $AddressFind = UserAddressModel::UserAddressFind($RessCondition);

            if (!$AddressFind){
                $this->returnApiData("请选择收获地址", 400);
            }

            $Condition["rf.order_id"] = array("eq",$OrderId);
            $Condition["rf.user_id"]  = array("eq",$Uid);
            $FahuoFind = OrderModel::OrderReservationFahuoFind($Condition);

            if ($FahuoFind){
                $this->returnApiData("已预约请勿重复预约", 400);
            }

            $Cash  = OrderModel::TableName();
            $Cash->startTrans();//开启事务

            $FahuoData["order_id"] = $OrderId;
            $FahuoData["user_id"]  = $Uid;
            $FahuoData["day"]      = $Day;
            $FahuoData["remark"]   = $Remark;
            $FahuoData["addtime"]  = time();

            $Data = OrderModel::OrderReservationFahuoUpdate($FahuoData);

            if (!$Data){
                $Cash->rollback();
                $this->returnApiData("预约发货失败", 400);
            }

            $OrCondition["user_id"] = array("eq",$Uid);
            $OrCondition["order_id"] = array("eq",$OrderId);

            $Order = OrderModel::OrderUpdate($OrCondition,array("address_id"=> $Address_id));

            if (!$Order){
                $Cash->rollback();
                $this->returnApiData("预约发货失败", 400);
            }

            $Cash->commit();//成功提交事务
            $this->returnApiData("预约发货成功", 200);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * 自动更新过期电子码
     * @param $order
     * @param $code
     * @param $user
     */
    private function verifyCode($order, $code, $user){
        //判断电子码是否过期
        if($order['product_endusetime'] < time()){
            Db::name('order_consume_code')->where(['consume_code'=>$code, 'user_id'=>$user['user_id']])->update(['status'=>3, 'uptime'=>time()]);
            $this->returnApiData('该订单已经过期,过期时间：'.date('Y-m-d H:i:s', $order['product_endusetime']));
        }
    }
}