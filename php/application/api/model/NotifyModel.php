<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/6
 * Time: 18:02
 */

namespace app\api\model;
use app\common\model\AccountRecordModel;
use app\common\model\Currency;
use app\common\model\CurrencyAction;
use app\common\model\PayMethod;
use think\Db;

/**
 * 支付通知业务处理
 * Class NotifyModel
 * @package app\api\model
 */
class NotifyModel
{

    public function notifyMall($order, $notifyparams, $paymethod, $cfg){
        //1.更新订单状态
        $uporder['order_transaction'] = $notifyparams['transaction_id'];
        $uporder['order_paytime'] = time();
        $uporder['order_uptime'] = time();
        $uporder['order_status'] = 2;
        $arm = new AccountRecordModel();
        //支付cash明细
        if($paymethod == PayMethod::WxJSApi || $paymethod == PayMethod::WxAppNative){//微信
            $res5 = $arm->add($order['user_id'], $order['order_id'], Currency::Cash, CurrencyAction::CashRechargeWechatResume, $order['order_payfee'], $arm->getRecordAttach($order['order_id'], $order['order_fullname'], $order['order_no']), '微信消费充值');
            $res6 = $arm->add($order['user_id'], $order['order_id'], Currency::Cash, CurrencyAction::CashWechatResume, -$order['order_payfee'], $arm->getRecordAttach($order['order_id'], $order['order_fullname'], $order['order_no']), '微信消费');
            $uporder['order_payment'] = 1;
            if($paymethod == PayMethod::WxAppNative){
                $uporder['order_payment'] = 4;
            }
        }elseif($paymethod == PayMethod::AlipayNative){//支付宝
            $res5 = $arm->add($order['user_id'], $order['order_id'], Currency::Cash, CurrencyAction::CashRechargeWechatResume, $order['order_payfee'], $arm->getRecordAttach($order['order_id'], $order['order_fullname'], $order['order_no']), '微信消费充值');
            $res6 = $arm->add($order['user_id'], $order['order_id'], Currency::Cash, CurrencyAction::CashWechatResume, -$order['order_payfee'], $arm->getRecordAttach($order['order_id'], $order['order_fullname'], $order['order_no']), '微信消费');
            $uporder['order_payment'] = 2;
        }
        $res1 = Db::name('order')->where(['order_id'=>$order['order_id'], 'order_status'=>1])->update($uporder);

        //2.新人免单全返到佣金
        $res2 = true;
        if($order['product_returnall'] == 1){
            $res2 = $arm->add($order['user_id'], $order['order_id'], Currency::Commission, CurrencyAction::CommissionReturnAll, $order['order_payfee'], $arm->getRecordAttach($order['order_id'], '平台', $order['order_no']), '新人免单全返', 1);
        }

        //3.生成电子码
        $consume_code='';
        if($order['order_isexpress'] == 1 && $order['distributiontag'] == 0){
            $mom = new MallOrderModel();
            $consume_code = $mom->buildConsumeCode($order['order_id'], $order['num'], $order['user_id'], $order['op_id']);
        }
        //4.发放佣金+服务号通知
        $cm = new CommissionModel();
        $res3 = $cm->build($order['order_id'], $consume_code);
        //6.会员升级
        $upm = new UserUpgradeModel();
        $upm->check($order['user_id'], 2);
        if($res1 !== false && $res2 && $res3 !== false && $res5 && $res6){
            return ['res'=>true, 'code'=>$consume_code];
        }else{
            GLog('微信支付回调处理res1:',json_encode($res1));
            GLog('微信支付回调处理res2:',json_encode($res2));
            GLog('微信支付回调处理res3:',json_encode($res3));
            GLog('微信支付回调处理res5:',json_encode($res5));
            GLog('微信支付回调处理res6:',json_encode($res6));
            return ['res'=>false, 'code'=>$consume_code];
        }
    }


