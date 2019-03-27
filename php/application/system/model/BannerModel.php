<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/29
 * Time: 17:09
 */
namespace app\system\model;
use think\Db;
use think\Request;

class BannerModel extends BaseModel{

    public static function TableName(){
        return Db::name("banner");
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Psize        分页数默认你第一页
     * @param int $PageSize     分页条数默认50条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取轮播数据
     * 肖亚子
     */
    public function BannerList($Condition = array(),$Psize = 1,$PageSize = 50){
        $Field = "b.id,b.type,b.position,b.alt,b.pic,b.sort,b.addtime,re.mergername,ct.category_name";
        $Count = self::TableName()
                    ->alias("b")
                    ->field($Field)
                    ->join("region re","re.id = b.city","left")
                    ->join("product_category ct","ct.category_id = b.cat_id","left")
                    ->where($Condition)
                    ->order('b.type asc,b.provence asc,b.city asc,b.cat_id asc,b.sort asc')
                    ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = self::TableName()
                        ->alias("b")
                        ->field($Field)
                        ->join("region re","re.id = b.city","left")
                        ->join("product_category ct","ct.category_id = b.cat_id","left")
                        ->where($Condition)
                        ->page($Psize, $PageSize)
                        ->order('b.type asc,b.provence asc,b.city asc,b.cat_id asc,b.sort asc')
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

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
     * @param array $Condition  查询条件
     * @return array|false|\PDOStatement|string|\think\Model
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 查询轮播详情
     * 肖亚子
     */
    public function BannerFind($Condition = array()){
        $Data = self::TableName()->where($Condition)->find();

        return $Data;
    }

    /**
     * @param array $Condition  修改条件
     * @param $Data             修改内容
     * @return int|string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 修改轮播内容
     * 肖亚子
     */
    public function BannerUpdate($Condition = array(),$Data){
        $BannerUp = self::TableName()->where($Condition)->update($Data);

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