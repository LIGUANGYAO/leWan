-- ----------------------------
-- View structure for `view_orderfinance`
-- ----------------------------
DROP VIEW IF EXISTS `view_orderfinance`;
CREATE ALGORITHM=UNDEFINED DEFINER=`lewan2018`@`%` SQL SECURITY DEFINER VIEW `view_orderfinance` AS
select `o`.`order_id` AS `order_id`,`o`.`order_no` AS `order_no`,`o`.`order_transaction` AS `order_transaction`,`o`.`order_fullname` AS `order_fullname`,`o`.`order_mobile` AS `order_mobile`,
`o`.`order_totalfee` AS `order_totalfee`,`o`.`order_isexpress` AS `order_isexpress`,`a`.`cash` AS `cash`,`a`.`coupon` AS `coupon`,`a`.`payamount` AS `payamount`,`m`.`merchant_name` AS `merchant_name`,
`o`.`order_payment` AS `order_payment`,`o`.`order_addtime` AS `order_addtime`,`o`.`order_paytime` AS `order_paytime`,`p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,
`p`.`product_property` AS `product_property`,`p`.`num` AS `num`,`p`.`price` AS `price`,`p`.`settle` AS `settle`,`p`.`totalmoney` AS `totalmoney`,`p`.`totalsettle` AS `totalsettle`,`p`.`commis_free` AS `commis_free`,
ifnull(`p`.`commis_first`,0) AS `commis_first`,ifnull(`p`.`commis_second`,0) AS `commis_second`,ifnull(`p`.`commis_operations`,0) AS `commis_operations`,
ifnull(`p`.`commis_operations_child`,0) AS `commis_operations_child`,ifnull(`p`.`commis_playerhost_child`,0) AS `commis_playerhost_child`,ifnull(`p`.`commis_playerhost_zhishu`,0) AS `commis_playerhost_zhishu`,
`p1`.`catefinance_id` AS `catefinance_id`,`o`.`order_refundstatus` AS `order_refundstatus`,`rf`.`refund_uptime` AS `refund_uptime` , rf.refund_type
from (((((`jay_order` `o` left join `jay_order_affiliated` `a` on((`a`.`order_id` = `o`.`order_id`)))
left join `jay_order_product` `p` on((`p`.`order_id` = `o`.`order_id`)))
left join `jay_order_refund` `rf` on((`rf`.`order_id` = `o`.`order_id`)))
left join `jay_product` `p1` on((`p1`.`product_id` = `p`.`product_id`)))
left join `jay_merchant` `m` on((`m`.`merchant_id` = `o`.`merchant_id`)))
where (`o`.`order_status` > 1) order by `o`.`order_id` desc ;
