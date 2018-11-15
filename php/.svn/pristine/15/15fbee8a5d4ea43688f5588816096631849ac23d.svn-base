<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/13
 * Time: 16:00
 */

namespace app\system\model;
use think\Db;
use think\Request;

class BankModel extends BaseModel {

    public static function TableName(){
        return Db::name("bank");
    }

    /**
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取全部开通银行列表
     * 肖亚子
     */
    public function BankAll(){
        $Data = self::TableName()->select();

        return $Data;
    }

    /**
     * @param array $Condition  查询条件
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取银行详情
     * 肖亚子
     */
    public function BankDataFind($Condition = array()){
        $Data = self::TableName()->where($Condition)->find();

        return $Data;
    }

    /**
     * @param array $Condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改银行内容
     * 肖亚子
     */
    public function BankUpdate($Condition = array(),$Data){
        $Data = self::TableName()->where($Condition)->update($Data);

        return $Data;
    }
}