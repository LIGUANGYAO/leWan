<?php
namespace app\wechat\controller;

use app\common\model\Paymodel;
use app\wechat\model\RoomModel;
use think\Request;
use think\Db;
use think\Log;
use think\Cache;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;
use think\Template;
use app\common\WechatBaseController;

/**
 * 微信入口
 * Enter description here ...
 * @author Administrator
 *
 */
class IndexController extends WechatBaseController
{
    
    /**
     * 微信首页
     * Enter description here ...
     */
    public function index(){
        return $this->displaySingle();
    }


    public function liebiao(){
        $ss['startDate'] = $this->get('startDate');
        $ss['endDate'] = $this->get('endDate');
        $ss['NumDate'] = $this->get('NumDate', 1);
        $ss['stweek'] = $this->get('stweek');
        $ss['enweek'] = $this->get('enweek');
        $ss['rooomnum'] = $this->get('rooomnum', 1);
        session('plan', $ss);

        //查询房型
        $room = Db::name('room')->where(['status'=>1])->field('id, title, pic, feature, price')->order('sort asc')->select();
        $this->assign('room', $room);
        return $this->displaySingle();
    }

    public function xiangqing(){
        $roomid = $this->get('roomid', 0);
        $room = Db::name('room')->where(['status'=>1])->find($roomid);
        for($i = 1; $i <= 6; $i++){
            if($room['photo'.$i] != ''){
                $room['images'][] = $room['photo'.$i];
            }
        }
        $this->assign('room', $room);
        if($room['type'] == 1){
            $this->assign('icons', RoomModel::$RoomType1);
        }else{
            $this->assign('icons', RoomModel::$RoomType2);
        }
        return $this->displaySingle();
    }

    public function dingdanqueren(){
        $roomid = $this->get('roomid', 0);
        $room = Db::name('room')->where(['status'=>1])->find($roomid);
        $room['services'] = Db::name('roomservice')->where(['id'=>['in', $room['serviceIds']]])->select();
        $this->assign('room', $room);

        $user = Db::name('member')->find(Session::get('user.id'));
        $this->assign('user', $user);
        return $this->displaySingle();
    }


    public function lxwm(){
        return $this->displaySingle('index:lxwm');
    }

    public function map(){
        return $this->displaySingle('index:map');
    }

//    public function test(){
//        $smsdata['orderno'] = '1212';
//        $smsdata['ruzhu'] = '1111';
//        $smsdata['likai'] = '3333';
//        $smsdata['price'] = '2.12';
//        $smsdata['num'] = 2;
//        $smsdata['name'] = '人家';
//        $smsdata['room'] = '解决';
//        $res = sendSms('15828218481', config('aliyun_sms.templatecode_yudingok'), $smsdata);
//        fuck($res);
//    }


}
