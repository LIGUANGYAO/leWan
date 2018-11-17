<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/16
 * Time: 14:48
 */

namespace app\system\model;


use think\Db;

class FinanceModel
{

    public function getList($map=array(), $pagenow=1, $pagesize=10){
        //查询总记录
        $count = Db::name('manage_finance')->where($map)->count();

        $list = Db::name('manage_finance')->where($map)
            ->page($pagenow, $pagesize)
            ->order(' total_tag desc')
            ->select();
        $return['heji'] = [];
        foreach ($list as $k=>$v){
            $list[$k]['total_tag'] = substr($v['total_tag'],0,4).'-'.substr($v['total_tag'],4,2).'-'.substr($v['total_tag'],6,2);
            $return['heji']['total_order_business'] += $v['total_order_business'];
            $return['heji']['total_order_payfee'] += $v['total_order_payfee'];
            $return['heji']['total_order_coupon'] += $v['total_order_coupon'];
            $return['heji']['total_order_settle'] += $v['total_order_settle'];
            $return['heji']['total_order_productnum'] += $v['total_order_productnum'];
            $return['heji']['total_order_addfee'] += $v['total_order_addfee'];
            $return['heji']['total_order_commission'] += $v['total_order_commission'];
            $return['heji']['total_jiesuan_commission'] += $v['total_jiesuan_commission'];
            $return['heji']['total_withdraw'] += $v['total_withdraw'];
            $return['heji']['total_taxfee'] += $v['total_taxfee'];
            $return['heji']['total_merchant_settle'] += $v['total_merchant_settle'];
            $return['heji']['total_business_user'] += $v['total_business_user'];
            $return['heji']['total_active_user'] += $v['total_active_user'];
            $return['heji']['total_level2_user'] += $v['total_level2_user'];
            $return['heji']['total_level3_user'] += $v['total_level3_user'];
            $return['heji']['total_level4_user'] += $v['total_level4_user'];
            $return['heji']['total_level2_user'] += $v['total_level5_user'];
        }
        $return['list'] = $list;
        //总计
        $return['zongji'] = Db::name('manage_finance')->field(
            "sum(total_order_business) total_order_business,".
            "sum(total_order_payfee) total_order_payfee,".
            "sum(total_order_coupon) total_order_coupon,".
            "sum(total_order_settle) total_order_settle,".
            "sum(total_order_productnum) total_order_productnum,".
            "sum(total_order_addfee) total_order_addfee,".
            "sum(total_order_commission) total_order_commission,".
            "sum(total_jiesuan_commission) total_jiesuan_commission,".
            "sum(total_withdraw) total_withdraw,".
            "sum(total_taxfee) total_taxfee,".
            "sum(total_merchant_settle) total_merchant_settle,".
            "sum(total_business_user) total_business_user,".
            "sum(total_active_user) total_active_user,".
            "sum(total_level2_user) total_level2_user,".
            "sum(total_level3_user) total_level3_user,".
            "sum(total_level4_user) total_level4_user,".
            "sum(total_level5_user) total_level5_user"
        )->where($map)->find();
        $pagination = new PaginationModel();
        $return['page'] = $pagination->getPage($count, $pagenow, $pagesize);
        return $return;
    }
}