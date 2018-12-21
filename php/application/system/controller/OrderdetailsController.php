<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/12
 * Time: 15:26
 * 订单详情数据查询
 * 肖亚子
 */
namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\OrderdetailsModel;

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
                    if (!$Delivery){
                        $Data["statuscss"]  = $Transference[4][1]["css"];
                        $Data["statusname"] = $Transference[4][1]["name"];
                    }else{
                        $Data["statuscss"]  = $Transference[3][$Data["order_status"]]["css"];
                        $Data["statusname"] = $Transference[3][$Data["order_status"]]["name"];
                    }
                }else{
                    $Data["statuscss"]  = $Transference[3][$Data["order_status"]]["css"];
                    $Data["statusname"] = $Transference[3][$Data["order_status"]]["name"];
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
            "2" => array("css" => "layui-bg-gray", "name" => "免预约"),);
        $PayType     = array("1" => array("css" => "layui-bg-green", "name" => "微信公众号支付"),
            "2" => array("css" => "layui-bg-blue", "name" => "支付宝APP支付"),
            "3" => array("css" => "layui-bg-orange", "name" => "银行卡支付"),
            "4" => array("css" => "layui-bg-green", "name" => "微信APP支付"),
            "5" => array("css" => "layui-bg-green", "name" => "后台下单核算"),
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

        return array($GoodsType,$Reservation,$PayType,$OrderStatus,$OrderBespoke);
    }

}