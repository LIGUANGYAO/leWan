<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/6
 * Time: 17:53
 * 用户收入模型
 * 肖亚子
 */
namespace app\api\model;
use think\Db;

class AccountcashModel{

    public static function TableName($Month){
        return Db::name("account_cash".$Month);
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Day          查询表
     * @param int $Page         分页默认第一页
     * @param int $Psize        分页数默认20条
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     *
     */
    public function AccountcashList($Condition = array(),$Month,$Page = 1,$Psize = 20){

        $Data = self::TableName($Month)
                    ->alias("ca")
                    ->field("o.order_no as ordernumber,ca.record_amount as money")
                    ->join("order o","o.order_id = ca.order_id","left")
                    ->where($Condition)
                    ->page($Page,$Psize)
                    ->select();

        return $Data;
    }


}