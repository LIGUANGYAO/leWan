<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2019/1/4
 * Time: 13:47
 * 短信发送模型
 * 肖亚子
 */
namespace app\system\model;

use Think\Db;

class MsgsendlogModel extends BaseModel{

    public static function TableName(){
        return Db::name("msg_sendlog");
    }

    /**
     * @param int $Psize     分页数
     * @param int $PageSize  分页条数
     * @return mixed
     * 获取后台短信推送记录
     * 肖亚子
     */
    public static function MsgSendlogList($Psize = 1,$PageSize = 30){
        $Count     = self::TableName()->count();
        $PageCount = ceil($Count/$PageSize);
        $List      = self::TableName()
                        ->field("admin_name,mobile,sendmsg,addtime")
                        ->page($Psize, $PageSize)
                        ->select();

        $PaginaTion = parent::Paging($Count,$Psize,$PageCount,$List);

        return $PaginaTion;

    }

}