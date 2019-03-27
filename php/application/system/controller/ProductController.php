<?php

namespace app\system\controller;

use app\api\model\JpushModel;
use app\api\model\OpenTmModel;
use app\common\AdminBaseController;
use app\common\model\ProcedureModel;
use app\common\model\Tag;
use app\system\model\AreaModel;
use app\system\model\ProductModel;
use think\exception\DbException;
use think\Request;
use think\Db;
use think\Session;
use app\common\RegExpression;
use app\common\Md5Help;
use app\common\SysHelp;
use app\system\model\AdminModel;
use app\system\model\ContentModel;
use Think\Exception;
use app\system\model\UserModel;
use app\system\model\MerchantModel;
/**
 * 商品管理
 * Enter description here ...
 * @author Administrator
 * `price_type` tinyint(4) DEFAULT '1' COMMENT '非预约商品[1=平日价[快递商品只能1]，2选日期价]； 预约商品[1平日价，下单后预约判断是否加价]',
 */
class ProductController extends AdminBaseController {

    /**
     * 待审核列表
     * Enter description here ...
     */
    public function review() {
        $where['p.product_reviewstatus'] = 0;
        $where['p.product_del'] = 0;
        $data = $this->loadList($where);
        $this->assign('data', $data);
        return $this->display('product/review', true);
    }

    /**
     * 驳回商品列表
     * @return string
     */
    public function reback() {
        $where['p.product_reviewstatus'] = 1;
        $where['p.product_del'] = 0;
        $data = $this->loadList($where);
        $this->assign('data', $data);
        return $this->display('product/reback', true);
    }

    /**
     * 商品列表
     * @return string
     */
    public function index() {
        $where['p.product_reviewstatus'] = 2;
        $where['p.product_del'] = 0;
        $data = $this->loadList($where);
        $this->assign('data', $data);
        $merchant_id = $this->get('merchant_id', 0);
        if($merchant_id){
            $merchant = Db::name('merchant')->field('merchant_id')->find($merchant_id);
            if(!$merchant){
                $this->error('商家不存在');
            }
            $this->assign('merchant_id',  $merchant_id);
            $this->assign('addbtn',  $this->returnAddbtn2('发布产品', url('system/product/add', ['mchid'=>$merchant_id]), 2));
        }

        return $this->display('product/index', true);
    }

    /**
     * 商家商品列表
     * @return string
     */
    public function mchindex() {
        $merchant_id = $this->get('merchant_id', 0);
        $merchant = Db::name('merchant')->find($merchant_id);
        if(!$merchant){
            $this->error('商家不存在');
        }
        session('admin.mch_id', $merchant_id);
        //$where['p.product_status'] = 1;
        $where['p.product_reviewstatus'] = 2;
        $where['p.product_del'] = 0;
        $where['p.merchant_id'] = session('admin.mch_id');
        $data = $this->loadList($where);
        $this->assign('data', $data);
        $this->assign('merchant', $merchant);

        $merchanttxt = "<span class=\"gpsdiy\">".$merchant['merchant_name']."[".$merchant['merchant_contact'].$merchant['merchant_contactmobile']."]</span>";
        $divgps = "商家：$merchanttxt";
        $this->assign('append_title', $divgps);
        $this->assign('addbtn',  $this->returnAddbtn2('发布产品', url('system/product/add', ['mchid'=>$merchant_id]), 2));
        return $this->display('product/mchindex', true);
    }


    /**
     * 查看详情
     */
    public function view(){
        $id = $this->get('id', 0);
        $product = Db::name('product p')
                    ->field('p.*, m.merchant_name,c.category_name')
                    ->join('jay_merchant m', 'm.merchant_id = p.merchant_id', 'left')
                    ->join('product_category c', 'c.category_id = p.product_cateids', 'left')
                    ->where(['p.product_id'=>$id])
                    ->find();
        if($product){
            //商品基本信息
            $tagdata = Db::name('product_tags')->column('tag_id, tag_name');
            $catedata = Db::name('product_category')->column('category_id, category_name');
            $product = $this->getProductTag($tagdata, $catedata, $product);
            //价格
            $price = Db::name('product_price')->where(['product_id'=>$id])->select();
            //图片
            $product['product_carousel'] = explode(',', $product['product_carousel']);
            //操作日志
            $product['logs'] = Db::name('product_log')->where(['product_id'=>$id])->order('id desc')->select();

            $this->assign('pricelist',  $price);
            $this->assign('product',  $product);
            $this->assign('action', url('system/product/inview'));
           // dump($product);exit;
            return $this->display('product/view', true);
        }else{
            $this->error('商品不存在');
        }
    }


    /**
     * 审核操作
     */
    public function inview(){
        if(Request::instance()->isPost()){
            $id     = $this->post('id', 0);
            $status = $this->post('status', 1);
            $reason = $this->post('reason', '');

            if($status == 1 && $reason==''){
                $this->error('请填写驳回原因');
            }

            $Condition["product_id"] = $id;

            $product = ProductModel::ProductFind($Condition);

            if($product){
                $statusname = $status==1?"商品驳回":"商品通过";

                $Data["product_reviewstatus"] = $status;
                $Data["product_remark"]       = $reason;
                $Data["product_uptime"]       = time();

                $res = ProductModel::ProductUpdate($Condition,$Data);
                ProductModel::log($id, 1, session('admin.nickname'), session('admin.id'), ($statusname));
                $this->log("商品审核为".$statusname.",[商品ID:".$id."]","product",$Condition,$product);
                $this->success('操作成功', url('product/review'), 2);
            }

        }

        $id = $this->get('id', 0);
        $product = ProductModel::ProductFind(array("product_id"=>$id));

        if($product){
            $this->assign('product',  $product);
            $this->assign('action', url('system/product/inview'));
            return $this->display('product/inview', false);
        }else{
            $this->error('商品不存在');
        }

    }

    /**
     * 批量删除
     */
    public function delete(){
        $id = Request::instance()->param('id', 0);
        $idstr = Request::instance()->post('idstr', '');
        if ($id > 0) {
            //$obj = Db::name('product')->where('product_id', $id)->find();
            //$this->log('软删除商品：' . $obj['product_name']);
            //$res = Db::name('product')->where('product_id', $id)->update(['product_del'=>1]);
        } else {
            //批量删除
            $idarray = explode(',', $idstr);
            foreach ($idarray as $k => $v) {
                if (!(empty($v))) {
                    $obj = Db::name('product')->where('product_id', $v)->find();
                    $this->log('软删除商品：' . $obj['product_name']);
                    $res = Db::name('product')->where('product_id', $v)->update(['product_del'=>1]);
                    ProductModel::log($id, 1, session('admin.nickname'), session('admin.id'), '软删除');
                }
            }
        }
        $this->toSuccess('删除成功');
    }

