<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/10/19
 * Time: 15:09
 * 用户银行卡控制器
 * 肖亚子
 */

namespace app\system\Controller;

use app\common\AdminBaseController;
use app\system\model\UserbankModel;

class UserbankController extends AdminBaseController{

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取全部用户银行卡
     * 肖亚子
     */
    public function BankList(){
        $Condition = array();
        $Psize     = $this->get("page",1);//当前分页页数默认第一页
        $Title     = $this->get("title");
        $BankId    = $this->get("bank_id",0);

        if ($Title){
            $Condition["b.account_name|b.account_number|b.account_tel|u.nickname|u.mobile"] = array("like","%$Title%");
        }
        if ($BankId){
            $Condition["b.bank_id"] = array("eq",$BankId);
        }

        $DataList = UserbankModel::BankList($Condition,$Psize,50);
        $BankList = UserbankModel::PlatformBank();

        $this->assign("title",$Title);
        $this->assign("bankid",$BankId);
        $this->assign("banklist",$BankList);
        $this->assign("data",$DataList);
        return $this->display('list', true);
    }
}