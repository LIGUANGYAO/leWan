<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 17:05
 */

namespace app\system\controller;


use app\common\AdminBaseController;

/**
 * 商家钱包
 * Class FinanceController
 * @package app\system\controller
 */
class MerchantaccountController extends AdminBaseController
{

    public function index(){
        return $this->display('index:index', true);
    }
}