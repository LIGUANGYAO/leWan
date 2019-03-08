-- ----------------------------
-- Event structure for `timer_automakeuserdata`
-- [定时统计达人数据]
-- ----------------------------
DROP EVENT IF EXISTS `timer_automakeuserdata`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` EVENT `timer_automakeuserdata` ON SCHEDULE EVERY 4 HOUR STARTS '2018-12-25 09:32:49'
ON COMPLETION NOT PRESERVE ENABLE
DO
  out_label: begin
    truncate jay_temp_userdata;
    call lewan_makeuserteamdata(2, @error);
    call lewan_makeuserteamdata(3, @error);
    call lewan_makeuserteamdata(4, @error);
    call lewan_makeuserteamdata(5, @error);
  end out_label;
;;
DELIMITER ;