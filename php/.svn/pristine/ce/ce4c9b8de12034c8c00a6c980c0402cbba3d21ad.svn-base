<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/26
 * Time: 14:19
 * 消单模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;

class OrderconsumptionModel extends BaseModel{

    public static function TableName(){
        return Db::name("order_consumption");
    }

    /**
     * @param array $Condition   查询条件
     * @param int $Psize         分页数默认第一页
     * @param int $PageSize      每页条数默认50条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function  ConsumptionList($Condition=array(), $Psize=1, $PageSize=50){
        $Field     = "cp.addtime,c.consume_code,o.order_no,u.mobile,u.nickname,m.merchant_name";
        $Count     = self::TableName()
                        ->alias("cp")
                        ->field($Field)
                        ->Join("order o","o.order_id = cp.order_id","left")
                        ->Join("user u","u.user_id = cp.user_id","left")
                        ->Join("merchant m","m.merchant_id = cp.merchant_id","left")
                        ->Join("order_consume_code c","c.consume_code_id = cp.consume_code_id","left")
                        ->where($Condition)
                        ->order('cp.consumption_id desc')
                        ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = self::TableName()
                        ->alias("cp")
                        ->field($Field)
                        ->Join("order o","o.order_id = cp.order_id","left")
                        ->Join("user u","u.user_id = cp.user_id","left")
                        ->Join("merchant m","m.merchant_id = cp.merchant_id","left")
                        ->Join("order_consume_code c","c.consume_code_id = cp.consume_code_id","left")
                        ->where($Condition)
                        ->order('cp.consumption_id desc')
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;
    }

}