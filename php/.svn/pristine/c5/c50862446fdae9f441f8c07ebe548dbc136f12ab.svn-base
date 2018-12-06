<?php
namespace app\api\controller;

use app\common\BaseController;
use OSS\Core\OssException;
use OSS\OssClient;
use think\Config;

/**
 * 图片文件类
 * Enter description here ...
 * @author yihong
 *
 */
class UploadController
{
    private $fileName;
    private $filepath;

    /**
     *
     * UploadController constructor.
     * @param string $fileName 保存路径
     * @param string $filepath 源文件
     */
    public function __construct($fileName='',$filepath=''){
        $fileName = input('fileName',$fileName);
        $filepath = input('filepath',$filepath);
        if($fileName){
            if(DEPLOY_ENV == 'pro'){
                $this->fileName =  $fileName; //正式服务器路径
            }else{
                $this->fileName = DEPLOY_ENV.'/'. $fileName;//其他环境上传
            }

        }
        if($filepath){
            $this->filepath = $filepath;
        }
    }

    public function ossUpload(){
        // 尝试执行
        try {
            $config =  Config::get('aliyun_oss');
            //实例化对象 将配置传入
            $ossClient = new OssClient($config['KeyId'], $config['KeySecret'], $config['Endpoint']);
            //这里是有sha1加密 生成文件名 之后连接上后缀
            //执行阿里云上传
            $result = $ossClient->uploadFile($config['Bucket'],  $this->fileName, $this->filepath);
            /*组合返回数据*/
            return json_encode(array('code'=>200,'url'=>Config::get('OSS_HOST').$this->fileName));
        } catch (OssException $e) {
            GLog( 'OSS UPload',$e->getMessage());
            return json_encode( array('code'=>400));
        }

    }

}
