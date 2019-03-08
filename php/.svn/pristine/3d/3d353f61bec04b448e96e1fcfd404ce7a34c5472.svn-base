
-- ----------------------------
-- Procedure structure for `deduction_Fee`
-- ----------------------------
DROP PROCEDURE IF EXISTS `deduction_Fee`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deduction_Fee`(in userId int, in amount DECIMAL(10,2), in taxfee_fuwu DECIMAL(10,2), in taxfee_geren DECIMAL(10,2), in taxfee_pingtai DECIMAL(10,2), in recordId int, out error int)
BEGIN

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;

  #1.计算3个扣费金额
  set @tax_geren = FORMAT( amount * taxfee_geren / 100, 2);
  set @tax_fuwu = FORMAT( amount * taxfee_fuwu / 100, 2);
  set @tax_pingtai = FORMAT( amount * taxfee_pingtai / 100, 2);
  set @attach = CONCAT("{\"userId\":\"",userId,"\",\"userName\":\"\",\"orderNo\":\"\",\"recordId\":\"", recordId,"\"}");
  #2.扣除手续费
  IF @tax_geren > 0 THEN
    call update_account(userId, 'cash', -@tax_geren, 0, 853, @attach, "扣除个人所得税", error, @recordid);
  END IF;
  IF @tax_pingtai > 0 THEN
    call update_account(userId, 'cash', -@tax_pingtai, 0, 854, @attach, "扣除平台管理费", error, @recordid);
  END IF;
  IF @tax_fuwu > 0 THEN
    call update_account(userId, 'cash', -@tax_fuwu, 0, 855, @attach, "扣除技术服务费", error, @recordid);
  END IF;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `insert_account_record`
-- ----------------------------
DROP PROCEDURE IF EXISTS `insert_account_record`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_account_record`(in `user_id` int, in `order_id` int, in `record_currency` varchar(20), in `record_action` int, in `record_amount` DECIMAL(10,2), in `record_balance` DECIMAL(10,2),  in `record_addtime` int, in `record_attach` varchar(800), in `record_remark` VARCHAR(50), in `record_status` int ,out error int, out recordId int)
BEGIN

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;

  #1.拼接sql，插入明细
  SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');
  SET @sql1 = CONCAT('INSERT IGNORE INTO `jay_account_', record_currency, @month_tag, '`(user_id,order_id,record_currency,record_action,record_amount,record_balance,record_addtime,record_attach,record_remark,record_status) VALUES (');
  SET @sql1 = CONCAT(@sql1, user_id,',');
  SET @sql1 = CONCAT(@sql1, order_id,',');
  SET @sql1 = CONCAT(@sql1, "'",record_currency,"',");
  SET @sql1 = CONCAT(@sql1, record_action,',');
  SET @sql1 = CONCAT(@sql1, record_amount,',');
  SET @sql1 = CONCAT(@sql1, record_balance,',');
  SET @sql1 = CONCAT(@sql1, record_addtime,',');
  SET @sql1 = CONCAT(@sql1, "'",record_attach,"',");
  SET @sql1 = CONCAT(@sql1, "'",record_remark,"',");
  SET @sql1 = CONCAT(@sql1, record_status,");");
  PREPARE statement FROM @sql1;
  EXECUTE statement;
  DEALLOCATE PREPARE statement;

  SET recordId = LAST_INSERT_ID(); # 获取明细ID
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `jiesuan_commissionToCashAll`
-- ----------------------------
DROP PROCEDURE IF EXISTS `jiesuan_commissionToCashAll`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `jiesuan_commissionToCashAll`(in userId int, in amount DECIMAL(10,2), in attach VARCHAR(800), in taxfee_fuwu DECIMAL(10,2),in taxfee_geren DECIMAL(10,2),in taxfee_pingtai DECIMAL(10,2), out error int)
BEGIN

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;
  #1.扣除佣金
  call update_account(userId, 'commission', -amount, 0, 652, attach, "次月累计结算扣除佣金", error, @recordid);
  #2.结算现金
  call update_account(userId, 'cash', amount, 0, 803, attach, "次月累计结算现金", error, @recordid);
  #3.扣除手续费
  call deduction_Fee(userId, amount, taxfee_fuwu, taxfee_geren, taxfee_pingtai, @recordid, error);

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `jiesuan_commissionToCashOneAndOne`
-- ----------------------------
DROP PROCEDURE IF EXISTS `jiesuan_commissionToCashOneAndOne`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `jiesuan_commissionToCashOneAndOne`(in userId int, in orderId int, in amount DECIMAL(10,2), in attach VARCHAR(800), in taxfee_fuwu DECIMAL(10,2),in taxfee_geren DECIMAL(10,2),in taxfee_pingtai DECIMAL(10,2), out error int)
BEGIN

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;
  #1.扣除佣金
  call update_account(userId, 'commission', -amount, orderId, 651, attach, "次日结算扣除佣金", error, @recordid);
  #2.结算现金
  call update_account(userId, 'cash', amount, orderId, 802, attach, "次日结算累加现金", error, @recordid);
  #3.扣除手续费
  call deduction_Fee(userId, amount, taxfee_fuwu, taxfee_geren, taxfee_pingtai, @recordid, error);

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `lewan_exchangeUserPath`
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
  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `lewan_orderyuyue_income`