    /**
     * 加载列表数据
     */
    private function loadList($map){
        $where = $map;
        //获取参数
        $pn          = $this->get('page', 1);
        $title       = $this->get('title', '');
        $provence_id = $this->get('provence_id', '');
        $city_id     = $this->get('city_id', '');
        $starttime   = $this->get('starttime', '');
        $endtime     = $this->get('endtime', '');
        $restarttime = $this->get('restrictstarttime', '');
        $reendtime   = $this->get('restrictendtime', '');
        $catedataid  = $this->get('catedataid', '');
        $returnall   = $this->get('returnall', '');
        $explosion   = $this->get('explosion', '');
        $numlimit    = $this->get('numlimit', '');
        $isexpress   = $this->get('isexpress', '');
        $reservation = $this->get('reservation', '');
        $status      = $this->get('status', '');
        $timelimit   = $this->get('timelimit', '');
        $sold_out    = $this->get('sold_out', '');
        $merchant_id = $this->get('merchant_id', '');
        $toplevel    = $this->get('toplevel', '');
        $distributiontag = $this->get('distributiontag', '');
        $Productmustfill = $this->get('productmustfill', '');
        $dboss_id = $this->get('dboss_id', '');
        $area_id  = $this->get('area_id', '');

        //组合where
        if($title){
            $where['p.product_name|m.merchant_name'] = array('like', '%'.$title.'%');
            $this->assign('title', $title);
        }
        if ($provence_id){
            $where['m.merchant_pcode'] = array('eq', $provence_id);
            $this->assign('provence_id', $provence_id);
        }
        if ($city_id){
            $where['m.merchant_ccode'] = array('eq', $city_id);
            $this->assign('city_id', $city_id);
        }
        if($starttime){
            $where['p.product_uptime'] = array('egt', strtotime($starttime));
            $this->assign('starttime', $starttime);
        }
        if($merchant_id){
            $where['p.merchant_id'] = $merchant_id;
        }
        if($endtime){
            $where['p.product_uptime'] = array('elt', strtotime($endtime)+86400);
            $this->assign('endtime', $endtime);
        }
        if($restarttime){
            $where['p.product_starttime'] = array('egt', strtotime($restarttime));
            $this->assign('restrictstarttime', $restarttime);
        }
        if($reendtime){
            $where['p.product_endtime'] = array('elt', strtotime($reendtime));
            $this->assign('restrictendtime', $reendtime);
        }
        if($catedataid){
            $where[] = array('exp',"find_in_set($catedataid,p.product_cateids)" );

            $this->assign('catedataid', $catedataid);
        }
        if($returnall){//新人免单
            if ($returnall == 1){
                $where['p.product_returnall'] = 1;
            }else{
                $where['p.product_returnall'] = 0;
            }
            $this->assign('returnall', $returnall);
        }
        if($returnall){//新人免单
            if ($returnall == 1){
                $where['p.product_returnall'] = 1;
            }else{
                $where['p.product_returnall'] = 0;
            }
            $this->assign('returnall', $returnall);
        }
        if($explosion){//分享圈
            if ($explosion == 1){
                $where['p.product_explosion'] = 1;
            }else{
                $where['p.product_explosion'] = 0;
            }
            $this->assign('explosion', $explosion);
        }
        if($numlimit){//限购
            $where['p.product_numlimit'] = $numlimit;
            $this->assign('numlimit', $numlimit);
        }
        if($isexpress){//体验形式
            $where['p.product_isexpress'] = $isexpress;
            $this->assign('isexpress', $isexpress);
        }
        if($reservation){//预约类型
            $where['p.product_reservation'] = $reservation;
            $this->assign('reservation', $reservation);
        }
        if($status){//预约类型
            if ($status == 1){
                $where['p.product_status'] = 1;
            }else{
                $where['p.product_status'] = 0;
            }
            $this->assign('status', $status);
        }
        if($timelimit){//限时
             if ($timelimit == 1){
                 $where['p.product_timelimit'] = 1;
             }else{
                 $where['p.product_timelimit'] = 0;
             }
             $this->assign('timelimit', $timelimit);
        }
        if($sold_out){//是否售罄
             if ($sold_out == 1){
                 $where['p.sold_out'] = 0;
             }else{
                 $where['p.sold_out'] = 1;
             }
             $this->assign('sold_out', $sold_out);
        }
        if($toplevel){
            if ($toplevel == 1){
                $where['p.product_toplevel'] = array("neq",0);
            }else{
                $where['p.product_toplevel'] = 0;
            }
            $this->assign('toplevel', $toplevel);
        }
        if($distributiontag){
            if ($distributiontag == 1){
                $where['p.distributiontag'] = array("neq",0);
            }else{
                $where['p.distributiontag'] = 0;
            }
            $this->assign('distributiontag', $distributiontag);
        }
        if($Productmustfill){
            $where['p.product_must_fill'] = $Productmustfill;
            $this->assign('productmustfill', $Productmustfill);
        }

        if ($dboss_id){
            $where['m.dboss_id'] = $dboss_id;
            $this->assign('dboss_id', $dboss_id);
        }

        $Cate["category_status"] = array("eq",1);
        $Cate["category_del"]    = array("eq",0);
        $Cate["category_id"]     = array("neq",1);

        $data     = productModel::getList($where, $pn);

        $tagdata  = Db::name('product_tags')->column('tag_id, tag_name');
        $catedata = Db::name('product_category')->where($Cate)->column('category_id, category_name');
        $dboss    = Db::name("merchant_dboss")->field("id,dboss_name")->select();

        foreach ($data['list'] as $k=>$v){
            $data['list'][$k] = $this->getProductTag($tagdata, $catedata, $v);
            $data['list'][$k]['prices'] = Db::name('product_price')->field('price_id, product_property')->where(['product_id'=>$v['product_id'], 'price_status'=>1])->select();
            //查询分店
            $data['list'][$k]['mchlist'] = Db::name('merchant')->field('merchant_id, merchant_name')->where(['merchant_id'=>['in', $v['fen_merchant_ids']]])->select();
        }

        $this->assign('catedata', $catedata);
        $this->assign('provence', $this->getProvenceList(1));
        $this->assign('dboss', $dboss);

        return $data;
    }

    public function getProductTag($tagdata, $catedata, $product){
        //标签
        $tagids  = explode(',' , $product['product_tags']);
        $cateids = explode(',' , $product['product_cateids']);
        $tag     = array();
        $cate    = array();
        foreach ($tagids as $a=>$b){
            if(trim($b) != ''){
                $tag[] = $tagdata[$b];
            }
        }
        foreach ($cateids as $a=>$b){
            if(trim($b) != ''){
                $cate[] = $catedata[$b];
            }
        }
        $product['tagstr']  = $tag;
        $product['catestr'] = $cate;
        return $product;
    }

    /**
     * @return string
     * @throws DbException
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * 发布商品
     */
    public function add(){
        if(Request::instance()->isPost()){
            $data = $this->createData();
            $merchant = Db::name('merchant')->find($this->post('merchant_id', 0));
            if(!$merchant){
                $this->error('商家不存在');
            }
            if($merchant['merchant_status'] != 2){
                //$this->error('商家未审核通过，不能发布商品');
            }
            $data['merchant_id'] = $merchant['merchant_id'];
            //更新分店
            $mchlist = Db::name('merchant')->where(['parent_id|merchant_id'=>$data['merchant_id']])->order('parent_id asc')->column('merchant_id');
            $data['fen_merchant_ids'] = implode(',',$mchlist);
            $data['product_addtime'] = time();
            $product_id = Db::name('product')->insertGetId($data);
            if($product_id){
                //到店商品默认推送到商家所在城市
                if($data['product_isexpress'] == 1){
                    if($merchant['merchant_ccode']){
                        ProductModel::pushProductToCity($product_id,$merchant['merchant_ccode'],'add');
                        if($data['product_toplevel'] > 0){
                            ProductModel::pushProductToProvince($product_id,$merchant['merchant_pcode'],$merchant['merchant_ccode']);
                        }
                    }else{
                        $this->success('发布成功,但商家没有选城市，需要手动推送到城市才能显示在首页', url('product/edit', ['id'=>$product_id]));
                    }
                }

                //进入编辑价格
                $this->log('发布商品id：'.$product_id);
                ProductModel::log($product_id, 1, session('admin.nickname'), session('admin.id'), '发布商品');
                $this->success('发布成功', url('product/edit', ['id'=>$product_id]));
            }else{
                $this->error('发布商品失败');
            }
        }

        //1、选择商家；2编辑
        $Cate["category_status"] = array("eq",1);
        $Cate["category_del"]    = array("eq",0);
        $Cate["category_id"]     = array("neq",1);

        $cates = Db::name('product_category')->field('category_id, category_name')->where($Cate)->select();
        $this->assign('cates', $cates);
        $tags = Db::name('product_tags')->field('tag_id, tag_name')->select();
        $this->assign('tags', $tags);

        $merchant_id = $this->get('mchid', 0);
        if($merchant_id > 0){
            $merchant = Db::name('merchant')->find($merchant_id);
            if(!$merchant){
                $this->error('商家不存在');
            }
            $obj['merchant'] = $merchant;
            $obj['merchant_id'] = $merchant['merchant_id'];
        }
        $obj['product_compic'] = [1,1,1];
        $obj['product_starttime'] = time();
        $obj['product_endtime'] = time()+2592000;
        $obj['product_startusetime'] = time();
        $obj['product_endusetime'] = time()+31536000;
        $goodsstatus = 1;

        $this->assign('obj', $obj);
        $this->assign('goodsstatus', $goodsstatus);
        $this->assign('action',  url('system/product/add'));
        return $this->display('product/add', true);
    }

