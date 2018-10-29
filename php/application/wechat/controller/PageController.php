<?php
namespace app\wechat\controller;
use app\common\WechatBaseController;
use think\Db;

/**
 * Created by PhpStorm.
 * User: jay
 * Date: 2018/9/29
 * Time: 10:49
 */

class PageController extends WechatBaseController{


    public function index(){
        $list = Db::name('page')->field('id, title, add_time')->order('id desc')->select();
        $this->assign('list', $list);
        return $this->displaySingle('index:h5');
    }


    public function info(){
        $id = intval($this->get('id', 0));
        $page = Db::name('page')->find($id);
        $this->assign('page', $page);
        return $this->displaySingle('index:page');
    }
}