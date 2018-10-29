<?php

/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/7/4
 * Time: 17:52
 */

namespace app\common\model;
/**
 * 货币操作类型，与旧版货币明细类型BONUS_TYPE值保持一致
 * Class CurrencyAction
 * @package V4\Model
 *
 *
 * @internal 第三方：指理财平台
 */
class CurrencyAction
{
    /********************* 现金余额 cash  ************************ */
    /**
     * 现金余额充值
     */
    const CashRecharge = 801;

    /**
     * 佣金结算到现金
     */
    const CashFromCommissionClean = 802;

    /**
     * 提现失败退回
     */
    const CashWithdrawFaillBack = 803;

    /**
     * 提现到支付宝
     */
    const CashWithdrawToAlipay = 850;

    /**
     * 提现到微信
     */
    const CashWithdrawToWechat = 851;

    /**
     * 提现到银行卡
     */
    const CashWithdrawToBank = 852;


    /********************* 预估佣金 commission  ************************ */
    
    /**
     * 一级佣金
     */
    const CommissionFirst = 601;

    /**
     * 上级佣金
     */
    const CommissionSecond = 602;

    /**
     * 运营佣金
     */
    const CommissionOperations = 603;

    /**
     * 运营奖金
     */
    const CommissionOperationsChilds = 604;

    /**
     * 佣金解冻
     */
    const CommissionFreezeReturn = 605;

    /**
     * 佣金结算现金
     */
    const CommissionCleanToCash = 651;

    /**
     * 佣金冻结
     */
    const CommissionFreeze = 652;

    /********************* 积分 points  ************************ */


    /**
     * 获取货币类型名称
     * @param CurrencyAction $currencyAction
     * @return string
     */
    public static function getLabel($currencyAction)
    {
        switch ($currencyAction) {
            //现金币
            case CurrencyAction::CashRecharge:
                return '现金余额充值';
            case CurrencyAction::CashFromCommissionClean:
                return '佣金结算到现金';
            case CurrencyAction::CashWithdrawFaillBack:
                return '提现失败退回';
            case CurrencyAction::CashWithdrawToAlipay:
                return '提现到支付宝';
            case CurrencyAction::CashWithdrawToWechat:
                return '提现到微信';
            case CurrencyAction::CashWithdrawToBank:
                return '提现到银行卡';

            case CurrencyAction::CommissionFirst:
                return '一级佣金';
            case CurrencyAction::CommissionSecond:
                return '上级佣金';
            case CurrencyAction::CommissionOperations:
                return '运营佣金';
            case CurrencyAction::CommissionOperationsChilds:
                return '运营奖金';
            case CurrencyAction::CommissionCleanToCash:
                return '佣金结算现金';
            case CurrencyAction::CommissionFreezeReturn:
                return '佣金解冻';
            case CurrencyAction::CommissionFreeze:
                return '佣金冻结';



            default:
                return $currencyAction . '未知';
        }
    }




}
