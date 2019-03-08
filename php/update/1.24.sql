update jay_order_product set commis_free = totalmoney where product_returnall=1;

DROP VIEW IF EXISTS `view_ordermerchantdaodianfinance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`lewan2018`@`%` SQL SECURITY DEFINER VIEW `view_ordermerchantdaodianfinance` AS
select `cp`.`consumption_id` AS `consumption_id`,`cp`.`addtime` AS `comsumeaddtime`,`cp`.`remark` AS `remark`,`r`.`reservation_payment` AS `reservation_payment`,
`r`.`reservation_addprice` AS `reservation_addprice`,`o`.`order_id` AS `order_id`,`o`.`order_no` AS `order_no`,
`c`.`consume_code` AS `consume_code`,`o`.`order_fullname` AS `order_fullname`,`o`.`order_mobile` AS `order_mobile`,
`o`.`order_reservation` AS `order_reservation`,`o`.`order_totalfee` AS `order_totalfee`,`o`.`order_payment` AS `order_payment`,
`o`.`order_paytime` AS `order_paytime`,`o`.`order_addtime` AS `order_addtime`,`a`.`cash` AS `cash`,`a`.`coupon` AS `coupon`,
`a`.`payamount` AS `payamount`,`op`.`product_id` AS `product_id`,`op`.`product_name` AS `product_name`,`op`.`product_property` AS `product_property`,`op`.`num` AS `num`,
`op`.`price` AS `price`,`op`.`settle` AS `settle`,`op`.`totalmoney` AS `totalmoney`,`op`.`totalsettle` AS `totalsettle`,ifnull(`op`.`commis_free`,0) AS `commis_free`,
ifnull(`op`.`commis_first`,0) AS `commis_first`,
ifnull(`op`.`commis_second`,0) AS `commis_second`,ifnull(`op`.`commis_operations`,0) AS `commis_operations`,ifnull(`op`.`commis_operations_child`,0) AS `commis_operations_child`,
ifnull(`op`.`commis_playerhost_child`,0) AS `commis_playerhost_child`,ifnull(`op`.`commis_playerhost_zhishu`,0) AS `commis_playerhost_zhishu`,
`p`.`catefinance_id` AS `catefinance_id`,`m`.`merchant_name` AS `merchant_name`,
`o`.`order_refundstatus` AS `order_refundstatus`,`rf`.`refund_uptime` AS `refund_uptime`
from ((((((((`jay_order_consumption` `cp` left join `jay_order_user_reservation` `r` on((`r`.`reservation_id` = `cp`.`reservation_id`)))
left join `jay_order_consume_code` `c` on((`c`.`consume_code_id` = `cp`.`consume_code_id`)))
left join `jay_order` `o` on((`o`.`order_id` = `cp`.`order_id`)))
left join `jay_order_refund` `rf` on((`rf`.`order_id` = `o`.`order_id`)))
left join `jay_order_affiliated` `a` on((`a`.`order_id` = `cp`.`order_id`)))
left join `jay_order_product` `op` on((`op`.`order_id` = `cp`.`order_id`)))
left join `jay_product` `p` on((`p`.`product_id` = `op`.`product_id`)))
left join `jay_merchant` `m` on((`m`.`merchant_id` = `o`.`merchant_id`))) ;





DROP VIEW IF EXISTS `view_ordermerchantkuaidifinance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`lewan2018`@`%` SQL SECURITY DEFINER VIEW `view_ordermerchantkuaidifinance` AS
select `o`.`order_id` AS `order_id`,`o`.`order_no` AS `order_no`,`o`.`order_fullname` AS `order_fullname`,`o`.`order_mobile` AS `order_mobile`,`o`.`order_totalfee` AS `order_totalfee`,
`o`.`order_payment` AS `order_payment`,`o`.`order_paytime` AS `order_paytime`,`o`.`order_isexpress` AS `order_isexpress`,`o`.`order_reservation` AS `order_reservation`,`o`.`order_addtime` AS `order_addtime`,
`a`.`cash` AS `cash`,`a`.`coupon` AS `coupon`,`a`.`payamount` AS `payamount`,`op`.`product_id` AS `product_id`,`op`.`product_name` AS `product_name`,`op`.`product_property` AS `product_property`,
`op`.`num` AS `num`,`op`.`price` AS `price`,`op`.`settle` AS `settle`,`op`.`totalmoney` AS `totalmoney`,`op`.`totalsettle` AS `totalsettle`,ifnull(`op`.`commis_free`,0) AS `commis_free`,
ifnull(`op`.`commis_first`,0) AS `commis_first`,ifnull(`op`.`commis_second`,0) AS `commis_second`,ifnull(`op`.`commis_operations`,0) AS `commis_operations`,
ifnull(`op`.`commis_operations_child`,0) AS `commis_operations_child`,ifnull(`op`.`commis_playerhost_child`,0) AS `commis_playerhost_child`,
ifnull(`op`.`commis_playerhost_zhishu`,0) AS `commis_playerhost_zhishu`,
`p`.`catefinance_id` AS `catefinance_id`,`m`.`merchant_name` AS `merchant_name`
from ((((`jay_order` `o` left join `jay_order_affiliated` `a` on((`a`.`order_id` = `o`.`order_id`)))
left join `jay_order_product` `op` on((`op`.`order_id` = `o`.`order_id`)))
left join `jay_product` `p` on((`p`.`product_id` = `op`.`product_id`)))
left join `jay_merchant` `m` on((`m`.`merchant_id` = `o`.`merchant_id`)))
where ((`o`.`order_status` = 4) and (`o`.`order_isexpress` = 2)) ;



