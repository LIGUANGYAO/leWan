<?php
namespace app\common;

/**
 *  基本图片处理，用于完成图片缩入，水印添加
 *  当水印图超过目标图片尺寸时，水印图能自动适应目标图片而缩小
 *  水印图可以设置跟背景的合并度
 */
class ImageCut
{
    //图片格式
    private $exts = array ('jpg', 'jpeg', 'gif', 'bmp', 'png' );

    /**
     *
     *
     * @throws Exception
     */
    public function __construct()
    {
        if (! function_exists ( 'gd_info' ))
        {
            throw new Exception ( '加载GD库失败！' );
        }
    }

    /**
     *
     * 裁剪压缩
     * @param $src_img 图片
     * @param $save_img 生成后的图片
     * @param $option 参数选项，包括： $maxwidth  宽  $maxheight 高
     * array('width'=>xx,'height'=>xxx)
     * @internal
     * 我们一般的压缩图片方法，在图片过长或过宽时生成的图片
     * 都会被“压扁”，针对这个应采用先裁剪后按比例压缩的方法
     */
    public function thumb_img($src_img, $save_img = '', $option)
    {

        if (empty ( $option ['width'] ) or empty ( $option ['height'] ))
        {
            return array ('flag' => False, 'msg' => '原图长度与宽度不能小于0' );
        }
        $org_ext = $this->is_img ( $src_img );
        if (! $org_ext ['flag'])
        {
            return $org_ext;
        }

        //如果有保存路径，则确定路径是否正确
        if (! empty ( $save_img ))
        {
            $f = $this->check_dir ( $save_img );
            if (! $f ['flag'])
            {
                return $f;
            }
        }

        //获取出相应的方法
        $org_funcs = $this->get_img_funcs ( $org_ext ['msg'] );

        //获取原大小
        $source = $org_funcs ['create_func'] ( $src_img );
        $src_w = imagesx ( $source );
        $src_h = imagesy ( $source );

        //调整原始图像(保持图片原形状裁剪图像)
        $dst_scale = $option ['height'] / $option ['width']; //目标图像长宽比
        $src_scale = $src_h / $src_w; // 原图长宽比
        if ($src_scale >= $dst_scale)
        { // 过高
            $w = intval ( $src_w );
            $h = intval ( $dst_scale * $w );

            $x = 0;
            $y = ($src_h - $h) / 3;
        } else
        { // 过宽
            $h = intval ( $src_h );
            $w = intval ( $h / $dst_scale );

            $x = ($src_w - $w) / 2;
            $y = 0;
        }
        // 剪裁
        $croped = imagecreatetruecolor ( $w, $h );
        imagecopy ( $croped, $source, 0, 0, $x, $y, $src_w, $src_h );
        // 缩放
        $scale = $option ['width'] / $w;
        $target = imagecreatetruecolor ( $option ['width'], $option ['height'] );
        $final_w = intval ( $w * $scale );
        $final_h = intval ( $h * $scale );
        imagecopyresampled ( $target, $croped, 0, 0, 0, 0, $final_w, $final_h, $w, $h );
        imagedestroy ( $croped );

        //输出(保存)图片
        if (! empty ( $save_img ))
        {

            $org_funcs ['save_func'] ( $target, $save_img );
        } else
        {
            header ( $org_funcs ['header'] );
            $org_funcs ['save_func'] ( $target );
        }
        imagedestroy ( $target );
        return array ('flag' => True, 'msg' => '' );
    }

