<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/5
 * Time: 10:03
 */

use \Workerman\Worker;
use \Workerman\Lib\Timer;
require_once __DIR__ . '/vendor/Workerman/Autoloader.php';

$task = new Worker();
// 开启多少个进程运行定时任务，注意业务是否在多进程有并发问题
$task->count = 1;
$task->onWorkerStart = function($task)
{

    // 每3秒执行一次
    $time_interval = 3;
    Timer::add($time_interval, function()
    {
        $ch = curl_init ();
        curl_setopt ( $ch, CURLOPT_URL, 'http://weixin.lewan6.ren/Api/Msg/sendMsgToWechat' );
        curl_setopt ( $ch, CURLOPT_POST, 1 );
        curl_setopt($ch, CURLOPT_HEADER, 0);
        $header = ['product:wechat','platform:pn'];
        curl_setopt ( $ch, CURLOPT_HTTPHEADER,  $header);
        curl_setopt ( $ch, CURLOPT_RETURNTRANSFER, 1 );
//        curl_setopt($ch, CURLOPT_POSTFIELDS, ['userId'=>$userId]);
        $return = curl_exec ( $ch );
        curl_close ( $ch );
        var_dump($return);
        echo $return."\r\n";
    });
};

// 运行worker
Worker::runAll();

