<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/25
 * Time: 14:19
 * 换货申请模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;

class OrderbarterModel extends BaseModel{

    public static function TableName(){
        return Db::name("order_barter");
    }

    /**
     * @param array $Condition     查询条件
     * @param int $Psize           分页数默认第一页
     * @param int $PageSize        每页默认50条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取申请换货订单数据
     * 肖亚子
     */
    public function OrderBarterList($Condition=array(), $Psize=1, $PageSize=50){
        $Field     = "b.*,u.mobile,u.nickname,o.order_no,m.merchant_name";
        $Count     = self::TableName()
                        ->alias("b")
                        ->field($Field)
                        ->Join("user u","u.user_id = b.user_id","left")
                        ->Join("order o","o.order_id = b.order_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('b.barter_id desc')
                        ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = self::TableName()
                        ->alias("b")
                        ->field($Field)
                        ->Join("user u","u.user_id = b.user_id","left")
                        ->Join("order o","o.order_id = b.order_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('b.barter_id desc')
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;
    }

    /**
     * @param array $Condition       搜索查询条件
     * @param array $CountCondition  单独订单状态条件
     * @param $Type                  查询订单状态类型
     * @param $Status                列表展示类型状态
     * @return int|string
     * 查询订单换货状态数量
     * 肖亚子
     */
    public function BarterCount($Condition = array(),$CountCondition = array(),$Type,$Status){
        if ($Type == $Status){
            $Count = self::TableName()
                        ->alias("b")
                        ->Join("user u","u.user_id = b.user_id","left")
                        ->Join("order o","o.order_id = b.order_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($Condition)
                        ->order('b.barter_id desc')
                        ->count();
        }else{
            $Count = self::TableName()
                        ->alias("b")
                        ->Join("user u","u.user_id = b.user_id","left")
                        ->Join("order o","o.order_id = b.order_id","left")
                        ->Join("merchant m","m.merchant_id = o.merchant_id","left")
                        ->where($CountCondition)
                        ->order('b.barter_id desc')
                        ->count();
        }

        return $Count;
    }
}