<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/12
 * Time: 10:31
 * 肖亚子
 * 城市model操作
 */

namespace app\system\model;
use think\Db;
use think\Request;


class AreaModel{
    /**
     * @return \Model|\Think\Model
     * 省份模型
     */
    public static function TableName(){
        return Db::name("provence");
    }

    /**
     * @param array $Condition 查询条件
     * @param int $Type        当前城市等级
     * @param int $Psize       分页数默认第一页
     * @param int $PageSize    分页数默认每页30条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取城市每等级的列表数据
     * 肖亚子
     */
    public static function ProvenceList($Condition = array(),$Type = 1,$Psize = 1,$PageSize = 30){

        if ($Type == 1){
            $Count = self::TableName()->count();
        }elseif ($Type == 2){
            $Count = Db::name("city")->where($Condition)->count();
        }else{
            $Count = Db::name("area")->where($Condition)->count();
        }

        $PageCount = ceil($Count/$PageSize);

        if ($Type == 1){
            $List = self::TableName()->page($Psize,$PageSize)->select();
        }elseif ($Type == 2){
            $List = Db::name("city")->page($Psize,$PageSize)->where($Condition)->select();
        }else{
            $List = Db::name("area")->page($Psize,$PageSize)->where($Condition)->select();
        }

        $Page['recordcount'] = $Count;
        $Page['pagenow']     = $Psize;
        $Page['pagecount']   = $PageCount;
        $Page['url']         = Request::instance()->url();
        $PaginaTion['list']  = $List;
        $PaginaTion['page']  = $Page;

        return $PaginaTion;
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Type         城市等级
     * @param $Pcode            省级code标识
     * @return array|false|mixed|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 编辑城市获取数据
     * 肖亚子
     */
    public static function RegionAreaFind($Condition = array(),$Type = 1,$Pcode){

        if ($Type == 1){
            $FindData = self::TableName()->field("id,provence")->where($Condition)->find();
        }elseif ($Type == 2){
            $Pname    = self::TableName()->field("provence")->where(array("code" => $Pcode))->find();
            $FindData = Db::name("city")->field("id,city as provence")->where($Condition)->find();

            $FindData["superior"] = $Pname["provence"];
        }else{
            $Pname    = self::TableName()->field("provence")->where(array("code" => $Pcode))->find();
            $FindData = Db::name("area")->field("id,area as provence,ccode")->where($Condition)->find();
            $Cname    = Db::name("city")->field("city")->where(array("code" => $FindData["ccode"]))->find();

            $FindData["superior"] = $Pname["provence"]."-".$Cname["city"];
            unset($FindData["ccode"]);
        }

        return $FindData;
    }

    /**
     * @param $Condition  修改条件
     * @param $Data       修改内容
     * @param int $Type   修改城市的等级
     * @return int|string|\think\db\Query|\Think\Model
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改城市内容
     * 肖亚子
     */

    public static function AreaUpdata($Condition, $Data,$Type = 1){

        if ($Type == 1){
            $AreaUp = self::TableName()->where($Condition)->update($Data);
        }elseif ($Type == 2){
            $AreaUp = Db::name("city")->where($Condition)->update($Data);
        }else{
            $AreaUp = Db::name("area")->where($Condition)->update($Data);
        }

        return $AreaUp;
    }


}