<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/30
 * Time: 15:23
 */

namespace app\system\controller;


use app\common\AdminBaseController;
use app\system\model\UserModel;

class UsertongjiController extends AdminBaseController
{

    public function index(){
        $page = $this->get('page', 1);
        $starttime = $this->get('starttime', '');
        $endtime = $this->get('endtime', '');
        $where['tag'] = ['gt', 20181001];
        if($starttime != ''){
            $where['tag'] = array('between', str_replace('-','',$starttime).',20301201');
            $this->assign('starttime', $starttime);
        }
        if($endtime != ''){
            $where['tag'] = array('between', '20181001,'.str_replace('-','',$endtime));
            $this->assign('endtime', $endtime);
        }
        if($starttime != '' && $endtime != ''){
            $where['tag'] = array('between', str_replace('-','',$starttime).','.str_replace('-','',$endtime));
        }
        $um = new UserModel();
        $data = $um->tongjiList($where, $page);
        $this->assign('data', $data);
        return $this->display('user:tongji', true);
    }
}