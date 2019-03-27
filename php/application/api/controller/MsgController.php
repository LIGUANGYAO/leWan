<?php
namespace app\api\controller;

use app\api\model\JpushModel;
use app\api\model\OpenTmModel;
use app\common\BaseController;
use think\Db;

/**
 * 消息类
 * Enter description here ...
 * @author yihong
 *
 */
class MsgController extends BaseController
{

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

    /**
     * 推送新产品给用户w
     * @return bool
     */
    public function sendMsgToWechat(){
        $map1['results'] = 1;
        $map1['correlation_id'] = array('gt',0);
        $product = Db::name('timer_action')->field('id,progress,correlation_id,type,touser')->where($map1)->find();
        if(!empty($product)){
            if($product['type'] ==2) { //短信推送
                $this->sendMsgToSMS($product);
            }else{
                $product_id = $product['correlation_id'];
                $progress = $product['progress'];
                if($product_id){
                    $productName = Db::name('product')->where(['product_id'=>$product_id])->value('product_name');
                    if(!$productName){
                        GLog('Share Proudct To Wecaht','分享产品不存在');
                        $this->returnApiData('empty',400);
                    }
                    if($product['touser'] ==3){ //微信推送
                        $data['title'] = '最新爆品推荐';
                        $data['product_name'] = $productName;
                        $data['sku'] = Db::name('product_price')->where(['product_id'=>$product_id])->sum('product_totalnum');
                        $data['remark'] = '点击查看详情';
                        $host =  $_SERVER['HTTP_HOST']?$_SERVER['HTTP_HOST']: $_SERVER['SERVER_NAME'];
                        $url = $host. '/wechat_html/page/homePage/productDetails.html?productId='.$product_id;
                        $accessToken =  Db::name('access_token')->value('access_token');
    //                  OpenTmModel::sendTplmsg6('oRSVB5uyiww45nudzxB1ZBF9qGZM',$data,$accessToken,$url);
                        //获取所有微信用户openid
                        $map['c.platform'] = 'wechat';
                        $map['c.subscribe'] = 1;
                        $map['u.level'] = array('gt',2);
                        $openidList = Db::name("user_connect c")
                            ->field('c.openid')
                            ->join('jay_user u', 'u.user_id = c.user_id', 'left')
                            ->where($map)
                            ->page($product['progress'],50)
                            ->select();
                        if(count($openidList)){
                            foreach ($openidList as $val){
                                if(isset($val['openid']) && $val['openid']){
                                    //发送消息给每个微信用户
                                    OpenTmModel::sendTplmsg6($val['openid'],$data,$accessToken,$url);
                                }
                            }
                            if($progress==1){
                                $update['starttime'] = time();
                            }
                            $progress++;
                            $update['progress'] = $progress;
                            Db::name('timer_action')->where(array('id'=>$product['id']))->update($update);
                        }else{ //循环完毕
                            GLog('Share Proudct To Wecaht','推送完毕，最后SQL为：'.Db::name("user_connect")->getLastSql());
                            Db::name('timer_action')->where(array('id'=>$product['id']))->update(array('results'=>2));
                        }
                        $this->returnApiData('ok',200);
                    }else{ //极光推送
                        $data['title'] = '最新爆品推荐';
                        $data['alert'] = $productName;
                        $option['type'] =  JpushModel::JPUSH_MSG_NEW_PRODUCT;
                        if($product['touser']==1){
                            $data['platform'] =  'android';
                        }elseif($product['touser']==2){
                            $data['platform'] =  'ios';
                        }else{
                            $data['platform'] =  'all';
                        }
                        $option['product_id'] =  $product_id;
                        JpushModel::sendMsg($data,$option);
                        Db::name('timer_action')->where(array('id'=>$product['id']))->update(array('results'=>2));
                    }
                }
            }
        }
        $this->returnApiData('empty',400);
    }

    public function sendMsgToSMS($product){

        $progress = $product['progress'];
        $product_id = $product['correlation_id'];
        if($product_id){
            $productName = Db::name('product')->where(['product_id'=>$product_id])->value('product_name');
            if(!$productName){
                GLog('Share Proudct To Wecaht','分享产品不存在');
                $this->returnApiData('empty',400);
            }
            //获取达人、玩主
            $where['level']=array('in','3,4,5');
            $userList = Db::name("user")->where($where)->field('nickname,username,mobile')->page($product['progress'],50)->select();
            if(count($userList)){
                foreach ($userList as $val){
                    if(isset($val['mobile']) && $val['mobile']){
                        $username = $val['username']? $val['username']: $val['nickname'];
                        $content = config('cdxx_sms.content_push_product');
                        if($content){
                            $content = str_replace('{name}', $username, $content);
                            $content = str_replace('{product}', $productName, $content);
                            if(sendSmsCdxx($val['mobile'], $content)){
                                echo 'ok';
                            }else{
                                echo 'err';
                            }
                        }else{
                            GLog('Share Proudct To SMS','短信模板不存在');
                            $this->returnApiData('短信模板不存在',400);
                        }
                    }
                }

                if($progress==1){
                    $update['starttime'] = time();
                }
                $progress++;
                $update['progress'] = $progress;
                Db::name('timer_action')->where(array('id'=>$product['id']))->update($update);
            }else{ //循环完毕
                GLog('Share Proudct To Wecaht','推送完毕，最后SQL为：'.Db::name("user_connect")->getLastSql());
                Db::name('timer_action')->where(array('id'=>$product['id']))->update(array('results'=>2));
            }
            $this->returnApiData('ok',200);
        }
    }

}
