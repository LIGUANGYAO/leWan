<?php
namespace app\system\controller;

use app\common\AdminBaseController;
use think\Request;
use think\Db;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;
use app\system\model\NodesModel;
use think\Exception;

/**
 * 后台角色模块
 * Enter description here ...
 * @author Administrator
 *
 */
class RolesController extends AdminBaseController
{
    
    /**
     * 角色列表
     * Enter description here ...
     */
    public function index(){
        //设置添加信息按钮
        $this->assign('addbtn',  $this->returnAddbtn('添加角色', 'system/roles/add', 1, '500px', '400px'));
        
        //获取分页列表数据
        $data = Db::name('sys_roles')->order('id asc')->select();
        //fuck($data, Request::instance());
        
        $this->assign('data',  $data);
        return $this->display('index', true);
    }
    
    
    /**
     * 添加操作
     * Enter description here ...
     */
    public function add(){
        if (Request::instance()->isGet()){
            return $this->display();
        }else{
            $item['role_name'] = $this->post('role_name', '', RegExpression::REQUIRED, '角色名称');
            $item['remarks'] = $this->post('remarks', '');
            $item['status'] = $this->post('status', 0);
            $item['addtime'] = SysHelp::getTimeString();
            $res = Db::name('sys_roles')->insert($item);
            if($res !== false){
                $this->toSuccess('添加成功', '', 2);
            }else{
                $this->toError('添加失败');
            }
        }
    }
    
    
    /**
     * 修改
     * Enter description here ...
     */
    public function edit(){
        if (Request::instance()->isGet()){
            $item = Db::name('sys_roles')->where('id', Request::instance()->param('id', 0))->find();
            $this->assign('obj', $item);
            return $this->display();
        }else{
            $item['role_name'] = $this->post('role_name', '', RegExpression::REQUIRED, '角色名称');
            $item['remarks'] = $this->post('remarks', '');
            $item['status'] = $this->post('status', 0);
            $item['id'] = $this->post('id', 0);
            
            $res = Db::name('sys_roles')->update($item);
            if($res !== false){
                $this->toSuccess('编辑成功', '', 2);
            }else{
                $this->toError('编辑失败');
            }
        }
    }
    
    /**
     * 删除角色
     * Enter description here ...
     */
    public function delete(){
        $id = Request::instance()->param('id', 0);
        $res = Db::name('sys_roles')->delete($id);
        //同时删除下面对应的权限配置
        $res = Db::name('sys_authority')->where('role_id', $id)->delete();
        if($res !== false){
            $this->toSuccess('删除成功');
        }else{
            $this->toError('删除失败');
        }
    }
    
    /**
     * 权限编辑页面
     * Enter description here ...
     */
    public function auth(){
        if (Request::instance()->isGet()){
            $role_id = Request::instance()->param('id');
            //1、获取节点信息
            $nm = new NodesModel();
            $list = $nm->getAuthData($role_id);
            $this->assign('list', $list);
            
            return $this->display('auth', true);
        }else{
            $nodes = Request::instance()->post('nodes/a');
            
             //开启事务
            Db::startTrans();
            try{
                $role_id = Request::instance()->post('role_id');
                Db::name('sys_authority')->where('role_id',$role_id)->delete();
                foreach($nodes as $k=>$v){
                    $vo = array();
                    $vo['role_id'] = $role_id;
                    $vo['node_id'] = $v;
                    Db::name('sys_authority')->insert($vo);
                }
                
                Db::commit();
                $this->toSuccess('执行成功', 'system/roles/index'); 
            } catch (Exception $e) {
                // 回滚事务
                Db::rollback();
                $this->toError('执行失败'.$e->getMessage());
            }
        }
    }
    
    
}
