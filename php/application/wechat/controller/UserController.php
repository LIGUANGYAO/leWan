<?php
namespace app\wechat\controller;

use app\common\model\AccountModel;
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
 * 用户
 * Enter description here ...
 * @author Administrator
 *
 */
class UserController extends WechatBaseController
{
    
    /**
     * 个人中心
     * Enter description here ...
     */
    public function index(){
        //待支付订单
        $data = Db::name('member')->find(Session::get('user.id'));
        $data['waitepay'] = Db::name('order')->where(['user_id'=>Session::get('user.id'), 'status'=>0])->count();
        $data['addpoints'] = Db::name('account_points')->where(['user_id'=>Session::get('user.id'), 'record_amount'=>['gt', 0], 'record_addtime'=>['gt', strtotime(date('Y-m-d'))]])->sum('record_amount');
        $am = new AccountModel();
        $data['balance'] = $am->getAllBalance(Session::get('user.id'));
        $this->assign('data', $data);
        return $this->displaySingle('index:user');
    }
    
    /**
     * 个人资料
     * @return type
     */
    public function info(){
        if(Request::instance()->isPost()){
            $ss['truename'] = $this->post('xm', '', RegExpression::REQUIRED, '姓名');
            $ss['phone'] = $this->post('tel', '', RegExpression::REQUIRED, '电话');
            $ss['email'] = $this->post('email', '');
            $ss['sex'] = $this->post('sex', '');
            $user = Db::name('member')->where('id = '.Session::get('user.id'))->find();
            if($user['vipcode'] == ''){
                $ss['vipcode'] = $this->getvipcode();
            }

            Db::name('member')->where('id = '.Session::get('user.id'))->update($ss);
            $this->ajaxReturn('保存成功');
        }else{
            $user = Db::name('member')->where('id = '.Session::get('user.id'))->find();
            $this->assign('user', $user);
            return $this->displaySingle('index/userinfo');
        }
    }


    public function vip(){
        $data = Db::name('member')->find(Session::get('user.id'));
        if($data['vipcode'] == ''){
            $url = urlwx('wechat/user/info');
            echo "<script>alert('请先完善个人资料！');window.location.href='$url';</script>";
        }else{
            $data['vipcode'] = substr($data['vipcode'],0,4).'&nbsp; &nbsp;'.substr($data['vipcode'],4,4).'&nbsp; &nbsp;'.substr($data['vipcode'],8,4).'&nbsp; &nbsp;'.substr($data['vipcode'],12,4);
            $this->assign('user', $data);
            return $this->displaySingle('index/vip');
        }

    }


    private function getvipcode(){
        $str = date('mdHis');
        $uid = '60'.Session::get('user.id');
        if(Session::get('user.id') > 1000){
            $uid = Session::get('user.id');
        }
        for($i=0; $i<6-strlen($uid); $i++){
            $str.='0';
        }
        return $str.$uid;
    }
}
