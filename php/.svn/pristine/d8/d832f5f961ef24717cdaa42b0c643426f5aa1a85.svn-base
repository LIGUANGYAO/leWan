<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/12
 * Time: 10:26
 * 肖亚子
 * 城市地区控制器
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\AreaModel;
use Think\Db;
use Common\Model\AreasModel;
//use Org\Util\String;
use think\Request;
use app\common\tools\Visitor;

class AreaController extends AdminBaseController{

    /***
     * @return string
     * 获取城市列表控制器
     * 肖亚子
     */
    public function AreaList(){

        $Condition = array();//定义查询条件默认空
        $Psize     = $this->get("page",1);//当前分页页数默认第一页
        $Code      = $this->get("areacode");//获取城市编码
        $Pcode     = $this->get("pcode");//获取省份编码
        $AreaType  = $this->get("type",1);//获取当前类型,默认第一级

        if($AreaType == 1){
            $GradeType = $AreaType + 1;
        }elseif($AreaType == 2){
            $Pcode              = $Code;
            $GradeType          = $AreaType + 1;
            $Condition["pcode"] = array('eq',$Code);
        }elseif ($AreaType == 3){
            $Condition["ccode"] = array("eq",$Code);
        }

        //查询城市列表
        $AreasData = AreaModel::ProvenceList($Condition,$AreaType,$Psize,50);

        $this->assign("data",  $AreasData);
        $this->assign("code",  $Code);
        $this->assign("pcode", $Pcode);
        $this->assign("type", $AreaType);
        $this->assign("gradetype", $GradeType);

        return $this->display('list', true);
    }

    public function AreaData(){
        $Condition = array();//定义查询条件默认空

        if(Request()->isGet()){
            $AreaId   = $this->get("id");//获取城市ID
            $Code     = $this->get("areacode");//获取城市编码
            $Pcode    = $this->get("pcode");//获取省份编码
            $AreaType = $this->get("type",1);//获取当前类型,默认第一级

            if ($AreaType == 1){
                $Condition["id"] = array("eq",$AreaId);
            }
            //查询城市内容
            $AreaFind = AreaModel::RegionAreaFind($Condition,$AreaType,$Pcode);

            $this->assign("data",  $AreaFind);
            $this->assign("code",  $Code);
            $this->assign("pcode", $Pcode);
            $this->assign("type", $AreaType);

            return $this->display('areadata', false);
        }else{
            $AreaId   = $this->post("id");//获取城市ID
            $AreaType = $this->post("type",1);//获取当前类型,默认第一级
            $CityName = $this->post("cityname");//城市名称

            parent::Tpl_NoSpaces($CityName,"请输入城市名");
            parent::Tpl_StringLength($CityName,"城市名称不能小于1字大于20字",3,1,20);

            $Condition["id"] = array("eq",$AreaId);

            if ($AreaType  == 1){
                $Data["provence"] = $CityName;
            }elseif ($AreaType == 2){
                $Data["city"]     = $CityName;
            }else{
                $Data["area"]     = $CityName;
            }
            //
            $AreasUp = AreaModel::AreaUpdata($Condition,$Data,$AreaType);

            if ($AreasUp) {
                $this->log("修改城市名称：[ID:".$AreaId."更改为".$CityName."]");
                $this->toSuccess('城市更新成功', '', 2);
            }else{
                $this->toError('城市更新失败');
            }
        }

    }

}