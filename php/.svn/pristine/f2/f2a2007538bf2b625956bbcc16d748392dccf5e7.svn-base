[分享达人，运营达人升级奖励赠送佣金，次月结算====已更新]

-- ----------------------------
-- Procedure structure for `jiesuan_commissionToCashAllYIjian`
-- ----------------------------
DROP PROCEDURE IF EXISTS `jiesuan_commissionToCashAllYIjian`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `jiesuan_commissionToCashAllYIjian`(out error int)
BEGIN

  declare userId int default 0;
  declare recordAmount DECIMAL(10,2) default 0;
  declare amounttag VARCHAR(50) default '';
  declare done int default 0;
  DECLARE recordlist CURSOR FOR SELECT * FROM view_forJiesuanCiYue order by user_id asc limit 1000;
  DECLARE CONTINUE handler FOR not found set done = 1;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;

  # 递归层级
  SET @@max_sp_recursion_depth = 5000;
  # 今日tag
  SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
  # 当月tag
  SET @moth_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m');
  # 上月tag
  SET @lastmoth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 MONTH), '%Y%m');
  # 手续费参数
  SET @taxfee_fuwu = 0;
  SET @taxfee_geren = 0;
  SET @taxfee_pingtai = 0;
  SELECT `value` INTO @taxfee_fuwu from jay_parameter where `key`='taxfee_fuwu';
  SELECT `value` INTO @taxfee_geren from jay_parameter where `key`='taxfee_geren';
  SELECT `value` INTO @taxfee_pingtai from jay_parameter where `key`='taxfee_pingtai';
  # 当日0点之前的时间戳
  SET @execStarttime = UNIX_TIMESTAMP();

  #开启事务
  START TRANSACTION ;
  out_label: BEGIN
    OPEN recordlist;
    repeat
      FETCH recordlist INTO userId,recordAmount,amounttag;
      IF NOT done THEN
        #1.结算佣金
        set @tempattach = concat('{"userId":',userId,',"desc":"',amounttag,'"}');
        call jiesuan_commissionToCashAll(userId, recordAmount, @tempattach, @taxfee_fuwu, @taxfee_geren, @taxfee_pingtai, error);
        if error then
          leave out_label;
        end if;

        #2.更新上月结算状态
        SET @v_sql = CONCAT('UPDATE jay_account_commission', @lastmoth_tag, ' SET record_status = 2 ');
        SET @v_sql = CONCAT(@v_sql, ' WHERE user_id = ', userId);
        SET @v_sql = CONCAT(@v_sql, ' AND record_action in (604,606,607,609,610)');
        SET @v_sql = CONCAT(@v_sql, ' AND record_status = 1');
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;


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

  #记录执行日志
  set @logId = addTimerlog('jiesuan_commissionToCashAllYIjian', error, @execStarttime);
  #判断是否还要继续执行
  SET @shengyu = 0;
  select count(*) into @shengyu from view_forjiesuanciyue;
  IF @shengyu > 0
    THEN
    call jiesuan_commissionToCashAllYIjian(@error);
  END IF ;
END
;;
DELIMITER ;