    /*
     *图片裁剪为固定大小
     * @param $source_path 源文件
     * @param $target_width 裁剪成的宽度
     * @param $target_height 裁剪成的高度
     * @param $newName 生成图片名没有则替换原图
     * */
    public function imagecropper($source_path, $target_width, $target_height,$newName=null){


        $source_info = getimagesize($source_path);
        $source_width = $source_info[0];
        $source_height = $source_info[1];
        $source_mime = $source_info['mime'];
        $source_ratio = $source_height / $source_width;
        $target_ratio = $target_height / $target_width;
        // 源图过高
        if ($source_ratio > $target_ratio){
            $cropped_width = $source_width;
            $cropped_height =intval($source_width * $target_ratio);
            $source_x = 0;
            $source_y = ($source_height - $cropped_height) / 2;
        }elseif ($source_ratio < $target_ratio){ // 源图过宽
            $cropped_width =intval( $source_height / $target_ratio);
            $cropped_height = $source_height;
            $source_x =intval( ($source_width - $cropped_width) / 2);
            $source_y = 0;
        }else{ // 源图适中
            $cropped_width = $source_width;
            $cropped_height = $source_height;
            $source_x = 0;
            $source_y = 0;
        }
        switch ($source_mime){
            case 'image/gif':
                $source_image = imagecreatefromgif($source_path);
                break;
            case 'image/jpeg':
                $source_image = imagecreatefromjpeg($source_path);
                break;
            case 'image/png':
                $source_image = imagecreatefrompng($source_path);
                break;
            default:
                return false;
                break;
        }

        $target_image = imagecreatetruecolor($target_width, $target_height);
        $cropped_image = imagecreatetruecolor($cropped_width, $cropped_height);
        // 裁剪
        imagecopy($cropped_image, $source_image, 0, 0, $source_x, $source_y, $cropped_width, $cropped_height);
        // 缩放
        imagecopyresampled($target_image, $cropped_image, 0, 0, 0, 0, $target_width, $target_height, $cropped_width, $cropped_height);
        $dotpos = strrpos($source_path, '.');
        $imgName = substr($source_path, 0, $dotpos);
        $suffix = substr($source_path, $dotpos);
        if (is_null($newName)) {
            $imgNew = $imgName . $suffix;
        } else {
            $imgNew = $imgName .'-'.$newName. $suffix;
        }

        header('Content-Type: image/jpeg');
        imagejpeg($target_image, $imgNew, 95);

        imagedestroy($source_image);
        imagedestroy($target_image);
        imagedestroy($cropped_image);
        $this->img_water_mark($imgNew,'www/images/mark.png');
    }


    /**
     * 图片缩放函数（可设置高度固定，宽度固定或者最大宽高，支持gif/jpg/png三种类型）
     * Author : Specs
     * Homepage: http://9iphp.com
     * myImageResize($filename, 200, 200); //最大宽高
     * myImageResize($filename, 200, 200, 'width'); //宽度固定
     * myImageResize($filename, 200, 200, 'height'); //高度固定
     * @param string $source_path 源图片
     * @param int $target_width 目标宽度
     * @param int $target_height 目标高度
     * @param string $fixed_orig 锁定宽高（可选参数 width、height或者空值）
     * @return string
     */
    public  function myImageResize($source_path, $target_width = 200, $target_height = 200,$newName=null, $fixed_orig = 'width')
    {
        $source_info = getimagesize($source_path);
        $source_width = $source_info[0];
        $source_height = $source_info[1];
        $source_mime = $source_info['mime'];


        /*if ($source_width > $target_width && $source_height > $target_height) {//宽高
            if ($source_width > $source_height) {
                $fixed_orig = 'height';
            } else {
                $fixed_orig = 'width';
            }
        } elseif ($source_width > $target_width && $source_height == $target_height) {
            $fixed_orig = 'height';
        } elseif ($source_width > $target_width && $source_height < $target_height) {
            $fixed_orig = 'height';
        } elseif ($source_width == $target_width && $source_height > $target_height) {
            $fixed_orig = 'width';
        } elseif ($source_width == $target_width && $source_height == $target_height) {
            $fixed_orig = 'width';
        } elseif ($source_width == $target_width && $source_height < $target_height) {
            $fixed_orig = 'height';
        } elseif ($source_width < $target_width && $source_height > $target_height) {
            $fixed_orig = 'width';
        } elseif ($source_width < $target_width && $source_height == $target_height) {
            $fixed_orig = 'width';
        } elseif ($source_width < $target_width && $source_height < $target_height) {
            if ($source_width > $source_height) {
                $fixed_orig = 'width';
            } else {
                $fixed_orig = 'height';
            }
        }*/

        $ratio_orig = $source_width / $source_height;
        if ($fixed_orig == 'width') {
            //宽度固定
            $target_height = $target_width / $ratio_orig;
        } elseif ($fixed_orig == 'height') {
            //高度固定
            $target_width = $target_height * $ratio_orig;
        } else {
            //最大宽或最大高
            if ($target_width / $target_height > $ratio_orig) {
                $target_width = $target_height * $ratio_orig;
            } else {
                $target_height = $target_width / $ratio_orig;
            }
        }
        switch ($source_mime) {
            case 'image/gif':
                $source_image = imagecreatefromgif($source_path);
                break;

            case 'image/jpeg':
                $source_image = imagecreatefromjpeg($source_path);
                break;

            case 'image/png':
                $source_image = imagecreatefrompng($source_path);
                break;

            default:
                return false;
                break;
        }
        $target_image = imagecreatetruecolor($target_width, $target_height);
        imagecopyresampled($target_image, $source_image, 0, 0, 0, 0, $target_width, $target_height, $source_width, $source_height);

        $imgArr = explode('.', $source_path);
        if (is_null($newName)) {
            $target_path = $imgArr[0] . '.' . $imgArr[1];//替换原图
        } else {
            $target_path = $imgArr[0] . '-'.$newName.'.' . $imgArr[1];//替换原图
        }

        imagejpeg($target_image, $target_path, 95);

        $this->img_water_mark($target_path,'www/images/mark45.png');


    }


