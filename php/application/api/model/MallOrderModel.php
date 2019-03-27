<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/6
 * Time: 11:44
 */

namespace app\api\model;
use app\common\Md5Help;
use app\common\SysHelp;
use think\Db;

/**
 * 商城订单相关的模型
 * Class MallOrderModel
 * @package app\api\model
 */
class MallOrderModel
{


    /**
     * 创建订单-普通购买price_type=1
     * @param $order_no
     * @param $product
     * @param $attach
     * @param $user
     * @return int|string
     */
    public function buildOrder1($order_no, $product, $attach, $user){
        $vo['merchant_id'] = $product['merchant_id'];
        $vo['fen_merchant_id'] = $product['merchant_id'];
        $vo['user_id'] = $user['user_id'];
        $vo['order_no'] = $order_no;
        $vo['order_idcard'] = $attach["order_idcard"];
        $vo['order_plainday'] = $attach["order_plainday"];
        $vo['order_fullname'] = $attach['concat'];
        $vo['order_mobile'] = $attach['mobile'];
        $vo['order_leave'] = $attach['remark'];
        $vo['address_id'] = $attach['address_id'];
        //总金额
        $vo['order_totalfee'] = $product['price_sale'] * $attach['buynum'];
        $vo['order_payfee'] = $product['price_sale'] * $attach['buynum'];
        if($product['coupon']){
            $vo['order_payfee'] = $vo['order_payfee'] - $product['coupon']['coupon_money']; //减去优惠券面额
        }
        $vo['order_isexpress'] = $product['product_isexpress'];
        $vo['order_reservation'] = $product['product_reservation'];
        $vo['order_addtime'] = time();
        $vo['order_uptime'] = time();
        //新人免单
        if($product['product_returnall'] == 1){
            $hasOrder = Db::name('order o')
                ->join('jay_order_product op', 'op.order_id = o.order_id', 'left')
                ->where(['o.user_id'=>$user['user_id'], 'op.product_returnall'=>1, 'o.order_status'=>['gt', 1], 'op.product_id'=>$product['product_id']])
                ->find();
            if($hasOrder){
                $product['product_returnall'] = 0;//已经买过新人免单产品
            }
        }
        $productRs = true;
        if(($product['product_sku']-$attach['buynum'])<1){ //售罄
            $productData['sold_out'] = 1;
            $productData['sold_out_time'] = time();
            $map['product_id'] = $product['product_id'];
            $productRs = Db::name('product')->where($map)->update($productData);
        }
        $orderId = Db::name('order')->insertGetId($vo);
        //创建附件信息
        $affiliatId = $this->buildOffiliate($orderId, $vo['order_payfee'], $product['coupon']);
        //关联商品数据
        $opId = $this->buildOProduct1($orderId, $product, $attach);
        //更新库存
        $res = $this->upKucun($product, $attach);
        if($orderId > 0 && $affiliatId > 0 && $opId > 0 && $res !== false && $productRs !== false){
            return true;
        }else{
            return false;
        }
    }

    /**
     * 更新库存
     */
    private function upKucun($product, $attach){
        $up['product_sales_volume'] = ['exp','product_sales_volume+'.$attach['buynum']];

        //是否售罄
//        if($product['product_buynum']*1+$attach['buynum']*1 >= $product['product_totalnum']){
//            $up['sold_out'] =1;
//            $up['sold_out_time'] =time();
//        }

        $res7 = Db::name('product')->where(['product_id'=>$product['product_id']])->update($up);
        $res8 = Db::name('product_price')->where(['price_id'=>$product['price_id']])->update(['product_buynum'=>['exp','product_buynum+'.$attach['buynum']], 'product_dynamicnum'=>['exp','product_dynamicnum+'.$attach['buynum']]]);
        return $res8;
    }


    private function buildOffiliate($order_id, $order_payfee, $coupon){
        $vo['order_id'] = $order_id;
        if($coupon){
            $vo['coupon'] = $coupon['coupon_money'];
            $vo['coupon_id'] = $coupon['user_coupon_id'];
        }
        $vo['payamount'] = $order_payfee;
        return Db::name('order_affiliated')->insertGetId($vo);
    }

    private function buildOProduct1($order_id, $product, $attach){
        $vo['order_id'] = $order_id;
        $vo['product_id'] = $product['product_id'];
        $vo['price_id'] = $product['price_id'];
        $vo['price_type'] = $product['price_type'];
        $vo['product_name'] = $product['product_name'];
        $vo['product_property'] = $product['product_property'];
        $vo['num'] = $attach['buynum'];
        $vo['price'] = $product['price_sale'];
        $vo['settle'] = $product['price_settle'];
        $vo['totalmoney'] = $product['price_sale']*$attach['buynum'];
        $vo['totalsettle'] = $product['price_settle']*$attach['buynum'];
        $vo['product_startusetime'] = $product['product_startusetime'];
        $vo['product_endusetime'] = $product['product_endusetime'];
        $vo['product_returnall'] = $product['product_returnall'];
        $vo['commis_free'] = ($product['product_returnall']==1)?$vo['totalmoney']:0;
        $vo['commission'] = $product['price_commission']*$attach['buynum'];
        $opId = Db::name('order_product')->insertGetId($vo);
        return $opId;
    }

    /***
     * 生成电子码
     * @param $order_id
     * @param $buynum
     * @param $user_id
     * @param $op_id
     * @return int|string
     */
    public function buildConsumeCode($order_id, $buynum, $user_id, $op_id){
        $code = '';
        for($i = 0; $i < $buynum; $i++){
            $vo['order_id'] = $order_id;
            $vo['user_id'] = $user_id;
            $vo['op_id'] = $op_id;
            $vo['hash'] = Md5Help::getDllKey();
            $vo['consume_code'] = HelpModel::makeConsumeCode($order_id);
            $vo['addtime'] = time();
            $vo['uptime'] = time();
            $code .= $vo['consume_code'].',';
            $res = Db::name('order_consume_code')->insertGetId($vo);
        }
        $code = trim($code, ',');
        return $code;
    }
}