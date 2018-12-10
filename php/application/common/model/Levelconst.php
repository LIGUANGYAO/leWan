<?php
namespace app\common\model;

class Levelconst{

    const Level1 = 1;
    const Level2 = 2;
    const Level3 = 3;
    const Level4 = 4;
    const Level5 = 5;

    public static function getName($level){
        switch ($level){
            case self::Level1:
                return '普通会员';
            case self::Level2:
                return '超级会员';
            case self::Level3:
                return '分享达人';
            case self::Level4:
                return '运营达人';
            case self::Level5:
                return '玩主';
        }
    }

}