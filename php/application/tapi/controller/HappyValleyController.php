<?php

namespace app\tapi\controller;

use app\common\BaseController;
use app\common\model\ProcedureModel;
use app\tapi\model\OrderModel;
use think\Db;

/**
 *  类描述: [欢乐谷对接]
 *  创建人: [yih]
 *  修改备注: [说明本次修改内容]
 */
class HappyvalleyController extends BaseController {
    
    /**
     * 123门票核销通知处理乐玩订单状态
     */
    public function finishOrder(){
        $data = $this->post('data');
        $event_type = $this->post('event_type');
        $signature = $this->post('signature');

        GLog('123门票网核销订单通知event_type'.$event_type.'   sign'.$signature,$data);
        $data = json_decode($this->post('data'),JSON_UNESCAPED_UNICODE);
        if($event_type==1){ //核销
            $client_id =$data['client_id'];
            $order_number =$data['order_number'];
            $name =$data['name'];
            $tel =$data['tel'];
            if(!$client_id){
                $this->returnApiData('client ID 不能为空', 1000002);
            }
            if(OrderModel::client_id != $client_id){
                $this->returnApiData('client ID 错误'.$client_id , 1000002);
            }
            $str = OrderModel::client_secret.'data'.json_encode($data,JSON_UNESCAPED_UNICODE).'event_type'.$event_type.OrderModel::client_secret;
            GLog('123门票网核销订单字符串',$str);
            $sign = md5($str);
            if($sign==$signature){
                $where['order_fullname'] = $name;
                $where['order_mobile'] = $tel;
                $where['dboss_main_orderno'] = $order_number;
                $order = Db::name('order')->field('order_status,order_id')->where($where)->find();
                if(empty($order)){
                    $this->returnApiData('未找到订单信息'.$sign, 1000002);
                }
                if($order['order_status'] ==2 ||$order['order_status']==3){
                    $res = Db::table('jay_order')->where(['order_id'=>$order['order_id']])->update(['order_status'=>4,'order_uptime'=>time()]);
                    Db::table('jay_order_consume_code')->where(['order_id'=>$order['order_id']])->update(['status'=>2,'uptime'=>time()]);
                    if( $res !== false ){
                        GLog('123门票网核销订单','orderid='.$order['order_id'].'成功');
                        $this->returnApiData('核销成功',1000001);
                    }else{
                        GLog('123门票网核销订单','orderid='.$order['order_id'].'成功失败');
                        $this->returnApiData('核销失败',1000002);
                    }
                }else{
                    if($order['order_status'] ==4){
                        $this->returnApiData('该订单已完成', 1000001);
                    }else if($order['order_status'] ==2){
                        $this->returnApiData('订单未支付', 1000002);
                    }else{
                        $this->returnApiData('订单状态异常', 1000002);
                    }
                }
            }else{
                GLog('123门票网核销订单签名错误',$sign.'签名错误！'.$signature);
                $this->returnApiData('签名错误！',1000002);
            }
        }else{
            $this->refund($data);

            #$this->returnApiData('暂不支持其他操作！',1000002);
        }
    }

    /**
     * 123门票核销通知处理乐玩订单状态
     */
    public function refund(){
        $data = $this->post('data');
        $event_type = $this->post('event_type');
        $signature = $this->post('signature');

    }


    /**
     * 接口返回数据
     * @param $msg
     * @param int $status
     * @param array $data
     */
    protected function returnApiData($msg, $status=200, $data=[]){
        $res['code']    = $status;
        $res['message'] = $msg;
        $res['data']    = $data;
        header('content-type:application/json;charset=utf8');
        echo json_encode($res, JSON_UNESCAPED_UNICODE);
        Db::rollback();
        exit;
    }

}