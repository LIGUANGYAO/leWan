<?php
namespace app\common;


/**
 * 正在表达式类型
 * Class Currency
 * @package app\common;
 */
class RegExpression
{
    /**
     * 必填项
     */
    const REQUIRED = 'require';

    /**
     * 至少2位字符串
     */
    const MIN2 = 'min2';
    
    /**
     * 至少6位字符串
     */
    const MIN6 = 'min6';
    
    /**
     * 至少5位字符串
     */
    const MIN5 = 'min5';

    /**
     * 验证码
     */
    const CAPTCHA = 'captcha';
    

    /**
     * 数字
     */
    const NUMBER = 'number';

    /**
     * 手机号
     */
    const MOBILE = 'mobile';

    /**
     * 座机号
     */
    const PHONE = 'phone';
    
    /**
     * 电子邮箱
     */
    const EMAIL = 'email';
    
    /**
     * 身份证
     */
    const IDCARD = 'idcard';
    
    /**
     * 金额
     */
    const MONEY = 'money';
    
    /**
     * 汉字中文
     */
    const CHSCHAR = 'chschar';

    /**
     * 英文字符
     */
    const STRING = 'string';

    /**
     * 获取对应的正则
     * @param Currency $currency
     * @return string
     */
    public static function getExp($reg)
    {
        switch ($reg) {
            case self::STRING:
                return '/^[a-zA-Z0-9]+$/';
            case self::MONEY:
                return '/^[0-9]{1,}(.[0-9]{1,})?$/';
            case self::NUMBER:
                return '/^[0-9]+$/';
            case self::CHSCHAR:
                return '/^[\x{4e00}-\x{9fa5}]+$/u';
            case self::MOBILE:
                return '/^1(3|4|5|7|8){1}[0-9]{1}[0-9]{8}$/';
            case self::PHONE:
                return '/^(0[0-9]{2,3}-)?([0-9]{7,8})+(-[0-9]{1,4})?$/';
            case self::EMAIL:
                return '/^([a-zA-Z0-9_-]){1,}@([a-zA-Z0-9_-]){1,}\.([a-zA-Z0-9_-]){1,}$/';
            case self::IDCARD:
                return '/^[1-9]{1}[0-9]{5}[1-2]{1}[0-9]{7}[0-9]{3}([0-9]{1}|X|x)$/';
            default:
                return '';
        }
        return '';

    }
}