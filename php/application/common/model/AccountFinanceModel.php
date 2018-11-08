<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/2
 * Time: 14:18
 */

namespace app\common\model;
use think\Db;

/**
 * 会员财务统计
 * Class AccountFinanceModel
 * @package app\common\model
 */
class AccountFinanceModel
{

    const finance_settle = 'finance_settle';     //累计已结算金额
    const finance_withdraw = 'finance_withdraw'; //累计提现
    const finance_recharge = 'finance_recharge'; //累计充值
    const finance_first = 'finance_first';  //累计一级佣金
    const finance_second = 'finance_second';  //累计二级佣金
    const finance_operations = 'finance_operations';  //累计运营佣金
    const finance_operationchilds = 'finance_operationchilds';  //累计运营奖金
    const finance_playerhost = 'finance_playerhost';  //玩主奖金
    const finance_taxfee = 'finance_taxfee';  //累计扣除的管理费，个税..
    const finance_hanldfee = 'finance_hanldfee';  //累计扣除的提现等手续费


    /**
     * 初始化账户资金明细
     * @param $userId
     */
    public static function init($userId){
        $sql1 = "insert IGNORE into jay_account_finance(user_id, finance_tag, finance_uptime) VALUES (".$userId.", 0,".time().");";
        Db::execute($sql1);
        return true;
    }

}