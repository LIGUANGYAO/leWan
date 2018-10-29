<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/27
 * Time: 16:02
 */

namespace app\api\controller;

use app\api\controller\ApiBaseController;
use app\api\model\BannerModel;

class BannerController extends ApiBaseController{

    public function HomePageList(){
//        $a = $this->headerData;
        $Condition = array();

        $List = BannerModel::BannerList($Condition);

        $this->returnApiData('获取成功',200,$List);
    }

}