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
use think\Db;
use Think\Exception;
use app\common\model\CurrencyAction;


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

            $Condition["user_id"]       = array("eq",$Uid);
//            $Condition[]                   = array("exp","ca.record_action = 802 or ca.record_action = 803");
            $Condition["record_status"] = array("eq",2);

            $Data = AccountcashModel::AccountcashList($Condition,$Month,$Page,20);

            if ($Data){
                foreach ($Data as $Key => $Val){
                    $Data[$Key]["action"] = CurrencyAction::getLabel($Val["action"]);
                }
            }

            $this->returnApiData("获取成功", 200,$Data);

        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }
    }

    /**
     * @throws Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\DbException
     * @throws \think\exception\PDOException
     * 获取用户佣金明细
     * 肖亚子
     */
    public function UserAccountCommissionhList(){
        try{
            $Token = input("post.token","","htmlspecialchars,strip_tags");
            $Time  = input("post.time","","htmlspecialchars,strip_tags");//日期
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

            $Condition["user_id"]       = array("eq",$Uid);
            $Condition["record_action"] = array("not in", '651,652');
            //$Condition["record_status"] = array("eq",2);

            $Data = AccountcashModel::AaccountCommissionList($Condition,$Month,$Page,20);

            if ($Data){
                $temporder = [];
                foreach ($Data as $Key => $Val){
                    $Data[$Key]["type"] = 1;
                    if (in_array($Val["action"],array(601,602,603))){
                        $Val["action"] = CurrencyAction::getLabel($Val["action"]);
                        $Val["type"] = 2;
                        $attr = json_decode($Val['record_attach'], true);
                        if($temporder['order_no'] != $attr['orderNo']){
                            $order = Db::name('order o')
                                ->field('p.product_name,p.num,o.order_fullname,o.order_mobile')
                                ->join('jay_order_product p', 'p.order_id=o.order_id','left')
                                ->where(['o.order_no'=>$attr['orderNo']])->find();
                            $order['order_mobile'] = substr($order['order_mobile'],0,3).'****'.substr($order['order_mobile'],7,4);
                            $temporder = $order;
                        }
                        $Data[$Key] = array_merge($Val, $temporder);
                    }else{
                        $Data[$Key]["action"] = CurrencyAction::getLabel($Val["action"]);
                    }
                }
            }

            $this->returnApiData("获取成功", 200,$Data);
        }catch (Exception $e){
            parent::Tpl_Abnormal($e->getMessage());
        }

    }

}
