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
        if(intval($res['errcode'])!==0){
            GLog('User level upgrade To WeChat template messages Err{obj:'.$openid.'}',json_encode($res));
        }
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
        if(intval($res['errcode'])!==0){
            GLog('book successfully To WeChat template messages Err{obj:'.$openid.'}',json_encode($res));
        }
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
        if(intval($res['errcode'])!==0){
            GLog('customer paid successfully To WeChat template messages Err{obj:'.$openid.'}',json_encode($res));
        }
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
        if(intval($res['errcode'])!==0){
            GLog('Rebate To WeChat template messages Err{obj:'.$openid.'}',json_encode($res));
        }
    }

    /**
     * 推送商品给用户
     * @param $order
     */
    public static function sendTplmsg6($openid, $data, $accesstoken,$url='',$j=false){
        //        $obj['template_id'] = 'wJdtYfLoF_e96Evuja6NaPGuE0DA5zzaCH90gI4fZD0';//测试环境通知模板
        // 模板名 = ['订购提醒','订购提醒1','商品到货提醒','作品发布完成通知','作品发布完成通知1',];
        $tempids=['znpk7mM-3lwp0BKgNQRO6f1XT4M-_269lL66PqY0618','VvgtktZsaFSav_56AIHY12p_97G9VGNChB4P_KOMuQI','cRfO4uxiq2bLWs78Tx5UG30tLAwK3iXUbY-ZQsIE7jg','dbfz-on9C9upfmrgfJ-8UiIDTzEoOnIWpc3DMGQ0Qs4','pFDbh7j70mROCD5th-bq6pu2_UP0aBuNKw7M2TgyXcA'];
        if($j===false){
            $j = rand(0,4);
        }
        switch ($j){
            case 1:
                $obj['data'] = [
                    'first'=>['value'=>$data['title'], 'color'=>'#173177'],
                    'keyword1'=>['value'=>$data['product_name'], 'color'=>'#173177'],
                    'keyword2'=>['value'=>$data['sku'].'份', 'color'=>'#173177'],
                    'keyword3'=>['value'=>'爆品推荐', 'color'=>'#3c3c3c'],
                    'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
                ];
                break;
            case 2:
                $obj['data'] = [
                    'first'=>['value'=>$data['title'], 'color'=>'#173177'],
                    'keyword1'=>['value'=>$data['product_name'], 'color'=>'#173177'],
                    'keyword2'=>['value'=>$data['sku'].'份', 'color'=>'#173177'],
                    'keyword3'=>['value'=>'乐玩联盟', 'color'=>'#3c3c3c'],
                    'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
                ];
                break;
            case 3:
                $obj['data'] = [
                    'first'=>['value'=>$data['title'], 'color'=>'#173177'],
                    'keyword1'=>['value'=>'爆品推荐', 'color'=>'#173177'],
                    'keyword2'=>['value'=>$data['product_name'], 'color'=>'#173177'],
                    'keyword3'=>['value'=>date('Y-m-d H:i:s'), 'color'=>'#3c3c3c'],
                    'keyword4'=>['value'=>'暂无', 'color'=>'#3c3c3c'],
                    'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
                ];
                break;
            case 4:
                $obj['data'] = [
                    'first'=>['value'=>$data['title'], 'color'=>'#173177'],
                    'keyword1'=>['value'=>'爆品推荐', 'color'=>'#173177'],
                    'keyword2'=>['value'=>date('Y-m-d H:i:s'), 'color'=>'#173177'],
                    'keyword3'=>['value'=>$data['product_name'], 'color'=>'#3c3c3c'],
                    'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
                ];
                break;
            default:
                $obj['data'] = [
                    'first'=>['value'=>$data['title'], 'color'=>'#173177'],
                    'keyword1'=>['value'=>'爆品推荐', 'color'=>'#173177'],
                    'keyword2'=>['value'=>$data['product_name'], 'color'=>'#173177'],
                    'keyword3'=>['value'=>date('Y-m-d H:i:s'), 'color'=>'#3c3c3c'],
                    'keyword4'=>['value'=>'爆品推荐', 'color'=>'#3c3c3c'],
                    'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
                ];
                break;
        }
        $obj['touser'] = $openid;
        $obj['template_id'] =  $tempids[$j];
        $obj['url'] = $url;
        $res = wx_post2('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$accesstoken, json_encode($obj));
        if(intval($res['errcode'])!==0){
            GLog('Share Product To WeChat template{temp ID'. $tempids[$j].'} messages Err{obj:'.$openid.'}',json_encode($res));
        }
        return $res;
    }


    /**
     * 邀请注册成功推送
     * @param $order
     */
    public function sendTplmsg7($openid, $data, $accesstoken,$url=''){
        $obj['touser'] = $openid;
        $obj['template_id'] = 'YkJnUlJU2a6bPQRRa7zG8vwGqtdqAJQQ-V9Z5eA9OwY';
        $obj['data'] = [
            'first'=>['value'=>$data['title'], 'color'=>'#173177'],
            'keyword1'=>['value'=>$data['keyword1'], 'color'=>'#173177'], //会员帐号
            'keyword2'=>['value'=>$data['keyword2'], 'color'=>'#173177'], //注册时间
            'remark'=>['value'=>$data['remark'], 'color'=>'#173177'],
        ];
        $obj['url'] = $url;
        $res = wx_post('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token='.$accesstoken, json_encode($obj));
        if(intval($res['errcode'])!==0){
            GLog('Invitation to register To WeChat template messages Err{obj:'.$openid.'}',json_encode($res));
        }
    }



}