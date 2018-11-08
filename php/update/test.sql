-- ----------------------------
-- [存储过程：测试，增加用户]
-- Function structure for `test_adduser`
-- ----------------------------
DROP PROCEDURE IF EXISTS `test_adduser`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `test_adduser`(out error int)
BEGIN

  declare k int default 1;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;
  set @user_id = 0;
  set @path = '';
  set @reid= 0;
  set @sid=0;
  set @level=0;
  set @floor = 0;
  SELECT user_id,path,reid,sid,`level`,floor into @user_id,@path,@reid,@sid,@level,@floor from jay_user order by rand() limit 1;

  set @floor = @floor+1;
  if @level = 1
    THEN
    set @path = '';
    set @reid = 0;
    set @level = 1;
    set @sid = @user_id;
  ELSE
    set @path = CONCAT(@path, @user_id, ',');
    set @reid = @user_id;
    set @level = (@user_id % 2)+1;
    set @sid = @user_id;
  end if;
  SELECT @user_id,@path,@reid,@sid,@level,@floor;

  testloop:loop
    set k = k+1;
    if k > 10
      THEN
        leave testloop;
    end if;

    SET @insql = CONCAT(" insert into jay_user(token, recode, nickname, path, reid, sid, `level`, floor, reg_time) ");
    SET @insql = CONCAT(@insql, " values( ");
    SET @insql = CONCAT(@insql, " MD5(CONCAT(RAND(),UNIX_TIMESTAMP())), ");
    SET @insql = CONCAT(@insql, " MD5(CONCAT(RAND(),UNIX_TIMESTAMP())), ");
    SET @insql = CONCAT(@insql, " CONCAT('test',FORMAT(RAND(),3)*1000), ");
    SET @insql = CONCAT(@insql, " @path, ");
    SET @insql = CONCAT(@insql, @reid, ",");
    SET @insql = CONCAT(@insql, @sid, ",");
    SET @insql = CONCAT(@insql, @level, ",");
    SET @insql = CONCAT(@insql, @floor, ",");
    SET @insql = CONCAT(@insql, " UNIX_TIMESTAMP()");
    SET @insql = CONCAT(@insql, " );");

    PREPARE statement FROM @insql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
  end loop testloop;

END
;;
DELIMITER ;
