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
 * 微信关键词
 * Enter description here ...
 * @author Administrator
 *
 */
class WxkeyController extends AdminBaseController {

    function index() {
        $this->assign('addbtn', $this->returnAddbtn('添加关键词', 'system/wxkey/add', 2));

        $this->assign('list', Db::name('wx_keywords')->select());
        return $this->display('wx/index_key', true);
    }

    //增加
    function add() {
        if (isset($_POST['key'])) {
            $item['groupid'] = $this->post('groupid', 0);
            $item['key'] = $this->post('key', '', RegExpression::REQUIRED, '关键词');
            $item['addtime'] = SysHelp::getTimeString();
            Db::name('wx_keywords')->insert($item);
            $this->success('添加成功', Url('wxkey/index'));
        } else {
            //加载素材内容
            $datalist = Db::name('wx_sourcegroup')->order('id DESC')->select();
            foreach ($datalist as $k => $v) {
                $datalist[$k]['items'] = Db::name('wx_sourceitems')->field('id, title, pic')->where('groupid=' . $v['id'])->order('id asc')->select();
            }
            $this->assign('datalist', $datalist);

            return $this->display('wx/add_key', true);
        }
    }

    /**
     * 修改
     */
    function edit() {
        if (isset($_POST['key'])) {
            $item['id'] = $this->post('id', 0);
            $item['groupid'] = $this->post('groupid', 0);
            $item['key'] = $this->post('key', '', RegExpression::REQUIRED, '关键词');
            $item['addtime'] = SysHelp::getTimeString();
            Db::name('wx_keywords')->update($item);
            $this->success('编辑成功', Url('wxkey/index'));
        } else {
            $id = $this->get('id', 0);
            $this->assign('info', Db::name('wx_keywords')->find($id));
            //加载素材内容
            $datalist = Db::name('wx_sourcegroup')->order('id DESC')->select();
            foreach ($datalist as $k => $v) {
                $datalist[$k]['items'] = Db::name('wx_sourceitems')->field('id, title, pic')->where('groupid=' . $v['id'])->order('id asc')->select();
            }
            $this->assign('datalist', $datalist);

            return $this->display('wx/edit_key', true);
        }
    }

    /**
     * 删除菜单
     */
    public function delete() {
        $id = Request::instance()->param('id', 0);
        if ($id > 0) {
            $res = Db::name('wx_keywords')->delete($id);
        }else{
            //批量删除
            $idstr = Request::instance()->post('idstr', '');
            $idarray = explode(',', $idstr);
            foreach ($idarray as $k => $v) {
                if (!(empty($v))) {
                    $obj = Db::name('wx_keywords')->where('id', $v)->find();
                    $this->log('删除关键词：' . $obj['id']);
                    $res = Db::name('wx_keywords')->where('id='.$v)->delete();
                }
            }
        }
        $this->toSuccess('删除成功');
    }

}

?>