-- ----------------------------
DROP PROCEDURE IF EXISTS `lewan_orderyuyue_income`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lewan_orderyuyue_income`(in reservationOrderId int, OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @totalfee = 0;
    #1.查询订单
    SELECT ifnull(reservation_addprice,0) into @totalfee from jay_order_user_reservation where reservation_id = reservationOrderId;

    out_label: BEGIN

      IF @totalfee > 0 THEN
        #4.初始化平台收支记录
        # 今日tag
        SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
        # 当月tang
        SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');
        # 昨日tag
        SET @yesterday_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m%d');
        # 昨日的月份tag
        SET @yesterdaymonth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m');
        #5.更新统计
        set @recordId = fuc_manage_finance(0, @totalfee);
        set @recordId = fuc_manage_finance(@month_tag, @totalfee);
        set @recordId = fuc_manage_finance(@day_tag, @totalfee);

      END IF ;

    END out_label;

  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `lewan_order_income`
-- ----------------------------
DROP PROCEDURE IF EXISTS `lewan_order_income`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lewan_order_income`(in orderId int, OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @totalfee = 0;
    SET @num = 0;
    SET @totalsettle = 0;
    SET @coupon = 0;
    SET @payamount = 0;
    SET @isreturnall = 0;
    SET @commis_first = 0;
    SET @commis_second = 0;
    SET @commis_operations = 0;
    SET @commis_operations_child = 0;
    SET @commis_playerhost_child = 0;
    SET @commis_playerhost_zhishu = 0;
    SET @returnmoney = 0;
    #1.查询订单
    SELECT ifnull(o.order_totalfee,0),
           ifnull(op.num,0),
          ifnull(op.totalsettle,0),
          ifnull(oa.coupon,0),
          ifnull(oa.payamount,0),
          ifnull(op.commis_first,0),
          ifnull(op.commis_second,0),
          ifnull(op.commis_operations,0),
          ifnull(op.commis_operations_child,0),
          ifnull(op.commis_playerhost_child,0),
          ifnull(op.commis_playerhost_zhishu,0),
          ifnull(op.product_returnall,0)
    into @totalfee,@num,@totalsettle,@coupon,@payamount,@commis_first,@commis_second,@commis_operations,@commis_operations_child,@commis_playerhost_child,@commis_playerhost_zhishu,@isreturnall from jay_order o
      left join jay_order_product op on op.order_id = o.order_id
      left join jay_order_affiliated oa on oa.order_id = o.order_id
    WHERE o.order_id = orderId and o.order_status=2;
    out_label: BEGIN

      IF @totalfee > 0 THEN
        IF @isreturnall = 1 then
          SET @returnmoney = @payamount;
        END IF ;
        #4.初始化平台收支记录
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
        INSERT IGNORE INTO jay_manage_finance (total_tag) VALUES (@month_tag);
        INSERT IGNORE INTO jay_manage_finance (total_tag) VALUES (@day_tag);
        #5.更新实时统计
        SET @totalcom = @commis_first+@commis_second+@commis_operations+@commis_operations_child+@commis_playerhost_child+@commis_playerhost_zhishu+@returnmoney;
        SET @v_sql = CONCAT('UPDATE jay_manage_finance SET total_order_business = total_order_business+', @totalfee);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_payfee=total_order_payfee+ ', @payamount);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_coupon=total_order_coupon+ ', @coupon);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_settle=total_order_settle+ ', @totalsettle);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_productnum=total_order_productnum+ ', @num);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_commission=total_order_commission+ ', @totalcom);
        SET @v_sql = CONCAT(@v_sql, ' WHERE total_tag = 0');
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        #5.当月统计
        SET @v_sql = CONCAT('UPDATE jay_manage_finance SET total_order_business = total_order_business+', @totalfee);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_payfee=total_order_payfee+ ', @payamount);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_coupon=total_order_coupon+ ', @coupon);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_settle=total_order_settle+ ', @totalsettle);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_productnum=total_order_productnum+ ', @num);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_commission=total_order_commission+ ', @totalcom);
        SET @v_sql = CONCAT(@v_sql, ' WHERE total_tag = ', @month_tag);
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
        #5.当日统计
        SET @v_sql = CONCAT('UPDATE jay_manage_finance SET total_order_business = total_order_business+', @totalfee);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_payfee=total_order_payfee+ ', @payamount);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_coupon=total_order_coupon+ ', @coupon);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_settle=total_order_settle+ ', @totalsettle);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_productnum=total_order_productnum+ ', @num);
        SET @v_sql = CONCAT(@v_sql, ' ,total_order_commission=total_order_commission+ ', @totalcom);
        SET @v_sql = CONCAT(@v_sql, ' WHERE total_tag = ', @day_tag);
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;

      END IF ;

    END out_label;

  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `lewan_user_performance`
