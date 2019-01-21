<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/26
 * Time: 14:46
 * 短信发送记录控制器
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\MsgsendlogModel;

class MsgsendlogController extends AdminBaseController{
    /**
     * @return string
     * 获取短信发送记录
     * 肖亚子
     */
    public function MsgList(){
        $Psize = $this->get("page",1);//当前分页页数默认第一页
        $List  = MsgsendlogModel::MsgSendlogList($Psize,20);

        $this->assign("data",  $List);
        return $this->display('list', true);
    }

}