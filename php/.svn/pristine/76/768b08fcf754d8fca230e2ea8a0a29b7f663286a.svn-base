
-- ----------------------------
-- 牵线 [已更新】
-- [牵线]Procedure structure for `lewan_exchangeUserPath`
-- ----------------------------
DROP PROCEDURE IF EXISTS `lewan_exchangeUserPath`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lewan_exchangeUserPath`(in fromUserId int, in toUserId int, OUT error INT)
  BEGIN

		declare floorexp int default 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    #1.查询被牵用户
    SET @from_user_id=0;
    SET @from_path='';
    SET @from_reid=0;
    SET @from_sid=0;
    SET @from_level=0;
    SET @from_floor=0;
    SELECT user_id,path,reid,sid,`level`,floor into @from_user_id,@from_path,@from_reid,@from_sid,@from_level,@from_floor from jay_user where user_id=fromUserId;
    #2.查询目标挂靠用户
    SET @to_user_id=0;
    SET @to_path='';
    SET @to_reid=0;
    SET @to_sid=0;
    SET @to_level=0;
    SET @to_floor=0;
    SELECT user_id,path,reid,sid,`level`,floor into @to_user_id,@to_path,@to_reid,@to_sid,@to_level,@to_floor from jay_user where user_id=toUserId;
    #如果 被牵用户 是目标用户的上线，无法执行
    set @cando= 0;
    select count(*) into @cando from jay_user where FIND_IN_SET(fromUserId,@to_path) and user_id=toUserId;

    out_label: BEGIN
      if @cando > 0 THEN
        SELECT '被牵用户是目标用户上级，无法降级牵线';
        leave out_label;
      END if;

      #开启事务
      START TRANSACTION ;

      #更新本人的标志
      set @target_newpath = concat(@to_path, @to_user_id, ',');
      SET @v_sql = CONCAT("UPDATE jay_user set reid=",@to_user_id, ", path='",@target_newpath, "', floor=",@to_floor+1," where user_id=",fromUserId,";");
      PREPARE statement FROM @v_sql;
      EXECUTE statement;
      DEALLOCATE PREPARE statement;

      #更新团队
      set @target_teampath = concat(@from_path, @from_user_id, ',');
      set @target_new_teampath = concat(@target_newpath, @from_user_id, ',');
			if @to_floor > @from_floor
				THEN
					set floorexp = @to_floor-@from_floor+1;
				ELSE
					set floorexp = -(@from_floor-@to_floor)+1;
			end if;

      SET @v_sql = CONCAT("UPDATE jay_user set path=REPLACE(path, '",@target_teampath,"','", @target_new_teampath,"'), floor=floor+",floorexp," where path like '",@target_teampath,"%';");
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

      SELECT error;
    END out_label;
  END;
;;
DELIMITER ;


