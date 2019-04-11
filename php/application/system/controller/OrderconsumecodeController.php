<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/26
 * Time: 11:24
 * 预约订单消费码控制器
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\OrderconsumecodeModel;
use think\Request;

class OrderconsumecodeController extends AdminBaseController{
    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取订单消费码列表
     * 肖亚子
     */
    public  function ConsumeCodeList(){
        $Condition   = array();
        $Page        = $this->get('page', 1);//分页默认第一页
        $Status      = $this->get('status', 0);
        $Title       = $this->get('title', '');
        $UpstartTime = strtotime($this->get("upstarttime"));
        $UpendTime   = strtotime($this->get("upendtime"));
        $StartTime   = strtotime($this->get("starttime"));
        $EndTime     = strtotime($this->get("endtime"));
        $Type        = $this->get('type', 0);

        if ($Status){
            $Condition["c.status"] = $Status;
        }
        $Condition = self::ContrastTime($UpstartTime,$UpendTime,"c.uptime",$Condition);
        $Condition = self::ContrastTime($StartTime,$EndTime,"c.addtime",$Condition);
        if ($Title){
            $Condition["c.consume_code|o.order_no|u.nickname|u.mobile|m.merchant_name"] = array("like","%$Title%");
        }
        if ($Type){
            $Condition["c.status"] = $Type;
        }

        $Data = OrderconsumecodeModel::CodeList($Condition,$Page,50);

        $Transference = self::Transference()[0];

        foreach ($Data["list"] as $Key => $Val){
            $Data["list"][$Key]["statuscss"] = $Transference[$Val["status"]]["css"];
            $Data["list"][$Key]["statusname"] = $Transference[$Val["status"]]["name"];
        }

        $Count["whole"]       = OrderconsumecodeModel::CodeCount($Condition,null,0,$Status);
        $Count["notused"]     = OrderconsumecodeModel::CodeCount($Condition,array("c.status"=>1),1,$Status);
        $Count["alreadyused"] = OrderconsumecodeModel::CodeCount($Condition,array("c.status"=>2),2,$Status);
        $Count["expired"]     = OrderconsumecodeModel::CodeCount($Condition,array("c.status"=>3),3,$Status);
        $Count["frozen"]      = OrderconsumecodeModel::CodeCount($Condition,array("c.status"=>4),4,$Status);

        $Query = array("title" => $Title,"type"=>$Type);
        $Query = self::Time($UpstartTime,"upstarttime",$Query);
        $Query = self::Time($UpendTime,"upendtime",$Query);
        $Query = self::Time($StartTime,"starttime",$Query);
        $Query = self::Time($EndTime,"endtime",$Query);

        $this->assign("query",$Query);
        $this->assign('status', $Status);
        $this->assign('count', $Count);
        $this->assign("data",$Data);
        return $this->display("list",true);
    }

    /**
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 批量修改消费码状态
     * 肖亚子
     */
    public function ConsumeCodeBatch(){
        if (Request::instance()->isAjax()){
            $Id   = $this->get("idstr","");
            $Type = $this->get("type",1);

            if ($Id){
                if ($Type == 1){
                    $Data["status"] = 4;
                }else{
                    $Data["status"] = 1;
                }


                $Condition[] = array("exp","instr(concat(',','$Id',','),concat(',',consume_code_id,','))");
               OrderconsumecodeModel::CodeUpdate($Condition,$Data);
            }

            $this->log("批量修改消费码状态:[ID:".$Id."]");

            $this->toSuccess('消费码批量修改成功',1);
        }

    }

    /**
     * @return array
     * 订单状态转中文
     * 肖亚子
     */
    private function Transference(){
        $CodeStatus = array("1" => array("css" => "layui-bg-gray","name" => "未使用"),
                            "2" => array("css" => "layui-bg-green","name" => "已使用"),
                            "3" => array("css" => "layui-bg-black","name" => "已过期"),
                            "4" => array("css" => "layui-bg-orange","name" => "已冻结"),);

        return array($CodeStatus);
    }

    /**
     * @param $StartTime  开始时间
     * @param $EndTime    结束时间
     * @param $Key        字段
     * @param $Condition  返回组合
     * @return mixed
     */
    private function ContrastTime($StartTime,$EndTime,$Key,$Condition){

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