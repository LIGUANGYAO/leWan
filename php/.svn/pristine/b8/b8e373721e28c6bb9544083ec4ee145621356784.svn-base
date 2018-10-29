<?php
namespace app\system\controller;

use app\common\AdminBaseController;
use app\common\model\AccountModel;
use app\common\model\AccountRecordModel;
use app\common\model\Currency;
use think\Request;
use think\Db;
use think\Log;
use think\Cache;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;
use think\Template;
use app\system\model\NodesModel;

/**
 * 系统入口
 * Enter description here ...
 * @author Administrator
 *
 */
class IndexController extends AdminBaseController
{
    
    /**
     * 系统首页
     * Enter description here ...
     */
    public function index(){
        return $this->display('index', true);
    }
    
    
    /**
     * 管理员登录
     * Enter description here ...
     */
    public function login(){
        if(Request::instance()->isAjax()){
            $username = $this->post('loginid', '', RegExpression::MIN5, '登录账号');
            $password = $this->post('pwdid', '', RegExpression::MIN5, '密码');
            $code = $this->post('code', '', RegExpression::CAPTCHA, '验证码');
            
            //查询账号
            $user = Db::name('sys_admin')->where('jname=:name')->bind(['name'=>$username])->find();
            if($user){
                if(Md5Help::getMd5Pwd($password, $user['dllkey']) != $user['jpass']){
                    $this->ajaxReturn('密码错误', 0);
                }else{
                	unset($user['jpass']);
                	unset($user['dllkey']);

                    $ipurl    = 'http://ip.taobao.com/service/getIpInfo.php?ip='.Request::ip();
                    $ipdata   = curlPost($ipurl);
                    $ipdata   = json_decode($ipdata,true);
                    $location = $ipdata["data"];
                    $country  = !$location["country"]?"XX":$location["country"];
                    $region   = !$location["region"]?"XX":$location["region"];
                    $city     = !$location["city"]?"XX":$location["city"];
                    $county   = !$location["county"]?"XX":$location["county"];
                    $isp      = !$location["isp"]?"XX":$location["isp"];
                    $location = $country."/".$region."/".$city."/".$county."/".$isp."/";
                    $location = Request::ip()." 所在地/".$location;

                    $user["location"] = $location;

                    Session::set('admin', $user);
                    Db::name('sys_admin')->where('id', $user['id'])->update(['last_login_time'=>SysHelp::getTimeString()]);

                    $this->log("管理员登录");
                    
                    //登录系统首页面
                    $nm = new NodesModel();
                    $groups = $nm->getGroup();
                    $node = $nm->secondMenu(intval($groups[0]['id']));
                    $url = empty($node)?url('index/index'):$node[0]['url'];
                    $this->ajaxReturn('登录成功', 1, $url);
                }
            }else{
                $this->ajaxReturn('账号不存在', 0);
            }
            
        }else{
            return $this->displaySingle('index/login');
        }
    }
    
    
    /**
     * 退出登录
     * Enter description here ...
     */
    public function logout(){
        $this->log("管理员退出");
        Session::delete('admin');
        $this->redirect('system/index/index');
    }
    
    /**
     * 清除缓存
     * Enter description here ...
     */
    public function clearCache(){
        Cache::clear();
        Log::clear();
       // rrmdir(RUNTIME_PATH.'log');
        //rrmdir(RUNTIME_PATH.'temp');
        //生成常量
        $config = Db::name('sys_config')->where("`type`='text'")->order('sort asc')->column('value','field');
        $wechatConstContent = file_get_contents(CONF_PATH.'extra/const.tpl');
        $wechatConstContent = str_replace('{domain}', $config['domain'], $wechatConstContent);
        $wechatConstContent = str_replace('{WX_APPID}', $config['wx_appid'], $wechatConstContent);
        $wechatConstContent = str_replace('{WX_APPSECRET}', $config['wx_appsecret'], $wechatConstContent);
        $wechatConstContent = str_replace('{WX_MCHID}', $config['mchid'], $wechatConstContent);
        $wechatConstContent = str_replace('{WX_KEY}', $config['wx_key'], $wechatConstContent);
        $wechatConstContent = str_replace('{WX_HTTPADDR}', $config['wx_http'], $wechatConstContent);
        $wechatConstContent = str_replace('{WX_VIEWURL}', $config['wx_viewurl'], $wechatConstContent);
        $wechatConstContent = str_replace('{WX_TOKEN}', $config['wx_token'], $wechatConstContent);
        $res = file_put_contents(CONF_PATH.'extra/const.php', $wechatConstContent);
        if($res === false){
            $this->ajaxReturn('清除失败', 0);
        }
        $this->ajaxReturn('清除成功', 1);
    }
    
    
}
