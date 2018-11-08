<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * Date: 2018/11/7
 * Time: 10:56
 */

namespace app\api\behavior;
use think\Request;
use think\Response;

class CORS
{

    public function appInit(&$request, \Closure $next)
    {



//        if (request()->isOptions()) {
//            self::returnApiData("获取成功", 200,4546);
//            header('Access-Control-Allow-Origin:*');
//            header('Access-Control-Allow-Headers:Accept,Referer,Host,Keep-Alive,User-Agent,X-Requested-With,Cache-Control,Content-Type,Cookie,token');
//            header('Access-Control-Allow-Credentials:true');
//            header('Access-Control-Allow-Methods:GET,POST,OPTIONS');
//            header('Access-Control-Max-Age:1728000');
//            header('Content-Type:text/plain charset=UTF-8');
//            header('Content-Length: 0', true);
//            header('status: 204');
//            header('HTTP/1.0 204 No Content');
//        }else{
//            self::returnApiData("获取成功", 200,12311);
//            header('Access-Control-Allow-Origin:*');
//            header('Access-Control-Allow-Headers:Accept,Referer,Host,Keep-Alive,User-Agent,X-Requested-With,Cache-Control,Content-Type,Cookie,token');
//            header('Access-Control-Allow-Credentials:true');
//            header('Access-Control-Allow-Methods:GET,POST,OPTIONS');
//        }

//        header('Access-Control-Allow-Origin: *');
//        header("Access-Control-Allow-Headers: token,Origin, X-Requested-With, Content-Type, Accept");
//        header('Access-Control-Allow-Methods: POST,GET');

        header('Access-Control-Allow-Origin: *' );
        header('Access-Control-Expose-Headers: Sekey, Authorization');
        header('Access-Control-Allow-Headers: Cookie, X-Requested-With, Content-Type, Origin, Accept, Authorization');
        header('Access-Control-Allow-Methods: HEAD, POST, GET, PUT, OPTIONS');

        if($request->isOptions()){
            return json(200, 200);
        }
        return $next($request);
    }
}