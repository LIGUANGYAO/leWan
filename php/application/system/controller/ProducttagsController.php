<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/12/18
 * Time: 15:46
 * 商品标签控制器
 * 肖亚子
 */

namespace app\system\controller;

use app\common\AdminBaseController;
use app\system\model\ProducttagsModel;

class ProducttagsController extends AdminBaseController{

    /**
     * @return string
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * 获取全部商品标签
     */
    public function TagsList(){

        $Data = ProducttagsModel::TagsLists();
        $this->assign("data",$Data);
        return $this->display('list', true);
    }

    /**
     * @return string
     * @throws \think\Exception
     * @throws \think\exception\PDOException
     * 商品标签(添加/修改)
     * 肖亚子
     */
    public function TagsDet(){
        if (request()->isGet()){
            $Id = $this->get("id");

            if ($Id){
                $Data = ProducttagsModel::TagsFind($Id);
                $this->assign("data",$Data);
            }

            return $this->display('det', false);
        }else{
            $Id       = $this->post("id");
            $Tag_Name = $this->post("tag_name");

            parent::Tpl_Empty($Tag_Name,"请输入标签名");
            parent::Tpl_FullSpace($Tag_Name,"请输入标签名");

            $Data["tag_name"]    = $Tag_Name;
            $Data["tag_addtime"] = time();

            if ($Id){
                $PreRevision = ProducttagsModel::TagsFind($Id);
                $Tags        = ProducttagsModel::TagsUp($Id,$Data);
            }else{
                $Tags = ProducttagsModel::TagsAdd($Data);
            }

            if ($Tags){
                if ($Id){
                    $this->log("编辑标签:[ID:".$Id."]","product_tags",array("tag_id"=>$Id),$PreRevision);
                }else{
                    $this->log("添加新标签");
                }

                $this->toSuccess('编辑成功', '', 2);
            }else{
                $this->toError("编辑失败");
            }

        }

    }

}