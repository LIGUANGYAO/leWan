<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/10
 * Time: 17:05
 */

namespace app\system\controller;


use app\common\AdminBaseController;
use app\common\model\Levelconst;
use app\common\model\ProcedureModel;
use app\system\model\PaginationModel;
use think\Db;

/**
 * 次月结算 运营奖金+玩主奖金
 * Class FinanceController
 * @package app\system\controller
 */
class SettleaccountsController extends AdminBaseController
{

    public function index(){
        $page = $this->get('page', 1);
        $pagesize = 20;
        $mobile = $this->get('mobile', '');
        $where = [];
        if($mobile != ''){
            $where['u.mobile'] = $mobile;
            $this->assign('mobile', $mobile);
        }
        //查询总记录
        $count = Db::table('view_forJiesuanCiYue a')->join('jay_user u', 'a.user_id = u.user_id', 'left')->where($where)->count();

        $list = Db::table('view_forJiesuanCiYue a')
            ->field('a.*, u.nickname, u.mobile, u.`level`')
            ->where($where)
            ->join('jay_user u', 'a.user_id = u.user_id', 'left')
            ->page($page, $pagesize)
            ->order('a.user_id asc')
            ->select();
        foreach ($list as $k=>$v){
            $list[$k]['level'] = Levelconst::getName($v['level']);
        }
        $return['list'] = $list;
        $return['count'] = $count;
        $pagination = new PaginationModel();
        $return['page'] = $pagination->getPage($count, $page, $pagesize);
        $this->assign('data', $return);
        return $this->display('user', true);
    }


    /**
     * 立即结算
     */
    public function settleall(){
        $count = Db::table('view_forjiesuanciyue')->count();
        if($count == 0){
            $this->ajaxReturn('没有数据待执行！', 0);
        }
        $md = date('d');
        if($md < 22 || $md > 26){
            $this->ajaxReturn('次月结算请在每月22号-25号执行', 0);
        }
        $pm = new ProcedureModel();
        $res = $pm->execute('jiesuan_commissionToCashAllYIjian', '', '@error');
        if($res){
            $this->log("批量结算佣金:[结算人数:".$count."]");
            $this->ajaxReturn('执行成功,结算人次：'.$count.'人', 1);
        }else{
            $this->ajaxReturn('执行失败', 0);
        }
    }

}