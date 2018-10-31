<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/30
 * Time: 17:30
 * 接口商品模型
 * 肖亚子
 */

namespace app\api\model;
use think\Db;

class ProductModel{

    public static function TableName(){
        return Db::name("product");
    }

    public function ShopProductList($Condition= array(),$Fd = null,$Order,$Psize=1, $PageSize=20){

        $Field = "p.product_id,p.product_pic,p.product_name,p.temp_price,p.temp_commission,p.product_sold".$Fd;

        $List = self::TableName()
                    ->alias("p")
                    ->field($Field)
                  //  ->join("product_price price","price.product_id = p.product_id","left")
                    ->join("merchant m","m.merchant_id = p.merchant_id","left")
                    ->where($Condition)
                    ->page($Psize,$PageSize)
                    ->order($Order)
                    ->select();

        return $List;
    }

    public function ShopProductData($Condition = array()){

    }
}