    /**
     * @return string
     * @throws DbException
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\PDOException
     * 修改商品基本信息
     *
     */
    public function edit(){
        if(Request::instance()->isPost()){
            $product_id = $this->post('product_id', 0);
            $MerchantId = $this->post('merchant_id', 0);

            $old      = ProductModel::ProductFind(['product_id'=>$product_id]);
            $data     = $this->createData();
            $merchant = MerchantModel::MerchantFind(["merchant_id"=>$MerchantId]);

            if(!$merchant){
                $this->error('商家不存在');
            }
            if($merchant['merchant_status'] != 2){
                //$this->error('商家未审核通过，不能发布商品');
            }
            if($old['product_reviewstatus'] != 2){
                $data['product_reviewstatus'] = 0;
            }
            $data['merchant_id'] = $merchant['merchant_id'];
            //更新分店
            $mchlist = MerchantModel::MerchantColumn(['parent_id|merchant_id'=>$data['merchant_id']]);
            $data['fen_merchant_ids'] = implode(',',$mchlist);

            Db::startTrans();

            $res1 = ProductModel::ProductUpdate(['product_id'=>$product_id],$data);

            //库存属性名改变
            if($data['product_reservation'] == 1){
                $kcarray    = explode('|', $data['reservationStr']);
                $oldkcarray = explode('|', $old['reservationStr']);
                $olen       = getExplodlen($oldkcarray);
                $nlen       = getExplodlen($kcarray);

                if($nlen < $olen){
                    for($i = $nlen; $i<$olen; $i++){
                       ProductModel::ReservationpriceDel(['product_id'=>$product_id, 'property'=>$oldkcarray[$i]]);
                       $this->log("删除商品预约型号信息:[商品ID:".$product_id."]");
                    }
                }

                foreach ($kcarray as $k=>$v){
                    $PreRevision = ProductModel::ReservationpriceFind(['product_id'=>$product_id, 'property'=>$oldkcarray[$k]]);
                    ProductModel::ReservationpriceUpdate(['product_id'=>$product_id, 'property'=>$oldkcarray[$k]],['property'=>$v]);

                    $this->log("修改商品预约型号信息:[商品ID:".$product_id."]","product_reservationprice",['product_id'=>$product_id, 'property'=>$oldkcarray[$k]],$PreRevision);
                }

            }

            if($res1 !== false){
                $this->log('编辑商品id：'.$product_id);
                ProductModel::log($product_id, 1, session('admin.nickname'), session('admin.id'), '编辑商品');
                if($data['product_toplevel'] < 1){
                    //取消置顶，移除首页推荐
                    ProductModel::TopProvenceDel(['product_id'=>$product_id,'provence_code'=>$merchant['merchant_pcode']]);

                    $this->log("取消置顶，移除首页推荐:[商品ID:".$product_id."]");
                }

                Db::commit();
                echo '<script>localStorage.removeItem("ueditor_preference");</script>';//清除百度编辑器中等富文本框内容

                $this->log("商品进行编辑修改:[商品ID:".$product_id."]","product",['product_id'=>$product_id],$old);
                $this->success('修改成功', session('admin.productfrom'));
            }else{
                Db::rollback();
                $this->error('修改失败', session('admin.productfrom'));
            }
        }

        session('admin.productfrom', $_SERVER['HTTP_REFERER']);

        $product = ProductModel::ProductFind(['product_id'=>$this->get('id', 0)]);

        $product['product_carousel'] = explode(',', $product['product_carousel']);
        $product['merchant']         = Db::name('merchant')->find($product['merchant_id']);
        $product['purchase']         = [];
        $product['duty']             = [];
        $product['maketing']         = [];

        if( $product['purchase_id']){
            $umap['user_id'] = $product['purchase_id'];
            $product['purchase'] = UserModel::UserFind($umap,"user_id,nickname,mobile");
        }
        if( $product['duty_id']){
            $umap['staff_id'] = $product['duty_id'];
            $product['duty']  = ProductModel::StaffFind($umap,"staff_id,staff_name,staff_tel");
        }
        if( $product['maketing_id']){
            $umap['staff_id']    = $product['maketing_id'];
            $product['maketing'] = ProductModel::StaffFind($umap,"staff_id,staff_name,staff_tel");
        }

        if ($product["product_isexpress"] == 2){
            $goodsstatus = 1;
        }else{
            if ($product["product_reservation"] == 1){
                $goodsstatus = 2;
            }else{
                $goodsstatus = 1;
            }
        }

        $Cate["category_status"] = array("eq",1);
        $Cate["category_del"]    = array("eq",0);
        $Cate["category_id"]     = array("neq",1);

        $cates = ProductModel::AategoryList($Cate,"category_id, category_name");
        $tags  = ProductModel::TagsList("tag_id,tag_name");

        $this->assign('goodsstatus', $goodsstatus);
        $this->assign('obj', $product);
        $this->assign('product_id', $this->get('id', 0));
        $this->assign('cates', $cates);
        $this->assign('tags', $tags);
        $this->assign('action',  url('system/product/edit'));

        return $this->display('product/add', true);
    }

