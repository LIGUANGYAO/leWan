<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/6
 * Time: 13:58
 * 用户收货地址模型
 * 肖亚子
 */

namespace app\api\model;
use think\Db;

class UserAddressModel{

    public static function TableName(){
        return Db::name("user_address");
    }

    /**
     * @param array $Condition    查询条件
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取用户全部收货地址数据
     * 肖亚子
     */
    public function UserAddressList($Condition = array()){
        $Data = self::TableName()->field("address_id,contact,mobile,ssq,address")->where($Condition)->select();

        return $Data;
    }

    /**
     * @param $Data       添加内容
     * @return int|string
     * 添加收货地址
     * 肖亚子
     */
    public function UserAddressAdd($Data){
        $Data = self::TableName()->insert($Data);

        return $Data;
    }

    /**
     * @param array $Condition  查询条件
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取收货地址详情
     * 肖亚子
     */
    public function UserAddressFind($Condition = array()){
        $Data = self::TableName()
                    ->field("address_id,contact,mobile,province_code,city_code,area_code,ssq,address")
                    ->where($Condition)
                    ->find();

        return $Data;
    }

    /**
     * @param array $Condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改收货地址信息
     * 肖亚子
     */
    public function UserAddressUpdate($Condition = array(),$Data){
        $Data = self::TableName()->where($Condition)->update($Data);

        return $Data;
    }


}