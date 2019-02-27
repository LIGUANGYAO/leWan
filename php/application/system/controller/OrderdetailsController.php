<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/12
 * Time: 15:26
 * 订单核查控制器
 * 肖亚子
 */
namespace app\system\controller;

use app\api\model\NotifyModel;
use app\common\AdminBaseController;
use app\system\model\OrderdetailsModel;
use Think\Db;


class OrderdetailsController extends AdminBaseController{

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 查询订单
     */
    public function Orderdetail(){

        $Number = $this->get("number");
        if ($Number){
            $OrderId = OrderdetailsModel::OrderIdFind($Number);

            if($OrderId){
                $DataFind    = OrderdetailsModel::OrderFind($OrderId);
                $Data        = $DataFind[0];//订单信息
                $Goods       = $DataFind[1];//订单商品信息
                $Calendar    = $DataFind[2];//到店免预约日历数据
                $Reservation = $DataFind[3];//到店预约制商品或免预约商品
                $Delivery    = $DataFind[4];//快递预约制商品,预约发货信息
                $OrderCode   = $DataFind[5];//电子码
                $OrderMarkup = $DataFind[6];//电子码预约加价信息

                $Uid = $Data["user_id"];

                $User         = OrderdetailsModel::OrderUser($Uid);
                $Transference = self::Transference();

                $Data["typecss"]    = $Transference[0][$Data["order_isexpress"]]["css"];
                $Data["typename"]   = $Transference[0][$Data["order_isexpress"]]["name"];
                $Data["recss"]      = $Transference[1][$Data["order_reservation"]]["css"];
                $Data["rename"]     = $Transference[1][$Data["order_reservation"]]["name"];
                $Data["paycss"]     = $Transference[2][$Data["order_payment"]]["css"];
                $Data["payname"]    = $Transference[2][$Data["order_payment"]]["name"];

                if ($Data["order_isexpress"] == 1){
                    if ($Data["order_status"] == 2){
                        $Data["statuscss"]  = $Transference[4][0]["css"];
                        $Data["statusname"] = $Transference[4][0]["name"];
                    }else{
                        $Data["statuscss"]  = $Transference[3][$Data["order_status"]]["css"];
                        $Data["statusname"] = $Transference[3][$Data["order_status"]]["name"];
                    }
                }elseif ($Data["order_isexpress"] == 2 && $Data["order_reservation"] == 1){
                    if ($Data["order_status"] < 2){
                        $Data["statuscss"]  = $Transference[3][$Data["order_status"]]["css"];
                        $Data["statusname"] = $Transference[3][$Data["order_status"]]["name"];
                    }else{
                        if (!$Delivery){
                            $Data["statuscss"]  = $Transference[4][1]["css"];
                            $Data["statusname"] = $Transference[4][1]["name"];
                        }else{
                            $Data["statuscss"]  = $Transference[3][$Data["order_status"]]["css"];
                            $Data["statusname"] = $Transference[3][$Data["order_status"]]["name"];
                        }
                    }
                }else{
                    $Data["statuscss"]  = $Transference[3][$Data["order_status"]]["css"];
                    $Data["statusname"] = $Transference[3][$Data["order_status"]]["name"];
                }

                if ($Data["order_refundstatus"] > 0){
                    $Data["refundstatuscss"]  = $Transference[5][$Data["order_refundstatus"]]["css"];
                    $Data["refundstatusname"]  = $Transference[5][$Data["order_refundstatus"]]["name"];
                }

                if ($Data["order_isexpress"] == 2 and $Data["order_reservation"] == 2){
                    if ($Data["order_plainday"]){
                        $Data["plaindaycss"]  = $Transference[6][0]["css"];
                        $Data["plaindayname"]  = $Transference[6][0]["name"];
                    }else{
                        $Data["plaindaycss"]  = $Transference[6][1]["css"];
                        $Data["plaindayname"]  = $Transference[6][1]["name"];
                    }
                }

                if($Goods["pricecalendar"]){
                    $Goods["pricecalendar"] = json_decode($Goods["pricecalendar"],true);
                }

                if($OrderMarkup){
                    foreach ($OrderMarkup as $Key=>$Val){
                        $OrderMarkup[$Key]["paycss"]  = $Transference[2][$Val["reservation_payment"]]["css"];
                        $OrderMarkup[$Key]["payname"] = $Transference[2][$Val["reservation_payment"]]["name"];
                    }
                }

                $this->assign("user",$User);
                $this->assign("data",$Data);
                $this->assign("goods",$Goods);
                $this->assign("calendar",$Calendar);
                $this->assign("reservation",$Reservation);
                $this->assign("ordercode",$OrderCode);
                $this->assign("ordermarkup",$OrderMarkup);
                $this->assign("delivery",$Delivery);
            }
        }

        $this->assign("number",$Number);

        return $this->display('detail', true);
    }