    /**
     * @return mixed
     * @throws DbException
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * 获取商品基本信息
     */
    private function createData(){
        $data['product_name']    = $this->post('product_name', '', RegExpression::REQUIRED, '商品名称');
        $data['product_info']    = $this->post('product_info', '', RegExpression::REQUIRED, '商品详情');
        $data['product_useinfo'] = $this->post('product_useinfo', '', RegExpression::REQUIRED, '使用方法');
        $data['product_notice']  = $this->post('product_notice', '', RegExpression::REQUIRED, '温馨提示');
        $data['product_cateids'] = implode(',',input('product_cateids/a'));
        $data['product_tags']    = input("post.product_tags/a");

        $data['purchase_id'] = $this->post('purchase_id', 0);
        $data['duty_id'] = $this->post('duty_id', 0);
        $data['maketing_id'] = $this->post('maketing_id', 0);
        if($data['purchase_id'] > 0){
            $user = Db::name('user')->find($data['purchase_id']);
            if(!$user){
                $this->error('采购员不存在');
            }
        }

        if(!$data['product_cateids']){
            $this->error('请勾选商品分类');
        }

        if (count($data['product_tags']) > 3){
            $this->error('商品标签最多勾选3个');
        }

        $data['product_tags']         = implode(',',$data['product_tags']);
        $data['product_toplevel']     = $this->post('product_toplevel', 0);
        $data['product_sold']         = $this->post('product_sold', 0);
        $data['product_returnall']    = $this->post('product_returnall', 0);
        $data['product_explosion']    = $this->post('product_explosion', 0);
        $data['product_isexpress']    = $this->post('product_isexpress', 2);
        $data['product_timelimit']    = $this->post('product_timelimit', 0);
        $data['distributiontag']      = intval($this->post('distributiontag', 0));
        $data['product_status']       = intval($this->post('product_status', 0));

        if ($data['product_isexpress'] == 1){
            $data['product_must_fill']    = intval($this->post('product_must_fill', 0));
        }else{
            $data['product_must_fill'] = 0;
        }
        if($data['product_status']!= 1){
            $data['obtained_time']  = time();
        }
        $data['product_numlimit']     = intval($this->post('product_numlimit', 0));
        $data['product_numlimit_num'] = intval($this->post('product_numlimit_num', 0));

        $data['product_reservation'] = $this->post('product_reservation', 2);

        if ($data['product_isexpress'] == 2 && $data['product_reservation'] == 2){
            $data['is_shengxian'] = $this->post('is_shengxian', 0);
        }else{
            $data['is_shengxian'] = 0;
        }

        $price_type = $this->post('price_type', 1);
        if($data['product_reservation'] == 1 && $price_type == 2){
            $this->error('预约商品价格模式只能是 平日价');
        }
        if($data['product_reservation'] == 1 && $price_type == 2){
            $this->error('预约商品价格模式只能是 平日价');
        }

        if ($data['product_numlimit'] == 1){
            parent::Tpl_Empty($data['product_numlimit_num'],"请输入用户每人限购数量如数字(1)");
        }
        if($data['product_isexpress'] == 1){
            $data['product_startusetime'] = strtotime($this->post('product_startusetime', '', RegExpression::REQUIRED, '使用开始时间'));
            $data['product_endusetime']   = strtotime($this->post('product_endusetime', '', RegExpression::REQUIRED, '使用结束时间'));
            if($data['product_endusetime'] < $data['product_startusetime']){
                $this->error('使用结束时间必须大于开始时间');
            }
        }
        if($data['product_timelimit'] == 1){
            $data['product_starttime'] = strtotime($this->post('product_starttime'));
            $data['product_endtime']   = strtotime($this->post('product_endtime'));

            parent::Tpl_Empty($data['product_starttime'],"请设置限时开始时间");
            parent::Tpl_Empty($data['product_endtime'],"请设置限时结束时间");

            if($data['product_endtime'] < $data['product_starttime']){
                $this->error('限时结束时间必须大于开始时间');
            }
        }

        $data['product_description'] = $this->post('product_description', '');
        $data['product_pic']         = $this->post('product_pic', '');
        $data['product_poster']      = $this->post('product_poster', '');
        $data['reservationStr']      = $this->post('reservationStr', '');
        $data['share_desc']          = $this->post('share_desc', '');
        $data['product_carousel']    = implode(',', input("post.batchimg1/a"));
        $data['product_compic']      = $this->post('product_compic', '');
        $data['product_uptime']      = time();
        $data['admin_id']      =  session('admin.id');
        $data['admin_name']      = session('admin.nickname');
        return $data;
    }

    /**
     * @return string
     * @throws DbException
     * @throws \think\Exception
     * @throws \think\db\exception\DataNotFoundException
     * @throws \think\db\exception\ModelNotFoundException
     * @throws \think\exception\PDOException
     * 添加商品规格
     */
    public function editprice(){
        if(Request::instance()->isPost()){
            $product_id = $this->post('product_id', 0);
            $pricedata  = [];
            $totalnum   = 0;
            $volume     = 0;
            $prid       = 0;

            foreach ($_POST['property'] as $k=>$property){
                if(trim($property) == ''){
                    continue;
                }
                $vo = [];
                $vo['product_id']       = $product_id;
                $vo['price_id']         = intval($_POST['price_id'][$k]);
                $vo['product_property'] = $property;
                $vo['price_market']     = $_POST['market'][$k];
                $vo['price_sale']       = $_POST['sale'][$k];
                $vo['price_status']     = $_POST['status'.($k+1)];
                $vo['pnumber']          = $_POST['pnumber'][$k];
                $vo['gnumber']          = $_POST['gnumber'][$k];
                $vo['price_commission'] = $_POST['commission'][$k];
                $vo['product_totalnum'] = $_POST['totalnum'][$k];
                $vo['product_buynum']   = $_POST['buynum'][$k];
                $vo['price_settle']     = $_POST['settle'][$k];
                $vo['price_addtime']    = time();
                $pricedata[]            = $vo;
            }

            foreach ($pricedata as $k=>$v){
                $this->verfiyValue($v['price_market'], RegExpression::MONEY, '市场价');
                $this->verfiyValue($v['price_sale'], RegExpression::MONEY, '销售价');
                $this->verfiyValue($v['price_commission'], RegExpression::MONEY, '佣金');
                $this->verfiyValue($v['product_totalnum'], RegExpression::NUMBER, '库存');
                $this->verfiyValue($v['product_buynum'], RegExpression::NUMBER, '已售数量');
                $this->verfiyValue($v['price_settle'], RegExpression::MONEY, '结算价格');

                if($v['price_market'] < $v['price_sale']){
                    $this->error('销售价 不能 高于 市场价');
                }
                if($v['price_commission'] >= $v['price_sale']){
                    $this->error('佣金 不能 高于 销售价');
                }
                if($v['price_sale'] <= $v['price_settle']){
                    $this->error('销售价 不能 低于 结算价格');
                }
                if($v['product_buynum'] >= $v['product_totalnum']){
                    $this->error('已售数量 不能 大于 库存总数');
                }
                if ($k == 0){
                    $prid =  $v['product_id'];
                }
                if ($v["price_status"]){
                    $totalnum += $v['product_totalnum'];
                }

                $volume += $v['product_buynum'];
            }

            if ($volume < $totalnum){
                $Data["sold_out"] = 0;
                $Data["sold_out_time"] = 0;
            }
            $Data["product_sales_volume"] = $volume;
            $Data["product_uptime"]       = time();

            $Condition["product_id"] = $prid;

            $PreRevision = ProductModel::ProductFind($Condition);
            ProductModel::ProductUpdate($Condition,$Data);

            $this->log("编辑规格,修改商品信息：[商品ID:".$product_id."]","product",$Condition,$PreRevision);

            Db::startTrans();
            foreach ($pricedata as $k=>$v){
                $price = ProductModel::ProductPriceFind(['price_id'=>$v['price_id']]);
                if($price){
                    ProductModel::ProductPriceUpdate(['price_id'=>$v['price_id']],$v);

                    $this->log("编辑规格,修改商品信息：[商品ID:".$product_id.",规格ID:".$v['price_id']."]","product_price",['price_id'=>$v['price_id']],$price);
                }else{
                    unset($v['price_id']);
                    ProductModel::ProductPriceAdd($v);

                    $this->log("商品添加规格:[商品ID:".$product_id."]");
                }
                ProductModel::log($v['product_id'], 1, session('admin.nickname'), session('admin.id'), '编辑价格'.$v['price_sale']);

            }

            $lowprice = ProductModel::ProductPriceFindAsc(['product_id'=>$product_id,"price_status"=>1]);

            $PreRevision = ProductModel::ProductFind(['product_id'=>$product_id]);
            ProductModel::ProductUpdate(['product_id'=>$product_id],['temp_price'=>$lowprice['price_sale'],'temp_commission'=>$lowprice['price_commission']]);
            $this->log("编辑规格,修改商品信息：[商品ID:".$product_id."]","product",['product_id'=>$product_id],$PreRevision);

            Db::commit();

            $this->log('编辑商品价格id：'.$product_id);
            $this->success('修改成功', '', 2);
        }

        $product   = ProductModel::ProductFind(['product_id'=>$this->get('id', 0)]);
        $pricelist = ProductModel::ProductPriceList(['product_id'=>$this->get('id', 0)]);
        $param     =  ProductModel::ParameterList();

        $this->assign('obj', $product);
        $this->assign('pricenum', count($pricelist));
        for($i = count($pricelist); $i < 20; $i++){
            if(!$pricelist[$i]){
                $pricelist[$i] = [];
            }
        }
        $this->assign('pricelist', $pricelist);
        $this->assign('param', $param);
        $this->assign('action',  url('system/product/editprice'));
        return $this->display('product/price'.$product['price_type'], false);
    }


