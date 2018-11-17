<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 17:05
 */

namespace app\system\controller;


use app\common\AdminBaseController;
use app\common\model\ManageFinanceModel;
use app\common\model\Tag;
use app\system\model\FinanceModel;
use Think\Db;

/**
 * 平台的财务统计
 * Class FinanceController
 * @package app\system\controller
 */
class FinanceController extends AdminBaseController
{

    public function index(){

    }


    /**
     * 平台收支统计
     */
    public function table(){
        $page = $this->get('page', 1);
        $starttime = $this->get('starttime', '');
        $endtime = $this->get('endtime', '');
        $where['total_tag'] = ['gt', 20181001];
        if($starttime != ''){
            $where['m.merchant_addtime'] = array('egt', strtotime($starttime));
            $this->assign('starttime', $starttime);
        }
        if($endtime != ''){
            $where['m.merchant_addtime'] = array('elt', strtotime($endtime)+86400);
            $this->assign('endtime', $endtime);
        }
        if($starttime != '' && $endtime != ''){
            $where['m.merchant_addtime'] = array('between', str_replace('-','',$starttime).','.str_replace('-','',$endtime));
        }
        $fm = new FinanceModel();
        $data = $fm->getList($where, $page);
        $this->assign('data', $data);
        return $this->display('table', true);
    }


}