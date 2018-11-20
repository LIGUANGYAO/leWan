<?php
namespace app\api\controller;

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
     * 推送新产品给用户
     * @return bool
     */
    public function sendMsgToWechat(){
        $product_id =  input('id', 0);
        $host =  $_SERVER['HTTP_HOST']?$_SERVER['HTTP_HOST']: $_SERVER['SERVER_NAME'];
        if($product_id){
            $productName = Db::name('product')->where(['product_id'=>$product_id])->value('product_name');
            if($productName){
                $data['title'] = '最新爆品推荐';
                $data['keyword1'] = '爆品推荐';
                $data['keyword2'] = $productName;
                $data['keyword3'] = date('Y-m-d H:i:s');
                $data['keyword4'] = '爆品推荐';
                $data['remark'] = '点击查看详情';
            }else{
                return false;
            }

            $url = $host. '/wechat_html/page/homePage/productDetails.html?productId='.$product_id;
            $accessToken = Db::name('access_token')->value('access_token');
            //OpenTmModel::sendTplmsg6('oRSVB5uyiww45nudzxB1ZBF9qGZM',$data,$accessToken,$url);
            //获取所有微信用户openid
            $openidList = Db::name("user_connect")->where(array('platform'=>'wechat'))->field('openid')->select();
            foreach ($openidList as $val){
                if(isset($val['openid']) && $val['openid']){
                    //发送消息给每个微信用户
                    OpenTmModel::sendTplmsg6($val['openid'],$data,$accessToken,$url);
                }
            }
            return true;
        }
        return false;
    }

}
