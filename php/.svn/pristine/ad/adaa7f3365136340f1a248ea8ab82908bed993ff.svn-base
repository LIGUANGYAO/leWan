<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/1/18
 * Time: 12:00
 * 快递预约订单模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;

class OrderdeliverModel extends BaseModel{

    public static function TableName(){
        return Db::name("order_user_reservation_fahuo");
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Psize        分页数
     * @param int $PageSize     分页条数
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取全部快递预约申请
     * 肖亚子
     */
    public static function ExpressList($Condition = array(),$Psize = 1,$PageSize = 30){
        $Field = "f.day,f.remark,f.addtime,m.merchant_alias as merchant_name,o.order_no,o.order_status,op.product_name,op.num,a.ssq,a.address";
        $Count     = self::TableName()
                        ->alias("f")
                        ->field($Field)
                        ->join("merchant m","m.merchant_id = f.merchant_id","left")
                        ->join("order o","o.order_id = f.order_id","left")
                        ->join("order_product op","op.order_id = f.order_id","left")
                        ->join("user_address a","a.address_id = o.address_id","left")
                        ->where($Condition)
                        ->count();

        $PageCount = ceil($Count/$PageSize);
        $List      = self::TableName()
                        ->alias("f")
                        ->field($Field)
                        ->join("merchant m","m.merchant_id = f.merchant_id","left")
                        ->join("order o","o.order_id = f.order_id","left")
                        ->join("order_product op","op.order_id = f.order_id","left")
                        ->join("user_address a","a.address_id = o.address_id","left")
                        ->where($Condition)
                        ->page($Psize, $PageSize)
                        ->order("f.addtime desc")
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;
    }

}