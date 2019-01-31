<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/1/28
 * Time: 11:47
 * 版本管理控制器
 * 肖亚子
 */
namespace  app\system\controller;

use app\common\AdminBaseController;
use Think\Db;

class EditionController extends AdminBaseController{

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取全部版本数据
     * 肖亚子
     */
    public function EditionList(){

        $List = Db::name("sys_edition")->order("id desc")->select();


        $this->assign("list",$List);
        return $this->display("list",true);
    }

    /**
     * @return string
     * 添加版本型号
     * 肖亚子
     */
    public function EditionEdit(){
        if (request()->isPost()){
            $VersionNumber = $this->post("versionnumber","");
           // $Status = $this->post("status","1");

            parent::Tpl_Empty($VersionNumber,"请输入版本号");
            parent::Tpl_FullSpace($VersionNumber,"请输入正确版本号");

            $Data["versionnumber"] = $VersionNumber;
            $Data["status"]        = 2;
            $Data["addtime"]       = time();

            $Add = Db::name("sys_edition")->insert($Data);

            if ($Add){
                $this->toSuccess('添加成功', '', 2);
            }else{
                $this->toError("添加失败");
            }
        }

        return $this->display("edit",false);
    }
}