    /**
     * 日历库存
     */
    public function resercanlendar(){
        $price_id = $this->get('price_id', 0);
        $mch_id   = $this->get('mch_id', 0);
        $product  = ProductModel::ProductFind(['product_id'=>$this->get('id', 0)]);

        if(!$product){
            $this->error('商品不存在');
        }
        if($product['product_reservation'] == 2){
            $this->error('免预约商品不需要设置日历库存');
        }
        if($product['product_isexpress'] == 2){
            $this->error('快递商品不需要设置日历库存');
        }
        if($product['price_type'] == 2){
            $this->error('商品价格类型[price_type=2]不支持日历库存功能');
        }
        $return['product'] = $product;
        $targetmonth = $this->get('month', date('Y-m', $product['product_startusetime']));
        $return['month_txt'] = $targetmonth;
        if($product['product_endusetime'] < strtotime($targetmonth)){
            $this->error('商品使用期限不包含'.$targetmonth);
        }
        if(strtotime(date('Y-m',$product['product_startusetime'])) > strtotime($targetmonth)){
            $this->error('商品使用期限不包含'.$targetmonth);
        }
        $return['canlendar'] = $this->getCalendar($targetmonth, $product['product_startusetime'], $product['product_endusetime'], $product['product_id'], $price_id, $mch_id);
        $this->assign('res', $return);
        $this->assign('price_id', $price_id);
        $this->assign('mch_id', $mch_id);
        return $this->display('product/resercanlendar', true);
    }


    /**
     * 批量编辑日历价格
     */
    public function reservbatchedit(){
        if(Request::instance()->isPost()){
            //编辑日期
            $calendararray = explode(',', $this->post('calendararray', ''));
            $product_id    = $this->post('product_id', 0);
            $priceId       = $this->post('priceId', 0);
            $mch_id        = $this->post('mch_id', 0);
            $preday        = $this->post('preday', 1);
            $product       = ProductModel::ProductFind(['product_id'=>$product_id]);

            if(!$product){
                $this->error('商品不存在');
            }

            $this->editKucunAndPrice($calendararray,$product_id,$priceId, $preday,$mch_id);
            $this->log('批量编辑商品库存价格:[商品ID:'.$product_id."]");
            ProductModel::log($product_id, 1, session('admin.nickname'), session('admin.id'), '批量编辑库存价格'.$this->post('calendararray', ''));
            $this->log('批量编辑商品库存价格,添加商品操作日志:[商品ID:'.$product_id."]");
            $this->success('编辑成功', '', 2);
        }

        $calendararray = $this->get('calendararray', '');
        $product_id    = $this->get('productId', 0);
        $priceId       = $this->get('priceId', 0);
        $mch_id        = $this->get('mch_id', 0);
        $product       = ProductModel::ProductFind(['product_id'=>$product_id]);

        if(!$product){
            $this->error('商品不存在');
        }

        $product['pplist'] = explode('|', $product['reservationStr']);
        $this->assign('product', $product);
        $this->assign('calendararray', $calendararray);
        $this->assign('priceId', $priceId);
        $this->assign('mch_id', $mch_id);
        $this->assign('action',  url('system/product/reservbatchedit'));
        return $this->display('product/reservbatchedit', false);
    }

    /**
     * 编辑指定日历价格
     */
    public function reservedit(){
        if(Request::instance()->isPost()){
            //编辑日期
            $calendararray = explode(',', $this->post('calendararray', ''));
            $product_id = $this->post('product_id', 0);
            $preday = $this->post('preday', 1);
            $priceId = $this->post('priceId', 0);
            $mch_id = $this->post('mch_id', 0);
            $product = Db::name('product')->where(['product_id'=>$product_id])->find();
            if(!$product){
                $this->error('商品不存在');
            }
            $this->editKucunAndPrice($calendararray,$product_id,$priceId,$preday,$mch_id);
            $this->log('编辑商品库存价格id：'.$product_id);
            ProductModel::log($product_id, 1, session('admin.nickname'), session('admin.id'), '编辑库存价格'.$this->post('calendararray', ''));
            $this->success('编辑成功', '', 2);
        }
        $calendar = $this->get('calendar', '');
        $product_id = $this->get('productId', 0);
        $priceId = $this->get('priceId', 0);
        $mch_id = $this->get('mch_id', 0);
        $product = Db::name('product')->where(['product_id'=>$product_id])->find();
        if(!$product){
            $this->error('商品不存在');
        }

        //获取日期
        $reservationday = Db::name('product_reservationday')->where(['product_id'=>$product_id,'merchant_id'=>$mch_id, 'price_id'=>$priceId, 'calendar'=>strtotime($calendar)])->find();
        $reservationday['properts'] = explode('|', $product['reservationStr']);
        //获取库存
        $templist = Db::name('product_reservationprice')->where(['reservationday_id'=>$reservationday['reservationday_id']])->select();
        foreach ($templist as $k=>$v){
            $kclist[$v['property']]=$v;
        }
        foreach ($reservationday['properts'] as $a=>$b){
            $kcdata[$b] = $kclist[$b];
            if(!$kclist[$b]){
                $kcdata[$b]['property'] = $b;
            }
        }
        $this->assign('reservationday', $reservationday);
        $this->assign('kcdata', $kcdata);
        $this->assign('product', $product);
        $this->assign('calendararray', $calendar);
        $this->assign('priceId', $priceId);
        $this->assign('mch_id', $mch_id);

        $this->assign('status', strtotime($calendar) >= strtotime(date('Y-m-d')));
        $this->assign('action',  url('system/product/reservedit'));
        return $this->display('product/reservedit', false);
    }


    /**
     * 编辑库存价格更新数据库
     * @param $calendararray
     * @param $product_id
     * @param $preday
     */
    private function editKucunAndPrice($calendararray,$product_id,$priceId,$preday,$mch_id){
        //更新日期数据
        foreach ($calendararray as $day){
            if(!$day){
                continue;
            }
            $dd = [];
            $dd['product_id']  = $product_id;
            $dd['preday']      = $preday;
            $dd['price_id']    = $priceId;
            $dd['merchant_id'] = $mch_id;
            $dd['calendar']    = strtotime($day);
            $dd['pretype']     = $_POST['pretype'];
            $dd['week']        = Tag::getWeek($day);
            $dd['uptime']      = time();

            try{
                $rd_id = ProductModel::ProductReservationdayAdd($dd);
                $this->log("添加商品日历库存:[商品ID:".$product_id.",商家ID:".$mch_id."]");
            }catch (DbException $e1){}

            $where1 = ['product_id'=>$product_id, 'calendar'=>$dd['calendar'], 'price_id'=>$priceId, 'merchant_id'=>$mch_id];

            $PreRevision = ProductModel::ProductReservationdayFind($where1);
            ProductModel::ProductReservationdayUpdate($where1,$dd);

            $this->log("修改商品日历库存信息：[商品ID:".$product_id.",商家ID:".$mch_id."]","product_reservationday",$where1,$PreRevision);

            $rd_id = Db::name('product_reservationday')->where($where1)->value('reservationday_id');
            //更新库存数据
            foreach ($_POST['property'] as $k=>$property){
                $mm = [];
                $mm['reservationday_id'] = $rd_id;
                $mm['property']          = $property;
                $mm['addprice']          = $_POST['addprice'][$k];
                $mm['totalnum']          = $_POST['totalnum'][$k];
                $mm['usenum']            = $_POST['usenum'][$k];
                $mm['product_id']        = $product_id;
                $mm['uptime']            = time();

                try{
                    ProductModel::ProductReservationpriceAdd($mm);
                    $this->log("添加商品日历库存预约商品指定日期加价、属性信息：[商品ID:".$product_id.",商家ID:".$mch_id."]");
                }catch (DbException $e2){}

                $where2 = ['reservationday_id'=>$rd_id, 'property'=>$mm['property']];

                $PreRevision2 = ProductModel::ProductReservationpriceFind($where2);
                ProductModel::ProductReservationpriceUpdate($where2,$mm);
                $this->log("修改商品日历库存预约商品指定日期加价、属性信息：[商品ID:".$product_id.",商家ID:".$mch_id."]","product_reservationprice",$where2,$PreRevision2);
            }
        }
    }

