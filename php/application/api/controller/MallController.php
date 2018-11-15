<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/6
 * Time: 10:22
 */

namespace app\api\controller;
use app\api\model\HelpModel;
use app\api\model\MallOrderModel;
use app\common\model\Paymodel;
use think\Db;

/**
 * 商城流程
 * Class MallController
 * @package app\api\controller
 */
class MallController extends ApiBaseController
{


    /**
     * 支付确认页面
     */
    public function confirmPay(){
        $product_id = $this->post('product_id', 0);
        $price_id = $this->post('price_id', 0);
        $calendar_id = $this->post('calendar_id', '');//支持散购
        $user = getUserByToken();
        //1.验证商品
        if($price_id > 0){
            $product = $this->verfiyProduct1($product_id, $price_id, $user);
        }else{
            $product = $this->verfiyProduct2($product_id, $calendar_id, $user);
        }

        $this->returnApiData('获取成功', 200, ['product'=>$product]);
    }


    /**
     * 提交订单
     */
    public function submitOrder(){
        $product_id = $this->post('product_id', 0);
        $price_id = $this->post('price_id', 0);
        $calendar_id = $this->post('calendar_id', '');//支持散购
        $attach['address_id'] = $this->post('address_id', 0);
        $attach['buynum'] = $this->post('buynum', 1);
        $attach['concat'] = $this->post('concat', '');
        $attach['mobile'] = $this->post('mobile', '');
        $attach['remark'] = $this->post('remark', '');
        $user = getUserByToken();
        //1.填写信息
        self::Tpl_Chinese($attach['concat'], '联系人姓名格式不正确', 2);
        self::Tpl_Phone($attach['mobile'], '手机号格式不正确', 2);

        //2.验证商品
        if($price_id > 0){
            //平日价
            $product = $this->verfiyProduct1($product_id, $price_id, $user);
            if($product['product_isexpress'] == 2){
                $addr = Db::name('user_address')->where(['user_id'=>$user['user_id'], 'address_id'=>$attach['address_id']])->find();
                if(!$addr){
                    $this->returnApiData('请选择收货地址', 400);
                }
            }
            $order_no = HelpModel::makeOrderNumber();
            Db::startTrans();
            //锁表
            Db::name('product_price')->lock(true)->find($product['price_id']);
            $mo = new MallOrderModel();
            $res = $mo->buildOrder1($order_no, $product, $attach, $user);
            if($res){
                Db::commit();
                $this->returnApiData('下单成功，请立即支付!', 200, ['order_no'=>$order_no]);
            }else{
                Db::rollback();
                $this->returnApiData('订单提交失败', 400);
            }
        }else{
            //选日期散购
            $product = $this->verfiyProduct2($product_id, $calendar_id, $user);
        }

    }

    /**
     * 立即支付订单
     */
    public function paynow(){
        $order_no = $this->post('order_no', '');
        $payway = $this->post('payway', 1); //1微信公众号支付 2支付宝app；3银行卡；4微信APP
        $user = getUserByToken();
        $where['o.user_id'] = $user['user_id'];
        $where['o.order_no'] = $order_no;
        $where['o.order_status'] = 1;
        $order = Db::name('order o')
            ->field('o.*, p.product_returnall')
            ->join('jay_order_product p', 'p.order_id = o.order_id', 'left')
            ->where($where)->find();
        if($order){
            //是否过期
            if($order['order_addtime'] < time()-1800){
                $this->returnApiData('订单已经过期，请重新下单', 400);
            }
            if($order['product_returnall'] == 1){
                //已买过新人免单，不能再购买
                $hasOrder = Db::name('order o')
                    ->join('jay_order_product op', 'op.order_id = o.order_id', 'left')
                    ->where(['o.user_id'=>$user['user_id'], 'op.product_returnall'=>1, 'o.order_status'=>['gt', 1]])
                    ->find();
                if($hasOrder){
                    $this->returnApiData('您的一次新人免单机会已经使用完了噢', 400);
                }
            }
            if($payway == 1){
                $openId = Db::name('user_connect')->where(['user_id'=>$user['user_id'], 'platform'=>'wechat'])->value('openid');
                if(!$openId){
                    $this->returnApiData('账号未授权登录服务号', 400);
                }
                $pm = new Paymodel();
                $res = $pm->wxJsPay($openId, $order_no, $order['order_payfee'], 'Notify/mall');
                $this->returnApiData('获取成功', 200, ['jsApiParameters'=>$res]);
            }elseif($payway == 2){
                $this->returnApiData('支付宝支付尚未开通', 400);
            }elseif($payway == 3){
                $this->returnApiData('银行卡支付尚未开通', 400);
            }elseif($payway == 4){
                $this->returnApiData('微信app支付尚未开通', 400);
            }
        }else{
            $this->returnApiData('订单不存在', 400);
        }
    }


    private function verfiyProduct1($product_id, $price_id, $user){
        $product = Db::name('product p')
            ->field('c.*, p.product_name, p.product_status, p.product_del, p.product_reviewstatus,p.price_type, p.product_returnall, p.product_reservation, p.product_isexpress, p.product_timelimit, p.product_numlimit, p.product_starttime, p.product_endtime, p.product_startusetime, p.product_endusetime, p.merchant_id')
            ->join('product_price c', 'c.product_id = p.product_id', 'left')
            ->join('merchant m', 'm.merchant_id = p.merchant_id', 'left')
            ->where(['p.product_id'=>$product_id, 'c.price_id'=>$price_id, 'm.merchant_status'=>2, 'c.price_status'=>1])
            ->find();
        if(!$product){
            $this->returnApiData('商品不存在', 400);
        }
        if($product['product_del'] == 1 || $product['product_status'] == 0){
            $this->returnApiData('商品售罄已下架', 400);
        }
        if($product['product_reviewstatus'] != 2){
            $this->returnApiData('商品未审核通过', 400);
        }
        if($product['product_buynum'] >= $product['product_totalnum']){
            $this->returnApiData('商品已售罄', 400);
        }
        if($product['price_type'] == 2){
            $this->returnApiData('商品价格类型异常', 400);
        }
        if($product['product_returnall'] == 1){
            //已买过新人免单，不能再购买
            $hasOrder = Db::name('order o')
                ->join('jay_order_product op', 'op.order_id = o.order_id', 'left')
                ->where(['o.user_id'=>$user['user_id'], 'op.product_returnall'=>1, 'o.order_status'=>['gt', 1]])
                ->find();
            if($hasOrder){
                $this->returnApiData('您的一次新人免单机会已经使用完了噢', 400);
            }
        }
        $product['coupon'] = $this->verifyCoupon($user, $product_id);
        return $product;
    }

    private function verifyCoupon($user, $product_id){
        $where['pc.product_id'] = $product_id;
        $where['uc.user_id'] = $user['user_id'];
        $where['uc.endtime'] = ['gt', time()];
        $where['uc.status'] = 1;
        $coupon = Db::name('user_coupon uc')->field('uc.*, pc.coupon_money')
                    ->join('jay_product_coupon pc', 'pc.coupon_id = uc.coupon_id', 'left')
                    ->where($where)
                    ->find();
        return $coupon?$coupon:[];
    }

}