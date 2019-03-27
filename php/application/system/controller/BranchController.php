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
use app\system\model\BannerModel;
/**
 * 分公司管理
 * Enter description here ...
 * @author Administrator
 *
 */
class BranchController extends AdminBaseController
{
    

    /**
     * banner列表
     * Enter description here ...
     */
    public function index(){
        //设置添加信息按钮

        $this->assign('addbtn',  $this->returnAddbtn('添加分公司', 'system/branch/add', 1, '50%', '80%'));
        return $this->display('index', true);
    }
    
    
    /**
     * 添加操作
     * Enter description here ...
     */
    public function add(){
        if (Request::instance()->isGet()){
            $this->assign('action',  url('system/branch/add'));
            $this->assign('provence', $this->getProvenceList(1));

            return $this->display('edit');
        }else{

        }
    }
    
    
    /**
     * 修改
     * Enter description here ...
     */
    public function edit(){

    }
    
    /**
     * 删除账号
     * Enter description here ...
     */
    public function delete(){

    }
    
    
}
