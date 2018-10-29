<?php
/**
 * Created by PhpStorm.
 * User: jay
 * Date: 2018/9/23
 * Time: 13:06
 */

namespace app\wechat\controller;


use app\common\WechatBaseController;
use Think\Db;

class NewsController extends WechatBaseController
{

    //新闻列表
    public function index(){
        $list = Db::name('article')->where([])->field('id, title, pic, add_time, tag')->order('add_time desc')->select();
        $this->assign('list', $list);
        return $this->displaySingle('index:news');
    }

    //新闻详情
    public function info(){
        $news = Db::name('article')->find($this->get('id', 0));
        $this->assign('news', $news);
        return $this->displaySingle('index:newsinfo');
    }

    /**
     * 常见问题
     */
    public function question(){
        $list = Db::name('content')->where(['section'=>2])->field('id, title, content')->order('`sort` asc')->select();
        $this->assign('list', $list);
        return $this->displaySingle('index:question');
    }

}