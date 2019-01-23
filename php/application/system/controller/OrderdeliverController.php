<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/1/18
 * Time: 10:10
 * 快递预约订单控制器
 * 肖亚子
 */
namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\OrderdeliverModel;

class OrderdeliverController extends AdminBaseController{
    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取预约快递信息
     * 肖亚子
     */
    public function DeliverList(){
        $Condition = array();
        $Page      = $this->get('page', 1);//分页默认第一页
        $Status    = $this->get('status', 0);
        $Title     = $this->get('title', '');
        $StartTime = strtotime($this->get("starttime"));
        $EndTime   = strtotime($this->get("endtime"));

        $Condition = $this->TimeContrast($StartTime,$EndTime,"f.day",$Condition);

        if ($Title){
            $Condition["o.order_no|m.merchant_alias|op.product_name"] = array("like","%$Title%");
        }
        if ($Status){
            $Condition["o.order_status"] = $Status;
        }

        $Data = OrderdeliverModel::ExpressList($Condition,$Page,5);

        $Query = array("title" => $Title,"status" => $Status);
        $Query = self::Time($StartTime,"starttime",$Query);
        $Query = self::Time($EndTime,"endtime",$Query);

        $this->assign("query",$Query);
        $this->assign("data",$Data);
        return $this->display("list",true);
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

}