<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 17:05
 */

namespace app\system\controller;


use app\common\AdminBaseController;
use app\common\model\MerchantAccountModel;
use app\common\model\MerchantAccountRecordModel;
use app\common\model\Tag;
use app\system\model\MerchantModel;
use Think\Db;

/**
 * 虚拟号业绩统计
 * Class FinanceController
 * @package app\system\controller
 */
class VitualperformanceController extends AdminBaseController
{


    public function index(){
        $this->assign('page_title', '财务 > 虚拟号业绩 (实时统计)');
        //查询明细
        $where['u.reg_type'] = 2;
        $where['up.tag'] = 0;
        $List = Db::name('user_performance up')
            ->field('up.*, u.nickname ')
            ->join('jay_user u', 'u.user_id = up.user_id', 'left')
            ->where($where)
            ->order('up.id asc')->select();
        $this->assign('list', $List);
        return $this->display('Vitualperformance:user', true);
    }

    public function month(){
        $this->assign('page_title', '财务 > 虚拟号业绩 (按月统计)');
        $user_id = $this->get('id');
        //查询明细
        $where['up.tag'] = ['between', '201810,203010'];
        $where['up.user_id'] = $user_id;
        $where['u.reg_type'] = 2;
        $List = Db::name('user_performance up')
            ->field('up.*, u.nickname ')
            ->join('jay_user u', 'u.user_id = up.user_id', 'left')
            ->where($where)
            ->order('up.id asc')->select();
        $this->assign('list', $List);
        return $this->display('Vitualperformance:user_month', true);
    }

    public function day(){
        $this->assign('page_title', '财务 > 商品销量统计 > 按日统计');
        $user_id = $this->get('id');
        $tag = $this->get('tag', 0);
        //查询明细
        $where['up.tag'] = ['between', $tag.'01,'.$tag.'31'];
        $where['up.user_id'] = $user_id;
        $where['u.reg_type'] = 2;
        $List = Db::name('user_performance up')
            ->field('up.*, u.nickname ')
            ->join('jay_user u', 'u.user_id = up.user_id', 'left')
            ->where($where)
            ->order('up.id asc')->select();
        $this->assign('list', $List);
        return $this->display('Vitualperformance:user_day', true);
    }


    public function info(){
        $merchantId = $this->get('merchant_id');
        $starttime = $this->get('starttime', '');
        $endtime = $this->get('endtime', '');
        $startmonth = date('Yd',time());
        $endmonth = date('Yd',time());
        $condition = array();
        if($starttime != ''){
            $startmonth = date('Yd',strtotime($starttime));
            $this->assign('starttime', $starttime);
        }
        if($endtime != ''){
            $endmonth = date('Yd',strtotime($endtime));
            $this->assign('endtime', $endtime);
        }
        $condition = $this->TimeContrast(strtotime($starttime),strtotime($endtime),"ma.record_addtime",$condition);
        $where['account_tag'] = array('neq',Tag::get());
        $condition['m.merchant_id']=$merchantId;
        if($endmonth==$startmonth){ //选择同一月的日期查询
            $list= MerchantAccountRecordModel::getMerchantAccountInfoList($condition,'',$startmonth);
        }else{ //跨月查询（分表查询）
            $months = $this->getMonth(strtotime($starttime) ,strtotime($endtime));
            if(!empty($months)){
                $condition['m.merchant_id']=$merchantId;
                $list = array();
                foreach ($months as $month){
                    $item = MerchantAccountRecordModel::getMerchantAccountInfoList($condition,'',$month);
                    $list = array_merge($list,$item);
                }
            }
        }
        $this->assign('list', $list);
        return $this->display('merchant:account-info', true);
    }

    /**
     * 获取两个时间段中所有月份
     * @param $startTime 开始时间戳
     * @param $len
     * @return array
     */
    public function getMonth($startTime,$endtime){
        $monarr[] = date('Ym',$startTime); // 当前月
        while( ($startTime = strtotime('+1 month', $startTime)) <= $endtime){
            $monarr[]= date('Ym',$startTime); // 取得递增月;
        }
        return $monarr;
    }

}