    /**
     * @return array
     * 订单状态转中文
     * 肖亚子
     */
    private function Transference(){
        $GoodsType   = array("1" => array("css" => "layui-bg-red", "name" => "到店商品"),
            "2" => array("css" => "layui-bg-green", "name" => "快递商品"),);
        $Reservation = array("0" => array("css" => "layui-bg-gray", "name" => "免预约"),
            "1" => array("css" => "layui-bg-blue", "name" => "预约制"),
            "2" => array("css" => "layui-bg-gray", "name" => "免预约"),
            "3" => array("css" => "layui-btn-radius", "name" => "电话预约"));
        $PayType     = array("1" => array("css" => "layui-bg-green", "name" => "微信公众号支付"),
            "2" => array("css" => "layui-bg-blue", "name" => "支付宝APP支付"),
            "3" => array("css" => "layui-bg-orange", "name" => "银行卡支付"),
            "4" => array("css" => "layui-bg-green", "name" => "微信APP支付"),
            "5" => array("css" => "layui-bg-cyan", "name" => "现金支付[后台下单]"),
        );
        $OrderStatus = array("1" => array("css" => "layui-bg-gray","name" => "待付款"),
            "2" => array("css" => "layui-bg-black","name" => "待发货"),
            "3" => array("css" => "layui-bg-cyan","name" => "待收货"),
            "4" => array("css" => "layui-bg-green","name" => "已完成"),
            "5" => array("css" => "layui-bg-blue","name" => "取消订单"),
            "6" => array("css" => "layui-bg-red","name" => "申请退款"),
            "7" => array("css" => "layui-bg-orange","name" => "申请换货"),
            "0" => array("css" => "layui-bg-black","name" => "订单过期"));
        $OrderBespoke = array("0"=>array("css" => "layui-bg-black","name" => "待使用"),
            "1"=>array("css" => "layui-bg-gray","name" => "待预约发货")
            );
        $OrderRefund = array("1"=>array("css" => "layui-bg-blue","name" => "退款申请中"),
            "2"=>array("css" => "layui-bg-black","name" => "退款驳回"),
            "3"=>array("css" => "layui-bg-green","name" => "退款通过")
        );
        $Delivery = array("0"=>array("css" => "layui-bg-blue","name" => "用户指定发货"),
            "1"=>array("css" => "layui-bg-green","name" => "正常发货")
        );

        return array($GoodsType,$Reservation,$PayType,$OrderStatus,$OrderBespoke,$OrderRefund,$Delivery);
    }


    public function reSendCodeSMS(){
        $order_id = $this->post("orderid");
        if($order_id){
            $field = 'o.*, p.product_name, p.product_returnall, p.product_id, p.price_id,
             p.op_id, p.commission, p.num, p.product_startusetime, p.product_endusetime';
            $order = Db::name('order o')->field($field)
                ->join('jay_order_product p', 'p.order_id = o.order_id', 'left')
                ->where(['o.order_id'=>$order_id])->find();

            $consume_code = Db::name('order_consume_code')->field('consume_code')->where(['order_id'=>$order_id])->select();
            $code = '';
            foreach ($consume_code as $val){
                if($val['consume_code']){
                    $code .= $val['consume_code'].',';
                }
            }
            $config = Db::name('sys_config')->order('sort asc')->column('value', 'field');
            if(!empty($order)){
                $notify = new NotifyModel();
                $notify->sendOrderSms($order, $code, $config);
                return array('code'=>200);
            }else{
                return array('code'=>400,'暂无数据2');
            }
        }else{
            return array('code'=>400,'暂无数据2');
        }
    }
}