-- ----------------------------
-- Procedure structure for `TimerTask_recordtable`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_recordtable`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `TimerTask_recordtable`(OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');
    SET @nextmonth_tag = DATE_FORMAT(DATE_ADD(@month_tag * 100 + 1, INTERVAL 1 MONTH), '%Y%m');
    # 今日tag
    SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
    # 上月tag
    SET @lastmoth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 MONTH), '%Y%m');
    SET @lastmoth_tagstr = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 MONTH), '%Y年%m月');
    SET @execStarttime = UNIX_TIMESTAMP();

    # 创建当月现金币交易记录表
    SET @v_sql = CONCAT('CREATE TABLE IF NOT EXISTS `jay_account_cash', @month_tag, '` LIKE `jay_account_record`;');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    # 创建下月现金币交易记录表
    SET @v_sql = CONCAT('CREATE TABLE IF NOT EXISTS `jay_account_cash', @nextmonth_tag, '` LIKE `jay_account_record`;');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    # 创建当月佣金交易记录表
    SET @v_sql = CONCAT('CREATE TABLE IF NOT EXISTS `jay_account_commission', @month_tag, '` LIKE `jay_account_record`;');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    # 创建下月佣金交易记录表
    SET @v_sql = CONCAT('CREATE TABLE IF NOT EXISTS `jay_account_commission', @nextmonth_tag, '` LIKE `jay_account_record`;');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    # 创建商家当月现金交易记录表
    SET @v_sql = CONCAT('CREATE TABLE IF NOT EXISTS `jay_merchant_account', @month_tag, '` LIKE `jay_merchant_account_record`;');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    # 创建商家下月现金交易记录表
    SET @v_sql = CONCAT('CREATE TABLE IF NOT EXISTS `jay_merchant_account', @nextmonth_tag, '` LIKE `jay_merchant_account_record`;');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    # 创建两个月佣金明细视图temp,给view_forJiesuanOneAndOne使用
    DROP VIEW IF EXISTS `view_tempJiesuanOneAndOne`;
    SET @v_sql = CONCAT('CREATE VIEW `view_tempJiesuanOneAndOne` AS ');
    SET @v_sql = CONCAT(@v_sql, ' select * from jay_account_commission', @lastmoth_tag, ' where record_status = 1 and record_action in (601,602,603) UNION ALL ');
    SET @v_sql = CONCAT(@v_sql, ' select * from jay_account_commission', @month_tag, ' where record_status = 1 and record_action in (601,602,603) ');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    # 创建两个月佣金明细视图->按用户id,订单id统计佣金->次日结算
    DROP VIEW IF EXISTS `view_forJiesuanOneAndOne`;
    SET @v_sql = CONCAT('CREATE VIEW `view_forJiesuanOneAndOne` AS ');
    SET @v_sql = CONCAT(@v_sql, ' select r.order_id, r.user_id, sum(r.record_amount) record_amount, r.record_attach from view_tempJiesuanOneAndOne as r ');
    SET @v_sql = CONCAT(@v_sql, ' GROUP BY r.user_id,r.order_id ');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;


    # 创建上月玩主奖金、运营奖金、新人免单、直属玩主奖 视图 > 次月结算
    DROP VIEW IF EXISTS `view_forJiesuanCiYue`;
    SET @v_sql = CONCAT('CREATE VIEW `view_forJiesuanCiYue` AS ');
    SET @v_sql = CONCAT(@v_sql, ' select user_id, SUM(record_amount) as record_amount, \'',@lastmoth_tagstr ,'\' as tag from jay_account_commission',@lastmoth_tag);
    SET @v_sql = CONCAT(@v_sql, ' WHERE record_action in (606,604,607,609,610) and record_status = 1 ');
    SET @v_sql = CONCAT(@v_sql, ' GROUP BY user_id order by null ');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #记录执行日志
    set @logId = addTimerlog('TimerTask_recordtable', error, @execStarttime);
  END
;;
DELIMITER ;






-- ----------------------------
-- Procedure structure for `Timertask_lewan_pt_income`
-- ----------------------------
DROP PROCEDURE IF EXISTS `Timertask_lewan_pt_income`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `Timertask_lewan_pt_income`(OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @execStarttime = UNIX_TIMESTAMP();
    # 今日tag
    SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
    # 当月tang
    SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');
    # 昨日tag
    SET @yesterday_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m%d');
    # 昨日的月份tag
    SET @yesterdaymonth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m');
    #1.初始化平台收支记录
    INSERT IGNORE INTO jay_manage_finance (total_tag) VALUES (0);
    INSERT IGNORE INTO jay_manage_finance (total_tag) VALUES (@yesterdaymonth_tag);
    INSERT IGNORE INTO jay_manage_finance (total_tag) VALUES (@yesterday_tag);

    #1.昨日已结算佣金
    SET @total_yijiesuan = 0;
    SET @v_sql = CONCAT("select ifnull(sum(record_amount),0) into @total_yijiesuan from jay_account_cash",@yesterdaymonth_tag," where record_action in (802,803) and FROM_UNIXTIME(record_addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #2.昨日总提现成功金额
    SET @total_tixian = 0;
    SET @v_sql = CONCAT("select ifnull(sum(withdraw_realamount),0) into @total_tixian from jay_user_withdraw where withdraw_code = 'success' and FROM_UNIXTIME(withdraw_addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #3.总手续费
    SET @total_shouxufei = 0;
    SET @v_sql = CONCAT("select ifnull(abs(sum(record_amount)),0) into @total_shouxufei from jay_account_cash",@yesterdaymonth_tag," where record_action in (854,855,856,857) and FROM_UNIXTIME(record_addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #4.商家结算总金额
    SET @total_shangjiajiesuan = 0;
    SET @v_sql = CONCAT("select ifnull(sum(record_amount),0) into @total_shangjiajiesuan from jay_merchant_account",@yesterdaymonth_tag," where record_action =952 and FROM_UNIXTIME(record_addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #5.交易用户量
    SET @total_business_user = 0;
    SET @v_sql = CONCAT("select count(*) into @total_business_user from (select count(*),user_id unum from jay_order where order_status>1 and FROM_UNIXTIME(order_addtime, '%Y%m%d')=",@yesterday_tag," GROUP BY user_id ) as o");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #6.活跃用户量
    SET @total_active_user = 0;
    SET @v_sql = CONCAT("select count(*) into @total_active_user from jay_user where FROM_UNIXTIME(up_time, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #7.超级会员注册数量
    SET @total_level2_user = 0;
    SET @v_sql = CONCAT("select count(*) into @total_level2_user from jay_user_upgrade where new_level=2 and FROM_UNIXTIME(addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #8.分销达人数量
    SET @total_level3_user = 0;
    SET @v_sql = CONCAT("select count(*) into @total_level3_user from jay_user_upgrade where new_level=3 and FROM_UNIXTIME(addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #9.运营达人人数
    SET @total_level4_user = 0;
    SET @v_sql = CONCAT("select count(*) into @total_level4_user from jay_user_upgrade where new_level=4 and FROM_UNIXTIME(addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #10.玩主人数
    SET @total_level5_user = 0;
    SET @v_sql = CONCAT("select count(*) into @total_level5_user from jay_user_upgrade where new_level=5 and FROM_UNIXTIME(addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #11.奖励佣金
    SET @total_reward = 0;
    SET @v_sql = CONCAT("select IFNULL(sum(record_amount),0) into @total_reward from jay_account_commission",@yesterdaymonth_tag," where record_action in (610) and FROM_UNIXTIME(record_addtime, '%Y%m%d')=",@yesterday_tag,";");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #***************************************更新统计数据***********************************************
    #do-1.更新实时统计
    SET @v_sql = CONCAT('UPDATE jay_manage_finance SET total_jiesuan_commission = total_jiesuan_commission+', @total_yijiesuan);
    SET @v_sql = CONCAT(@v_sql, ' ,total_withdraw = total_withdraw+', @total_tixian);
    SET @v_sql = CONCAT(@v_sql, ' ,total_taxfee = total_taxfee+', @total_shouxufei);
    SET @v_sql = CONCAT(@v_sql, ' ,total_merchant_settle = total_merchant_settle+', @total_shangjiajiesuan);
    SET @v_sql = CONCAT(@v_sql, ' ,total_business_user = total_business_user+', @total_business_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_active_user = total_active_user+', @total_active_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level2_user = total_level2_user+', @total_level2_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level3_user = total_level3_user+', @total_level3_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level4_user = total_level4_user+', @total_level4_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level5_user = total_level5_user+', @total_level5_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_reward = total_reward+', @total_reward);
    SET @v_sql = CONCAT(@v_sql, ' WHERE total_tag = 0');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #do-2.当月统计
    SET @v_sql = CONCAT('UPDATE jay_manage_finance SET total_jiesuan_commission = total_jiesuan_commission+', @total_yijiesuan);
    SET @v_sql = CONCAT(@v_sql, ' ,total_withdraw = total_withdraw+', @total_tixian);
    SET @v_sql = CONCAT(@v_sql, ' ,total_taxfee = total_taxfee+', @total_shouxufei);
    SET @v_sql = CONCAT(@v_sql, ' ,total_merchant_settle = total_merchant_settle+', @total_shangjiajiesuan);
    SET @v_sql = CONCAT(@v_sql, ' ,total_business_user = total_business_user+', @total_business_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_active_user = total_active_user+', @total_active_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level2_user = total_level2_user+', @total_level2_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level3_user = total_level3_user+', @total_level3_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level4_user = total_level4_user+', @total_level4_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level5_user = total_level5_user+', @total_level5_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_reward = total_reward+', @total_reward);
    SET @v_sql = CONCAT(@v_sql, ' WHERE total_tag = ', @yesterdaymonth_tag);
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #do-3.昨日统计
    SET @v_sql = CONCAT('UPDATE jay_manage_finance SET total_jiesuan_commission = total_jiesuan_commission+', @total_yijiesuan);
    SET @v_sql = CONCAT(@v_sql, ' ,total_withdraw = total_withdraw+', @total_tixian);
    SET @v_sql = CONCAT(@v_sql, ' ,total_taxfee = total_taxfee+', @total_shouxufei);
    SET @v_sql = CONCAT(@v_sql, ' ,total_merchant_settle = total_merchant_settle+', @total_shangjiajiesuan);
    SET @v_sql = CONCAT(@v_sql, ' ,total_business_user = total_business_user+', @total_business_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_active_user = total_active_user+', @total_active_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level2_user = total_level2_user+', @total_level2_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level3_user = total_level3_user+', @total_level3_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level4_user = total_level4_user+', @total_level4_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_level5_user = total_level5_user+', @total_level5_user);
    SET @v_sql = CONCAT(@v_sql, ' ,total_reward = total_reward+', @total_reward);
    SET @v_sql = CONCAT(@v_sql, ' WHERE total_tag = ', @yesterday_tag);
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #记录执行日志
    set @logId = addTimerlog('Timertask_lewan_pt_income', error, @execStarttime);
  END
;;
DELIMITER ;
















-- ----------------------------
-- Procedure structure for `TimerTask_userFinance`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_userFinance`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `TimerTask_userFinance`(OUT error INT)
BEGIN

    declare userId int default 0;
    declare amount decimal(14,2) default 0;
    #获取要统计的用户id
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    # 今日tag
    SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
    # 昨日tag
    SET @yesterday_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m%d');
    # 昨日的月份tag
    SET @yesterdaymonth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m');
    # 昨日时间戳
    SET @yesterday_sjc = UNIX_TIMESTAMP(@yesterday_tag);
    SET @yesterday_sjcend = @yesterday_sjc + 86400;
    # 昨日的年tag
    SET @yesterdayyear_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y');
    SET @temp_record_finance_table = 'temp_record_finance_table';
    SET @temp_groupdata_userfinance = 'temp_groupdata_userfinance';
    SET @execStarttime = UNIX_TIMESTAMP();
    #开启事务
    START TRANSACTION;
    out_label:BEGIN
				DROP TABLE IF EXISTS `temp_record_finance_table`;
        DROP TABLE IF EXISTS `temp_groupdata_userfinance`;
        # 1.把昨日用户明细（现金，佣金）放入临时表
        SET @tbrfsql = CONCAT("create table ", @temp_record_finance_table ," as ");
        SET @tbrfsql = CONCAT(@tbrfsql, " select t.* from ( ");
        SET @tbrfsql = CONCAT(@tbrfsql, " select * from jay_account_commission",@yesterdaymonth_tag," where record_addtime >= ",@yesterday_sjc," and record_addtime < ",@yesterday_sjcend," ");
        SET @tbrfsql = CONCAT(@tbrfsql, " UNION ALL ");
        SET @tbrfsql = CONCAT(@tbrfsql, " select * from jay_account_cash",@yesterdaymonth_tag," where record_addtime >= ",@yesterday_sjc," and record_addtime < ",@yesterday_sjcend," ");
        SET @tbrfsql = CONCAT(@tbrfsql, " ) t; ");
        PREPARE statement FROM @tbrfsql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        if error = 1
        then
          leave out_label;
        end if;

        # 2.统计昨日各项收支->临时表
        SET @tbgpsql = CONCAT("create table ", @temp_groupdata_userfinance," as ");
        SET @tbgpsql = CONCAT(@tbgpsql, " select ");
        SET @tbgpsql = CONCAT(@tbgpsql, " null as finance_id, ");
        SET @tbgpsql = CONCAT(@tbgpsql, " m.user_id, ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(settle.amount,0) finance_settle  , ");
				SET @tbgpsql = CONCAT(@tbgpsql, " 0 as finance_withdraw, ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(recharge.amount,0) finance_recharge , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(reward.amount,0) finance_reward , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`xrmd`.amount,0) finance_xrmd , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`first`.amount,0) finance_first , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`second`.amount,0) finance_second , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`operations`.amount,0) finance_operations , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`operationchilds`.amount,0) finance_operationchilds , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`playerhost`.amount,0) finance_playerhost , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`playerhostzhishu`.amount,0) finance_playerhostzhishu , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`taxfee`.amount,0) finance_taxfee , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(`hanldfee`.amount,0) finance_hanldfee , ");
        SET @tbgpsql = CONCAT(@tbgpsql, @yesterday_tag, " as finance_tag, ");
        SET @tbgpsql = CONCAT(@tbgpsql, " UNIX_TIMESTAMP() as finance_uptime ");
        SET @tbgpsql = CONCAT(@tbgpsql, " from ");
        SET @tbgpsql = CONCAT(@tbgpsql, " (select user_id from temp_record_finance_table GROUP BY user_id order by null) m ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action in (652, 651) GROUP BY user_id order by null) as settle on settle.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 801 GROUP BY user_id order by null) as recharge on recharge.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 610 GROUP BY user_id order by null) as `reward` on `reward`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 607 GROUP BY user_id order by null) as `xrmd` on `xrmd`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 601 GROUP BY user_id order by null) as `first` on `first`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 602 GROUP BY user_id order by null) as `second` on `second`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 603 GROUP BY user_id order by null) as `operations` on `operations`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 604 GROUP BY user_id order by null) as `operationchilds` on `operationchilds`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 606 GROUP BY user_id order by null) as `playerhost` on `playerhost`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 609 GROUP BY user_id order by null) as `playerhostzhishu` on `playerhostzhishu`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action in (853, 854, 855) GROUP BY user_id order by null) as `taxfee` on `taxfee`.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 856 GROUP BY user_id order by null) as `hanldfee` on `hanldfee`.user_id = m.user_id; ");
        PREPARE statement FROM @tbgpsql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        if error = 1
        then
          leave out_label;
        end if;

        #3. 插入昨日收支统计
        INSERT IGNORE into jay_account_finance SELECT * from temp_groupdata_userfinance;

        #4.更新用户总收支
        SET @up0sql = CONCAT("UPDATE jay_account_finance f, temp_groupdata_userfinance g set ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_xrmd = f.finance_xrmd + g.finance_xrmd, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_reward = f.finance_reward + g.finance_reward, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_first = f.finance_first + g.finance_first, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_hanldfee = f.finance_hanldfee + g.finance_hanldfee, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operationchilds = f.finance_operationchilds + g.finance_operationchilds, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operations = f.finance_operations + g.finance_operations, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhost = f.finance_playerhost + g.finance_playerhost, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhostzhishu = f.finance_playerhostzhishu + g.finance_playerhostzhishu, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_recharge = f.finance_recharge + g.finance_recharge, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_second = f.finance_second + g.finance_second, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_settle = f.finance_settle + g.finance_settle, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_taxfee = f.finance_taxfee + g.finance_taxfee ");
        SET @up0sql = CONCAT(@up0sql, " where f.user_id = g.user_id and f.finance_tag = 0 ");
        PREPARE statement FROM @up0sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        if error = 1
        then
          leave out_label;
        end if;

        # 5.插入月记录
        SET @upytagsql = CONCAT("insert IGNORE into jay_account_finance(user_id, finance_tag, finance_uptime) ");
        SET @upytagsql = CONCAT(@upytagsql, " select user_id, ",@yesterdaymonth_tag," as finance_tag, UNIX_TIMESTAMP() as finance_uptime ");
        SET @upytagsql = CONCAT(@upytagsql, " from temp_record_finance_table GROUP BY user_id; ");
        PREPARE statement FROM @upytagsql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;

        #6.更新用户月收支
        SET @up0sql = CONCAT("UPDATE jay_account_finance f, temp_groupdata_userfinance g set ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_reward = f.finance_reward + g.finance_reward, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_xrmd = f.finance_xrmd + g.finance_xrmd, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_first = f.finance_first + g.finance_first, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_hanldfee = f.finance_hanldfee + g.finance_hanldfee, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operationchilds = f.finance_operationchilds + g.finance_operationchilds, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operations = f.finance_operations + g.finance_operations, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhost = f.finance_playerhost + g.finance_playerhost, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhostzhishu = f.finance_playerhostzhishu + g.finance_playerhostzhishu, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_recharge = f.finance_recharge + g.finance_recharge, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_second = f.finance_second + g.finance_second, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_settle = f.finance_settle + g.finance_settle, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_taxfee = f.finance_taxfee + g.finance_taxfee ");
        SET @up0sql = CONCAT(@up0sql, " where f.user_id = g.user_id and f.finance_tag = ", @yesterdaymonth_tag);
        PREPARE statement FROM @up0sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        if error = 1
        then
          leave out_label;
        end if;

        # 7.插入年记录
        SET @upytagsql = CONCAT("insert IGNORE into jay_account_finance(user_id, finance_tag, finance_uptime) ");
        SET @upytagsql = CONCAT(@upytagsql, " select user_id, ",@yesterdayyear_tag," as finance_tag, UNIX_TIMESTAMP() as finance_uptime ");
        SET @upytagsql = CONCAT(@upytagsql, " from temp_record_finance_table GROUP BY user_id; ");
        PREPARE statement FROM @upytagsql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;

        #8.更新用户年收支
        SET @up0sql = CONCAT("UPDATE jay_account_finance f, temp_groupdata_userfinance g set ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_reward = f.finance_reward + g.finance_reward, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_xrmd = f.finance_xrmd + g.finance_xrmd, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_first = f.finance_first + g.finance_first, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_hanldfee = f.finance_hanldfee + g.finance_hanldfee, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operationchilds = f.finance_operationchilds + g.finance_operationchilds, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operations = f.finance_operations + g.finance_operations, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhost = f.finance_playerhost + g.finance_playerhost, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhostzhishu = f.finance_playerhostzhishu + g.finance_playerhostzhishu, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_recharge = f.finance_recharge + g.finance_recharge, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_second = f.finance_second + g.finance_second, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_settle = f.finance_settle + g.finance_settle, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_taxfee = f.finance_taxfee + g.finance_taxfee ");
        SET @up0sql = CONCAT(@up0sql, " where f.user_id = g.user_id and f.finance_tag = ", @yesterdayyear_tag);
        PREPARE statement FROM @up0sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        if error = 1
        then
          leave out_label;
        end if;

        #9删除临时表
        SET @v_sql = CONCAT('DROP TABLE IF EXISTS ', @temp_record_finance_table, ';');
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        #9删除临时表
        SET @v_sql = CONCAT('DROP TABLE IF EXISTS ', @temp_groupdata_userfinance, ';');
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;

    END out_label;
    #提交事务
    IF error = 1
      THEN
        ROLLBACK ;
      ELSE
        COMMIT ;
    END IF ;
    set @logId = addTimerlog('TimerTask_userFinance', error, @execStarttime);
  END
;;
DELIMITER ;
