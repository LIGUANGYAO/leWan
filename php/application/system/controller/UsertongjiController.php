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
use think\Db;

class UsertongjiController extends AdminBaseController
{

    /**
     * 数据统计
     */
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


    /**
     * 佣金收入排名
     */
    public function top(){
        $ulevel = $this->get('ulevel', 2);
        $sql = "select f.finance_first+f.finance_second+f.finance_operations+f.finance_operationchilds+f.finance_playerhost+f.finance_xrmd as amount , f.user_id, u.mobile, u.nickname, u.floor, a.truename, pu.mobile pumobile, pu.nickname punickname from jay_account_finance f ".
               " left join jay_user u on u.user_id = f.user_id ".
               " left join jay_user_auth a on a.user_id = u.user_id".
               " left join jay_user pu on pu.user_id = u.reid".
               " where f.finance_tag = 0 and u.`level`=".$ulevel.
               " GROUP BY f.user_id ".
               " order by amount desc limit 100;";

        $list = Db::query($sql);
        $this->assign('list', $list);
        $this->assign('ulevel', $ulevel);
        return $this->display('user:commistiontop', true);
    }


    public function bizdata(){
        $page = $this->get('page', 1);
        $ulevel = $this->get('ulevel', 2);
        $sorttype = $this->get('sorttype', 'desc');
        $sortField = $this->get('sortField', 'urecount');
        $sort = $sortField.' '.$sorttype;
        $where['level'] = $ulevel;
        $um = new UserModel();
        $data = $um->getbizdata($sort, $where, $page);
        $this->assign('data', $data);
        $this->assign('ulevel', $ulevel);
        $this->assign('sortField', $sortField);
        return $this->display('user:bizdata', true);
    }


}