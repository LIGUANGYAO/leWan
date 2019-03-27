<?php
/**
 * [WEIYIN System] Copyright (c) 2016 MICRO-SILVER.CN
 */

/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/4/12
 * Time: 下午 3:01
 */
namespace app\common\model;
use think\Model;
use think\Db;

class AreasModel extends Model {

    public static function TableName(){
        return Db::name("region");
    }

    /**
     * @param $id  查询省级数据id,为0
     * @return mixed  查询省级数据
     */
      public  function RegionWhole($Condition = array()){
          //  ->fetchSql()
            $Data = self::TableName()
                    ->field("id,name")
                    ->where($Condition)
                    ->select();

            return $Data;
        }

    /**
     * @param $pid  根据点击的城市id查找下级城市数据
     * @return mixed 查找下级城市
     */
      public  function RegionOpening($Condition = array()){
            $list = self::TableName()
                    ->alias("r")
                    ->field("r.id,r.name,l.name as s")
                    ->join("region l","l.parentid = r.id","left")
                    ->where($Condition)
                    ->group("r.id")
                    ->select();

            return $list;
        }

}