<?php

/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/7/4
 * Time: 17:07
 */

namespace app\common\model;

/**
 * 货币标签
 * Class Currency
 * @package V4\Model
 */
class Tag {

    const Year = 'year';
    const LastYear = 'last_year';
    const Month = 'month';
    const LastMonth = 'last_month';
    const ToDay = 'day';
    const Yesterday = 'yesterday';

    /**
     * 获取表前缀
     * @return string
     */
    public static function getTbSuffix(){
        return '';
    }

    /**
     * 获取标签
     * @param string $type ： total, year, last_year month, last_month, day, yesterday
     * @param int $time
     * @return int
     */
    public static function get($type = 'total', $time = 0) {
        if ($type == 'total')
            return 0;
        if ($time == 0)
            $time = time();
        switch ($type) {
            case 'year':
                return date('Y', $time);
            case 'last_year':
                return date('Y', $time) - 1;
            case 'month':
                return date('Ym', $time);
            case 'last_month':
                return date('Ym', $time) - 1;
            case 'day':
                return date('Ymd', $time);
            case 'yesterday':
                return date('Ymd', $time - 3600 * 24);
        }
        return 0;
    }

    /**
     * 获取当年或指定年标签
     * @param int $time
     * @return int
     */
    public static function getYear($time = 0) {
        return self::get('year', $time);
    }

    /**
     * 获取去年或指定年前一年标签
     * @param int $time
     * @return int
     */
    public static function getLastYear($time = 0) {
        return self::get('last_year', $time);
    }

    /**
     * 获取当年或指定年标签
     * @param int $time
     * @return int
     */
    public static function getMonth($time = 0) {
        return self::get('month', $time);
    }

    /**
     * 获取去年或指定年前一年标签
     * @param int $time
     * @return int
     */
    public static function getLastMonth($time = 0) {
        return self::get('last_month', $time);
    }

    /**
     * 获取当天或指定日期标签
     * @param int $time
     * @return int
     */
    public static function getDay($time = 0) {
        return self::get('day', $time);
    }

    /**
     * 获取昨天或指定日期前一天标签
     * @param int $time
     * @return int
     */
    public static function getYesterday($time = 0) {
        return self::get('yesterday', $time);
    }


    /**
     * 获取周几
     * @param $dat
     * @return string
     */
    public static function getWeek($dat){
        $wi = date('N', strtotime($dat));
        switch ($wi){
            case 1:
                return '周一';
            case 2:
                return '周二';
            case 3:
                return '周三';
            case 4:
                return '周四';
            case 5:
                return '周五';
            case 6:
                return '周六';
            case 7:
                return '周日';
            default:
                return '无';
        }
    }
}