    /**
     * 删除指定日历
     */
    public function deletereserv(){
        $calendararray = explode(',', $this->get('calendararray', ''));
        $product_id    = $this->get('productId', 0);
        $priceId       = $this->get('priceId', 0);
        $mch_id        = $this->get('mch_id', 0);
        $product       = ProductModel::ProductFind(['product_id'=>$product_id]);

        if(!$product){
            $this->error('商品不存在');
        }
        foreach ($calendararray as $k=>$day){
            $reservationday = Db::name('product_reservationday')->where(['product_id'=>$product_id, 'price_id'=>$priceId, 'merchant_id'=>$mch_id, 'calendar'=>strtotime($day)])->find();
            //删除记录
            Db::name('product_reservationday')->where(['reservationday_id'=>$reservationday['reservationday_id']])->delete();
            Db::name('product_reservationprice')->where(['reservationday_id'=>$reservationday['reservationday_id']])->delete();
            ProductModel::log($product_id, 1, session('admin.nickname'), session('admin.id'), '删除库存价格'.$day);
        }

        $this->log("删除商品库存价格:[商品ID:".$product_id.",商家ID:".$mch_id."]");
        $this->success('删除成功');
    }

    /**
     * 获取指定月份日历表
     * @param $month
     * @param $starttime
     * @param $endtime
     */
    private function getCalendar($month, $starttime, $endtime, $product_id, $price_id, $mch_id){
        $monthstamp = strtotime($month);
        //查询price
        $sql = "select r.*, sum(p.totalnum) totalnum, sum(p.usenum) usenum, count(p.reservationday_id) casenum from jay_product_reservationday r ".
                " left join jay_product_reservationprice p on p.reservationday_id = r.reservationday_id ".
                " where r.product_id =".$product_id. " and r.price_id = ".$price_id. ' and r.merchant_id='.$mch_id.
                " GROUP BY r.reservationday_id ";
        $pricelist = Db::query($sql);
        $newpricelist = [];
        foreach ($pricelist as $k=>$v){
            $newpricelist[$v['calendar']] = $v;
        }
        //当月天数
        $dayNumber = date('t', $monthstamp);
        $calendar = [];
        //第一天星期几？补空位
        $weekindex = date('N', $monthstamp);
        for($i = 1; $i < $weekindex; $i++){
            $day = [];
            $day['day'] ='';
            $day['status'] = 0; //占位
            $day['expired'] = '';
            $day['data'] = [];
            $calendar[] = $day;
        }
        for($i = 1; $i <= $dayNumber; $i++){
            $day = [];
            $day['day'] = $month.'-'.$i;
            $day['d'] = $i;
            $day['status'] = 1;   //有效期内
            $daystamp = strtotime($day['day']);
            if($daystamp < strtotime(date('Y-m-d')) || $daystamp > $endtime){

                $day['status'] = 0;
            }
            $day['expired'] = '';
            if($daystamp < strtotime(date('Y-m-d'))){
                $day['expired'] = '已过期';
            }
            //组合日历价格
            $day['data'] = $newpricelist[$daystamp];
            $calendar[] = $day;
            $lashweekindex = date('N', $daystamp);
        }

        //最后一天星期几？补空位
        for($i = $lashweekindex; $i < 7; $i++){
            $day = [];
            $day['day'] ='';
            $day['status'] = 0; //占位
            $day['expired'] = '';
            $day['data'] = [];
            $calendar[] = $day;
        }

        //上一个月
        $month = date('m', $monthstamp);
        $year = date('Y', $monthstamp);
        $prev = $year.'-'.($month-1);
        if($month - 1 <= 0){
            $prev = ($year-1) .'-12';
        }
        $next = $year.'-'.($month+1);
        if($month + 1 > 12){
            $next = ($year+1) .'-01';
        }
        $return['canlendar'] = $calendar;
        $return['prev'] = $prev;
        $return['next'] = $next;
        return $return;
    }

    /**
     *商品分类
     * @return string
     */
    public function productCategory(){
        //设置添加信息按钮
        $this->assign('addbtn',  $this->returnAddbtn('添加分组', 'system/Product/productCategoryEdit?type=add'));
        //获取分页列表数据
        $data = Db::name('product_category')->order("category_sort asc")->select();
        $list = listToTree($data,'category_id','parent_id');
        $this->assign('data',  $list);
        return $this->display('product-cate-list', true);
    }

    /**
     * 添加操作
     * Enter description here ...
     */
    public function productCategoryEdit(){
        if (Request::instance()->isGet()){ //显示
            $cateId = Request::instance()->param('id', 0);
            $type   = $this->get('type', '');

            if($type == 'del') { //删除 (暂时不考虑多级分类)
                $res = Db::name('product_category')->delete($cateId);

                if ($res !== false) {
                    $this->log("删除商品分类:[ID:" . $cateId . "]");
                    $this->toSuccess("删除成功");
                } else {
                    $this->toError('删除失败');
                }
            }

            if($cateId){
                $item = Db::name('product_category')->where('category_id',$cateId )->find();
                $this->assign('obj', $item);
                $this->assign('type', 'up');
            }else{
                $this->assign('type', 'add');
            }
            return $this->display('product-cate-edit');
        }else{ //提交操作
            $type = $this->get('type', '');
            $item['category_name']   = $this->post('category_name', '', RegExpression::REQUIRED, '分类名称');
            $item['category_sort']   = $this->post('category_sort', '', RegExpression::REQUIRED, '分类排序');
            $item['parent_id']       = $this->post('parent_id', 0, RegExpression::STRING, '父级ID');
            $item['category_icon']   = $this->post('category_icon' );
            $item['category_status'] = $this->post('category_status',0);
            $item['category_show']   = $this->post('category_show',0);
            $item['addtime']         = time();

            parent::Tpl_Integer($item['category_sort'],"请输入数字");

            $id = Request::instance()->param('category_id', 0);
            if($type== 'add'){
                $res = Db::name('product_category')->insert($item);
                if($res !== false){
                    $this->log("添加商品分类");
                    $this->toSuccess('添加成功', '', 2);
                }else{
                    $this->toError('添加失败');
                }
            }elseif($id){
                if($type=='up' && $id){ //修改
                    $PreRevision = Db::name("product_category")->where(array('category_id'=>$id))->find();
                    $res         = Db::name('product_category')->where(array('category_id'=>$id))->update($item);

                    if($res !== false){
                        $this->log("编辑商品分类信息：[ID:".$id."]","product_category",array("category_id"=>$id),$PreRevision);
                        $this->toSuccess('编辑成功', '', 2);
                    }else{
                        $this->toError('编辑失败');
                    }

                }
            }
        }
    }

