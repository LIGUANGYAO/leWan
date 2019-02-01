<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 13:56
 * 订单管理模型
 * author@yihong
 */

namespace app\tapi\model;
use think\Db;

class OrderModel{

    const happy_valley_host = 'http://api.123menpiao.com'; //123门票api url
    const client_id = 'fba100bb';//123门票网
    const client_secret = 'c1bbde2b953e';//123门票网
//    const happy_valley_host = 'http://test.123wlx.cn'; //123门票api url(测试环境)
//    const client_id = 'lewan';//123门票网(测试环境)
//    const client_secret = 'lewan123';//123门票网（测试环境）

    const cloud_getorder_url = 'http://o2o.9uhd.com/v2/ota/getorder'; //欢乐云下单api url
    const cloud_appid = 'lewan';//欢乐云
    const corpcode = '36542';//欢乐云企业编号
    const cloud_secret = '_bP63iCEgqCn4OhseIUYWslB6P_aan7KMR4E073OYsZJJ1FliItFFI3A';//欢乐云

    /**
     * 欢乐谷（123门票下单）
     * @param $data
     * @return bool
     */
    public static function createOrderToHappyValley($data){
        $url = self::happy_valley_host.'/vapi/v1/distributor/orders';
        $data['client_id'] =  self::client_id;
        $data['timestamp'] =  date('Y-m-d H:i:s');
        ksort($data);
        $str = '';

        foreach ($data as $key=>$val){
            if($val){
                $str.=$key.''.$val;
            }
        }
        $str = md5(self::client_secret.$str.self::client_secret);
        $data['signature'] =  $str;
        $res = curlPost($url,$data);
        GLog('123门票网分销返回',$res);
        $newRes = json_decode($res,true);
        if($newRes['code']==200){
            Db::name('order')->where(['order_id'=>$data['partner_order_number']])->update(['dboss_main_orderno'=>$newRes['response']['order_number'],'dboss_child_ordernos'=>$newRes['response']['code'],'distributionsendcode'=>1]);
            GLog('123门票网分销成功ID:'.$data['partner_order_number'],'sql:'.Db::name('order')->getLastSql());
        }else{
            Db::name('order')->where(['order_id'=>$data['partner_order_number']])->update(['oredr_remark'=>$newRes['message']]);
            GLog('123门票网分销失败:', Db::name('order')->getLastSql());
        }
    }

}