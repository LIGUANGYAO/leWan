<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/1/22
 * Time: 9:42
 * 用户取消预约模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;

class ReservationcancelModel extends BaseModel{

    public static function TableName(){
        return Db::name("order_reservation_cancel");
    }

    /**
     * @param array $Condition 查询条件
     * @param int $Psize       分页数
     * @param int $PageSize    分页条数
     * @return mixed
     * 获取用户取消预约申请数据
     * 肖亚子
     */
    public static function UserCancelList($Condition = array(),$Psize = 1,$PageSize = 30){
        $Field = "rc.id,rc.remark,rc.bremark,rc.status as rcstatus,rc.addtime,r.reservation_id,r.reservation_calendar,r.reservation_week,
        r.reservation_property,r.reservation_status,o.order_no,o.order_fullname,o.order_mobile,op.product_name,c.consume_code,c.status,
        m.merchant_alias as merchant_name,f.merchant_alias as merchant_cname,u.nickname,u.username,u.mobile";
        $Count     = self::TableName()
                        ->alias("rc")
                        ->field($Field)
                        ->join("order_user_reservation r","r.reservation_id = rc.reservation_id","left")
                        ->join("order_consume_code c","c.consume_code_id = r.consume_code_id","left")
                        ->join("order o","o.order_id = c.order_id","left")
                        ->join("order_product op","op.order_id = o.order_id","left")
                        ->join("merchant m","m.merchant_id = c.merchant_id","left")
                        ->join("merchant f","f.merchant_id = c.fen_merchant_id","left")
                        ->join("user u","u.user_id = o.user_id","left")
                        ->where($Condition)
                        ->count();

        $PageCount = ceil($Count/$PageSize);
        $List      = self::TableName()
                        ->alias("rc")
                        ->field($Field)
                        ->join("order_user_reservation r","r.reservation_id = rc.reservation_id","left")
                        ->join("order_consume_code c","c.consume_code_id = r.consume_code_id","left")
                        ->join("order o","o.order_id = c.order_id","left")
                        ->join("order_product op","op.order_id = o.order_id","left")
                        ->join("merchant m","m.merchant_id = c.merchant_id","left")
                        ->join("merchant f","f.merchant_id = c.fen_merchant_id","left")
                        ->join("user u","u.user_id = o.user_id","left")
                        ->where($Condition)
                        ->page($Psize, $PageSize)
                        ->order("rc.addtime desc")
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;
    }

    /**
     * @param array $Condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改取消预约申请
     * 肖亚子
     */
    public static function UserCancelUpdate($Condition = array(),$Data){
        $Data = self::TableName()->where($Condition)->update($Data);

        return $Data;
    }

    /**
     * @param array $Condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改消费码预约状态
     * 肖亚子
     */
    public static function UserReservationUpdate($Condition = array(),$Data){
        $Data = Db::name("order_user_reservation")->where($Condition)->update($Data);

        return $Data;
    }

    /**
     * @param $Id 申请取消预约id
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取取消预约用户相关信息
     * 肖亚子
     */
    public static function UserCancelOrder($Condition = array()){
        $Data = self::TableName()
                    ->alias("rc")
                    ->field("m.merchant_alias as merchant_name,o.order_no,o.order_addtime,uc.openid")
                    ->join("merchant m","m.merchant_id = rc.fen_merchant_id","left")
                    ->join("order_user_reservation r","r.reservation_id = rc.reservation_id","left")
                    ->join("order o","o.order_id = r.order_id","left")
                    ->join("user u","u.user_id = r.user_id","left")
                    ->join("user_connect uc","uc.user_id = u.user_id","left")
                    ->where($Condition)
                    ->find();

        return $Data;

    }

}