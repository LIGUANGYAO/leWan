<?php

namespace app\system\model;
use think\Db;
use think\Request;

class BranchModel extends BaseModel{

    public static function TableName(){
        return Db::name("fgs_admin_user");
    }

    /**
     * @param array $condition  查询条件
     * @param int $Psize        分页数默认你第一页
     * @param int $PageSize     分页条数默认50条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public static function branchList($condition = array(),$psize = 1,$pageSize = 50){
        $Field = "u.username,b.sub_name,u.status,u.bc_id,b.province_code,b.city_code,r.region_name";
//        $paginaTion = parent::Paging($count,$psize,$pageCount,$list);
//        return $paginaTion;
    }

    /**
     * @param $data   添加
     * @return int|string
     * 添加轮播数据
     */
    public static function branchAdd($data){
        return self::TableName()->insert($data);
    }

    /**
     * @param array $condition  查询条件
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 查询轮播详情
     */
    public static function branchFind($condition = array()){
        return self::TableName()->where($condition)->find();
    }

    /**
     * @param array $condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改轮播内容
     */
    public static function branchUpdate($condition = array(),$Data){
        $branchUp = self::TableName()->where($condition)->update($Data);
        return $branchUp;
    }

}