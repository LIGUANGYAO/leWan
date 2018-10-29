<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/16
 * Time: 10:57
 */

namespace app\system\model;
use think\Model;
use think\Request;


class BaseModel extends Model{

    /**
     * @param $Count      数据总条数
     * @param $Psize      当前分页数
     * @param $PageCount  总分页数
     * @param $List       查询数据
     * 肖亚子
     * 自定义组装分页返回数据
     */

    public function Paging($Count = 0,$Psize = 1,$PageCount = 0,$List = array()){
        $Page['recordcount'] = $Count;
        $Page['pagenow']     = $Psize;
        $Page['pagecount']   = $PageCount;
        $Page['url']         = Request::instance()->url();
        $PaginaTion['list']  = $List;
        $PaginaTion['page']  = $Page;

        return $PaginaTion;
    }

}