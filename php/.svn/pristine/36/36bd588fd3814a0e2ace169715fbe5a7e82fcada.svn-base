<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/6
 * Time: 17:47
 * 收入api接口
 * 肖亚子
 */
namespace app\api\controller;
use app\api\model\UserModel;
use app\api\model\AccountcashModel;
use Think\Exception;


class AccountcashController extends ApiBaseController{

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取用户收入明细
     * 肖亚子
     */

    public function UserAccountCashList(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Time  = input("post.time","","htmlspecialchars,strip_tags");//推荐码
            $Page  = intval(input("post.page","1"));

            $Punfu = new PubfunController();
            $Punfu->UserLoginStatus($Token,$this->headerData);//用户判断
            $Punfu->UserLevelPower($Token);//用户权限验证

            $Uid = UserModel::UserFindUid($Token);

            if ($Time){
                $Month = date("Ym",$Time);
            }else{
                $Month = date("Ym",time());
            }

            $Condition["ca.user_id"]       = array("eq",$Uid);
            $Condition[]                   = array("exp","ca.record_action = 802 or ca.record_action = 803");
            $Condition["ca.record_status"] = array("eq",2);

            $Data = AccountcashModel::AccountcashList($Condition,$Month,$Page,20);

            $this->returnApiData("获取成功", 200,$Data);

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

}