    /**
     * * 图片加水印（适用于png/jpg/gif格式）
     *
     * @author flynetcn
     *
     * @param $srcImg  原图片
     * @param $waterImg 水印图片
     * @param $positon  水印位置
     *          1:顶部居左, 2:顶部居右, 3:居中, 4:底部局左, 5:底部居右
     * @param $alpha   透明度 -- 0:完全透明, 100:完全不透明
     *
     * @param $src   保存到其他路径
     *
     * @return 成功 -- 加水印后的新图片地址
     *   失败 -- -1:原文件不存在, -2:水印图片不存在, -3:原文件图像对象建立失败
     *       -4:水印文件图像对象建立失败 -5:加水印后的新图片保存失败
     */
    function img_water_mark($srcImg, $waterImg, $positon=5, $alpha=50,$src=null)
    {

        $dotpos = strrpos($srcImg, '.');
        $imgName = substr($srcImg, 0, $dotpos);
        $suffix = substr($srcImg, $dotpos);
        if($src){
            $savefile = $src;
        }else{
            $savefile = $imgName.$suffix;
        }
        $srcinfo = @getimagesize($srcImg);
        if (!$srcinfo) {
            return -1; //原文件不存在
        }
        $waterinfo = @getimagesize($waterImg);
        if (!$waterinfo) {
            return -2; //水印图片不存在
        }
        $srcImgObj = $this->image_create_from_ext($srcImg);
        if (!$srcImgObj) {
            return -3; //原文件图像对象建立失败
        }
        $waterImgObj = $this->image_create_from_ext($waterImg);
        if (!$waterImgObj) {
            return -4; //水印文件图像对象建立失败
        }
        switch ($positon) {
            //1顶部居左
            case 1: $x=$y=0; break;
            //2顶部居右
            case 2: $x = $srcinfo[0]-$waterinfo[0]; $y = 20; break;
            //3居中
            case 3: $x = ($srcinfo[0]-$waterinfo[0])/2; $y = ($srcinfo[1]-$waterinfo[1])/2; break;
            //4底部居左
            case 4: $x = 0; $y = $srcinfo[1]-$waterinfo[1]; break;
            //4底部居左
            case 6: $x = 20; $y = $srcinfo[1]-$waterinfo[1]-10; break;
            //5底部居右
            case 5: $x = $srcinfo[0]-$waterinfo[0]-20; $y = ($srcinfo[1]-$waterinfo[1])/4; break;
            default: $x=$y=0;
        }
        //imagecopymerge($srcImgObj, $waterImgObj, $x, $y, 0, 0, $waterinfo[0], $waterinfo[1], $alpha);
        imagecopy($srcImgObj, $waterImgObj, $x, $y, 0, 0, $waterinfo[0], $waterinfo[1]);
        switch ($srcinfo[2]) {
            case 1: imagegif($srcImgObj, $savefile); break;
            case 2: imagejpeg($srcImgObj, $savefile,95); break;
            case 3: imagepng($srcImgObj, $savefile); break;
            default: return -5; //保存失败
        }
        imagedestroy($srcImgObj);
        imagedestroy($waterImgObj);
        return $savefile;
    }

