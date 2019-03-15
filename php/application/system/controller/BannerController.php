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
 * banner模块
 * Enter description here ...
 * @author Administrator
 *
 */
class BannerController extends AdminBaseController
{
    
    private $pages = [
        1=>'首页',
        2=>'商品分类',
        3=>'全国',
    ];
    
    /**
     * banner列表
     * Enter description here ...
     */
    public function index(){
        //设置添加信息按钮
        $this->assign('addbtn',  $this->returnAddbtn('添加banner', 'system/banner/add', 1, '50%', '80%'));

        $Condition  = array();
        $Psize      = $this->get("page", 1);
        $Type       = $this->get("type", 0);
        $CategoryId = $this->get("category", 0);
        $Provence   = $this->get("provence_id", 0);
        $City       = $this->get("city_id", 0);

        //获取参数

        if($Type){
            $Condition["b.type"] = $Type;
        }
        if($CategoryId){
            $Condition["b.cat_id"] = $CategoryId;
        }
        if($Provence){
            $Condition["b.provence"] = $Provence;
        }
        if($City){
            $Condition["b.city"] = $City;
        }

        $List = BannerModel::BannerList($Condition,$Psize,50);
        $Category = BannerModel::CategoryList();

        foreach ($List["list"] as $Key=>$Val){
            $List["list"][$Key]['type'] = $this->pages[$Val['type']];
        }

        $Query = array("type"=>$Type,"cat_id"=>$CategoryId,"provence"=>$Provence,"city"=>$City);

        $this->assign('query', $Query);
        $this->assign('category', $Category);
        $this->assign('provence', $this->getProvenceList(1));
        $this->assign('city', $this->getCityList($Provence,1));
        $this->assign('parents', $this->pages);
        $this->assign('data', $List);
        return $this->display('index', true);
    }
    
    
    /**
     * 添加操作
     * Enter description here ...
     */
    public function add(){

        if (Request::instance()->isGet()){

            $Category = BannerModel::CategoryList();

            $this->assign('parents', $this->pages);
            $this->assign('provence', $this->getProvenceList(1));
            $this->assign('category', $Category);
            $this->assign('action',  url('system/banner/add'));

            return $this->display('edit');

        }else{
            $Item['alt']      = $this->post('alt', '', RegExpression::REQUIRED, '图片描述');
            $Item['sort']     = intval($this->post('sort', 1));
            $Item['jump']     = intval($this->post('jump', 2));
            $Item['position'] = intval($this->post('position', 0));
            $Item['pr_id']    = intval($this->post('pr_id', 0));
            $Item['route']    = $this->post('route', '');
            $Item['type']     = $this->post('type', '');
            $Item['pic']      = $this->post('pic', '');
            $Item['provence'] = $this->post('provence_id', 0);
            $Item['city']     = $this->post('city_id', 0);
            $Item['cat_id']   = $this->post('category', 0);
            $Item['addtime']  = time();

            parent::Tpl_StringLength($Item['alt'],"描述最少2字最多15字",3,2,15);

            if ($Item['jump'] == 1){
                parent::Tpl_Empty($Item['position'],"请选择跳转位置");
                parent::Tpl_Empty($Item['type'],"请选择跳转banner位置");

                if ($Item['position'] == 1){
                    parent::Tpl_Empty($Item['pr_id'],"请选择跳转的商品ID");
                }elseif ($Item['position'] == 2){
                    parent::Tpl_Empty($Item['route'],"请输入跳转链接");

                    if (!filter_var($Item["route"], FILTER_VALIDATE_URL)){
                        $this->toError('请输入外部跳转url');
                    }
                }elseif ($Item['position'] == 3){
                    parent::Tpl_Empty($Item['cat_id'],"请选择跳转商品类型");
                }
            }

            if ($Item['type'] != 3){
                parent::Tpl_Empty($Item['provence'],"请选择banner城市");
                parent::Tpl_Empty($Item['city'],"请选择banner城市");
            }

            $Add = BannerModel::BannerAdd($Item);
            
            //删除图片
            $this->deleteUploaded('uploads', $Item['pic']);
            $this->log('添加banner：'.$Item['alt']);

            if($Add){
                $this->toSuccess('添加成功', '', 2);
            }else{
                $this->toError('添加失败');
            }
        }
    }
    
    
    /**
     * 修改
     * Enter description here ...
     */
    public function edit(){
        if (Request::instance()->isGet()){

            $Id = $this->get("id");

            $Item     = BannerModel::BannerFind(array("id"=>$Id));
            $Category = BannerModel::CategoryList();

            $this->assign('obj', $Item);
            $this->assign('parents', $this->pages);
            $this->assign('provence', $this->getProvenceList(1));
            $this->assign('city', $this->getCityList($Item["provence"],1));
            $this->assign('category', $Category);
            $this->assign('action',  url('system/banner/edit'));

            return $this->display();
        }else{
            $Id       = $this->post('id', 0);

            $Item['alt']      = $this->post('alt', '', RegExpression::REQUIRED, '图片描述');
            $Item['sort']     = intval($this->post('sort', 1));
            $Item['jump']     = intval($this->post('jump', 2));
            $Item['position'] = intval($this->post('position', 0));
            $Item['pr_id']    = intval($this->post('pr_id', 0));
            $Item['route']    = $this->post('route', '');
            $Item['type']     = $this->post('type', '');
            $Pic              = $this->post('pic', '');
            $Item['provence'] = $this->post('provence_id', 0);
            $Item['city']     = $this->post('city_id', 0);
            $Item['cat_id']   = $this->post('category', 0);
            $Item['addtime']  = time();

            parent::Tpl_StringLength($Item['alt'],"描述最少2字最多15字",3,2,15);

            if ($Item['jump'] == 1){
                    parent::Tpl_Empty($Item['position'],"请选择跳转位置");
                if ($Item['position'] == 1){
                    parent::Tpl_Empty($Item['pr_id'],"请输入商品ID");
                }elseif ($Item['position'] == 2){
                    parent::Tpl_Empty($Item['route'],"请输入跳转链接");

                    if (!filter_var($Item["route"], FILTER_VALIDATE_URL)){
                        $this->toError('请输入外部跳转url');
                    }
                }else{
                    parent::Tpl_Email($Item['cat_id'],"请选择跳转商品类型");
                }
            }

            if ($Item['type'] != 3) {
                parent::Tpl_Empty($Item['provence'], "请选择banner城市");
                parent::Tpl_Empty($Item['city'], "请选择banner城市");
            }
            if ($Item['type'] == 2){
                parent::Tpl_Empty($Item['cat_id'],"请选择商品分类");
            }
            if($Pic){
                $Item['pic'] = $Pic;
            }

            $BannerUp = BannerModel::BannerUpdate(array("id"=>$Id),$Item);

            //删除图片
            $this->deleteUploaded('uploads', $Item['pic']);
            $this->log('修改banner：'.$Item['alt']);

            if($BannerUp){
                $this->toSuccess('编辑成功', '', 2);
            }else{
                $this->toError('编辑失败');
            }
        }
    }
    
    /**
     * 删除账号
     * Enter description here ...
     */
    public function delete(){
        $id = Request::instance()->param('id', 0);
        $this->log('删除banner：'.Db::name('banner')->where('id', $id)->value('alt'));
        $res = Db::name('banner')->delete($id);
        if($res !== false){
            $this->toSuccess('删除成功');
        }else{
            $this->toError('删除失败');
        }
    }
    
    
}
