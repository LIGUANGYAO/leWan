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

use app\system\model\UserModel;

/**
 * 会员管理
 * Enter description here ...
 * @author Administrator
 *
 */
class UserController extends AdminBaseController {

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取用户数据
     * 肖亚子
     */
    public function UserList() {

        $Condition = array();
        $Psize     = $this->get('page', 1);
        $Title     = $this->get("title");//搜索栏数据
        $Level     = $this->get("level",0);//用户等级
        $Auth     = $this->get("auth",0);//用户等级
        $StartTime = strtotime($this->get("starttime"));//提现开始时间
        $EndTime   = strtotime($this->get("endtime"));//提现结束时间

        if ($Title){
            $Condition["u.mobile|u.nickname"] = array("like","%$Title%");
        }
        if ($Level){
            $Condition["u.level"] = array("eq",$Level);
        }
        if ($Auth){
            $Condition["u.auth"] = array("eq",$Auth);
        }

        $Condition = self::TimeContrast($StartTime,$EndTime,"u.reg_time",$Condition);

        $Data      = UserModel::UserList($Condition,$Psize,50);

        $Query     = array("title" => $Title,"level" => $Level,"auth"=>$Auth);
        $Query     = self::Time($StartTime,"starttime",$Query);
        $Query     = self::Time($EndTime,"endtime",$Query);

        $this->assign("query",$Query);
        $this->assign("data",$Data);
        return $this->display('index', true);
    }

    public function UserDet(){
        $Condition = array();

        if (Request()->isGet()){
            $Id = $this->get("id");

            $Condition["user_id"] = array("eq",$Id);

            $UserFind =  UserModel::UserFind($Condition);

            $this->assign("data",$UserFind);
            return $this->display('det', true);
        }


    }


    /**
     * @param $StartTime  开始时间
     * @param $EndTime    结束时间
     * @param $Key        字段
     * @param $Condition  返回组合
     * @return mixed
     */
    public  function TimeContrast($StartTime,$EndTime,$Key,$Condition){

        if (!empty($StartTime) && empty($EndTime)) {
            parent::Tpl_NotGtTime($StartTime,"开始时间不能大于当前时间"); //开始时间不为空和当前时间对比
            $Condition[$Key] = array(array('egt', $StartTime));
        } else if (empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_NotGtTime($EndTime,"结束时间不能大于当前时间"); //结束时间不为空和当前时间对比
            $Condition[$Key] = array(array('lt', $EndTime));
        } else if (!empty($StartTime) && !empty($EndTime)) {
            parent::Tpl_TimeContrast1($StartTime,$EndTime); //开始和结束时间都不为空进行判断
            $Condition[$Key] = array(array('egt', $StartTime), array('elt', $EndTime));
        }

        return $Condition;
    }

    /**
     * @param $Time  转换时间
     * @param $Key   返回字段
     * @param $Query 组合数组
     * @return mixed
     */
    public function Time($Time,$Key,$Query){
        if(!empty($Time)){
            $Query[$Key] = date("Y-m-d H:i:s",$Time);
        }

        return $Query;
    }

    /**
     * 删除账号
     * Enter description here ...
     */
    public function delete() {


        $id = Request::instance()->param('id', 0);

        $idstr = Request::instance()->post('idstr', '');

        if ($id > 0) {
            $obj = Db::name('member')->where('id', $id)->find();
            $this->log('删除会员：' . $obj['nickname']);
            $res = Db::name('member')->delete($id);
        } else {
            //批量删除
            $idarray = explode(',', $idstr);
            foreach ($idarray as $k => $v) {
                if (!(empty($v))) {
                    $obj = Db::name('member')->where('id', $v)->find();
                    $this->log('删除会员：' . $obj['nickname']);
                    $res = Db::name('member')->delete($v);
                }
            }
        }
        $this->toError("删除失败");

        $this->toSuccess('删除成功');
    }

}
