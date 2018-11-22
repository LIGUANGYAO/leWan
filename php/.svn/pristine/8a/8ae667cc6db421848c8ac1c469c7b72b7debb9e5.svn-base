<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 17:05
 */

namespace app\system\controller;


use app\common\AdminBaseController;
use app\common\model\MerchantAccountModel;
use app\common\model\MerchantAccountRecordModel;
use app\common\model\Tag;
use app\system\model\ContentModel;
use app\system\model\MerchantModel;
use Think\Db;
use think\Request;

/**
 * 消息推送
 * Class FinanceController
 * @package app\system\controller
 */
class MsgController extends AdminBaseController
{

    public function index(){
        $condition = array();
        $type      = $this->get('type');
        $msguser   = $this->get('user');
        $page      = $this->get('page');//分页默认第一页
        $title     = $this->get('keywrods', '');
        $startTime = strtotime($this->get("starttime"));
        $endTime   = strtotime($this->get("endtime"));
        if ($title){
            $this->assign('keywrods', $title);
            $condition["msg_title"] = array("like","%$title%");
        }
        if($type){
            $this->assign('type', $type);
            $condition['msg_type'] = $type;
        }
        if($msguser){
            $this->assign('user', $msguser);
            $condition['msg_user'] = $msguser;
        }else{
            $condition['msg_user'] = 0;
        }
        $condition = $this->TimeContrast($startTime,$endTime,"msg_addtime",$condition);
        $data = ContentModel::getMsgList($condition,$page);
        $this->assign('data', $data);
        $this->assign('addbtn',  $this->returnAddbtn('发布消息', 'system/msg/info', 2));
        return $this->display('index', true);
    }

    public function info(){
        return $this->display('edit', true);
    }

    public function sub(){
        if(Request::instance()->isPost()){
            $id    = $this->get("id",'');
            if($id){ //消息推送
                $updata['msg_status'] = 2;
                $updata['send_time'] = time();
                $res = Db::name('msg')->where(array('msg_id'=>$id))->update($updata);
                if($res){
                    $this->success('已成功推送');
                }
                $this->error('推送失败');
            }else{
                $data["msg_type"]    = $this->get("type",1);
                $data["msg_user"]    = $this->get("msg_user",0);
                $data["msg_title"]    = $this->get("title");
                $data["msg_content"]    = $this->get("content");
                $data["msg_addtime"]    = time();
                $mid = Db::name('msg')->insertGetId($data);
                if($mid){
                    //$this->sendMsg($data);
                    $this->log('发布推送消息');
                    $this->success('添加成功');
                }else{
                    $this->error('添加失败');
                }
            }
        }
    }

    public function sendMsg($data){
        if(intval($data['msg_user']) === 0){ //推送全员

        }else{ //推送指定用户（APP等）

        }
    }




}