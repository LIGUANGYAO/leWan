<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/2
 * Time: 14:18
 */

namespace app\common\model;
use app\system\model\PaginationModel;
use think\Db;

/**
 * 平台财务统计
 * Class ManageFinanceModel
 * @package app\common\model
 */
class ManageFinanceModel
{
    /**
     * @return string
     */
    private static function getTableName() {
        return Db::name("manage_finance");
    }

    public static function getManageFinanceList($condition) {
        if($condition){
            $list =  self::getTableName()
                ->where($condition)
                ->order('total_tag asc')
                ->select();
            return $list;
        }else{
            return false;
        }
    }
    public static function getManageFinanceCount($condition) {
        if($condition){
            $list =  self::getTableName()
                ->where($condition)
                ->count();
            return $list;
        }else{
            return false;
        }
    }

    public static function getManageFinanceByTag($tag) {
        return  self::getTableName()->where(array('total_tag'=>$tag))->find();
    }

}