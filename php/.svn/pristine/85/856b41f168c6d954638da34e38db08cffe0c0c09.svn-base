<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/7/4
 * Time: 17:07
 */

namespace app\common\model;


/**
 * 货币类型
 * Class Currency
 * @package V4\Model
 */
class Currency
{
    /**
     * 现金币
     */
    const Cash = 'cash';

    /**
     * 积分
     */
    const Points = 'points';

    /**
     * 预估佣金
     */
    const Commission = 'commission';
    /**
     * 获取货币类型名称
     * @param Currency $currency
     * @return string
     */
    public static function getLabel($currency)
    {
        switch ($currency) {
            case self::Cash:
                return '现金币';
            case self::Points:
                return '积分';
            case self::Commission:
                return '预估佣金';
        }
        return '未知';

    }
}