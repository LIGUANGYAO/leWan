<?php

/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/22
 * Time: 10:26
 * 肖亚子
 * 订单控制器
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\common\model\AccountFinanceModel;
use app\common\model\AccountRecordModel;
use app\common\model\Currency;
use app\common\model\CurrencyAction;
use app\common\model\Paymodel;
use app\system\model\ExcelModel;
use think\Request;
use think\Db;
use think\Session;
use app\system\model\OrderModel;
use app\system\model\FinanceModel;

class OrderController extends AdminBaseController {

    /**
     * @return string
     * 获取订单列表数据
     * 肖亚子
     */
    public function OrderList() {
        //获取参数
        $Condition = array();
        $Page      = $this->get('page', 1);//分页默认第一页
        $Status    = $this->get('status', 0);
        $Title     = $this->get('title', '');
        $StartTime = strtotime($this->get("starttime"));
        $EndTime   = strtotime($this->get("endtime"));
        $dboss_id  = $this->get('dboss_id', 0);
        $Isexpress = $this->get('isexpress', 0);
        $Reservation = $this->get('reservation', 0);
        $Distributiontag = $this->get('distributiontag', 0);
        $Payment   = $this->get('payment', 0);

        $Condition = $this->TimeContrast($StartTime,$EndTime,"o.order_addtime",$Condition);
        if ($Title){
            $Condition["o.order_no|u.nickname|u.mobile|m.merchant_name|o.order_fullname|o.order_mobile"] = array("like","%$Title%");
        }
        if ($dboss_id){
            $Condition["m.dboss_id"] = $dboss_id;
        }
        if ($Isexpress){
            $Condition["o.order_isexpress"] = $Isexpress;
        }
        if ($Reservation){
            $Condition["o.order_reservation"] = $Reservation;
        }
        if ($Distributiontag){
            if ($Distributiontag == 1){
                $Condition["pr.distributiontag"] = array("neq",0);
            }else{
                $Condition["pr.distributiontag"] = 0;
            }
        }

        if ($Payment){
            $Condition["o.order_payment"] = $Payment;
        }

        if ($Status){
            if ($Status==8){
                $Condition["o.order_status"] = 0;
            }else{
                $Condition["o.order_status"] = $Status;
            }
        }

        $DbossList = OrderModel::MerchantDboss();
        $OrderList = OrderModel::OrderList($Condition,$Page,50);
        $Count     = OrderModel::OrderCount($Condition);
        $List      = $OrderList[0];
        $Payfee    = $OrderList[1];
        $List      = self::OrderConvert($List);

        $Query = array("title" => $Title,"dboss_id"=>$dboss_id,"isexpress" => $Isexpress,"reservation"=>$Reservation,
            "distributiontag"=>$Distributiontag,"payment"=>$Payment);
        $Query = self::Time($StartTime,"starttime",$Query);
        $Query = self::Time($EndTime,"endtime",$Query);

        $this->assign('count', $Count);
        $this->assign("query",$Query);
        $this->assign('status', $Status);
        $this->assign('payfee', $Payfee);
        $this->assign('data', $List);
        $this->assign('dbosslist', $DbossList);
       // $this->assign('query_str', http_build_query($Query));
        return $this->display('index', true);
    }

