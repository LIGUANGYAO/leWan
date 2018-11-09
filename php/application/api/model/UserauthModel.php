<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/8
 * Time: 17:15
 * 用户实名认证模型
 * 肖亚子
 */

namespace app\api\model;
use think\Db;

class UserauthModel{

    public static function TableName(){
        return Db::name("user_auth");
    }

    /**
     * @param $Uid    用户uid
     * @return mixed
     * 获取实名认证用户名字
     * 肖亚子
     */
    public function UserAuthFind($Uid){
        $Condition["user_id"] = array("eq",$Uid);
        $Condition["status"] = array("eq",2);

        $Data = self::TableName()->where($Condition)->value("truename");

        return $Data;
    }
}