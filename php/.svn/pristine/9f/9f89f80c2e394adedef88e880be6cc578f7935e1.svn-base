<?php
namespace app\system\controller;

use app\common\AdminBaseController;
use think\Request;
use think\Db;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;
use app\system\model\AdminModel;
use app\system\model\ContentModel;
use app\system\model\PaginationModel;
use app\system\model\NodesModel;

/**
 * 单页管理
 * Enter description here ...
 * @author Administrator
 *
 */
class PageController extends AdminBaseController
{
    
	//大分类id
	private $section = 2;
	
	
    /**
     * 啤酒列表
     * Enter description here ...
     */
    public function index(){
    	$page_section_id = $this->get('section', 0);
    	if($page_section_id > 0){
    		Session::set('page_section_id', $page_section_id);
    	}
    	
    	
        //设置添加信息按钮
        $this->assign('addbtn',  $this->returnAddbtn('添加页面', 'system/page/add', 2));
        
        $cm = new ContentModel();
        //类型
        $this->assign('parents',  $cm->getCatesById($this->section));
        
        //获取参数
        $pn = $this->get('page', 1);
        $kws = $this->get('kws', '');
        $cat_id = $this->get('cat_id', 0);
        $starttime = $this->get('starttime', '');
        $endtime = $this->get('endtime', '');
        //组合where
        if($kws != ''){
        	$where['a.name'] = array('like', '%'.$kws.'%');
        	$this->assign('kws', $kws);
        }
        $where['a.section'] = Session::get('page_section_id');
        if($starttime != ''){
        	$where['a.addtime'] = array('egt', $starttime);
        	$this->assign('starttime', $starttime);
        }
        if($endtime != ''){
        	$where['a.addtime'] = array('elt', $endtime);
        	$this->assign('endtime', $endtime);
        }

       //获取分页列表数据
         //查询总记录
        $count = Db::name('page a')->where($where)->count();
        
        $list = Db::name('page a')
                ->field('a.*')
                ->where($where)
                ->page($pagenow, $pagesize)
                ->order(' a.id desc')
                ->select();

        $data['list'] = $list;
        $pagination = new PaginationModel();
        $data['page'] = $pagination->getPage($count, $pagenow, $pagesize);

        $this->assign('data',  $data);
        return $this->display('index', true);
    }
    
    
    /**
     * 添加操作
     * Enter description here ...
     */
    public function add(){
        if (Request::instance()->isGet()){
	        $this->assign('action',  url('system/page/add'));
            return $this->display('edit', true);
        }else{
        	$item['title'] = $this->post('title', '', RegExpression::REQUIRED, '页面名称');
//        	$item['photo1'] = $this->post('photo1', '');
//        	$item['photo2'] = $this->post('photo2', '');
//        	$item['photo3'] = $this->post('photo3', '');
//        	$item['photo4'] = $this->post('photo4', '');
        	$item['content'] = $this->post('content', '');
        	$item['add_time'] = time();
        	$item['section'] = Session::get('page_section_id');
        	
        	$res = Db::name('page')->insert($item);
        	//删除图片
        	$this->deleteUploaded('uploads', $item['photo1']);
        	$this->deleteUploaded('uploads', $item['photo2']);
        	$this->deleteUploaded('uploads', $item['photo3']);
        	$this->deleteUploaded('uploads', $item['photo4']);
        	
            $this->log('添加页面：'.$item['title']);
            if($res !== false){
                $this->toSuccess('发布成功', 'page/index');
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
            $item = Db::name('page')->where('id', Request::instance()->param('id', 0))->find();
            $this->assign('obj', $item);
	        $this->assign('action',  url('system/page/edit'));
            return $this->display('edit', true);
        }else{
        	$item['id'] = $this->post('id', 0);
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '页面名称');
            $item['en_title'] = $this->post('en_title', '');
        	$photo1 = $this->post('photo1', '');
        	$photo2 = $this->post('photo2', '');
        	$photo3 = $this->post('photo3', '');
        	$photo4 = $this->post('photo4', '');
        	$item['content'] = $this->post('content', '');
        	$item['en_content'] = $this->post('en_content', '');
        	$item['add_time'] = time();
            if($photo1 != ''){
            	$item['photo1'] = $photo1;
            	$this->deleteUploaded('uploads', $item['photo1']);
            }
            if($photo2 != ''){
            	$item['photo2'] = $photo2;
            	$this->deleteUploaded('uploads', $item['photo2']);
            }
            if($photo3 != ''){
            	$item['photo3'] = $photo3;
            	$this->deleteUploaded('uploads', $item['photo3']);
            }
            if($photo4 != ''){
            	$item['photo4'] = $photo4;
            	$this->deleteUploaded('uploads', $item['photo4']);
            }
            
            $res = Db::name('page')->update($item);
            
            $this->log('修改页面：'.$item['title']);
            if($res !== false){
                $this->toSuccess('编辑成功', url('page/index'));
            }else{
                $this->toError('编辑失败');
            }
        }
    }
    
    /**
     * 删除账号
     * Enter description here ...
     */
    public function delete(){
        $id = Request::instance()->param('id', 0);
        $idstr = Request::instance()->post('idstr', '');
        if($id > 0){
	        $obj = Db::name('page')->where('id', $id)->find();
	        $this->log('删除页面：'.$obj['title']);
	        $this->deletefile('uploads', $obj['photo1']);
	        $this->deletefile('uploads', $obj['photo2']);
	        $this->deletefile('uploads', $obj['photo3']);
	        $this->deletefile('uploads', $obj['photo4']);
	        $res = Db::name('page')->delete($id);
        }else{
        	//批量删除
        	$idarray = explode(',', $idstr);
        	foreach ($idarray as $k=>$v){
        		if(!(empty($v))){
        			$obj = Db::name('article')->where('id', $v)->find();
			        $this->log('删除页面：'.$obj['title']);
			        $this->deletefile('uploads', $obj['photo1']);
			        $this->deletefile('uploads', $obj['photo2']);
			        $this->deletefile('uploads', $obj['photo3']);
			        $this->deletefile('uploads', $obj['photo4']);
			        $res = Db::name('page')->delete($v);
        		}
        	}
        }
        $this->toSuccess('删除成功');
    }
    
}
