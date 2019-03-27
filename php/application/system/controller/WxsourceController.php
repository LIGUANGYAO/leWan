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
 * 微信素材
 * Enter description here ...
 * @author Administrator
 *
 */
class WxsourceController extends AdminBaseController {

    public function index() {
        //设置添加信息按钮
        $this->assign('addbtn', $this->returnAddbtn('添加图文素材', 'system/wxsource/add', 2));
        $this->assign('addbtn2', $this->returnAddbtn('添加文字素材', 'system/wxsource/addtxt'));

        $datalist = Db::name('wx_sourcegroup')->order('id DESC')->select();
        //加载素材内容
        foreach ($datalist as $k => $v) {
            $datalist[$k]['items'] = Db::name('wx_sourceitems')->field('id, title, pic')->where('groupid=' . $v['id'])->order('id asc')->select();
        }

        $this->assign('datalist', $datalist);
        return $this->display('wx/index_source', true);
    }

    function edit() {
        if (isset($_POST['id'])) {
            $item_dao = Db::name('wx_sourceitems');
            $groupid = intval($_POST['id']);
            $delids = trim($_POST['delids']);
            $delids = explode(',', $delids);
            //删除记录
            foreach ($delids as $k => $v) {
                if ($v > 0) {
                    $entity = $item_dao->find($v);
                    $imgaddr = ROOT_PATH . 'public' . DS . 'uploads' . DS . $entity['pic'];
                    if (file_exists($imgaddr)) {
                        unlink($imgaddr);
                    }
                    $item_dao->delete($v);
                }
            }
            //更新
            foreach ($_POST['title'] as $k => $v) {
                if (trim($v) != '') {
                    $item = array();
                    $item['title'] = $v;
                    $item['groupid'] = $groupid;
                    $item['abstract'] = trim($_POST['abstract'][$k]);
                    $item['pic'] = $_POST['pic'][$k];
                    $item['content'] = $_POST['content'][$k];
                    $item['abstract'] = $this->_getAbs($item['content'], $item['abstract']);
                    $item['url'] = $_POST['url'][$k];
                    $item['type'] = $_POST['type' . ($k + 1)];
                    $item['iscode'] = empty($_POST['iscode' . ($k + 1)]) ? 0 : 1;
                    $item['addtime'] = time();
                    if ($_POST['itemid'][$k] > 0) {
                        //修改
                        $item['id'] = $_POST['itemid'][$k];
                        $entity = $item_dao->find($item['id']);
                        if ($item['pic'] != $entity['pic']) {
                            //删除图片记录
                            $imgaddr = ROOT_PATH . 'public' . DS . 'uploads' . DS . $entity['pic'];
                            if (file_exists($imgaddr)) {
                                unlink($imgaddr);
                            }
                        }
                        $item_dao->update($item);
                    } else {
                        //添加
                        $item_dao->insert($item);
                    }
                }
            }
            $this->toSuccess('修改成功', 'system/wxsource/index');
        } else {
            $id = Request::instance()->param('id');
            $itemlist = Db::name('wx_sourceitems')->where('groupid=' . $id)->order('id asc')->select();
            foreach ($itemlist as $k => $v) {
                $itemlist[$k]['pic'] = '/uploads/' . $v['pic'];
            }
            $len = count($itemlist);
            $temp = array('id' => '', 'title' => '', 'pic' => '/statics/admin/images2/df.png');
            for ($i = $len; $i < 8; $i++) {
                $itemlist[] = $temp;
            }
            //fuck($itemlist);
            $this->assign('itemlist', $itemlist);
            $this->assign('id', $id);
            return $this->display('wx/edit_source', true);
        }
    }

