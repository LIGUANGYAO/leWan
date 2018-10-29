<?php
namespace app\common;

use think\Controller;
use think\Request;
use app\common\RegExpression;
use think\Db;

/**
 * PC端基类
 * Enter description here ...
 * @author Administrator
 *
 */
class WwwBaseController extends BaseController
{
    
    /**
     * 入口控制
     * Enter description here ...
     */
    public function __construct(){
        parent::__construct();
        $this->_listenLangurage();
        if(\think\Session::get('lang') == 'en-us'){
            $field = 'id, en_cat_name as cat_name';
        }else{
            $field = 'id, cat_name';
        }
        $cates = Db::name('categories')->where('`status` = 1 and parent_id > 0')->order('sort asc')->field($field.', parent_id')->select();
        $this->assign('cates', $cates);
    }
    
    /**
     * 监听语言，切换语言
     */
    private function _listenLangurage(){
        $langurage = $this->get('l', '');
        if($langurage == 'zh-cn'){
            \think\Session::set('lang', 'zh-cn');
        }elseif($langurage == 'en-us'){
            \think\Session::set('lang', 'en-us');
        }
        
        //首次访问
        if(!\think\Session::has('lang')){
            \think\Session::set('lang', 'zh-cn');
        }
        
        //设置切换语言链接地址
        $params = Request::instance()->param();
        if(\think\Session::get('lang') == 'en-us'){
            \think\Lang::load(APP_PATH. '/home/lang/en-us.php');
            $params['l'] = 'zh-cn';
            $switchlangurl = url(Request::instance()->module().'/'.Request::instance()->controller().'/'.Request::instance()->action(), $params);
            $this->assign('switchlangurage', $switchlangurl);
            $this->assign('langurage', 'cn');
        }else{
            \think\Lang::load(APP_PATH. '/home/lang/zh-cn.php');
            $params['l'] = 'en-us';
            $switchlangurl = url(Request::instance()->module().'/'.Request::instance()->controller().'/'.Request::instance()->action(), $params);
            $this->assign('switchlangurage', $switchlangurl);
            $this->assign('langurage', 'en');
        }
    }
    
}
