<?php
namespace app\system\controller;

use app\common\AdminBaseController;
use think\Request;
use think\Db;
use think\Log;
use think\Config;
use think\Cache;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;

/**
 * 微信菜单
 * Enter description here ...
 * @author Administrator
 *
 */
class WxmenuController extends AdminBaseController
{
    
    /**
     * 首页
     * Enter description here ...
     */
    public function index(){
    	//设置添加信息按钮
    	$this->assign('addbtn',  $this->returnAddbtn('添加菜单', 'system/wxmenu/add', 2));
    	
    	$list = Db::name('wx_menu')->where('parent_id < 1')->order('sort asc')->select();
    	$childs = Db::name('wx_menu')->where('parent_id > 1')->order('sort asc')->select();
    	foreach ($list as $k=>$v){
    		foreach ($childs as $a=>$b){
    			if($b['parent_id'] == $v['id']){
    				$list[$k]['childs'][] = $b;
    			}
    		}
    	}
    	$this->assign('list' ,$list);
    	
        return $this->display('wx/index_menu', true);
    }
    
    
    /**
     * 添加操作
     * Enter description here ...
     */
    public function add(){
    	if (Request::instance()->isGet()){
    		$this->assign('page_title',  '添加菜单');
    		//加载素材内容
    		$datalist = Db::name('wx_sourcegroup')->order('id DESC')->select();
    		foreach($datalist as $k=>$v){
    			$datalist[$k]['items'] = Db::name('wx_sourceitems')->field('id, title, pic')->where('groupid='.$v['id'])->order('id asc')->select();
    		}
    		$this->assign('datalist',$datalist);
    		//顶级菜单
    		$plist = Db::name('wx_menu')->where('parent_id=0')->order('sort asc')->select();
    		$this->assign('plist',$plist);
    		
    		return $this->display('wx/add_menu', true);
    	}else{
    		$item['parent_id'] = $this->post('parent_id', 0);
    		$item['name'] = $this->post('name', '', RegExpression::REQUIRED, '菜单名称');
    		$item['type'] = $this->post('type', 'click');
    		$item['key'] = md5(time());
    		$item['url'] = $this->post('url', '');
    		$item['iscode'] = $this->post('iscode', 0);
    		$item['groupid'] = $this->post('groupid', 0);
    		$item['addtime'] = SysHelp::getTimeString();
    
    		$res = Db::name('wx_menu')->insert($item);
    		if($res !== false){
    			$this->toSuccess('添加成功', url('wxmenu/index'));
    		}else{
    			$this->toError('添加失败');
    		}
    	}
    }
    
    

    /**
     * 修改操作
     * Enter description here ...
     */
    public function edit(){
    	if (Request::instance()->isGet()){
    		$this->assign('page_title',  '编辑菜单');
    		$id = $this->get('id');
    		$menu = Db::name('wx_menu')->find($id);
    		$this->assign('menu', $menu);
    		//加载素材内容
    		$datalist = Db::name('wx_sourcegroup')->order('id DESC')->select();
    		foreach($datalist as $k=>$v){
    			$datalist[$k]['items'] = Db::name('wx_sourceitems')->field('id, title, pic')->where('groupid='.$v['id'])->order('id asc')->select();
    		}
    		$this->assign('datalist',$datalist);
    		//顶级菜单
    		$plist = Db::name('wx_menu')->where('parent_id=0')->order('sort asc')->select();
    		$this->assign('plist',$plist);
    
    		return $this->display('wx/edit_menu', true);
    	}else{
                if($this->post('hid', 0) >=0 ){
                    $item['parent_id'] = $this->post('parent_id', 0);
                    $item['type'] = $this->post('type', 'click');
                    $item['name'] = $this->post('name', '', RegExpression::REQUIRED, '菜单名称');
                    $item['key'] = md5(time());
                    $item['url'] = $this->post('url', '');
                    $item['iscode'] = $this->post('iscode', 0);
                }
    		$item['groupid'] = $this->post('groupid', 0);
    		$item['id'] = $this->post('id', 0);
    		$item['addtime'] = SysHelp::getTimeString();
    
    		$res = Db::name('wx_menu')->update($item);
    		if($res !== false){
    			$this->toSuccess('编辑成功', url('wxmenu/index'));
    		}else{
    			$this->toError('编辑失败');
    		}
    	}
    }
    
    
    /**
     * 删除菜单
     */
    public function delete(){
    	$id = Request::instance()->param('id', 0);
    	if($id > 0){
    		$res = Db::name('wx_menu')->delete($id);
    	}
    	$this->toSuccess('删除成功');
    }
    
    
    /**
     * 创建菜单
     */
    public function create(){
    	$access_token = get_wx_access_token();
    	//1.删除菜单
    	$delurl = 'https://api.weixin.qq.com/cgi-bin/menu/delete?access_token='.$access_token;
    	$res = wx_get($delurl);
    	if(!$res){
    		$this->error('菜单删除失败');
    	}
    	if(Request::instance()->param('remove') == 1){
            $this->error('菜单删除成功');exit;
        }
    	//创建菜单
    	$msg_body = $this->create_menu_msg_body();
    	$url = 'https://api.weixin.qq.com/cgi-bin/menu/create?access_token='.$access_token;
    	$res = wx_post($url, $msg_body);
    	if(!$res){
    		$this->error('菜单创建失败');
    	}else{
    		$this->success('创建成功msg='.$res['errmsg'].';code='.$res['errcode'].'，24小时内生效！');
    	}
    }
    
    //生成菜单json结构
    private function create_menu_msg_body(){
    	$first_menu = Db::name('wx_menu')->where('parent_id=0')->order('sort asc')->select();
    	//二级菜单
    	$temp_btn = array();
    	foreach($first_menu as $fm){
    		$fist_m = array();
    		$fist_m['name'] = urlencode($fm['name']);
    		$second_menu = Db::name('wx_menu')->where('parent_id='.$fm['id'])->order('sort asc')->select();
    		if(count($second_menu) > 0){
    			$temp_sm = array();
    			foreach($second_menu as $sm){
    				$btn = array();
    				$btn['type'] = strtolower($sm['type']);
    				$btn['name'] = urlencode($sm['name']);
    				if($sm['type'] == 'click'){
    					$btn['key'] = $sm['key'];
    				}elseif($sm['type'] == 'view'){
    					//是否加密
    					if($sm['iscode'] == 1){
    						$btn['url'] = get_wx_snslink($sm['url']);
    					}else{
    						$btn['url'] = $sm['url'];
    					}
    				}
    				$temp_sm[] = $btn;
    			}
    			$fist_m['sub_button'] = $temp_sm;
    		}else{
    			$btntype = strtolower($fm['type']);
    			$btnname = urlencode($fm['name']);
    			$fist_m['type'] = $btntype;
    			if($btntype == 'click'){
    				$fist_m['key'] = $fm['key'];
    			}elseif($btntype == 'view'){
    				//是否加密
    				if($fm['iscode'] == 1){
    					$fist_m['url'] = get_wx_snslink($fm['url']);
    				}else{
    					$fist_m['url'] = $fm['url'];
    				}
    			}
    
    		}
    			
    			
    		$temp_btn[] = $fist_m;
    	}
    
    	$menu_code_json['button'] = $temp_btn;
    	$create_menu_body = json_encode($menu_code_json);
    	$create_menu_body =  urldecode($create_menu_body);
    	return $create_menu_body;
    }
    
}
