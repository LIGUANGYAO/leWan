<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/19
 * Time: 17:06
 * 订单支付成功订单查询接口
 * 肖亚子
 */

namespace app\api\controller;
use Think\Exception;
use app\api\model\OrderModel;
use app\api\model\UserModel;

class OrdersubscribeController extends ApiBaseController{

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取订单是不是预约制的
     * 肖亚子
     */
    public function OrderType(){
        try{
            $Token    = input("post.token","","htmlspecialchars,strip_tags");
            $Order_No = input("post.order_no","","htmlspecialchars,strip_tags");
            $CodeData = array();

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Uid = UserModel::UserFindUid($Token);

            $Condition["o.user_id"]  = array("eq",$Uid);
            $Condition["o.order_no"] = array("eq",$Order_No);

            $Field = "o.order_id,o.order_no,o.order_isexpress as express,order_reservation as reservation,o.order_fullname as fullname,o.order_mobile as mobile,
                        o.order_leave as remarks,m.merchant_name as shopname,p.product_name,p.price,pr.distributiontag,pp.price_market as settle,p.num,
                        p.product_startusetime as startusetime,p.product_endusetime as endusetime";

            $OrderFind = OrderModel::OrderFind($Condition,$Field);

            if ($OrderFind){
                $OrderFind["code"] = "";
                if ($OrderFind["express"] == 1){
                    $CodeCondition["cc.order_id"] = array("eq",$OrderFind["order_id"]);
                    $CodeCondition["cc.user_id"]  = array("eq",$Uid);

                    if ($OrderFind["distributiontag"] == 0){
                        $CodeList = OrderModel::OrderConsumeCodeList($CodeCondition);
                        foreach ($CodeList as $Key => $Val ){
                            $Data["consume_code"] = $Val["consume_code"];
                            $Data["status"]       = $Val["status"];
                            $CodeData[] = $Data;
                        }
                    }

                    $OrderFind["code"] = $CodeData;
                }
                $this->returnApiData("获取成功", 200,$OrderFind);
            }else{
                $this->returnApiData("获取失败", 400);
            }

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }

}