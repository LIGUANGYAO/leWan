<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/2/15
 * Time: 14:55
 * 用户邀请海报模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;
use think\Request;

class PosterModel extends BaseModel{

    public static function TableName(){
        return Db::name("sys_poster");
    }

    /**
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取全部邀请海报
     * 肖亚子
     */
    public static function PosterAll(){
        $List = self::TableName()->order("sort asc")->select();

        return $List;
    }

    /**
     * @param array $Condition  查询条件
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取海报信息
     * 肖亚子
     */
    public static function PosterFind($Condition = array()){
        $Data = self::TableName()->where($Condition)->find();

        return $Data;
    }

    /**
     * @param $Data   添加内容
     * @return int|string
     * 添加邀请海报
     * 肖亚子
     */
    public static function PosterAdd($Data){
        $AddData = self::TableName()->insert($Data);

        return $AddData;
    }

    /**
     * @param array $Condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改邀请海报信息
     * 肖亚子
     */
    public static function PosterEdit($Condition = array(),$Data){
        $Data = self::TableName()->where($Condition)->update($Data);

        return $Data;
    }
}