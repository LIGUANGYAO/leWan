<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/18
 * Time: 16:15
 * 商品标签模型
 * 肖亚子
 */
namespace app\system\model;
use Think\Db;

class ProducttagsModel extends BaseModel{

    public static function TableName(){
        return Db::name("product_tags");
    }

    /**
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取所有商品标签
     * 肖亚子
     */
    public static function TagsLists(){
        $Data = self::TableName()->select();

        return $Data;
    }

    /**
     * @param $Id  标签id
     * @return \think\db\Query
     * 获取标签数据
     * 肖亚子
     */
    public static function TagsFind($Id){
        $Data = self::TableName()->where("tag_id","=",$Id)->find();

        return $Data;
    }

    /**
     * @param $Data   添加内容
     * @return int|string
     * 添加标签数据
     * 肖亚子
     */
    public static function TagsAdd($Data){
        $TagsAdd = self::TableName()->insert($Data);

        return $TagsAdd;
    }

    /**
     * @param $Id   标签id
     * @param $Data 修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改标签数据
     * 肖亚子
     */
    public static function TagsUp($Id,$Data){
        $TagsUp = self::TableName()->where("tag_id","=",$Id)->update($Data);

        return $TagsUp;
    }
}