<?php 
namespace app\common;


/**
 * 系统生成唯一随机码工具类
 * Enter description here ...
 * @author Administrator
 *
 */
class Md5Help{
    

    /**
     * 系统密码加密函数
     * 
     * @param string $password 用户输入的密码
     * @param string $dllkey  动态码
     * @return string 生成最终密码串 
     */
    public static function getMd5Pwd($password,   $dllkey){
        $position = ord(substr($dllkey,0,1));
        $position1 = $position % 32;
        
        $tmp = "";
        if($position1 == 0){
            $tmp = $password . $dllkey;
        }else{
            //$tmp = $dellkey.substring(0, $position1) + $org + $dellkey.substring($position1, 32);
            $tmp = substr($dllkey,0,$position1).$password.substr($dllkey,$position1,strlen($dllkey));
        }
        return Md5Help::getMD5($tmp);
    }
    
    /**
     * 获取动态码
     * Enter description here ...
     */
    public static function getDllKey(){
        return md5(time().'%j!f$n&a*l!p@h.p^'.date('YmdHis'));
    }
    
    private static function getMD5($message) {
        $res = Md5Help::getMD52($message,"sha-1");
        return $res;
    }
    
    private static function getMD52($message, $MessageDigestType) {
        //将message转为asicc数组
        $arr1 = array();
        for($i = 0; $i < strlen($message); $i++){
            array_push($arr1, ord(substr($message,$i,1)));
        }
        return sha1($message);
    }
    
    
    
    /**
     * 生成订单号
     * 生成系统唯一订单号。规则=年月日时分秒+3位随机+毫秒数
     */
    public static function getOrderNo(){
        //生成毫秒数
        list($usec, $sec) = explode(" ", microtime());  
        $micsec = (int)($usec*1000);
        return date('ymdhis').rand(100,999).$micsec;
    }


    public static function getToken($str){
        return md5($str.'jay@！23232');
    }
    
}
?>