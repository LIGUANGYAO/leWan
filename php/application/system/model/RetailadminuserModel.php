<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/4/9
 * Time: 15:59
 * 分销商管理模型
 * 肖亚子
 */
namespace  app\system\model;
use think\Db;

class RetailadminuserModel extends BaseModel{

    public static function TableName($Name = "admin_user"){
         return Db::connect('database_distr')->name($Name);
    }

    /**
     * @param array $Condition  查询条件
     * @param int $Psize        分页数
     * @param int $PageSize     分页条数
     * @return false|\PDOStatement|string|\think\Collection
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取分销商列表数据
     * 肖亚子
     */
    public static function AdminList($Condition = array(),$Psize = 1,$PageSize = 50){

        $Field = "a.*,ac.account_cash_expenditure,ac.account_cash_income,ac.account_cash_balance";
        $Count = self::TableName()
                    ->alias("a")
                    ->field($Field)
                    ->join("account ac","ac.fxuser_id = a.id","left")
                    ->where($Condition)
                    ->order("a.type desc,a.id asc")
                    ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = self::TableName()
                    ->alias("a")
                    ->field($Field)
                    ->where($Condition)
                    ->join("account ac","ac.fxuser_id = a.id","left")
                    ->order("a.type desc,a.id asc")
                    ->page($Psize, $PageSize)
                    ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;

    }

    public static function AdminSubordinateList($Condition=array()){
        $List = self::TableName()->where($Condition)->select();

        return $List;
    }

    public static function AccountCashList($Condition = array(),$Time){

        $TablesName = Db::connect("database_distr")->query("show tables like 'jay_fx_account_cash{$Time}'");

        if (!empty($TablesName)){
            $List = self::TableName("account_cash".$Time)->where($Condition)->select();

            return $List;
        }else{
            return array();
        }

    }
}