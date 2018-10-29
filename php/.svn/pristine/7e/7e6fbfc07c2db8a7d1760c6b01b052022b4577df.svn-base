<?php
namespace app\system\model;

use think\Request;

/**
 * 分页工具model
 * 
 * @author jay
 *
 */
class PaginationModel{
	
	
	/**
	 * 获取分页的参数
	 * @param  $count 总数据量
	 * @param  $pagenow  当前页
	 * @param  $pagesize 每页数量
	 * @return unknown
	 */
	public function getPage($count, $pagenow=1, $pagesize=10){
		$pagecount = ceil($count/$pagesize);
		$page['recordcount'] = $count;
		$page['pagenow'] = $pagenow;
		$page['pagecount'] = $pagecount;
		$page['url'] = Request::instance()->url();
		return $page;
	}
}