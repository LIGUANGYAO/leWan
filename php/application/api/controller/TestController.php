<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/1
 * Time: 9:33
 */

namespace app\api\controller;


use app\api\model\CommissionModel;
use app\api\model\HelpModel;
use app\api\model\OpenTmModel;
use app\common\model\AccountRecordModel;
use app\common\model\Currency;
use app\common\model\CurrencyAction;
use app\common\model\ProcedureModel;
use think\Db;

class TestController extends ApiBaseController
{

    public function index(){
        $cm = new CommissionModel();
        fuck($cm->build(22));
    }

}