DROP VIEW IF EXISTS `view_orderfinance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`lewan2018`@`%` SQL SECURITY DEFINER VIEW `view_orderfinance` AS select `o`.`order_id` AS `order_id`,`o`.`order_no` AS `order_no`,`o`.`order_transaction` AS `order_transaction`,
`o`.`order_fullname` AS `order_fullname`,`o`.`order_mobile` AS `order_mobile`,`o`.`order_totalfee` AS `order_totalfee`,`o`.`order_isexpress` AS `order_isexpress`,`a`.`cash` AS `cash`,`a`.`coupon` AS `coupon`,
`a`.`payamount` AS `payamount`,`m`.`merchant_name` AS `merchant_name`,`o`.`order_payment` AS `order_payment`,`o`.`order_addtime` AS `order_addtime`,`o`.`order_paytime` AS `order_paytime`,
`p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,`p`.`product_property` AS `product_property`,`p`.`num` AS `num`,`p`.`price` AS `price`,`p`.`settle` AS `settle`,`p`.`totalmoney` AS `totalmoney`,
`p`.`totalsettle` AS `totalsettle`,`p`.`commis_free` AS `commis_free`,
ifnull(`p`.`commis_first`,0) AS `commis_first`,ifnull(`p`.`commis_second`,0) AS `commis_second`,ifnull(`p`.`commis_operations`,0) AS `commis_operations`,
ifnull(`p`.`commis_operations_child`,0) AS `commis_operations_child`,ifnull(`p`.`commis_playerhost_child`,0) AS `commis_playerhost_child`,ifnull(`p`.`commis_playerhost_zhishu`,0) AS `commis_playerhost_zhishu`,
`p1`.`catefinance_id` AS `catefinance_id`,`o`.`order_refundstatus` AS `order_refundstatus`,`rf`.`refund_uptime` AS `refund_uptime`
from (((((`jay_order` `o`
left join `jay_order_affiliated` `a` on((`a`.`order_id` = `o`.`order_id`)))
left join `jay_order_product` `p` on((`p`.`order_id` = `o`.`order_id`)))
left join `jay_order_refund` `rf` on((`rf`.`order_id` = `o`.`order_id`)))
left join `jay_product` `p1` on((`p1`.`product_id` = `p`.`product_id`)))
left join `jay_merchant` `m` on((`m`.`merchant_id` = `o`.`merchant_id`)))
where (`o`.`order_status` > 1) order by `o`.`order_id` desc;




-- ----------------------------
-- Procedure structure for `lewan_order_income`
-- ----------------------------
DROP PROCEDURE IF EXISTS `lewan_order_income`;
DELIMITER ;;
CREATE DEFINER=`lewan2018`@`%` PROCEDURE `lewan_order_income`(in orderId int, OUT error INT)
BEGIN

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;
    SET @totalfee = 0;
    SET @num = 0;
    SET @totalsettle = 0;
    SET @coupon = 0;
    SET @payamount = 0;
    SET @isreturnall = 0;
    SET @commis_free = 0;
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
          ifnull(op.commis_free,0),
          ifnull(op.commis_first,0),
          ifnull(op.commis_second,0),
          ifnull(op.commis_operations,0),
          ifnull(op.commis_operations_child,0),
          ifnull(op.commis_playerhost_child,0),
          ifnull(op.commis_playerhost_zhishu,0),
          ifnull(op.product_returnall,0)
    into @totalfee,@num,@totalsettle,@coupon,@payamount,@commis_free,@commis_first,@commis_second,@commis_operations,@commis_operations_child,@commis_playerhost_child,@commis_playerhost_zhishu,@isreturnall from jay_order o
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
        SET @totalcom = @commis_free+@commis_first+@commis_second+@commis_operations+@commis_operations_child+@commis_playerhost_child+@commis_playerhost_zhishu+@returnmoney;
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