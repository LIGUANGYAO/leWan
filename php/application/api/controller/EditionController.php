<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/1/29
 * Time: 11:46
 * 版本接口
 * 肖亚子
 */

namespace app\api\controller;
use Think\Exception;

use think\Db;

class EditionController extends ApiBaseController{

    /**
     * 获取最新版本信号
     * 肖亚子
     */
    public function EditionNew(){
        try{
            $Data = Db::name("sys_edition")->field("versionnumber,status")->order("id desc")->find();
            $this->returnApiData("获取成功", 200,$Data);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }
}