    /**
     * @return string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 获取订单详情信息
     * 肖亚子
     */
    public function OrderData(){
        $Condition = array();

        if (Request()->isGet()){
            //获取订单相关信息
            $OrderId = $this->get("order_id");
            $Status  = $this->get("status");

            $DataFind    = OrderModel::OrderFind($OrderId);
            $Data        = $DataFind[0];//订单信息
            $Goods       = $DataFind[1];//订单商品信息
            $Calendar    = $DataFind[2];//到店免预约日历数据
            $Reservation = $DataFind[3];//到店预约制商品或免预约商品
            $Delivery    = $DataFind[4];//快递预约制商品,预约发货信息
            $OrderCode   = $DataFind[5];//电子码
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
            if($Goods["pricecalendar"]){
                $Goods["pricecalendar"] = json_decode($Goods["pricecalendar"],true);
            }

            if($OrderMarkup){
                foreach ($OrderMarkup as $Key=>$Val){
                    $OrderMarkup[$Key]["paycss"]  = $Transference[2][$Val["reservation_payment"]]["css"];
                    $OrderMarkup[$Key]["payname"] = $Transference[2][$Val["reservation_payment"]]["name"];
                }
            }
            if($Data['order_isexpress'] == 1 && $Data['order_reservation'] == 1){
                $http =  $_SERVER['REQUEST_SCHEME']?$_SERVER['REQUEST_SCHEME']:'http';
                $nativeurl= $http.'://'.$_SERVER['SERVER_NAME'].'/wechat_html/page/smsAppointment/smsVerify.html';
                foreach ($OrderCode as &$val){
                    if(!empty($val)){
                        $val['url'] = $nativeurl."?code={$val['consume_code']}&mobile={$Data['order_mobile']}";
                    }
                }
            }

            $this->assign("status",$Status);
            $this->assign("data",$Data);
            $this->assign("goods",$Goods);
            $this->assign("calendar",$Calendar);
            $this->assign("reservation",$Reservation);
            $this->assign("ordercode",$OrderCode);
            $this->assign("ordermarkup",$OrderMarkup);
            $this->assign("delivery",$Delivery);

            return $this->display("view",true);
        }else{
            //修改订单消费码状态
            $OrderId = $this->post("order_id");
            $UserId  = $this->post("user_id");
            $Statuss = $this->post("statuss");
            $Status  = $this->post("status/a");

            foreach ($Status as $Key=>$Val){
                $Condition["order_id"]        = $OrderId;
                $Condition["user_id"]         = $UserId;
                $Condition["consume_code_id"] = $Key;

                $Data["status"] = $Val;
                $Data["uptime"] = time();

                $CodeUp = OrderModel::OrderConsumeCodeUp($Condition,$Data);

                if ($CodeUp){
                    $Action = "管理员：".Session::get('admin.nickname')."修改订单消费码状态为：";
                    $TypeName = $Val == 1?"恢复":"冻结";
                    $CodeLog["user_id"]         = $UserId;
                    $CodeLog["consume_code_id"] = $Key;
                    $CodeLog["action"]          = $Action . $TypeName;
                    $CodeLog["admin_id"]        = Session::get('admin.id');
                    $CodeLog["addtime"]         = time();
                    OrderModel::OrderCodeLogAdd($CodeLog);
                }
            }

            $this->log("修改订单消费码状态：[订单ID:".$OrderId."ID/状态值".json_encode($Status)."]");

            $this->toSuccess("更新成功", url("Order/OrderData",array("order_id"=>$OrderId,"status"=>$Statuss)), 1);
        }

    }

