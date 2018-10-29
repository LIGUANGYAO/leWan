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

/**
 * 门店管理
 * Enter description here ...
 * @author Administrator
 *
 */
class StoreController extends AdminBaseController
{
    
	//无
	private $section = 0;
	
	
    /**
     * 门店列表
     * Enter description here ...
     */
    public function index(){
    	$cat_id = $this->get('section', 0);
    	if($cat_id > 0){
    		Session::set('store_cat_id', $cat_id);
    	}
        //设置添加信息按钮
        $this->assign('addbtn',  $this->returnAddbtn2('增加门店', url('store/add', array('cat_id'=>Session::get('store_cat_id'))), 2));
        
        $cm = new ContentModel();
        //门店类型
        $this->assign('parents',  $cm->getCatesById(6));
        
        //获取参数
        $pn = $this->get('page', 1);
        $kws = $this->get('kws', '');
        $cat_id = $this->get('cat_id', 0);
        $starttime = $this->get('starttime', '');
        $endtime = $this->get('endtime', '');
        //组合where
        if($kws != ''){
        	$where['a.title'] = array('like', '%'.$kws.'%');
        	$this->assign('kws', $kws);
        }
        //if($cat_id > 0){
        	$where['a.cat_id'] = Session::get('store_cat_id');
        //	$this->assign('cat_id', $cat_id);
        //}
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
        $count = Db::name('store a')->where($where)->count();
        
        $list = Db::name('store a')
                ->field('a.*, c.cat_name')
                ->where($where)
                ->join('categories c', 'c.id = a.cat_id', 'left')
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
            //门店类型
            //$cm = new ContentModel();
        	//$this->assign('parents',  $cm->getCatesById(6));
        	$cat_id = $this->get('cat_id', 0);
        	//省份
        	$this->assign('provence', $this->getProvenceList());
	        $this->assign('action',  url('system/store/add'));
            return $this->display('edit'.$cat_id, true);
        }else{
        	$item['title'] = $this->post('title', '', RegExpression::REQUIRED, '名称');
        	$item['en_title'] = $this->post('en_title', '');
        	$item['cat_id'] = $this->post('cat_id',0);
        	$item['provence_id'] = $this->post('provence_id', '');
        	$item['city_id'] = $this->post('city_id', '');
        	$item['area_id'] = $this->post('area_id', '');
        	$item['address'] = $this->post('address', '');
        	$item['en_address'] = $this->post('en_address', '');
        	$item['ssq'] = $this->post('ssq', '', RegExpression::REQUIRED, '省市区');
        	$item['en_ssq'] = $this->post('en_ssq', '');
        	$item['lng'] = $this->post('lng', '');
        	$item['lat'] = $this->post('lat', '');
        	$item['tel'] = $this->post('tel', '');
        	$item['businesstime'] = $this->post('businesstime', '');
			$item['content'] = $this->post('content', '');
        	$item['en_content'] = $this->post('en_content', '');
        	$item['add_time'] = time();
        	//图片
        	$item['pic_logo'] = $this->post('pic_logo', '');
        	$item['pic_photo1'] = $this->post('pic_photo1', '');
        	$item['pic_photo2'] = $this->post('pic_photo2', '');
        	$item['pic_photo3'] = $this->post('pic_photo3', '');
        	$item['pic_photo4'] = $this->post('pic_photo4', '');
        	$item['pic_tg1'] = $this->post('pic_tg1', '');
        	$item['pic_tg2'] = $this->post('pic_tg2', '');
        	$item['pic_menu1'] = $this->post('pic_menu1', '');
        	$item['pic_menu1_1'] = $this->post('pic_menu1_1', '');
        	$item['pic_menu2'] = $this->post('pic_menu2', '');
        	$item['pic_menu2_2'] = $this->post('pic_menu2_2', '');
        	$item['pic_menu3'] = $this->post('pic_menu3', '');
        	$item['pic_menu3_3'] = $this->post('pic_menu3_3', '');
        	
        	
        	//删除图片
        	$this->deleteUploaded('uploads', $item['pic_logo']);
        	$this->deleteUploaded('uploads', $item['pic_photo1']);
        	$this->deleteUploaded('uploads', $item['pic_photo2']);
        	$this->deleteUploaded('uploads', $item['pic_photo3']);
        	$this->deleteUploaded('uploads', $item['pic_photo4']);
        	$this->deleteUploaded('uploads', $item['pic_tg1']);
        	$this->deleteUploaded('uploads', $item['pic_tg2']);
        	$this->deleteUploaded('uploads', $item['pic_menu1']);
        	$this->deleteUploaded('uploads', $item['pic_menu1_1']);
        	$this->deleteUploaded('uploads', $item['pic_menu2']);
        	$this->deleteUploaded('uploads', $item['pic_menu2_2']);
        	$this->deleteUploaded('uploads', $item['pic_menu3']);
        	$this->deleteUploaded('uploads', $item['pic_menu3_3']);

        	$res = Db::name('store')->insert($item);
            $this->log('增加店铺：'.$item['title']);
            if($res !== false){
                $this->toSuccess('发布成功', 'store/index');
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
            $item = Db::name('store')->where('id', Request::instance()->param('id', 0))->find();
            $this->assign('obj', $item);
            //类型
            $cat_id = $this->get('cat_id', $item['cat_id']);
        	//省份
        	$this->assign('provence', $this->getProvenceList());
        	$this->assign('city', $this->getCityList($item['provence_id']));
        	$this->assign('area', $this->getAreaList($item['city_id']));
        	
	        $this->assign('action',  url('system/store/edit'));
            return $this->display('edit'.$cat_id, true);
        }else{
        	$item['id'] = $this->post('id',0);
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '名称');
        	$item['en_title'] = $this->post('en_title', '');
        	$item['cat_id'] = $this->post('cat_id',0);
        	$item['provence_id'] = $this->post('provence_id', '');
        	$item['city_id'] = $this->post('city_id', '');
        	$item['area_id'] = $this->post('area_id', '');
        	$item['address'] = $this->post('address', '');
        	$item['en_address'] = $this->post('en_address', '');
        	$item['ssq'] = $this->post('ssq', '', RegExpression::REQUIRED, '省市区');
        	$item['en_ssq'] = $this->post('en_ssq', '');
        	$item['lng'] = $this->post('lng', '');
        	$item['lat'] = $this->post('lat', '');
        	$item['tel'] = $this->post('tel', '');
        	$item['businesstime'] = $this->post('businesstime', '');
			$item['content'] = $this->post('content', '');
        	$item['en_content'] = $this->post('en_content', '');
        	$item['add_time'] = time();
        	//图片
        	$item['pic_logo'] = $this->post('pic_logo', '');
        	$item['pic_photo1'] = $this->post('pic_photo1', '');
        	$item['pic_photo2'] = $this->post('pic_photo2', '');
        	$item['pic_photo3'] = $this->post('pic_photo3', '');
        	$item['pic_photo4'] = $this->post('pic_photo4', '');
        	$item['pic_tg1'] = $this->post('pic_tg1', '');
        	$item['pic_tg2'] = $this->post('pic_tg2', '');
        	$item['pic_menu1'] = $this->post('pic_menu1', '');
        	$item['pic_menu1_1'] = $this->post('pic_menu1_1', '');
        	$item['pic_menu2'] = $this->post('pic_menu2', '');
        	$item['pic_menu2_2'] = $this->post('pic_menu2_2', '');
        	$item['pic_menu3'] = $this->post('pic_menu3', '');
        	$item['pic_menu3_3'] = $this->post('pic_menu3_3', '');
        	if($item['pic_logo'] == ''){
        		unset($item['pic_logo']);
        	}
        	if($item['pic_photo1'] == ''){
        		unset($item['pic_photo1']);
        	}
        	if($item['pic_photo2'] == ''){
        		unset($item['pic_photo2']);
        	}
        	if($item['pic_photo3'] == ''){
        		unset($item['pic_photo3']);
        	}
        	if($item['pic_photo4'] == ''){
        		unset($item['pic_photo4']);
        	}
        	if($item['pic_tg1'] == ''){
        		unset($item['pic_tg1']);
        	}
        	if($item['pic_tg2'] == ''){
        		unset($item['pic_tg2']);
        	}
        	if($item['pic_menu1'] == ''){
        		unset($item['pic_menu1']);
        	}
        	if($item['pic_menu1_1'] == ''){
        		unset($item['pic_menu1_1']);
        	}
        	if($item['pic_menu2'] == ''){
        		unset($item['pic_menu2']);
        	}
        	if($item['pic_menu2_2'] == ''){
        		unset($item['pic_menu2_2']);
        	}
        	if($item['pic_menu3'] == ''){
        		unset($item['pic_menu3']);
        	}
        	if($item['pic_menu3_3'] == ''){
        		unset($item['pic_menu3_3']);
        	}
        	
        	//删除图片
        	$this->deleteUploaded('uploads', $item['pic_logo']);
        	$this->deleteUploaded('uploads', $item['pic_photo1']);
        	$this->deleteUploaded('uploads', $item['pic_photo2']);
        	$this->deleteUploaded('uploads', $item['pic_photo3']);
        	$this->deleteUploaded('uploads', $item['pic_photo4']);
        	$this->deleteUploaded('uploads', $item['pic_tg1']);
        	$this->deleteUploaded('uploads', $item['pic_tg2']);
        	$this->deleteUploaded('uploads', $item['pic_menu1']);
        	$this->deleteUploaded('uploads', $item['pic_menu1_1']);
        	$this->deleteUploaded('uploads', $item['pic_menu2']);
        	$this->deleteUploaded('uploads', $item['pic_menu2_2']);
        	$this->deleteUploaded('uploads', $item['pic_menu3']);
        	$this->deleteUploaded('uploads', $item['pic_menu3_3']);
            
            $res = Db::name('store')->update($item);
            
            $this->log('修改店铺：'.$item['title']);
            if($res !== false){
                $this->toSuccess('编辑成功', url('store/index'));
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
	        $obj = Db::name('store')->where('id', $id)->find();
	        $this->log('删除门店：'.$obj['title']);
	        $this->deletefile('uploads', $obj['pic_logo']);
	        $this->deletefile('uploads', $obj['pic_photo1']);
	        $this->deletefile('uploads', $obj['pic_photo2']);
	        $this->deletefile('uploads', $obj['pic_photo3']);
	        $this->deletefile('uploads', $obj['pic_photo4']);
	        $this->deletefile('uploads', $obj['pic_tg1']);
	        $this->deletefile('uploads', $obj['pic_tg2']);
	        $this->deletefile('uploads', $obj['pic_menu1']);
	        $this->deletefile('uploads', $obj['pic_menu1_1']);
	        $this->deletefile('uploads', $obj['pic_menu2']);
	        $this->deletefile('uploads', $obj['pic_menu2_2']);
	        $this->deletefile('uploads', $obj['pic_menu3']);
	        $this->deletefile('uploads', $obj['pic_menu3_3']);
	        $res = Db::name('store')->delete($id);
        }else{
        	//批量删除
        	$idarray = explode(',', $idstr);
        	foreach ($idarray as $k=>$v){
        		if(!(empty($v))){
        			$obj = Db::name('store')->where('id', $v)->find();
			        $this->log('删除门店：'.$obj['title']);
			        $this->deletefile('uploads', $obj['pic']);
			        $res = Db::name('store')->delete($v);
        		}
        	}
        }
        $this->toSuccess('删除成功');
    }
    
}
