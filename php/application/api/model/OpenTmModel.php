<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/9
 * Time: 13:42
 */

namespace app\api\model;

/**
 * 微信服务号通知模板
 * Class OpenTmModel
 * @package app\api\model
 */
class OpenTmModel
{

    /**
     * 用户等级升级模板
     * @param $order
     */
    public function sendTplmsg1($openid,  $data, $accesstoken){
        $obj['touser'] = $openid;
        $obj['template_id'] = 'R_ZBYmLPDAFXbkhcUEZFHzmbHDCTlUBJS02ADb3zE20';
        $obj['data'] = [
            'first'=>['value'=>$data['title'], 'color'=>'#173177'],
            'grade1'=>['value'=>$data['grade1'], 'color'=>'#173177'],   //原先等级
            'grade2'=>['value'=>$data['grade2'], 'color'=>'#173177'],   //当前等级
            'time'=>['value'=>date('Y-m-d H:i:s'), 'color'=>'#3c3c3c'],  //变更时间
            'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
        ];
        $res = wx_post('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$accesstoken, json_encode($obj));
    }



    /**
     * 预约成功提示
     * @param $order
     */
    public function sendTplmsg2($openid,  $data, $accesstoken){
        $obj['touser'] = $openid;
        $obj['template_id'] = 'h4t51xZsdQQW_r0OXf9lkjfuY3FJdVD2I73hOvMhppg';
        $obj['data'] = [
            'first'=>['value'=>$data['title'], 'color'=>'#173177'],
            'keyword1'=>['value'=>$data['keyword1'], 'color'=>'#173177'], //预约项目
            'keyword2'=>['value'=>$data['keyword2'], 'color'=>'#173177'], //预约数量
            'keyword3'=>['value'=>$data['keyword3'], 'color'=>'#3c3c3c'], //使用时间
            'keyword4'=>['value'=>$data['keyword4'], 'color'=>'#3c3c3c'], //地址
            'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
        ];
        $res = wx_post('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$accesstoken, json_encode($obj));
    }



    /**
     * 客户本人支付成功,默认无电子码
     * @param $order
     */
    public function sendTplmsg3($openid, $data, $accesstoken){
        $obj['touser'] = $openid;
        $obj['template_id'] = 'EXH4dqYkMapIZZWOfmoQ7GhRs9056afwEk5wdyLRaWc';
        $obj['data'] = [
            'first'=>['value'=>$data['title'], 'color'=>'#173177'],
            'keyword1'=>['value'=>$data['keyword1'], 'color'=>'#173177'], //商品信息
            'keyword2'=>['value'=>$data['keyword2'], 'color'=>'#173177'], //交易单号
            'keyword3'=>['value'=>$data['keyword3'], 'color'=>'#3c3c3c'], //支付金额
            'keyword4'=>['value'=>$data['keyword4'], 'color'=>'#3c3c3c'], //支付时间
            'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
        ];
        $res = wx_post('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$accesstoken, json_encode($obj));
    }


    /**
     * 上线返佣
     * @param $order
     */
    public function sendTplmsg5($openid, $data, $accesstoken){
        $obj['touser'] = $openid;
        $obj['template_id'] = 'ReLdbs-BVJ0dp52bJdz7kSPZvkVJw5UiBnt2O6kkngI';
        $obj['data'] = [
            'first'=>['value'=>$data['title'], 'color'=>'#173177'],
            'keyword1'=>['value'=>$data['keyword1'], 'color'=>'#173177'], //商品信息
            'keyword2'=>['value'=>$data['keyword2'], 'color'=>'#173177'], //订单编号
            'keyword3'=>['value'=>$data['keyword3'], 'color'=>'#3c3c3c'], //佣金金额
            'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
        ];
        $res = wx_post('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$accesstoken, json_encode($obj));
    }

    /**
     * 推送商品给用户
     * @param $order
     */
    public function sendTplmsg6($openid, $data, $accesstoken,$url=''){
        $obj['touser'] = $openid;
        $obj['template_id'] = 'hnsmaGvMRG67SggZZTOKdlsgsA1F8IzZAfK-9tfHxAQ';
        $obj['data'] = [
            'first'=>['value'=>$data['title'], 'color'=>'#173177'],
            'keyword1'=>['value'=>$data['keyword1'], 'color'=>'#173177'], //商品信息
            'keyword2'=>['value'=>$data['keyword2'], 'color'=>'#173177'], //订单编号
            'keyword3'=>['value'=>$data['keyword3'], 'color'=>'#3c3c3c'], //佣金金额
            'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
        ];
        $obj['url'] = $url;

        $res = wx_post('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$accesstoken, json_encode($obj));
    }

}