    /**
     * @return string
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 订单进行退款
     * 肖亚子
     */
    public function OrderRefund(){
        if (Request()->isGet()){
            $OrderId = $this->get("id");

            $this->assign("id",$OrderId);
            return $this->display("refund");
        }else{
            $OrderId = $this->get("id");
            $Status  = $this->get("status");//1退款并退佣金 2退佣金不退款 3退款不退佣金

            $OrderFind = OrderModel::OrderRefundFind($OrderId);

            if (!$OrderFind){
                $this->toError("订单不存在,请重新发起退款");
            }

            if($OrderFind["order_status"] == 4){
                $this->toError("订单已完成,不能进行退款");
            }
            if($OrderFind["order_status"] <= 1 || $OrderFind["order_status"] >= 5){
                $this->toError("订单不能进行退款");
            }

            if($OrderFind["order_isexpress"] == 2){//快递商品判断
                if ($OrderFind["order_status"] == 3){
                    $this->toError("订单已发货,不能进行退款");
                }
            }else{
                $CodeList = OrderModel::OrderRefundCode($OrderId);

                foreach ($CodeList as $Key => $Val){
                    if ($Val["status"] == 2 || $Val["reservation_status"] == 2){
                        $this->toError("订单电子码已有使用,不能进行退款");
                        break;
                    }
                }
            }

            $Month   = date("Ym",$OrderFind["order_paytime"]);
            $Time    = strtotime(date("Y-m-d",time()));
            $Paytime = strtotime(date("Y-m-d",$OrderFind["order_paytime"]));

            if ($Time == $Paytime){
                $Type = 1;
            }else{
                $Type = 2;
            }

            $Cash  = OrderModel::TableName();
            $Cash->startTrans();//开启事务

            if ($Status != 3){
                if ($OrderFind["commis_first"] > 0){
                    self::OrderRefundCommission($OrderFind,$OrderFind["userid_first"],$OrderFind["commis_first"],$Cash,$Type,0);
                }
                if ($OrderFind["commis_second"] > 0){
                    self::OrderRefundCommission($OrderFind,$OrderFind["userid_second"],$OrderFind["commis_second"],$Cash,$Type,0);
                }
                if ($OrderFind["commis_operations"] > 0){
                    self::OrderRefundCommission($OrderFind,$OrderFind["userid_operations"],$OrderFind["commis_operations"],$Cash,$Type,0);
                }

                if ($OrderFind["commis_operations_child"] > 0){
                    self::OrderRefundCommission($OrderFind,$OrderFind["userid_operations_child"],$OrderFind["commis_operations_child"],$Cash,$Type,1);
                }
                if ($OrderFind["commis_playerhost_child"] > 0){
                    self::OrderRefundCommission($OrderFind,$OrderFind["userid_playerhost_child"],$OrderFind["commis_playerhost_child"],$Cash,$Type,1);
                }

                if($OrderFind["product_returnall"] == 1){ //新人免单退款
                    self::OrderRefundCommission($OrderFind,$OrderFind["user_id"],$OrderFind["totalmoney"],$Cash,$Type,0);
                }
            }

            if ($Status == 1 || $Status == 3){
                $PayRefund = new Paymodel();

                $Order["transaction_id"] = $OrderFind["transaction_id"];
                $Order["totalfee"]       = $OrderFind["order_totalfee"];

                $WeChat = $PayRefund->wxRefund($Order);

                if ($WeChat["result_code"] != "SUCCESS" ){
                    $Cash->rollback();//失败回滚exit;
                    $this->toError("订单微信退款失败,".json_encode($WeChat,JSON_UNESCAPED_UNICODE ));
                }
            }

            $OrderCondition["order_id"]      = $OrderId;
            $OrderData["order_status"]       = 6;
            $OrderData["order_refundstatus"] = 3;

            $OrderUp = OrderModel::OrderUpDate($OrderCondition,$OrderData);

            if ($OrderUp === false){
                $Cash->rollback();//失败回滚exit;
                $this->toError("订单退款修订单状态失败");
            }

            $RefundData["order_id"]       = $OrderId;
            $RefundData["user_id"]        = $OrderFind["user_id"];
            $RefundData["refund_reason"]  = "平台进行退款";
            $RefundData["refund_status"]  = 3;
            $RefundData["refund_type"]    = $Status;
            $RefundData["refund_uptime"]  = time();
            $RefundData["refund_addtime"] = time();

            $RefundAdd = OrderModel::OrderRefundAdd($RefundData);

            if ($RefundAdd === false){
                $Cash->rollback();//失败回滚exit;
                $this->toError("订单退款添加退款申请失败");
            }

            $RecordData["order_id"]      = $OrderId;
            $RecordData["user_id"]       = $OrderFind["user_id"];
            $RecordData["refund_no"]     = $OrderFind["transaction_id"];
            $RecordData["refund_amount"] = $OrderFind["order_totalfee"];
            $RecordData["refund_time"]   = time();
            $RecordData["remark"]        = "用户订单退款日志";

            $RecordAdd = OrderModel::OrderRefundRecordAdd($RecordData);

            if ($RecordAdd === false){
                $Cash->rollback();//失败回滚exit;
                $this->toError("订单退款添加退款记录失败");
            }


            if ($Status == 1){

                if ($OrderFind["order_isexpress"] == 1 && $OrderFind["order_reservation"] == 1){
                    foreach ($CodeList as $Key => $Val){
                        if ($Val["reservation_addprice"] > 0 && $Val["reservation_status"] == 1){
                            $Order["transaction_id"] = $Val["transaction_id"];
                            $Order["totalfee"]       = $Val["reservation_addprice"];

                            $WeChat = $PayRefund->wxRefund($Order);

                            if ($WeChat["result_code"] != "SUCCESS" ){
                                $Cash->rollback();//失败回滚exit;
                                $this->toError("订单微信退款失败,".json_encode($WeChat,JSON_UNESCAPED_UNICODE ));
                                break;
                            }else{
                                $RecordData["user_id"]       = $Val["user_id"];
                                $RecordData["refund_no"]     = $Val["transaction_id"];
                                $RecordData["refund_amount"] = $Val["reservation_addprice"];
                                $RecordData["remark"]        = "用户订单预约加价退款日志";

                                $RecordAdd = OrderModel::OrderRefundRecordAdd($RecordData);

                                if ($RecordAdd === false){
                                    $Cash->rollback();//失败回滚exit;
                                    $this->toError("订单退款添加退款记录失败");
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            if ($OrderFind["order_isexpress"] == 1){
                foreach ($CodeList as $Key => $Val){
                    $Condition["order_id"]        = $OrderId;
                    $Condition["user_id"]         = $Val["user_id"];
                    $Condition["consume_code_id"] = $Val["consume_code_id"];

                    $Data["status"] = 3;
                    $Data["uptime"] = time();

                    $CodeUp = OrderModel::OrderConsumeCodeUp($Condition,$Data);

                    if ($CodeUp){
                        $Action = "管理员：".Session::get('admin.nickname')."订单退款,电子码修改为过期";
                        $CodeLog["user_id"]         = $Val["user_id"];
                        $CodeLog["consume_code_id"] = $Val["consume_code_id"];
                        $CodeLog["action"]          = $Action;
                        $CodeLog["admin_id"]        = Session::get('admin.id');
                        $CodeLog["addtime"]         = time();
                        OrderModel::OrderCodeLogAdd($CodeLog);
                    }
                }
            }

            if ($Status != 3){
                $RefundRecord = FinanceModel::refundDecodeData($OrderFind["order_totalfee"]);

                if (!$RefundRecord){
                    $Cash->rollback();//失败回滚exit;
                    $this->toError("订单退款统计失败");
                }
            }

            $Cash->commit();//成功提交事务
            $this->log("订单退款成功：[ID:".$OrderId."]");

            $this->toSuccess('退款成功', '', 2);
        }

    }

    /**
     * @param $OrderFind  订单信息
     * @param $Uid        用户id
     * @param $Money      扣除金额
     * @param $Cash       事务
     * @param int $Type   状态 1扣除佣金 2扣除现金
     * @param int $High   大于0代表扣除佣金
     */
    private function OrderRefundCommission($OrderFind,$Uid,$Money,$Cash,$Type = 1,$High = 0){
        $Arm   = new AccountRecordModel();
        $Admin = $Arm->getRecordAttach(session('admin.id'),session('admin.jname'),$OrderFind["order_no"]);
        $Month = date("Ym",$OrderFind["order_paytime"]);

        if ($Type == 1 || $High > 0){
            $CurrencyAction = CurrencyAction::CommissionDecodeBack;
            $Commission     = Currency::Commission;
            $Msg            = "订单退款扣除佣金失败";
        }else{
            $CurrencyAction = CurrencyAction::CashDeducAdmin;
            $Commission     = Currency::Cash;
            $Msg            = "订单退款扣除现金失败";
        }

        if ($Type == 1 || $High > 0){//预估佣金扣除
            $Dduct = $Arm->add($Uid, $OrderFind["order_id"],$Commission,$CurrencyAction,-$Money,$Admin,"平台退款扣除");
        }else{//现金扣除
            $Dduct = $Arm->add($Uid, $OrderFind["order_id"],$Commission,$CurrencyAction,-$Money,$Admin,"平台退款扣除");
        }

        if (!$Dduct){
            $Cash->rollback();//失败回滚exit;
            $this->toError("{$Msg}");
        }

//        if ($Status > 0){
            $Condition["user_id"]  = $Uid;
            $Condition["order_id"] = $OrderFind["order_id"];
            $CommUp = OrderModel::OrderRefundCommission($Month,$Condition);

            if ($CommUp === false){
                $Cash->rollback();//失败回滚exit;
                $this->toError("订单退款修改用户交易记录失败");
            }
//        }
        $Record = FinanceModel::recordDecodeData($Commission,$Money);

        if(!$Record){
            $Cash->rollback();//失败回滚exit;
            $this->toError("订单退款统计后台退款失败");
        }

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

    /**
     * @param $List    订单数据
     * @return mixed
     * 订单数据标识进行中文转换
     * 肖亚子
     */
    private function OrderConvert($List){
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
     * @param $StartTime  开始时间
     * @param $EndTime    结束时间
     * @param $Key        字段
     * @param $Condition  返回组合
     * @return mixed
     */
    public  function TimeContrast($StartTime,$EndTime,$Key,$Condition){

        if (!empty($StartTime) && empty($EndTime)) {
            parent::Tpl_NotGtTime($StartTime,"开始时间不能大于当前时间"); //开始时间不为空和当前时间对比
            $Condition[$Key] = array(array('egt', $StartTime));
        } else if (empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_NotGtTime($EndTime,"结束时间不能大于当前时间"); //结束时间不为空和当前时间对比
            $Condition[$Key] = array(array('lt', $EndTime));
        } else if (!empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_TimeContrast1($StartTime,$EndTime); //开始和结束时间都不为空进行判断
            $Condition[$Key] = array(array('egt', $StartTime), array('elt', $EndTime));
        }

        return $Condition;
    }

    /**
     * @param $Time  转换时间
     * @param $Key   返回字段
     * @param $Query 组合数组
     * @return mixed
     */
    public function Time($Time,$Key,$Query){
        if(!empty($Time)){
            $Query[$Key] = date("Y-m-d H:i:s",$Time);
        }

        return $Query;
    }

    /**
     * 修改
     * Enter description here ...
     */
//    public function view() {
//        if (Request::instance()->isGet()) {
//            $item = Db::name('order o')
//                ->field('o.*, r.username, r.mobile, r.remark, m.title, r.num, r.price, u.nickname')
//                ->where('o.id', Request::instance()->param('id', 0))
//                ->join('order_room r', 'r.order_id = o.id', 'left')
//                ->join('room m', 'm.id = r.room_id', 'left')
//                ->join('member u', 'o.user_id = u.id', 'left')
//                ->order('o.id desc')
//                ->find();
//
//            $service = Db::name('order_service')->where(['order_id'=>$item['id']])->select();
//            $item['services'] = $service;
//
//            $this->assign('obj', $item);
//            return $this->display('view', true);
//        }
//    }

    /**
     * 删除账号
     * Enter description here ...
     */
//    public function delete() {
//        $id = Request::instance()->param('id', 0);
//        $idstr = Request::instance()->post('idstr', '');
//        if ($id > 0) {
//            $obj = Db::name('order')->where('id', $id)->find();
//            $this->log('删除订单：' . $obj['id']);
//            $res = Db::name('order')->where('id='.$id)->update(['del'=>1]);
//        } else {
//            //批量删除
//            $idarray = explode(',', $idstr);
//            foreach ($idarray as $k => $v) {
//                if (!(empty($v))) {
//                    $obj = Db::name('order')->where('id', $v)->find();
//                    $this->log('删除订单：' . $obj['id']);
//                    $res = Db::name('order')->where('id='.$v)->update(['del'=>1]);
//                }
//            }
//        }
//        $this->toSuccess('删除成功');
//    }


//    public function ruzhu() {
//        $id = Request::instance()->param('id', 0);
//        if ($id > 0) {
//            $obj = Db::name('order')->where('id', $id)->find();
//            $this->log('客人入住：' . $obj['id']);
//            $res = Db::name('order')->where('id='.$id)->update(['status'=>2]);
//        }
//        $this->toSuccess('入住成功');
//    }

    /**
     * 后台操作-》单产品批量下单
     */
    public function createOrder(){
        $product_id = input('product_id');
        if (Request()->isGet()){
            $prices = Db::name('product_price')->where(['product_id'=>$product_id])->select();
            $this->assign('prices',$prices);
            $this->assign('product_id',$product_id);
            return $this->display('product:_create_order' );
        }else{
            $price = input('price',0);
            $buynum = input('buynum');
            $user_id = input('user_id');//默认下单用户
            if($user_id<1){
                $user_id= 15439;
            }
            $price_id = input('price_id');
            $product = $this->verfiyProduct($product_id, $price_id,$buynum);
            if(isset($product['code'] ) && $product['code'] == 400){
                return $product;
            }else{

                $data['buynum'] = $buynum;
//                if($user_id==15439){
//                    $data['concat'] = '后台下单';
//                    $data['mobile'] = '';
//                }else{
                    $orderUser = Db::name('user')->where(array('user_id'=>$user_id))->field('nickname,mobile')->find();
                    $data['concat']= $orderUser['nickname'];
                    $data['mobile'] = $orderUser['mobile'];
//                }
                $data['product_id'] = $product_id;
                $data['price_id'] = $price_id;
                $data['price'] = $price;
                $data['remark'] = $this->post('remark', '通过后台管理员下单');
                $data['user_id'] = $user_id;
                $data['time'] = time();
                GLog('后台单品下单','数据'.json_encode($data));
                $data['key'] = getSelfSignStr($data);
                $host =  $_SERVER['HTTP_HOST']?$_SERVER['HTTP_HOST']: $_SERVER['SERVER_NAME'];
                $url =  $host.'/api/Order/createOrder';
                curlPost($url,$data); //curl创建订单
                $this->toSuccess("创建成功",'', 2);
            }
        }

    }

    /**
     * 后台操作-》Excel表导入批量下单
     */
    public function createOrderByExcel(){
        if (!empty ($_FILES ['excel'] ['name'])) {
            $tmp_file = $_FILES ['excel'] ['tmp_name'];
            $file_types = explode(".", $_FILES ['excel'] ['name']);
            $file_type = $file_types [count($file_types) - 1];
            /*判别是不是.xls文件，判别是不是excel文件*/
            if (strtolower($file_type) != "xlsx") {
                $this->error('不支持的Excel文件，请重新上传');
            }
            vendor('phpexcel.PHPExcel');
            vendor('phpexcel.PHPExcel.IOFactory');

            $objReader = \PHPExcel_IOFactory::createReader('Excel2007');
            $obj_PHPExcel = $objReader->load($tmp_file, $encode = 'utf-8');//加载文件内容,编码utf-8
            $excel_array = $obj_PHPExcel->getsheet(0)->toArray();//转换为数组格式
            array_shift($excel_array);//删除第一个数组(标题);
            $datas = [];
            foreach ($excel_array as $k => $v) {
                $datas[$k]['product_id'] = $v[0];
                $datas[$k]['mobile'] = $v[1];
                $datas[$k]['buynum'] = $v[2];
                $datas[$k]['price'] = $v[3];
            }

            $data['concat'] = '用户';
            $data['remark'] = $this->post('remark', '通过后台管理员下单');
            $data['user_id'] =  15439;//下单用户
            $data['time'] = time();
            $data['key'] = getSelfSignStr($data);
            $data['list'] = json_encode($datas);
            $host =  $_SERVER['HTTP_HOST']?$_SERVER['HTTP_HOST']: $_SERVER['SERVER_NAME'];
            $url =  $host.'/api/Order/createBatchOrder';
            curlPost($url,$data); //curl创建订单
            $this->success('创建成功,',url('system/order/orderlist'));

        }
    }

    private function verfiyProduct($product_id, $price_id, $buynum){
        $product = Db::name('product p')
            ->field('c.*, p.product_name, p.product_status, p.product_del, p.product_reviewstatus,
            p.price_type, p.product_returnall, p.product_reservation, p.product_isexpress, 
            p.product_timelimit, p.product_numlimit, p.product_numlimit_num, p.product_starttime, p.product_endtime, 
            p.product_startusetime, p.product_endusetime, p.merchant_id, p.sold_out')
            ->join('product_price c', 'c.product_id = p.product_id', 'left')
            ->join('merchant m', 'm.merchant_id = p.merchant_id', 'left')
            ->where(['p.product_id'=>$product_id, 'c.price_id'=>$price_id, 'm.merchant_status'=>2, 'c.price_status'=>1])
            ->find();
        if(!$product){
            return array('code'=>400,'商品不存在');
        }
//        if($product['sold_out'] == 1){
//            return array('code'=>400,'商品已售罄');
//        }
        if($product['product_isexpress'] == 2 && $product['product_reservation'] == 2){
            return array('code'=>400,'快递类产品不支持后台下单');
        }
        if($product['product_del'] == 1 || $product['product_status'] == 0){
            return array('code'=>400,'商品售罄已下架');
        }
        if($product['product_reviewstatus'] != 2){
            return array('code'=>400,'商品未审核通过');
        }
//        if($product['product_buynum'] >= $product['product_totalnum']){
//            return array('code'=>400,'商品已售罄');
//        }
        if($product['product_buynum']+$buynum > $product['product_totalnum']){
            return array('code'=>400,'商品库存不足');
        }
        if($product['price_type'] == 2){
            return array('code'=>400,'商品价格类型异常');
        }
        $product['product_sku'] = $product['product_totalnum']-$product['product_buynum']; //剩余库存
        return $product;
    }

    /**
     * 导出商品销售数据
     */
    public function downOrderInfo(){
        $pType = input('p_type',1);
        $productId = input('product_id');
        $starttime = input('starttime');
        $endtime = input('endtime');
       # $where['o.order_status'] =array('in','2,3');// array('in','2,3,4');//已支付的
        if($productId){
            $where['p.product_id'] = $productId;
        }
        $tit = '全部销售数据';
        if($pType==2){ //已核销数据
            $where['o.order_status'] = 4;
            $tit = '已核销数据';
        }elseif($pType==3){ //待使用数据
            $where['o.order_status'] = array('in','2,3');
            $tit = '待使用数据';
        }else{ //全部销售数据
            $where['o.order_status'] = array('in','2,3,4');
        }
        $where = $this->TimeContrast(strtotime($starttime),strtotime($endtime),"o.order_addtime",$where);
        $field = "o.order_fullname,o.order_mobile,o.order_idcard,from_unixtime(o.order_plainday,'%Y-%m-%d') ,p.num,p.price,p.product_property,p.product_name,from_unixtime(o.order_addtime,'%Y-%m-%d %H:%i:%s')";
        $list = Db::name('order o')->join('order_product p','o.order_id=p.order_id','left')
            ->field($field)->where($where)->select();
        if(!empty($list)){
            $Column    =  array("联系人","联系电话","身份证","预约（游玩）日期","购买数量","单价","规格（套餐）","产品名","下单时间");
            $em        = new ExcelModel();
            $Date      = date("Y年m月d日H时i分");
            $em->export($Column,$list,"","下单数据",$Date.$tit);
        }else{
            $this->error('暂无数据');
        }
    }
}
