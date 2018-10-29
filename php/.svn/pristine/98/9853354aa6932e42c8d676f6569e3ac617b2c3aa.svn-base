<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/19
 * Time: 13:40
 * 用户收货地址模型
 * 肖亚子
 */

namespace app\system\model;
use think\Db;

class UseraddressModel extends BaseModel{

    public static function TableName(){
        return Db::name("user_address");
    }

    /**
     * @param array $Condition   查询条件
     * @param int $Psize         分页数默认第一页
     * @param int $PageSize      分页条数默认50条
     * @return mixed
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    public function UserAddressList($Condition = array(), $Psize = 1, $PageSize = 50){
        $Field = "a.contact,a.mobile,a.ssq,a.address,a.flag,a.addtime,u.avatar,u.mobile as umobile,u.nickname";

        //查询总记录
        $Count     = self::TableName()
                        ->alias("a")
                        ->field($Field)
                        ->Join("user u","u.user_id = a.user_id","left")
                        ->where($Condition)
                        ->order('u.user_id desc')
                        ->count();

        $PageCount = ceil($Count/$PageSize);

        $List      = self::TableName()
                        ->alias("a")
                        ->field($Field)
                        ->Join("user u","u.user_id = a.user_id","left")
                        ->where($Condition)
                        ->page($Psize, $PageSize)
                        ->order('u.user_id desc')
                        ->select();


        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;
    }
}