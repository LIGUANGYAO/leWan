<?php
/**
 * Created by PhpStorm.
 * User: Admini
 * 文章模型
 */

namespace app\api\model;
use think\Db;
use think\Request;

class ArticleModel{

    /**
     * 获取文章分类
     * @return false|\PDOStatement|string|\think\Collection
     */
    public static function getCategory($pid,$field='*'){
        if($pid){
            $where['parent_id'] = $pid;
            return Db::name('categories')->field($field)->where($where)->order('sort asc')->select();
        }else{
            return array();
        }

    }

    /**
     * 获取文章列表
     * @param $cate
     * @param $page
     * @param $pagesize
     * @return false|\PDOStatement|string|\think\Collection
     */
    public static function getArticle($where,$field='*',$page=1,$pagesize=10){
        if($where){
            return Db::name('article')
                ->field($field)
                ->where($where)
                ->order('id desc')
                ->page($page,$pagesize)
                ->select();
        }else{
            return array();
        }

    }


}