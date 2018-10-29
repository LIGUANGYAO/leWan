<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/26
 * Time: 16:30
 * 消费码日志控制器
 * 肖亚子
 */
namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\OrderconsumecodelogModel;

class OrderconsumecodelogController extends AdminBaseController{

    public function ConsumeCodeLogList(){
        $Condition   = array();
        $Page        = $this->get('page', 1);//分页默认第一页
        $Title       = $this->get('title', '');
        $StartTime   = strtotime($this->get("starttime"));
        $EndTime     = strtotime($this->get("endtime"));

        $Condition = self::TimeContrast($StartTime,$EndTime,"l.addtime",$Condition);
        if ($Title){
            $Condition["c.consume_code|o.order_no|u.nickname|u.mobile|m.merchant_name"] = array("like","%$Title%");
        }

        $Data = OrderconsumecodelogModel::CodeLogList($Condition,$Page,50);

        $Query = array("title" => $Title);
        $Query = self::Time($StartTime,"starttime",$Query);
        $Query = self::Time($EndTime,"endtime",$Query);

        $this->assign("query",$Query);
        $this->assign('data', $Data);
        return $this->display("list",true);
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