    function add() {
        if (isset($_POST['title'])) {
            // 启动事务
            Db::startTrans();
            $group_dao = Db::name('wx_sourcegroup');
            $item_dao = Db::name('wx_sourceitems');

            //添加消息组
            $group['createtime'] = time();
            $group['msgtype'] = 1;
            $groupid = $group_dao->insertGetId($group);
            foreach ($_POST['title'] as $k => $v) {
                $item = array();
                $item['groupid'] = $groupid;
                if (trim($v) != '') {
                    $item['title'] = $v;
                    $item['abstract'] = trim($_POST['abstract'][$k]);
                    $item['pic'] = $_POST['pic'][$k];
                    $item['content'] = $_POST['content'][$k];
                    $item['abstract'] = $this->_getAbs($item['content'], $item['abstract']);
                    $item['url'] = $_POST['url'][$k];
                    $item['type'] = $_POST['type' . ($k + 1)];
                    $item['iscode'] = empty($_POST['iscode' . ($k + 1)]) ? 0 : 1;
                    $item['addtime'] = time();
                    $item['sort'] = $k;
                    $res = $item_dao->insert($item);
                }
            }
            if ($res != false && $groupid != false) {
                Db::commit();
                $this->toSuccess('添加成功', 'wxsource/index');
            } else {
                Db::rollback();
                $this->toError('添加失败');
            }
        } else {
            return $this->display('wx/add_source', true);
        }
    }

    function addtxt() {
        if (isset($_POST['returnstr'])) {
            $_mod1 = Db::name('wx_sourcegroup');
            $data['returnstr'] = $_POST['returnstr'];
            $data['msgtype'] = 2;
            $data['createtime'] = time();
            $_mod1->insert($data);
            $this->log("添加新素材");
            $this->toSuccess('添加成功', 'wechat/wxsource/index', 2);
        } else {
            $this->assign('act', url('Wxsource/addtxt'));
            return $this->display('wx/addtxt_source');
        }
    }

    function edittxt() {
        if (isset($_POST['returnstr'])) {
            $_mod1 = Db::name('wx_sourcegroup');
            $data['returnstr'] = $_POST['returnstr'];
            $data['msgtype']   = 2;
            $data['id']        = $_POST['id'];

            $PreRevision = $_mod1->where(array("id"=>$data['id']))->find();
            $_mod1->update($data);

            $this->log("编辑素材:[素材ID:".$data['id']."]","wx_sourcegroup",array("id"=>$data['id']),$PreRevision);
            $this->toSuccess('修改成功', 'wechat/wxsource/index', 2);
        } else {
            $_mod = Db::name('wx_sourcegroup');
            $id = Request::instance()->param('id');
            $entity = $_mod->find($id);
            $this->assign('entity', $entity);
            $this->assign('act', url('Wxsource/edittxt'));
            return $this->display('wx/addtxt_source');
        }
    }

    function delete() {
        $id = Request::instance()->param('id');
        $_mod1 = Db::name('wx_sourcegroup');
        $_mod2 = Db::name('wx_sourceitems');
        $group = $_mod1->find($id);
        if ($group['msgtype'] == 2) {
            $_mod1->delete($id);
            $this->log("删除文字素材:[素材ID:".$id."]");
        } else {
            $items = $_mod2->field('id, pic')->where('groupid=' . $id)->order('id asc')->select();
            foreach ($items as $k => $v) {
                if ($v['pic'] != 'df.jpg') {
                    //删除图片
                    $imgurl = ROOT_PATH . 'public' . DS . 'uploads' . DS . $v['pic'];
                    if (file_exists($imgurl)) {
                        unlink($imgurl);
                    }
                }
            }
            $_mod2->delete($v['id']);
            $_mod1->delete($id);
            $this->log("删除图文素材:[素材ID:".$id."]");
        }


        $this->toSuccess('操作成功');
    }

    private function _getAbs($content, $abs = '') {
        $tempc = strip_tags($content);
        if (strlen($abs) > 1) {
            return $abs;
        } else {
            $qian = array(" ", "　", "\t", "\n", "\r");
            $hou = array("", "", "", "", "");
            $tempc = str_replace($qian, $hou, $tempc);
            $tempc = mb_substr($tempc, 0, 100, 'UTF-8') . '...';
            return $tempc;
        }
    }

}

?>