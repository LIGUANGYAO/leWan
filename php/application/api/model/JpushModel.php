<?php

namespace app\api\model;

use JPush\Client;
use think\Config;
use think\Db;

/**
 * 极光推送
 * Class NotifyModel
 * @package app\api\model
 */
class JpushModel
{

    public static function sendMsg($data=[]){
        vendor('jpush.autoload');
        $config = Config::get('jpush');
        if ($config['production']) {
            $production = true;
        } else {
            $production = false;
        }
        $jpush = new  Client($config['jpush_key'],$config['jpush_secret']);

        $pusher = $jpush->push();
        $pusher->setPlatform($data['platform']);
        $pusher->addAllAudience();
        $pusher->setNotificationAlert($data['title']);
        $pusher->addAndroidNotification($data['title'], $data['title'], 1, array("type" => $data['type']));
        $pusher->addIosNotification($data['title'], 'default', '+1', true, 'iOS category', array("type" => $data['type']));
        try {
            return $pusher->send();
        } catch (\JPush\Exceptions\JPushException $e) {
            GLog('极光推送失败',$e);
        }
    }

    public static function sendMsgSpecial($regid,$data=[]){
        vendor('jpush.autoload');
        $config = Config::get('jpush');
        if ($config['production']) {
            $production = true;
        } else {
            $production = false;
        }
        $jpush = new  Client($config['jpush_key'],$config['jpush_secret']);
        $pusher = $jpush->push();
        $pusher->setPlatform('all');
        $pusher->addRegistrationId($regid);
        $pusher->setNotificationAlert($data['title']);
        $pusher->addAndroidNotification($data['alert'],$data['title'],1, array("type" => $data['type']));
        $pusher->addIosNotification('乐玩联盟测试-ios-唯一设备测试', 'default', '+1', true, 'iOS category', array("type" =>  $data['type']));
        try {
            return $pusher->send();
        } catch (\JPush\Exceptions\JPushException $e) {
            GLog('极光推送失败',$e);
        }
    }

}