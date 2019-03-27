
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
  DECLARE recordlist CURSOR FOR SELECT j.user_id, IF(j.record_amount>a.account_commission_balance, a.account_commission_balance, j.record_amount) record_amount, j.tag FROM view_forJiesuanCiYue j
                                left join jay_account a on a.user_id = j.user_id
                                where a.account_tag=0
                                order by j.user_id asc limit 1000;
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
        SET @v_sql = CONCAT(@v_sql, ' AND record_action in (604,606,607,609,610,611)');
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



