<?php

namespace app\system\model;
use think\Db;
use think\Request;

class ActivesModel extends BaseModel{

    public static function TableName(){
        return Db::name("actives");
    }

    /**
     * @param array $condition  查询条件
     * @param int $psize        分页数默认你第一页
     * @param int $pageSize     分页条数默认15条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取轮播数据
     */
    public static function getActivesList($condition = array(),$psize = 1,$pageSize = 15){
        $Field = "a.a_id,a.thumb,a.type,a.title,a.starttime,a.endtime,a.status,a.addtime,r.fullname,a.productids";
        $count     = self::TableName()
                        ->alias("a")
                        ->field($Field)
                        ->join("region re","re.id = a.citycode","left")
                        ->where($condition)
                        ->count();
        $pageCount = ceil($count/$pageSize);

        $list      = self::TableName()
                        ->alias("a")
                        ->field($Field)
                        ->join("region r","r.id = a.citycode","left")
                        ->where($condition)
                        ->page($psize, $pageSize)
                        ->order("a.provencecode asc,a.citycode asc,a.sort asc")
                        ->select();

        $PaginaTion = parent::Paging($count,$psize,$pageCount,$list);
        return $PaginaTion;
    }

    /**
     * @param $Data   添加内容
     * @return int|string
     * 添加轮播数据
     * 肖亚子
     */
    public function BannerAdd($Data){
        $Add = self::TableName()->insert($Data);

        return $Add;
    }

    /**
     * @param array $condition  查询条件
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 查询轮播详情
     * 肖亚子
     */
    public function BannerFind($condition = array()){
        $Data = self::TableName()->where($condition)->find();

        return $Data;
    }

    /**
     * @param array $condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改轮播内容
     * 肖亚子
     */
    public function BannerUpdate($condition = array(),$Data){
        $BannerUp = self::TableName()->where($condition)->update($Data);

        return $BannerUp;
    }
    /**
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取商品分类
     * 肖亚子
     */
    public function CategoryList(){
       $CaList = Db::name("product_category")
                    ->field("category_id,category_name")
                    ->where(array("category_status" => 1,"category_del"=>0))
                    ->select();

       return $CaList;
    }

}