    public function sendOrderSms($order, $consume_code, $cfg){
        if($order['merchant_id'] == 21){
            //诺亚方舟短信单独
            $content = "【乐玩联盟】客人您好，非常感谢您购买诺亚方舟成人票，我们将在24小时内给您发送诺亚方舟电子消费码，凭码在30分钟后到门店前台即可核销使用，谢谢您的支持。";
        }elseif($order['merchant_id'] == 25){
            //浩海立方短信单独
            $content = "【乐玩联盟】客人您好，非常感谢您购买浩海立方海洋馆门票，我们将在24小时～48小时内给您发送专属电子消费码，本月21日起可用，凭码到前台即可核销使用，详情见购买链接。";
        }elseif($order['merchant_id'] == 54){
            //花水湾锦泰温泉酒店
            $content = "【乐玩联盟】客人您好，非常感谢您购买花水湾锦泰温泉酒店，我们将在12月25日给您发送专属电子消费码，12月26日起可凭电子码通过指定网站进行预约使用。详情请见购买链接。";
        }elseif($order['merchant_id'] == 58){
            //鹧鸪山
            $content = "【乐玩联盟】客人您好，非常感谢您购买鹧鸪山活动套餐，我们将在24小时内给您发送专属电子消费码，可凭电子码拨打预约电话预约使用，详情请见购买链接。";
        }elseif($order['merchant_id'] == 57){
            //万达瑞华
            $content = "【乐玩联盟】客人您好，非常感谢您购买万达瑞华酒店自助午餐，我们将在24小时内给您发送专属电子消费码，凭码在指定网站预约使用即可。";
        }elseif($order['merchant_id'] == 122){
            //二郎山·喇叭河
            $content = "【乐玩联盟】客人您好，非常感谢您购买喇叭河·五星豪华酒店1晚优惠套票 ，我们将在24小时内给您发送专属电子消费码，凭码在指定网站预约使用即可。";
        }elseif($order['merchant_id'] == 116){
            //瓦屋山
            $content = "【乐玩联盟】客人您好，非常感谢您购买瓦屋山亲子踏雪之旅套票，预约电话：13348888776,15928815726，请了解产品使用规则提前预约哦。";
        }elseif($order['order_reservation'] == 1 && $order['order_isexpress'] == 1){
            //到店预约类短信
            $content = config('cdxx_sms.content_ordersuccessyuyue');
            $content = str_replace('{name}', $order['order_fullname'], $content);
            $content = str_replace('{product}', $order['product_name'], $content);
            $content = str_replace('{num}', $order['num'], $content);
            $content = str_replace('{mtel}', $order['merchant_contactmobile'], $content);
            $content = str_replace('{code}', str_replace(',', "\r\n,",$consume_code), $content);
            $content = str_replace('{starttime}', date('m月d日',$order['product_startusetime']), $content);
            $content = str_replace('{yysj1}', $cfg['yy_start'], $content);
            $content = str_replace('{yysj2}', $cfg['yy_end'], $content);
            $codearray = explode(',', $consume_code);
            $yyurl='';
            foreach($codearray as $k=>$v){
                if($v){
                    $nativeurl= (isset($_SERVER['REQUEST_SCHEME'])?$_SERVER['REQUEST_SCHEME']:'http').'://'.$_SERVER['SERVER_NAME'].'/wechat_html/page/smsAppointment/smsVerify.html?code='.$v.'&mobile='.$order['order_mobile'];
                    $yyurl .= createShortUrl($nativeurl)."\r\n；";
                }
            }
            $content = str_replace('{yyurl}', $yyurl, $content);
            $content = str_replace('{yxq1}', date('Y-m-d', $order['product_startusetime']), $content);
            $content = str_replace('{yxq2}', date('Y-m-d', $order['product_endusetime']), $content);
        }elseif($order['order_reservation'] == 2 && $order['order_isexpress'] == 1){
            //到店免预约类短信
            $content = config('cdxx_sms.content_ordersuccessmianyuyue');
            if($order['merchant_id'] == 24){
                $content = "【乐玩联盟】尊敬的{name}，您购买的商品{product}已经支付成功，您{num}份电子码:{code}。不可预约当天），请添加商家微信号13666228828进行预约，有效期内每天库存以网站为准，约满即止。有效期{yxq1}至{yxq2}，逾期作废！商家电话：{mtel}。";
            }
            $content = str_replace('{name}', $order['order_fullname'], $content);
            $content = str_replace('{product}', $order['product_name'], $content);
            $content = str_replace('{num}', $order['num'], $content);
            $content = str_replace('{mtel}', $order['merchant_contactmobile'], $content);
            $content = str_replace('{code}', str_replace(',', "\r\n,",$consume_code), $content);
            $content = str_replace('{yxq1}', date('Y-m-d', $order['product_startusetime']), $content);
            $content = str_replace('{yxq2}', date('Y-m-d', $order['product_endusetime']), $content);
        }elseif($order['order_reservation'] == 3 && $order['order_isexpress'] == 1){
            //到店电话预约类短信
            $content = config('cdxx_sms.content_order_by_tel_yuyue');
            $content = str_replace('{name}', $order['order_fullname'], $content);
            $content = str_replace('{product}', $order['product_name'], $content);
            $content = str_replace('{num}', $order['num'], $content);
            $content = str_replace('{code}', str_replace(',', "\r\n,",$consume_code), $content);
            $content = str_replace('{yxq1}', date('Y-m-d', $order['product_startusetime']), $content);
            $content = str_replace('{yxq2}', date('Y-m-d', $order['product_endusetime']), $content);
        }elseif($order['order_reservation'] == 2 && $order['order_isexpress'] == 2){
            //快递商品,免预约
            $content = config('cdxx_sms.content_ordersuccesskuaidi');
            $content = str_replace('{name}', $order['order_fullname'], $content);
            $content = str_replace('{product}', $order['product_name'], $content);
            $content = str_replace('{orderno}', $order['order_no'], $content);
        }elseif($order['order_reservation'] == 1 && $order['order_isexpress'] == 2){
            //快递商品,预约制
            $content = config('cdxx_sms.content_ordersuccesskuaidiyuyue');
            $content = str_replace('{name}', $order['order_fullname'], $content);
            $content = str_replace('{product}', $order['product_name'], $content);
            $content = str_replace('{orderno}', $order['order_no'], $content);
        }
        return sendSmsCdxx($order['order_mobile'], $content);
    }



}