<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/4/10
 * Time: 10:40
 * 后台订单状态转换
 * 肖亚子
 */
namespace app\common\model;

class Ordertransference{

    /**
     * @param $List    订单数据
     * @return mixed
     * 订单列表数据标识进行中文转换
     * 肖亚子
     */
    public static function OrderConvert($List){
        $Transference = self::Transference();

        foreach($List["list"] as $Key=>$Val){
            $List["list"][$Key]["typecss"]    = $Transference[0][$Val["order_isexpress"]]["css"];
            $List["list"][$Key]["typename"]   = $Transference[0][$Val["order_isexpress"]]["name"];
            $List["list"][$Key]["recss"]      = $Transference[1][$Val["order_reservation"]]["css"];
            $List["list"][$Key]["rename"]     = $Transference[1][$Val["order_reservation"]]["name"];
            $List["list"][$Key]["paycss"]     = $Transference[2][$Val["order_payment"]]["css"];
            $List["list"][$Key]["payname"]    = $Transference[2][$Val["order_payment"]]["name"];

            if ($Val["order_isexpress"] == 1){
                if ($Val["order_status"] == 2){
                    $List["list"][$Key]["statuscss"]  = $Transference[4][0]["css"];
                    $List["list"][$Key]["statusname"] = $Transference[4][0]["name"];
                }else{
                    $List["list"][$Key]["statuscss"]  = $Transference[3][$Val["order_status"]]["css"];
                    $List["list"][$Key]["statusname"] = $Transference[3][$Val["order_status"]]["name"];
                }
            }elseif ($Val["order_isexpress"] == 2 && $Val["order_reservation"] == 1){

                if ($Val["order_status"] < 2){
                    $List["list"][$Key]["statuscss"]  = $Transference[3][$Val["order_status"]]["css"];
                    $List["list"][$Key]["statusname"] = $Transference[3][$Val["order_status"]]["name"];
                }else{
                    if (!$Val["address_id"]){
                        $List["list"][$Key]["statuscss"]  = $Transference[4][1]["css"];
                        $List["list"][$Key]["statusname"] = $Transference[4][1]["name"];
                    }else{
                        $List["list"][$Key]["statuscss"]  = $Transference[3][$Val["order_status"]]["css"];
                        $List["list"][$Key]["statusname"] = $Transference[3][$Val["order_status"]]["name"];
                    }
                }
            }else{
                $List["list"][$Key]["statuscss"]  = $Transference[3][$Val["order_status"]]["css"];
                $List["list"][$Key]["statusname"] = $Transference[3][$Val["order_status"]]["name"];
            }

            if ($Val["order_refundstatus"] > 0){
                $List["list"][$Key]["refundstatuscss"]  = $Transference[5][$Val["order_refundstatus"]]["css"];
                $List["list"][$Key]["refundstatusname"]  = $Transference[5][$Val["order_refundstatus"]]["name"];
            }

            if ($Val["order_isexpress"] == 2 and $Val["order_reservation"] == 2){
                if ($Val["order_plainday"]){
                    $List["list"][$Key]["plaindaycss"]  = $Transference[6][0]["css"];
                    $List["list"][$Key]["plaindayname"]  = $Transference[6][0]["name"];
                }else{
                    $List["list"][$Key]["plaindaycss"]  = $Transference[6][1]["css"];
                    $List["list"][$Key]["plaindayname"]  = $Transference[6][1]["name"];
                }
            }
        }

        return $List;
    }

    /**
     * @param $DataFind  订单详情数据
     * @return array
     * 订单详情数据进行标识转换
     * 肖亚子
     */
    public static function OrderDetailsConvert($DataFind){

        $Data        = $DataFind[0];//订单信息
        $Delivery    = $DataFind[4];//快递预约制商品,预约发货信息
        $OrderMarkup = $DataFind[6];//电子码预约加价信息

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

        if($OrderMarkup){
            foreach ($OrderMarkup as $Key=>$Val){
                $OrderMarkup[$Key]["paycss"]  = $Transference[2][$Val["reservation_payment"]]["css"];
                $OrderMarkup[$Key]["payname"] = $Transference[2][$Val["reservation_payment"]]["name"];
            }
        }


        return array($Data,$Delivery,$OrderMarkup);
    }

    /**
     * @return array
     * 订单状态转中文
     * 肖亚子
     */
    public static function Transference(){
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
            "3" => array("css" => "layui-bg-blue","name" => "待收货"),
            "4" => array("css" => "layui-bg-green","name" => "已完成"),
            "5" => array("css" => "layui-bg-blue","name" => "取消订单"),
            "6" => array("css" => "layui-bg-red","name" => "申请退款"),
            "7" => array("css" => "layui-bg-orange","name" => "申请换货"),
            "0" => array("css" => "layui-bg-black","name" => "订单过期"));
        $OrderBespoke = array("0"=>array("css" => "layui-bg-blue","name" => "待使用"),
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
}