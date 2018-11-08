<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/7
 * Time: 15:40
 * 提现模型
 * 肖亚子
 */

namespace app\api\model;
use think\Db;

class UserwithdrawModel {

    public static function TableName(){
        return Db::name("user_withdraw");
    }

    /**
     * @param array $Condition  查询条件
     * @param $Page             分页数默认第一页
     * @param int $Psize        分页条数默认20条
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取用户提现明细
     * 肖亚子
     */
    public static function WithdrawList($Condition = array(),$Page ,$Psize = 20){
        $Data = self::TableName()
                ->field("withdraw_amount as money,withdraw_type as type,withdraw_status as status,withdraw_reason as reason,withdraw_addtime as addtime")
                ->where($Condition)
                ->page($Page,$Psize)
                ->select();

        return $Data;
    }

    /**
     * @param $Data     添加内容
     * @return int|string
     * 添加提现申请
     * 肖亚子
     */
    public function WithdrawAdd($Data){
        $Data = self::TableName()->insert($Data);

        return $Data;
    }

    /**
     * @param array $Condition  修改条件
     * @param $Data             修改内容
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改账户信息
     * 肖亚子
     */
    public static function UserAccountUpdate($Condition = array(),$Data){
        $Data = Db::name("account")->where($Condition)->update($Data);

        return $Data;
    }

    /**
     * @param array $Condition  查询条件
     * @return mixed
     * 获取系统配置数据
     * 肖亚子
     */
    public function ParameterFind($Condition = array()){
        $Data = Db::name("parameter")->where($Condition)->value("value");

        return $Data;
    }


}