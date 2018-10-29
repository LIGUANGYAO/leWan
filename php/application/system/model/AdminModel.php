<?php
namespace app\system\model;

use app\common\SysHelp;
use think\Db;
use think\Config;
use think\Session;
use think\Request;
use think\Loader;
use app\common\tools\Visitor;
use app\system\model\NodesModel;
/**
 * 管理员模型
 * Enter description here ...
 * @author Administrator
 *
 */
class AdminModel 
{
    
    /**
     * 管理员列表
     * Enter description here ...
     * @param unknown_type $map
     * @param unknown_type $pagenow
     * @param unknown_type $pagesize
     */
    public function getList($map=array(), $pagenow=1, $pagesize=10){
        //查询总记录
        $count = Db::name('sys_admin a')->where($map)->count();
        $pagecount = ceil($count/$pagesize);
        
        $list = Db::name('sys_admin a')
                ->field('a.id, a.jname, a.nickname, a.last_login_time, a.addtime, r.role_name')
                ->where($map)
                ->join('sys_roles r', 'r.id = a.role_id')
                ->page($pagenow, $pagesize)
                ->order('a.id desc')
                ->select();
                
        $page['recordcount'] = $count;
        $page['pagenow'] = $pagenow;
        $page['pagecount'] = $pagecount;
        $page['url'] = Request::instance()->url();
        $pagination['list'] = $list;
        $pagination['page'] = $page;
        
        return $pagination;
    }
    
    /**
     * 添加账号
     * Enter description here ...
     * @param $item
     */
    public function add($item){
        return Db::name('sys_admin')->insert($item);
    }
    
    /**
     * 记录管理员操作日志
     * Enter description here ...
     * @param $action
     */
    public function log($data){

        $request    = Request::instance();
        $controller = $request->controller();
        $action     = $request->action();

        $curmenu    = NodesModel::getAction(strtolower($controller), strtolower($action));

        if($curmenu["cat_name"]){
            $Title = Db::name("sys_nodes")
                ->field("title")
                ->where(array("type" => array("eq",1),"codes" => array("instr",$controller)))
                ->find();

            $curmenu = $curmenu['cat_name']."/".$Title['title'].'/'.$curmenu['title'];
        }else{
            $curmenu = "(登录/退出)操作";
        }

        $log['admin_id']       = Session::get('admin.id');
        $log['admin_name']     = Session::get('admin.jname');
        $log['admin_nickname'] = Session::get('admin.nickname');
        $log['module']         = $curmenu;
        $log['ipaddress']      = Session::get('admin.location');
        $log['addtime']        = SysHelp::getTimeString();
        $log['intro']          = $data;
        Db::name('sys_adminlogs')->insert($log);
    }
    
    
    /**
     * 搜索日志
     * Enter description here ...
     * @param $map
     * @param $pagenow
     * @param $pagesize
     */
    public function getLogsList($map=array(), $pagenow=1, $pagesize=10){
        //查询总记录
        $count = Db::name('sys_adminlogs')->where($map)->count();
        $pagecount = ceil($count/$pagesize);
        
        $list = Db::name('sys_adminlogs')
                ->where($map)
                ->page($pagenow, $pagesize)
                ->order('id desc')
                ->select();
                
        $page['recordcount'] = $count;
        $page['pagenow'] = $pagenow;
        $page['pagecount'] = $pagecount;
        $page['url'] = Request::instance()->url();
        $pagination['list'] = $list;
        $pagination['page'] = $page;
        
        return $pagination;
    }
    
}
