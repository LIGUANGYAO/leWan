<?php
// +----------------------------------------------------------------------
// | 咸鱼网络中心数据管理平台
// +----------------------------------------------------------------------
// | provide by ：www.saltyfishweb.com
// 
// +----------------------------------------------------------------------
// | Author: saltyfishweb@foxmail.com
// +----------------------------------------------------------------------

class WxqrcodeAction extends BaseAction
{
	function index()
	{
		$_mod = D('wx_qrcode');
		$datalist = $_mod->order('id asc')->select();
		foreach($datalist as $k=>$v){
			$datalist[$k]['src'] = 'https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket='.urlencode($v['ticket']);
		}
		$this->assign('datalist',$datalist);
		$big_menu = array(U('Wxqrcode/add'),'创建场景二维码');
		$this->assign('big_menu',$big_menu);		
		$this->display();
	}
	
    //增加
	function add()
	{
	    if(isset($_POST['dosubmit'])){		    	
 			$_mod = D('wx_qrcode');
			if(false === $data = $_mod->create()){
				$this->error($_mod->error());
			}
	    	$data['addtime'] = date('Y-m-d H:i:s', time());
			$id = $_mod->add($data);

			//1.创建ticket
			$access_token = getAccess_token();
			$url = 'https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token='.$access_token;
			$data = '{"action_name": "QR_LIMIT_SCENE", "action_info": {"scene": {"scene_id": '.$id.'}}}';
			$res = postdata($url, $data);
			//保持ticket
			$val['id'] = $id;
			$val['ticket'] = $res['ticket'];
			$val['url'] = $res['url'];
			$_mod->save($val);
			
			$this->success(L('operation_success'), U('Wxqrcode/index'));
	    }else{	
			$this->display();
	    }
	}
	
	
	//修改
	function edit()
	{
		if(isset($_POST['dosubmit'])){
			$_mod = D('wx_qrcode');
			if(false === $data = $_mod->create()){
				$this->error($_mod->error());
			}
	    	$data['addtime'] = date('Y-m-d H:i:s', time());
			$_mod->save($data);
			$this->success(L('operation_success'), U('Wxqrcode/index'));
		}else{
			if( isset($_GET['id']) ){
				$id = isset($_GET['id']) && intval($_GET['id']) ? intval($_GET['id']) : $this->error('参数错误');
			}
		    $data = D('wx_qrcode')->find($id);		
			$this->assign('data', $data);	
			
			$this->display();
		}
	}
	//删除
	function delete()	{
		if((!isset($_GET['id']) || empty($_GET['id'])) && (!isset($_POST['id']) || empty($_POST['id']))) {
            $this->error('请选择要删除的数据');
		}
		$_mod = D('wx_qrcode');
		$id = intval($_GET['id']);
		$_mod->delete($id);
		$this->success(L('operation_success'));
	}

	
	
}
?>