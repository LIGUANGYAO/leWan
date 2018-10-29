<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/26
 * Time: 17:02
 * 消费码日志模型
 * 肖亚子
 */

namespace app\system\model;
use Think\Db;

class OrderconsumecodelogModel extends BaseModel{

    public static function TableName(){
        return Db::name("order_consume_code_log");
    }

    public function  CodeLogList($Condition=array(), $Psize=1, $PageSize=50){
        $Field     = "l.action,l.addtime,c.consume_code_id,c.consume_code,c.status,o.order_no,u.mobile,u.nickname,m.merchant_name";
        $Count     = self::TableName()
                        ->alias("l")
                        ->field($Field)
                        ->Join("order_consume_code c","c.consume_code_id = l.consume_code_id","left")
                        ->Join("order o","o.order_id = c.order_id","left")
                        ->Join("user u","u.user_id = c.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('l.id desc')
                        ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = self::TableName()
                        ->alias("l")
                        ->field($Field)
                        ->Join("order_consume_code c","c.consume_code_id = l.consume_code_id","left")
                        ->Join("order o","o.order_id = c.order_id","left")
                        ->Join("user u","u.user_id = c.user_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order("l.id desc")
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;
    }
}