<?php
namespace app\system\model;

use think\Db;
use think\Config;
use think\Request;
use think\Session;
use think\Cache;

/**
 * 商家相关
 * Enter description here ...
 * @author Administrator
 *
 */
class ProductModel extends BaseModel{

    /**
     * 查询列表
     * @param array $Condition
     * @param int $Page
     * @param int $PageSize
     */
    public function getList($Condition=array(), $Page=1, $PageSize=20){
        //查询总记录
        $Count = Db::name('product p')->where($Condition)->count();

        $PageCount = ceil($Count/$PageSize);

        $List = Db::name('product p')
                ->field('p.*, m.merchant_name')
                ->join('jay_merchant m', 'm.merchant_id = p.merchant_id', 'left')
                ->where($Condition)
                ->page($Page, $PageSize)->order('p.product_uptime desc')->select();

        $PaginaTion = parent::Paging($Count,$Page,$PageCount,$List);
        return $PaginaTion;
    }


    /**
     * 商品操作日志
     * @param $product_id
     * @param int $operator_from 1店小二；2商家
     * @param $operator_name
     * @param $operator_id
     * @param $action
     */
    public function log($product_id, $operator_from=1,$operator_name, $operator_id, $action){
        $vo['product_id'] = $product_id;
        $vo['operator_from'] = $operator_from;
        $vo['operator_name'] = $operator_name;
        $vo['operator_id'] = $operator_id;
        $vo['action'] = $action;
        $vo['addtime'] = time();
        Db::name('product_log')->insert($vo);
    }
    
}
