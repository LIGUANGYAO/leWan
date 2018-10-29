<?php
namespace app\api\controller;
use app\common\BaseController;
use think\Config;
use think\Db;

/**
 * 接口父类
 */
class ApiBaseController extends BaseController{

    protected $headerData = [];

    public function __construct(){
        $this->getHeaderData();
        if(Config::get('signswitch')){
           $this->checkSign($this->headerData['sign']);
        }
    }

    /**
     * 获取头部参数
     */
    public function getHeaderData(){
        $allheader = get_all_header();
        if($allheader){
            $this->headerData['sign'] = $allheader['sign'];
            $this->headerData['product'] = $allheader['product']; //wechatjs/app/applet
            $this->headerData['platform'] = $allheader['platform']; //ios/android/other
        }
    }


    /**
     * 接口返回数据
     * @param $msg
     * @param int $status
     * @param array $data
     */
    protected function returnApiData($msg, $status=200, $data=[]){
        $res['info'] = $msg;
        $res['status'] = $status;
        $res['data'] = $data;
        header('content-type:application/json;charset=utf8');
        echo json_encode($res, JSON_UNESCAPED_UNICODE);
        Db::rollback();
        exit;
    }

    /**
     * 生成URL参数
     * @param $arr
     * @return string
     */
    private function getUrlParams($arr)
    {
        $buff = "";
        foreach ($arr as $k => $v) {
            if ($k != "sign" && $v != "" && !is_array($v)) {
                $buff .= $k . "=" . $v . "&";
            }
        }
        $buff = trim($buff, "&");
        return $buff;
    }

    /**
     * 签名算法
     * 1.ksort 对参数升序排
     * 2.对参数拼接成字符串 并+ key
     * 3.md5加密 转化大写
     * 4.再base64加密
     */
    private function makeSignature($args)
    {
        ksort($args);
        $params = $this->getUrlParams($args);
        $stringSignTemp =  $params.'&key='.Config::get('signkey');
        $signature  = strtoupper(md5($stringSignTemp));
        $newSign = base64_encode($signature);
        return $newSign;
    }

    /**
     * 签名校验
     */
    private function checkSign($sign){
        if(count($_POST) == 0){
            $this->returnApiData('签名失败', 400);
        }else{
            $signStr = $this->makeSignature($_POST);
            if($sign != $signStr){
                $this->returnApiData('签名失败', 400);
            }else{
                //return true;
            }
        }
    }


}
