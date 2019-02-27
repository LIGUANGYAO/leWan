<?php
namespace app\api\controller;

use app\api\model\JpushModel;
use app\common\BaseController;
use think\Db;

/**
 * 极光推送
 * Enter description here ...
 *
 */
class JpushController extends BaseController
{

    public function sendMsg(){
        $type =  $this->post('type', 'sys');

        $data['title'] = $this->post('title', '测试');
        $data['alert'] =  $this->post('content', '乐玩联盟');;
        $data['type'] =  $this->post('type', 'sys');;
       if($type =='sys'){
           $res = JpushModel::sendMsg();
       }else{
           $res = JpushModel::sendMsgSpecial('18071adc0347fe55b56',$data);
       }
        $res['code']    = 200;
        $res['message'] = '获取成功';
        $res['data']    = $res;
        header('content-type:application/json;charset=utf8');
        echo json_encode($res, JSON_UNESCAPED_UNICODE);
        Db::rollback();
        exit;
//        JpushModel::sendMsg('test');
    }


}
