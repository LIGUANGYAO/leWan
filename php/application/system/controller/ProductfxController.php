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
use app\system\model\ExcelModel;
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
        $miandan = $this->get('miandan', 0);
        $sold_out = $this->get('sold_out', 0);
        $page = $this->get('page', 1);
        $pagesize = 20;
        $key = $this->get('key', '');
        //$where['p.product_returnall'] = 0;
        $where['p.product_addtime'] = ['gt', '1542816000'];
        $where['pp.pf_amount'] = ['gt', 0];
        if($key != ''){
            $where['p.product_name'] = ['like', '%'.$key.'%'];
            $this->assign('key', $key);
        }
        if($miandan > 0){
            $where['p.product_returnall'] = $miandan-1;
            $this->assign('miandan', $miandan);
        }
        if($sold_out > 0){
            $where['p.sold_out'] = $sold_out-1;
            $this->assign('sold_out', $sold_out);
        }
        //查询总记录
        $count = Db::table('jay_product p')->join('jay_product_performance pp', 'pp.product_id = p.product_id and pp.tag=0', 'left')->where($where)->count();

        $list = Db::table('jay_product p')
            ->field('p.product_id, p.product_name, p.product_returnall, p.sold_out, p.product_status, p.product_addtime, m.merchant_name, p.obtained_time, p.product_starttime, p.product_endtime')
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


    /**
     * 直卖份数
     */
    public function datafen(){
        $ids = $this->get('ids', '');
        $whereproduct = ' p.product_id in ('.trim($ids,',').')';
        $product = Db::name('product')->find(explode(',',trim($ids,','))[0]);
        if(strpos($this->get("starttime"),':')===false
            && strpos($this->get("endtime"),':')===false){
            $StartTime = $this->get("starttime");
            $EndTime   = $this->get("endtime");
        }else{
            $StartTime = strtotime($this->get("starttime"));
            $EndTime   = strtotime($this->get("endtime"));
        }
        $this->assign('ids', $ids);
        $this->assign('EndTime',$EndTime ? date('Y-m-d H:i:s',$EndTime):'');
        $this->assign('StartTime', $StartTime ? date('Y-m-d H:i:s',$StartTime):'');

        $Condition='';
        $Condition   = self::TimeContrast($StartTime,$EndTime,"o.order_addtime",$Condition,'str');
        $sql = "SELECT t.*, sum(t.num) num from (
                      select p.userid_first, u.nickname, u.mobile, u.`level`, sum(p.num) num, reu.nickname parentnickname, reu.mobile parentmobile from jay_order o
                      left join jay_order_product p on p.order_id=o.order_id
                      left join jay_user u on u.user_id = p.userid_first
                      left join jay_user reu on reu.user_id = u.reid
                      where".$whereproduct." and p.product_returnall=0 and o.user_id!=p.userid_first and p.userid_first>0 and o.order_status>1 ".($Condition!=''? ' and '.$Condition:'')."
                      group by p.userid_first
                        union all
                      select p.userid_second userid_first, fen.nickname, fen.mobile, fen.`level`, sum(p.num) num, reu.nickname parentnickname, reu.mobile parentmobile from jay_order o
                      left join jay_order_product p on p.order_id=o.order_id
                      left join jay_user byer on byer.user_id = o.user_id
                      left join jay_user fen on fen.user_id = p.userid_second
                      left join jay_user reu on reu.user_id = fen.reid
                      where ".$whereproduct." and p.product_returnall=0 and byer.`level`>1 and o.user_id=p.userid_first and o.order_status>1 ".($Condition!=''? ' and '.$Condition:'')."
                      group by p.userid_second
                      ) t
                      group by t.userid_first
                      order by num desc;";
        $this->assign('title', $title='直接分享人数据分析,统计单数;统计商品id='.$ids);
        $excel     = $this->get('excel', 0);
        $list = Db::query($sql);
        foreach ($list as $k=>$v){
            $list[$k]['level'] = Levelconst::getName($v['level']);
        }
        if($excel && !empty($list)){
            $Column    =  array('达人UID','达人昵称','联系电话','用户等级','购买份数','达人上级用户','达人上级用户手机号');
            $em   = new ExcelModel();
            $em->export($Column,$list,"","数据分析","商品ID{$product['product_id']}直卖份数数据分析");
        }else{
            $this->assign('list', $list);
            $this->assign('product', $product);
            return $this->display('datafen', true);
        }
    }


    /**
     * 销售数据分析
     */
    public function data(){

        $type = $this->get('type', 1);
        $id = $this->get('id', 0);
        $ids = $this->get('ids', '');
        $product = Db::name('product')->find($id);
        $excel     = $this->get('excel', 0);
        if($id >= 0){
            $whereproduct = ' p.product_id ='.$id;
        }else{
            $whereproduct = ' p.product_id in ('.trim($ids,',').')';
        }
        if(strpos($this->get("starttime"),':')===false
            && strpos($this->get("endtime"),':')===false){
            $StartTime = $this->get("starttime");
            $EndTime   = $this->get("endtime");
        }else{
            $StartTime = strtotime($this->get("starttime"));
            $EndTime   = strtotime($this->get("endtime"));
        }
        $this->assign('id', $id);
        $this->assign('ids', $ids);
        $this->assign('type', $type);
        $this->assign('EndTime',$EndTime ? date('Y-m-d H:i:s',$EndTime):'');
        $this->assign('StartTime', $StartTime ? date('Y-m-d H:i:s',$StartTime):'');

        $Condition='';
        $Condition   = self::TimeContrast($StartTime,$EndTime,"o.order_addtime",$Condition,'str');
        if ($type == 1){
            //直卖数据分析

            $sql = "SELECT t.*, sum(t.num) num from (
                      select p.userid_first, u.nickname, u.mobile, u.`level`, count(*) num, reu.nickname parentnickname, reu.mobile parentmobile from jay_order o
                      left join jay_order_product p on p.order_id=o.order_id
                      left join jay_user u on u.user_id = p.userid_first
                      left join jay_user reu on reu.user_id = u.reid
                      where".$whereproduct." and p.product_returnall=0 and o.user_id!=p.userid_first and p.userid_first>0 and o.order_status>1 ".($Condition!=''? ' and '.$Condition:'')."
                      group by p.userid_first
                        union all
                      select p.userid_second userid_first, fen.nickname, fen.mobile, fen.`level`, count(*) num, reu.nickname parentnickname, reu.mobile parentmobile from jay_order o
                      left join jay_order_product p on p.order_id=o.order_id
                      left join jay_user byer on byer.user_id = o.user_id
                      left join jay_user fen on fen.user_id = p.userid_second
                      left join jay_user reu on reu.user_id = fen.reid
                      where ".$whereproduct." and p.product_returnall=0 and byer.`level`>1 and o.user_id=p.userid_first and o.order_status>1 ".($Condition!=''? ' and '.$Condition:'')."
                      group by p.userid_second
                      ) t
                      group by t.userid_first
                      order by num desc;";
            $this->assign('title', '直接分享人数据分析,统计单数;统计商品id='.$ids.$id);
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
                    ($Condition?( ' and '.$Condition):'').
                    "   group by p.userid_operations order by num desc limit 100    ".
                    "   ) t    ".
                    "   left join jay_user u on u.user_id = t.userid_operations    ".
                    "   left join jay_user pu on pu.user_id = u.reid".
                    "   ) kk".
                    "   group by userid_operations order by num desc";
            $this->assign('title', '会员团队数据分析,统计份数');
        }
        $list = Db::query($sql);
        foreach ($list as $k=>$v){
            $list[$k]['level'] = Levelconst::getName($v['level']);
        }
        if($excel){
            $Column    =  array('达人UID','达人昵称','联系电话','用户等级','购买份数','达人上级用户','达人上级用户手机号');
            $em   = new ExcelModel();
            $em->export($Column,$list,"","数据分析","商品ID{$product['product_id']}直卖单数数据分析");
        }else{
            $this->assign('list', $list);
            $this->assign('product', $product);
            return $this->display('data', true);
        }
    }

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取商品销量分析
     * 肖亚子
     */
    public function ProductOrder(){
        $Id        = $this->get("id");
        $StartTime = strtotime($this->get("starttime"));
        $EndTime   = strtotime($this->get("endtime"));

        $Condition["op.product_id"] = array("eq",$Id);
        $Condition[] = array("exp","o.order_status > 1 and o.order_status < 5");
        $Condition   = self::TimeContrast($StartTime,$EndTime,"o.order_paytime",$Condition);

        $Field = "`p`.`product_name`,`pu`.`staff_name`, ma.staff_name as mstaff_name,sum(o.order_totalfee) as order_totalfee,sum(op.num) as num, sum(op.totalsettle) totalsettle, sum(op.commis_free+op.commis_first+op.commis_second+op.commis_operations+op.commis_operations_child+op.commis_playerhost_child+op.commis_playerhost_zhishu) as commis, FROM_UNIXTIME(o.order_paytime,'%Y-%m-%d')as date ";

        $List = Db::name("order")
                ->alias("o")
                ->field($Field)
                ->join("order_product op","op.order_id = o.order_id","left")
                ->join("product p","p.product_id = op.product_id","left")
                ->join("jay_staff pu","pu.staff_id = p.duty_id","left")
                ->join("jay_staff ma","ma.staff_id = p.maketing_id","left")
                ->where($Condition)
                ->group("date")
                ->order("date desc")
                ->select();
        $Price = Db::name("product_price")
                 ->field("product_totalnum,product_buynum")
                 ->where(array("product_id"=>$Id,"price_status"=>1))
                 ->select();

        //剩余库存
        $Totalnum = array_sum(array_map(function($Val){return $Val['product_totalnum'];}, $Price));
        $Buynum   = array_sum(array_map(function($Val){return $Val['product_buynum'];}, $Price));
        $Count["totalnum"] = $Totalnum - $Buynum;
        foreach ($List as $k=>$v){
            $Count["order_totalfee"] +=$v['order_totalfee'];
            $Count["totalsettle"] +=$v['totalsettle'];
            $Count["commis"] +=$v['commis'];
            $Count["num"] +=$v['num'];
            $List[$k]['maoli'] = sprintf('%.2f', $v['order_totalfee']-$v['totalsettle']-$v['commis']);
        }

        $this->assign('id', $Id);
        $this->assign('list', $List);
        $Count['maoli'] = sprintf('%.2f', $Count['order_totalfee']-$Count['totalsettle']-$Count['commis']);
        $this->assign('count', $Count);

        return $this->display('order', true);
    }


    /**
     * 导出商品销售数据-产品运营部分析数据
     * @return string
     */
    public function exportproductdata(){
        $Id        = $this->get("id");
        $StartTime = strtotime($this->get("starttime"));
        $EndTime   = strtotime($this->get("endtime"));

        $Condition["op.product_id"] = array("eq",$Id);
        $Condition[] = array("exp","o.order_status > 1 and o.order_status < 5");
        $Condition   = self::TimeContrast($StartTime,$EndTime,"o.order_paytime",$Condition);

        $Field = "`p`.`product_name`,`pu`.`staff_name`, ma.staff_name as mstaff_name,sum(o.order_totalfee) as order_totalfee,sum(op.num) as num, sum(op.totalsettle) totalsettle, sum(op.commis_free+op.commis_first+op.commis_second+op.commis_operations+op.commis_operations_child+op.commis_playerhost_child+op.commis_playerhost_zhishu) as commis, FROM_UNIXTIME(o.order_paytime,'%Y-%m-%d')as date ";

        $List = Db::name("order")
            ->alias("o")
            ->field($Field)
            ->join("order_product op","op.order_id = o.order_id","left")
            ->join("product p","p.product_id = op.product_id","left")
            ->join("staff pu","pu.staff_id = p.duty_id","left")
            ->join("staff ma","ma.staff_id = p.maketing_id","left")
            ->where($Condition)
            ->group("date")
            ->order("date desc")
            ->select();
        $column = ['商品名称', '产品负责人', '营销负责人', '营业额', '销售数量', '成本', '佣金', '日期'];
        $em = new ExcelModel();
        $em->export($column, $List, '商品每日销售数据统计', '商品每日销售数据统计', '商品每日销售数据统计');
    }


    /**
     * 导出商品订单数据统计-用于财务对账
     */
    public function exportproductorder(){
        $productids        = $this->get("ids");
        $tt        = $this->get("tt", 1);
        $tkstatus        = $this->get("tkstatus", 0);
        $StartTime = strtotime($this->get("bstarttime"));
        $EndTime   = strtotime($this->get("bendtime"));
        if($productids != ''){
            $Condition["op.product_id"] = array("in", $productids);
        }
        $Condition   = self::TimeContrast($StartTime,$EndTime,"o.order_paytime",$Condition);
        if($tkstatus > 0){
            //包含退款
            $Condition['o.order_status'] = ['gt', 1];
            $title = '全部订单（包含退款）';
        }else{
            $Condition['o.order_status'] = ['in', '2,3,4'];
            $title = '不含退款订单';
        }
        $Field = "m.merchant_name, `p`.`product_name`,`pu`.`staff_name`, ma.staff_name as mstaff_name, p.product_returnall, p.product_starttime, p.product_endtime, p.product_status, p.obtained_time, sum(o.order_totalfee) as order_totalfee,sum(op.num) as num, sum(op.totalsettle) totalsettle, sum(op.commis_free+op.commis_first+op.commis_second+op.commis_operations+op.commis_operations_child+op.commis_playerhost_child+op.commis_playerhost_zhishu) as commis ";
        $List = Db::name("order")
            ->alias("o")
            ->field($Field)
            ->join("order_product op","op.order_id = o.order_id","left")
            ->join("product p","p.product_id = op.product_id","left")
            ->join("merchant m","m.merchant_id = p.merchant_id","left")
            ->join("staff pu","pu.staff_id = p.duty_id","left")
            ->join("staff ma","ma.staff_id = p.maketing_id","left")
            ->where($Condition)
            ->group("op.product_id")
            ->order("p.product_id asc")
            ->select();
        foreach ($List as $k=>$v){
            $List[$k]['product_status'] = $v['product_status']==1?'上架':'已下架';
            $List[$k]['product_returnall'] = $v['product_returnall']==1?'免单':'';
            $List[$k]['product_starttime'] = date2('Y-m-d H:i:s', $v['product_starttime']);
            $List[$k]['product_endtime'] = date2('Y-m-d H:i:s', $v['product_endtime']);
            $List[$k]['obtained_time'] = date2('Y-m-d H:i:s', $v['obtained_time']);
            if($v['product_returnall'] == 1){
                $List[$k]['commis'] = $v['order_totalfee'];
            }
        }
        $column = ['商家' ,'商品名称', '产品负责人','营销负责人','新人免单？', '抢购开始时间', '抢购结束时间', '上下架状态', '下架时间', '营业额', '销售数量', '成本', '佣金'];
        $em = new ExcelModel();
        $em->export($column, $List, $title, $title, $title);
    }


    /**
     * @param $StartTime  开始时间
     * @param $EndTime    结束时间
     * @param $Key        字段
     * @param $Condition  返回组合
     * @return mixed
     */
    public  function TimeContrast($StartTime,$EndTime,$Key,$Condition,$type='arr'){
        if (!empty($StartTime) && empty($EndTime)) {
            parent::Tpl_NotGtTime($StartTime,"开始时间不能大于当前时间"); //开始时间不为空和当前时间对比
            if($type!='arr'){
                $Condition.= $Key. ' >= '. $StartTime;
            }else{
                $Condition[$Key] = array(array('egt', $StartTime));
            }

        } else if (empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_NotGtTime($EndTime,"结束时间不能大于当前时间"); //结束时间不为空和当前时间对比
            if($type!='arr'){
                $Condition.= $Key. ' <= '.  $EndTime;
            }else{
                $Condition[$Key] = array(array('elt', $EndTime+86400));
            }
        } else if (!empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_TimeContrast1($StartTime,$EndTime); //开始和结束时间都不为空进行判断
            if($type!='arr'){
                $Condition.= $Key. '>='.  $StartTime .' and '. $Key. '<='.  $EndTime;
            }else{
                $Condition[$Key] = array(array('egt', $StartTime), array('elt', $EndTime+86400));
            }
        }
        return $Condition;
    }

}