
-- ----------------------------
-- 统计直推和二级人数Procedure structure for `lewan_makeusercount`
-- ----------------------------
DROP PROCEDURE IF EXISTS `lewan_makeusercount`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` PROCEDURE `lewan_makeusercount`(OUT error INT)
BEGIN

		declare done int default 0;
    declare userId int default 0;
    declare recount int default 0;
    declare userList cursor for select user_id  from jay_user where FROM_UNIXTIME(make_time,"%Y%m%d") < FROM_UNIXTIME(UNIX_TIMESTAMP(),"%Y%m%d") and `level`>1 order by user_id asc limit 100;
    declare continue handler for not found set done = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @execStarttime = UNIX_TIMESTAMP();

    out_label: BEGIN
      OPEN userList;
      repeat
        FETCH userList INTO userId;
        IF NOT done THEN
          #1.统计直属人数,排除运营达人团队
          set @recount = 0;
          SELECT count(*) into @recount from jay_user where reid = userId and `level` < 4;
          #2.统计二级人数,排除运营达人团队
          set @secondcount = 0;
          select count(*) into @secondcount from jay_user u left join (select user_id from jay_user where reid = userId and `level` < 4) t on u.reid = t.user_id where t.user_id is not null;

          #3.更新人数
          UPDATE jay_user set recount=@recount,childcount=@secondcount,make_time=UNIX_TIMESTAMP() where user_id=userId;

        end if;
      until done end repeat;
      close userList;#关闭释放资源
    END out_label;

    #记录执行日志
    set @logId = addTimerlog('jiesuan_commissionToCashAllYIjian', error, @execStarttime);
  END
;;
DELIMITER ;
