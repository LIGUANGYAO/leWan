<?php

namespace app\system\controller;

use app\common\AdminBaseController;
use think\Request;
use think\Db;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;
use app\system\model\PaginationModel;
use app\system\model\AdminModel;
use app\system\model\ContentModel;

/**
 * 达人分布图
 * Enter description here ...
 * @author Administrator
 *
 */
class UsermapController extends AdminBaseController {


    public function index(){
        return $this->display('user:usermap', true);
    }

    public function loaddata(){
        $level = $this->post('level', 2);
        $zoom = $this->post('zoom', 12);
        $daytag = $this->post('daytag', 0);
        $zxlnt = $this->post('zxlnt', 0);
        $zxlat = $this->post('zxlat', 0);
        $yslnt = $this->post('yslnt', 0);
        $yslat = $this->post('yslat', 0);

        $where['level'] = $level;
        $where['lat*1'] = ['between', [$zxlat, $yslat]]; //大于右下角 小于 左上角
        $where['lng*1'] = ['between', [$zxlnt,$yslnt]]; //大于左上角 小于 右下角
        $today = date('Y-m-d', time());
        $todaystarttime = strtotime($today);
        if($daytag == 1){
            //今日活跃
            $where['up_time'] = ['between', [$todaystarttime, $todaystarttime+86400]];
        }elseif($daytag == 2){
            //最近7天
            $where['up_time'] = ['between', [$todaystarttime-518400, $todaystarttime+86400]];
        }elseif($daytag == 3){
            //最近1月
            $where['up_time'] = ['between', [$todaystarttime-2592000, $todaystarttime+86400]];
        }
        $list = Db::name('user')->where($where)->field('user_id,nickname,avatar,lat,lng,mobile')->order('user_id asc')->select();
        foreach ($list as $k=>$v){
            if($level == 2){
                $list[$k]['level'] = '超级会员';
            }elseif($level == 3){
                $list[$k]['level'] = '分享达人';
            }elseif($level == 4){
                $list[$k]['level'] = '运营达人';
            }elseif($level == 5){
                $list[$k]['level'] = '玩主';
            }
        }
        echo json_encode($list);
    }
}