    /**
     * 推荐产品给用户
     * @return bool
     */
    public function sendMsgToWechat(){
        $product_id =  input('id', 0);
        $type = input('type', 2);//默认短信推送
        if($product_id){
            $stime = strtotime(date('Y-m-d').' 00:00:00');
            $etime = strtotime(date('Y-m-d').' 23:59:59');
            $todayCount = Db::name('timer_action')->where('addtime','between',$stime.','.$etime)->count();
            if($todayCount){
                return array('code'=>400,'msg'=>'一天只能推送一个商品！！！');
            }
            $product = Db::name('timer_action')->where(['results'=>1,'type'=>$type,'correlation_id'=>$product_id])->count();
            if($product){
                return array('code'=>400,'msg'=>'该商品正在推送中。。。');
            }
            $data['action_name'] = '商品推送，ID：'.$product_id;
            $data['correlation_id'] = $product_id;
            $data['type'] = $type;
            $data['addtime'] = time();
            $ta_id = Db::name('timer_action')->insertGetId($data);
            if($ta_id){
                return array('code'=>200);
            }
        }
        return array('code'=>400,'msg'=>'推送失败');
      /*
        $host =  $_SERVER['HTTP_HOST']?$_SERVER['HTTP_HOST']: $_SERVER['SERVER_NAME'];
        $url =  $host.'/api/Msg/sendMsgToWechat';
        $data['id'] = $product_id;
        $data['code'] = time();
        curlPost($url,$data); //curl发送推送消息给所有微信用户
        return array('code'=>200);*/
    }

    /**
     * @throws \PHPExcel_Exception
     * @throws \PHPExcel_Reader_Exception
     * @throws \think\exception\PDOException
     * 消费码导入
     * 肖亚子
     */
    public function ProcuctCodeExcel(){
        $Cash = ProductModel::TableName();
        $Cash->startTrans();//开启事务

        try{
            $Id = $this->post("id");

            if (!empty ($_FILES ['excel'] ['name'])) {
                $Tmp_File = $_FILES ['excel'] ['tmp_name'];
                $File_Types = explode(".", $_FILES ['excel'] ['name']);
                $File_Type = $File_Types [count($File_Types) - 1];
                /*判别是不是.xls文件，判别是不是excel文件*/
                if (strtolower($File_Type) != "xlsx") {
                    $this->error('不支持的Excel文件，请重新上传');
                }
                vendor('phpexcel.PHPExcel');
                vendor('phpexcel.PHPExcel.IOFactory');

                $ObjReader = \PHPExcel_IOFactory::createReader('Excel2007');
                $Obj_PHPExcel = $ObjReader->load($Tmp_File, $Encode = 'utf-8');//加载文件内容,编码utf-8
                $Excel_Array = $Obj_PHPExcel->getsheet(0)->toArray();//转换为数组格式
                array_shift($Excel_Array);//删除第一个数组(标题);

                foreach ($Excel_Array as $Key => $Val) {
                    $Data['product_id']   = $Id;
                    $Data['consome_code'] = $Val[0];
                    $Data['addtime']      = time();

                    $CodeAdd = ProductModel::ProductCode($Data);

                    if ($CodeAdd === false){
                        $Cash->rollback();//失败回滚exit;
                        break;
                    }
                }

                $Cash->commit();//成功提交事务
                $this->log("商品消费码导入:[商品ID".$Id."]");
                $this->success('消费码导入成功,',url('system/product/index'));
            }else{
                $this->error('消费码导入失败,',url('system/product/index'));
            }
        }catch (Exception $e){
            $Cash->rollback();//失败回滚exit;
            $this->error('消费码导入失败,',url('system/product/index'));
        }
    }

    /**
     * 推送商品到城市
     * @return string
     */
    public function sendProductToCity(){
        if(Request::instance()->isPost()){
            $data = $this->request->param();
            if(!in_array($data['merchant_city'],$data['city']) && $data['merchant_city']){
                array_push($data['city'],$data['merchant_city']);//商家默认城市必须推送
            }

            if(!$data['product_id']){
                $this->error('推送错误，请重试');
            }
            $Condition["product_id"] = $data['product_id'];

            $PreRevision = ProductModel::ProductFind($Condition);
            $product     = ProductModel::ProductFinds(['p.product_id'=>$data['product_id']]);

            if(empty($product)){
                $this->error('商品不存在');
            }

            Db::startTrans();

            $rs = ProductModel::ProductUpdate($Condition,['push_city_codes'=>implode(',',$data['city'])]);

            if($rs!==false){
                if(empty($data['city'])){
                    if($product['product_isexpress'] ==1){
                        Db::rollback();
                        $this->error('请选择推送城市');
                    }else{  //快递推送全国
                        ProductModel::HomeProductCityDel(['product_id'=>$data['product_id']]);
                        $this->log("删除商品推送城市：[商品ID:".$data['product_id']."]");
                    }
                }else{
                    //删除已取消勾选的
                    Db::name('home_product_city')
                        ->where(['product_id'=>$data['product_id']])
                        ->where('id','not in',implode(',',$data['city']))
                        ->delete();

                    foreach ($data['city'] as $val){
                        if(is_numeric($val)){
                            if(!ProductModel::pushProductToCity($data['product_id'],$val,'',$product['product_isexpress'])){
                                Db::rollback();
                                $this->error("城市ID{$val}推送失败");
                            }else{
                                $this->log("商品推送城市成功：[商品ID:".$data['product_id'].",城市ID:".$val."]");
                            }
                        }
                    }
                    if($product['product_isexpress'] ==1){
                        if($product['product_toplevel']==1){ //是否置顶
                            if(!ProductModel::pushProductToProvince($data['product_id'],$product['merchant_pcode'],implode(',',$data['city']))){
                                Db::rollback();
                                $this->error("首页省份到店商品置顶推荐表：推送失败");
                            }else{
                                $this->log("首页省份到店商品置顶推荐表,推送成功：[商品ID:".$data['product_id']."]");
                            }
                        }
                    }
                }

                Db::commit();
                $this->log("商品推送首页：[商品ID:".$data['product_id']."]","product",$Condition,$PreRevision);
                $this->success('推送成功', '', 2);

            }
        }else{
            $product_id  = Request::instance()->param('product_id', 0);
            $merchant_id = Request::instance()->param('merchant_id', 0);
            $list        = ProductModel::HomeProductCityFind(['product_id'=>$product_id],"city_code");
            $product_isexpress = ProductModel::ProductVal(['product_id'=>$product_id],"product_isexpress");
            $city_code     =[];
            $merchant_city ='';

            if($list){
                foreach ($list as $val){
                    if(!empty($val)){
                        $city_code[]=$val['city_code'];
                    }
                }
            }else{
                if($product_isexpress ==1) {
                    $merchant_city = MerchantModel::MerchantVal(['merchant_id' => $merchant_id],"merchant_ccode");
                }
            }

            $city_code[]  = $merchant_city;
            $this->assign('city_code',  $city_code);
            $this->assign('citylist',  AreaModel::getOpenCity());
            $this->assign('product_isexpress', $product_isexpress);
            $this->assign('product_id',  Request::instance()->param('product_id', 0));
            $this->assign('merchant_city', $merchant_city);
            return $this->display('send-to-city');
        }
    }

