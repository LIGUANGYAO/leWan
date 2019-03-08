
-- ----------------------------
-- 统计不同等级达人团队数据
-- [牵线]Procedure structure for `lewan_makeuserteamdata`
-- ----------------------------
DROP PROCEDURE IF EXISTS `lewan_makeuserteamdata`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `lewan_makeuserteamdata`(in userLevel int, OUT error INT)
  BEGIN

		declare done int default 0;
    declare userId int default 0;
    declare unickname VARCHAR(30) default '';
    declare umobile VARCHAR(20) default '';
    declare utruename VARCHAR(20) default '';
    declare urecount int default 0;
    declare userList cursor for select u.user_id, u.nickname, u.mobile, a.truename, retb.recount from jay_user u
                                left join jay_user_auth a on a.user_id = u.user_id
                                left join (select reid, count(*) recount from jay_user where reid>0 group by reid) retb on retb.reid = u.user_id
																left join jay_account ac on ac.user_id = u.user_id and ac.account_tag=0
                                where u.`level`= userLevel
																group by u.user_id order by ac.account_commission_income desc, retb.recount desc limit 3000;
    declare continue handler for not found set done = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    out_label: BEGIN
      OPEN userList;
      repeat
        FETCH userList INTO userId,unickname,umobile,utruename,urecount;
        IF NOT done THEN
           #1.统计团队所有人
           set @teamcount = 0;
           SET @v_sql = CONCAT("select count(*) into @teamcount from jay_user where path like '%,",userId,",%';");
           PREPARE statement FROM @v_sql;
           EXECUTE statement;
           DEALLOCATE PREPARE statement;

           if @teamcount > 0 THEN
               #2.统计团队营业额，销量
               set @totalMoney = 0;
               set @num = 0;
               SET @v_sql = CONCAT("select SUM(o.order_payfee), SUM(p.num) into @totalMoney, @num from jay_order o");
               SET @v_sql = CONCAT(@v_sql, " left join jay_order_product p on p.order_id = o.order_id ");
               SET @v_sql = CONCAT(@v_sql, " where o.order_status>1 and (p.userid_first=",userId," or p.userid_second=",userId," or p.userid_operations=",userId," or p.userid_operations_child=",userId," or p.userid_playerhost_child=",userId,") ");
               PREPARE statement FROM @v_sql;
               EXECUTE statement;
               DEALLOCATE PREPARE statement;

                if @totalMoney > 0 then
                  INSERT IGNORE INTO jay_temp_userdata (`level`, user_id, unickname,umobile,utruename,urecount,teamcount,totalmoney,num,up_time) VALUES (
                    userLevel, userId, unickname, umobile, utruename, urecount, @teamcount, @totalMoney, @num, UNIX_TIMESTAMP()
                  );
                  UPDATE jay_temp_userdata set utruename = utruename,
                                                urecount = urecount,
                                                totalmoney = @totalMoney,
                                                num = @num,
                                                teamcount = @teamcount,
                                                up_time = UNIX_TIMESTAMP()
                                          where `level` = userLevel and user_id = userId;
                end if;
           end if;

        end if;
      until done end repeat;
      close userList;#关闭释放资源
    END out_label;
  END;
;;
DELIMITER ;


