[已更新]
-- ----------------------------
-- Procedure structure for `TimerTask_usertop300lashmonth` 上月排名
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_usertop300lashmonth`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `TimerTask_usertop300lashmonth`(OUT error INT)
BEGIN

    declare userId int default 0;
    declare amount decimal(14,2) default 0;
    #获取要统计的用户id
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    # 今日tag
    SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
    # 本月tag
    SET @month_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m');
    # 昨日tag
    SET @yesterday_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m%d');
    # 昨日的月份tag
    SET @yesterdaymonth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m');
    # 上月tag
    SET @lastmoth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 MONTH), '%Y%m');
    # 执行之前的时间戳
    SET @execStarttime = UNIX_TIMESTAMP();
    # 表名=jay_user300lastmonth

    # 清空上个月的表数据
    TRUNCATE jay_user300lastmonth;

    # 计算上个月300排名
    SET @v_sql = "insert into jay_user300lastmonth(user_id, commission, tag, addtime) select * from (";
    SET @v_sql = CONCAT(@v_sql, " select user_id, sum(finance_first+finance_second+finance_operations+finance_operationchilds+finance_playerhost+finance_playerhostzhishu+finance_reward) commission, '",@lastmoth_tag,"', UNIX_TIMESTAMP() from jay_account_finance  ");
    SET @v_sql = CONCAT(@v_sql, " where finance_tag=", @lastmoth_tag);
    SET @v_sql = CONCAT(@v_sql, " group by user_id");
    SET @v_sql = CONCAT(@v_sql, " order by commission desc limit 300 ) t;");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #记录执行日志
    set @logId = addTimerlog('TimerTask_usertop300lashmonth', error, @execStarttime);
  END
;;
DELIMITER ;






-- ----------------------------
-- Procedure structure for `TimerTask_usertop300month` 本月排名
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_usertop300month`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `TimerTask_usertop300month`(OUT error INT)
BEGIN

    declare userId int default 0;
    declare amount decimal(14,2) default 0;
    #获取要统计的用户id
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    # 今日tag
    SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
    # 本月tag
    SET @month_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m');
    # 昨日tag
    SET @yesterday_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m%d');
    # 昨日的月份tag
    SET @yesterdaymonth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m');
    # 上月tag
    SET @lastmoth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 MONTH), '%Y%m');
    # 执行之前的时间戳
    SET @execStarttime = UNIX_TIMESTAMP();
    # 表名=jay_user300month

    # 清空上本月的表数据
    TRUNCATE jay_user300month;

    # 计算上本月月300排名
    SET @v_sql = "insert into jay_user300month(user_id, commission, tag, addtime) select * from (";
    SET @v_sql = CONCAT(@v_sql, " select user_id, sum(finance_first+finance_second+finance_operations+finance_operationchilds+finance_playerhost+finance_playerhostzhishu+finance_reward) commission, '",@month_tag,"', UNIX_TIMESTAMP() from jay_account_finance  ");
    SET @v_sql = CONCAT(@v_sql, " where finance_tag=", @month_tag);
    SET @v_sql = CONCAT(@v_sql, " group by user_id");
    SET @v_sql = CONCAT(@v_sql, " order by commission desc limit 300 ) t;");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #记录执行日志
    set @logId = addTimerlog('TimerTask_usertop300month', error, @execStarttime);
  END
;;
DELIMITER ;