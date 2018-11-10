<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/9
 * Time: 14:48
 * 实名认证接口
 * 肖亚子
 */

namespace app\api\controller;
use think\Request;
use think\Config;
use Think\Exception;
use app\api\model\UserauthModel;
use app\api\model\UserModel;

class UserauthController extends ApiBaseController{

    /**
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取实名认证信息
     */
    public function UserAuthData(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token,$this->headerData);//权限判断

            $Uid      = UserModel::UserFindUid($Token);
            $AuthData = UserauthModel::UserAuthFinds($Uid);

            if ($AuthData){
                $this->returnApiData("获取成功", 200,$AuthData);
            }else{
                $this->returnApiData("请先进行实名认证", 400);
            }
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 用户进行实名认证申请
     * 肖亚子
     */
    public function UserAuthenticate(){
        try{
            $Token    = input("post.token","","htmlspecialchars,strip_tags");
            $AuthId   = intval(input("post.authid"));
            $Truename = input("post.truename","","htmlspecialchars,strip_tags");
            $Cardno   = input("post.cardno","","htmlspecialchars,strip_tags");
            $Positive = input("file.positive");
            $Opposite = input("file.opposite");

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token,$this->headerData);//权限判断

            parent::Tpl_Empty($Truename,"请输入真实姓名",2);
            parent::Tpl_FullSpace($Truename,"请输入真实姓名",2);
            parent::Tpl_StringLength($Truename,"姓名2-6位",3,2,6,2);
            parent::Tpl_Empty($Cardno,"请输入身份证号",2);
            parent::Tpl_IdCard($Cardno,2);
            parent::Tpl_Empty($Positive,"请上传身份证正面照",2);
            parent::Tpl_Empty($Opposite,"请上传身份证背面照",2);

            $Positive = $Positive->move(ROOT_PATH.'uploads/idcard'.DS);
            $Opposite = $Opposite->move(ROOT_PATH.'uploads/idcard'.DS);

            $Positive = Config::get('picture')."idcard/".str_replace("\\", "/",$Positive->getSaveName());
            $Opposite = Config::get('picture')."idcard/".str_replace("\\", "/",$Opposite->getSaveName());

            $Uid      = UserModel::UserFindUid($Token);
            $AuthFind = UserauthModel::UserAuthFinds($Uid);

            if (!$AuthId){
                if ($AuthFind){
                    $this->returnApiData("你已进行实名认证提交", 400);
                }
            }else{
                if ($AuthFind["status"] == 0){
                    $this->returnApiData("实名认证正在审核中,请耐心等待", 400);
                }elseif ($AuthFind["status"] == 2){
                    $this->returnApiData("实名认证已通过,请勿重复提交", 400);
                }
            }

            $Data["truename"] = $Truename;
            $Data["cardno"]   = $Cardno;
            $Data["card1"]    = $Positive;
            $Data["card2"]    = $Opposite;
            $Data["status"]   = 0;

            if ($AuthId){
                $AuthData = UserauthModel::UserAuthUpdate($Uid,$Data);
            }else{
                $Data["user_id"]  = $Uid;
                $Data["addtime"]  = time();
                $AuthData = UserauthModel::UserAuthAdd($Data);
            }

            if ($AuthData){
                $this->returnApiData("实名认证提交成功,请等待", 200);
            }else{
                $this->returnApiData("实名认证提交失败,请重新提交", 400);
            }
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

}