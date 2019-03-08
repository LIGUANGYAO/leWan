DROP PROCEDURE IF EXISTS `TimerTask_zidongshouqing`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TimerTask_zidongshouqing`(OUT error INT)
BEGIN

    declare done int default 0;
    declare productId int default 0;
    declare productSold int default 0; #虚拟销量
    #获取要统计的商品
    declare productlist cursor for select product_id, product_sold from jay_product where sold_out=0 and product_status=1;
    declare continue handler for not found set done = 1;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET error = 1; # 异常错误
    SET error = 0;

    out_label: BEGIN
      open productlist;
      repeat
        FETCH productlist INTO productId,productSold;
        IF not done
          THEN
            BEGIN
                #2.规格数量
                set @pricenum = 0;
                SET @v_sql = CONCAT('select count(*) into @pricenum from jay_product_price where product_id = ',productId,' and  price_status=1;');
                PREPARE statement FROM @v_sql;
                EXECUTE statement;
                DEALLOCATE PREPARE statement;

                #2.查询余额
                set @totalnum = 0;
                set @buynum = 0;
                SET @v_sql = CONCAT('select sum(product_totalnum),sum(product_buynum) into @totalnum, @buynum from jay_product_price where product_id = ',productId,' and  price_status=1;');
                PREPARE statement FROM @v_sql;
                EXECUTE statement;
                DEALLOCATE PREPARE statement;

                if @buynum+@pricenum*productSold >= @totalnum THEN
                  SET @v_sql = CONCAT('update jay_product set sold_out=1, sold_out_time=',UNIX_TIMESTAMP(),' where product_id = ',productId);
                  PREPARE statement FROM @v_sql;
                  EXECUTE statement;
                  DEALLOCATE PREPARE statement;
                END if;

            END ;
        END IF ;
      until done end repeat;
      close productlist;#关闭释放资源
  END;

  SELECT error;
end;
;;
DELIMITER ;



CREATE DEFINER=`lewan2018`@`%` EVENT `lewan_zidongshouqing` ON SCHEDULE EVERY 1 HOUR STARTS '2019-02-18 11:30:07' ON COMPLETION NOT PRESERVE ENABLE DO call TimerTask_zidongshouqing(@error)