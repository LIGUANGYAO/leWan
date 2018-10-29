<?php

namespace app\system\controller;

use app\common\AdminBaseController;
use think\Request;
use think\Db;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;
use app\system\model\PaginationModel;
use app\system\model\AdminModel;
use app\system\model\ContentModel;

/**
 * 房型管理
 * Enter description here ...
 * @author Administrator
 *
 */
class RoomController extends AdminBaseController {


    /**
     * 房型列表
     * Enter description here ...
     */
    public function index() {
        //设置添加信息按钮
        $this->assign('addbtn', $this->returnAddbtn('添加房型', 'system/room/add', 2));
        $list = Db::name('room')->field('id, title, price, feature, addtime, sort, `status`')->order('sort asc')->select();
        $this->assign('data', $list);
        return $this->display('index', true);
    }

    /**
     * 添加操作
     * Enter description here ...
     */
    public function add() {
        if (Request::instance()->isGet()) {
            $this->assign('roomservice', Db::name('roomservice')->select());
            $this->assign('action', url('system/room/add'));
            return $this->display('edit', true);
        } else {
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '房型名称');
            $item['num'] = $this->post('num', 0);
            $item['price'] = $this->post('price', 0);
            $item['type'] = $this->post('type', 1);
            $item['feature'] = $this->post('feature', '', RegExpression::REQUIRED, '房型摘要');
            $item['pic'] = $this->post('pic', '');
            $item['photo1'] = $this->post('photo1', '');
            $item['photo2'] = $this->post('photo2', '');
            $item['photo3'] = $this->post('photo3', '');
            $item['photo4'] = $this->post('photo4', '');
            $item['photo5'] = $this->post('photo5', '');
            $item['photo6'] = $this->post('photo6', '');
            $item['descp'] = $this->post('descp', '');
            $item['serviceIds'] = implode(',',$_POST['sids']);
            $item['introduction'] = $this->post('introduction', '');
            $item['addtime'] = time();
            $res = Db::name('room')->insert($item);
            //删除图片
            $this->deleteUploaded('uploads', $item['pic']);

            $this->log('添加房型：' . $item['title']);
            if ($res !== false) {
                $this->toSuccess('添加成功', 'room/index');
            } else {
                $this->toError('添加失败');
            }
        }
    }

    /**
     * 修改
     * Enter description here ...
     */
    public function edit() {
        if (Request::instance()->isGet()) {
            $item = Db::name('room')->where('id', Request::instance()->param('id', 0))->find();
            $this->assign('obj', $item);
            $ids = explode(',', $item['serviceIds']);
            //类型
            $services = Db::name('roomservice')->select();
            foreach ($services as $k=>$v){
                if(in_array($v['id'], $ids)){
                    $services[$k]['ischeck'] = 1;
                }
            }
            $this->assign('roomservice', $services);
            $this->assign('action', url('system/room/edit'));
            return $this->display('edit', true);
        } else {
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '房型名称');
            $item['num'] = $this->post('num', 0);
            $item['price'] = $this->post('price', 0);
            $item['type'] = $this->post('type', 1);
            $item['feature'] = $this->post('feature', '', RegExpression::REQUIRED, '房型摘要');
            $item['pic'] = $this->post('pic', '');
            $item['photo1'] = $this->post('photo1', '');
            $item['photo2'] = $this->post('photo2', '');
            $item['photo3'] = $this->post('photo3', '');
            $item['photo4'] = $this->post('photo4', '');
            $item['photo5'] = $this->post('photo5', '');
            $item['photo6'] = $this->post('photo6', '');
            $item['descp'] = $this->post('descp', '');
            $item['serviceIds'] = implode(',',$_POST['sids']);
            $item['introduction'] = $this->post('introduction', '');
            $item['id'] = $this->post('id', 0);

            $res = Db::name('room')->update($item);
            //删除图片
            $this->deleteUploaded('uploads', $item['pic']);

            $this->log('修改房型：' . $item['title']);
            if ($res !== false) {
                $this->toSuccess('编辑成功', url('room/index'));
            } else {
                $this->toError('编辑失败');
            }
        }
    }

    /**
     * 删除账号
     * Enter description here ...
     */
    public function delete() {
        $id = Request::instance()->param('id', 0);
        $idstr = Request::instance()->post('idstr', '');
        if ($id > 0) {
            $obj = Db::name('room')->where('id', $id)->find();
            $this->log('删除房型：' . $obj['title']);
            $this->deletefile('uploads', $obj['pic']);
            $res = Db::name('room')->delete($id);
        } else {
            //批量删除
            $idarray = explode(',', $idstr);
            foreach ($idarray as $k => $v) {
                if (!(empty($v))) {
                    $obj = Db::name('room')->where('id', $v)->find();
                    $this->log('删除房型：' . $obj['title']);
                    $this->deletefile('uploads', $obj['pic']);
                    $res = Db::name('room')->delete($v);
                }
            }
        }
        $this->toSuccess('删除成功');
    }

}
