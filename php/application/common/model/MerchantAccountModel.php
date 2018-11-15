<?php

namespace app\common\model;

use think\Db;

/**
 * 商户实时统计数据模块
 */
class MerchantAccountModel {

    /**
     * @return string
     */
    private static function getTableName() {
        $_tableName = 'merchant_account';
        return $_tableName;
    }

    /**
     * 获取商户实时统计数据
     * @param $merchantId
     * @param string $fields
     * @param int $tag 请用Tag
     * @return mixed
     */
    public static function getItemByMerchantId($merchantId, $fields = '*', $tag = 0) {
        $balance  =  Db::name(self::getTableName())
                    ->where('`merchant_id`=:merchant_id AND `account_tag`=:account_tag')
                    ->bind(['merchant_id'=>$merchantId, 'account_tag'=>$tag])
                    ->field($fields)
                    ->order('account_id desc')
                    ->find();
        return $balance;
    }

    /**
     * 锁行
     * @param $merchantId
     * @param string $fields
     * @param int $tag  请用Tag
     */
    public static function lockMerchantItem($merchantId, $fields = '*', $tag = 0) {
        return Db::name(self::getTableName())->lock(true)
                    ->where('`merchant_id`=:merchant_id AND `account_tag`=:account_tag')
                    ->bind(['merchant_id'=>$merchantId, 'account_tag'=>$tag])
                    ->field($fields)
                    ->order('account_id desc')
                    ->find();
    }


    /**
     * 判断商户指定标签统计记录ID
     * @param $merchantId
     * @param int $tag
     * @return mixed
     */
    public static function getMerchantAccountIdByTag($merchantId, $tag = 0) {
        return Db::name(self::getTableName())->lock(true)
            ->where('`merchant_id`=:merchant_id AND `account_tag`=:account_tag')
            ->bind(['merchant_id'=>$merchantId, 'account_tag'=>$tag])
            ->order('account_id desc')
            ->value('account_id');
    }

    /**
     * 新增商户统计数据
     * @param $merchantId
     * @param $amount 操作金额
     * @param $recordBalance  余额
     * @param int $tag
     * @param int $acction
     * @return int|string
     */
    public static function add($merchantId, $amount, $recordBalance, $tag = 0, $acction=MerchantAccountRecordModel::ACTION_INCOME) {
        $item = [
            'merchant_id' => $merchantId,
            'account_cash_balance' => $recordBalance,
            'account_tag' => $tag,
            'account_uptime' => time()
        ];
        if ($acction == MerchantAccountRecordModel::ACTION_INCOME) { //收入
            $item['account_cash_income'] = $amount;
        } else {
            $item['account_cash_expenditure'] = $amount;
        }
        return Db::name(self::getTableName())->insert($item);
    }

    /**
     * 更新用户统计数据
     * @param $accountId
     * @param $amount 操作金额
     * @param $recordBalance 余额
     * @param int $tag
     * @return int|string
     */
    public static function update($accountId, $amount, $recordBalance, $acction=MerchantAccountRecordModel::ACTION_INCOME) {
        if ($acction == MerchantAccountRecordModel::ACTION_INCOME) {
            $item['account_cash_income'] = ['exp', 'account_cash_income' . '+' . $amount];
        } else {
            $item['account_cash_expenditure'] = ['exp', 'account_cash_expenditure' . '+' . $amount];
        }
        $item['account_cash_balance'] = $recordBalance;
        return Db::name(self::getTableName())->where(array('account_id' => $accountId))->update($item);
    }

    /**
     * 实时统计用户帐户数据
     * @param $merchantId 商户ID
     * @param float $amount 操作金额
     * @param float $recordBalance 余额
     * @return bool 操作结果
     */
    public static function save($merchantId, $amount, $recordBalance,$acction=MerchantAccountRecordModel::ACTION_INCOME) {
        if ($amount == 0) {
            return false;
        }
        // 更新商户帐户总额数据
        $_totalAccountId = self::getMerchantAccountIdByTag($merchantId, Tag::get());
        if ($_totalAccountId > 0) {
            if (!self::update($_totalAccountId, $amount, $recordBalance, $acction)) {
                return false;
            }
        } else {
            if (!self::add($merchantId, $amount, $recordBalance, Tag::get(), $acction)) {
                return false;
            }
        }
        // 更新商户帐户当日数据
        $_dayAccountId = self::getMerchantAccountIdByTag($merchantId, Tag::getDay());
        if ($_dayAccountId > 0) {
            if (!self::update($_dayAccountId, $amount, $recordBalance,$acction)) {
                return false;
            }
        } else {
            if (!self::add($merchantId, $amount, $recordBalance, Tag::getDay(), $acction)) {
                return false;
            }
        }
        return true;
    }


}
