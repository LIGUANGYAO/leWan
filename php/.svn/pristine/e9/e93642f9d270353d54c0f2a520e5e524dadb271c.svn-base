<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/2/15
 * Time: 9:50
 * 用户邀请好友海报控制器
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use think\Request;
use app\system\model\PosterModel;

class PosterController extends AdminBaseController{

    public function PosterList(){
        $List = PosterModel::PosterAll();

        $this->assign("data",$List);
        return $this->display('list', true);
    }

    public function PosterAppend(){

        if (Request::instance()->isPost()){
            $Id            = $this->post("id");
            $Poster        = $this->post("poster/a","");
            $Poster["pic"] = $this->post("pic", "");
            $Poster["addtime"] = time();

            if ($Id){
                $Data = PosterModel::PosterEdit(array("id"=>$Id),$Poster);
            }else{
                $Data = PosterModel::PosterAdd($Poster);
            }

            if ($Data === false){
                $this->toError('编辑失败');
            }else{
                $this->toSuccess('添加成功', '', 2);
            }
        }

        $Id = $this->get("id");

        if ($Id){
            $Data = PosterModel::PosterFind(array("id"=>$Id));

            $this->assign("obj" ,$Data);
        }

        return $this->display('edit', false);
    }
}