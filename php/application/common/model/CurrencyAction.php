<?php

/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/7/4
 * Time: 17:52
 */

namespace app\common\model;
/**
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
     * 佣金累计结算到现金
     */
    const CashFromCommissionCleanAll = 803;

    /**
     * 提现失败退回
     */
    const CashWithdrawFaillBack = 804;

    /**
     * 微信消费充值
     */
    const CashRechargeWechatResume = 805;

    /**
     * 支付宝消费充值
     */
    const CashRechargeAlipayResume = 806;





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

    /**
     * 扣除个人所得税
     */
    const CashDeductionGeren = 853;

    /**
     * 扣除平台管理费
     */
    const CashDeductionPingtai = 854;

    /**
     * 扣除技术服务费
     */
    const CashDeductionJishu = 855;

    /**
     * 扣除提现手续费
     */
    const CashTixianFee = 856;

    /**
     * 支付宝消费
     */
    const CashAlipayResume = 857;

    /**
     * 微信消费
     */
    const CashWechatResume = 858;

    /**
     * 后台扣款
     */
    const CashDeducAdmin = 859;


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
     * （次月结算）运营奖金[直属下级 运营达人佣金的x%]
     */
    const CommissionOperationsChilds = 604;

    /**
     * 佣金解冻
     */
    const CommissionFreezeReturn = 605;

    /**
     * （次月结算）玩主奖金
     */
    const CommissionPlayerhostChild = 606;

    /**
     * （次月结算）新人免单全返
     */
    const CommissionReturnAll = 607;


    /**
     * 佣金结算现金[每次0点自动结算:前一天的一级佣金、上级佣金、运营佣金]
     */
    const CommissionAutoCleanToCash = 651;

    /**
     * 佣金结算现金[次月结算：运营奖金8%、玩主奖金2%,新人免单]
     */
    const CommissionAdminCleanToCash = 652;


    /**
     * 佣金冻结
     */
    const CommissionFreeze = 653;

    /**
     * 后台扣除
     */
    const CommissionDecodeBack = 654;







    /********************* 积分 points  ************************ */




    /********************* 商家现金  ************************ */
    /**
     * 电子码消单进账
     */
    const MCashfromxiaodan = 901;


    /**
     * 收货订单完成进账
     */
    const MCashfromOrderSuc = 902;


    /**
     * 后台充值
     */
    const MCashRechargeadmin = 903;



    /**
     * 后台扣款
     */
    const MCashDeducAdmin = 950;

    /**
     * 后台结账提现
     */
    const MCashSettleAdmin = 952;



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
            case CurrencyAction::CashFromCommissionCleanAll:
                return '佣金累计结算到现金';
            case CurrencyAction::CashWithdrawFaillBack:
                return '提现失败退回';
            case CurrencyAction::CashWithdrawToAlipay:
                return '提现到支付宝';
            case CurrencyAction::CashWithdrawToWechat:
                return '提现到微信';
            case CurrencyAction::CashWithdrawToBank:
                return '提现到银行卡';
            case CurrencyAction::CashRechargeWechatResume:
                return '微信消费充值';
            case CurrencyAction::CashRechargeAlipayResume:
                return '支付宝消费充值';
            case CurrencyAction::CashWechatResume:
                return '微信消费';
            case CurrencyAction::CashAlipayResume:
                return '支付宝消费';
			case CurrencyAction::CashDeductionGeren:
                return '扣除个人所得税';
			case CurrencyAction::CashDeductionPingtai:
                return '扣除平台管理费';
			case CurrencyAction::CashDeductionJishu:
                return '扣除技术服务费';
			case CurrencyAction::CashTixianFee:
                return '扣除提现手续费';
            case CurrencyAction::CashDeducAdmin:
                return '后台扣款';

            case CurrencyAction::CommissionFirst:
                return '一级佣金';
            case CurrencyAction::CommissionSecond:
                return '上级佣金';
            case CurrencyAction::CommissionOperations:
                return '运营佣金';
            case CurrencyAction::CommissionOperationsChilds:
                return '运营奖金';
            case CurrencyAction::CommissionPlayerhostChild:
                return '玩主奖金';
            case CurrencyAction::CommissionAutoCleanToCash:
                return '佣金自动结算现金';
            case CurrencyAction::CommissionAdminCleanToCash:
                return '佣金后台结算现金';
            case CurrencyAction::CommissionFreezeReturn:
                return '佣金解冻';
            case CurrencyAction::CommissionFreeze:
                return '佣金冻结';
            case CurrencyAction::CommissionReturnAll:
                return '新人免单全返';
            case CurrencyAction::CommissionDecodeBack:
                return '后台扣款';


            default:
                return $currencyAction . '未知';
        }
    }




}
