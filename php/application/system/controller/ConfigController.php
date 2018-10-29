<?php

namespace app\system\controller;

use app\common\AdminBaseController;
use think\Request;
use think\Db;
use think\Log;
use think\Config;
use think\Cache;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;

/**
 * 系统入口
 * Enter description here ...
 * @author Administrator
 *
 */
class ConfigController extends AdminBaseController {

    /**
     * 首页
     * Enter description here ...
     */
    public function index() {
        if(isset($_POST['tab'])){
            $tab = intval($_POST['tab']);
            $data = Request::instance()->post();
            foreach ($data as $k=>$v){
                $sw['field'] = $k;
                $sw['tab'] = $tab;
                $new['value'] = $v;
                if(isset($_POST[$k.'_alt'])){
                    $new['alt'] = $_POST[$k.'_alt'];
                }
                Db::name('sys_config')->where($sw)->update($new);
            }
            
            $this->success('更新成功， 请清空缓存', url('config/index', array('tab'=>$tab)));
        }
        $tab = intval($this->get('tab', 1));
        $this->assign('tabnow', $tab);
        
        //设置添加信息按钮
        $config = Db::name('sys_config')->order('sort asc')->where(['status'=>1])->select();
        foreach ($config as $k=>$v){
            if($v['type'] == 'radio'){
                $config[$k]['options'] = json_decode($v['alt']);
            }
        }
        $this->assign('config', $config);

        //fuck($config);
        return $this->display('index/config', true);
    }


    /**
     * 佣金设置
     */
    public function commission(){
        if(Request::instance()->isPost()){
            foreach ($_POST as $k=>$v){
                Db::name('parameter')->where(['key'=>$k])->update(['value'=>$v]);
            }
            $this->success('更新成功');
        }
        $config = Db::name('parameter')->column('key,value');
        $this->assign('obj',$config);
        return $this->display('index/commission', true);
    }
}
