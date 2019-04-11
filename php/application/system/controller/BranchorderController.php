<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/4/10
 * Time: 16:31
 * 分公司订单控制器
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\BranchorderModel;
use app\common\model\Ordertransference;

class BranchorderController extends AdminBaseController {
    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取分公司订单列表
     * 肖亚子
     */
    public function BranchOrderList(){
        $Condition = array();
        $Page      = $this->get('page', 1);//分页默认第一页
        $SudId     = $this->get("sudid",0);
        $SudType   = $this->get("sudtype",0);
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

        if ($SudId){
            $Condition["o.fgs_admin_user_id"] = $SudId;
        }
        if ($SudType){
            $Condition["o.fx_admin_user_id"] = array("neq",0);
        }else{
            $Condition["o.fx_admin_user_id"] = 0;
        }
        if ($Title){
            $Condition["o.order_no|u.nickname|u.mobile|m.merchant_name|o.order_fullname|o.order_mobile|au.sub_name|fa.company"]
                = array("like","%$Title%");
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
        $DbossList = BranchorderModel::MerchantDboss();
        $OrderList = BranchorderModel::OrderList($Condition,$Page,20);
        $Count     = BranchorderModel::OrderCount($Condition);
        $List      = Ordertransference::OrderConvert($OrderList[0]);
        $Payfee    = $OrderList[1];

        $Query = array("sudid"=>$SudId,"title" => $Title,"dboss_id"=>$dboss_id,"isexpress" => $Isexpress,"reservation"=>$Reservation,
            "distributiontag"=>$Distributiontag,"payment"=>$Payment);
        $Query = self::Time($StartTime,"starttime",$Query);
        $Query = self::Time($EndTime,"endtime",$Query);

        $this->assign("sudtype",$SudType);
        $this->assign("query",$Query);
        $this->assign('status', $Status);
        $this->assign('count', $Count);
        $this->assign('payfee', $Payfee);
        $this->assign("data",$List);
        $this->assign('dbosslist', $DbossList);
        $Type = $SudId==0?true:false;
        return $this->display("list",$Type);
    }

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取分公司订单详情
     * 肖亚子
     */
    public function BranchOrderDetails(){

        //获取订单相关信息
        $Sudtype = $this->get("sudtype",0);
        $SudId   = $this->get("sudid",0);
        $OrderId = $this->get("order_id");
        $Status  = $this->get("status");

        $DataFind    = BranchorderModel::OrderFind($OrderId);
        $DataConvert = Ordertransference::OrderDetailsConvert($DataFind);

        $Data        = $DataConvert[0];//订单信息
        $Goods       = $DataFind[1];//订单商品信息
        $Calendar    = $DataFind[2];//到店免预约日历数据
        $Reservation = $DataFind[3];//到店预约制商品或免预约商品
        $Delivery    = $DataConvert[2];//快递预约制商品,预约发货信息
        $OrderCode   = $DataFind[5];//电子码
        $OrderMarkup = $DataConvert[3];//电子码预约加价信息

        if($Goods["pricecalendar"]){
            $Goods["pricecalendar"] = json_decode($Goods["pricecalendar"],true);
        }

        if($Data['order_isexpress'] == 1 && $Data['order_reservation'] == 1){
            $http =  $_SERVER['REQUEST_SCHEME']?$_SERVER['REQUEST_SCHEME']:'http';
            $nativeurl= $http.'://'.$_SERVER['SERVER_NAME'].'/wechat_html/page/smsAppointment/smsVerify.html';
            foreach ($OrderCode as &$val){
                if(!empty($val)){
                    $hash = Db::name('order_consume_code')->where(['consume_code'=>$val['consume_code']])->value('hash');
                    if($hash){
                        $val['url'] = $nativeurl."?code={$val['consume_code']}&hash={$hash}";
                    }else{
                        $val['url'] = $nativeurl."?code={$val['consume_code']}&mobile={$Data['order_mobile']}";
                    }
                }
            }
        }

        $this->assign("sudtype",$Sudtype);
        $this->assign("sudid",$SudId);
        $this->assign("status",$Status);
        $this->assign("data",$Data);
        $this->assign("goods",$Goods);
        $this->assign("calendar",$Calendar);
        $this->assign("reservation",$Reservation);
        $this->assign("ordercode",$OrderCode);
        $this->assign("ordermarkup",$OrderMarkup);
        $this->assign("delivery",$Delivery);
        $Type = $SudId==0?true:false;
        return $this->display("view",$Type);
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
}