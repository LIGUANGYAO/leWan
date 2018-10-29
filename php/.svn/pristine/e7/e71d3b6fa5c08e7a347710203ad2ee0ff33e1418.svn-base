<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/26
 * Time: 9:19
 * 退款控制器
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\OrderrefundModel;

class OrderrefundController extends AdminBaseController{

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取退款订单数据
     * 肖亚子
     */
    public function RefundList(){

        $Condition = array();
        $Page      = $this->get('page', 1);//分页默认第一页
        $Status    = $this->get('status', 0);
        $Title     = $this->get('title', '');
        $StartTime = strtotime($this->get("starttime"));
        $EndTime   = strtotime($this->get("endtime"));
        $Type      = $this->get('type', 0);

        if ($Status){
            $Condition["r.refund_status"] = $Status;
        }
        $Condition = self::TimeContrast($StartTime,$EndTime,"o.order_addtime",$Condition);
        if ($Title){
            $Condition["o.order_no|u.nickname|u.mobile|m.merchant_name"] = array("like","%$Title%");
        }
        if ($Type){
            $Condition["r.refund_status"] = $Type;
        }

        $Refund = OrderrefundModel::OrderRefundList($Condition,$Page,50);

        $Transference = self::Transference()[0];

        foreach ($Refund["list"] as $Key => $Val){
            $Refund["list"][$Key]["statuscss"]  = $Transference[$Val["refund_status"]]["css"];
            $Refund["list"][$Key]["statusname"] = $Transference[$Val["refund_status"]]["name"];
        }

        $Count["whole"]    = OrderrefundModel::RefundCount($Condition,null,0,$Status);
        $Count["apply"]    = OrderrefundModel::RefundCount($Condition,array("r.refund_status"=>1),1,$Status);
        $Count["reject"]   = OrderrefundModel::RefundCount($Condition,array("r.refund_status"=>2),2,$Status);
        $Count["complete"] = OrderrefundModel::RefundCount($Condition,array("r.refund_status"=>3),3,$Status);

        $Query = array("title" => $Title,"type"=>$Type);
        $Query = self::Time($StartTime,"starttime",$Query);
        $Query = self::Time($EndTime,"endtime",$Query);

        $this->assign("query",$Query);
        $this->assign("status", $Status);
        $this->assign("data",$Refund);
        $this->assign("count",$Count);
        return $this->display('list', true);
    }

    /**
     * @return array
     * 退货状态转中文
     * 肖亚子
     */
    private function Transference(){
        $BarterStatus = array("1" => array("css" => "layui-bg-gray","name" => "申请中"),
                            "2" => array("css" => "","name" => "驳回"),
                            "3" => array("css" => "layui-bg-green","name" => "退款成功"),);

        return array($BarterStatus);
    }

    /**
     * @param $StartTime  开始时间
     * @param $EndTime    结束时间
     * @param $Key        字段
     * @param $Condition  返回组合
     * @return mixed
     */
    private function TimeContrast($StartTime,$EndTime,$Key,$Condition){

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
    private function Time($Time,$Key,$Query){
        if(!empty($Time)){
            $Query[$Key] = date("Y-m-d H:i:s",$Time);
        }

        return $Query;
    }
}