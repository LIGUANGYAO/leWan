<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/13
 * Time: 11:36
 */

namespace app\api\controller;
use app\api\model\HelpModel;
use app\common\BaseController;

/**
 * 定时任务
 * Class TimerController
 * @package app\api\controller
 */
class TimerController extends BaseController
{

    /**
     * 刷新全局token
     */
    public function refreshAccessToken(){
        $hm = new HelpModel();
        $hm->getAccessToken();
        $this->ajaxReturn('刷新成功', 1);
    }
}