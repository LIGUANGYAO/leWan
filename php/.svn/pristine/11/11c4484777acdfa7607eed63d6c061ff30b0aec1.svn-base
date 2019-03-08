[内部调用的存储过程]
insert_account_record
update_account
deduction_Fee
jiesuan_commissionToCashOneAndOne
jiesuan_commissionToCashAll
tj_lastMonthAccount


[定时任务的存储过程]
1.TimerTask_ciriJiesuan  每日凌晨0点1分
2.TimerTask_recordtable  每月1号0点1分：
创建当月现金币交易记录表、
创建两个月佣金明细视图temp,给view_forJiesuanOneAndOne使用
创建两个月佣金明细视图->按用户id,订单id统计佣金->次日结算
创建上月玩主奖金、运营奖金、新人免单 视图 > 次月结算

3.TimerTask_upAccountMonth  每月1号凌晨2点
自动统计用户上月收支入口函数

4.TimerTask_userFinance    每日凌晨5点
统计用户次日，次月、次年财务收支

5.TimerTask_cancelOrder
定时取消未付款订单

6.Timertask_lewan_pt_income  每日凌晨3点
平台利润统计3其他项-昨日

7.Timer_order_autodelivery
自动收货


[即时调用]
1.merchant_daodian_income
到店订单完成结算给商家

2.merchant_kuaidi_income
快递订单完成结算给商家。确认收货结算

3.lewan_order_income
平台利润统计1，付款后调用，

4.lewan_orderyuyue_income
预约加价统计2，付款后调用

5.lewan_user_performance
会员业绩统计，订单付款后调用



[视图]
1.view_forexpireorder
过期订单视图

2.view_orderFinance
订单统计视图

3.view_orderMerchantDaodianFinance
商家到店订单统计视图

4.view_orderMerchantKuaidiFinance
商家快递订单统计视图

5.addTimerlog
存储过程执行日志记录

6.addPerformance
记录虚拟号业绩

7.addProductPerformance
记录商品销量利润

8.fuc_manage_finance
记录平台统计

9.fuc_merchant_account
记录商家统计







-- ----------------------------
-- [存储过程：新人免单不签]
-- Function structure for `returnXinrenmiandan`
-- ----------------------------
DROP PROCEDURE IF EXISTS `returnXinrenmiandan`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `returnXinrenmiandan`(out error int)
BEGIN

  declare Toorder_no VARCHAR (50) default '';
  declare Toorder_id int default 0;
  declare Touser_id int default 0;
  declare Toorder_payfee DECIMAL(10,2) default 0;
  declare Tocommis_first DECIMAL(10,2) default 0;
  declare Tocommis_second DECIMAL(10,2) default 0;
  declare Tocommis_operations DECIMAL(10,2) default 0;
  declare Tocommis_operations_child DECIMAL(10,2) default 0;
  declare Touserid_first int default 0;
  declare Touserid_second int default 0;
  declare Touserid_operations int default 0;
  declare Touserid_operations_child int default 0;
  declare recordAttach VARCHAR(800) default '';
  declare done int default 0;
  DECLARE recordlist CURSOR FOR
    select o.order_no, o.order_id, o.user_id, o.order_payfee,
      p.commis_first, p.commis_second, p.commis_operations, p.commis_operations_child,
      p.userid_first, p.userid_second, p.userid_operations, p.userid_operations_child
      from jay_order o
    left join jay_order_product p on p.order_id = o.order_id
    where o.order_status>1 and p.product_id=17 and p.product_returnall=0 limit 1;

  DECLARE CONTINUE handler FOR not found set done = 1;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;

  #开启事务
  START TRANSACTION ;
  out_label: BEGIN
    OPEN recordlist;
    repeat
      FETCH recordlist INTO Toorder_no,Toorder_id,Touser_id,Toorder_payfee,Tocommis_first,Tocommis_second,Tocommis_operations,Tocommis_operations_child,Touserid_first,Touserid_second,Touserid_operations,Touserid_operations_child;
      IF NOT done THEN

        #1.扣除一级佣金
        set @attach = CONCAT("{\"orderId\":\"",Toorder_id,"\",\"amount\":\"",Tocommis_first,"\",\"num\":\"",1,"\"}");
        call update_account(Touserid_first, 'cash', -Tocommis_first, Toorder_id, 859, @attach, "后台扣款", error, 0);

        #1.扣除上级佣金
        set @attach = CONCAT("{\"orderId\":\"",Toorder_id,"\",\"amount\":\"",Tocommis_second,"\",\"num\":\"",1,"\"}");
        call update_account(Touserid_second, 'cash', -Tocommis_second, Toorder_id, 859, @attach, "后台扣款", error, 0);

        #1.扣除运营佣金
        set @attach = CONCAT("{\"orderId\":\"",Toorder_id,"\",\"amount\":\"",Tocommis_operations,"\",\"num\":\"",1,"\"}");
        call update_account(Touserid_operations, 'cash', -Tocommis_operations, Toorder_id, 859, @attach, "后台扣款", error, 0);

        #1.新人全返
        set @attach = CONCAT("{\"orderId\":\"",Toorder_id,"\",\"amount\":\"",Toorder_payfee,"\",\"num\":\"",1,"\"}");
        call update_account(Touser_id, 'commission', Toorder_payfee, Toorder_id, 607, @attach, "新人免单全返", error, 0);

        #1.扣运营奖金
        if Touserid_operations_child > 0 THEN
          set @attach = CONCAT("{\"orderId\":\"",Toorder_id,"\",\"amount\":\"",Tocommis_operations_child,"\",\"num\":\"",1,"\"}");
          call update_account(Touserid_operations_child, 'commission', -Tocommis_operations_child, Toorder_id, 654, @attach, "后台扣款", error, 0);
        end if;



      END IF;
    until done end repeat;
    close recordlist;#关闭释放资源
  END out_label;

  #提交事务
  IF error = 1
  THEN
    ROLLBACK ;
  ELSE
    COMMIT ;
  END IF ;

END
;;
DELIMITER ;






