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
 * 内容管理
 * Enter description here ...
 * @author Administrator
 *
 */
class YueController extends AdminBaseController {

    //生活汇id
    private $section = 2;

    /**
     * 内容列表
     * Enter description here ...
     */
    public function index() {
        //设置添加信息按钮
        $this->assign('addbtn', $this->returnAddbtn('发布信息', 'system/yue/add', 2));

        $cm = new ContentModel();
        //类型
        $this->assign('parents', $cm->getCatesById($this->section));

        //获取参数
        $pn = $this->get('page', 1);
        $kws = $this->get('kws', '');
        $cat_id = $this->get('cat_id', 0);
        $starttime = $this->get('starttime', '');
        $endtime = $this->get('endtime', '');
        //组合where
        if ($kws != '') {
            $where['a.title'] = array('like', '%' . $kws . '%');
            $this->assign('kws', $kws);
        }
        if ($cat_id > 0) {
            $where['a.cat_id'] = $cat_id;
            $this->assign('cat_id', $cat_id);
        } else {
            $where['a.section'] = $this->section;
        }
        if ($starttime != '') {
            $where['a.addtime'] = array('egt', $starttime);
            $this->assign('starttime', $starttime);
        }
        if ($endtime != '') {
            $where['a.addtime'] = array('elt', $endtime);
            $this->assign('endtime', $endtime);
        }

        //获取分页列表数据
        $data = $cm->getContentList($where, $pn);

        $this->assign('data', $data);
        return $this->display('index', true);
    }

    /**
     * 添加操作
     * Enter description here ...
     */
    public function add() {
        if (Request::instance()->isGet()) {
            $this->assign('action', url('system/yue/add'));
            return $this->display('edit', true);
        } else {
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '标题');
            $item['section'] = $this->section;
            $item['content'] = $this->post('content', '', RegExpression::REQUIRED, '内容');
            $item['pic'] = $this->post('pic', '');
            $item['add_time'] = time();

            $res = Db::name('content')->insert($item);

            $this->log('发布生活汇：' . $item['title']);
            if ($res !== false) {
                $this->toSuccess('发布成功', 'yue/index');
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
            $item = Db::name('content')->where('id', Request::instance()->param('id', 0))->find();
            $this->assign('obj', $item);

            $this->assign('action', url('system/yue/edit'));
            return $this->display('edit', true);
        } else {
            $item['title'] = $this->post('title', '', RegExpression::REQUIRED, '标题');
            $item['section'] = $this->section;
            $item['content'] = $this->post('content', '', RegExpression::REQUIRED, '内容');
            $item['id'] = $this->post('id', 0);
            $pic = $this->post('pic', '');
            if($pic){
                $item['pic'] = $pic;
            }
            $res = Db::name('content')->update($item);

            $this->log('修改生活汇：' . $item['title']);
            if ($res !== false) {
                $this->toSuccess('编辑成功', url('yue/index'));
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
            $obj = Db::name('content')->where('id', $id)->find();
            $this->log('删除：' . $obj['title']);
            $this->deletefile('uploads', $obj['pic']);
            $res = Db::name('content')->delete($id);
        } else {
            //批量删除
            $idarray = explode(',', $idstr);
            foreach ($idarray as $k => $v) {
                if (!(empty($v))) {
                    $obj = Db::name('content')->where('id', $v)->find();
                    $this->log('删除：' . $obj['title']);
                    $this->deletefile('uploads', $obj['pic']);
                    $res = Db::name('content')->delete($v);
                }
            }
        }
        $this->toSuccess('删除成功');
    }

}
