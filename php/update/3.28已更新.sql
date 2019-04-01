DROP PROCEDURE IF EXISTS `TimerTask_createzhimaitable23`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `TimerTask_createzhimaitable23`(OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @execStarttime = UNIX_TIMESTAMP();

    #1.创建临时表
    DROP TABLE IF EXISTS `view_zhimaiuser23`;
    CREATE TABLE `view_zhimaiuser23` as SELECT t.userid_first, t.nickname, t.mobile, t.`level`, sum(t.num) num, FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y%m%d') as uptime from (
      select p.userid_first, u.nickname, u.mobile, u.`level`, count(*) num from jay_order o
      left join jay_order_product p on p.order_id=o.order_id
      left join jay_user u on u.user_id = p.userid_first
      where FROM_UNIXTIME(o.order_addtime,'%Y%m%d%H') BETWEEN FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y%m%d11') and FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y%m%d14')  and p.product_returnall=0 and o.user_id!=p.userid_first and p.userid_first>0 and o.order_status>1
      group by p.userid_first
        union all
      select p.userid_second userid_first, fen.nickname, fen.mobile, fen.`level`, count(*) num from jay_order o
      left join jay_order_product p on p.order_id=o.order_id
      left join jay_user byer on byer.user_id = o.user_id
      left join jay_user fen on fen.user_id = p.userid_second
      where p.product_returnall=0 and byer.`level`>1 and o.user_id=p.userid_first and o.order_status>1 and FROM_UNIXTIME(o.order_addtime,'%Y%m%d%H') BETWEEN FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y%m%d17') and FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y%m%d23')
      group by p.userid_second
      ) t
      group by t.userid_first
      order by num desc;

    set @logId = addTimerlog('TimerTask_createzhimaitable23', error, @execStarttime);
  END
;;
DELIMITER ;





-- ----------------------------
-- 对view_zhimaiuser23已入围的用户进行奖励分配,每天下午23点执行
-- Procedure structure for `TimerTask_zhimairuweiexecreward23`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_zhimairuweiexecreward23`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `TimerTask_zhimairuweiexecreward23`(OUT error INT)
BEGIN

    declare userId int default 0;
    declare recordAmount DECIMAL(10,2) default 0;
    declare amounttag VARCHAR(50) default '';
    declare done int default 0;
    DECLARE userlist CURSOR FOR SELECT userid_first FROM view_zhimaiuser23 where num>=3;
    DECLARE CONTINUE handler FOR not found set done = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    # 今日tag
    SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
    # 本月tag
    SET @month_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m');
    # 执行之前的时间戳
    SET @execStarttime = UNIX_TIMESTAMP();

    #查询总人数
    set @count = 0;
    SELECT count(*) into @count FROM view_zhimaiuser23 where `num`>=3;
    #查询每日分钱金额
    set @money = 0;
    SELECT `value` into @money FROM jay_parameter where `key`='hd_mrjl';
    #每份的金额
    set @everyOneMoney = FLOOR(@money/@count*100)/100;

    #开启事务
    START TRANSACTION ;
    out_label: BEGIN
      OPEN userlist;
      repeat
        FETCH userlist INTO userId;
        IF NOT done THEN
          #执行奖励
          call update_account(userId, 'commission', @everyOneMoney, 0, 611, '', "23点日3单活动奖励", error, @recordid);
        END IF;
      until done end repeat;
      close userlist;#关闭释放资源
    END out_label;


    #更新状态未结算
    SET @v_sql = CONCAT("UPDATE jay_account_commission",@month_tag," SET record_status = 1 where record_action=611 and FROM_UNIXTIME(record_addtime,'%Y%m%d') = FROM_UNIXTIME(UNIX_TIMESTAMP(),'%Y%m%d')");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #提交事务
    IF error = 1
    THEN
      ROLLBACK ;
    ELSE
      COMMIT ;
    END IF ;

    #记录执行日志
    set @logId = addTimerlog('TimerTask_zhimairuweiexecreward23', error, @execStarttime);
  END
;;
DELIMITER ;