    /**
     * 刷新产品修改时间
     * @return array
     */
    public function refreshTime(){
        $product_id = $this->request->post('product_id');
        if($product_id){
            $Conditiopn["product_id"]  = $product_id;

            $PreRevision = ProductModel::ProductFind($Conditiopn);
            $Data        = ProductModel::ProductUpdate($Conditiopn,['product_uptime'=>time()]);

            if(false !== $Data){
                $this->log("刷新商品修改时间：[商品ID:".$product_id."]","product",$Condition,$PreRevision);

                return array('code'=>200);
            }
        }
        return array('code'=>400);
    }

    /**
     * 首页排序
     * @return array
     */
    public function homeproductrank(){
        $type =  Request::instance()->param('type','city');
        $ptype =  Request::instance()->param('ptype', 1);
        $where['p.product_reviewstatus'] = 2;//审核通过
        $where['p.product_status'] = 1; //上架
        $where['p.sold_out'] = array('neq',1);//为售罄
        if($ptype==1){//到店类型
            if($type == 'city'){
                $where['c.product_type'] = 1;
                $list = Db::name('home_product_city c')
                    ->field('c.*,r.name')
                    ->join('region r','r.id=c.city_code')
                    ->join('product p','p.product_id=c.product_id')
                    ->where($where)
                    ->group('c.city_code')
                    ->select();
            }else{
                $list = Db::name('home_product_top_provence tp')
                    ->field('tp.*,r.name')
                    ->join('region r','r.id=tp.provence_code')
                    ->join('product p','p.product_id=tp.product_id')
                    ->where($where)
                    ->group('tp.provence_code')
                    ->select();
            }
        }else{ //快递类型
            if($type == 'city'){
                $where['c.product_type'] = 2;
                $list = Db::name('home_product_city c')
                    ->field('c.*,r.name')
                    ->join('region r','r.id=c.city_code')
                    ->join('product p','p.product_id=c.product_id')
                    ->where($where)
                    ->group('c.city_code')
                    ->select();
            }else{
                $where['p.product_isexpress'] = 2;//快递
                $where[] = array('EXP',"find_in_set('4',p.product_cateids)" );
                $where['p.push_city_codes'] = array('EXP','IS NULL');
                $list = Db::name('product p')
                    ->field('p.product_id,p.product_name,p.product_pic')
                    ->where($where)
                    ->order('product_uptime desc')
                    ->select();
            }
        }

        $this->assign('list', $list);
        $this->assign('type', $type);
        $this->assign('ptype',$ptype);
        return $this->display('homeproductrank',true);
    }

    /**
     * 快递商品每日库存
     */
    public function deliveryOrderSku(){
        if(Request::instance()->isPost()) {
            $data   = $this->request->param();
            $result = [];

            foreach ($data['num'] as $k => $v) {
                if ($v)
                    $result[$k]['kucun'] = $v;
            }
            foreach ($data['merchant_id'] as $k => $v) {
                if ($v)
                    $result[$k]['merchant_id'] = $v;
            }
            foreach ($result as $k => $v) {
                if ($v) {
                    if (!$v['merchant_id'] || !$v['kucun']) {
                        continue;
                    }
                    $merchant = MerchantModel::MerchantFind(['merchant_id' => $v['merchant_id']],"parent_id,merchant_id");

                    if (isset($merchant['parent_id']) && $merchant['parent_id'] > 0) {
                        $v['merchant_id']     = $merchant['parent_id'];
                        $v['fen_merchant_id'] = $merchant['merchant_id'];
                    } else {
                        $v['merchant_id']     = $merchant['merchant_id'];
                        $v['fen_merchant_id'] = $merchant['merchant_id'];
                    }

                    $v['product_id'] = $data['product_id'];

                    $map = [];
                    $map['merchant_id']     = $v['merchant_id'];
                    $map['fen_merchant_id'] = $v['fen_merchant_id'];
                    $map['product_id']      = $v['product_id'];

                    if (ProductModel::ProductKuaidikucunCount($map)) {
                        $PreRevision = ProductModel::ProductKuaidikucunFind($map);

                        if (false === ProductModel::ProductKuaidikucunUpdate($map,$v)) {
                            $this->error("提交失败");
                        }else{
                            $this->log("修改快递商品每日预约库存数量：[商品ID:".$data["product_id"]."]","product_kuaidikucun",$map,$PreRevision);
                        }
                    } else {
                        $v['addtime'] = time();
                        if (!ProductModel::ProductKuaidikucunAdd($v)) {
                            $this->error("提交失败");
                        }else{
                            $this->log("添加快递商品每日开放库存:[商品ID:".$data["product_id"]."]");
                        }
                    }
                }
            }

            $this->log("快递商品每日开放库存设置成功:[商品ID:".$data["product_id"]."]");
            $this->success('提交成功', '', 2);
        }else{
            $product_id =  Request::instance()->param('product_id', 0);
            $fen_merchant_ids = Db::name('product')->where(['product_id'=>$product_id])->value('fen_merchant_ids');
            $mchlist = Db::name('merchant')->field('merchant_id,merchant_name') ->where(['merchant_id'=>['in', $fen_merchant_ids]])->select();
            foreach ($mchlist as &$val){
                if($val){
                    $val['kucun'] =  Db::name('product_kuaidikucun')->where(['merchant_id'=>$val['merchant_id']])->value('kucun');
                }
            }
            $this->assign('mchlist', $mchlist);
            $this->assign('product_id', $product_id);
            return $this->display('_delivery_order_sku');
        }
    }

    /**
     * 产品推送
     * @return string
     */
    public function productPush(){
        if(Request::instance()->isPost()) {
            $product_id = input('product_id');
            $touser     = input('touser',0);
            $ulevel     = input('ulevel/a');
            $type       = 1;
            $product    = ProductModel::TimerActionFind(['results'=>1,'type'=>$type,'correlation_id'=>$product_id]);

            if($product['results'] == 1){
                $this->error("该商品正在推送中。。。");
            }
            if($touser==3){
                //当天有发送记录
                if($product['addtime']>strtotime(date('Y-m-d').' 00:00:00') &&
                    $product['addtime']<strtotime(date('Y-m-d').' 23:59:59')){
                    $this->error("微信推送每天只能推送一次且仅只能推一个商品！！！");
                }
            }

            $data['action_name']    = '商品推送，ID：'.$product_id;
            $data['correlation_id'] = $product_id;
            $data['type']           = $type;
            $data['addtime']        = time();
            $data['touser']         = $touser;
            $data['ulevel']         = implode(',',$ulevel);

            $ta_id = ProductModel::TimerActionAdd($data);

            if($ta_id){
                $this->log("商品短信推送,添加MySQL定时器执行日志:[商品ID:".$product_id."]");
                $this->success('创建推送成功', '', 2);
            }else{
                $this->success('创建推送失败', '', 2);
            }
        }else{
            $product_id =  Request::instance()->param('product_id', 0);
            $this->assign('product_id', $product_id);
            return $this->display('_product_push');
        }
    }

    public function sendJpush(){
        if(Request::instance()->isPost()) {
//            $title = input('title');
//            $content = input('content');
////            $content = input('content');
//            $type =  $this->post('type', 'sys');
//            $data['title'] = $this->post('title', '测试');
//            $data['alert'] =  $this->post('content', '乐玩联盟');
//            $data['type'] =  JpushModel::JPUSH_MSG_NORMAL;
//            $data['platform'] =  'all';
//            $regid =  $this->post('regid','18071adc0347fe55b56');//1001
////        $regid =  $this->post('regid','18171adc03492bdaecf');
//            if(){
//                $this->success('推送成功', '', 2);
//            }else{
//                $this->success('推送失败', '', 2);
//            }
        }else{
            return $this->display('_jpush_msg');
        }
    }

}