    function image_create_from_ext($imgfile)
    {
        $info = getimagesize($imgfile);
        $im = null;
        switch ($info[2]) {
            case 1: $im=imagecreatefromgif($imgfile); break;
            case 2: $im=imagecreatefromjpeg($imgfile); break;
            case 3: $im=imagecreatefrompng($imgfile); break;
        }
        return $im;
    }



    /**
     *
     * 检查图片
     * @param unknown_type $img_path
     * @return array('flag'=>true/false,'msg'=>ext/错误信息)
     */
    private function is_img($img_path)
    {
        if (! file_exists ( $img_path ))
        {
            return array ('flag' => False, 'msg' => "加载图片 $img_path 失败！" );
        }
        $ext = explode ( '.', $img_path );
        $ext = strtolower ( end ( $ext ) );
        if (! in_array ( $ext, $this->exts ))
        {
            return array ('flag' => False, 'msg' => "图片 $img_path 格式不正确！" );
        }
        return array ('flag' => True, 'msg' => $ext );
    }

    /**
     *
     * 返回正确的图片函数
     * @param unknown_type $ext
     */
    private function get_img_funcs($ext)
    {
        //选择
        switch ($ext)
        {
            case 'jpg' :
                $header = 'Content-Type:image/jpeg';
                $createfunc = 'imagecreatefromjpeg';
                $savefunc = 'imagejpeg';
                break;
            case 'jpeg' :
                $header = 'Content-Type:image/jpeg';
                $createfunc = 'imagecreatefromjpeg';
                $savefunc = 'imagejpeg';
                break;
            case 'gif' :
                $header = 'Content-Type:image/gif';
                $createfunc = 'imagecreatefromgif';
                $savefunc = 'imagegif';
                break;
            case 'bmp' :
                $header = 'Content-Type:image/bmp';
                $createfunc = 'imagecreatefrombmp';
                $savefunc = 'imagebmp';
                break;
            default :
                $header = 'Content-Type:image/png';
                $createfunc = 'imagecreatefrompng';
                $savefunc = 'imagepng';
        }
        return array ('save_func' => $savefunc, 'create_func' => $createfunc, 'header' => $header );
    }

    /**
     *
     * 检查并试着创建目录
     * @param $save_img
     */
    private function check_dir($save_img)
    {
        $dir = dirname ( $save_img );
        if (! is_dir ( $dir ))
        {
            if (! mkdir ( $dir, 0777, true ))
            {
                return array ('flag' => False, 'msg' => "图片保存目录 $dir 无法创建！" );
            }
        }
        return array ('flag' => True, 'msg' => '' );
    }

    /*
     * 获取对应尺寸图片地址
     * @param $tag eg 500x600....
     * */

    public function getImgUrl($path,$tag='small'){

        if(is_array($path)){
            return 1;
        }
        $arr=array_filter(explode('.',$path));
        $html='';
        foreach($arr as $key=>$val){
            if($key==count($arr)-1){
                $html.=$val;
            }elseif($key==count($arr)-2){
                $html.=$val.'-'.$tag.'.';
            }else{
                $html.=$val.'.';
            }
        }
        if(file_exists(strstr($html,'storage'))){
            return $html;
        }else{
            /*if(file_exists(strstr($path,'storage'))) {
                if(!strstr($path,'612x394')&&!strstr($path,'480x288')&&!strstr($path,'218x128')){
                    $this->myImageResize(strstr($path, 'storage'), 612, 394, '612x394');
                    $this->myImageResize(strstr($path, 'storage'), 480, 288, '480x288');
                    $this->myImageResize(strstr($path, 'storage'), 218, 128, '218x128');
                }
            }*/
            return $path;
        }
    }

}


