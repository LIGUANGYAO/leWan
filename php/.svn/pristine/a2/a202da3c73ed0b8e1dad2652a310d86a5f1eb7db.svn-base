<?php

namespace app\common;

use think\Controller;
use think\Request;
use think\Session;
use think\Config;
use think\Db;
use app\common\BaseController;
use app\common\RegExpression;
use app\system\model\AdminModel;
use app\system\model\NodesModel;

/**
 * 微信端基类
 * Enter description here ...
 * @author Administrator
 *
 */
class WechatBaseController extends BaseController {

    /**
     * 入口控制
     * Enter description here ...
     */
    public function __construct() {
        parent::__construct();
        //$this->test();
        //微信授权
        //$this->userAuthorization();
        //$this->loadconfig();
        //$this->share();
    }

    private function test(){
        $clickuser = Db::name('member')->find(1);
        session('user', $clickuser);
    }

    /**
     * 加载配置
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     */
    private function loadconfig(){
        $configdata = [];
        $config = Db::name('sys_config')->where('tab=1')->order('sort asc')->select();
        foreach ($config as $k=>$v){
            $v['value'] = str_replace('\\', '/', $v['value']);
            $configdata[$v['field']] = $v;
        }
        $this->assign('cc', $configdata);
    }

    /**
     * 用户网页授权
     */
    public function userAuthorization() {
        /* 以下是点击素材授权 */
        $openid = $this->get('openid', '');
        $clickuser = Db::name('member')->where(array('openid'=>$openid))->find();
        if($clickuser){
            session('user', $clickuser);
        }
        if (Session::has('user') && Session::get('user.id') > 0) {
            return;
        }
        /* 以下是网页授权 */
        if (isset($_GET['code'])) {
            //同意授权/用户点击有有授权的页面进来.。   没有 关注公众号的人，点击链接 也能获取openid
            $url = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid=' . WX_APPID . '&secret=' . WX_APPSECRET . '&code=' . $_GET['code'] . '&grant_type=authorization_code';
            $res = wx_get($url);
            if (isset($res['openid']) && $res['openid'] != '') {
                $user = Db::name('member')->where(array('openid' => $res['openid']))->find();
                if ($user && $user['id'] > 0) {
                    session('user', $user);
                } else {
                    //新用户，自动注册
                    //拉取用户信息
                    $access_token = $res['access_token'];
                    $openid = $res['openid'];
                    $url = "https://api.weixin.qq.com/sns/userinfo?access_token=$access_token&openid=$openid&lang=zh_CN";
                    $uinfo = wx_get($url);
                    $newuser['head'] = $uinfo['headimgurl'];
                    $newuser['nickname'] = $uinfo['nickname'];
                    $newuser['openid'] = $res['openid'];
                    $newuser['addtime'] = SysHelp::getTimeString();
                    $newuser['token'] = Md5Help::getToken($access_token);
                    $userid = Db::name('member')->insertGetId($newuser);
                    session('user', Db::name('member')->find($userid));
                }
            } else {
                //授权失败
                echo 'authorization fail';
            }
        } else {
            echo 'Please open it with WeChat';
        }
    }
    

    protected function getshareUrl(){
        $user = Db::name('member')->find(Session::get('user.id'));
        $params['utoken'] = @$user['token'];
        foreach (Request::instance()->param() as $k => $v) {
            if (!is_array($v)) {
                $params[$k] = $v;
            }
        }
        unset($params['code']);
        unset($params['state']);
        $request = Request::instance();
        $url = url($request->module().'/'.$request->controller().'/'.$request->action(), $params, true, true);
        return get_wx_snslink($url);
    }

    protected function share(){
        $url = $this->getshareUrl();
        $sharedata = array(
            'title' => '成都明宇丽雅悦酒店',
            'desc'  => '成都明宇丽雅悦酒店',
            'link'  => $url,
            'imgUrl'=> WX_HTTPADDR.'/www/images/logo.png'
        );
        $this->assign('sharedata', $sharedata);

        //调用jssdk
        Vendor('WxPay.jssdk');
        $jssdk = new \JSSDK(WX_APPID, WX_APPSECRET);
        $signPackage = $jssdk->getSignPackage();
        $this->assign('signPackage',  $signPackage);
    }
   

}
