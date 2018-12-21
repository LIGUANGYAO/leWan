<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 17:05
 */

namespace app\system\controller;


use app\common\AdminBaseController;
use app\common\model\Levelconst;
use app\common\model\ProcedureModel;
use app\system\model\PaginationModel;
use think\Db;

/**
 * 商品销售分析
 * Class FinanceController
 * @package app\system\controller
 */
class ProductfxController extends AdminBaseController
{

    public function index(){
        $page = $this->get('page', 1);
        $pagesize = 20;
        $key = $this->get('key', '');
        $where['p.product_returnall'] = 0;
        $where['p.product_addtime'] = ['gt', '1543593600'];
        $where['pp.pf_amount'] = ['gt', 0];
        if($key != ''){
            $where['p.product_name'] = ['like', '%'.$key.'%'];
            $this->assign('key', $key);
        }
        //查询总记录
        $count = Db::table('jay_product p')->join('jay_product_performance pp', 'pp.product_id = p.product_id and pp.tag=0', 'left')->where($where)->count();

        $list = Db::table('jay_product p')
            ->field('p.product_id, p.product_name, p.sold_out, p.product_status, p.product_addtime, m.merchant_name')
            ->where($where)
            ->join('jay_merchant m', 'm.merchant_id = p.merchant_id', 'left')
            ->join('jay_product_performance pp', 'pp.product_id = p.product_id and pp.tag=0', 'left')
            ->page($page, $pagesize)
            ->order('p.product_id desc')
            ->select();
        $return['list'] = $list;
        $pagination = new PaginationModel();
        $return['page'] = $pagination->getPage($count, $page, $pagesize);
        $this->assign('data', $return);
        return $this->display('index', true);
    }



    public function data(){
        $type = $this->get('type', 1);
        $id = $this->get('id', 0);
        $product = Db::name('product')->find($id);
        if ($type == 1){
            $sql = "select t.*, u.nickname, u.mobile, u.`level`, pu.nickname as parentnickname, pu.mobile as parentmobile from ( ".
                " select p.userid_second, sum(p.num) num, sum(o.order_payfee) order_payfee from jay_order_product p ".
                " left join jay_order o on o.order_id = p.order_id ".
                "   where o.order_status>1 and p.product_id = ".$id." and p.product_returnall=0 and o.user_id != p.userid_second and p.userid_second>0 ".
                "   group by p.userid_second order by num desc limit 100 ".
                "   ) t ".
                "   left join jay_user u on u.user_id = t.userid_second ".
                "   left join jay_user pu on pu.user_id = u.reid order by num desc";
            $this->assign('title', '直接分享人数据分析');
        }else{
//            $sql = "select t.*, u.nickname, u.mobile, u.`level`, pu.nickname as parentnickname, pu.mobile as parentmobile from ( ".
//                " select p.userid_operations, sum(p.num) num, sum(o.order_payfee) order_payfee from jay_order_product p ".
//                " left join jay_order o on o.order_id = p.order_id ".
//                "   where o.order_status>1 and p.product_id = ".$id." and p.product_returnall=0 and o.user_id != p.userid_operations and p.userid_operations>0 ".
//                "   group by p.userid_operations order by num desc limit 100 ".
//                "   ) t ".
//                "   left join jay_user u on u.user_id = t.userid_operations ".
//                "   left join jay_user pu on pu.user_id = u.reid order by null";

                $sql = "select kk.`level`, kk.mobile, kk.nickname, kk.parentmobile, kk.parentnickname, sum(kk.num) num, sum(kk.order_payfee) order_payfee, kk.userid_operations from (".
                    "  select t.*, u.nickname, u.mobile, u.`level`, pu.nickname as parentnickname, pu.mobile as parentmobile from (  ".
                    "   select p.userid_operations_child userid_operations, sum(p.num) num, sum(o.order_payfee) order_payfee from jay_order_product p  ".
                    "   left join jay_order o on o.order_id = p.order_id    ".
                    "   where o.order_status>1 and p.product_id = ".$id." and p.product_returnall=0 and o.user_id != p.userid_operations_child and p.userid_operations_child>0  ".
                    "   group by p.userid_operations_child order by num desc limit 100    ".
                    "   ) t    ".
                    "   left join jay_user u on u.user_id = t.userid_operations    ".
                    "   left join jay_user pu on pu.user_id = u.reid ".
                    "   union ALL".
                    "   select t.*, u.nickname, u.mobile, u.`level`, pu.nickname as parentnickname, pu.mobile as parentmobile from ( ".
                    "   select p.userid_operations, sum(p.num) num, sum(o.order_payfee) order_payfee from jay_order_product p  ".
                    "   left join jay_order o on o.order_id = p.order_id    ".
                    "   where o.order_status>1 and p.product_id = ".$id." and p.product_returnall=0 and o.user_id != p.userid_operations and p.userid_operations>0    ".
                    "   group by p.userid_operations order by num desc limit 100    ".
                    "   ) t    ".
                    "   left join jay_user u on u.user_id = t.userid_operations    ".
                    "   left join jay_user pu on pu.user_id = u.reid".
                    "   ) kk".
                    "   group by userid_operations order by num desc";
            $this->assign('title', '会员团队数据分析');
        }
        $list = Db::query($sql);
        foreach ($list as $k=>$v){
            $list[$k]['level'] = Levelconst::getName($v['level']);
        }
        $this->assign('list', $list);
        $this->assign('product', $product);
        return $this->display('data', true);
    }


}