<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/19
 * Time: 11:53
 * 所有用户收货地址控制器
 * 肖亚子
 */

namespace app\system\Controller;

use think\Request;
use think\Db;
use app\common\AdminBaseController;
use app\system\model\UseraddressModel;

class UseraddressController extends AdminBaseController{

    /**
     * @return string
     * 获取全部用户收货数据
     * 肖亚子
     */
    public function SiteList(){
        $Condition = array();
        $Psize      = $this->get("page",1);//当前分页页数默认第一页
        $Title      = $this->get("title");
        $Flag       = $this->get("flag",0);

        if ($Title){
            $Condition["a.contact|a.mobile|u.nickname|u.mobile"] = array("like","%$Title%");
        }

        if ($Flag){
            $Condition["a.flag"] = array("eq",$Flag);
        }

        $DataList = UseraddressModel::UserAddressList($Condition,$Psize,50);

        $this->assign("title",$Title);
        $this->assign("flag",$Flag);
        $this->assign("data",$DataList);

        return $this->display('list', true);
    }

}