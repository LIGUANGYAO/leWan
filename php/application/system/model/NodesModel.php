<?php

namespace app\system\model;

use think\Db;
use think\Config;
use think\Request;
use think\Session;
use think\Cache;

/**
 * 系统节点相关
 * Enter description here ...
 * @author Administrator
 *
 */
class NodesModel {

    /**
     * 节点列表-分页
     * Enter description here ...
     * @param unknown_type $map
     * @param unknown_type $pagenow
     * @param unknown_type $pagesize
     */
    public function getList($map = array(), $pagenow = 1, $pagesize = 10) {
        //查询总记录
        $count = Db::name('sys_nodes n')->where($map)->count();

        $list = Db::name('sys_nodes n')
                ->field('n.id, n.group_id, n.title, n.codes, n.icon, n.type, n.status, n.sort, g.title as `group`')
                ->where($map)
                ->join('sys_group g', 'g.id = n.group_id', 'left')
                ->page($pagenow, $pagesize)
                ->order(' n.codes asc, n.type asc')
                ->select();

        $return['list'] = $list;
        $pagination = new PaginationModel();
        $return['page'] = $pagination->getPage($count, $pagenow, $pagesize);
        return $return;
    }

    public function add($item) {
        return Db::name('sys_admin')->insert($item);
    }

    /**
     * 获取权限编辑页面展示格式
     * Enter description here ...
     */
    public function getAuthData($role_id = 0) {
        //1.获取全部的数据
        $nodes = Db::name('sys_group g')->field('g.id, g.title as groupname, n.id node_id, n.title node, a.node_id as ischeck')
                ->join('sys_nodes n', 'g.id = n.group_id', 'left')
                ->join('sys_authority a', 'a.node_id = n.id and a.role_id =' . $role_id, 'left')
                ->where('g.`status` = 1 and n.`status` = 1')
                ->order('g.sort asc, n.codes asc, n.sort asc')
                ->select();


        //2.
        $list = array();
        foreach ($nodes as $k => $v) {
            $list[$v['id']]['list'][] = $v;
            $list[$v['id']]['title'] = $v['groupname'];
        }
        return $list;
    }

    /**
     * 获取管理员权限对应的菜单
     * Enter description here ...
     */
    public function getGroup() {
        //1.获取菜单
        if (Session::get('admin.id') == 100) {
            $groups = Db::name('sys_group')->field('id, title, icon')->where('status=1')->order('sort asc')->select();
        } else {
            $groups = Db::query('select g.id, g.title, g.icon from jay_sys_authority as a'
                            . ' left join jay_sys_nodes as n on n.id = a.node_id'
                            . ' left join jay_sys_group as g on g.id = n.group_id'
                            . ' where a.role_id=' . Session::get('admin.role_id')
                            . ' group by n.group_id order by g.sort asc');
        }
        return $groups;
    }

    public function secondMenu($group_id = 0) {
        //1.获取菜单
        if (Session::get('admin.id') == 100) {
            if(Config::get('display_nodes')){
                $ww = '';
            }else{
                $ww = ' and id not in(1,2,8,9,16)';
            }
            $nodes = Db::name('sys_nodes')->where('status=1 and type=1 and group_id = ' . $group_id.$ww)->order('sort asc')->select();
        } else {
            $nodes = Db::query('select n.* from jay_sys_authority as a'
                            . ' left join jay_sys_nodes as n on n.id = a.node_id'
                            . ' where n.type = 1 and a.role_id=' . Session::get('admin.role_id') . ' and n.group_id = ' . $group_id
                            . ' order by n.sort asc');
        }

        foreach ($nodes as $k => $v) {
            $args = json_decode($v['args']);
            $nodes[$k]['url'] = url($v['codes'], $args);
        }
        return $nodes;
    }

    public function getAction($c, $a) {
        $and = '';
        if (Session::get('admin.groupid')) {
            $and = ' and n.group_id = ' . Session::get('admin.groupid');
        }

        //1.获取菜单
        $action = $c . '/' . $a;
        $nodes = Db::name('sys_nodes n')->field('n.*, c.title as cat_name')
                        ->join('sys_group c', 'c.id = n.group_id', 'left')
                        ->where("n.status=1 and n.codes like '%$action%'" . $and)->find();
        if (empty($nodes)) {
            $nodes = Db::name('sys_nodes n')->field('n.*, c.title as cat_name')
                            ->join('sys_group c', 'c.id = n.group_id', 'left')
                            ->where("n.status=1 and n.codes like '%$action%'")->find();
        }
        return $nodes;
    }

    /**
     * 验证点击的具体节点权限
     * Enter description here ...
     */
    public function authorization($c, $a, $role_id) {
        $action = $c . '/' . $a;
        $nodes = Db::name('sys_authority a')
                        ->join('sys_nodes n', 'n.id = a.node_id and a.role_id = ' . $role_id, 'left')
                        ->where("n.status=1 and n.codes like '%$action%'")->find();
        if ($nodes) {
            return true;
        } else {
            return false;
        }
    }

}