-- ----------------------------
DROP PROCEDURE IF EXISTS `lewan_user_performance`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `lewan_user_performance`(in orderId int, OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @productId = 0;
    set @virtualpath = '';
    set @level= 0;
    set @path= 0;
    set @supath= 0;
    SET @num = 0;
    set @totalsettle = 0;
    set @payamount = 0;
    set @commission = 0;
    set @isreturnall = 0;
    set @userId = 0;
    set @userid_first = 0;
    set @userid_second=0;
    set @userid_operations=0;
    set @userid_operations_child=0;
    set @userid_playerhost_child=0;
    #1.查询订单
    SELECT u.`level`,u.path, CONCAT(su.path,su.user_id) supath, ifnull(op.num,0),
      ifnull(op.totalsettle,0),
      ifnull(o.order_payfee,0),
      ifnull(op.commis_first+op.commis_second+op.commis_operations+op.commis_operations_child+op.commis_playerhost_child, 0),
      ifnull(op.product_returnall,0),
      o.user_id,op.userid_first,op.userid_second,op.userid_operations,op.userid_operations_child,op.userid_playerhost_child,op.product_id
    into @level,@path,@supath,@num,@totalsettle,@payamount,@commission,@isreturnall,@userId,@userid_first,@userid_second,@userid_operations,@userid_operations_child,@userid_playerhost_child,@productId from jay_order o
      left join jay_order_product op on op.order_id = o.order_id
      left join jay_user u on u.user_id = o.user_id
      left join jay_user su on su.user_id = u.sid
    WHERE o.order_id = orderId and o.order_status=2;

    out_label: BEGIN
      IF @payamount > 0 THEN
        #2.查询上级虚拟账号
        IF @level < 2 THEN
          set @virtualpath = @supath;
        ELSE
          set @virtualpath = @path;
        END IF ;

        IF @virtualpath is NULL
          THEN
            leave out_label;
        END IF ;

        SET @userid_virtual = 0;
        SET @v_sql = CONCAT("select user_id into @userid_virtual from jay_user where FIND_IN_SET(user_id,'",@virtualpath,"') and reg_type=2 order by floor desc limit 1;");
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;

        # 今日tag
        SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
        # 当月tang
        SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');
        # 顺差
        set @suncha = @payamount-@totalsettle;
        set @maoli = @suncha-@commission;
        #1.统计虚拟号业绩
        IF @userid_virtual > 0 THEN
          set @recordId = addPerformance(@userid_virtual, 0, @payamount, @num, @suncha, @maoli);
          set @recordId = addPerformance(@userid_virtual, @month_tag, @payamount, @num, @suncha, @maoli);
          set @recordId = addPerformance(@userid_virtual, @day_tag, @payamount, @num, @suncha, @maoli);
        END IF ;
        #2.统计商品销量
        set @recordId = addProductPerformance(@productId, 0, @payamount, @num, @suncha, @maoli);
        set @recordId = addProductPerformance(@productId, @month_tag, @payamount, @num, @suncha, @maoli);
        set @recordId = addProductPerformance(@productId, @day_tag, @payamount, @num, @suncha, @maoli);

      END IF ;

    END out_label;

  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `merchant_daodian_income`
-- ----------------------------
DROP PROCEDURE IF EXISTS `merchant_daodian_income`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `merchant_daodian_income`(in consumeCodeId int, in merchantId int, OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @orderId = 0;
    SET @price = 0;
    SET @settle = 0;
    SET @num = 0;
    SET @priceType = 0;
    SET @totalmoney = 0;
    SET @totalsettle = 0;
    SET @addprice = 0;
    SET @raction = 901;
    #1.查询电子码
    SELECT op.price,op.settle,op.num,op.price_type,o.order_id,op.totalsettle,op.totalmoney,IFNULL(r.reservation_addprice,0) into @price,@settle,@num,@priceType,@orderId,@totalsettle,@totalmoney,@addprice from jay_order_consumption cp
      left join jay_order_consume_code c on c.consume_code_id = cp.consume_code_id
      left join jay_order o on o.order_id = cp.order_id
      left join jay_order_product op on op.order_id = o.order_id
      left join jay_order_user_reservation r on r.consume_code_id = cp.consume_code_id
    where cp.consume_code_id = consumeCodeId and cp.merchant_id = merchantId and o.merchant_id = merchantId;

    out_label: BEGIN
      #是否存在这个订单
      if @orderId=0 or @num=0 then
        leave out_label;
      end if;
      #计算给商家的钱
      if @priceType=1 then
        SET @totalMoney = @settle;
      elseif @priceType=2 then
        SET @totalMoney = @totalsettle;
      end if;
      IF @totalMoney > 0 THEN
        #4.初始化商家账户实时余额记录
        # 今日tag
        SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
        # 当月tang
        SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');
        #5.更新实时统计
        set @getMoney = @totalMoney+@addprice;
        SET @recordId = fuc_merchant_account(merchantId, 0, @getMoney);
        SET @recordId = fuc_merchant_account(merchantId, @month_tag, @getMoney);
        SET @recordId = fuc_merchant_account(merchantId, @day_tag, @getMoney);

        #8.记录日志
        set @balance = 0;
        SELECT account_cash_balance into @balance from jay_merchant_account where merchant_id = merchantId and account_tag=0;
        SET @sql1 = CONCAT('INSERT IGNORE INTO `jay_merchant_account',@month_tag,'`(merchant_id,record_action,record_amount,record_balance,record_attach,record_remark,record_addtime) VALUES (');
        SET @sql1 = CONCAT(@sql1, merchantId,',');
        SET @sql1 = CONCAT(@sql1, @raction,',');
        SET @sql1 = CONCAT(@sql1, @getMoney, ',');
        SET @sql1 = CONCAT(@sql1, @balance,',');
        SET @sql1 = CONCAT(@sql1, "'{\"orderId\":\"",@orderId,"\",\"amount\":\"",@getMoney,"\",\"num\":\"",@num,"\",\"addprice\":\"",@addprice,"\"}',");
        SET @sql1 = CONCAT(@sql1, "'订单完成结算',");
        SET @sql1 = CONCAT(@sql1, UNIX_TIMESTAMP(),");");
        PREPARE statement FROM @sql1;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;

      END IF ;

    END out_label;

  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `merchant_kuaidi_income`
-- ----------------------------
DROP PROCEDURE IF EXISTS `merchant_kuaidi_income`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `merchant_kuaidi_income`(in orderId int, OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @orderId = 0;
    SET @price = 0;
    SET @settle = 0;
    SET @num = 0;
    SET @priceType = 0;
    SET @totalmoney = 0;
    SET @totalsettle = 0;
    SET @merchantId = 0;
    SET @raction = 902;
    #1.查询订单
    SELECT op.price,op.settle,op.num,op.price_type,o.order_id,op.totalsettle,op.totalmoney,o.merchant_id into @price,@settle,@num,@priceType,@orderId,@totalsettle,@totalmoney,@merchantId from jay_order o
      left join jay_order_product op on op.order_id = o.order_id
      WHERE o.order_id = orderId and o.order_status=4;

    out_label: BEGIN

      IF @totalsettle > 0 THEN
        #4.初始化商家账户实时余额记录
        # 今日tag
        SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
        # 当月tang
        SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');

        SET @recordId = fuc_merchant_account(@merchantId, 0, @totalsettle);
        SET @recordId = fuc_merchant_account(@merchantId, @month_tag, @totalsettle);
        SET @recordId = fuc_merchant_account(@merchantId, @day_tag, @totalsettle);

        #8.记录日志
        set @balance = 0;
        SELECT account_cash_balance into @balance from jay_merchant_account where merchant_id = @merchantId and account_tag=0;
        SET @sql1 = CONCAT('INSERT IGNORE INTO `jay_merchant_account',@month_tag,'`(merchant_id,record_action,record_amount,record_balance,record_attach,record_remark,record_addtime) VALUES (');
        SET @sql1 = CONCAT(@sql1, @merchantId,',');
        SET @sql1 = CONCAT(@sql1, @raction,',');
        SET @sql1 = CONCAT(@sql1, @totalsettle, ',');
        SET @sql1 = CONCAT(@sql1, @balance,',');
        SET @sql1 = CONCAT(@sql1, "'{\"orderId\":\"",@orderId,"\",\"amount\":\"",@totalsettle,"\",\"num\":\"",@num,"\"}',");
        SET @sql1 = CONCAT(@sql1, "'确认收货结算给商家',");
        SET @sql1 = CONCAT(@sql1, UNIX_TIMESTAMP(),");");
        PREPARE statement FROM @sql1;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;
      END IF ;

    END out_label;

  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `TimerTask_cancelOrder`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_cancelOrder`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimerTask_cancelOrder`(OUT error INT)
BEGIN

    declare done int default 0;
    declare orderId int default 0;
    declare priceId int default 0;
    declare pricecalendarId int default 0;
    declare priceType int default 0;
    declare num int default 0;
    declare productId int default 0;
    #获取要统计的用户id
    declare orderlist cursor for select * from view_forexpireorder;
    declare continue handler for not found set done = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @execStarttime = UNIX_TIMESTAMP();

    #开启事务
    START TRANSACTION ;
    out_label: BEGIN
      OPEN orderlist;
      repeat
        FETCH orderlist INTO orderId,priceId,pricecalendarId,priceType,num,productId;
        IF NOT done THEN
          #1.取消订单
          SET @v_sql = CONCAT('UPDATE jay_order SET order_status = 0, order_uptime=UNIX_TIMESTAMP() ');
          SET @v_sql = CONCAT(@v_sql, ' WHERE order_id = ', orderId);
          PREPARE statement FROM @v_sql;
          EXECUTE statement;
          DEALLOCATE PREPARE statement;
          #2.更新已购库存
          IF priceType = 1
            THEN
              SET @v_sql = CONCAT('UPDATE jay_product_price SET product_buynum = product_buynum- ', num);
              SET @v_sql = CONCAT(@v_sql, ' WHERE price_id = ', priceId);
              PREPARE statement FROM @v_sql;
              EXECUTE statement;
              DEALLOCATE PREPARE statement;
            ELSE
              SET @v_sql = CONCAT('UPDATE jay_product_pricecalendar SET product_buynum = product_buynum- ', num);
              SET @v_sql = CONCAT(@v_sql, ' WHERE calendar_id in (', pricecalendarId, ')');
              PREPARE statement FROM @v_sql;
              EXECUTE statement;
              DEALLOCATE PREPARE statement;
          end if;
          #更新商品
          SET @v_sql = CONCAT('UPDATE jay_product SET sold_out = 0,sold_out_time=0,product_sales_volume=product_sales_volume-',num,' where product_id = ', productId);
          PREPARE statement FROM @v_sql;
          EXECUTE statement;
          DEALLOCATE PREPARE statement;

        END IF;
      until done end repeat;
      close orderlist;#关闭释放资源
    END out_label;

    #提交事务
    IF error = 1
    THEN
      ROLLBACK ;
    ELSE
      COMMIT ;
    END IF ;

    #记录执行日志
    set @logId = addTimerlog('TimerTask_cancelOrder', error, @execStarttime);

  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `TimerTask_ciriJiesuan`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_ciriJiesuan`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimerTask_ciriJiesuan`(out error int)
BEGIN

  declare orderId int default 0;
  declare userId int default 0;
  declare recordAmount DECIMAL(10,2) default 0;
  declare recordAttach VARCHAR(800) default '';
  declare done int default 0;
  DECLARE recordlist CURSOR FOR SELECT * FROM view_forJiesuanOneAndOne order by user_id asc limit 1000;
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
  SET @today_befor_time = UNIX_TIMESTAMP(FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y-%m-%d'));
  SET @execStarttime = UNIX_TIMESTAMP();

  #开启事务
  START TRANSACTION ;
  out_label: BEGIN
    OPEN recordlist;
    repeat
      FETCH recordlist INTO orderId,userId,recordAmount,recordAttach;
      IF NOT done THEN
        #1.结算佣金
        call jiesuan_commissionToCashOneAndOne(userId, orderId, recordAmount, recordAttach, @taxfee_fuwu, @taxfee_geren, @taxfee_pingtai, error);
        if error then
          leave out_label;
        end if;

        #2.更新结算状态
        SET @v_sql = CONCAT('UPDATE jay_account_commission', @lastmoth_tag, ' SET record_status = 2 ');
        SET @v_sql = CONCAT(@v_sql, ' WHERE user_id = ', userId);
        SET @v_sql = CONCAT(@v_sql, ' AND order_id = ', orderId);
        SET @v_sql = CONCAT(@v_sql, ' AND record_status = 1');
        PREPARE statement FROM @v_sql;
        EXECUTE statement;
        DEALLOCATE PREPARE statement;

        SET @v_sql = CONCAT('UPDATE jay_account_commission', @moth_tag, ' SET record_status = 2 ');
        SET @v_sql = CONCAT(@v_sql, ' WHERE user_id = ', userId);
        SET @v_sql = CONCAT(@v_sql, ' AND order_id = ', orderId);
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
  set @logId = addTimerlog('TimerTask_ciriJiesuan', error, @execStarttime);
  #判断是否还要继续执行
  SET @shengyu = 0;
  select count(*) into @shengyu from view_forJiesuanOneAndOne;
  IF @shengyu > 0
    THEN
    call TimerTask_ciriJiesuan(@error);
  END IF ;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `Timertask_lewan_pt_income`
-- ----------------------------
DROP PROCEDURE IF EXISTS `Timertask_lewan_pt_income`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Timertask_lewan_pt_income`(OUT error INT)
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
-- Procedure structure for `TimerTask_recordtable`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_recordtable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimerTask_recordtable`(OUT error INT)
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
    SET @v_sql = CONCAT(@v_sql, ' WHERE record_action in (606,604,607,609) and record_status = 1 ');
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
-- Procedure structure for `TimerTask_upAccountMonth`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_upAccountMonth`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimerTask_upAccountMonth`(OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @execStarttime = UNIX_TIMESTAMP();
    #1.创建临时表
    DROP TABLE IF EXISTS `temp_account0`;
    CREATE TABLE `temp_account0` as SELECT user_id from jay_account where account_tag=0 order by user_id asc;
    set @logId = addTimerlog('TimerTask_upAccountMonth', error, @execStarttime);

    #2.执行统计
    call tj_lastMonthAccount(@error);
  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `TimerTask_userFinance`
-- ----------------------------
DROP PROCEDURE IF EXISTS `TimerTask_userFinance`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimerTask_userFinance`(OUT error INT)
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
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(withdraw.amount,0) finance_withdraw , ");
        SET @tbgpsql = CONCAT(@tbgpsql, " IFNULL(recharge.amount,0) finance_recharge , ");
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
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action in (850, 851, 852) GROUP BY user_id order by null) as withdraw on withdraw.user_id = m.user_id ");
        SET @tbgpsql = CONCAT(@tbgpsql, " left join (select abs(sum(record_amount)) amount, user_id from temp_record_finance_table where record_action = 801 GROUP BY user_id order by null) as recharge on recharge.user_id = m.user_id ");
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
        SET @up0sql = CONCAT(@up0sql, " f.finance_first = f.finance_first + g.finance_first, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_hanldfee = f.finance_hanldfee + g.finance_hanldfee, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operationchilds = f.finance_operationchilds + g.finance_operationchilds, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_operations = f.finance_operations + g.finance_operations, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhost = f.finance_playerhost + g.finance_playerhost, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_playerhostzhishu = f.finance_playerhostzhishu + g.finance_playerhostzhishu, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_recharge = f.finance_recharge + g.finance_recharge, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_second = f.finance_second + g.finance_second, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_settle = f.finance_settle + g.finance_settle, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_taxfee = f.finance_taxfee + g.finance_taxfee, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_withdraw = f.finance_withdraw + g.finance_withdraw ");
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
        SET @up0sql = CONCAT(@up0sql, " f.finance_taxfee = f.finance_taxfee + g.finance_taxfee, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_withdraw = f.finance_withdraw + g.finance_withdraw ");
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
        SET @up0sql = CONCAT(@up0sql, " f.finance_taxfee = f.finance_taxfee + g.finance_taxfee, ");
        SET @up0sql = CONCAT(@up0sql, " f.finance_withdraw = f.finance_withdraw + g.finance_withdraw ");
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

-- ----------------------------
-- Procedure structure for `Timertask_user_tongji`
-- ----------------------------
DROP PROCEDURE IF EXISTS `Timertask_user_tongji`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Timertask_user_tongji`(OUT error INT)
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
    SET @yesterday_tag2 = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y-%m-%d');
    # 昨日的月份tag
    SET @yesterdaymonth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 DAY), '%Y%m');
    #1.初始化记录

    INSERT IGNORE INTO jay_user_tongji(tag) VALUES (@yesterdaymonth_tag);
    INSERT IGNORE INTO jay_user_tongji(tag) VALUES (@yesterday_tag);

    ######################总数###########################
    #1.浏览次数
    SET @viewtimes = 0;
    SET @v_sql = CONCAT('select sum(viewtimes_everyday) into @viewtimes from jay_user;');
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #2.用户总数
    SET @userallcount = 0;
    SET @v_sql = CONCAT("select count(*) into @userallcount from jay_user where reg_time < UNIX_TIMESTAMP('",@yesterday_tag2,"');");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #4.新增普通会员总数
    SET @user1count = 0;
    SET @v_sql = CONCAT("select count(*) into @user1count from jay_user where `level`=1 and FROM_UNIXTIME(upgrade_time,'%Y%m%d')='",@yesterday_tag,"';");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #5.新增超级会员总数
    SET @user2count = 0;
    SET @v_sql = CONCAT("select count(*) into @user2count from jay_user where `level`=2 and FROM_UNIXTIME(upgrade_time,'%Y%m%d')='",@yesterday_tag,"';");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #6.新增分享达人总数
    SET @user3count = 0;
    SET @v_sql = CONCAT("select count(*) into @user3count from jay_user where `level`=3 and FROM_UNIXTIME(upgrade_time,'%Y%m%d')='",@yesterday_tag,"';");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #7.新增运营达人总数
    SET @user4count = 0;
    SET @v_sql = CONCAT("select count(*) into @user4count from jay_user where `level`=4 and FROM_UNIXTIME(upgrade_time,'%Y%m%d')='",@yesterday_tag,"';");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #8.新增玩主总数
    SET @user5count = 0;
    SET @v_sql = CONCAT("select count(*) into @user5count from jay_user where `level`=5 and FROM_UNIXTIME(upgrade_time,'%Y%m%d')='",@yesterday_tag,"';");
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #***************************************更新统计数据***********************************************
    #do-2.当月统计
    SET @v_sql = CONCAT('UPDATE jay_user_tongji SET viewtimes = ', @viewtimes);
    SET @v_sql = CONCAT(@v_sql, ' ,userallcount = ', @userallcount);
    SET @v_sql = CONCAT(@v_sql, ' ,user1count = ', @user1count);
    SET @v_sql = CONCAT(@v_sql, ' ,user2count = ', @user2count);
    SET @v_sql = CONCAT(@v_sql, ' ,user3count = ', @user3count);
    SET @v_sql = CONCAT(@v_sql, ' ,user4count = ', @user4count);
    SET @v_sql = CONCAT(@v_sql, ' ,user5count = ', @user5count);
    SET @v_sql = CONCAT(@v_sql, ' WHERE tag = ', @yesterday_tag);
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    #do-3.昨日统计
    SET @v_sql = CONCAT('UPDATE jay_user_tongji SET viewtimes = viewtimes+', @viewtimes);
    SET @v_sql = CONCAT(@v_sql, ' ,userallcount = ', @userallcount);
    SET @v_sql = CONCAT(@v_sql, ' ,user1count = user1count+ ', @user1count);
    SET @v_sql = CONCAT(@v_sql, ' ,user2count = user2count+', @user2count);
    SET @v_sql = CONCAT(@v_sql, ' ,user3count = user3count+', @user3count);
    SET @v_sql = CONCAT(@v_sql, ' ,user4count = user4count+', @user4count);
    SET @v_sql = CONCAT(@v_sql, ' ,user5count = user5count+', @user5count);
    SET @v_sql = CONCAT(@v_sql, ' WHERE tag = ', @yesterdaymonth_tag);
    PREPARE statement FROM @v_sql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;
    #重置每日浏览量
    update jay_user set viewtimes_everyday = 0;

    #记录执行日志
    set @logId = addTimerlog('Timertask_user_tongji', error, @execStarttime);
  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `Timer_order_autodelivery`
-- ----------------------------
DROP PROCEDURE IF EXISTS `Timer_order_autodelivery`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Timer_order_autodelivery`(OUT error INT)
BEGIN

    declare done int default 0;
    declare orderId int default 0;
    #获取要统计的用户id
    declare orderList cursor for select order_id from jay_order where order_isexpress=2 and order_reservation > 1 and order_status = 3 and delivery_time + 604800 < UNIX_TIMESTAMP();
    declare continue handler for not found set done = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    #开启事务
    START TRANSACTION ;
    out_label: BEGIN
      OPEN orderList;
      repeat
        FETCH orderList INTO orderId;
        IF NOT done THEN
          update jay_order set order_status = 4,order_uptime=UNIX_TIMESTAMP() where order_id=orderId;
          call merchant_kuaidi_income(orderId, error);
        END IF;
      until done end repeat;
      close orderList;#关闭释放资源
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

-- ----------------------------
-- Procedure structure for `tj_lastMonthAccount`
-- ----------------------------
DROP PROCEDURE IF EXISTS `tj_lastMonthAccount`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tj_lastMonthAccount`(OUT error INT)
BEGIN

    declare done int default 0;
    declare userId int default 0;
    #获取要统计的用户id
    declare userlist cursor for select user_id from temp_account0 order by user_id asc limit 1000;
    declare continue handler for not found set done = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    # 递归层级
    SET @@max_sp_recursion_depth = 5000;
    SET @lastUserId = 0;
    SET @day_tag = FROM_UNIXTIME(UNIX_TIMESTAMP(), '%Y%m%d');
    # 上月tag
    SET @lastmoth_tag = DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 MONTH), '%Y%m');
    # 上月第一天
    SET @lastmoth_1day = CONCAT(DATE_FORMAT(DATE_ADD(@day_tag, INTERVAL -1 MONTH), '%Y%m'),'01');
    # 本月第一天
    SET @month_tag = FROM_UNIXTIME(unix_timestamp(), '%Y%m');
    SET @lastmonth_endday = CONCAT(@month_tag,'01');
    SET @execStarttime = UNIX_TIMESTAMP();
    #开启事务
    START TRANSACTION;
    #1.创建临时表:统计每一个用户的收支
    SET @tbsql = CONCAT("create TABLE temp_account_table AS select ");
    SET @tbsql = CONCAT(@tbsql, "NULL AS account_id, ");
    SET @tbsql = CONCAT(@tbsql, "user_id, ");
    SET @tbsql = CONCAT(@tbsql, "sum(account_cash_expenditure) account_cash_expenditure, ");
    SET @tbsql = CONCAT(@tbsql, "sum(account_cash_income) account_cash_income, ");
    SET @tbsql = CONCAT(@tbsql, " account_cash_balance, ");
    SET @tbsql = CONCAT(@tbsql, "sum(account_commission_expenditure) account_commission_expenditure, ");
    SET @tbsql = CONCAT(@tbsql, "sum(account_commission_income) account_commission_income, ");
    SET @tbsql = CONCAT(@tbsql, " account_commission_balance, ");
    SET @tbsql = CONCAT(@tbsql, "sum(account_points_expenditure) account_points_expenditure, ");
    SET @tbsql = CONCAT(@tbsql, "sum(account_points_income) account_points_income , ");
    SET @tbsql = CONCAT(@tbsql, " account_points_balance, ");
    SET @tbsql = CONCAT(@tbsql, @lastmoth_tag," as account_tag, ");
    SET @tbsql = CONCAT(@tbsql, "UNIX_TIMESTAMP() as account_uptime ");
    SET @tbsql = CONCAT(@tbsql, "from jay_account ");
    SET @tbsql = CONCAT(@tbsql, "where account_tag < ",@lastmonth_endday," and account_tag >= ", @lastmoth_1day, " ");
    SET @tbsql = CONCAT(@tbsql, "GROUP BY user_id; ");
    PREPARE statement FROM @tbsql;
    EXECUTE statement;
    DEALLOCATE PREPARE statement;

    out_label: BEGIN
      open userlist;
      repeat
        FETCH userlist INTO userId;
        IF not done
          THEN
            BEGIN
                #2.查询余额
                set @account_cash_balance = 0;
                set @account_points_balance = 0;
                set @account_commission_balance = 0;
                SET @v_sql = CONCAT('select account_cash_balance,account_commission_balance,account_points_balance into @account_cash_balance, @account_commission_balance, @account_points_balance  from jay_account where account_tag < ',@lastmonth_endday,' and user_id=',userId,' order by account_tag desc limit 1;');
                PREPARE statement FROM @v_sql;
                EXECUTE statement;
                DEALLOCATE PREPARE statement;

                #3.更新余额
                SET @uptbsql = CONCAT("update temp_account_table set account_cash_balance=",@account_cash_balance,", account_commission_balance=",@account_commission_balance,", account_points_balance=",@account_points_balance," where user_id=", userId);
                PREPARE statement FROM @uptbsql;
                EXECUTE statement;
                DEALLOCATE PREPARE statement;

                set @lastUserId = userId;
            END ;
        END IF ;
      until done end repeat;
      close userlist;#关闭释放资源

      #4.插入记录
      SET @insql = "insert IGNORE into jay_account(";
      SET @insql = CONCAT(@insql, " account_id,user_id, ");
      SET @insql = CONCAT(@insql, " account_cash_expenditure,account_cash_income,account_cash_balance, ");
      SET @insql = CONCAT(@insql, " account_commission_expenditure,account_commission_income,account_commission_balance, ");
      SET @insql = CONCAT(@insql, " account_points_expenditure,account_points_income,account_points_balance, ");
      SET @insql = CONCAT(@insql, " account_tag,account_uptime ");
      SET @insql = CONCAT(@insql, " ) ");
      SET @insql = CONCAT(@insql, " select * from temp_account_table; ");
      PREPARE statement FROM @insql;
      EXECUTE statement;
      DEALLOCATE PREPARE statement;

      #删除临时表
      SET @v_sql = CONCAT('DROP TABLE IF EXISTS temp_account_table;');
      PREPARE statement FROM @v_sql;
      EXECUTE statement;
      DEALLOCATE PREPARE statement;

      #删除1000条数据
      SET @v_sql = CONCAT("delete from temp_account0 where user_id <=", @lastUserId);
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

    set @logId = addTimerlog('tj_lastMonthAccount', error, @execStarttime);
    #判断是否还要继续执行
    SET @shengyu = 0;
    select count(*) into @shengyu from temp_account0;
    IF @shengyu > 0
    THEN
      call tj_lastMonthAccount(@error);
    END IF ;

  END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for `update_account`
-- ----------------------------
DROP PROCEDURE IF EXISTS `update_account`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_account`(in `userId` int, in `currenty` varchar(20), in `amount` DECIMAL(10,2), in orderId int, in action int, in attach varchar(800), in remark varchar(50),  out error int, out recordId int)
BEGIN

  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
  SET error = 0;
  set @currenty = currenty;
  SET @tag_today = from_unixtime(UNIX_TIMESTAMP(), '%Y%m%d');
  SET @field_balance = CONCAT('account_', @currenty, '_balance');
  SET @field_expenditure = CONCAT('account_', @currenty, '_expenditure');
  SET @field_income = CONCAT('account_', @currenty, '_income');

  #1.初始化用户实时收支数据
  INSERT IGNORE INTO jay_account (user_id, account_tag, account_uptime) VALUES (userId, 0, UNIX_TIMESTAMP());
  #2.初始化用户日收支数据
  INSERT IGNORE INTO jay_account (
    user_id,
    account_cash_balance,
    account_commission_balance,
    account_points_balance,
    account_tag,
    account_uptime)
    SELECT user_id, account_cash_balance, account_commission_balance, account_points_balance, @tag_today, UNIX_TIMESTAMP() FROM jay_account WHERE user_id = userId AND account_tag=0;

  #3.获取账户余额
  SET @old_balance = 0;
  SET @v_sql = CONCAT('SELECT ', @field_balance, ' INTO @old_balance FROM jay_account WHERE
                          account_tag = 0 AND user_id = ', userId, ' LIMIT 1;');
      PREPARE statement FROM @v_sql;
      EXECUTE statement;
      DEALLOCATE PREPARE statement;

  #4.更新用户实时收支总计和余额
  SET @v_sql = CONCAT('UPDATE jay_account SET
        ', @field_balance, ' = ', @field_balance, ' + ', amount, ',
        ', @field_expenditure, ' = ', @field_expenditure, ' + ', IF(amount < 0, amount, 0), ',
        ', @field_income, ' = ', @field_income, ' + ', IF(amount > 0, amount, 0), ',
        account_uptime = ', UNIX_TIMESTAMP(), '
        WHERE user_id = ', userId, ' AND account_tag = 0');
      PREPARE statement FROM @v_sql;
      EXECUTE statement;
      DEALLOCATE PREPARE statement;


  #5.更新用户当日收支总计和余额
  SET @v_sql = CONCAT('UPDATE jay_account SET
        ', @field_balance, ' = ', @field_balance, ' + ', amount, ',
        ', @field_expenditure, ' = ', @field_expenditure, ' + ', IF(amount < 0, amount, 0), ',
        ', @field_income, ' = ', @field_income, ' + ', IF(amount > 0, amount, 0), ',
        account_uptime = ', UNIX_TIMESTAMP(), '
        WHERE user_id = ', userId, ' AND account_tag = ',@tag_today);
      PREPARE statement FROM @v_sql;
      EXECUTE statement;
      DEALLOCATE PREPARE statement;

  #6.记录日志
  call insert_account_record(userId, orderId, currenty, action, amount, (@old_balance + amount), UNIX_TIMESTAMP(), attach, remark, 2, error, recordId);
END
;;
DELIMITER ;




-- ----------------------------
-- View structure for `view_forexpireorder`
-- ----------------------------
DROP VIEW IF EXISTS `view_forexpireorder`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_forexpireorder` AS select `o`.`order_id` AS `order_id`,ifnull(`p`.`price_id`,0) AS `price_id`,ifnull(`p`.`pricecalendar_id`,0) AS `pricecalendar_id`,`p`.`price_type` AS `price_type`,`p`.`num` AS `num`,`p`.`product_id` AS `product_id` from (`jay_order` `o` left join `jay_order_product` `p` on((`p`.`order_id` = `o`.`order_id`))) where ((`o`.`order_status` = 1) and (`o`.`order_addtime` < (unix_timestamp() - 1800))) ;



-- ----------------------------
-- View structure for `view_orderfinance`
-- ----------------------------
DROP VIEW IF EXISTS `view_orderfinance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `view_orderfinance` AS select `o`.`order_id` AS `order_id`,`o`.`order_no` AS `order_no`,`o`.`order_transaction` AS `order_transaction`,`o`.`order_fullname` AS `order_fullname`,`o`.`order_mobile` AS `order_mobile`,`o`.`order_totalfee` AS `order_totalfee`,`o`.`order_isexpress` AS `order_isexpress`,`a`.`cash` AS `cash`,`a`.`coupon` AS `coupon`,`a`.`payamount` AS `payamount`,`m`.`merchant_name` AS `merchant_name`,`o`.`order_payment` AS `order_payment`,`o`.`order_addtime` AS `order_addtime`,`o`.`order_paytime` AS `order_paytime`,`p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,`p`.`product_property` AS `product_property`,`p`.`num` AS `num`,`p`.`price` AS `price`,`p`.`settle` AS `settle`,`p`.`totalmoney` AS `totalmoney`,`p`.`totalsettle` AS `totalsettle`,ifnull(`p`.`commis_first`,0) AS `commis_first`,ifnull(`p`.`commis_second`,0) AS `commis_second`,ifnull(`p`.`commis_operations`,0) AS `commis_operations`,ifnull(`p`.`commis_operations_child`,0) AS `commis_operations_child`,ifnull(`p`.`commis_playerhost_child`,0) AS `commis_playerhost_child`,`p1`.`catefinance_id` AS `catefinance_id`,`o`.`order_refundstatus` AS `order_refundstatus`,`rf`.`refund_uptime` AS `refund_uptime` from (((((`jay_order` `o` left join `jay_order_affiliated` `a` on((`a`.`order_id` = `o`.`order_id`))) left join `jay_order_product` `p` on((`p`.`order_id` = `o`.`order_id`))) left join `jay_order_refund` `rf` on((`rf`.`order_id` = `o`.`order_id`))) left join `jay_product` `p1` on((`p1`.`product_id` = `p`.`product_id`))) left join `jay_merchant` `m` on((`m`.`merchant_id` = `o`.`merchant_id`))) where (`o`.`order_status` > 1) order by `o`.`order_id` desc;
-- ----------------------------
-- View structure for `view_ordermerchantdaodianfinance`
-- ----------------------------
DROP VIEW IF EXISTS `view_ordermerchantdaodianfinance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ordermerchantdaodianfinance` AS select `cp`.`consumption_id` AS `consumption_id`,`cp`.`addtime` AS `comsumeaddtime`,`cp`.`remark` AS `remark`,`r`.`reservation_payment` AS `reservation_payment`,`r`.`reservation_addprice` AS `reservation_addprice`,`o`.`order_id` AS `order_id`,`o`.`order_no` AS `order_no`,`c`.`consume_code` AS `consume_code`,`o`.`order_fullname` AS `order_fullname`,`o`.`order_mobile` AS `order_mobile`,`o`.`order_reservation` AS `order_reservation`,`o`.`order_totalfee` AS `order_totalfee`,`o`.`order_payment` AS `order_payment`,`o`.`order_paytime` AS `order_paytime`,`o`.`order_addtime` AS `order_addtime`,`a`.`cash` AS `cash`,`a`.`coupon` AS `coupon`,`a`.`payamount` AS `payamount`,`op`.`product_id` AS `product_id`,`op`.`product_name` AS `product_name`,`op`.`product_property` AS `product_property`,`op`.`num` AS `num`,`op`.`price` AS `price`,`op`.`settle` AS `settle`,`op`.`totalmoney` AS `totalmoney`,`op`.`totalsettle` AS `totalsettle`,ifnull(`op`.`commis_first`,0) AS `commis_first`,ifnull(`op`.`commis_second`,0) AS `commis_second`,ifnull(`op`.`commis_operations`,0) AS `commis_operations`,ifnull(`op`.`commis_operations_child`,0) AS `commis_operations_child`,ifnull(`op`.`commis_playerhost_child`,0) AS `commis_playerhost_child`,`op`.`userid_first` AS `userid_first`,`op`.`userid_second` AS `userid_second`,`op`.`userid_operations` AS `userid_operations`,`op`.`userid_operations_child` AS `userid_operations_child`,`op`.`userid_playerhost_child` AS `userid_playerhost_child`,`p`.`catefinance_id` AS `catefinance_id`,`m`.`merchant_name` AS `merchant_name` from (((((((`jay_order_consumption` `cp` left join `jay_order_user_reservation` `r` on((`r`.`reservation_id` = `cp`.`reservation_id`))) left join `jay_order_consume_code` `c` on((`c`.`consume_code_id` = `cp`.`consume_code_id`))) left join `jay_order` `o` on((`o`.`order_id` = `cp`.`order_id`))) left join `jay_order_affiliated` `a` on((`a`.`order_id` = `cp`.`order_id`))) left join `jay_order_product` `op` on((`op`.`order_id` = `cp`.`order_id`))) left join `jay_product` `p` on((`p`.`product_id` = `op`.`product_id`))) left join `jay_merchant` `m` on((`m`.`merchant_id` = `o`.`merchant_id`))) ;

-- ----------------------------
-- View structure for `view_ordermerchantkuaidifinance`
-- ----------------------------
DROP VIEW IF EXISTS `view_ordermerchantkuaidifinance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_ordermerchantkuaidifinance` AS select `o`.`order_id` AS `order_id`,`o`.`order_no` AS `order_no`,`o`.`order_fullname` AS `order_fullname`,`o`.`order_mobile` AS `order_mobile`,`o`.`order_totalfee` AS `order_totalfee`,`o`.`order_payment` AS `order_payment`,`o`.`order_paytime` AS `order_paytime`,`o`.`order_isexpress` AS `order_isexpress`,`o`.`order_reservation` AS `order_reservation`,`o`.`order_addtime` AS `order_addtime`,`a`.`cash` AS `cash`,`a`.`coupon` AS `coupon`,`a`.`payamount` AS `payamount`,`op`.`product_id` AS `product_id`,`op`.`product_name` AS `product_name`,`op`.`product_property` AS `product_property`,`op`.`num` AS `num`,`op`.`price` AS `price`,`op`.`settle` AS `settle`,`op`.`totalmoney` AS `totalmoney`,`op`.`totalsettle` AS `totalsettle`,ifnull(`op`.`commis_first`,0) AS `commis_first`,ifnull(`op`.`commis_second`,0) AS `commis_second`,ifnull(`op`.`commis_operations`,0) AS `commis_operations`,ifnull(`op`.`commis_operations_child`,0) AS `commis_operations_child`,ifnull(`op`.`commis_playerhost_child`,0) AS `commis_playerhost_child`,`op`.`userid_first` AS `userid_first`,`op`.`userid_second` AS `userid_second`,`op`.`userid_operations` AS `userid_operations`,`op`.`userid_operations_child` AS `userid_operations_child`,`op`.`userid_playerhost_child` AS `userid_playerhost_child`,`p`.`catefinance_id` AS `catefinance_id`,`m`.`merchant_name` AS `merchant_name` from ((((`jay_order` `o` left join `jay_order_affiliated` `a` on((`a`.`order_id` = `o`.`order_id`))) left join `jay_order_product` `op` on((`op`.`order_id` = `o`.`order_id`))) left join `jay_product` `p` on((`p`.`product_id` = `op`.`product_id`))) left join `jay_merchant` `m` on((`m`.`merchant_id` = `o`.`merchant_id`))) where ((`o`.`order_status` = 4) and (`o`.`order_isexpress` = 2)) ;


-- ----------------------------
-- Function structure for `addPerformance`
-- ----------------------------
DROP FUNCTION IF EXISTS `addPerformance`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `addPerformance`(userId int, tagstr int, amount DECIMAL(10,2), xiaoliang DECIMAL(10,2), shuncha DECIMAL(10,2), maoli DECIMAL(10,2)) RETURNS int(4)
    SQL SECURITY INVOKER
BEGIN

    INSERT IGNORE INTO jay_user_performance (user_id,tag) VALUES (userId, tagstr);
    UPDATE jay_user_performance SET pf_amount = pf_amount+amount,pf_xiaoliang=pf_xiaoliang+xiaoliang,pf_shuncha=pf_shuncha+shuncha,pf_maoli=pf_maoli+maoli where user_id=userId and tag=tagstr;
    RETURN LAST_INSERT_ID();
  END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `addProductPerformance`
-- ----------------------------
DROP FUNCTION IF EXISTS `addProductPerformance`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `addProductPerformance`(productId int, tagstr int, amount DECIMAL(10,2), xiaoliang DECIMAL(10,2), shuncha DECIMAL(10,2), maoli DECIMAL(10,2)) RETURNS int(4)
    SQL SECURITY INVOKER
BEGIN

    INSERT IGNORE INTO jay_product_performance (product_id,tag) VALUES (productId, tagstr);
    UPDATE jay_product_performance SET pf_amount = pf_amount+amount,pf_xiaoliang=pf_xiaoliang+xiaoliang,pf_shuncha=pf_shuncha+shuncha,pf_maoli=pf_maoli+maoli where product_id=productId and tag=tagstr;
    RETURN LAST_INSERT_ID();
  END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `addTimerlog`
-- ----------------------------
DROP FUNCTION IF EXISTS `addTimerlog`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `addTimerlog`(pname VARCHAR(50), errorstatis int, stime int) RETURNS int(4)
    SQL SECURITY INVOKER
BEGIN

    INSERT INTO jay_timer_log(procedurename, `error`, starttime, addtime) VALUES (pname, errorstatis, stime, UNIX_TIMESTAMP());
    RETURN LAST_INSERT_ID();

END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `fuc_manage_finance`
-- ----------------------------
DROP FUNCTION IF EXISTS `fuc_manage_finance`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fuc_manage_finance`(tagstr int, amount DECIMAL(10,2)) RETURNS int(4)
    SQL SECURITY INVOKER
BEGIN

    INSERT IGNORE INTO jay_manage_finance (total_tag) VALUES (tagstr);
    UPDATE jay_manage_finance SET total_order_addfee = total_order_addfee + amount WHERE total_tag = tagstr;
    RETURN LAST_INSERT_ID();
  END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `fuc_merchant_account`
-- ----------------------------
DROP FUNCTION IF EXISTS `fuc_merchant_account`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fuc_merchant_account`(merchantId int, tagstr int, amount DECIMAL(10,2)) RETURNS int(4)
    SQL SECURITY INVOKER
BEGIN
    INSERT IGNORE INTO jay_merchant_account (merchant_id, account_tag, account_uptime) VALUES (merchantId, tagstr, UNIX_TIMESTAMP());
    UPDATE jay_merchant_account SET account_cash_income = account_cash_income+ amount ,account_cash_balance=account_cash_balance+ amount WHERE merchant_id =merchantId and account_tag = tagstr;
    RETURN LAST_INSERT_ID();
  END
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_autodelivery`
-- ----------------------------
DROP EVENT IF EXISTS `timer_autodelivery`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_autodelivery` ON SCHEDULE EVERY 2 HOUR STARTS '2018-11-23 15:38:25' ON COMPLETION PRESERVE ENABLE DO call Timer_order_autodelivery(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_cancelorder`
-- ----------------------------
DROP EVENT IF EXISTS `timer_cancelorder`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_cancelorder` ON SCHEDULE EVERY 5 MINUTE STARTS '2018-10-10 00:00:00' ON COMPLETION PRESERVE ENABLE DO call TimerTask_cancelOrder(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_cirijiesuan`
-- ----------------------------
DROP EVENT IF EXISTS `timer_cirijiesuan`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_cirijiesuan` ON SCHEDULE EVERY 1 DAY STARTS '2018-09-20 00:01:00' ON COMPLETION PRESERVE ENABLE DO call TimerTask_ciriJiesuan(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_createtable`
-- ----------------------------
DROP EVENT IF EXISTS `timer_createtable`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_createtable` ON SCHEDULE EVERY 1 MONTH STARTS '2018-09-01 00:00:01' ON COMPLETION PRESERVE ENABLE DO call TimerTask_recordtable(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_manage_income`
-- ----------------------------
DROP EVENT IF EXISTS `timer_manage_income`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_manage_income` ON SCHEDULE EVERY 1 DAY STARTS '2018-11-01 00:03:00' ON COMPLETION PRESERVE ENABLE DO call Timertask_lewan_pt_income(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_userfinance`
-- ----------------------------
DROP EVENT IF EXISTS `timer_userfinance`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_userfinance` ON SCHEDULE EVERY 1 DAY STARTS '2018-09-10 05:00:00' ON COMPLETION PRESERVE ENABLE DO call TimerTask_userFinance(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_userlashmonthaccount`
-- ----------------------------
DROP EVENT IF EXISTS `timer_userlashmonthaccount`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_userlashmonthaccount` ON SCHEDULE EVERY 1 MONTH STARTS '2018-09-01 02:00:01' ON COMPLETION PRESERVE ENABLE DO call TimerTask_upAccountMonth(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_usertongji`
-- ----------------------------
DROP EVENT IF EXISTS `timer_usertongji`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_usertongji` ON SCHEDULE EVERY 1 DAY STARTS '2018-12-02 00:02:00' ON COMPLETION PRESERVE ENABLE DO call Timertask_user_tongji(@error)
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_yuyueexpired`
-- ----------------------------
DROP EVENT IF EXISTS `timer_yuyueexpired`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` EVENT `timer_yuyueexpired` ON SCHEDULE EVERY 1 DAY STARTS '2018-11-09 17:45:42' ON COMPLETION PRESERVE ENABLE DO update jay_order_user_reservation r,jay_order_consume_code c set r.reservation_status = 3, c.`status`=3
  where r.consume_code_id = c.consume_code_id and r.reservation_status=1 and UNIX_TIMESTAMP()-86400 > r.reservation_calendar
;;
DELIMITER ;

-- ----------------------------
-- Event structure for `timer_zidongxiajia`
-- ----------------------------
DROP EVENT IF EXISTS `timer_zidongxiajia`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` EVENT `timer_zidongxiajia`
ON SCHEDULE EVERY 5 MINUTE STARTS '2018-12-12 21:00:00' ON COMPLETION PRESERVE ENABLE DO
update jay_product set sold_out = 1, sold_out_time=UNIX_TIMESTAMP() where sold_out=0 and product_timelimit=1 and product_endtime < UNIX_TIMESTAMP();
;;
DELIMITER ;