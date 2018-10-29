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

/**
 * 项目管理
 * Enter description here ...
 * @author Administrator
 *
 */
class ServiceitemController extends AdminBaseController {

    /**
     * 内容列表
     * Enter description here ...
     */
    public function index() {
        //设置添加信息按钮
        $this->assign('addbtn', $this->returnAddbtn('发布信息', 'system/Serviceitem/add', 1));
        $data = Db::name('roomservice')->order('id desc')->select();
        $this->assign('data', $data);
        return $this->display('index', true);
    }

    /**
     * 添加操作
     * Enter description here ...
     */
    public function add() {
        if (Request::instance()->isGet()) {
            $this->assign('action', url('system/Serviceitem/add'));
            return $this->display('edit', false);
        } else {
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '标题');
            $item['price'] = $this->post('price', '', RegExpression::MONEY, '价格');
            $item['addtime'] = time();

            $res = Db::name('roomservice')->insert($item);

            $this->log('发布服务：' . $item['title']);
            if ($res !== false) {
                $this->toSuccess('发布成功', 'Serviceitem/index', 2);
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
            $item = Db::name('roomservice')->where('id', Request::instance()->param('id', 0))->find();
            $this->assign('obj', $item);

            $this->assign('action', url('system/Serviceitem/edit'));
            return $this->display('edit', false);
        } else {
            $item['id'] = $this->post('id');
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '标题');
            $item['price'] = $this->post('price', '', RegExpression::MONEY, '价格');
            $res = Db::name('roomservice')->update($item);

            $this->log('修改服务：' . $item['title']);
            if ($res !== false) {
                $this->toSuccess('编辑成功', url('Serviceitem/index'), 2);
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
            $obj = Db::name('roomservice')->where('id', $id)->find();
            $this->log('删除：' . $obj['title']);
            $res = Db::name('roomservice')->delete($id);
        } else {
            //批量删除
            $idarray = explode(',', $idstr);
            foreach ($idarray as $k => $v) {
                if (!(empty($v))) {
                    $obj = Db::name('roomservice')->where('id', $v)->find();
                    $this->log('删除：' . $obj['title']);
                    $res = Db::name('roomservice')->delete($v);
                }
            }
        }
        $this->toSuccess('删除成功');
    }

}
