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
class ContentModel 
{
    
    /**
     * 活动列表-分页
     * Enter description here ...
     * @param unknown_type $map
     * @param unknown_type $pagenow
     * @param unknown_type $pagesize
     */
    public function getActivesList($map=array(), $pagenow=1, $pagesize=10){
        //查询总记录
        $count = Db::name('actives a')->where($map)->count();
        
        $list = Db::name('actives a')
                ->field('a.id, a.title, a.addtime, a.starttime, a.price, a.`status`, (a.enrollnum+a.applynum) as enrollnum, a.totalnum, c.cat_name')
                ->where($map)
                ->join('categories c', 'c.id = a.cat_id', 'left')
                ->page($pagenow, $pagesize)
                ->order(' a.id desc')
                ->select();

        $return['list'] = $list;
        $pagination = new PaginationModel();
        $return['page'] = $pagination->getPage($count, $pagenow, $pagesize);
        return $return;
    }
    
    
    /**
     * 新闻列表-分页
     * Enter description here ...
     * @param unknown_type $map
     * @param unknown_type $pagenow
     * @param unknown_type $pagesize
     */
    public function getArticleList($map=array(), $pagenow=1, $pagesize=10){
        //查询总记录
        $count = Db::name('article a')->where($map)->count();
        
        $list = Db::name('article a')
                ->field('a.id, a.title, a.add_time, a.`status`, c.cat_name')
                ->where($map)
                ->join('categories c', 'c.id = a.cat_id', 'left')
                ->page($pagenow, $pagesize)
                ->order(' a.id desc')
                ->select();

        $return['list'] = $list;
        $pagination = new PaginationModel();
        $return['page'] = $pagination->getPage($count, $pagenow, $pagesize);
        return $return;
    }
    
    /**
     * 其他内容
     * Enter description here ...
     * @param unknown_type $map
     * @param unknown_type $pagenow
     * @param unknown_type $pagesize
     */
    public function getContentList($map=array(), $pagenow=1, $pagesize=10){
        //查询总记录
        $count = Db::name('content a')->where($map)->count();
        
        $list = Db::name('content a')
                ->field('a.id, a.title, a.add_time, a.`status`, c.cat_name, a.sort')
                ->where($map)
                ->join('categories c', 'c.id = a.cat_id', 'left')
                ->page($pagenow, $pagesize)
                ->order(' a.sort asc')
                ->select();

        $return['list'] = $list;
        $pagination = new PaginationModel();
        $return['page'] = $pagination->getPage($count, $pagenow, $pagesize);
        return $return;
    }
    
    
    /**
     * 获取分类列表
     * @param number $cate_id
     */
    public function getCatesById($cate_id=0){
    	$parents = Db::name('categories')->where('parent_id = '.$cate_id)->order('sort asc')->select();
    	foreach ($parents as $k=>$v){
    		$parents[$k]['childs'] = Db::name('categories')->where('parent_id = '.$v['id'])->order('sort asc')->select();
    	}
    	return $parents;
    }
    
}
