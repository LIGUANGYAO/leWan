/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50519
Source Host           : localhost:3306
Source Database       : jdyd

Target Server Type    : MYSQL
Target Server Version : 50519
File Encoding         : 65001

Date: 2018-10-08 09:35:00
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `jay_account`
-- ----------------------------
DROP TABLE IF EXISTS `jay_account`;
CREATE TABLE `jay_account` (
  `account_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `account_cash_expenditure` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '现金币支出总额',
  `account_cash_income` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '现金币收入总额',
  `account_cash_balance` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '现金币余额',
  `account_points_expenditure` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '积分支出总额',
  `account_points_income` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '积分收入总额',
  `account_points_balance` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '积分余额',
  `account_tag` int(10) NOT NULL DEFAULT '0' COMMENT '标签：total, [year], [year][moth], [year][moth][day]',
  `account_uptime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '更新时',
  PRIMARY KEY (`account_id`),
  KEY `account_tag` (`account_tag`),
  KEY `account_uptime` (`account_uptime`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='帐户实时统计表';

-- ----------------------------
-- Records of jay_account
-- ----------------------------
INSERT INTO `jay_account` VALUES ('1', null, '0.0000', '0.0000', '0.0000', '0.0000', '3.6000', '3.6000', '0', '1531723942');
INSERT INTO `jay_account` VALUES ('3', null, '0.0000', '0.0000', '0.0000', '0.0000', '2.4000', '3.6000', '20180716', '1531724385');
INSERT INTO `jay_account` VALUES ('4', null, '0.0000', '0.0000', '0.0000', '0.0000', '1.2000', '1.2000', '0', '1531724449');
INSERT INTO `jay_account` VALUES ('5', null, '0.0000', '0.0000', '0.0000', '0.0000', '1.2000', '1.2000', '20180716', '1531724449');

-- ----------------------------
-- Table structure for `jay_account_points`
-- ----------------------------
DROP TABLE IF EXISTS `jay_account_points`;
CREATE TABLE `jay_account_points` (
  `record_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `record_currency` varchar(10) NOT NULL DEFAULT '' COMMENT '货币类型',
  `record_action` int(3) NOT NULL DEFAULT '0' COMMENT '操作类型',
  `record_amount` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '操作金额',
  `record_balance` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '操作后余',
  `record_addtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  `record_attach` varchar(1000) DEFAULT '' COMMENT '操作附近带参数',
  `record_remark` varchar(1000) DEFAULT '' COMMENT '操作说明',
  `record_exchange` float DEFAULT '1' COMMENT '兑换比例',
  PRIMARY KEY (`record_id`),
  KEY `record_currency` (`record_currency`),
  KEY `record_action` (`record_action`),
  KEY `record_addtime` (`record_addtime`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COMMENT='交易记录基础表\r\n';

-- ----------------------------
-- Records of jay_account_points
-- ----------------------------
INSERT INTO `jay_account_points` VALUES ('1', null, '3', '0', '0.0000', '0.0000', '0', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('2', '2', 'points', '1', '1.2000', '1.2000', '1533280375', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('3', '22', 'points', '1', '1.2000', '1.2000', '1533280375', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('4', null, 'points', '1', '1.2000', '2.4000', '1531724042', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('5', null, 'points', '1', '1.2000', '2.4000', '1531724044', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('6', null, 'points', '1', '1.2000', '2.4000', '1531724090', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('7', null, 'points', '1', '1.2000', '2.4000', '1531724104', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('8', null, 'points', '1', '1.2000', '2.4000', '1531724156', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('9', null, 'points', '1', '1.2000', '2.4000', '1531724174', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('10', null, 'points', '1', '1.2000', '2.4000', '1531724384', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('11', null, 'points', '1', '1.2000', '3.6000', '1531724419', '', '', '1');
INSERT INTO `jay_account_points` VALUES ('12', null, 'points', '1', '1.2000', '1.2000', '1531724449', '', '', '1');

-- ----------------------------
-- Table structure for `jay_account_record`
-- ----------------------------
DROP TABLE IF EXISTS `jay_account_record`;
CREATE TABLE `jay_account_record` (
  `record_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `record_currency` varchar(10) NOT NULL DEFAULT '' COMMENT '货币类型',
  `record_action` int(3) NOT NULL DEFAULT '0' COMMENT '操作类型',
  `record_amount` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '操作金额',
  `record_balance` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '操作后余',
  `record_addtime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '操作时间',
  `record_attach` varchar(1000) DEFAULT '' COMMENT '操作附近带参数',
  `record_remark` varchar(1000) DEFAULT '' COMMENT '操作说明',
  `record_exchange` float DEFAULT '1' COMMENT '兑换比例',
  PRIMARY KEY (`record_id`),
  KEY `record_currency` (`record_currency`),
  KEY `record_action` (`record_action`),
  KEY `record_addtime` (`record_addtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='交易记录基础表\r\n积分交易记录表，按月分表\r\nCREATE TABLE IF NOT EXISTS zc_account_points_201807 LIKE zc_account_record;';

-- ----------------------------
-- Records of jay_account_record
-- ----------------------------

-- ----------------------------
-- Table structure for `jay_actives`
-- ----------------------------
DROP TABLE IF EXISTS `jay_actives`;
CREATE TABLE `jay_actives` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cat_id` int(11) DEFAULT NULL COMMENT '分类id',
  `section` int(11) DEFAULT NULL COMMENT '大分类id',
  `title` varchar(100) DEFAULT NULL,
  `content` text,
  `price` varchar(10) DEFAULT NULL,
  `pic` varchar(50) DEFAULT NULL,
  `starttime` varchar(20) DEFAULT NULL COMMENT '开始时间',
  `endtime` varchar(20) DEFAULT NULL COMMENT '结束时间',
  `applynum` int(11) DEFAULT '0' COMMENT '实际申请人数',
  `enrollnum` int(11) DEFAULT NULL COMMENT '后台报名人数',
  `totalnum` int(11) DEFAULT '50' COMMENT '总人数',
  `status` tinyint(4) DEFAULT '0' COMMENT '0默认 1上线 2过期',
  `addtime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='活动表';

-- ----------------------------
-- Records of jay_actives
-- ----------------------------
INSERT INTO `jay_actives` VALUES ('1', null, '4', '保修日期', '<p>本产品全国联保，享受三包服务，质保期为：全国联保一年<br/>\r\n &nbsp; &nbsp; &nbsp; &nbsp; 如因质量问题享受7日内退货，15日内换货，15日以上在质保期内享受免费保修等三包服务！</p>', null, null, null, null, '0', null, '50', '0', null);
INSERT INTO `jay_actives` VALUES ('2', '20', '4', '为 畅享5 会员专享通道', '<pre class=\"brush:php;toolbar:false\">/**\r\n&nbsp;*&nbsp;远程调用控制器&lt;输出xml&gt;\r\n&nbsp;*\r\n&nbsp;*&nbsp;@author&nbsp;Carrot\r\n&nbsp;*/\r\nclass&nbsp;BaoBiaoController&nbsp;extends&nbsp;XAdminBase&nbsp;{\r\n\r\n&nbsp;&nbsp;&nbsp;&nbsp;public&nbsp;function&nbsp;init()&nbsp;{\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;parent::init();\r\n&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$this-&gt;layout&nbsp;=&nbsp;false;\r\n&nbsp;&nbsp;&nbsp;&nbsp;//&nbsp;&nbsp;&nbsp;&nbsp;header(\"Content-type:text/xml;charset=utf-8\");\r\n&nbsp;&nbsp;&nbsp;&nbsp;}</pre>', null, '20180716\\bdb7778d5c17ff35b0633852809bb511.png', '', null, '0', '4', '50', '0', '1531708412');

-- ----------------------------
-- Table structure for `jay_actives_apply`
-- ----------------------------
DROP TABLE IF EXISTS `jay_actives_apply`;
CREATE TABLE `jay_actives_apply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `active_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `day` varchar(20) DEFAULT NULL,
  `tel` varchar(12) DEFAULT NULL,
  `addtime` int(11) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1' COMMENT '1提交 0取消',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_actives_apply
-- ----------------------------
INSERT INTO `jay_actives_apply` VALUES ('2', '34', '1', '测试', '2017-12-20', '18983298399', null, '1');
INSERT INTO `jay_actives_apply` VALUES ('3', '4', '1', '15828218481', '2017-12-20', '14232131312', null, '1');

-- ----------------------------
-- Table structure for `jay_area`
-- ----------------------------
DROP TABLE IF EXISTS `jay_area`;
CREATE TABLE `jay_area` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `area` varchar(50) NOT NULL,
  `ccode` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3145 DEFAULT CHARSET=utf8 COMMENT='行政区域县区信息表';

-- ----------------------------
-- Records of jay_area
-- ----------------------------
INSERT INTO `jay_area` VALUES ('1', '110101', '东城区', '110100');
INSERT INTO `jay_area` VALUES ('2', '110102', '西城区', '110100');
INSERT INTO `jay_area` VALUES ('3', '110103', '崇文区', '110100');
INSERT INTO `jay_area` VALUES ('4', '110104', '宣武区', '110100');
INSERT INTO `jay_area` VALUES ('5', '110105', '朝阳区', '110100');
INSERT INTO `jay_area` VALUES ('6', '110106', '丰台区', '110100');
INSERT INTO `jay_area` VALUES ('7', '110107', '石景山区', '110100');
INSERT INTO `jay_area` VALUES ('8', '110108', '海淀区', '110100');
INSERT INTO `jay_area` VALUES ('9', '110109', '门头沟区', '110100');
INSERT INTO `jay_area` VALUES ('10', '110111', '房山区', '110100');
INSERT INTO `jay_area` VALUES ('11', '110112', '通州区', '110100');
INSERT INTO `jay_area` VALUES ('12', '110113', '顺义区', '110100');
INSERT INTO `jay_area` VALUES ('13', '110114', '昌平区', '110100');
INSERT INTO `jay_area` VALUES ('14', '110115', '大兴区', '110100');
INSERT INTO `jay_area` VALUES ('15', '110116', '怀柔区', '110100');
INSERT INTO `jay_area` VALUES ('16', '110117', '平谷区', '110100');
INSERT INTO `jay_area` VALUES ('17', '110228', '密云县', '110200');
INSERT INTO `jay_area` VALUES ('18', '110229', '延庆县', '110200');
INSERT INTO `jay_area` VALUES ('19', '120101', '和平区', '120100');
INSERT INTO `jay_area` VALUES ('20', '120102', '河东区', '120100');
INSERT INTO `jay_area` VALUES ('21', '120103', '河西区', '120100');
INSERT INTO `jay_area` VALUES ('22', '120104', '南开区', '120100');
INSERT INTO `jay_area` VALUES ('23', '120105', '河北区', '120100');
INSERT INTO `jay_area` VALUES ('24', '120106', '红桥区', '120100');
INSERT INTO `jay_area` VALUES ('25', '120107', '塘沽区', '120100');
INSERT INTO `jay_area` VALUES ('26', '120108', '汉沽区', '120100');
INSERT INTO `jay_area` VALUES ('27', '120109', '大港区', '120100');
INSERT INTO `jay_area` VALUES ('28', '120110', '东丽区', '120100');
INSERT INTO `jay_area` VALUES ('29', '120111', '西青区', '120100');
INSERT INTO `jay_area` VALUES ('30', '120112', '津南区', '120100');
INSERT INTO `jay_area` VALUES ('31', '120113', '北辰区', '120100');
INSERT INTO `jay_area` VALUES ('32', '120114', '武清区', '120100');
INSERT INTO `jay_area` VALUES ('33', '120115', '宝坻区', '120100');
INSERT INTO `jay_area` VALUES ('34', '120221', '宁河县', '120200');
INSERT INTO `jay_area` VALUES ('35', '120223', '静海县', '120200');
INSERT INTO `jay_area` VALUES ('36', '120225', '蓟　县', '120200');
INSERT INTO `jay_area` VALUES ('37', '130101', '市辖区', '130100');
INSERT INTO `jay_area` VALUES ('38', '130102', '长安区', '130100');
INSERT INTO `jay_area` VALUES ('39', '130103', '桥东区', '130100');
INSERT INTO `jay_area` VALUES ('40', '130104', '桥西区', '130100');
INSERT INTO `jay_area` VALUES ('41', '130105', '新华区', '130100');
INSERT INTO `jay_area` VALUES ('42', '130107', '井陉矿区', '130100');
INSERT INTO `jay_area` VALUES ('43', '130108', '裕华区', '130100');
INSERT INTO `jay_area` VALUES ('44', '130121', '井陉县', '130100');
INSERT INTO `jay_area` VALUES ('45', '130123', '正定县', '130100');
INSERT INTO `jay_area` VALUES ('46', '130124', '栾城县', '130100');
INSERT INTO `jay_area` VALUES ('47', '130125', '行唐县', '130100');
INSERT INTO `jay_area` VALUES ('48', '130126', '灵寿县', '130100');
INSERT INTO `jay_area` VALUES ('49', '130127', '高邑县', '130100');
INSERT INTO `jay_area` VALUES ('50', '130128', '深泽县', '130100');
INSERT INTO `jay_area` VALUES ('51', '130129', '赞皇县', '130100');
INSERT INTO `jay_area` VALUES ('52', '130130', '无极县', '130100');
INSERT INTO `jay_area` VALUES ('53', '130131', '平山县', '130100');
INSERT INTO `jay_area` VALUES ('54', '130132', '元氏县', '130100');
INSERT INTO `jay_area` VALUES ('55', '130133', '赵　县', '130100');
INSERT INTO `jay_area` VALUES ('56', '130181', '辛集市', '130100');
INSERT INTO `jay_area` VALUES ('57', '130182', '藁城市', '130100');
INSERT INTO `jay_area` VALUES ('58', '130183', '晋州市', '130100');
INSERT INTO `jay_area` VALUES ('59', '130184', '新乐市', '130100');
INSERT INTO `jay_area` VALUES ('60', '130185', '鹿泉市', '130100');
INSERT INTO `jay_area` VALUES ('61', '130201', '市辖区', '130200');
INSERT INTO `jay_area` VALUES ('62', '130202', '路南区', '130200');
INSERT INTO `jay_area` VALUES ('63', '130203', '路北区', '130200');
INSERT INTO `jay_area` VALUES ('64', '130204', '古冶区', '130200');
INSERT INTO `jay_area` VALUES ('65', '130205', '开平区', '130200');
INSERT INTO `jay_area` VALUES ('66', '130207', '丰南区', '130200');
INSERT INTO `jay_area` VALUES ('67', '130208', '丰润区', '130200');
INSERT INTO `jay_area` VALUES ('68', '130223', '滦　县', '130200');
INSERT INTO `jay_area` VALUES ('69', '130224', '滦南县', '130200');
INSERT INTO `jay_area` VALUES ('70', '130225', '乐亭县', '130200');
INSERT INTO `jay_area` VALUES ('71', '130227', '迁西县', '130200');
INSERT INTO `jay_area` VALUES ('72', '130229', '玉田县', '130200');
INSERT INTO `jay_area` VALUES ('73', '130230', '唐海县', '130200');
INSERT INTO `jay_area` VALUES ('74', '130281', '遵化市', '130200');
INSERT INTO `jay_area` VALUES ('75', '130283', '迁安市', '130200');
INSERT INTO `jay_area` VALUES ('76', '130301', '市辖区', '130300');
INSERT INTO `jay_area` VALUES ('77', '130302', '海港区', '130300');
INSERT INTO `jay_area` VALUES ('78', '130303', '山海关区', '130300');
INSERT INTO `jay_area` VALUES ('79', '130304', '北戴河区', '130300');
INSERT INTO `jay_area` VALUES ('80', '130321', '青龙满族自治县', '130300');
INSERT INTO `jay_area` VALUES ('81', '130322', '昌黎县', '130300');
INSERT INTO `jay_area` VALUES ('82', '130323', '抚宁县', '130300');
INSERT INTO `jay_area` VALUES ('83', '130324', '卢龙县', '130300');
INSERT INTO `jay_area` VALUES ('84', '130401', '市辖区', '130400');
INSERT INTO `jay_area` VALUES ('85', '130402', '邯山区', '130400');
INSERT INTO `jay_area` VALUES ('86', '130403', '丛台区', '130400');
INSERT INTO `jay_area` VALUES ('87', '130404', '复兴区', '130400');
INSERT INTO `jay_area` VALUES ('88', '130406', '峰峰矿区', '130400');
INSERT INTO `jay_area` VALUES ('89', '130421', '邯郸县', '130400');
INSERT INTO `jay_area` VALUES ('90', '130423', '临漳县', '130400');
INSERT INTO `jay_area` VALUES ('91', '130424', '成安县', '130400');
INSERT INTO `jay_area` VALUES ('92', '130425', '大名县', '130400');
INSERT INTO `jay_area` VALUES ('93', '130426', '涉　县', '130400');
INSERT INTO `jay_area` VALUES ('94', '130427', '磁　县', '130400');
INSERT INTO `jay_area` VALUES ('95', '130428', '肥乡县', '130400');
INSERT INTO `jay_area` VALUES ('96', '130429', '永年县', '130400');
INSERT INTO `jay_area` VALUES ('97', '130430', '邱　县', '130400');
INSERT INTO `jay_area` VALUES ('98', '130431', '鸡泽县', '130400');
INSERT INTO `jay_area` VALUES ('99', '130432', '广平县', '130400');
INSERT INTO `jay_area` VALUES ('100', '130433', '馆陶县', '130400');
INSERT INTO `jay_area` VALUES ('101', '130434', '魏　县', '130400');
INSERT INTO `jay_area` VALUES ('102', '130435', '曲周县', '130400');
INSERT INTO `jay_area` VALUES ('103', '130481', '武安市', '130400');
INSERT INTO `jay_area` VALUES ('104', '130501', '市辖区', '130500');
INSERT INTO `jay_area` VALUES ('105', '130502', '桥东区', '130500');
INSERT INTO `jay_area` VALUES ('106', '130503', '桥西区', '130500');
INSERT INTO `jay_area` VALUES ('107', '130521', '邢台县', '130500');
INSERT INTO `jay_area` VALUES ('108', '130522', '临城县', '130500');
INSERT INTO `jay_area` VALUES ('109', '130523', '内丘县', '130500');
INSERT INTO `jay_area` VALUES ('110', '130524', '柏乡县', '130500');
INSERT INTO `jay_area` VALUES ('111', '130525', '隆尧县', '130500');
INSERT INTO `jay_area` VALUES ('112', '130526', '任　县', '130500');
INSERT INTO `jay_area` VALUES ('113', '130527', '南和县', '130500');
INSERT INTO `jay_area` VALUES ('114', '130528', '宁晋县', '130500');
INSERT INTO `jay_area` VALUES ('115', '130529', '巨鹿县', '130500');
INSERT INTO `jay_area` VALUES ('116', '130530', '新河县', '130500');
INSERT INTO `jay_area` VALUES ('117', '130531', '广宗县', '130500');
INSERT INTO `jay_area` VALUES ('118', '130532', '平乡县', '130500');
INSERT INTO `jay_area` VALUES ('119', '130533', '威　县', '130500');
INSERT INTO `jay_area` VALUES ('120', '130534', '清河县', '130500');
INSERT INTO `jay_area` VALUES ('121', '130535', '临西县', '130500');
INSERT INTO `jay_area` VALUES ('122', '130581', '南宫市', '130500');
INSERT INTO `jay_area` VALUES ('123', '130582', '沙河市', '130500');
INSERT INTO `jay_area` VALUES ('124', '130601', '市辖区', '130600');
INSERT INTO `jay_area` VALUES ('125', '130602', '新市区', '130600');
INSERT INTO `jay_area` VALUES ('126', '130603', '北市区', '130600');
INSERT INTO `jay_area` VALUES ('127', '130604', '南市区', '130600');
INSERT INTO `jay_area` VALUES ('128', '130621', '满城县', '130600');
INSERT INTO `jay_area` VALUES ('129', '130622', '清苑县', '130600');
INSERT INTO `jay_area` VALUES ('130', '130623', '涞水县', '130600');
INSERT INTO `jay_area` VALUES ('131', '130624', '阜平县', '130600');
INSERT INTO `jay_area` VALUES ('132', '130625', '徐水县', '130600');
INSERT INTO `jay_area` VALUES ('133', '130626', '定兴县', '130600');
INSERT INTO `jay_area` VALUES ('134', '130627', '唐　县', '130600');
INSERT INTO `jay_area` VALUES ('135', '130628', '高阳县', '130600');
INSERT INTO `jay_area` VALUES ('136', '130629', '容城县', '130600');
INSERT INTO `jay_area` VALUES ('137', '130630', '涞源县', '130600');
INSERT INTO `jay_area` VALUES ('138', '130631', '望都县', '130600');
INSERT INTO `jay_area` VALUES ('139', '130632', '安新县', '130600');
INSERT INTO `jay_area` VALUES ('140', '130633', '易　县', '130600');
INSERT INTO `jay_area` VALUES ('141', '130634', '曲阳县', '130600');
INSERT INTO `jay_area` VALUES ('142', '130635', '蠡　县', '130600');
INSERT INTO `jay_area` VALUES ('143', '130636', '顺平县', '130600');
INSERT INTO `jay_area` VALUES ('144', '130637', '博野县', '130600');
INSERT INTO `jay_area` VALUES ('145', '130638', '雄　县', '130600');
INSERT INTO `jay_area` VALUES ('146', '130681', '涿州市', '130600');
INSERT INTO `jay_area` VALUES ('147', '130682', '定州市', '130600');
INSERT INTO `jay_area` VALUES ('148', '130683', '安国市', '130600');
INSERT INTO `jay_area` VALUES ('149', '130684', '高碑店市', '130600');
INSERT INTO `jay_area` VALUES ('150', '130701', '市辖区', '130700');
INSERT INTO `jay_area` VALUES ('151', '130702', '桥东区', '130700');
INSERT INTO `jay_area` VALUES ('152', '130703', '桥西区', '130700');
INSERT INTO `jay_area` VALUES ('153', '130705', '宣化区', '130700');
INSERT INTO `jay_area` VALUES ('154', '130706', '下花园区', '130700');
INSERT INTO `jay_area` VALUES ('155', '130721', '宣化县', '130700');
INSERT INTO `jay_area` VALUES ('156', '130722', '张北县', '130700');
INSERT INTO `jay_area` VALUES ('157', '130723', '康保县', '130700');
INSERT INTO `jay_area` VALUES ('158', '130724', '沽源县', '130700');
INSERT INTO `jay_area` VALUES ('159', '130725', '尚义县', '130700');
INSERT INTO `jay_area` VALUES ('160', '130726', '蔚　县', '130700');
INSERT INTO `jay_area` VALUES ('161', '130727', '阳原县', '130700');
INSERT INTO `jay_area` VALUES ('162', '130728', '怀安县', '130700');
INSERT INTO `jay_area` VALUES ('163', '130729', '万全县', '130700');
INSERT INTO `jay_area` VALUES ('164', '130730', '怀来县', '130700');
INSERT INTO `jay_area` VALUES ('165', '130731', '涿鹿县', '130700');
INSERT INTO `jay_area` VALUES ('166', '130732', '赤城县', '130700');
INSERT INTO `jay_area` VALUES ('167', '130733', '崇礼县', '130700');
INSERT INTO `jay_area` VALUES ('168', '130801', '市辖区', '130800');
INSERT INTO `jay_area` VALUES ('169', '130802', '双桥区', '130800');
INSERT INTO `jay_area` VALUES ('170', '130803', '双滦区', '130800');
INSERT INTO `jay_area` VALUES ('171', '130804', '鹰手营子矿区', '130800');
INSERT INTO `jay_area` VALUES ('172', '130821', '承德县', '130800');
INSERT INTO `jay_area` VALUES ('173', '130822', '兴隆县', '130800');
INSERT INTO `jay_area` VALUES ('174', '130823', '平泉县', '130800');
INSERT INTO `jay_area` VALUES ('175', '130824', '滦平县', '130800');
INSERT INTO `jay_area` VALUES ('176', '130825', '隆化县', '130800');
INSERT INTO `jay_area` VALUES ('177', '130826', '丰宁满族自治县', '130800');
INSERT INTO `jay_area` VALUES ('178', '130827', '宽城满族自治县', '130800');
INSERT INTO `jay_area` VALUES ('179', '130828', '围场满族蒙古族自治县', '130800');
INSERT INTO `jay_area` VALUES ('180', '130901', '市辖区', '130900');
INSERT INTO `jay_area` VALUES ('181', '130902', '新华区', '130900');
INSERT INTO `jay_area` VALUES ('182', '130903', '运河区', '130900');
INSERT INTO `jay_area` VALUES ('183', '130921', '沧　县', '130900');
INSERT INTO `jay_area` VALUES ('184', '130922', '青　县', '130900');
INSERT INTO `jay_area` VALUES ('185', '130923', '东光县', '130900');
INSERT INTO `jay_area` VALUES ('186', '130924', '海兴县', '130900');
INSERT INTO `jay_area` VALUES ('187', '130925', '盐山县', '130900');
INSERT INTO `jay_area` VALUES ('188', '130926', '肃宁县', '130900');
INSERT INTO `jay_area` VALUES ('189', '130927', '南皮县', '130900');
INSERT INTO `jay_area` VALUES ('190', '130928', '吴桥县', '130900');
INSERT INTO `jay_area` VALUES ('191', '130929', '献　县', '130900');
INSERT INTO `jay_area` VALUES ('192', '130930', '孟村回族自治县', '130900');
INSERT INTO `jay_area` VALUES ('193', '130981', '泊头市', '130900');
INSERT INTO `jay_area` VALUES ('194', '130982', '任丘市', '130900');
INSERT INTO `jay_area` VALUES ('195', '130983', '黄骅市', '130900');
INSERT INTO `jay_area` VALUES ('196', '130984', '河间市', '130900');
INSERT INTO `jay_area` VALUES ('197', '131001', '市辖区', '131000');
INSERT INTO `jay_area` VALUES ('198', '131002', '安次区', '131000');
INSERT INTO `jay_area` VALUES ('199', '131003', '广阳区', '131000');
INSERT INTO `jay_area` VALUES ('200', '131022', '固安县', '131000');
INSERT INTO `jay_area` VALUES ('201', '131023', '永清县', '131000');
INSERT INTO `jay_area` VALUES ('202', '131024', '香河县', '131000');
INSERT INTO `jay_area` VALUES ('203', '131025', '大城县', '131000');
INSERT INTO `jay_area` VALUES ('204', '131026', '文安县', '131000');
INSERT INTO `jay_area` VALUES ('205', '131028', '大厂回族自治县', '131000');
INSERT INTO `jay_area` VALUES ('206', '131081', '霸州市', '131000');
INSERT INTO `jay_area` VALUES ('207', '131082', '三河市', '131000');
INSERT INTO `jay_area` VALUES ('208', '131101', '市辖区', '131100');
INSERT INTO `jay_area` VALUES ('209', '131102', '桃城区', '131100');
INSERT INTO `jay_area` VALUES ('210', '131121', '枣强县', '131100');
INSERT INTO `jay_area` VALUES ('211', '131122', '武邑县', '131100');
INSERT INTO `jay_area` VALUES ('212', '131123', '武强县', '131100');
INSERT INTO `jay_area` VALUES ('213', '131124', '饶阳县', '131100');
INSERT INTO `jay_area` VALUES ('214', '131125', '安平县', '131100');
INSERT INTO `jay_area` VALUES ('215', '131126', '故城县', '131100');
INSERT INTO `jay_area` VALUES ('216', '131127', '景　县', '131100');
INSERT INTO `jay_area` VALUES ('217', '131128', '阜城县', '131100');
INSERT INTO `jay_area` VALUES ('218', '131181', '冀州市', '131100');
INSERT INTO `jay_area` VALUES ('219', '131182', '深州市', '131100');
INSERT INTO `jay_area` VALUES ('220', '140101', '市辖区', '140100');
INSERT INTO `jay_area` VALUES ('221', '140105', '小店区', '140100');
INSERT INTO `jay_area` VALUES ('222', '140106', '迎泽区', '140100');
INSERT INTO `jay_area` VALUES ('223', '140107', '杏花岭区', '140100');
INSERT INTO `jay_area` VALUES ('224', '140108', '尖草坪区', '140100');
INSERT INTO `jay_area` VALUES ('225', '140109', '万柏林区', '140100');
INSERT INTO `jay_area` VALUES ('226', '140110', '晋源区', '140100');
INSERT INTO `jay_area` VALUES ('227', '140121', '清徐县', '140100');
INSERT INTO `jay_area` VALUES ('228', '140122', '阳曲县', '140100');
INSERT INTO `jay_area` VALUES ('229', '140123', '娄烦县', '140100');
INSERT INTO `jay_area` VALUES ('230', '140181', '古交市', '140100');
INSERT INTO `jay_area` VALUES ('231', '140201', '市辖区', '140200');
INSERT INTO `jay_area` VALUES ('232', '140202', '城　区', '140200');
INSERT INTO `jay_area` VALUES ('233', '140203', '矿　区', '140200');
INSERT INTO `jay_area` VALUES ('234', '140211', '南郊区', '140200');
INSERT INTO `jay_area` VALUES ('235', '140212', '新荣区', '140200');
INSERT INTO `jay_area` VALUES ('236', '140221', '阳高县', '140200');
INSERT INTO `jay_area` VALUES ('237', '140222', '天镇县', '140200');
INSERT INTO `jay_area` VALUES ('238', '140223', '广灵县', '140200');
INSERT INTO `jay_area` VALUES ('239', '140224', '灵丘县', '140200');
INSERT INTO `jay_area` VALUES ('240', '140225', '浑源县', '140200');
INSERT INTO `jay_area` VALUES ('241', '140226', '左云县', '140200');
INSERT INTO `jay_area` VALUES ('242', '140227', '大同县', '140200');
INSERT INTO `jay_area` VALUES ('243', '140301', '市辖区', '140300');
INSERT INTO `jay_area` VALUES ('244', '140302', '城　区', '140300');
INSERT INTO `jay_area` VALUES ('245', '140303', '矿　区', '140300');
INSERT INTO `jay_area` VALUES ('246', '140311', '郊　区', '140300');
INSERT INTO `jay_area` VALUES ('247', '140321', '平定县', '140300');
INSERT INTO `jay_area` VALUES ('248', '140322', '盂　县', '140300');
INSERT INTO `jay_area` VALUES ('249', '140401', '市辖区', '140400');
INSERT INTO `jay_area` VALUES ('250', '140402', '城　区', '140400');
INSERT INTO `jay_area` VALUES ('251', '140411', '郊　区', '140400');
INSERT INTO `jay_area` VALUES ('252', '140421', '长治县', '140400');
INSERT INTO `jay_area` VALUES ('253', '140423', '襄垣县', '140400');
INSERT INTO `jay_area` VALUES ('254', '140424', '屯留县', '140400');
INSERT INTO `jay_area` VALUES ('255', '140425', '平顺县', '140400');
INSERT INTO `jay_area` VALUES ('256', '140426', '黎城县', '140400');
INSERT INTO `jay_area` VALUES ('257', '140427', '壶关县', '140400');
INSERT INTO `jay_area` VALUES ('258', '140428', '长子县', '140400');
INSERT INTO `jay_area` VALUES ('259', '140429', '武乡县', '140400');
INSERT INTO `jay_area` VALUES ('260', '140430', '沁　县', '140400');
INSERT INTO `jay_area` VALUES ('261', '140431', '沁源县', '140400');
INSERT INTO `jay_area` VALUES ('262', '140481', '潞城市', '140400');
INSERT INTO `jay_area` VALUES ('263', '140501', '市辖区', '140500');
INSERT INTO `jay_area` VALUES ('264', '140502', '城　区', '140500');
INSERT INTO `jay_area` VALUES ('265', '140521', '沁水县', '140500');
INSERT INTO `jay_area` VALUES ('266', '140522', '阳城县', '140500');
INSERT INTO `jay_area` VALUES ('267', '140524', '陵川县', '140500');
INSERT INTO `jay_area` VALUES ('268', '140525', '泽州县', '140500');
INSERT INTO `jay_area` VALUES ('269', '140581', '高平市', '140500');
INSERT INTO `jay_area` VALUES ('270', '140601', '市辖区', '140600');
INSERT INTO `jay_area` VALUES ('271', '140602', '朔城区', '140600');
INSERT INTO `jay_area` VALUES ('272', '140603', '平鲁区', '140600');
INSERT INTO `jay_area` VALUES ('273', '140621', '山阴县', '140600');
INSERT INTO `jay_area` VALUES ('274', '140622', '应　县', '140600');
INSERT INTO `jay_area` VALUES ('275', '140623', '右玉县', '140600');
INSERT INTO `jay_area` VALUES ('276', '140624', '怀仁县', '140600');
INSERT INTO `jay_area` VALUES ('277', '140701', '市辖区', '140700');
INSERT INTO `jay_area` VALUES ('278', '140702', '榆次区', '140700');
INSERT INTO `jay_area` VALUES ('279', '140721', '榆社县', '140700');
INSERT INTO `jay_area` VALUES ('280', '140722', '左权县', '140700');
INSERT INTO `jay_area` VALUES ('281', '140723', '和顺县', '140700');
INSERT INTO `jay_area` VALUES ('282', '140724', '昔阳县', '140700');
INSERT INTO `jay_area` VALUES ('283', '140725', '寿阳县', '140700');
INSERT INTO `jay_area` VALUES ('284', '140726', '太谷县', '140700');
INSERT INTO `jay_area` VALUES ('285', '140727', '祁　县', '140700');
INSERT INTO `jay_area` VALUES ('286', '140728', '平遥县', '140700');
INSERT INTO `jay_area` VALUES ('287', '140729', '灵石县', '140700');
INSERT INTO `jay_area` VALUES ('288', '140781', '介休市', '140700');
INSERT INTO `jay_area` VALUES ('289', '140801', '市辖区', '140800');
INSERT INTO `jay_area` VALUES ('290', '140802', '盐湖区', '140800');
INSERT INTO `jay_area` VALUES ('291', '140821', '临猗县', '140800');
INSERT INTO `jay_area` VALUES ('292', '140822', '万荣县', '140800');
INSERT INTO `jay_area` VALUES ('293', '140823', '闻喜县', '140800');
INSERT INTO `jay_area` VALUES ('294', '140824', '稷山县', '140800');
INSERT INTO `jay_area` VALUES ('295', '140825', '新绛县', '140800');
INSERT INTO `jay_area` VALUES ('296', '140826', '绛　县', '140800');
INSERT INTO `jay_area` VALUES ('297', '140827', '垣曲县', '140800');
INSERT INTO `jay_area` VALUES ('298', '140828', '夏　县', '140800');
INSERT INTO `jay_area` VALUES ('299', '140829', '平陆县', '140800');
INSERT INTO `jay_area` VALUES ('300', '140830', '芮城县', '140800');
INSERT INTO `jay_area` VALUES ('301', '140881', '永济市', '140800');
INSERT INTO `jay_area` VALUES ('302', '140882', '河津市', '140800');
INSERT INTO `jay_area` VALUES ('303', '140901', '市辖区', '140900');
INSERT INTO `jay_area` VALUES ('304', '140902', '忻府区', '140900');
INSERT INTO `jay_area` VALUES ('305', '140921', '定襄县', '140900');
INSERT INTO `jay_area` VALUES ('306', '140922', '五台县', '140900');
INSERT INTO `jay_area` VALUES ('307', '140923', '代　县', '140900');
INSERT INTO `jay_area` VALUES ('308', '140924', '繁峙县', '140900');
INSERT INTO `jay_area` VALUES ('309', '140925', '宁武县', '140900');
INSERT INTO `jay_area` VALUES ('310', '140926', '静乐县', '140900');
INSERT INTO `jay_area` VALUES ('311', '140927', '神池县', '140900');
INSERT INTO `jay_area` VALUES ('312', '140928', '五寨县', '140900');
INSERT INTO `jay_area` VALUES ('313', '140929', '岢岚县', '140900');
INSERT INTO `jay_area` VALUES ('314', '140930', '河曲县', '140900');
INSERT INTO `jay_area` VALUES ('315', '140931', '保德县', '140900');
INSERT INTO `jay_area` VALUES ('316', '140932', '偏关县', '140900');
INSERT INTO `jay_area` VALUES ('317', '140981', '原平市', '140900');
INSERT INTO `jay_area` VALUES ('318', '141001', '市辖区', '141000');
INSERT INTO `jay_area` VALUES ('319', '141002', '尧都区', '141000');
INSERT INTO `jay_area` VALUES ('320', '141021', '曲沃县', '141000');
INSERT INTO `jay_area` VALUES ('321', '141022', '翼城县', '141000');
INSERT INTO `jay_area` VALUES ('322', '141023', '襄汾县', '141000');
INSERT INTO `jay_area` VALUES ('323', '141024', '洪洞县', '141000');
INSERT INTO `jay_area` VALUES ('324', '141025', '古　县', '141000');
INSERT INTO `jay_area` VALUES ('325', '141026', '安泽县', '141000');
INSERT INTO `jay_area` VALUES ('326', '141027', '浮山县', '141000');
INSERT INTO `jay_area` VALUES ('327', '141028', '吉　县', '141000');
INSERT INTO `jay_area` VALUES ('328', '141029', '乡宁县', '141000');
INSERT INTO `jay_area` VALUES ('329', '141030', '大宁县', '141000');
INSERT INTO `jay_area` VALUES ('330', '141031', '隰　县', '141000');
INSERT INTO `jay_area` VALUES ('331', '141032', '永和县', '141000');
INSERT INTO `jay_area` VALUES ('332', '141033', '蒲　县', '141000');
INSERT INTO `jay_area` VALUES ('333', '141034', '汾西县', '141000');
INSERT INTO `jay_area` VALUES ('334', '141081', '侯马市', '141000');
INSERT INTO `jay_area` VALUES ('335', '141082', '霍州市', '141000');
INSERT INTO `jay_area` VALUES ('336', '141101', '市辖区', '141100');
INSERT INTO `jay_area` VALUES ('337', '141102', '离石区', '141100');
INSERT INTO `jay_area` VALUES ('338', '141121', '文水县', '141100');
INSERT INTO `jay_area` VALUES ('339', '141122', '交城县', '141100');
INSERT INTO `jay_area` VALUES ('340', '141123', '兴　县', '141100');
INSERT INTO `jay_area` VALUES ('341', '141124', '临　县', '141100');
INSERT INTO `jay_area` VALUES ('342', '141125', '柳林县', '141100');
INSERT INTO `jay_area` VALUES ('343', '141126', '石楼县', '141100');
INSERT INTO `jay_area` VALUES ('344', '141127', '岚　县', '141100');
INSERT INTO `jay_area` VALUES ('345', '141128', '方山县', '141100');
INSERT INTO `jay_area` VALUES ('346', '141129', '中阳县', '141100');
INSERT INTO `jay_area` VALUES ('347', '141130', '交口县', '141100');
INSERT INTO `jay_area` VALUES ('348', '141181', '孝义市', '141100');
INSERT INTO `jay_area` VALUES ('349', '141182', '汾阳市', '141100');
INSERT INTO `jay_area` VALUES ('350', '150101', '市辖区', '150100');
INSERT INTO `jay_area` VALUES ('351', '150102', '新城区', '150100');
INSERT INTO `jay_area` VALUES ('352', '150103', '回民区', '150100');
INSERT INTO `jay_area` VALUES ('353', '150104', '玉泉区', '150100');
INSERT INTO `jay_area` VALUES ('354', '150105', '赛罕区', '150100');
INSERT INTO `jay_area` VALUES ('355', '150121', '土默特左旗', '150100');
INSERT INTO `jay_area` VALUES ('356', '150122', '托克托县', '150100');
INSERT INTO `jay_area` VALUES ('357', '150123', '和林格尔县', '150100');
INSERT INTO `jay_area` VALUES ('358', '150124', '清水河县', '150100');
INSERT INTO `jay_area` VALUES ('359', '150125', '武川县', '150100');
INSERT INTO `jay_area` VALUES ('360', '150201', '市辖区', '150200');
INSERT INTO `jay_area` VALUES ('361', '150202', '东河区', '150200');
INSERT INTO `jay_area` VALUES ('362', '150203', '昆都仑区', '150200');
INSERT INTO `jay_area` VALUES ('363', '150204', '青山区', '150200');
INSERT INTO `jay_area` VALUES ('364', '150205', '石拐区', '150200');
INSERT INTO `jay_area` VALUES ('365', '150206', '白云矿区', '150200');
INSERT INTO `jay_area` VALUES ('366', '150207', '九原区', '150200');
INSERT INTO `jay_area` VALUES ('367', '150221', '土默特右旗', '150200');
INSERT INTO `jay_area` VALUES ('368', '150222', '固阳县', '150200');
INSERT INTO `jay_area` VALUES ('369', '150223', '达尔罕茂明安联合旗', '150200');
INSERT INTO `jay_area` VALUES ('370', '150301', '市辖区', '150300');
INSERT INTO `jay_area` VALUES ('371', '150302', '海勃湾区', '150300');
INSERT INTO `jay_area` VALUES ('372', '150303', '海南区', '150300');
INSERT INTO `jay_area` VALUES ('373', '150304', '乌达区', '150300');
INSERT INTO `jay_area` VALUES ('374', '150401', '市辖区', '150400');
INSERT INTO `jay_area` VALUES ('375', '150402', '红山区', '150400');
INSERT INTO `jay_area` VALUES ('376', '150403', '元宝山区', '150400');
INSERT INTO `jay_area` VALUES ('377', '150404', '松山区', '150400');
INSERT INTO `jay_area` VALUES ('378', '150421', '阿鲁科尔沁旗', '150400');
INSERT INTO `jay_area` VALUES ('379', '150422', '巴林左旗', '150400');
INSERT INTO `jay_area` VALUES ('380', '150423', '巴林右旗', '150400');
INSERT INTO `jay_area` VALUES ('381', '150424', '林西县', '150400');
INSERT INTO `jay_area` VALUES ('382', '150425', '克什克腾旗', '150400');
INSERT INTO `jay_area` VALUES ('383', '150426', '翁牛特旗', '150400');
INSERT INTO `jay_area` VALUES ('384', '150428', '喀喇沁旗', '150400');
INSERT INTO `jay_area` VALUES ('385', '150429', '宁城县', '150400');
INSERT INTO `jay_area` VALUES ('386', '150430', '敖汉旗', '150400');
INSERT INTO `jay_area` VALUES ('387', '150501', '市辖区', '150500');
INSERT INTO `jay_area` VALUES ('388', '150502', '科尔沁区', '150500');
INSERT INTO `jay_area` VALUES ('389', '150521', '科尔沁左翼中旗', '150500');
INSERT INTO `jay_area` VALUES ('390', '150522', '科尔沁左翼后旗', '150500');
INSERT INTO `jay_area` VALUES ('391', '150523', '开鲁县', '150500');
INSERT INTO `jay_area` VALUES ('392', '150524', '库伦旗', '150500');
INSERT INTO `jay_area` VALUES ('393', '150525', '奈曼旗', '150500');
INSERT INTO `jay_area` VALUES ('394', '150526', '扎鲁特旗', '150500');
INSERT INTO `jay_area` VALUES ('395', '150581', '霍林郭勒市', '150500');
INSERT INTO `jay_area` VALUES ('396', '150602', '东胜区', '150600');
INSERT INTO `jay_area` VALUES ('397', '150621', '达拉特旗', '150600');
INSERT INTO `jay_area` VALUES ('398', '150622', '准格尔旗', '150600');
INSERT INTO `jay_area` VALUES ('399', '150623', '鄂托克前旗', '150600');
INSERT INTO `jay_area` VALUES ('400', '150624', '鄂托克旗', '150600');
INSERT INTO `jay_area` VALUES ('401', '150625', '杭锦旗', '150600');
INSERT INTO `jay_area` VALUES ('402', '150626', '乌审旗', '150600');
INSERT INTO `jay_area` VALUES ('403', '150627', '伊金霍洛旗', '150600');
INSERT INTO `jay_area` VALUES ('404', '150701', '市辖区', '150700');
INSERT INTO `jay_area` VALUES ('405', '150702', '海拉尔区', '150700');
INSERT INTO `jay_area` VALUES ('406', '150721', '阿荣旗', '150700');
INSERT INTO `jay_area` VALUES ('407', '150722', '莫力达瓦达斡尔族自治旗', '150700');
INSERT INTO `jay_area` VALUES ('408', '150723', '鄂伦春自治旗', '150700');
INSERT INTO `jay_area` VALUES ('409', '150724', '鄂温克族自治旗', '150700');
INSERT INTO `jay_area` VALUES ('410', '150725', '陈巴尔虎旗', '150700');
INSERT INTO `jay_area` VALUES ('411', '150726', '新巴尔虎左旗', '150700');
INSERT INTO `jay_area` VALUES ('412', '150727', '新巴尔虎右旗', '150700');
INSERT INTO `jay_area` VALUES ('413', '150781', '满洲里市', '150700');
INSERT INTO `jay_area` VALUES ('414', '150782', '牙克石市', '150700');
INSERT INTO `jay_area` VALUES ('415', '150783', '扎兰屯市', '150700');
INSERT INTO `jay_area` VALUES ('416', '150784', '额尔古纳市', '150700');
INSERT INTO `jay_area` VALUES ('417', '150785', '根河市', '150700');
INSERT INTO `jay_area` VALUES ('418', '150801', '市辖区', '150800');
INSERT INTO `jay_area` VALUES ('419', '150802', '临河区', '150800');
INSERT INTO `jay_area` VALUES ('420', '150821', '五原县', '150800');
INSERT INTO `jay_area` VALUES ('421', '150822', '磴口县', '150800');
INSERT INTO `jay_area` VALUES ('422', '150823', '乌拉特前旗', '150800');
INSERT INTO `jay_area` VALUES ('423', '150824', '乌拉特中旗', '150800');
INSERT INTO `jay_area` VALUES ('424', '150825', '乌拉特后旗', '150800');
INSERT INTO `jay_area` VALUES ('425', '150826', '杭锦后旗', '150800');
INSERT INTO `jay_area` VALUES ('426', '150901', '市辖区', '150900');
INSERT INTO `jay_area` VALUES ('427', '150902', '集宁区', '150900');
INSERT INTO `jay_area` VALUES ('428', '150921', '卓资县', '150900');
INSERT INTO `jay_area` VALUES ('429', '150922', '化德县', '150900');
INSERT INTO `jay_area` VALUES ('430', '150923', '商都县', '150900');
INSERT INTO `jay_area` VALUES ('431', '150924', '兴和县', '150900');
INSERT INTO `jay_area` VALUES ('432', '150925', '凉城县', '150900');
INSERT INTO `jay_area` VALUES ('433', '150926', '察哈尔右翼前旗', '150900');
INSERT INTO `jay_area` VALUES ('434', '150927', '察哈尔右翼中旗', '150900');
INSERT INTO `jay_area` VALUES ('435', '150928', '察哈尔右翼后旗', '150900');
INSERT INTO `jay_area` VALUES ('436', '150929', '四子王旗', '150900');
INSERT INTO `jay_area` VALUES ('437', '150981', '丰镇市', '150900');
INSERT INTO `jay_area` VALUES ('438', '152201', '乌兰浩特市', '152200');
INSERT INTO `jay_area` VALUES ('439', '152202', '阿尔山市', '152200');
INSERT INTO `jay_area` VALUES ('440', '152221', '科尔沁右翼前旗', '152200');
INSERT INTO `jay_area` VALUES ('441', '152222', '科尔沁右翼中旗', '152200');
INSERT INTO `jay_area` VALUES ('442', '152223', '扎赉特旗', '152200');
INSERT INTO `jay_area` VALUES ('443', '152224', '突泉县', '152200');
INSERT INTO `jay_area` VALUES ('444', '152501', '二连浩特市', '152500');
INSERT INTO `jay_area` VALUES ('445', '152502', '锡林浩特市', '152500');
INSERT INTO `jay_area` VALUES ('446', '152522', '阿巴嘎旗', '152500');
INSERT INTO `jay_area` VALUES ('447', '152523', '苏尼特左旗', '152500');
INSERT INTO `jay_area` VALUES ('448', '152524', '苏尼特右旗', '152500');
INSERT INTO `jay_area` VALUES ('449', '152525', '东乌珠穆沁旗', '152500');
INSERT INTO `jay_area` VALUES ('450', '152526', '西乌珠穆沁旗', '152500');
INSERT INTO `jay_area` VALUES ('451', '152527', '太仆寺旗', '152500');
INSERT INTO `jay_area` VALUES ('452', '152528', '镶黄旗', '152500');
INSERT INTO `jay_area` VALUES ('453', '152529', '正镶白旗', '152500');
INSERT INTO `jay_area` VALUES ('454', '152530', '正蓝旗', '152500');
INSERT INTO `jay_area` VALUES ('455', '152531', '多伦县', '152500');
INSERT INTO `jay_area` VALUES ('456', '152921', '阿拉善左旗', '152900');
INSERT INTO `jay_area` VALUES ('457', '152922', '阿拉善右旗', '152900');
INSERT INTO `jay_area` VALUES ('458', '152923', '额济纳旗', '152900');
INSERT INTO `jay_area` VALUES ('459', '210101', '市辖区', '210100');
INSERT INTO `jay_area` VALUES ('460', '210102', '和平区', '210100');
INSERT INTO `jay_area` VALUES ('461', '210103', '沈河区', '210100');
INSERT INTO `jay_area` VALUES ('462', '210104', '大东区', '210100');
INSERT INTO `jay_area` VALUES ('463', '210105', '皇姑区', '210100');
INSERT INTO `jay_area` VALUES ('464', '210106', '铁西区', '210100');
INSERT INTO `jay_area` VALUES ('465', '210111', '苏家屯区', '210100');
INSERT INTO `jay_area` VALUES ('466', '210112', '东陵区', '210100');
INSERT INTO `jay_area` VALUES ('467', '210113', '新城子区', '210100');
INSERT INTO `jay_area` VALUES ('468', '210114', '于洪区', '210100');
INSERT INTO `jay_area` VALUES ('469', '210122', '辽中县', '210100');
INSERT INTO `jay_area` VALUES ('470', '210123', '康平县', '210100');
INSERT INTO `jay_area` VALUES ('471', '210124', '法库县', '210100');
INSERT INTO `jay_area` VALUES ('472', '210181', '新民市', '210100');
INSERT INTO `jay_area` VALUES ('473', '210201', '市辖区', '210200');
INSERT INTO `jay_area` VALUES ('474', '210202', '中山区', '210200');
INSERT INTO `jay_area` VALUES ('475', '210203', '西岗区', '210200');
INSERT INTO `jay_area` VALUES ('476', '210204', '沙河口区', '210200');
INSERT INTO `jay_area` VALUES ('477', '210211', '甘井子区', '210200');
INSERT INTO `jay_area` VALUES ('478', '210212', '旅顺口区', '210200');
INSERT INTO `jay_area` VALUES ('479', '210213', '金州区', '210200');
INSERT INTO `jay_area` VALUES ('480', '210224', '长海县', '210200');
INSERT INTO `jay_area` VALUES ('481', '210281', '瓦房店市', '210200');
INSERT INTO `jay_area` VALUES ('482', '210282', '普兰店市', '210200');
INSERT INTO `jay_area` VALUES ('483', '210283', '庄河市', '210200');
INSERT INTO `jay_area` VALUES ('484', '210301', '市辖区', '210300');
INSERT INTO `jay_area` VALUES ('485', '210302', '铁东区', '210300');
INSERT INTO `jay_area` VALUES ('486', '210303', '铁西区', '210300');
INSERT INTO `jay_area` VALUES ('487', '210304', '立山区', '210300');
INSERT INTO `jay_area` VALUES ('488', '210311', '千山区', '210300');
INSERT INTO `jay_area` VALUES ('489', '210321', '台安县', '210300');
INSERT INTO `jay_area` VALUES ('490', '210323', '岫岩满族自治县', '210300');
INSERT INTO `jay_area` VALUES ('491', '210381', '海城市', '210300');
INSERT INTO `jay_area` VALUES ('492', '210401', '市辖区', '210400');
INSERT INTO `jay_area` VALUES ('493', '210402', '新抚区', '210400');
INSERT INTO `jay_area` VALUES ('494', '210403', '东洲区', '210400');
INSERT INTO `jay_area` VALUES ('495', '210404', '望花区', '210400');
INSERT INTO `jay_area` VALUES ('496', '210411', '顺城区', '210400');
INSERT INTO `jay_area` VALUES ('497', '210421', '抚顺县', '210400');
INSERT INTO `jay_area` VALUES ('498', '210422', '新宾满族自治县', '210400');
INSERT INTO `jay_area` VALUES ('499', '210423', '清原满族自治县', '210400');
INSERT INTO `jay_area` VALUES ('500', '210501', '市辖区', '210500');
INSERT INTO `jay_area` VALUES ('501', '210502', '平山区', '210500');
INSERT INTO `jay_area` VALUES ('502', '210503', '溪湖区', '210500');
INSERT INTO `jay_area` VALUES ('503', '210504', '明山区', '210500');
INSERT INTO `jay_area` VALUES ('504', '210505', '南芬区', '210500');
INSERT INTO `jay_area` VALUES ('505', '210521', '本溪满族自治县', '210500');
INSERT INTO `jay_area` VALUES ('506', '210522', '桓仁满族自治县', '210500');
INSERT INTO `jay_area` VALUES ('507', '210601', '市辖区', '210600');
INSERT INTO `jay_area` VALUES ('508', '210602', '元宝区', '210600');
INSERT INTO `jay_area` VALUES ('509', '210603', '振兴区', '210600');
INSERT INTO `jay_area` VALUES ('510', '210604', '振安区', '210600');
INSERT INTO `jay_area` VALUES ('511', '210624', '宽甸满族自治县', '210600');
INSERT INTO `jay_area` VALUES ('512', '210681', '东港市', '210600');
INSERT INTO `jay_area` VALUES ('513', '210682', '凤城市', '210600');
INSERT INTO `jay_area` VALUES ('514', '210701', '市辖区', '210700');
INSERT INTO `jay_area` VALUES ('515', '210702', '古塔区', '210700');
INSERT INTO `jay_area` VALUES ('516', '210703', '凌河区', '210700');
INSERT INTO `jay_area` VALUES ('517', '210711', '太和区', '210700');
INSERT INTO `jay_area` VALUES ('518', '210726', '黑山县', '210700');
INSERT INTO `jay_area` VALUES ('519', '210727', '义　县', '210700');
INSERT INTO `jay_area` VALUES ('520', '210781', '凌海市', '210700');
INSERT INTO `jay_area` VALUES ('521', '210782', '北宁市', '210700');
INSERT INTO `jay_area` VALUES ('522', '210801', '市辖区', '210800');
INSERT INTO `jay_area` VALUES ('523', '210802', '站前区', '210800');
INSERT INTO `jay_area` VALUES ('524', '210803', '西市区', '210800');
INSERT INTO `jay_area` VALUES ('525', '210804', '鲅鱼圈区', '210800');
INSERT INTO `jay_area` VALUES ('526', '210811', '老边区', '210800');
INSERT INTO `jay_area` VALUES ('527', '210881', '盖州市', '210800');
INSERT INTO `jay_area` VALUES ('528', '210882', '大石桥市', '210800');
INSERT INTO `jay_area` VALUES ('529', '210901', '市辖区', '210900');
INSERT INTO `jay_area` VALUES ('530', '210902', '海州区', '210900');
INSERT INTO `jay_area` VALUES ('531', '210903', '新邱区', '210900');
INSERT INTO `jay_area` VALUES ('532', '210904', '太平区', '210900');
INSERT INTO `jay_area` VALUES ('533', '210905', '清河门区', '210900');
INSERT INTO `jay_area` VALUES ('534', '210911', '细河区', '210900');
INSERT INTO `jay_area` VALUES ('535', '210921', '阜新蒙古族自治县', '210900');
INSERT INTO `jay_area` VALUES ('536', '210922', '彰武县', '210900');
INSERT INTO `jay_area` VALUES ('537', '211001', '市辖区', '211000');
INSERT INTO `jay_area` VALUES ('538', '211002', '白塔区', '211000');
INSERT INTO `jay_area` VALUES ('539', '211003', '文圣区', '211000');
INSERT INTO `jay_area` VALUES ('540', '211004', '宏伟区', '211000');
INSERT INTO `jay_area` VALUES ('541', '211005', '弓长岭区', '211000');
INSERT INTO `jay_area` VALUES ('542', '211011', '太子河区', '211000');
INSERT INTO `jay_area` VALUES ('543', '211021', '辽阳县', '211000');
INSERT INTO `jay_area` VALUES ('544', '211081', '灯塔市', '211000');
INSERT INTO `jay_area` VALUES ('545', '211101', '市辖区', '211100');
INSERT INTO `jay_area` VALUES ('546', '211102', '双台子区', '211100');
INSERT INTO `jay_area` VALUES ('547', '211103', '兴隆台区', '211100');
INSERT INTO `jay_area` VALUES ('548', '211121', '大洼县', '211100');
INSERT INTO `jay_area` VALUES ('549', '211122', '盘山县', '211100');
INSERT INTO `jay_area` VALUES ('550', '211201', '市辖区', '211200');
INSERT INTO `jay_area` VALUES ('551', '211202', '银州区', '211200');
INSERT INTO `jay_area` VALUES ('552', '211204', '清河区', '211200');
INSERT INTO `jay_area` VALUES ('553', '211221', '铁岭县', '211200');
INSERT INTO `jay_area` VALUES ('554', '211223', '西丰县', '211200');
INSERT INTO `jay_area` VALUES ('555', '211224', '昌图县', '211200');
INSERT INTO `jay_area` VALUES ('556', '211281', '调兵山市', '211200');
INSERT INTO `jay_area` VALUES ('557', '211282', '开原市', '211200');
INSERT INTO `jay_area` VALUES ('558', '211301', '市辖区', '211300');
INSERT INTO `jay_area` VALUES ('559', '211302', '双塔区', '211300');
INSERT INTO `jay_area` VALUES ('560', '211303', '龙城区', '211300');
INSERT INTO `jay_area` VALUES ('561', '211321', '朝阳县', '211300');
INSERT INTO `jay_area` VALUES ('562', '211322', '建平县', '211300');
INSERT INTO `jay_area` VALUES ('563', '211324', '喀喇沁左翼蒙古族自治县', '211300');
INSERT INTO `jay_area` VALUES ('564', '211381', '北票市', '211300');
INSERT INTO `jay_area` VALUES ('565', '211382', '凌源市', '211300');
INSERT INTO `jay_area` VALUES ('566', '211401', '市辖区', '211400');
INSERT INTO `jay_area` VALUES ('567', '211402', '连山区', '211400');
INSERT INTO `jay_area` VALUES ('568', '211403', '龙港区', '211400');
INSERT INTO `jay_area` VALUES ('569', '211404', '南票区', '211400');
INSERT INTO `jay_area` VALUES ('570', '211421', '绥中县', '211400');
INSERT INTO `jay_area` VALUES ('571', '211422', '建昌县', '211400');
INSERT INTO `jay_area` VALUES ('572', '211481', '兴城市', '211400');
INSERT INTO `jay_area` VALUES ('573', '220101', '市辖区', '220100');
INSERT INTO `jay_area` VALUES ('574', '220102', '南关区', '220100');
INSERT INTO `jay_area` VALUES ('575', '220103', '宽城区', '220100');
INSERT INTO `jay_area` VALUES ('576', '220104', '朝阳区', '220100');
INSERT INTO `jay_area` VALUES ('577', '220105', '二道区', '220100');
INSERT INTO `jay_area` VALUES ('578', '220106', '绿园区', '220100');
INSERT INTO `jay_area` VALUES ('579', '220112', '双阳区', '220100');
INSERT INTO `jay_area` VALUES ('580', '220122', '农安县', '220100');
INSERT INTO `jay_area` VALUES ('581', '220181', '九台市', '220100');
INSERT INTO `jay_area` VALUES ('582', '220182', '榆树市', '220100');
INSERT INTO `jay_area` VALUES ('583', '220183', '德惠市', '220100');
INSERT INTO `jay_area` VALUES ('584', '220201', '市辖区', '220200');
INSERT INTO `jay_area` VALUES ('585', '220202', '昌邑区', '220200');
INSERT INTO `jay_area` VALUES ('586', '220203', '龙潭区', '220200');
INSERT INTO `jay_area` VALUES ('587', '220204', '船营区', '220200');
INSERT INTO `jay_area` VALUES ('588', '220211', '丰满区', '220200');
INSERT INTO `jay_area` VALUES ('589', '220221', '永吉县', '220200');
INSERT INTO `jay_area` VALUES ('590', '220281', '蛟河市', '220200');
INSERT INTO `jay_area` VALUES ('591', '220282', '桦甸市', '220200');
INSERT INTO `jay_area` VALUES ('592', '220283', '舒兰市', '220200');
INSERT INTO `jay_area` VALUES ('593', '220284', '磐石市', '220200');
INSERT INTO `jay_area` VALUES ('594', '220301', '市辖区', '220300');
INSERT INTO `jay_area` VALUES ('595', '220302', '铁西区', '220300');
INSERT INTO `jay_area` VALUES ('596', '220303', '铁东区', '220300');
INSERT INTO `jay_area` VALUES ('597', '220322', '梨树县', '220300');
INSERT INTO `jay_area` VALUES ('598', '220323', '伊通满族自治县', '220300');
INSERT INTO `jay_area` VALUES ('599', '220381', '公主岭市', '220300');
INSERT INTO `jay_area` VALUES ('600', '220382', '双辽市', '220300');
INSERT INTO `jay_area` VALUES ('601', '220401', '市辖区', '220400');
INSERT INTO `jay_area` VALUES ('602', '220402', '龙山区', '220400');
INSERT INTO `jay_area` VALUES ('603', '220403', '西安区', '220400');
INSERT INTO `jay_area` VALUES ('604', '220421', '东丰县', '220400');
INSERT INTO `jay_area` VALUES ('605', '220422', '东辽县', '220400');
INSERT INTO `jay_area` VALUES ('606', '220501', '市辖区', '220500');
INSERT INTO `jay_area` VALUES ('607', '220502', '东昌区', '220500');
INSERT INTO `jay_area` VALUES ('608', '220503', '二道江区', '220500');
INSERT INTO `jay_area` VALUES ('609', '220521', '通化县', '220500');
INSERT INTO `jay_area` VALUES ('610', '220523', '辉南县', '220500');
INSERT INTO `jay_area` VALUES ('611', '220524', '柳河县', '220500');
INSERT INTO `jay_area` VALUES ('612', '220581', '梅河口市', '220500');
INSERT INTO `jay_area` VALUES ('613', '220582', '集安市', '220500');
INSERT INTO `jay_area` VALUES ('614', '220601', '市辖区', '220600');
INSERT INTO `jay_area` VALUES ('615', '220602', '八道江区', '220600');
INSERT INTO `jay_area` VALUES ('616', '220621', '抚松县', '220600');
INSERT INTO `jay_area` VALUES ('617', '220622', '靖宇县', '220600');
INSERT INTO `jay_area` VALUES ('618', '220623', '长白朝鲜族自治县', '220600');
INSERT INTO `jay_area` VALUES ('619', '220625', '江源县', '220600');
INSERT INTO `jay_area` VALUES ('620', '220681', '临江市', '220600');
INSERT INTO `jay_area` VALUES ('621', '220701', '市辖区', '220700');
INSERT INTO `jay_area` VALUES ('622', '220702', '宁江区', '220700');
INSERT INTO `jay_area` VALUES ('623', '220721', '前郭尔罗斯蒙古族自治县', '220700');
INSERT INTO `jay_area` VALUES ('624', '220722', '长岭县', '220700');
INSERT INTO `jay_area` VALUES ('625', '220723', '乾安县', '220700');
INSERT INTO `jay_area` VALUES ('626', '220724', '扶余县', '220700');
INSERT INTO `jay_area` VALUES ('627', '220801', '市辖区', '220800');
INSERT INTO `jay_area` VALUES ('628', '220802', '洮北区', '220800');
INSERT INTO `jay_area` VALUES ('629', '220821', '镇赉县', '220800');
INSERT INTO `jay_area` VALUES ('630', '220822', '通榆县', '220800');
INSERT INTO `jay_area` VALUES ('631', '220881', '洮南市', '220800');
INSERT INTO `jay_area` VALUES ('632', '220882', '大安市', '220800');
INSERT INTO `jay_area` VALUES ('633', '222401', '延吉市', '222400');
INSERT INTO `jay_area` VALUES ('634', '222402', '图们市', '222400');
INSERT INTO `jay_area` VALUES ('635', '222403', '敦化市', '222400');
INSERT INTO `jay_area` VALUES ('636', '222404', '珲春市', '222400');
INSERT INTO `jay_area` VALUES ('637', '222405', '龙井市', '222400');
INSERT INTO `jay_area` VALUES ('638', '222406', '和龙市', '222400');
INSERT INTO `jay_area` VALUES ('639', '222424', '汪清县', '222400');
INSERT INTO `jay_area` VALUES ('640', '222426', '安图县', '222400');
INSERT INTO `jay_area` VALUES ('641', '230101', '市辖区', '230100');
INSERT INTO `jay_area` VALUES ('642', '230102', '道里区', '230100');
INSERT INTO `jay_area` VALUES ('643', '230103', '南岗区', '230100');
INSERT INTO `jay_area` VALUES ('644', '230104', '道外区', '230100');
INSERT INTO `jay_area` VALUES ('645', '230106', '香坊区', '230100');
INSERT INTO `jay_area` VALUES ('646', '230107', '动力区', '230100');
INSERT INTO `jay_area` VALUES ('647', '230108', '平房区', '230100');
INSERT INTO `jay_area` VALUES ('648', '230109', '松北区', '230100');
INSERT INTO `jay_area` VALUES ('649', '230111', '呼兰区', '230100');
INSERT INTO `jay_area` VALUES ('650', '230123', '依兰县', '230100');
INSERT INTO `jay_area` VALUES ('651', '230124', '方正县', '230100');
INSERT INTO `jay_area` VALUES ('652', '230125', '宾　县', '230100');
INSERT INTO `jay_area` VALUES ('653', '230126', '巴彦县', '230100');
INSERT INTO `jay_area` VALUES ('654', '230127', '木兰县', '230100');
INSERT INTO `jay_area` VALUES ('655', '230128', '通河县', '230100');
INSERT INTO `jay_area` VALUES ('656', '230129', '延寿县', '230100');
INSERT INTO `jay_area` VALUES ('657', '230181', '阿城市', '230100');
INSERT INTO `jay_area` VALUES ('658', '230182', '双城市', '230100');
INSERT INTO `jay_area` VALUES ('659', '230183', '尚志市', '230100');
INSERT INTO `jay_area` VALUES ('660', '230184', '五常市', '230100');
INSERT INTO `jay_area` VALUES ('661', '230201', '市辖区', '230200');
INSERT INTO `jay_area` VALUES ('662', '230202', '龙沙区', '230200');
INSERT INTO `jay_area` VALUES ('663', '230203', '建华区', '230200');
INSERT INTO `jay_area` VALUES ('664', '230204', '铁锋区', '230200');
INSERT INTO `jay_area` VALUES ('665', '230205', '昂昂溪区', '230200');
INSERT INTO `jay_area` VALUES ('666', '230206', '富拉尔基区', '230200');
INSERT INTO `jay_area` VALUES ('667', '230207', '碾子山区', '230200');
INSERT INTO `jay_area` VALUES ('668', '230208', '梅里斯达斡尔族区', '230200');
INSERT INTO `jay_area` VALUES ('669', '230221', '龙江县', '230200');
INSERT INTO `jay_area` VALUES ('670', '230223', '依安县', '230200');
INSERT INTO `jay_area` VALUES ('671', '230224', '泰来县', '230200');
INSERT INTO `jay_area` VALUES ('672', '230225', '甘南县', '230200');
INSERT INTO `jay_area` VALUES ('673', '230227', '富裕县', '230200');
INSERT INTO `jay_area` VALUES ('674', '230229', '克山县', '230200');
INSERT INTO `jay_area` VALUES ('675', '230230', '克东县', '230200');
INSERT INTO `jay_area` VALUES ('676', '230231', '拜泉县', '230200');
INSERT INTO `jay_area` VALUES ('677', '230281', '讷河市', '230200');
INSERT INTO `jay_area` VALUES ('678', '230301', '市辖区', '230300');
INSERT INTO `jay_area` VALUES ('679', '230302', '鸡冠区', '230300');
INSERT INTO `jay_area` VALUES ('680', '230303', '恒山区', '230300');
INSERT INTO `jay_area` VALUES ('681', '230304', '滴道区', '230300');
INSERT INTO `jay_area` VALUES ('682', '230305', '梨树区', '230300');
INSERT INTO `jay_area` VALUES ('683', '230306', '城子河区', '230300');
INSERT INTO `jay_area` VALUES ('684', '230307', '麻山区', '230300');
INSERT INTO `jay_area` VALUES ('685', '230321', '鸡东县', '230300');
INSERT INTO `jay_area` VALUES ('686', '230381', '虎林市', '230300');
INSERT INTO `jay_area` VALUES ('687', '230382', '密山市', '230300');
INSERT INTO `jay_area` VALUES ('688', '230401', '市辖区', '230400');
INSERT INTO `jay_area` VALUES ('689', '230402', '向阳区', '230400');
INSERT INTO `jay_area` VALUES ('690', '230403', '工农区', '230400');
INSERT INTO `jay_area` VALUES ('691', '230404', '南山区', '230400');
INSERT INTO `jay_area` VALUES ('692', '230405', '兴安区', '230400');
INSERT INTO `jay_area` VALUES ('693', '230406', '东山区', '230400');
INSERT INTO `jay_area` VALUES ('694', '230407', '兴山区', '230400');
INSERT INTO `jay_area` VALUES ('695', '230421', '萝北县', '230400');
INSERT INTO `jay_area` VALUES ('696', '230422', '绥滨县', '230400');
INSERT INTO `jay_area` VALUES ('697', '230501', '市辖区', '230500');
INSERT INTO `jay_area` VALUES ('698', '230502', '尖山区', '230500');
INSERT INTO `jay_area` VALUES ('699', '230503', '岭东区', '230500');
INSERT INTO `jay_area` VALUES ('700', '230505', '四方台区', '230500');
INSERT INTO `jay_area` VALUES ('701', '230506', '宝山区', '230500');
INSERT INTO `jay_area` VALUES ('702', '230521', '集贤县', '230500');
INSERT INTO `jay_area` VALUES ('703', '230522', '友谊县', '230500');
INSERT INTO `jay_area` VALUES ('704', '230523', '宝清县', '230500');
INSERT INTO `jay_area` VALUES ('705', '230524', '饶河县', '230500');
INSERT INTO `jay_area` VALUES ('706', '230601', '市辖区', '230600');
INSERT INTO `jay_area` VALUES ('707', '230602', '萨尔图区', '230600');
INSERT INTO `jay_area` VALUES ('708', '230603', '龙凤区', '230600');
INSERT INTO `jay_area` VALUES ('709', '230604', '让胡路区', '230600');
INSERT INTO `jay_area` VALUES ('710', '230605', '红岗区', '230600');
INSERT INTO `jay_area` VALUES ('711', '230606', '大同区', '230600');
INSERT INTO `jay_area` VALUES ('712', '230621', '肇州县', '230600');
INSERT INTO `jay_area` VALUES ('713', '230622', '肇源县', '230600');
INSERT INTO `jay_area` VALUES ('714', '230623', '林甸县', '230600');
INSERT INTO `jay_area` VALUES ('715', '230624', '杜尔伯特蒙古族自治县', '230600');
INSERT INTO `jay_area` VALUES ('716', '230701', '市辖区', '230700');
INSERT INTO `jay_area` VALUES ('717', '230702', '伊春区', '230700');
INSERT INTO `jay_area` VALUES ('718', '230703', '南岔区', '230700');
INSERT INTO `jay_area` VALUES ('719', '230704', '友好区', '230700');
INSERT INTO `jay_area` VALUES ('720', '230705', '西林区', '230700');
INSERT INTO `jay_area` VALUES ('721', '230706', '翠峦区', '230700');
INSERT INTO `jay_area` VALUES ('722', '230707', '新青区', '230700');
INSERT INTO `jay_area` VALUES ('723', '230708', '美溪区', '230700');
INSERT INTO `jay_area` VALUES ('724', '230709', '金山屯区', '230700');
INSERT INTO `jay_area` VALUES ('725', '230710', '五营区', '230700');
INSERT INTO `jay_area` VALUES ('726', '230711', '乌马河区', '230700');
INSERT INTO `jay_area` VALUES ('727', '230712', '汤旺河区', '230700');
INSERT INTO `jay_area` VALUES ('728', '230713', '带岭区', '230700');
INSERT INTO `jay_area` VALUES ('729', '230714', '乌伊岭区', '230700');
INSERT INTO `jay_area` VALUES ('730', '230715', '红星区', '230700');
INSERT INTO `jay_area` VALUES ('731', '230716', '上甘岭区', '230700');
INSERT INTO `jay_area` VALUES ('732', '230722', '嘉荫县', '230700');
INSERT INTO `jay_area` VALUES ('733', '230781', '铁力市', '230700');
INSERT INTO `jay_area` VALUES ('734', '230801', '市辖区', '230800');
INSERT INTO `jay_area` VALUES ('735', '230802', '永红区', '230800');
INSERT INTO `jay_area` VALUES ('736', '230803', '向阳区', '230800');
INSERT INTO `jay_area` VALUES ('737', '230804', '前进区', '230800');
INSERT INTO `jay_area` VALUES ('738', '230805', '东风区', '230800');
INSERT INTO `jay_area` VALUES ('739', '230811', '郊　区', '230800');
INSERT INTO `jay_area` VALUES ('740', '230822', '桦南县', '230800');
INSERT INTO `jay_area` VALUES ('741', '230826', '桦川县', '230800');
INSERT INTO `jay_area` VALUES ('742', '230828', '汤原县', '230800');
INSERT INTO `jay_area` VALUES ('743', '230833', '抚远县', '230800');
INSERT INTO `jay_area` VALUES ('744', '230881', '同江市', '230800');
INSERT INTO `jay_area` VALUES ('745', '230882', '富锦市', '230800');
INSERT INTO `jay_area` VALUES ('746', '230901', '市辖区', '230900');
INSERT INTO `jay_area` VALUES ('747', '230902', '新兴区', '230900');
INSERT INTO `jay_area` VALUES ('748', '230903', '桃山区', '230900');
INSERT INTO `jay_area` VALUES ('749', '230904', '茄子河区', '230900');
INSERT INTO `jay_area` VALUES ('750', '230921', '勃利县', '230900');
INSERT INTO `jay_area` VALUES ('751', '231001', '市辖区', '231000');
INSERT INTO `jay_area` VALUES ('752', '231002', '东安区', '231000');
INSERT INTO `jay_area` VALUES ('753', '231003', '阳明区', '231000');
INSERT INTO `jay_area` VALUES ('754', '231004', '爱民区', '231000');
INSERT INTO `jay_area` VALUES ('755', '231005', '西安区', '231000');
INSERT INTO `jay_area` VALUES ('756', '231024', '东宁县', '231000');
INSERT INTO `jay_area` VALUES ('757', '231025', '林口县', '231000');
INSERT INTO `jay_area` VALUES ('758', '231081', '绥芬河市', '231000');
INSERT INTO `jay_area` VALUES ('759', '231083', '海林市', '231000');
INSERT INTO `jay_area` VALUES ('760', '231084', '宁安市', '231000');
INSERT INTO `jay_area` VALUES ('761', '231085', '穆棱市', '231000');
INSERT INTO `jay_area` VALUES ('762', '231101', '市辖区', '231100');
INSERT INTO `jay_area` VALUES ('763', '231102', '爱辉区', '231100');
INSERT INTO `jay_area` VALUES ('764', '231121', '嫩江县', '231100');
INSERT INTO `jay_area` VALUES ('765', '231123', '逊克县', '231100');
INSERT INTO `jay_area` VALUES ('766', '231124', '孙吴县', '231100');
INSERT INTO `jay_area` VALUES ('767', '231181', '北安市', '231100');
INSERT INTO `jay_area` VALUES ('768', '231182', '五大连池市', '231100');
INSERT INTO `jay_area` VALUES ('769', '231201', '市辖区', '231200');
INSERT INTO `jay_area` VALUES ('770', '231202', '北林区', '231200');
INSERT INTO `jay_area` VALUES ('771', '231221', '望奎县', '231200');
INSERT INTO `jay_area` VALUES ('772', '231222', '兰西县', '231200');
INSERT INTO `jay_area` VALUES ('773', '231223', '青冈县', '231200');
INSERT INTO `jay_area` VALUES ('774', '231224', '庆安县', '231200');
INSERT INTO `jay_area` VALUES ('775', '231225', '明水县', '231200');
INSERT INTO `jay_area` VALUES ('776', '231226', '绥棱县', '231200');
INSERT INTO `jay_area` VALUES ('777', '231281', '安达市', '231200');
INSERT INTO `jay_area` VALUES ('778', '231282', '肇东市', '231200');
INSERT INTO `jay_area` VALUES ('779', '231283', '海伦市', '231200');
INSERT INTO `jay_area` VALUES ('780', '232721', '呼玛县', '232700');
INSERT INTO `jay_area` VALUES ('781', '232722', '塔河县', '232700');
INSERT INTO `jay_area` VALUES ('782', '232723', '漠河县', '232700');
INSERT INTO `jay_area` VALUES ('783', '310101', '黄浦区', '310100');
INSERT INTO `jay_area` VALUES ('784', '310103', '卢湾区', '310100');
INSERT INTO `jay_area` VALUES ('785', '310104', '徐汇区', '310100');
INSERT INTO `jay_area` VALUES ('786', '310105', '长宁区', '310100');
INSERT INTO `jay_area` VALUES ('787', '310106', '静安区', '310100');
INSERT INTO `jay_area` VALUES ('788', '310107', '普陀区', '310100');
INSERT INTO `jay_area` VALUES ('789', '310108', '闸北区', '310100');
INSERT INTO `jay_area` VALUES ('790', '310109', '虹口区', '310100');
INSERT INTO `jay_area` VALUES ('791', '310110', '杨浦区', '310100');
INSERT INTO `jay_area` VALUES ('792', '310112', '闵行区', '310100');
INSERT INTO `jay_area` VALUES ('793', '310113', '宝山区', '310100');
INSERT INTO `jay_area` VALUES ('794', '310114', '嘉定区', '310100');
INSERT INTO `jay_area` VALUES ('795', '310115', '浦东新区', '310100');
INSERT INTO `jay_area` VALUES ('796', '310116', '金山区', '310100');
INSERT INTO `jay_area` VALUES ('797', '310117', '松江区', '310100');
INSERT INTO `jay_area` VALUES ('798', '310118', '青浦区', '310100');
INSERT INTO `jay_area` VALUES ('799', '310119', '南汇区', '310100');
INSERT INTO `jay_area` VALUES ('800', '310120', '奉贤区', '310100');
INSERT INTO `jay_area` VALUES ('801', '310230', '崇明县', '310200');
INSERT INTO `jay_area` VALUES ('802', '320101', '市辖区', '320100');
INSERT INTO `jay_area` VALUES ('803', '320102', '玄武区', '320100');
INSERT INTO `jay_area` VALUES ('804', '320103', '白下区', '320100');
INSERT INTO `jay_area` VALUES ('805', '320104', '秦淮区', '320100');
INSERT INTO `jay_area` VALUES ('806', '320105', '建邺区', '320100');
INSERT INTO `jay_area` VALUES ('807', '320106', '鼓楼区', '320100');
INSERT INTO `jay_area` VALUES ('808', '320107', '下关区', '320100');
INSERT INTO `jay_area` VALUES ('809', '320111', '浦口区', '320100');
INSERT INTO `jay_area` VALUES ('810', '320113', '栖霞区', '320100');
INSERT INTO `jay_area` VALUES ('811', '320114', '雨花台区', '320100');
INSERT INTO `jay_area` VALUES ('812', '320115', '江宁区', '320100');
INSERT INTO `jay_area` VALUES ('813', '320116', '六合区', '320100');
INSERT INTO `jay_area` VALUES ('814', '320124', '溧水县', '320100');
INSERT INTO `jay_area` VALUES ('815', '320125', '高淳县', '320100');
INSERT INTO `jay_area` VALUES ('816', '320201', '市辖区', '320200');
INSERT INTO `jay_area` VALUES ('817', '320202', '崇安区', '320200');
INSERT INTO `jay_area` VALUES ('818', '320203', '南长区', '320200');
INSERT INTO `jay_area` VALUES ('819', '320204', '北塘区', '320200');
INSERT INTO `jay_area` VALUES ('820', '320205', '锡山区', '320200');
INSERT INTO `jay_area` VALUES ('821', '320206', '惠山区', '320200');
INSERT INTO `jay_area` VALUES ('822', '320211', '滨湖区', '320200');
INSERT INTO `jay_area` VALUES ('823', '320281', '江阴市', '320200');
INSERT INTO `jay_area` VALUES ('824', '320282', '宜兴市', '320200');
INSERT INTO `jay_area` VALUES ('825', '320301', '市辖区', '320300');
INSERT INTO `jay_area` VALUES ('826', '320302', '鼓楼区', '320300');
INSERT INTO `jay_area` VALUES ('827', '320303', '云龙区', '320300');
INSERT INTO `jay_area` VALUES ('828', '320304', '九里区', '320300');
INSERT INTO `jay_area` VALUES ('829', '320305', '贾汪区', '320300');
INSERT INTO `jay_area` VALUES ('830', '320311', '泉山区', '320300');
INSERT INTO `jay_area` VALUES ('831', '320321', '丰　县', '320300');
INSERT INTO `jay_area` VALUES ('832', '320322', '沛　县', '320300');
INSERT INTO `jay_area` VALUES ('833', '320323', '铜山县', '320300');
INSERT INTO `jay_area` VALUES ('834', '320324', '睢宁县', '320300');
INSERT INTO `jay_area` VALUES ('835', '320381', '新沂市', '320300');
INSERT INTO `jay_area` VALUES ('836', '320382', '邳州市', '320300');
INSERT INTO `jay_area` VALUES ('837', '320401', '市辖区', '320400');
INSERT INTO `jay_area` VALUES ('838', '320402', '天宁区', '320400');
INSERT INTO `jay_area` VALUES ('839', '320404', '钟楼区', '320400');
INSERT INTO `jay_area` VALUES ('840', '320405', '戚墅堰区', '320400');
INSERT INTO `jay_area` VALUES ('841', '320411', '新北区', '320400');
INSERT INTO `jay_area` VALUES ('842', '320412', '武进区', '320400');
INSERT INTO `jay_area` VALUES ('843', '320481', '溧阳市', '320400');
INSERT INTO `jay_area` VALUES ('844', '320482', '金坛市', '320400');
INSERT INTO `jay_area` VALUES ('845', '320501', '市辖区', '320500');
INSERT INTO `jay_area` VALUES ('846', '320502', '沧浪区', '320500');
INSERT INTO `jay_area` VALUES ('847', '320503', '平江区', '320500');
INSERT INTO `jay_area` VALUES ('848', '320504', '金阊区', '320500');
INSERT INTO `jay_area` VALUES ('849', '320505', '虎丘区', '320500');
INSERT INTO `jay_area` VALUES ('850', '320506', '吴中区', '320500');
INSERT INTO `jay_area` VALUES ('851', '320507', '相城区', '320500');
INSERT INTO `jay_area` VALUES ('852', '320581', '常熟市', '320500');
INSERT INTO `jay_area` VALUES ('853', '320582', '张家港市', '320500');
INSERT INTO `jay_area` VALUES ('854', '320583', '昆山市', '320500');
INSERT INTO `jay_area` VALUES ('855', '320584', '吴江市', '320500');
INSERT INTO `jay_area` VALUES ('856', '320585', '太仓市', '320500');
INSERT INTO `jay_area` VALUES ('857', '320601', '市辖区', '320600');
INSERT INTO `jay_area` VALUES ('858', '320602', '崇川区', '320600');
INSERT INTO `jay_area` VALUES ('859', '320611', '港闸区', '320600');
INSERT INTO `jay_area` VALUES ('860', '320621', '海安县', '320600');
INSERT INTO `jay_area` VALUES ('861', '320623', '如东县', '320600');
INSERT INTO `jay_area` VALUES ('862', '320681', '启东市', '320600');
INSERT INTO `jay_area` VALUES ('863', '320682', '如皋市', '320600');
INSERT INTO `jay_area` VALUES ('864', '320683', '通州市', '320600');
INSERT INTO `jay_area` VALUES ('865', '320684', '海门市', '320600');
INSERT INTO `jay_area` VALUES ('866', '320701', '市辖区', '320700');
INSERT INTO `jay_area` VALUES ('867', '320703', '连云区', '320700');
INSERT INTO `jay_area` VALUES ('868', '320705', '新浦区', '320700');
INSERT INTO `jay_area` VALUES ('869', '320706', '海州区', '320700');
INSERT INTO `jay_area` VALUES ('870', '320721', '赣榆县', '320700');
INSERT INTO `jay_area` VALUES ('871', '320722', '东海县', '320700');
INSERT INTO `jay_area` VALUES ('872', '320723', '灌云县', '320700');
INSERT INTO `jay_area` VALUES ('873', '320724', '灌南县', '320700');
INSERT INTO `jay_area` VALUES ('874', '320801', '市辖区', '320800');
INSERT INTO `jay_area` VALUES ('875', '320802', '清河区', '320800');
INSERT INTO `jay_area` VALUES ('876', '320803', '楚州区', '320800');
INSERT INTO `jay_area` VALUES ('877', '320804', '淮阴区', '320800');
INSERT INTO `jay_area` VALUES ('878', '320811', '清浦区', '320800');
INSERT INTO `jay_area` VALUES ('879', '320826', '涟水县', '320800');
INSERT INTO `jay_area` VALUES ('880', '320829', '洪泽县', '320800');
INSERT INTO `jay_area` VALUES ('881', '320830', '盱眙县', '320800');
INSERT INTO `jay_area` VALUES ('882', '320831', '金湖县', '320800');
INSERT INTO `jay_area` VALUES ('883', '320901', '市辖区', '320900');
INSERT INTO `jay_area` VALUES ('884', '320902', '亭湖区', '320900');
INSERT INTO `jay_area` VALUES ('885', '320903', '盐都区', '320900');
INSERT INTO `jay_area` VALUES ('886', '320921', '响水县', '320900');
INSERT INTO `jay_area` VALUES ('887', '320922', '滨海县', '320900');
INSERT INTO `jay_area` VALUES ('888', '320923', '阜宁县', '320900');
INSERT INTO `jay_area` VALUES ('889', '320924', '射阳县', '320900');
INSERT INTO `jay_area` VALUES ('890', '320925', '建湖县', '320900');
INSERT INTO `jay_area` VALUES ('891', '320981', '东台市', '320900');
INSERT INTO `jay_area` VALUES ('892', '320982', '大丰市', '320900');
INSERT INTO `jay_area` VALUES ('893', '321001', '市辖区', '321000');
INSERT INTO `jay_area` VALUES ('894', '321002', '广陵区', '321000');
INSERT INTO `jay_area` VALUES ('895', '321003', '邗江区', '321000');
INSERT INTO `jay_area` VALUES ('896', '321011', '郊　区', '321000');
INSERT INTO `jay_area` VALUES ('897', '321023', '宝应县', '321000');
INSERT INTO `jay_area` VALUES ('898', '321081', '仪征市', '321000');
INSERT INTO `jay_area` VALUES ('899', '321084', '高邮市', '321000');
INSERT INTO `jay_area` VALUES ('900', '321088', '江都市', '321000');
INSERT INTO `jay_area` VALUES ('901', '321101', '市辖区', '321100');
INSERT INTO `jay_area` VALUES ('902', '321102', '京口区', '321100');
INSERT INTO `jay_area` VALUES ('903', '321111', '润州区', '321100');
INSERT INTO `jay_area` VALUES ('904', '321112', '丹徒区', '321100');
INSERT INTO `jay_area` VALUES ('905', '321181', '丹阳市', '321100');
INSERT INTO `jay_area` VALUES ('906', '321182', '扬中市', '321100');
INSERT INTO `jay_area` VALUES ('907', '321183', '句容市', '321100');
INSERT INTO `jay_area` VALUES ('908', '321201', '市辖区', '321200');
INSERT INTO `jay_area` VALUES ('909', '321202', '海陵区', '321200');
INSERT INTO `jay_area` VALUES ('910', '321203', '高港区', '321200');
INSERT INTO `jay_area` VALUES ('911', '321281', '兴化市', '321200');
INSERT INTO `jay_area` VALUES ('912', '321282', '靖江市', '321200');
INSERT INTO `jay_area` VALUES ('913', '321283', '泰兴市', '321200');
INSERT INTO `jay_area` VALUES ('914', '321284', '姜堰市', '321200');
INSERT INTO `jay_area` VALUES ('915', '321301', '市辖区', '321300');
INSERT INTO `jay_area` VALUES ('916', '321302', '宿城区', '321300');
INSERT INTO `jay_area` VALUES ('917', '321311', '宿豫区', '321300');
INSERT INTO `jay_area` VALUES ('918', '321322', '沭阳县', '321300');
INSERT INTO `jay_area` VALUES ('919', '321323', '泗阳县', '321300');
INSERT INTO `jay_area` VALUES ('920', '321324', '泗洪县', '321300');
INSERT INTO `jay_area` VALUES ('921', '330101', '市辖区', '330100');
INSERT INTO `jay_area` VALUES ('922', '330102', '上城区', '330100');
INSERT INTO `jay_area` VALUES ('923', '330103', '下城区', '330100');
INSERT INTO `jay_area` VALUES ('924', '330104', '江干区', '330100');
INSERT INTO `jay_area` VALUES ('925', '330105', '拱墅区', '330100');
INSERT INTO `jay_area` VALUES ('926', '330106', '西湖区', '330100');
INSERT INTO `jay_area` VALUES ('927', '330108', '滨江区', '330100');
INSERT INTO `jay_area` VALUES ('928', '330109', '萧山区', '330100');
INSERT INTO `jay_area` VALUES ('929', '330110', '余杭区', '330100');
INSERT INTO `jay_area` VALUES ('930', '330122', '桐庐县', '330100');
INSERT INTO `jay_area` VALUES ('931', '330127', '淳安县', '330100');
INSERT INTO `jay_area` VALUES ('932', '330182', '建德市', '330100');
INSERT INTO `jay_area` VALUES ('933', '330183', '富阳市', '330100');
INSERT INTO `jay_area` VALUES ('934', '330185', '临安市', '330100');
INSERT INTO `jay_area` VALUES ('935', '330201', '市辖区', '330200');
INSERT INTO `jay_area` VALUES ('936', '330203', '海曙区', '330200');
INSERT INTO `jay_area` VALUES ('937', '330204', '江东区', '330200');
INSERT INTO `jay_area` VALUES ('938', '330205', '江北区', '330200');
INSERT INTO `jay_area` VALUES ('939', '330206', '北仑区', '330200');
INSERT INTO `jay_area` VALUES ('940', '330211', '镇海区', '330200');
INSERT INTO `jay_area` VALUES ('941', '330212', '鄞州区', '330200');
INSERT INTO `jay_area` VALUES ('942', '330225', '象山县', '330200');
INSERT INTO `jay_area` VALUES ('943', '330226', '宁海县', '330200');
INSERT INTO `jay_area` VALUES ('944', '330281', '余姚市', '330200');
INSERT INTO `jay_area` VALUES ('945', '330282', '慈溪市', '330200');
INSERT INTO `jay_area` VALUES ('946', '330283', '奉化市', '330200');
INSERT INTO `jay_area` VALUES ('947', '330301', '市辖区', '330300');
INSERT INTO `jay_area` VALUES ('948', '330302', '鹿城区', '330300');
INSERT INTO `jay_area` VALUES ('949', '330303', '龙湾区', '330300');
INSERT INTO `jay_area` VALUES ('950', '330304', '瓯海区', '330300');
INSERT INTO `jay_area` VALUES ('951', '330322', '洞头县', '330300');
INSERT INTO `jay_area` VALUES ('952', '330324', '永嘉县', '330300');
INSERT INTO `jay_area` VALUES ('953', '330326', '平阳县', '330300');
INSERT INTO `jay_area` VALUES ('954', '330327', '苍南县', '330300');
INSERT INTO `jay_area` VALUES ('955', '330328', '文成县', '330300');
INSERT INTO `jay_area` VALUES ('956', '330329', '泰顺县', '330300');
INSERT INTO `jay_area` VALUES ('957', '330381', '瑞安市', '330300');
INSERT INTO `jay_area` VALUES ('958', '330382', '乐清市', '330300');
INSERT INTO `jay_area` VALUES ('959', '330401', '市辖区', '330400');
INSERT INTO `jay_area` VALUES ('960', '330402', '秀城区', '330400');
INSERT INTO `jay_area` VALUES ('961', '330411', '秀洲区', '330400');
INSERT INTO `jay_area` VALUES ('962', '330421', '嘉善县', '330400');
INSERT INTO `jay_area` VALUES ('963', '330424', '海盐县', '330400');
INSERT INTO `jay_area` VALUES ('964', '330481', '海宁市', '330400');
INSERT INTO `jay_area` VALUES ('965', '330482', '平湖市', '330400');
INSERT INTO `jay_area` VALUES ('966', '330483', '桐乡市', '330400');
INSERT INTO `jay_area` VALUES ('967', '330501', '市辖区', '330500');
INSERT INTO `jay_area` VALUES ('968', '330502', '吴兴区', '330500');
INSERT INTO `jay_area` VALUES ('969', '330503', '南浔区', '330500');
INSERT INTO `jay_area` VALUES ('970', '330521', '德清县', '330500');
INSERT INTO `jay_area` VALUES ('971', '330522', '长兴县', '330500');
INSERT INTO `jay_area` VALUES ('972', '330523', '安吉县', '330500');
INSERT INTO `jay_area` VALUES ('973', '330601', '市辖区', '330600');
INSERT INTO `jay_area` VALUES ('974', '330602', '越城区', '330600');
INSERT INTO `jay_area` VALUES ('975', '330621', '绍兴县', '330600');
INSERT INTO `jay_area` VALUES ('976', '330624', '新昌县', '330600');
INSERT INTO `jay_area` VALUES ('977', '330681', '诸暨市', '330600');
INSERT INTO `jay_area` VALUES ('978', '330682', '上虞市', '330600');
INSERT INTO `jay_area` VALUES ('979', '330683', '嵊州市', '330600');
INSERT INTO `jay_area` VALUES ('980', '330701', '市辖区', '330700');
INSERT INTO `jay_area` VALUES ('981', '330702', '婺城区', '330700');
INSERT INTO `jay_area` VALUES ('982', '330703', '金东区', '330700');
INSERT INTO `jay_area` VALUES ('983', '330723', '武义县', '330700');
INSERT INTO `jay_area` VALUES ('984', '330726', '浦江县', '330700');
INSERT INTO `jay_area` VALUES ('985', '330727', '磐安县', '330700');
INSERT INTO `jay_area` VALUES ('986', '330781', '兰溪市', '330700');
INSERT INTO `jay_area` VALUES ('987', '330782', '义乌市', '330700');
INSERT INTO `jay_area` VALUES ('988', '330783', '东阳市', '330700');
INSERT INTO `jay_area` VALUES ('989', '330784', '永康市', '330700');
INSERT INTO `jay_area` VALUES ('990', '330801', '市辖区', '330800');
INSERT INTO `jay_area` VALUES ('991', '330802', '柯城区', '330800');
INSERT INTO `jay_area` VALUES ('992', '330803', '衢江区', '330800');
INSERT INTO `jay_area` VALUES ('993', '330822', '常山县', '330800');
INSERT INTO `jay_area` VALUES ('994', '330824', '开化县', '330800');
INSERT INTO `jay_area` VALUES ('995', '330825', '龙游县', '330800');
INSERT INTO `jay_area` VALUES ('996', '330881', '江山市', '330800');
INSERT INTO `jay_area` VALUES ('997', '330901', '市辖区', '330900');
INSERT INTO `jay_area` VALUES ('998', '330902', '定海区', '330900');
INSERT INTO `jay_area` VALUES ('999', '330903', '普陀区', '330900');
INSERT INTO `jay_area` VALUES ('1000', '330921', '岱山县', '330900');
INSERT INTO `jay_area` VALUES ('1001', '330922', '嵊泗县', '330900');
INSERT INTO `jay_area` VALUES ('1002', '331001', '市辖区', '331000');
INSERT INTO `jay_area` VALUES ('1003', '331002', '椒江区', '331000');
INSERT INTO `jay_area` VALUES ('1004', '331003', '黄岩区', '331000');
INSERT INTO `jay_area` VALUES ('1005', '331004', '路桥区', '331000');
INSERT INTO `jay_area` VALUES ('1006', '331021', '玉环县', '331000');
INSERT INTO `jay_area` VALUES ('1007', '331022', '三门县', '331000');
INSERT INTO `jay_area` VALUES ('1008', '331023', '天台县', '331000');
INSERT INTO `jay_area` VALUES ('1009', '331024', '仙居县', '331000');
INSERT INTO `jay_area` VALUES ('1010', '331081', '温岭市', '331000');
INSERT INTO `jay_area` VALUES ('1011', '331082', '临海市', '331000');
INSERT INTO `jay_area` VALUES ('1012', '331101', '市辖区', '331100');
INSERT INTO `jay_area` VALUES ('1013', '331102', '莲都区', '331100');
INSERT INTO `jay_area` VALUES ('1014', '331121', '青田县', '331100');
INSERT INTO `jay_area` VALUES ('1015', '331122', '缙云县', '331100');
INSERT INTO `jay_area` VALUES ('1016', '331123', '遂昌县', '331100');
INSERT INTO `jay_area` VALUES ('1017', '331124', '松阳县', '331100');
INSERT INTO `jay_area` VALUES ('1018', '331125', '云和县', '331100');
INSERT INTO `jay_area` VALUES ('1019', '331126', '庆元县', '331100');
INSERT INTO `jay_area` VALUES ('1020', '331127', '景宁畲族自治县', '331100');
INSERT INTO `jay_area` VALUES ('1021', '331181', '龙泉市', '331100');
INSERT INTO `jay_area` VALUES ('1022', '340101', '市辖区', '340100');
INSERT INTO `jay_area` VALUES ('1023', '340102', '瑶海区', '340100');
INSERT INTO `jay_area` VALUES ('1024', '340103', '庐阳区', '340100');
INSERT INTO `jay_area` VALUES ('1025', '340104', '蜀山区', '340100');
INSERT INTO `jay_area` VALUES ('1026', '340111', '包河区', '340100');
INSERT INTO `jay_area` VALUES ('1027', '340121', '长丰县', '340100');
INSERT INTO `jay_area` VALUES ('1028', '340122', '肥东县', '340100');
INSERT INTO `jay_area` VALUES ('1029', '340123', '肥西县', '340100');
INSERT INTO `jay_area` VALUES ('1030', '340201', '市辖区', '340200');
INSERT INTO `jay_area` VALUES ('1031', '340202', '镜湖区', '340200');
INSERT INTO `jay_area` VALUES ('1032', '340203', '马塘区', '340200');
INSERT INTO `jay_area` VALUES ('1033', '340204', '新芜区', '340200');
INSERT INTO `jay_area` VALUES ('1034', '340207', '鸠江区', '340200');
INSERT INTO `jay_area` VALUES ('1035', '340221', '芜湖县', '340200');
INSERT INTO `jay_area` VALUES ('1036', '340222', '繁昌县', '340200');
INSERT INTO `jay_area` VALUES ('1037', '340223', '南陵县', '340200');
INSERT INTO `jay_area` VALUES ('1038', '340301', '市辖区', '340300');
INSERT INTO `jay_area` VALUES ('1039', '340302', '龙子湖区', '340300');
INSERT INTO `jay_area` VALUES ('1040', '340303', '蚌山区', '340300');
INSERT INTO `jay_area` VALUES ('1041', '340304', '禹会区', '340300');
INSERT INTO `jay_area` VALUES ('1042', '340311', '淮上区', '340300');
INSERT INTO `jay_area` VALUES ('1043', '340321', '怀远县', '340300');
INSERT INTO `jay_area` VALUES ('1044', '340322', '五河县', '340300');
INSERT INTO `jay_area` VALUES ('1045', '340323', '固镇县', '340300');
INSERT INTO `jay_area` VALUES ('1046', '340401', '市辖区', '340400');
INSERT INTO `jay_area` VALUES ('1047', '340402', '大通区', '340400');
INSERT INTO `jay_area` VALUES ('1048', '340403', '田家庵区', '340400');
INSERT INTO `jay_area` VALUES ('1049', '340404', '谢家集区', '340400');
INSERT INTO `jay_area` VALUES ('1050', '340405', '八公山区', '340400');
INSERT INTO `jay_area` VALUES ('1051', '340406', '潘集区', '340400');
INSERT INTO `jay_area` VALUES ('1052', '340421', '凤台县', '340400');
INSERT INTO `jay_area` VALUES ('1053', '340501', '市辖区', '340500');
INSERT INTO `jay_area` VALUES ('1054', '340502', '金家庄区', '340500');
INSERT INTO `jay_area` VALUES ('1055', '340503', '花山区', '340500');
INSERT INTO `jay_area` VALUES ('1056', '340504', '雨山区', '340500');
INSERT INTO `jay_area` VALUES ('1057', '340521', '当涂县', '340500');
INSERT INTO `jay_area` VALUES ('1058', '340601', '市辖区', '340600');
INSERT INTO `jay_area` VALUES ('1059', '340602', '杜集区', '340600');
INSERT INTO `jay_area` VALUES ('1060', '340603', '相山区', '340600');
INSERT INTO `jay_area` VALUES ('1061', '340604', '烈山区', '340600');
INSERT INTO `jay_area` VALUES ('1062', '340621', '濉溪县', '340600');
INSERT INTO `jay_area` VALUES ('1063', '340701', '市辖区', '340700');
INSERT INTO `jay_area` VALUES ('1064', '340702', '铜官山区', '340700');
INSERT INTO `jay_area` VALUES ('1065', '340703', '狮子山区', '340700');
INSERT INTO `jay_area` VALUES ('1066', '340711', '郊　区', '340700');
INSERT INTO `jay_area` VALUES ('1067', '340721', '铜陵县', '340700');
INSERT INTO `jay_area` VALUES ('1068', '340801', '市辖区', '340800');
INSERT INTO `jay_area` VALUES ('1069', '340802', '迎江区', '340800');
INSERT INTO `jay_area` VALUES ('1070', '340803', '大观区', '340800');
INSERT INTO `jay_area` VALUES ('1071', '340811', '郊　区', '340800');
INSERT INTO `jay_area` VALUES ('1072', '340822', '怀宁县', '340800');
INSERT INTO `jay_area` VALUES ('1073', '340823', '枞阳县', '340800');
INSERT INTO `jay_area` VALUES ('1074', '340824', '潜山县', '340800');
INSERT INTO `jay_area` VALUES ('1075', '340825', '太湖县', '340800');
INSERT INTO `jay_area` VALUES ('1076', '340826', '宿松县', '340800');
INSERT INTO `jay_area` VALUES ('1077', '340827', '望江县', '340800');
INSERT INTO `jay_area` VALUES ('1078', '340828', '岳西县', '340800');
INSERT INTO `jay_area` VALUES ('1079', '340881', '桐城市', '340800');
INSERT INTO `jay_area` VALUES ('1080', '341001', '市辖区', '341000');
INSERT INTO `jay_area` VALUES ('1081', '341002', '屯溪区', '341000');
INSERT INTO `jay_area` VALUES ('1082', '341003', '黄山区', '341000');
INSERT INTO `jay_area` VALUES ('1083', '341004', '徽州区', '341000');
INSERT INTO `jay_area` VALUES ('1084', '341021', '歙　县', '341000');
INSERT INTO `jay_area` VALUES ('1085', '341022', '休宁县', '341000');
INSERT INTO `jay_area` VALUES ('1086', '341023', '黟　县', '341000');
INSERT INTO `jay_area` VALUES ('1087', '341024', '祁门县', '341000');
INSERT INTO `jay_area` VALUES ('1088', '341101', '市辖区', '341100');
INSERT INTO `jay_area` VALUES ('1089', '341102', '琅琊区', '341100');
INSERT INTO `jay_area` VALUES ('1090', '341103', '南谯区', '341100');
INSERT INTO `jay_area` VALUES ('1091', '341122', '来安县', '341100');
INSERT INTO `jay_area` VALUES ('1092', '341124', '全椒县', '341100');
INSERT INTO `jay_area` VALUES ('1093', '341125', '定远县', '341100');
INSERT INTO `jay_area` VALUES ('1094', '341126', '凤阳县', '341100');
INSERT INTO `jay_area` VALUES ('1095', '341181', '天长市', '341100');
INSERT INTO `jay_area` VALUES ('1096', '341182', '明光市', '341100');
INSERT INTO `jay_area` VALUES ('1097', '341201', '市辖区', '341200');
INSERT INTO `jay_area` VALUES ('1098', '341202', '颍州区', '341200');
INSERT INTO `jay_area` VALUES ('1099', '341203', '颍东区', '341200');
INSERT INTO `jay_area` VALUES ('1100', '341204', '颍泉区', '341200');
INSERT INTO `jay_area` VALUES ('1101', '341221', '临泉县', '341200');
INSERT INTO `jay_area` VALUES ('1102', '341222', '太和县', '341200');
INSERT INTO `jay_area` VALUES ('1103', '341225', '阜南县', '341200');
INSERT INTO `jay_area` VALUES ('1104', '341226', '颍上县', '341200');
INSERT INTO `jay_area` VALUES ('1105', '341282', '界首市', '341200');
INSERT INTO `jay_area` VALUES ('1106', '341301', '市辖区', '341300');
INSERT INTO `jay_area` VALUES ('1107', '341302', '墉桥区', '341300');
INSERT INTO `jay_area` VALUES ('1108', '341321', '砀山县', '341300');
INSERT INTO `jay_area` VALUES ('1109', '341322', '萧　县', '341300');
INSERT INTO `jay_area` VALUES ('1110', '341323', '灵璧县', '341300');
INSERT INTO `jay_area` VALUES ('1111', '341324', '泗　县', '341300');
INSERT INTO `jay_area` VALUES ('1112', '341401', '市辖区', '341400');
INSERT INTO `jay_area` VALUES ('1113', '341402', '居巢区', '341400');
INSERT INTO `jay_area` VALUES ('1114', '341421', '庐江县', '341400');
INSERT INTO `jay_area` VALUES ('1115', '341422', '无为县', '341400');
INSERT INTO `jay_area` VALUES ('1116', '341423', '含山县', '341400');
INSERT INTO `jay_area` VALUES ('1117', '341424', '和　县', '341400');
INSERT INTO `jay_area` VALUES ('1118', '341501', '市辖区', '341500');
INSERT INTO `jay_area` VALUES ('1119', '341502', '金安区', '341500');
INSERT INTO `jay_area` VALUES ('1120', '341503', '裕安区', '341500');
INSERT INTO `jay_area` VALUES ('1121', '341521', '寿　县', '341500');
INSERT INTO `jay_area` VALUES ('1122', '341522', '霍邱县', '341500');
INSERT INTO `jay_area` VALUES ('1123', '341523', '舒城县', '341500');
INSERT INTO `jay_area` VALUES ('1124', '341524', '金寨县', '341500');
INSERT INTO `jay_area` VALUES ('1125', '341525', '霍山县', '341500');
INSERT INTO `jay_area` VALUES ('1126', '341601', '市辖区', '341600');
INSERT INTO `jay_area` VALUES ('1127', '341602', '谯城区', '341600');
INSERT INTO `jay_area` VALUES ('1128', '341621', '涡阳县', '341600');
INSERT INTO `jay_area` VALUES ('1129', '341622', '蒙城县', '341600');
INSERT INTO `jay_area` VALUES ('1130', '341623', '利辛县', '341600');
INSERT INTO `jay_area` VALUES ('1131', '341701', '市辖区', '341700');
INSERT INTO `jay_area` VALUES ('1132', '341702', '贵池区', '341700');
INSERT INTO `jay_area` VALUES ('1133', '341721', '东至县', '341700');
INSERT INTO `jay_area` VALUES ('1134', '341722', '石台县', '341700');
INSERT INTO `jay_area` VALUES ('1135', '341723', '青阳县', '341700');
INSERT INTO `jay_area` VALUES ('1136', '341801', '市辖区', '341800');
INSERT INTO `jay_area` VALUES ('1137', '341802', '宣州区', '341800');
INSERT INTO `jay_area` VALUES ('1138', '341821', '郎溪县', '341800');
INSERT INTO `jay_area` VALUES ('1139', '341822', '广德县', '341800');
INSERT INTO `jay_area` VALUES ('1140', '341823', '泾　县', '341800');
INSERT INTO `jay_area` VALUES ('1141', '341824', '绩溪县', '341800');
INSERT INTO `jay_area` VALUES ('1142', '341825', '旌德县', '341800');
INSERT INTO `jay_area` VALUES ('1143', '341881', '宁国市', '341800');
INSERT INTO `jay_area` VALUES ('1144', '350101', '市辖区', '350100');
INSERT INTO `jay_area` VALUES ('1145', '350102', '鼓楼区', '350100');
INSERT INTO `jay_area` VALUES ('1146', '350103', '台江区', '350100');
INSERT INTO `jay_area` VALUES ('1147', '350104', '仓山区', '350100');
INSERT INTO `jay_area` VALUES ('1148', '350105', '马尾区', '350100');
INSERT INTO `jay_area` VALUES ('1149', '350111', '晋安区', '350100');
INSERT INTO `jay_area` VALUES ('1150', '350121', '闽侯县', '350100');
INSERT INTO `jay_area` VALUES ('1151', '350122', '连江县', '350100');
INSERT INTO `jay_area` VALUES ('1152', '350123', '罗源县', '350100');
INSERT INTO `jay_area` VALUES ('1153', '350124', '闽清县', '350100');
INSERT INTO `jay_area` VALUES ('1154', '350125', '永泰县', '350100');
INSERT INTO `jay_area` VALUES ('1155', '350128', '平潭县', '350100');
INSERT INTO `jay_area` VALUES ('1156', '350181', '福清市', '350100');
INSERT INTO `jay_area` VALUES ('1157', '350182', '长乐市', '350100');
INSERT INTO `jay_area` VALUES ('1158', '350201', '市辖区', '350200');
INSERT INTO `jay_area` VALUES ('1159', '350203', '思明区', '350200');
INSERT INTO `jay_area` VALUES ('1160', '350205', '海沧区', '350200');
INSERT INTO `jay_area` VALUES ('1161', '350206', '湖里区', '350200');
INSERT INTO `jay_area` VALUES ('1162', '350211', '集美区', '350200');
INSERT INTO `jay_area` VALUES ('1163', '350212', '同安区', '350200');
INSERT INTO `jay_area` VALUES ('1164', '350213', '翔安区', '350200');
INSERT INTO `jay_area` VALUES ('1165', '350301', '市辖区', '350300');
INSERT INTO `jay_area` VALUES ('1166', '350302', '城厢区', '350300');
INSERT INTO `jay_area` VALUES ('1167', '350303', '涵江区', '350300');
INSERT INTO `jay_area` VALUES ('1168', '350304', '荔城区', '350300');
INSERT INTO `jay_area` VALUES ('1169', '350305', '秀屿区', '350300');
INSERT INTO `jay_area` VALUES ('1170', '350322', '仙游县', '350300');
INSERT INTO `jay_area` VALUES ('1171', '350401', '市辖区', '350400');
INSERT INTO `jay_area` VALUES ('1172', '350402', '梅列区', '350400');
INSERT INTO `jay_area` VALUES ('1173', '350403', '三元区', '350400');
INSERT INTO `jay_area` VALUES ('1174', '350421', '明溪县', '350400');
INSERT INTO `jay_area` VALUES ('1175', '350423', '清流县', '350400');
INSERT INTO `jay_area` VALUES ('1176', '350424', '宁化县', '350400');
INSERT INTO `jay_area` VALUES ('1177', '350425', '大田县', '350400');
INSERT INTO `jay_area` VALUES ('1178', '350426', '尤溪县', '350400');
INSERT INTO `jay_area` VALUES ('1179', '350427', '沙　县', '350400');
INSERT INTO `jay_area` VALUES ('1180', '350428', '将乐县', '350400');
INSERT INTO `jay_area` VALUES ('1181', '350429', '泰宁县', '350400');
INSERT INTO `jay_area` VALUES ('1182', '350430', '建宁县', '350400');
INSERT INTO `jay_area` VALUES ('1183', '350481', '永安市', '350400');
INSERT INTO `jay_area` VALUES ('1184', '350501', '市辖区', '350500');
INSERT INTO `jay_area` VALUES ('1185', '350502', '鲤城区', '350500');
INSERT INTO `jay_area` VALUES ('1186', '350503', '丰泽区', '350500');
INSERT INTO `jay_area` VALUES ('1187', '350504', '洛江区', '350500');
INSERT INTO `jay_area` VALUES ('1188', '350505', '泉港区', '350500');
INSERT INTO `jay_area` VALUES ('1189', '350521', '惠安县', '350500');
INSERT INTO `jay_area` VALUES ('1190', '350524', '安溪县', '350500');
INSERT INTO `jay_area` VALUES ('1191', '350525', '永春县', '350500');
INSERT INTO `jay_area` VALUES ('1192', '350526', '德化县', '350500');
INSERT INTO `jay_area` VALUES ('1193', '350527', '金门县', '350500');
INSERT INTO `jay_area` VALUES ('1194', '350581', '石狮市', '350500');
INSERT INTO `jay_area` VALUES ('1195', '350582', '晋江市', '350500');
INSERT INTO `jay_area` VALUES ('1196', '350583', '南安市', '350500');
INSERT INTO `jay_area` VALUES ('1197', '350601', '市辖区', '350600');
INSERT INTO `jay_area` VALUES ('1198', '350602', '芗城区', '350600');
INSERT INTO `jay_area` VALUES ('1199', '350603', '龙文区', '350600');
INSERT INTO `jay_area` VALUES ('1200', '350622', '云霄县', '350600');
INSERT INTO `jay_area` VALUES ('1201', '350623', '漳浦县', '350600');
INSERT INTO `jay_area` VALUES ('1202', '350624', '诏安县', '350600');
INSERT INTO `jay_area` VALUES ('1203', '350625', '长泰县', '350600');
INSERT INTO `jay_area` VALUES ('1204', '350626', '东山县', '350600');
INSERT INTO `jay_area` VALUES ('1205', '350627', '南靖县', '350600');
INSERT INTO `jay_area` VALUES ('1206', '350628', '平和县', '350600');
INSERT INTO `jay_area` VALUES ('1207', '350629', '华安县', '350600');
INSERT INTO `jay_area` VALUES ('1208', '350681', '龙海市', '350600');
INSERT INTO `jay_area` VALUES ('1209', '350701', '市辖区', '350700');
INSERT INTO `jay_area` VALUES ('1210', '350702', '延平区', '350700');
INSERT INTO `jay_area` VALUES ('1211', '350721', '顺昌县', '350700');
INSERT INTO `jay_area` VALUES ('1212', '350722', '浦城县', '350700');
INSERT INTO `jay_area` VALUES ('1213', '350723', '光泽县', '350700');
INSERT INTO `jay_area` VALUES ('1214', '350724', '松溪县', '350700');
INSERT INTO `jay_area` VALUES ('1215', '350725', '政和县', '350700');
INSERT INTO `jay_area` VALUES ('1216', '350781', '邵武市', '350700');
INSERT INTO `jay_area` VALUES ('1217', '350782', '武夷山市', '350700');
INSERT INTO `jay_area` VALUES ('1218', '350783', '建瓯市', '350700');
INSERT INTO `jay_area` VALUES ('1219', '350784', '建阳市', '350700');
INSERT INTO `jay_area` VALUES ('1220', '350801', '市辖区', '350800');
INSERT INTO `jay_area` VALUES ('1221', '350802', '新罗区', '350800');
INSERT INTO `jay_area` VALUES ('1222', '350821', '长汀县', '350800');
INSERT INTO `jay_area` VALUES ('1223', '350822', '永定县', '350800');
INSERT INTO `jay_area` VALUES ('1224', '350823', '上杭县', '350800');
INSERT INTO `jay_area` VALUES ('1225', '350824', '武平县', '350800');
INSERT INTO `jay_area` VALUES ('1226', '350825', '连城县', '350800');
INSERT INTO `jay_area` VALUES ('1227', '350881', '漳平市', '350800');
INSERT INTO `jay_area` VALUES ('1228', '350901', '市辖区', '350900');
INSERT INTO `jay_area` VALUES ('1229', '350902', '蕉城区', '350900');
INSERT INTO `jay_area` VALUES ('1230', '350921', '霞浦县', '350900');
INSERT INTO `jay_area` VALUES ('1231', '350922', '古田县', '350900');
INSERT INTO `jay_area` VALUES ('1232', '350923', '屏南县', '350900');
INSERT INTO `jay_area` VALUES ('1233', '350924', '寿宁县', '350900');
INSERT INTO `jay_area` VALUES ('1234', '350925', '周宁县', '350900');
INSERT INTO `jay_area` VALUES ('1235', '350926', '柘荣县', '350900');
INSERT INTO `jay_area` VALUES ('1236', '350981', '福安市', '350900');
INSERT INTO `jay_area` VALUES ('1237', '350982', '福鼎市', '350900');
INSERT INTO `jay_area` VALUES ('1238', '360101', '市辖区', '360100');
INSERT INTO `jay_area` VALUES ('1239', '360102', '东湖区', '360100');
INSERT INTO `jay_area` VALUES ('1240', '360103', '西湖区', '360100');
INSERT INTO `jay_area` VALUES ('1241', '360104', '青云谱区', '360100');
INSERT INTO `jay_area` VALUES ('1242', '360105', '湾里区', '360100');
INSERT INTO `jay_area` VALUES ('1243', '360111', '青山湖区', '360100');
INSERT INTO `jay_area` VALUES ('1244', '360121', '南昌县', '360100');
INSERT INTO `jay_area` VALUES ('1245', '360122', '新建县', '360100');
INSERT INTO `jay_area` VALUES ('1246', '360123', '安义县', '360100');
INSERT INTO `jay_area` VALUES ('1247', '360124', '进贤县', '360100');
INSERT INTO `jay_area` VALUES ('1248', '360201', '市辖区', '360200');
INSERT INTO `jay_area` VALUES ('1249', '360202', '昌江区', '360200');
INSERT INTO `jay_area` VALUES ('1250', '360203', '珠山区', '360200');
INSERT INTO `jay_area` VALUES ('1251', '360222', '浮梁县', '360200');
INSERT INTO `jay_area` VALUES ('1252', '360281', '乐平市', '360200');
INSERT INTO `jay_area` VALUES ('1253', '360301', '市辖区', '360300');
INSERT INTO `jay_area` VALUES ('1254', '360302', '安源区', '360300');
INSERT INTO `jay_area` VALUES ('1255', '360313', '湘东区', '360300');
INSERT INTO `jay_area` VALUES ('1256', '360321', '莲花县', '360300');
INSERT INTO `jay_area` VALUES ('1257', '360322', '上栗县', '360300');
INSERT INTO `jay_area` VALUES ('1258', '360323', '芦溪县', '360300');
INSERT INTO `jay_area` VALUES ('1259', '360401', '市辖区', '360400');
INSERT INTO `jay_area` VALUES ('1260', '360402', '庐山区', '360400');
INSERT INTO `jay_area` VALUES ('1261', '360403', '浔阳区', '360400');
INSERT INTO `jay_area` VALUES ('1262', '360421', '九江县', '360400');
INSERT INTO `jay_area` VALUES ('1263', '360423', '武宁县', '360400');
INSERT INTO `jay_area` VALUES ('1264', '360424', '修水县', '360400');
INSERT INTO `jay_area` VALUES ('1265', '360425', '永修县', '360400');
INSERT INTO `jay_area` VALUES ('1266', '360426', '德安县', '360400');
INSERT INTO `jay_area` VALUES ('1267', '360427', '星子县', '360400');
INSERT INTO `jay_area` VALUES ('1268', '360428', '都昌县', '360400');
INSERT INTO `jay_area` VALUES ('1269', '360429', '湖口县', '360400');
INSERT INTO `jay_area` VALUES ('1270', '360430', '彭泽县', '360400');
INSERT INTO `jay_area` VALUES ('1271', '360481', '瑞昌市', '360400');
INSERT INTO `jay_area` VALUES ('1272', '360501', '市辖区', '360500');
INSERT INTO `jay_area` VALUES ('1273', '360502', '渝水区', '360500');
INSERT INTO `jay_area` VALUES ('1274', '360521', '分宜县', '360500');
INSERT INTO `jay_area` VALUES ('1275', '360601', '市辖区', '360600');
INSERT INTO `jay_area` VALUES ('1276', '360602', '月湖区', '360600');
INSERT INTO `jay_area` VALUES ('1277', '360622', '余江县', '360600');
INSERT INTO `jay_area` VALUES ('1278', '360681', '贵溪市', '360600');
INSERT INTO `jay_area` VALUES ('1279', '360701', '市辖区', '360700');
INSERT INTO `jay_area` VALUES ('1280', '360702', '章贡区', '360700');
INSERT INTO `jay_area` VALUES ('1281', '360721', '赣　县', '360700');
INSERT INTO `jay_area` VALUES ('1282', '360722', '信丰县', '360700');
INSERT INTO `jay_area` VALUES ('1283', '360723', '大余县', '360700');
INSERT INTO `jay_area` VALUES ('1284', '360724', '上犹县', '360700');
INSERT INTO `jay_area` VALUES ('1285', '360725', '崇义县', '360700');
INSERT INTO `jay_area` VALUES ('1286', '360726', '安远县', '360700');
INSERT INTO `jay_area` VALUES ('1287', '360727', '龙南县', '360700');
INSERT INTO `jay_area` VALUES ('1288', '360728', '定南县', '360700');
INSERT INTO `jay_area` VALUES ('1289', '360729', '全南县', '360700');
INSERT INTO `jay_area` VALUES ('1290', '360730', '宁都县', '360700');
INSERT INTO `jay_area` VALUES ('1291', '360731', '于都县', '360700');
INSERT INTO `jay_area` VALUES ('1292', '360732', '兴国县', '360700');
INSERT INTO `jay_area` VALUES ('1293', '360733', '会昌县', '360700');
INSERT INTO `jay_area` VALUES ('1294', '360734', '寻乌县', '360700');
INSERT INTO `jay_area` VALUES ('1295', '360735', '石城县', '360700');
INSERT INTO `jay_area` VALUES ('1296', '360781', '瑞金市', '360700');
INSERT INTO `jay_area` VALUES ('1297', '360782', '南康市', '360700');
INSERT INTO `jay_area` VALUES ('1298', '360801', '市辖区', '360800');
INSERT INTO `jay_area` VALUES ('1299', '360802', '吉州区', '360800');
INSERT INTO `jay_area` VALUES ('1300', '360803', '青原区', '360800');
INSERT INTO `jay_area` VALUES ('1301', '360821', '吉安县', '360800');
INSERT INTO `jay_area` VALUES ('1302', '360822', '吉水县', '360800');
INSERT INTO `jay_area` VALUES ('1303', '360823', '峡江县', '360800');
INSERT INTO `jay_area` VALUES ('1304', '360824', '新干县', '360800');
INSERT INTO `jay_area` VALUES ('1305', '360825', '永丰县', '360800');
INSERT INTO `jay_area` VALUES ('1306', '360826', '泰和县', '360800');
INSERT INTO `jay_area` VALUES ('1307', '360827', '遂川县', '360800');
INSERT INTO `jay_area` VALUES ('1308', '360828', '万安县', '360800');
INSERT INTO `jay_area` VALUES ('1309', '360829', '安福县', '360800');
INSERT INTO `jay_area` VALUES ('1310', '360830', '永新县', '360800');
INSERT INTO `jay_area` VALUES ('1311', '360881', '井冈山市', '360800');
INSERT INTO `jay_area` VALUES ('1312', '360901', '市辖区', '360900');
INSERT INTO `jay_area` VALUES ('1313', '360902', '袁州区', '360900');
INSERT INTO `jay_area` VALUES ('1314', '360921', '奉新县', '360900');
INSERT INTO `jay_area` VALUES ('1315', '360922', '万载县', '360900');
INSERT INTO `jay_area` VALUES ('1316', '360923', '上高县', '360900');
INSERT INTO `jay_area` VALUES ('1317', '360924', '宜丰县', '360900');
INSERT INTO `jay_area` VALUES ('1318', '360925', '靖安县', '360900');
INSERT INTO `jay_area` VALUES ('1319', '360926', '铜鼓县', '360900');
INSERT INTO `jay_area` VALUES ('1320', '360981', '丰城市', '360900');
INSERT INTO `jay_area` VALUES ('1321', '360982', '樟树市', '360900');
INSERT INTO `jay_area` VALUES ('1322', '360983', '高安市', '360900');
INSERT INTO `jay_area` VALUES ('1323', '361001', '市辖区', '361000');
INSERT INTO `jay_area` VALUES ('1324', '361002', '临川区', '361000');
INSERT INTO `jay_area` VALUES ('1325', '361021', '南城县', '361000');
INSERT INTO `jay_area` VALUES ('1326', '361022', '黎川县', '361000');
INSERT INTO `jay_area` VALUES ('1327', '361023', '南丰县', '361000');
INSERT INTO `jay_area` VALUES ('1328', '361024', '崇仁县', '361000');
INSERT INTO `jay_area` VALUES ('1329', '361025', '乐安县', '361000');
INSERT INTO `jay_area` VALUES ('1330', '361026', '宜黄县', '361000');
INSERT INTO `jay_area` VALUES ('1331', '361027', '金溪县', '361000');
INSERT INTO `jay_area` VALUES ('1332', '361028', '资溪县', '361000');
INSERT INTO `jay_area` VALUES ('1333', '361029', '东乡县', '361000');
INSERT INTO `jay_area` VALUES ('1334', '361030', '广昌县', '361000');
INSERT INTO `jay_area` VALUES ('1335', '361101', '市辖区', '361100');
INSERT INTO `jay_area` VALUES ('1336', '361102', '信州区', '361100');
INSERT INTO `jay_area` VALUES ('1337', '361121', '上饶县', '361100');
INSERT INTO `jay_area` VALUES ('1338', '361122', '广丰县', '361100');
INSERT INTO `jay_area` VALUES ('1339', '361123', '玉山县', '361100');
INSERT INTO `jay_area` VALUES ('1340', '361124', '铅山县', '361100');
INSERT INTO `jay_area` VALUES ('1341', '361125', '横峰县', '361100');
INSERT INTO `jay_area` VALUES ('1342', '361126', '弋阳县', '361100');
INSERT INTO `jay_area` VALUES ('1343', '361127', '余干县', '361100');
INSERT INTO `jay_area` VALUES ('1344', '361128', '鄱阳县', '361100');
INSERT INTO `jay_area` VALUES ('1345', '361129', '万年县', '361100');
INSERT INTO `jay_area` VALUES ('1346', '361130', '婺源县', '361100');
INSERT INTO `jay_area` VALUES ('1347', '361181', '德兴市', '361100');
INSERT INTO `jay_area` VALUES ('1348', '370101', '市辖区', '370100');
INSERT INTO `jay_area` VALUES ('1349', '370102', '历下区', '370100');
INSERT INTO `jay_area` VALUES ('1350', '370103', '市中区', '370100');
INSERT INTO `jay_area` VALUES ('1351', '370104', '槐荫区', '370100');
INSERT INTO `jay_area` VALUES ('1352', '370105', '天桥区', '370100');
INSERT INTO `jay_area` VALUES ('1353', '370112', '历城区', '370100');
INSERT INTO `jay_area` VALUES ('1354', '370113', '长清区', '370100');
INSERT INTO `jay_area` VALUES ('1355', '370124', '平阴县', '370100');
INSERT INTO `jay_area` VALUES ('1356', '370125', '济阳县', '370100');
INSERT INTO `jay_area` VALUES ('1357', '370126', '商河县', '370100');
INSERT INTO `jay_area` VALUES ('1358', '370181', '章丘市', '370100');
INSERT INTO `jay_area` VALUES ('1359', '370201', '市辖区', '370200');
INSERT INTO `jay_area` VALUES ('1360', '370202', '市南区', '370200');
INSERT INTO `jay_area` VALUES ('1361', '370203', '市北区', '370200');
INSERT INTO `jay_area` VALUES ('1362', '370205', '四方区', '370200');
INSERT INTO `jay_area` VALUES ('1363', '370211', '黄岛区', '370200');
INSERT INTO `jay_area` VALUES ('1364', '370212', '崂山区', '370200');
INSERT INTO `jay_area` VALUES ('1365', '370213', '李沧区', '370200');
INSERT INTO `jay_area` VALUES ('1366', '370214', '城阳区', '370200');
INSERT INTO `jay_area` VALUES ('1367', '370281', '胶州市', '370200');
INSERT INTO `jay_area` VALUES ('1368', '370282', '即墨市', '370200');
INSERT INTO `jay_area` VALUES ('1369', '370283', '平度市', '370200');
INSERT INTO `jay_area` VALUES ('1370', '370284', '胶南市', '370200');
INSERT INTO `jay_area` VALUES ('1371', '370285', '莱西市', '370200');
INSERT INTO `jay_area` VALUES ('1372', '370301', '市辖区', '370300');
INSERT INTO `jay_area` VALUES ('1373', '370302', '淄川区', '370300');
INSERT INTO `jay_area` VALUES ('1374', '370303', '张店区', '370300');
INSERT INTO `jay_area` VALUES ('1375', '370304', '博山区', '370300');
INSERT INTO `jay_area` VALUES ('1376', '370305', '临淄区', '370300');
INSERT INTO `jay_area` VALUES ('1377', '370306', '周村区', '370300');
INSERT INTO `jay_area` VALUES ('1378', '370321', '桓台县', '370300');
INSERT INTO `jay_area` VALUES ('1379', '370322', '高青县', '370300');
INSERT INTO `jay_area` VALUES ('1380', '370323', '沂源县', '370300');
INSERT INTO `jay_area` VALUES ('1381', '370401', '市辖区', '370400');
INSERT INTO `jay_area` VALUES ('1382', '370402', '市中区', '370400');
INSERT INTO `jay_area` VALUES ('1383', '370403', '薛城区', '370400');
INSERT INTO `jay_area` VALUES ('1384', '370404', '峄城区', '370400');
INSERT INTO `jay_area` VALUES ('1385', '370405', '台儿庄区', '370400');
INSERT INTO `jay_area` VALUES ('1386', '370406', '山亭区', '370400');
INSERT INTO `jay_area` VALUES ('1387', '370481', '滕州市', '370400');
INSERT INTO `jay_area` VALUES ('1388', '370501', '市辖区', '370500');
INSERT INTO `jay_area` VALUES ('1389', '370502', '东营区', '370500');
INSERT INTO `jay_area` VALUES ('1390', '370503', '河口区', '370500');
INSERT INTO `jay_area` VALUES ('1391', '370521', '垦利县', '370500');
INSERT INTO `jay_area` VALUES ('1392', '370522', '利津县', '370500');
INSERT INTO `jay_area` VALUES ('1393', '370523', '广饶县', '370500');
INSERT INTO `jay_area` VALUES ('1394', '370601', '市辖区', '370600');
INSERT INTO `jay_area` VALUES ('1395', '370602', '芝罘区', '370600');
INSERT INTO `jay_area` VALUES ('1396', '370611', '福山区', '370600');
INSERT INTO `jay_area` VALUES ('1397', '370612', '牟平区', '370600');
INSERT INTO `jay_area` VALUES ('1398', '370613', '莱山区', '370600');
INSERT INTO `jay_area` VALUES ('1399', '370634', '长岛县', '370600');
INSERT INTO `jay_area` VALUES ('1400', '370681', '龙口市', '370600');
INSERT INTO `jay_area` VALUES ('1401', '370682', '莱阳市', '370600');
INSERT INTO `jay_area` VALUES ('1402', '370683', '莱州市', '370600');
INSERT INTO `jay_area` VALUES ('1403', '370684', '蓬莱市', '370600');
INSERT INTO `jay_area` VALUES ('1404', '370685', '招远市', '370600');
INSERT INTO `jay_area` VALUES ('1405', '370686', '栖霞市', '370600');
INSERT INTO `jay_area` VALUES ('1406', '370687', '海阳市', '370600');
INSERT INTO `jay_area` VALUES ('1407', '370701', '市辖区', '370700');
INSERT INTO `jay_area` VALUES ('1408', '370702', '潍城区', '370700');
INSERT INTO `jay_area` VALUES ('1409', '370703', '寒亭区', '370700');
INSERT INTO `jay_area` VALUES ('1410', '370704', '坊子区', '370700');
INSERT INTO `jay_area` VALUES ('1411', '370705', '奎文区', '370700');
INSERT INTO `jay_area` VALUES ('1412', '370724', '临朐县', '370700');
INSERT INTO `jay_area` VALUES ('1413', '370725', '昌乐县', '370700');
INSERT INTO `jay_area` VALUES ('1414', '370781', '青州市', '370700');
INSERT INTO `jay_area` VALUES ('1415', '370782', '诸城市', '370700');
INSERT INTO `jay_area` VALUES ('1416', '370783', '寿光市', '370700');
INSERT INTO `jay_area` VALUES ('1417', '370784', '安丘市', '370700');
INSERT INTO `jay_area` VALUES ('1418', '370785', '高密市', '370700');
INSERT INTO `jay_area` VALUES ('1419', '370786', '昌邑市', '370700');
INSERT INTO `jay_area` VALUES ('1420', '370801', '市辖区', '370800');
INSERT INTO `jay_area` VALUES ('1421', '370802', '市中区', '370800');
INSERT INTO `jay_area` VALUES ('1422', '370811', '任城区', '370800');
INSERT INTO `jay_area` VALUES ('1423', '370826', '微山县', '370800');
INSERT INTO `jay_area` VALUES ('1424', '370827', '鱼台县', '370800');
INSERT INTO `jay_area` VALUES ('1425', '370828', '金乡县', '370800');
INSERT INTO `jay_area` VALUES ('1426', '370829', '嘉祥县', '370800');
INSERT INTO `jay_area` VALUES ('1427', '370830', '汶上县', '370800');
INSERT INTO `jay_area` VALUES ('1428', '370831', '泗水县', '370800');
INSERT INTO `jay_area` VALUES ('1429', '370832', '梁山县', '370800');
INSERT INTO `jay_area` VALUES ('1430', '370881', '曲阜市', '370800');
INSERT INTO `jay_area` VALUES ('1431', '370882', '兖州市', '370800');
INSERT INTO `jay_area` VALUES ('1432', '370883', '邹城市', '370800');
INSERT INTO `jay_area` VALUES ('1433', '370901', '市辖区', '370900');
INSERT INTO `jay_area` VALUES ('1434', '370902', '泰山区', '370900');
INSERT INTO `jay_area` VALUES ('1435', '370903', '岱岳区', '370900');
INSERT INTO `jay_area` VALUES ('1436', '370921', '宁阳县', '370900');
INSERT INTO `jay_area` VALUES ('1437', '370923', '东平县', '370900');
INSERT INTO `jay_area` VALUES ('1438', '370982', '新泰市', '370900');
INSERT INTO `jay_area` VALUES ('1439', '370983', '肥城市', '370900');
INSERT INTO `jay_area` VALUES ('1440', '371001', '市辖区', '371000');
INSERT INTO `jay_area` VALUES ('1441', '371002', '环翠区', '371000');
INSERT INTO `jay_area` VALUES ('1442', '371081', '文登市', '371000');
INSERT INTO `jay_area` VALUES ('1443', '371082', '荣成市', '371000');
INSERT INTO `jay_area` VALUES ('1444', '371083', '乳山市', '371000');
INSERT INTO `jay_area` VALUES ('1445', '371101', '市辖区', '371100');
INSERT INTO `jay_area` VALUES ('1446', '371102', '东港区', '371100');
INSERT INTO `jay_area` VALUES ('1447', '371103', '岚山区', '371100');
INSERT INTO `jay_area` VALUES ('1448', '371121', '五莲县', '371100');
INSERT INTO `jay_area` VALUES ('1449', '371122', '莒　县', '371100');
INSERT INTO `jay_area` VALUES ('1450', '371201', '市辖区', '371200');
INSERT INTO `jay_area` VALUES ('1451', '371202', '莱城区', '371200');
INSERT INTO `jay_area` VALUES ('1452', '371203', '钢城区', '371200');
INSERT INTO `jay_area` VALUES ('1453', '371301', '市辖区', '371300');
INSERT INTO `jay_area` VALUES ('1454', '371302', '兰山区', '371300');
INSERT INTO `jay_area` VALUES ('1455', '371311', '罗庄区', '371300');
INSERT INTO `jay_area` VALUES ('1456', '371312', '河东区', '371300');
INSERT INTO `jay_area` VALUES ('1457', '371321', '沂南县', '371300');
INSERT INTO `jay_area` VALUES ('1458', '371322', '郯城县', '371300');
INSERT INTO `jay_area` VALUES ('1459', '371323', '沂水县', '371300');
INSERT INTO `jay_area` VALUES ('1460', '371324', '苍山县', '371300');
INSERT INTO `jay_area` VALUES ('1461', '371325', '费　县', '371300');
INSERT INTO `jay_area` VALUES ('1462', '371326', '平邑县', '371300');
INSERT INTO `jay_area` VALUES ('1463', '371327', '莒南县', '371300');
INSERT INTO `jay_area` VALUES ('1464', '371328', '蒙阴县', '371300');
INSERT INTO `jay_area` VALUES ('1465', '371329', '临沭县', '371300');
INSERT INTO `jay_area` VALUES ('1466', '371401', '市辖区', '371400');
INSERT INTO `jay_area` VALUES ('1467', '371402', '德城区', '371400');
INSERT INTO `jay_area` VALUES ('1468', '371421', '陵　县', '371400');
INSERT INTO `jay_area` VALUES ('1469', '371422', '宁津县', '371400');
INSERT INTO `jay_area` VALUES ('1470', '371423', '庆云县', '371400');
INSERT INTO `jay_area` VALUES ('1471', '371424', '临邑县', '371400');
INSERT INTO `jay_area` VALUES ('1472', '371425', '齐河县', '371400');
INSERT INTO `jay_area` VALUES ('1473', '371426', '平原县', '371400');
INSERT INTO `jay_area` VALUES ('1474', '371427', '夏津县', '371400');
INSERT INTO `jay_area` VALUES ('1475', '371428', '武城县', '371400');
INSERT INTO `jay_area` VALUES ('1476', '371481', '乐陵市', '371400');
INSERT INTO `jay_area` VALUES ('1477', '371482', '禹城市', '371400');
INSERT INTO `jay_area` VALUES ('1478', '371501', '市辖区', '371500');
INSERT INTO `jay_area` VALUES ('1479', '371502', '东昌府区', '371500');
INSERT INTO `jay_area` VALUES ('1480', '371521', '阳谷县', '371500');
INSERT INTO `jay_area` VALUES ('1481', '371522', '莘　县', '371500');
INSERT INTO `jay_area` VALUES ('1482', '371523', '茌平县', '371500');
INSERT INTO `jay_area` VALUES ('1483', '371524', '东阿县', '371500');
INSERT INTO `jay_area` VALUES ('1484', '371525', '冠　县', '371500');
INSERT INTO `jay_area` VALUES ('1485', '371526', '高唐县', '371500');
INSERT INTO `jay_area` VALUES ('1486', '371581', '临清市', '371500');
INSERT INTO `jay_area` VALUES ('1487', '371601', '市辖区', '371600');
INSERT INTO `jay_area` VALUES ('1488', '371602', '滨城区', '371600');
INSERT INTO `jay_area` VALUES ('1489', '371621', '惠民县', '371600');
INSERT INTO `jay_area` VALUES ('1490', '371622', '阳信县', '371600');
INSERT INTO `jay_area` VALUES ('1491', '371623', '无棣县', '371600');
INSERT INTO `jay_area` VALUES ('1492', '371624', '沾化县', '371600');
INSERT INTO `jay_area` VALUES ('1493', '371625', '博兴县', '371600');
INSERT INTO `jay_area` VALUES ('1494', '371626', '邹平县', '371600');
INSERT INTO `jay_area` VALUES ('1495', '371701', '市辖区', '371700');
INSERT INTO `jay_area` VALUES ('1496', '371702', '牡丹区', '371700');
INSERT INTO `jay_area` VALUES ('1497', '371721', '曹　县', '371700');
INSERT INTO `jay_area` VALUES ('1498', '371722', '单　县', '371700');
INSERT INTO `jay_area` VALUES ('1499', '371723', '成武县', '371700');
INSERT INTO `jay_area` VALUES ('1500', '371724', '巨野县', '371700');
INSERT INTO `jay_area` VALUES ('1501', '371725', '郓城县', '371700');
INSERT INTO `jay_area` VALUES ('1502', '371726', '鄄城县', '371700');
INSERT INTO `jay_area` VALUES ('1503', '371727', '定陶县', '371700');
INSERT INTO `jay_area` VALUES ('1504', '371728', '东明县', '371700');
INSERT INTO `jay_area` VALUES ('1505', '410101', '市辖区', '410100');
INSERT INTO `jay_area` VALUES ('1506', '410102', '中原区', '410100');
INSERT INTO `jay_area` VALUES ('1507', '410103', '二七区', '410100');
INSERT INTO `jay_area` VALUES ('1508', '410104', '管城回族区', '410100');
INSERT INTO `jay_area` VALUES ('1509', '410105', '金水区', '410100');
INSERT INTO `jay_area` VALUES ('1510', '410106', '上街区', '410100');
INSERT INTO `jay_area` VALUES ('1511', '410108', '邙山区', '410100');
INSERT INTO `jay_area` VALUES ('1512', '410122', '中牟县', '410100');
INSERT INTO `jay_area` VALUES ('1513', '410181', '巩义市', '410100');
INSERT INTO `jay_area` VALUES ('1514', '410182', '荥阳市', '410100');
INSERT INTO `jay_area` VALUES ('1515', '410183', '新密市', '410100');
INSERT INTO `jay_area` VALUES ('1516', '410184', '新郑市', '410100');
INSERT INTO `jay_area` VALUES ('1517', '410185', '登封市', '410100');
INSERT INTO `jay_area` VALUES ('1518', '410201', '市辖区', '410200');
INSERT INTO `jay_area` VALUES ('1519', '410202', '龙亭区', '410200');
INSERT INTO `jay_area` VALUES ('1520', '410203', '顺河回族区', '410200');
INSERT INTO `jay_area` VALUES ('1521', '410204', '鼓楼区', '410200');
INSERT INTO `jay_area` VALUES ('1522', '410205', '南关区', '410200');
INSERT INTO `jay_area` VALUES ('1523', '410211', '郊　区', '410200');
INSERT INTO `jay_area` VALUES ('1524', '410221', '杞　县', '410200');
INSERT INTO `jay_area` VALUES ('1525', '410222', '通许县', '410200');
INSERT INTO `jay_area` VALUES ('1526', '410223', '尉氏县', '410200');
INSERT INTO `jay_area` VALUES ('1527', '410224', '开封县', '410200');
INSERT INTO `jay_area` VALUES ('1528', '410225', '兰考县', '410200');
INSERT INTO `jay_area` VALUES ('1529', '410301', '市辖区', '410300');
INSERT INTO `jay_area` VALUES ('1530', '410302', '老城区', '410300');
INSERT INTO `jay_area` VALUES ('1531', '410303', '西工区', '410300');
INSERT INTO `jay_area` VALUES ('1532', '410304', '廛河回族区', '410300');
INSERT INTO `jay_area` VALUES ('1533', '410305', '涧西区', '410300');
INSERT INTO `jay_area` VALUES ('1534', '410306', '吉利区', '410300');
INSERT INTO `jay_area` VALUES ('1535', '410307', '洛龙区', '410300');
INSERT INTO `jay_area` VALUES ('1536', '410322', '孟津县', '410300');
INSERT INTO `jay_area` VALUES ('1537', '410323', '新安县', '410300');
INSERT INTO `jay_area` VALUES ('1538', '410324', '栾川县', '410300');
INSERT INTO `jay_area` VALUES ('1539', '410325', '嵩　县', '410300');
INSERT INTO `jay_area` VALUES ('1540', '410326', '汝阳县', '410300');
INSERT INTO `jay_area` VALUES ('1541', '410327', '宜阳县', '410300');
INSERT INTO `jay_area` VALUES ('1542', '410328', '洛宁县', '410300');
INSERT INTO `jay_area` VALUES ('1543', '410329', '伊川县', '410300');
INSERT INTO `jay_area` VALUES ('1544', '410381', '偃师市', '410300');
INSERT INTO `jay_area` VALUES ('1545', '410401', '市辖区', '410400');
INSERT INTO `jay_area` VALUES ('1546', '410402', '新华区', '410400');
INSERT INTO `jay_area` VALUES ('1547', '410403', '卫东区', '410400');
INSERT INTO `jay_area` VALUES ('1548', '410404', '石龙区', '410400');
INSERT INTO `jay_area` VALUES ('1549', '410411', '湛河区', '410400');
INSERT INTO `jay_area` VALUES ('1550', '410421', '宝丰县', '410400');
INSERT INTO `jay_area` VALUES ('1551', '410422', '叶　县', '410400');
INSERT INTO `jay_area` VALUES ('1552', '410423', '鲁山县', '410400');
INSERT INTO `jay_area` VALUES ('1553', '410425', '郏　县', '410400');
INSERT INTO `jay_area` VALUES ('1554', '410481', '舞钢市', '410400');
INSERT INTO `jay_area` VALUES ('1555', '410482', '汝州市', '410400');
INSERT INTO `jay_area` VALUES ('1556', '410501', '市辖区', '410500');
INSERT INTO `jay_area` VALUES ('1557', '410502', '文峰区', '410500');
INSERT INTO `jay_area` VALUES ('1558', '410503', '北关区', '410500');
INSERT INTO `jay_area` VALUES ('1559', '410505', '殷都区', '410500');
INSERT INTO `jay_area` VALUES ('1560', '410506', '龙安区', '410500');
INSERT INTO `jay_area` VALUES ('1561', '410522', '安阳县', '410500');
INSERT INTO `jay_area` VALUES ('1562', '410523', '汤阴县', '410500');
INSERT INTO `jay_area` VALUES ('1563', '410526', '滑　县', '410500');
INSERT INTO `jay_area` VALUES ('1564', '410527', '内黄县', '410500');
INSERT INTO `jay_area` VALUES ('1565', '410581', '林州市', '410500');
INSERT INTO `jay_area` VALUES ('1566', '410601', '市辖区', '410600');
INSERT INTO `jay_area` VALUES ('1567', '410602', '鹤山区', '410600');
INSERT INTO `jay_area` VALUES ('1568', '410603', '山城区', '410600');
INSERT INTO `jay_area` VALUES ('1569', '410611', '淇滨区', '410600');
INSERT INTO `jay_area` VALUES ('1570', '410621', '浚　县', '410600');
INSERT INTO `jay_area` VALUES ('1571', '410622', '淇　县', '410600');
INSERT INTO `jay_area` VALUES ('1572', '410701', '市辖区', '410700');
INSERT INTO `jay_area` VALUES ('1573', '410702', '红旗区', '410700');
INSERT INTO `jay_area` VALUES ('1574', '410703', '卫滨区', '410700');
INSERT INTO `jay_area` VALUES ('1575', '410704', '凤泉区', '410700');
INSERT INTO `jay_area` VALUES ('1576', '410711', '牧野区', '410700');
INSERT INTO `jay_area` VALUES ('1577', '410721', '新乡县', '410700');
INSERT INTO `jay_area` VALUES ('1578', '410724', '获嘉县', '410700');
INSERT INTO `jay_area` VALUES ('1579', '410725', '原阳县', '410700');
INSERT INTO `jay_area` VALUES ('1580', '410726', '延津县', '410700');
INSERT INTO `jay_area` VALUES ('1581', '410727', '封丘县', '410700');
INSERT INTO `jay_area` VALUES ('1582', '410728', '长垣县', '410700');
INSERT INTO `jay_area` VALUES ('1583', '410781', '卫辉市', '410700');
INSERT INTO `jay_area` VALUES ('1584', '410782', '辉县市', '410700');
INSERT INTO `jay_area` VALUES ('1585', '410801', '市辖区', '410800');
INSERT INTO `jay_area` VALUES ('1586', '410802', '解放区', '410800');
INSERT INTO `jay_area` VALUES ('1587', '410803', '中站区', '410800');
INSERT INTO `jay_area` VALUES ('1588', '410804', '马村区', '410800');
INSERT INTO `jay_area` VALUES ('1589', '410811', '山阳区', '410800');
INSERT INTO `jay_area` VALUES ('1590', '410821', '修武县', '410800');
INSERT INTO `jay_area` VALUES ('1591', '410822', '博爱县', '410800');
INSERT INTO `jay_area` VALUES ('1592', '410823', '武陟县', '410800');
INSERT INTO `jay_area` VALUES ('1593', '410825', '温　县', '410800');
INSERT INTO `jay_area` VALUES ('1594', '410881', '济源市', '410800');
INSERT INTO `jay_area` VALUES ('1595', '410882', '沁阳市', '410800');
INSERT INTO `jay_area` VALUES ('1596', '410883', '孟州市', '410800');
INSERT INTO `jay_area` VALUES ('1597', '410901', '市辖区', '410900');
INSERT INTO `jay_area` VALUES ('1598', '410902', '华龙区', '410900');
INSERT INTO `jay_area` VALUES ('1599', '410922', '清丰县', '410900');
INSERT INTO `jay_area` VALUES ('1600', '410923', '南乐县', '410900');
INSERT INTO `jay_area` VALUES ('1601', '410926', '范　县', '410900');
INSERT INTO `jay_area` VALUES ('1602', '410927', '台前县', '410900');
INSERT INTO `jay_area` VALUES ('1603', '410928', '濮阳县', '410900');
INSERT INTO `jay_area` VALUES ('1604', '411001', '市辖区', '411000');
INSERT INTO `jay_area` VALUES ('1605', '411002', '魏都区', '411000');
INSERT INTO `jay_area` VALUES ('1606', '411023', '许昌县', '411000');
INSERT INTO `jay_area` VALUES ('1607', '411024', '鄢陵县', '411000');
INSERT INTO `jay_area` VALUES ('1608', '411025', '襄城县', '411000');
INSERT INTO `jay_area` VALUES ('1609', '411081', '禹州市', '411000');
INSERT INTO `jay_area` VALUES ('1610', '411082', '长葛市', '411000');
INSERT INTO `jay_area` VALUES ('1611', '411101', '市辖区', '411100');
INSERT INTO `jay_area` VALUES ('1612', '411102', '源汇区', '411100');
INSERT INTO `jay_area` VALUES ('1613', '411103', '郾城区', '411100');
INSERT INTO `jay_area` VALUES ('1614', '411104', '召陵区', '411100');
INSERT INTO `jay_area` VALUES ('1615', '411121', '舞阳县', '411100');
INSERT INTO `jay_area` VALUES ('1616', '411122', '临颍县', '411100');
INSERT INTO `jay_area` VALUES ('1617', '411201', '市辖区', '411200');
INSERT INTO `jay_area` VALUES ('1618', '411202', '湖滨区', '411200');
INSERT INTO `jay_area` VALUES ('1619', '411221', '渑池县', '411200');
INSERT INTO `jay_area` VALUES ('1620', '411222', '陕　县', '411200');
INSERT INTO `jay_area` VALUES ('1621', '411224', '卢氏县', '411200');
INSERT INTO `jay_area` VALUES ('1622', '411281', '义马市', '411200');
INSERT INTO `jay_area` VALUES ('1623', '411282', '灵宝市', '411200');
INSERT INTO `jay_area` VALUES ('1624', '411301', '市辖区', '411300');
INSERT INTO `jay_area` VALUES ('1625', '411302', '宛城区', '411300');
INSERT INTO `jay_area` VALUES ('1626', '411303', '卧龙区', '411300');
INSERT INTO `jay_area` VALUES ('1627', '411321', '南召县', '411300');
INSERT INTO `jay_area` VALUES ('1628', '411322', '方城县', '411300');
INSERT INTO `jay_area` VALUES ('1629', '411323', '西峡县', '411300');
INSERT INTO `jay_area` VALUES ('1630', '411324', '镇平县', '411300');
INSERT INTO `jay_area` VALUES ('1631', '411325', '内乡县', '411300');
INSERT INTO `jay_area` VALUES ('1632', '411326', '淅川县', '411300');
INSERT INTO `jay_area` VALUES ('1633', '411327', '社旗县', '411300');
INSERT INTO `jay_area` VALUES ('1634', '411328', '唐河县', '411300');
INSERT INTO `jay_area` VALUES ('1635', '411329', '新野县', '411300');
INSERT INTO `jay_area` VALUES ('1636', '411330', '桐柏县', '411300');
INSERT INTO `jay_area` VALUES ('1637', '411381', '邓州市', '411300');
INSERT INTO `jay_area` VALUES ('1638', '411401', '市辖区', '411400');
INSERT INTO `jay_area` VALUES ('1639', '411402', '梁园区', '411400');
INSERT INTO `jay_area` VALUES ('1640', '411403', '睢阳区', '411400');
INSERT INTO `jay_area` VALUES ('1641', '411421', '民权县', '411400');
INSERT INTO `jay_area` VALUES ('1642', '411422', '睢　县', '411400');
INSERT INTO `jay_area` VALUES ('1643', '411423', '宁陵县', '411400');
INSERT INTO `jay_area` VALUES ('1644', '411424', '柘城县', '411400');
INSERT INTO `jay_area` VALUES ('1645', '411425', '虞城县', '411400');
INSERT INTO `jay_area` VALUES ('1646', '411426', '夏邑县', '411400');
INSERT INTO `jay_area` VALUES ('1647', '411481', '永城市', '411400');
INSERT INTO `jay_area` VALUES ('1648', '411501', '市辖区', '411500');
INSERT INTO `jay_area` VALUES ('1649', '411502', '师河区', '411500');
INSERT INTO `jay_area` VALUES ('1650', '411503', '平桥区', '411500');
INSERT INTO `jay_area` VALUES ('1651', '411521', '罗山县', '411500');
INSERT INTO `jay_area` VALUES ('1652', '411522', '光山县', '411500');
INSERT INTO `jay_area` VALUES ('1653', '411523', '新　县', '411500');
INSERT INTO `jay_area` VALUES ('1654', '411524', '商城县', '411500');
INSERT INTO `jay_area` VALUES ('1655', '411525', '固始县', '411500');
INSERT INTO `jay_area` VALUES ('1656', '411526', '潢川县', '411500');
INSERT INTO `jay_area` VALUES ('1657', '411527', '淮滨县', '411500');
INSERT INTO `jay_area` VALUES ('1658', '411528', '息　县', '411500');
INSERT INTO `jay_area` VALUES ('1659', '411601', '市辖区', '411600');
INSERT INTO `jay_area` VALUES ('1660', '411602', '川汇区', '411600');
INSERT INTO `jay_area` VALUES ('1661', '411621', '扶沟县', '411600');
INSERT INTO `jay_area` VALUES ('1662', '411622', '西华县', '411600');
INSERT INTO `jay_area` VALUES ('1663', '411623', '商水县', '411600');
INSERT INTO `jay_area` VALUES ('1664', '411624', '沈丘县', '411600');
INSERT INTO `jay_area` VALUES ('1665', '411625', '郸城县', '411600');
INSERT INTO `jay_area` VALUES ('1666', '411626', '淮阳县', '411600');
INSERT INTO `jay_area` VALUES ('1667', '411627', '太康县', '411600');
INSERT INTO `jay_area` VALUES ('1668', '411628', '鹿邑县', '411600');
INSERT INTO `jay_area` VALUES ('1669', '411681', '项城市', '411600');
INSERT INTO `jay_area` VALUES ('1670', '411701', '市辖区', '411700');
INSERT INTO `jay_area` VALUES ('1671', '411702', '驿城区', '411700');
INSERT INTO `jay_area` VALUES ('1672', '411721', '西平县', '411700');
INSERT INTO `jay_area` VALUES ('1673', '411722', '上蔡县', '411700');
INSERT INTO `jay_area` VALUES ('1674', '411723', '平舆县', '411700');
INSERT INTO `jay_area` VALUES ('1675', '411724', '正阳县', '411700');
INSERT INTO `jay_area` VALUES ('1676', '411725', '确山县', '411700');
INSERT INTO `jay_area` VALUES ('1677', '411726', '泌阳县', '411700');
INSERT INTO `jay_area` VALUES ('1678', '411727', '汝南县', '411700');
INSERT INTO `jay_area` VALUES ('1679', '411728', '遂平县', '411700');
INSERT INTO `jay_area` VALUES ('1680', '411729', '新蔡县', '411700');
INSERT INTO `jay_area` VALUES ('1681', '420101', '市辖区', '420100');
INSERT INTO `jay_area` VALUES ('1682', '420102', '江岸区', '420100');
INSERT INTO `jay_area` VALUES ('1683', '420103', '江汉区', '420100');
INSERT INTO `jay_area` VALUES ('1684', '420104', '乔口区', '420100');
INSERT INTO `jay_area` VALUES ('1685', '420105', '汉阳区', '420100');
INSERT INTO `jay_area` VALUES ('1686', '420106', '武昌区', '420100');
INSERT INTO `jay_area` VALUES ('1687', '420107', '青山区', '420100');
INSERT INTO `jay_area` VALUES ('1688', '420111', '洪山区', '420100');
INSERT INTO `jay_area` VALUES ('1689', '420112', '东西湖区', '420100');
INSERT INTO `jay_area` VALUES ('1690', '420113', '汉南区', '420100');
INSERT INTO `jay_area` VALUES ('1691', '420114', '蔡甸区', '420100');
INSERT INTO `jay_area` VALUES ('1692', '420115', '江夏区', '420100');
INSERT INTO `jay_area` VALUES ('1693', '420116', '黄陂区', '420100');
INSERT INTO `jay_area` VALUES ('1694', '420117', '新洲区', '420100');
INSERT INTO `jay_area` VALUES ('1695', '420201', '市辖区', '420200');
INSERT INTO `jay_area` VALUES ('1696', '420202', '黄石港区', '420200');
INSERT INTO `jay_area` VALUES ('1697', '420203', '西塞山区', '420200');
INSERT INTO `jay_area` VALUES ('1698', '420204', '下陆区', '420200');
INSERT INTO `jay_area` VALUES ('1699', '420205', '铁山区', '420200');
INSERT INTO `jay_area` VALUES ('1700', '420222', '阳新县', '420200');
INSERT INTO `jay_area` VALUES ('1701', '420281', '大冶市', '420200');
INSERT INTO `jay_area` VALUES ('1702', '420301', '市辖区', '420300');
INSERT INTO `jay_area` VALUES ('1703', '420302', '茅箭区', '420300');
INSERT INTO `jay_area` VALUES ('1704', '420303', '张湾区', '420300');
INSERT INTO `jay_area` VALUES ('1705', '420321', '郧　县', '420300');
INSERT INTO `jay_area` VALUES ('1706', '420322', '郧西县', '420300');
INSERT INTO `jay_area` VALUES ('1707', '420323', '竹山县', '420300');
INSERT INTO `jay_area` VALUES ('1708', '420324', '竹溪县', '420300');
INSERT INTO `jay_area` VALUES ('1709', '420325', '房　县', '420300');
INSERT INTO `jay_area` VALUES ('1710', '420381', '丹江口市', '420300');
INSERT INTO `jay_area` VALUES ('1711', '420501', '市辖区', '420500');
INSERT INTO `jay_area` VALUES ('1712', '420502', '西陵区', '420500');
INSERT INTO `jay_area` VALUES ('1713', '420503', '伍家岗区', '420500');
INSERT INTO `jay_area` VALUES ('1714', '420504', '点军区', '420500');
INSERT INTO `jay_area` VALUES ('1715', '420505', '猇亭区', '420500');
INSERT INTO `jay_area` VALUES ('1716', '420506', '夷陵区', '420500');
INSERT INTO `jay_area` VALUES ('1717', '420525', '远安县', '420500');
INSERT INTO `jay_area` VALUES ('1718', '420526', '兴山县', '420500');
INSERT INTO `jay_area` VALUES ('1719', '420527', '秭归县', '420500');
INSERT INTO `jay_area` VALUES ('1720', '420528', '长阳土家族自治县', '420500');
INSERT INTO `jay_area` VALUES ('1721', '420529', '五峰土家族自治县', '420500');
INSERT INTO `jay_area` VALUES ('1722', '420581', '宜都市', '420500');
INSERT INTO `jay_area` VALUES ('1723', '420582', '当阳市', '420500');
INSERT INTO `jay_area` VALUES ('1724', '420583', '枝江市', '420500');
INSERT INTO `jay_area` VALUES ('1725', '420601', '市辖区', '420600');
INSERT INTO `jay_area` VALUES ('1726', '420602', '襄城区', '420600');
INSERT INTO `jay_area` VALUES ('1727', '420606', '樊城区', '420600');
INSERT INTO `jay_area` VALUES ('1728', '420607', '襄阳区', '420600');
INSERT INTO `jay_area` VALUES ('1729', '420624', '南漳县', '420600');
INSERT INTO `jay_area` VALUES ('1730', '420625', '谷城县', '420600');
INSERT INTO `jay_area` VALUES ('1731', '420626', '保康县', '420600');
INSERT INTO `jay_area` VALUES ('1732', '420682', '老河口市', '420600');
INSERT INTO `jay_area` VALUES ('1733', '420683', '枣阳市', '420600');
INSERT INTO `jay_area` VALUES ('1734', '420684', '宜城市', '420600');
INSERT INTO `jay_area` VALUES ('1735', '420701', '市辖区', '420700');
INSERT INTO `jay_area` VALUES ('1736', '420702', '梁子湖区', '420700');
INSERT INTO `jay_area` VALUES ('1737', '420703', '华容区', '420700');
INSERT INTO `jay_area` VALUES ('1738', '420704', '鄂城区', '420700');
INSERT INTO `jay_area` VALUES ('1739', '420801', '市辖区', '420800');
INSERT INTO `jay_area` VALUES ('1740', '420802', '东宝区', '420800');
INSERT INTO `jay_area` VALUES ('1741', '420804', '掇刀区', '420800');
INSERT INTO `jay_area` VALUES ('1742', '420821', '京山县', '420800');
INSERT INTO `jay_area` VALUES ('1743', '420822', '沙洋县', '420800');
INSERT INTO `jay_area` VALUES ('1744', '420881', '钟祥市', '420800');
INSERT INTO `jay_area` VALUES ('1745', '420901', '市辖区', '420900');
INSERT INTO `jay_area` VALUES ('1746', '420902', '孝南区', '420900');
INSERT INTO `jay_area` VALUES ('1747', '420921', '孝昌县', '420900');
INSERT INTO `jay_area` VALUES ('1748', '420922', '大悟县', '420900');
INSERT INTO `jay_area` VALUES ('1749', '420923', '云梦县', '420900');
INSERT INTO `jay_area` VALUES ('1750', '420981', '应城市', '420900');
INSERT INTO `jay_area` VALUES ('1751', '420982', '安陆市', '420900');
INSERT INTO `jay_area` VALUES ('1752', '420984', '汉川市', '420900');
INSERT INTO `jay_area` VALUES ('1753', '421001', '市辖区', '421000');
INSERT INTO `jay_area` VALUES ('1754', '421002', '沙市区', '421000');
INSERT INTO `jay_area` VALUES ('1755', '421003', '荆州区', '421000');
INSERT INTO `jay_area` VALUES ('1756', '421022', '公安县', '421000');
INSERT INTO `jay_area` VALUES ('1757', '421023', '监利县', '421000');
INSERT INTO `jay_area` VALUES ('1758', '421024', '江陵县', '421000');
INSERT INTO `jay_area` VALUES ('1759', '421081', '石首市', '421000');
INSERT INTO `jay_area` VALUES ('1760', '421083', '洪湖市', '421000');
INSERT INTO `jay_area` VALUES ('1761', '421087', '松滋市', '421000');
INSERT INTO `jay_area` VALUES ('1762', '421101', '市辖区', '421100');
INSERT INTO `jay_area` VALUES ('1763', '421102', '黄州区', '421100');
INSERT INTO `jay_area` VALUES ('1764', '421121', '团风县', '421100');
INSERT INTO `jay_area` VALUES ('1765', '421122', '红安县', '421100');
INSERT INTO `jay_area` VALUES ('1766', '421123', '罗田县', '421100');
INSERT INTO `jay_area` VALUES ('1767', '421124', '英山县', '421100');
INSERT INTO `jay_area` VALUES ('1768', '421125', '浠水县', '421100');
INSERT INTO `jay_area` VALUES ('1769', '421126', '蕲春县', '421100');
INSERT INTO `jay_area` VALUES ('1770', '421127', '黄梅县', '421100');
INSERT INTO `jay_area` VALUES ('1771', '421181', '麻城市', '421100');
INSERT INTO `jay_area` VALUES ('1772', '421182', '武穴市', '421100');
INSERT INTO `jay_area` VALUES ('1773', '421201', '市辖区', '421200');
INSERT INTO `jay_area` VALUES ('1774', '421202', '咸安区', '421200');
INSERT INTO `jay_area` VALUES ('1775', '421221', '嘉鱼县', '421200');
INSERT INTO `jay_area` VALUES ('1776', '421222', '通城县', '421200');
INSERT INTO `jay_area` VALUES ('1777', '421223', '崇阳县', '421200');
INSERT INTO `jay_area` VALUES ('1778', '421224', '通山县', '421200');
INSERT INTO `jay_area` VALUES ('1779', '421281', '赤壁市', '421200');
INSERT INTO `jay_area` VALUES ('1780', '421301', '市辖区', '421300');
INSERT INTO `jay_area` VALUES ('1781', '421302', '曾都区', '421300');
INSERT INTO `jay_area` VALUES ('1782', '421381', '广水市', '421300');
INSERT INTO `jay_area` VALUES ('1783', '422801', '恩施市', '422800');
INSERT INTO `jay_area` VALUES ('1784', '422802', '利川市', '422800');
INSERT INTO `jay_area` VALUES ('1785', '422822', '建始县', '422800');
INSERT INTO `jay_area` VALUES ('1786', '422823', '巴东县', '422800');
INSERT INTO `jay_area` VALUES ('1787', '422825', '宣恩县', '422800');
INSERT INTO `jay_area` VALUES ('1788', '422826', '咸丰县', '422800');
INSERT INTO `jay_area` VALUES ('1789', '422827', '来凤县', '422800');
INSERT INTO `jay_area` VALUES ('1790', '422828', '鹤峰县', '422800');
INSERT INTO `jay_area` VALUES ('1791', '429004', '仙桃市', '429000');
INSERT INTO `jay_area` VALUES ('1792', '429005', '潜江市', '429000');
INSERT INTO `jay_area` VALUES ('1793', '429006', '天门市', '429000');
INSERT INTO `jay_area` VALUES ('1794', '429021', '神农架林区', '429000');
INSERT INTO `jay_area` VALUES ('1795', '430101', '市辖区', '430100');
INSERT INTO `jay_area` VALUES ('1796', '430102', '芙蓉区', '430100');
INSERT INTO `jay_area` VALUES ('1797', '430103', '天心区', '430100');
INSERT INTO `jay_area` VALUES ('1798', '430104', '岳麓区', '430100');
INSERT INTO `jay_area` VALUES ('1799', '430105', '开福区', '430100');
INSERT INTO `jay_area` VALUES ('1800', '430111', '雨花区', '430100');
INSERT INTO `jay_area` VALUES ('1801', '430121', '长沙县', '430100');
INSERT INTO `jay_area` VALUES ('1802', '430122', '望城县', '430100');
INSERT INTO `jay_area` VALUES ('1803', '430124', '宁乡县', '430100');
INSERT INTO `jay_area` VALUES ('1804', '430181', '浏阳市', '430100');
INSERT INTO `jay_area` VALUES ('1805', '430201', '市辖区', '430200');
INSERT INTO `jay_area` VALUES ('1806', '430202', '荷塘区', '430200');
INSERT INTO `jay_area` VALUES ('1807', '430203', '芦淞区', '430200');
INSERT INTO `jay_area` VALUES ('1808', '430204', '石峰区', '430200');
INSERT INTO `jay_area` VALUES ('1809', '430211', '天元区', '430200');
INSERT INTO `jay_area` VALUES ('1810', '430221', '株洲县', '430200');
INSERT INTO `jay_area` VALUES ('1811', '430223', '攸　县', '430200');
INSERT INTO `jay_area` VALUES ('1812', '430224', '茶陵县', '430200');
INSERT INTO `jay_area` VALUES ('1813', '430225', '炎陵县', '430200');
INSERT INTO `jay_area` VALUES ('1814', '430281', '醴陵市', '430200');
INSERT INTO `jay_area` VALUES ('1815', '430301', '市辖区', '430300');
INSERT INTO `jay_area` VALUES ('1816', '430302', '雨湖区', '430300');
INSERT INTO `jay_area` VALUES ('1817', '430304', '岳塘区', '430300');
INSERT INTO `jay_area` VALUES ('1818', '430321', '湘潭县', '430300');
INSERT INTO `jay_area` VALUES ('1819', '430381', '湘乡市', '430300');
INSERT INTO `jay_area` VALUES ('1820', '430382', '韶山市', '430300');
INSERT INTO `jay_area` VALUES ('1821', '430401', '市辖区', '430400');
INSERT INTO `jay_area` VALUES ('1822', '430405', '珠晖区', '430400');
INSERT INTO `jay_area` VALUES ('1823', '430406', '雁峰区', '430400');
INSERT INTO `jay_area` VALUES ('1824', '430407', '石鼓区', '430400');
INSERT INTO `jay_area` VALUES ('1825', '430408', '蒸湘区', '430400');
INSERT INTO `jay_area` VALUES ('1826', '430412', '南岳区', '430400');
INSERT INTO `jay_area` VALUES ('1827', '430421', '衡阳县', '430400');
INSERT INTO `jay_area` VALUES ('1828', '430422', '衡南县', '430400');
INSERT INTO `jay_area` VALUES ('1829', '430423', '衡山县', '430400');
INSERT INTO `jay_area` VALUES ('1830', '430424', '衡东县', '430400');
INSERT INTO `jay_area` VALUES ('1831', '430426', '祁东县', '430400');
INSERT INTO `jay_area` VALUES ('1832', '430481', '耒阳市', '430400');
INSERT INTO `jay_area` VALUES ('1833', '430482', '常宁市', '430400');
INSERT INTO `jay_area` VALUES ('1834', '430501', '市辖区', '430500');
INSERT INTO `jay_area` VALUES ('1835', '430502', '双清区', '430500');
INSERT INTO `jay_area` VALUES ('1836', '430503', '大祥区', '430500');
INSERT INTO `jay_area` VALUES ('1837', '430511', '北塔区', '430500');
INSERT INTO `jay_area` VALUES ('1838', '430521', '邵东县', '430500');
INSERT INTO `jay_area` VALUES ('1839', '430522', '新邵县', '430500');
INSERT INTO `jay_area` VALUES ('1840', '430523', '邵阳县', '430500');
INSERT INTO `jay_area` VALUES ('1841', '430524', '隆回县', '430500');
INSERT INTO `jay_area` VALUES ('1842', '430525', '洞口县', '430500');
INSERT INTO `jay_area` VALUES ('1843', '430527', '绥宁县', '430500');
INSERT INTO `jay_area` VALUES ('1844', '430528', '新宁县', '430500');
INSERT INTO `jay_area` VALUES ('1845', '430529', '城步苗族自治县', '430500');
INSERT INTO `jay_area` VALUES ('1846', '430581', '武冈市', '430500');
INSERT INTO `jay_area` VALUES ('1847', '430601', '市辖区', '430600');
INSERT INTO `jay_area` VALUES ('1848', '430602', '岳阳楼区', '430600');
INSERT INTO `jay_area` VALUES ('1849', '430603', '云溪区', '430600');
INSERT INTO `jay_area` VALUES ('1850', '430611', '君山区', '430600');
INSERT INTO `jay_area` VALUES ('1851', '430621', '岳阳县', '430600');
INSERT INTO `jay_area` VALUES ('1852', '430623', '华容县', '430600');
INSERT INTO `jay_area` VALUES ('1853', '430624', '湘阴县', '430600');
INSERT INTO `jay_area` VALUES ('1854', '430626', '平江县', '430600');
INSERT INTO `jay_area` VALUES ('1855', '430681', '汨罗市', '430600');
INSERT INTO `jay_area` VALUES ('1856', '430682', '临湘市', '430600');
INSERT INTO `jay_area` VALUES ('1857', '430701', '市辖区', '430700');
INSERT INTO `jay_area` VALUES ('1858', '430702', '武陵区', '430700');
INSERT INTO `jay_area` VALUES ('1859', '430703', '鼎城区', '430700');
INSERT INTO `jay_area` VALUES ('1860', '430721', '安乡县', '430700');
INSERT INTO `jay_area` VALUES ('1861', '430722', '汉寿县', '430700');
INSERT INTO `jay_area` VALUES ('1862', '430723', '澧　县', '430700');
INSERT INTO `jay_area` VALUES ('1863', '430724', '临澧县', '430700');
INSERT INTO `jay_area` VALUES ('1864', '430725', '桃源县', '430700');
INSERT INTO `jay_area` VALUES ('1865', '430726', '石门县', '430700');
INSERT INTO `jay_area` VALUES ('1866', '430781', '津市市', '430700');
INSERT INTO `jay_area` VALUES ('1867', '430801', '市辖区', '430800');
INSERT INTO `jay_area` VALUES ('1868', '430802', '永定区', '430800');
INSERT INTO `jay_area` VALUES ('1869', '430811', '武陵源区', '430800');
INSERT INTO `jay_area` VALUES ('1870', '430821', '慈利县', '430800');
INSERT INTO `jay_area` VALUES ('1871', '430822', '桑植县', '430800');
INSERT INTO `jay_area` VALUES ('1872', '430901', '市辖区', '430900');
INSERT INTO `jay_area` VALUES ('1873', '430902', '资阳区', '430900');
INSERT INTO `jay_area` VALUES ('1874', '430903', '赫山区', '430900');
INSERT INTO `jay_area` VALUES ('1875', '430921', '南　县', '430900');
INSERT INTO `jay_area` VALUES ('1876', '430922', '桃江县', '430900');
INSERT INTO `jay_area` VALUES ('1877', '430923', '安化县', '430900');
INSERT INTO `jay_area` VALUES ('1878', '430981', '沅江市', '430900');
INSERT INTO `jay_area` VALUES ('1879', '431001', '市辖区', '431000');
INSERT INTO `jay_area` VALUES ('1880', '431002', '北湖区', '431000');
INSERT INTO `jay_area` VALUES ('1881', '431003', '苏仙区', '431000');
INSERT INTO `jay_area` VALUES ('1882', '431021', '桂阳县', '431000');
INSERT INTO `jay_area` VALUES ('1883', '431022', '宜章县', '431000');
INSERT INTO `jay_area` VALUES ('1884', '431023', '永兴县', '431000');
INSERT INTO `jay_area` VALUES ('1885', '431024', '嘉禾县', '431000');
INSERT INTO `jay_area` VALUES ('1886', '431025', '临武县', '431000');
INSERT INTO `jay_area` VALUES ('1887', '431026', '汝城县', '431000');
INSERT INTO `jay_area` VALUES ('1888', '431027', '桂东县', '431000');
INSERT INTO `jay_area` VALUES ('1889', '431028', '安仁县', '431000');
INSERT INTO `jay_area` VALUES ('1890', '431081', '资兴市', '431000');
INSERT INTO `jay_area` VALUES ('1891', '431101', '市辖区', '431100');
INSERT INTO `jay_area` VALUES ('1892', '431102', '芝山区', '431100');
INSERT INTO `jay_area` VALUES ('1893', '431103', '冷水滩区', '431100');
INSERT INTO `jay_area` VALUES ('1894', '431121', '祁阳县', '431100');
INSERT INTO `jay_area` VALUES ('1895', '431122', '东安县', '431100');
INSERT INTO `jay_area` VALUES ('1896', '431123', '双牌县', '431100');
INSERT INTO `jay_area` VALUES ('1897', '431124', '道　县', '431100');
INSERT INTO `jay_area` VALUES ('1898', '431125', '江永县', '431100');
INSERT INTO `jay_area` VALUES ('1899', '431126', '宁远县', '431100');
INSERT INTO `jay_area` VALUES ('1900', '431127', '蓝山县', '431100');
INSERT INTO `jay_area` VALUES ('1901', '431128', '新田县', '431100');
INSERT INTO `jay_area` VALUES ('1902', '431129', '江华瑶族自治县', '431100');
INSERT INTO `jay_area` VALUES ('1903', '431201', '市辖区', '431200');
INSERT INTO `jay_area` VALUES ('1904', '431202', '鹤城区', '431200');
INSERT INTO `jay_area` VALUES ('1905', '431221', '中方县', '431200');
INSERT INTO `jay_area` VALUES ('1906', '431222', '沅陵县', '431200');
INSERT INTO `jay_area` VALUES ('1907', '431223', '辰溪县', '431200');
INSERT INTO `jay_area` VALUES ('1908', '431224', '溆浦县', '431200');
INSERT INTO `jay_area` VALUES ('1909', '431225', '会同县', '431200');
INSERT INTO `jay_area` VALUES ('1910', '431226', '麻阳苗族自治县', '431200');
INSERT INTO `jay_area` VALUES ('1911', '431227', '新晃侗族自治县', '431200');
INSERT INTO `jay_area` VALUES ('1912', '431228', '芷江侗族自治县', '431200');
INSERT INTO `jay_area` VALUES ('1913', '431229', '靖州苗族侗族自治县', '431200');
INSERT INTO `jay_area` VALUES ('1914', '431230', '通道侗族自治县', '431200');
INSERT INTO `jay_area` VALUES ('1915', '431281', '洪江市', '431200');
INSERT INTO `jay_area` VALUES ('1916', '431301', '市辖区', '431300');
INSERT INTO `jay_area` VALUES ('1917', '431302', '娄星区', '431300');
INSERT INTO `jay_area` VALUES ('1918', '431321', '双峰县', '431300');
INSERT INTO `jay_area` VALUES ('1919', '431322', '新化县', '431300');
INSERT INTO `jay_area` VALUES ('1920', '431381', '冷水江市', '431300');
INSERT INTO `jay_area` VALUES ('1921', '431382', '涟源市', '431300');
INSERT INTO `jay_area` VALUES ('1922', '433101', '吉首市', '433100');
INSERT INTO `jay_area` VALUES ('1923', '433122', '泸溪县', '433100');
INSERT INTO `jay_area` VALUES ('1924', '433123', '凤凰县', '433100');
INSERT INTO `jay_area` VALUES ('1925', '433124', '花垣县', '433100');
INSERT INTO `jay_area` VALUES ('1926', '433125', '保靖县', '433100');
INSERT INTO `jay_area` VALUES ('1927', '433126', '古丈县', '433100');
INSERT INTO `jay_area` VALUES ('1928', '433127', '永顺县', '433100');
INSERT INTO `jay_area` VALUES ('1929', '433130', '龙山县', '433100');
INSERT INTO `jay_area` VALUES ('1930', '440101', '市辖区', '440100');
INSERT INTO `jay_area` VALUES ('1931', '440102', '东山区', '440100');
INSERT INTO `jay_area` VALUES ('1932', '440103', '荔湾区', '440100');
INSERT INTO `jay_area` VALUES ('1933', '440104', '越秀区', '440100');
INSERT INTO `jay_area` VALUES ('1934', '440105', '海珠区', '440100');
INSERT INTO `jay_area` VALUES ('1935', '440106', '天河区', '440100');
INSERT INTO `jay_area` VALUES ('1936', '440107', '芳村区', '440100');
INSERT INTO `jay_area` VALUES ('1937', '440111', '白云区', '440100');
INSERT INTO `jay_area` VALUES ('1938', '440112', '黄埔区', '440100');
INSERT INTO `jay_area` VALUES ('1939', '440113', '番禺区', '440100');
INSERT INTO `jay_area` VALUES ('1940', '440114', '花都区', '440100');
INSERT INTO `jay_area` VALUES ('1941', '440183', '增城市', '440100');
INSERT INTO `jay_area` VALUES ('1942', '440184', '从化市', '440100');
INSERT INTO `jay_area` VALUES ('1943', '440201', '市辖区', '440200');
INSERT INTO `jay_area` VALUES ('1944', '440203', '武江区', '440200');
INSERT INTO `jay_area` VALUES ('1945', '440204', '浈江区', '440200');
INSERT INTO `jay_area` VALUES ('1946', '440205', '曲江区', '440200');
INSERT INTO `jay_area` VALUES ('1947', '440222', '始兴县', '440200');
INSERT INTO `jay_area` VALUES ('1948', '440224', '仁化县', '440200');
INSERT INTO `jay_area` VALUES ('1949', '440229', '翁源县', '440200');
INSERT INTO `jay_area` VALUES ('1950', '440232', '乳源瑶族自治县', '440200');
INSERT INTO `jay_area` VALUES ('1951', '440233', '新丰县', '440200');
INSERT INTO `jay_area` VALUES ('1952', '440281', '乐昌市', '440200');
INSERT INTO `jay_area` VALUES ('1953', '440282', '南雄市', '440200');
INSERT INTO `jay_area` VALUES ('1954', '440301', '市辖区', '440300');
INSERT INTO `jay_area` VALUES ('1955', '440303', '罗湖区', '440300');
INSERT INTO `jay_area` VALUES ('1956', '440304', '福田区', '440300');
INSERT INTO `jay_area` VALUES ('1957', '440305', '南山区', '440300');
INSERT INTO `jay_area` VALUES ('1958', '440306', '宝安区', '440300');
INSERT INTO `jay_area` VALUES ('1959', '440307', '龙岗区', '440300');
INSERT INTO `jay_area` VALUES ('1960', '440308', '盐田区', '440300');
INSERT INTO `jay_area` VALUES ('1961', '440401', '市辖区', '440400');
INSERT INTO `jay_area` VALUES ('1962', '440402', '香洲区', '440400');
INSERT INTO `jay_area` VALUES ('1963', '440403', '斗门区', '440400');
INSERT INTO `jay_area` VALUES ('1964', '440404', '金湾区', '440400');
INSERT INTO `jay_area` VALUES ('1965', '440501', '市辖区', '440500');
INSERT INTO `jay_area` VALUES ('1966', '440507', '龙湖区', '440500');
INSERT INTO `jay_area` VALUES ('1967', '440511', '金平区', '440500');
INSERT INTO `jay_area` VALUES ('1968', '440512', '濠江区', '440500');
INSERT INTO `jay_area` VALUES ('1969', '440513', '潮阳区', '440500');
INSERT INTO `jay_area` VALUES ('1970', '440514', '潮南区', '440500');
INSERT INTO `jay_area` VALUES ('1971', '440515', '澄海区', '440500');
INSERT INTO `jay_area` VALUES ('1972', '440523', '南澳县', '440500');
INSERT INTO `jay_area` VALUES ('1973', '440601', '市辖区', '440600');
INSERT INTO `jay_area` VALUES ('1974', '440604', '禅城区', '440600');
INSERT INTO `jay_area` VALUES ('1975', '440605', '南海区', '440600');
INSERT INTO `jay_area` VALUES ('1976', '440606', '顺德区', '440600');
INSERT INTO `jay_area` VALUES ('1977', '440607', '三水区', '440600');
INSERT INTO `jay_area` VALUES ('1978', '440608', '高明区', '440600');
INSERT INTO `jay_area` VALUES ('1979', '440701', '市辖区', '440700');
INSERT INTO `jay_area` VALUES ('1980', '440703', '蓬江区', '440700');
INSERT INTO `jay_area` VALUES ('1981', '440704', '江海区', '440700');
INSERT INTO `jay_area` VALUES ('1982', '440705', '新会区', '440700');
INSERT INTO `jay_area` VALUES ('1983', '440781', '台山市', '440700');
INSERT INTO `jay_area` VALUES ('1984', '440783', '开平市', '440700');
INSERT INTO `jay_area` VALUES ('1985', '440784', '鹤山市', '440700');
INSERT INTO `jay_area` VALUES ('1986', '440785', '恩平市', '440700');
INSERT INTO `jay_area` VALUES ('1987', '440801', '市辖区', '440800');
INSERT INTO `jay_area` VALUES ('1988', '440802', '赤坎区', '440800');
INSERT INTO `jay_area` VALUES ('1989', '440803', '霞山区', '440800');
INSERT INTO `jay_area` VALUES ('1990', '440804', '坡头区', '440800');
INSERT INTO `jay_area` VALUES ('1991', '440811', '麻章区', '440800');
INSERT INTO `jay_area` VALUES ('1992', '440823', '遂溪县', '440800');
INSERT INTO `jay_area` VALUES ('1993', '440825', '徐闻县', '440800');
INSERT INTO `jay_area` VALUES ('1994', '440881', '廉江市', '440800');
INSERT INTO `jay_area` VALUES ('1995', '440882', '雷州市', '440800');
INSERT INTO `jay_area` VALUES ('1996', '440883', '吴川市', '440800');
INSERT INTO `jay_area` VALUES ('1997', '440901', '市辖区', '440900');
INSERT INTO `jay_area` VALUES ('1998', '440902', '茂南区', '440900');
INSERT INTO `jay_area` VALUES ('1999', '440903', '茂港区', '440900');
INSERT INTO `jay_area` VALUES ('2000', '440923', '电白县', '440900');
INSERT INTO `jay_area` VALUES ('2001', '440981', '高州市', '440900');
INSERT INTO `jay_area` VALUES ('2002', '440982', '化州市', '440900');
INSERT INTO `jay_area` VALUES ('2003', '440983', '信宜市', '440900');
INSERT INTO `jay_area` VALUES ('2004', '441201', '市辖区', '441200');
INSERT INTO `jay_area` VALUES ('2005', '441202', '端州区', '441200');
INSERT INTO `jay_area` VALUES ('2006', '441203', '鼎湖区', '441200');
INSERT INTO `jay_area` VALUES ('2007', '441223', '广宁县', '441200');
INSERT INTO `jay_area` VALUES ('2008', '441224', '怀集县', '441200');
INSERT INTO `jay_area` VALUES ('2009', '441225', '封开县', '441200');
INSERT INTO `jay_area` VALUES ('2010', '441226', '德庆县', '441200');
INSERT INTO `jay_area` VALUES ('2011', '441283', '高要市', '441200');
INSERT INTO `jay_area` VALUES ('2012', '441284', '四会市', '441200');
INSERT INTO `jay_area` VALUES ('2013', '441301', '市辖区', '441300');
INSERT INTO `jay_area` VALUES ('2014', '441302', '惠城区', '441300');
INSERT INTO `jay_area` VALUES ('2015', '441303', '惠阳区', '441300');
INSERT INTO `jay_area` VALUES ('2016', '441322', '博罗县', '441300');
INSERT INTO `jay_area` VALUES ('2017', '441323', '惠东县', '441300');
INSERT INTO `jay_area` VALUES ('2018', '441324', '龙门县', '441300');
INSERT INTO `jay_area` VALUES ('2019', '441401', '市辖区', '441400');
INSERT INTO `jay_area` VALUES ('2020', '441402', '梅江区', '441400');
INSERT INTO `jay_area` VALUES ('2021', '441421', '梅　县', '441400');
INSERT INTO `jay_area` VALUES ('2022', '441422', '大埔县', '441400');
INSERT INTO `jay_area` VALUES ('2023', '441423', '丰顺县', '441400');
INSERT INTO `jay_area` VALUES ('2024', '441424', '五华县', '441400');
INSERT INTO `jay_area` VALUES ('2025', '441426', '平远县', '441400');
INSERT INTO `jay_area` VALUES ('2026', '441427', '蕉岭县', '441400');
INSERT INTO `jay_area` VALUES ('2027', '441481', '兴宁市', '441400');
INSERT INTO `jay_area` VALUES ('2028', '441501', '市辖区', '441500');
INSERT INTO `jay_area` VALUES ('2029', '441502', '城　区', '441500');
INSERT INTO `jay_area` VALUES ('2030', '441521', '海丰县', '441500');
INSERT INTO `jay_area` VALUES ('2031', '441523', '陆河县', '441500');
INSERT INTO `jay_area` VALUES ('2032', '441581', '陆丰市', '441500');
INSERT INTO `jay_area` VALUES ('2033', '441601', '市辖区', '441600');
INSERT INTO `jay_area` VALUES ('2034', '441602', '源城区', '441600');
INSERT INTO `jay_area` VALUES ('2035', '441621', '紫金县', '441600');
INSERT INTO `jay_area` VALUES ('2036', '441622', '龙川县', '441600');
INSERT INTO `jay_area` VALUES ('2037', '441623', '连平县', '441600');
INSERT INTO `jay_area` VALUES ('2038', '441624', '和平县', '441600');
INSERT INTO `jay_area` VALUES ('2039', '441625', '东源县', '441600');
INSERT INTO `jay_area` VALUES ('2040', '441701', '市辖区', '441700');
INSERT INTO `jay_area` VALUES ('2041', '441702', '江城区', '441700');
INSERT INTO `jay_area` VALUES ('2042', '441721', '阳西县', '441700');
INSERT INTO `jay_area` VALUES ('2043', '441723', '阳东县', '441700');
INSERT INTO `jay_area` VALUES ('2044', '441781', '阳春市', '441700');
INSERT INTO `jay_area` VALUES ('2045', '441801', '市辖区', '441800');
INSERT INTO `jay_area` VALUES ('2046', '441802', '清城区', '441800');
INSERT INTO `jay_area` VALUES ('2047', '441821', '佛冈县', '441800');
INSERT INTO `jay_area` VALUES ('2048', '441823', '阳山县', '441800');
INSERT INTO `jay_area` VALUES ('2049', '441825', '连山壮族瑶族自治县', '441800');
INSERT INTO `jay_area` VALUES ('2050', '441826', '连南瑶族自治县', '441800');
INSERT INTO `jay_area` VALUES ('2051', '441827', '清新县', '441800');
INSERT INTO `jay_area` VALUES ('2052', '441881', '英德市', '441800');
INSERT INTO `jay_area` VALUES ('2053', '441882', '连州市', '441800');
INSERT INTO `jay_area` VALUES ('2054', '445101', '市辖区', '445100');
INSERT INTO `jay_area` VALUES ('2055', '445102', '湘桥区', '445100');
INSERT INTO `jay_area` VALUES ('2056', '445121', '潮安县', '445100');
INSERT INTO `jay_area` VALUES ('2057', '445122', '饶平县', '445100');
INSERT INTO `jay_area` VALUES ('2058', '445201', '市辖区', '445200');
INSERT INTO `jay_area` VALUES ('2059', '445202', '榕城区', '445200');
INSERT INTO `jay_area` VALUES ('2060', '445221', '揭东县', '445200');
INSERT INTO `jay_area` VALUES ('2061', '445222', '揭西县', '445200');
INSERT INTO `jay_area` VALUES ('2062', '445224', '惠来县', '445200');
INSERT INTO `jay_area` VALUES ('2063', '445281', '普宁市', '445200');
INSERT INTO `jay_area` VALUES ('2064', '445301', '市辖区', '445300');
INSERT INTO `jay_area` VALUES ('2065', '445302', '云城区', '445300');
INSERT INTO `jay_area` VALUES ('2066', '445321', '新兴县', '445300');
INSERT INTO `jay_area` VALUES ('2067', '445322', '郁南县', '445300');
INSERT INTO `jay_area` VALUES ('2068', '445323', '云安县', '445300');
INSERT INTO `jay_area` VALUES ('2069', '445381', '罗定市', '445300');
INSERT INTO `jay_area` VALUES ('2070', '450101', '市辖区', '450100');
INSERT INTO `jay_area` VALUES ('2071', '450102', '兴宁区', '450100');
INSERT INTO `jay_area` VALUES ('2072', '450103', '青秀区', '450100');
INSERT INTO `jay_area` VALUES ('2073', '450105', '江南区', '450100');
INSERT INTO `jay_area` VALUES ('2074', '450107', '西乡塘区', '450100');
INSERT INTO `jay_area` VALUES ('2075', '450108', '良庆区', '450100');
INSERT INTO `jay_area` VALUES ('2076', '450109', '邕宁区', '450100');
INSERT INTO `jay_area` VALUES ('2077', '450122', '武鸣县', '450100');
INSERT INTO `jay_area` VALUES ('2078', '450123', '隆安县', '450100');
INSERT INTO `jay_area` VALUES ('2079', '450124', '马山县', '450100');
INSERT INTO `jay_area` VALUES ('2080', '450125', '上林县', '450100');
INSERT INTO `jay_area` VALUES ('2081', '450126', '宾阳县', '450100');
INSERT INTO `jay_area` VALUES ('2082', '450127', '横　县', '450100');
INSERT INTO `jay_area` VALUES ('2083', '450201', '市辖区', '450200');
INSERT INTO `jay_area` VALUES ('2084', '450202', '城中区', '450200');
INSERT INTO `jay_area` VALUES ('2085', '450203', '鱼峰区', '450200');
INSERT INTO `jay_area` VALUES ('2086', '450204', '柳南区', '450200');
INSERT INTO `jay_area` VALUES ('2087', '450205', '柳北区', '450200');
INSERT INTO `jay_area` VALUES ('2088', '450221', '柳江县', '450200');
INSERT INTO `jay_area` VALUES ('2089', '450222', '柳城县', '450200');
INSERT INTO `jay_area` VALUES ('2090', '450223', '鹿寨县', '450200');
INSERT INTO `jay_area` VALUES ('2091', '450224', '融安县', '450200');
INSERT INTO `jay_area` VALUES ('2092', '450225', '融水苗族自治县', '450200');
INSERT INTO `jay_area` VALUES ('2093', '450226', '三江侗族自治县', '450200');
INSERT INTO `jay_area` VALUES ('2094', '450301', '市辖区', '450300');
INSERT INTO `jay_area` VALUES ('2095', '450302', '秀峰区', '450300');
INSERT INTO `jay_area` VALUES ('2096', '450303', '叠彩区', '450300');
INSERT INTO `jay_area` VALUES ('2097', '450304', '象山区', '450300');
INSERT INTO `jay_area` VALUES ('2098', '450305', '七星区', '450300');
INSERT INTO `jay_area` VALUES ('2099', '450311', '雁山区', '450300');
INSERT INTO `jay_area` VALUES ('2100', '450321', '阳朔县', '450300');
INSERT INTO `jay_area` VALUES ('2101', '450322', '临桂县', '450300');
INSERT INTO `jay_area` VALUES ('2102', '450323', '灵川县', '450300');
INSERT INTO `jay_area` VALUES ('2103', '450324', '全州县', '450300');
INSERT INTO `jay_area` VALUES ('2104', '450325', '兴安县', '450300');
INSERT INTO `jay_area` VALUES ('2105', '450326', '永福县', '450300');
INSERT INTO `jay_area` VALUES ('2106', '450327', '灌阳县', '450300');
INSERT INTO `jay_area` VALUES ('2107', '450328', '龙胜各族自治县', '450300');
INSERT INTO `jay_area` VALUES ('2108', '450329', '资源县', '450300');
INSERT INTO `jay_area` VALUES ('2109', '450330', '平乐县', '450300');
INSERT INTO `jay_area` VALUES ('2110', '450331', '荔蒲县', '450300');
INSERT INTO `jay_area` VALUES ('2111', '450332', '恭城瑶族自治县', '450300');
INSERT INTO `jay_area` VALUES ('2112', '450401', '市辖区', '450400');
INSERT INTO `jay_area` VALUES ('2113', '450403', '万秀区', '450400');
INSERT INTO `jay_area` VALUES ('2114', '450404', '蝶山区', '450400');
INSERT INTO `jay_area` VALUES ('2115', '450405', '长洲区', '450400');
INSERT INTO `jay_area` VALUES ('2116', '450421', '苍梧县', '450400');
INSERT INTO `jay_area` VALUES ('2117', '450422', '藤　县', '450400');
INSERT INTO `jay_area` VALUES ('2118', '450423', '蒙山县', '450400');
INSERT INTO `jay_area` VALUES ('2119', '450481', '岑溪市', '450400');
INSERT INTO `jay_area` VALUES ('2120', '450501', '市辖区', '450500');
INSERT INTO `jay_area` VALUES ('2121', '450502', '海城区', '450500');
INSERT INTO `jay_area` VALUES ('2122', '450503', '银海区', '450500');
INSERT INTO `jay_area` VALUES ('2123', '450512', '铁山港区', '450500');
INSERT INTO `jay_area` VALUES ('2124', '450521', '合浦县', '450500');
INSERT INTO `jay_area` VALUES ('2125', '450601', '市辖区', '450600');
INSERT INTO `jay_area` VALUES ('2126', '450602', '港口区', '450600');
INSERT INTO `jay_area` VALUES ('2127', '450603', '防城区', '450600');
INSERT INTO `jay_area` VALUES ('2128', '450621', '上思县', '450600');
INSERT INTO `jay_area` VALUES ('2129', '450681', '东兴市', '450600');
INSERT INTO `jay_area` VALUES ('2130', '450701', '市辖区', '450700');
INSERT INTO `jay_area` VALUES ('2131', '450702', '钦南区', '450700');
INSERT INTO `jay_area` VALUES ('2132', '450703', '钦北区', '450700');
INSERT INTO `jay_area` VALUES ('2133', '450721', '灵山县', '450700');
INSERT INTO `jay_area` VALUES ('2134', '450722', '浦北县', '450700');
INSERT INTO `jay_area` VALUES ('2135', '450801', '市辖区', '450800');
INSERT INTO `jay_area` VALUES ('2136', '450802', '港北区', '450800');
INSERT INTO `jay_area` VALUES ('2137', '450803', '港南区', '450800');
INSERT INTO `jay_area` VALUES ('2138', '450804', '覃塘区', '450800');
INSERT INTO `jay_area` VALUES ('2139', '450821', '平南县', '450800');
INSERT INTO `jay_area` VALUES ('2140', '450881', '桂平市', '450800');
INSERT INTO `jay_area` VALUES ('2141', '450901', '市辖区', '450900');
INSERT INTO `jay_area` VALUES ('2142', '450902', '玉州区', '450900');
INSERT INTO `jay_area` VALUES ('2143', '450921', '容　县', '450900');
INSERT INTO `jay_area` VALUES ('2144', '450922', '陆川县', '450900');
INSERT INTO `jay_area` VALUES ('2145', '450923', '博白县', '450900');
INSERT INTO `jay_area` VALUES ('2146', '450924', '兴业县', '450900');
INSERT INTO `jay_area` VALUES ('2147', '450981', '北流市', '450900');
INSERT INTO `jay_area` VALUES ('2148', '451001', '市辖区', '451000');
INSERT INTO `jay_area` VALUES ('2149', '451002', '右江区', '451000');
INSERT INTO `jay_area` VALUES ('2150', '451021', '田阳县', '451000');
INSERT INTO `jay_area` VALUES ('2151', '451022', '田东县', '451000');
INSERT INTO `jay_area` VALUES ('2152', '451023', '平果县', '451000');
INSERT INTO `jay_area` VALUES ('2153', '451024', '德保县', '451000');
INSERT INTO `jay_area` VALUES ('2154', '451025', '靖西县', '451000');
INSERT INTO `jay_area` VALUES ('2155', '451026', '那坡县', '451000');
INSERT INTO `jay_area` VALUES ('2156', '451027', '凌云县', '451000');
INSERT INTO `jay_area` VALUES ('2157', '451028', '乐业县', '451000');
INSERT INTO `jay_area` VALUES ('2158', '451029', '田林县', '451000');
INSERT INTO `jay_area` VALUES ('2159', '451030', '西林县', '451000');
INSERT INTO `jay_area` VALUES ('2160', '451031', '隆林各族自治县', '451000');
INSERT INTO `jay_area` VALUES ('2161', '451101', '市辖区', '451100');
INSERT INTO `jay_area` VALUES ('2162', '451102', '八步区', '451100');
INSERT INTO `jay_area` VALUES ('2163', '451121', '昭平县', '451100');
INSERT INTO `jay_area` VALUES ('2164', '451122', '钟山县', '451100');
INSERT INTO `jay_area` VALUES ('2165', '451123', '富川瑶族自治县', '451100');
INSERT INTO `jay_area` VALUES ('2166', '451201', '市辖区', '451200');
INSERT INTO `jay_area` VALUES ('2167', '451202', '金城江区', '451200');
INSERT INTO `jay_area` VALUES ('2168', '451221', '南丹县', '451200');
INSERT INTO `jay_area` VALUES ('2169', '451222', '天峨县', '451200');
INSERT INTO `jay_area` VALUES ('2170', '451223', '凤山县', '451200');
INSERT INTO `jay_area` VALUES ('2171', '451224', '东兰县', '451200');
INSERT INTO `jay_area` VALUES ('2172', '451225', '罗城仫佬族自治县', '451200');
INSERT INTO `jay_area` VALUES ('2173', '451226', '环江毛南族自治县', '451200');
INSERT INTO `jay_area` VALUES ('2174', '451227', '巴马瑶族自治县', '451200');
INSERT INTO `jay_area` VALUES ('2175', '451228', '都安瑶族自治县', '451200');
INSERT INTO `jay_area` VALUES ('2176', '451229', '大化瑶族自治县', '451200');
INSERT INTO `jay_area` VALUES ('2177', '451281', '宜州市', '451200');
INSERT INTO `jay_area` VALUES ('2178', '451301', '市辖区', '451300');
INSERT INTO `jay_area` VALUES ('2179', '451302', '兴宾区', '451300');
INSERT INTO `jay_area` VALUES ('2180', '451321', '忻城县', '451300');
INSERT INTO `jay_area` VALUES ('2181', '451322', '象州县', '451300');
INSERT INTO `jay_area` VALUES ('2182', '451323', '武宣县', '451300');
INSERT INTO `jay_area` VALUES ('2183', '451324', '金秀瑶族自治县', '451300');
INSERT INTO `jay_area` VALUES ('2184', '451381', '合山市', '451300');
INSERT INTO `jay_area` VALUES ('2185', '451401', '市辖区', '451400');
INSERT INTO `jay_area` VALUES ('2186', '451402', '江洲区', '451400');
INSERT INTO `jay_area` VALUES ('2187', '451421', '扶绥县', '451400');
INSERT INTO `jay_area` VALUES ('2188', '451422', '宁明县', '451400');
INSERT INTO `jay_area` VALUES ('2189', '451423', '龙州县', '451400');
INSERT INTO `jay_area` VALUES ('2190', '451424', '大新县', '451400');
INSERT INTO `jay_area` VALUES ('2191', '451425', '天等县', '451400');
INSERT INTO `jay_area` VALUES ('2192', '451481', '凭祥市', '451400');
INSERT INTO `jay_area` VALUES ('2193', '460101', '市辖区', '460100');
INSERT INTO `jay_area` VALUES ('2194', '460105', '秀英区', '460100');
INSERT INTO `jay_area` VALUES ('2195', '460106', '龙华区', '460100');
INSERT INTO `jay_area` VALUES ('2196', '460107', '琼山区', '460100');
INSERT INTO `jay_area` VALUES ('2197', '460108', '美兰区', '460100');
INSERT INTO `jay_area` VALUES ('2198', '460201', '市辖区', '460200');
INSERT INTO `jay_area` VALUES ('2199', '469001', '五指山市', '469000');
INSERT INTO `jay_area` VALUES ('2200', '469002', '琼海市', '469000');
INSERT INTO `jay_area` VALUES ('2201', '469003', '儋州市', '469000');
INSERT INTO `jay_area` VALUES ('2202', '469005', '文昌市', '469000');
INSERT INTO `jay_area` VALUES ('2203', '469006', '万宁市', '469000');
INSERT INTO `jay_area` VALUES ('2204', '469007', '东方市', '469000');
INSERT INTO `jay_area` VALUES ('2205', '469025', '定安县', '469000');
INSERT INTO `jay_area` VALUES ('2206', '469026', '屯昌县', '469000');
INSERT INTO `jay_area` VALUES ('2207', '469027', '澄迈县', '469000');
INSERT INTO `jay_area` VALUES ('2208', '469028', '临高县', '469000');
INSERT INTO `jay_area` VALUES ('2209', '469030', '白沙黎族自治县', '469000');
INSERT INTO `jay_area` VALUES ('2210', '469031', '昌江黎族自治县', '469000');
INSERT INTO `jay_area` VALUES ('2211', '469033', '乐东黎族自治县', '469000');
INSERT INTO `jay_area` VALUES ('2212', '469034', '陵水黎族自治县', '469000');
INSERT INTO `jay_area` VALUES ('2213', '469035', '保亭黎族苗族自治县', '469000');
INSERT INTO `jay_area` VALUES ('2214', '469036', '琼中黎族苗族自治县', '469000');
INSERT INTO `jay_area` VALUES ('2215', '469037', '西沙群岛', '469000');
INSERT INTO `jay_area` VALUES ('2216', '469038', '南沙群岛', '469000');
INSERT INTO `jay_area` VALUES ('2217', '469039', '中沙群岛的岛礁及其海域', '469000');
INSERT INTO `jay_area` VALUES ('2218', '500101', '万州区', '500100');
INSERT INTO `jay_area` VALUES ('2219', '500102', '涪陵区', '500100');
INSERT INTO `jay_area` VALUES ('2220', '500103', '渝中区', '500100');
INSERT INTO `jay_area` VALUES ('2221', '500104', '大渡口区', '500100');
INSERT INTO `jay_area` VALUES ('2222', '500105', '江北区', '500100');
INSERT INTO `jay_area` VALUES ('2223', '500106', '沙坪坝区', '500100');
INSERT INTO `jay_area` VALUES ('2224', '500107', '九龙坡区', '500100');
INSERT INTO `jay_area` VALUES ('2225', '500108', '南岸区', '500100');
INSERT INTO `jay_area` VALUES ('2226', '500109', '北碚区', '500100');
INSERT INTO `jay_area` VALUES ('2227', '500110', '万盛区', '500100');
INSERT INTO `jay_area` VALUES ('2228', '500111', '双桥区', '500100');
INSERT INTO `jay_area` VALUES ('2229', '500112', '渝北区', '500100');
INSERT INTO `jay_area` VALUES ('2230', '500113', '巴南区', '500100');
INSERT INTO `jay_area` VALUES ('2231', '500114', '黔江区', '500100');
INSERT INTO `jay_area` VALUES ('2232', '500115', '长寿区', '500100');
INSERT INTO `jay_area` VALUES ('2233', '500222', '綦江县', '500200');
INSERT INTO `jay_area` VALUES ('2234', '500223', '潼南县', '500200');
INSERT INTO `jay_area` VALUES ('2235', '500224', '铜梁县', '500200');
INSERT INTO `jay_area` VALUES ('2236', '500225', '大足县', '500200');
INSERT INTO `jay_area` VALUES ('2237', '500226', '荣昌县', '500200');
INSERT INTO `jay_area` VALUES ('2238', '500227', '璧山县', '500200');
INSERT INTO `jay_area` VALUES ('2239', '500228', '梁平县', '500200');
INSERT INTO `jay_area` VALUES ('2240', '500229', '城口县', '500200');
INSERT INTO `jay_area` VALUES ('2241', '500230', '丰都县', '500200');
INSERT INTO `jay_area` VALUES ('2242', '500231', '垫江县', '500200');
INSERT INTO `jay_area` VALUES ('2243', '500232', '武隆县', '500200');
INSERT INTO `jay_area` VALUES ('2244', '500233', '忠　县', '500200');
INSERT INTO `jay_area` VALUES ('2245', '500234', '开　县', '500200');
INSERT INTO `jay_area` VALUES ('2246', '500235', '云阳县', '500200');
INSERT INTO `jay_area` VALUES ('2247', '500236', '奉节县', '500200');
INSERT INTO `jay_area` VALUES ('2248', '500237', '巫山县', '500200');
INSERT INTO `jay_area` VALUES ('2249', '500238', '巫溪县', '500200');
INSERT INTO `jay_area` VALUES ('2250', '500240', '石柱土家族自治县', '500200');
INSERT INTO `jay_area` VALUES ('2251', '500241', '秀山土家族苗族自治县', '500200');
INSERT INTO `jay_area` VALUES ('2252', '500242', '酉阳土家族苗族自治县', '500200');
INSERT INTO `jay_area` VALUES ('2253', '500243', '彭水苗族土家族自治县', '500200');
INSERT INTO `jay_area` VALUES ('2254', '500381', '江津市', '500300');
INSERT INTO `jay_area` VALUES ('2255', '500382', '合川市', '500300');
INSERT INTO `jay_area` VALUES ('2256', '500383', '永川市', '500300');
INSERT INTO `jay_area` VALUES ('2257', '500384', '南川市', '500300');
INSERT INTO `jay_area` VALUES ('2258', '510101', '市辖区', '510100');
INSERT INTO `jay_area` VALUES ('2259', '510104', '锦江区', '510100');
INSERT INTO `jay_area` VALUES ('2260', '510105', '青羊区', '510100');
INSERT INTO `jay_area` VALUES ('2261', '510106', '金牛区', '510100');
INSERT INTO `jay_area` VALUES ('2262', '510107', '武侯区', '510100');
INSERT INTO `jay_area` VALUES ('2263', '510108', '成华区', '510100');
INSERT INTO `jay_area` VALUES ('2264', '510112', '龙泉驿区', '510100');
INSERT INTO `jay_area` VALUES ('2265', '510113', '青白江区', '510100');
INSERT INTO `jay_area` VALUES ('2266', '510114', '新都区', '510100');
INSERT INTO `jay_area` VALUES ('2267', '510115', '温江区', '510100');
INSERT INTO `jay_area` VALUES ('2268', '510121', '金堂县', '510100');
INSERT INTO `jay_area` VALUES ('2269', '510122', '双流区', '510100');
INSERT INTO `jay_area` VALUES ('2270', '510124', '郫都区', '510100');
INSERT INTO `jay_area` VALUES ('2271', '510129', '大邑县', '510100');
INSERT INTO `jay_area` VALUES ('2272', '510131', '蒲江县', '510100');
INSERT INTO `jay_area` VALUES ('2273', '510132', '新津县', '510100');
INSERT INTO `jay_area` VALUES ('2274', '510181', '都江堰市', '510100');
INSERT INTO `jay_area` VALUES ('2275', '510182', '彭州市', '510100');
INSERT INTO `jay_area` VALUES ('2276', '510183', '邛崃市', '510100');
INSERT INTO `jay_area` VALUES ('2277', '510184', '崇州市', '510100');
INSERT INTO `jay_area` VALUES ('2278', '510301', '市辖区', '510300');
INSERT INTO `jay_area` VALUES ('2279', '510302', '自流井区', '510300');
INSERT INTO `jay_area` VALUES ('2280', '510303', '贡井区', '510300');
INSERT INTO `jay_area` VALUES ('2281', '510304', '大安区', '510300');
INSERT INTO `jay_area` VALUES ('2282', '510311', '沿滩区', '510300');
INSERT INTO `jay_area` VALUES ('2283', '510321', '荣　县', '510300');
INSERT INTO `jay_area` VALUES ('2284', '510322', '富顺县', '510300');
INSERT INTO `jay_area` VALUES ('2285', '510401', '市辖区', '510400');
INSERT INTO `jay_area` VALUES ('2286', '510402', '东　区', '510400');
INSERT INTO `jay_area` VALUES ('2287', '510403', '西　区', '510400');
INSERT INTO `jay_area` VALUES ('2288', '510411', '仁和区', '510400');
INSERT INTO `jay_area` VALUES ('2289', '510421', '米易县', '510400');
INSERT INTO `jay_area` VALUES ('2290', '510422', '盐边县', '510400');
INSERT INTO `jay_area` VALUES ('2291', '510501', '市辖区', '510500');
INSERT INTO `jay_area` VALUES ('2292', '510502', '江阳区', '510500');
INSERT INTO `jay_area` VALUES ('2293', '510503', '纳溪区', '510500');
INSERT INTO `jay_area` VALUES ('2294', '510504', '龙马潭区', '510500');
INSERT INTO `jay_area` VALUES ('2295', '510521', '泸　县', '510500');
INSERT INTO `jay_area` VALUES ('2296', '510522', '合江县', '510500');
INSERT INTO `jay_area` VALUES ('2297', '510524', '叙永县', '510500');
INSERT INTO `jay_area` VALUES ('2298', '510525', '古蔺县', '510500');
INSERT INTO `jay_area` VALUES ('2299', '510601', '市辖区', '510600');
INSERT INTO `jay_area` VALUES ('2300', '510603', '旌阳区', '510600');
INSERT INTO `jay_area` VALUES ('2301', '510623', '中江县', '510600');
INSERT INTO `jay_area` VALUES ('2302', '510626', '罗江县', '510600');
INSERT INTO `jay_area` VALUES ('2303', '510681', '广汉市', '510600');
INSERT INTO `jay_area` VALUES ('2304', '510682', '什邡市', '510600');
INSERT INTO `jay_area` VALUES ('2305', '510683', '绵竹市', '510600');
INSERT INTO `jay_area` VALUES ('2306', '510701', '市辖区', '510700');
INSERT INTO `jay_area` VALUES ('2307', '510703', '涪城区', '510700');
INSERT INTO `jay_area` VALUES ('2308', '510704', '游仙区', '510700');
INSERT INTO `jay_area` VALUES ('2309', '510722', '三台县', '510700');
INSERT INTO `jay_area` VALUES ('2310', '510723', '盐亭县', '510700');
INSERT INTO `jay_area` VALUES ('2311', '510724', '安　县', '510700');
INSERT INTO `jay_area` VALUES ('2312', '510725', '梓潼县', '510700');
INSERT INTO `jay_area` VALUES ('2313', '510726', '北川羌族自治县', '510700');
INSERT INTO `jay_area` VALUES ('2314', '510727', '平武县', '510700');
INSERT INTO `jay_area` VALUES ('2315', '510781', '江油市', '510700');
INSERT INTO `jay_area` VALUES ('2316', '510801', '市辖区', '510800');
INSERT INTO `jay_area` VALUES ('2317', '510802', '市中区', '510800');
INSERT INTO `jay_area` VALUES ('2318', '510811', '元坝区', '510800');
INSERT INTO `jay_area` VALUES ('2319', '510812', '朝天区', '510800');
INSERT INTO `jay_area` VALUES ('2320', '510821', '旺苍县', '510800');
INSERT INTO `jay_area` VALUES ('2321', '510822', '青川县', '510800');
INSERT INTO `jay_area` VALUES ('2322', '510823', '剑阁县', '510800');
INSERT INTO `jay_area` VALUES ('2323', '510824', '苍溪县', '510800');
INSERT INTO `jay_area` VALUES ('2324', '510901', '市辖区', '510900');
INSERT INTO `jay_area` VALUES ('2325', '510903', '船山区', '510900');
INSERT INTO `jay_area` VALUES ('2326', '510904', '安居区', '510900');
INSERT INTO `jay_area` VALUES ('2327', '510921', '蓬溪县', '510900');
INSERT INTO `jay_area` VALUES ('2328', '510922', '射洪县', '510900');
INSERT INTO `jay_area` VALUES ('2329', '510923', '大英县', '510900');
INSERT INTO `jay_area` VALUES ('2330', '511001', '市辖区', '511000');
INSERT INTO `jay_area` VALUES ('2331', '511002', '市中区', '511000');
INSERT INTO `jay_area` VALUES ('2332', '511011', '东兴区', '511000');
INSERT INTO `jay_area` VALUES ('2333', '511024', '威远县', '511000');
INSERT INTO `jay_area` VALUES ('2334', '511025', '资中县', '511000');
INSERT INTO `jay_area` VALUES ('2335', '511028', '隆昌县', '511000');
INSERT INTO `jay_area` VALUES ('2336', '511101', '市辖区', '511100');
INSERT INTO `jay_area` VALUES ('2337', '511102', '市中区', '511100');
INSERT INTO `jay_area` VALUES ('2338', '511111', '沙湾区', '511100');
INSERT INTO `jay_area` VALUES ('2339', '511112', '五通桥区', '511100');
INSERT INTO `jay_area` VALUES ('2340', '511113', '金口河区', '511100');
INSERT INTO `jay_area` VALUES ('2341', '511123', '犍为县', '511100');
INSERT INTO `jay_area` VALUES ('2342', '511124', '井研县', '511100');
INSERT INTO `jay_area` VALUES ('2343', '511126', '夹江县', '511100');
INSERT INTO `jay_area` VALUES ('2344', '511129', '沐川县', '511100');
INSERT INTO `jay_area` VALUES ('2345', '511132', '峨边彝族自治县', '511100');
INSERT INTO `jay_area` VALUES ('2346', '511133', '马边彝族自治县', '511100');
INSERT INTO `jay_area` VALUES ('2347', '511181', '峨眉山市', '511100');
INSERT INTO `jay_area` VALUES ('2348', '511301', '市辖区', '511300');
INSERT INTO `jay_area` VALUES ('2349', '511302', '顺庆区', '511300');
INSERT INTO `jay_area` VALUES ('2350', '511303', '高坪区', '511300');
INSERT INTO `jay_area` VALUES ('2351', '511304', '嘉陵区', '511300');
INSERT INTO `jay_area` VALUES ('2352', '511321', '南部县', '511300');
INSERT INTO `jay_area` VALUES ('2353', '511322', '营山县', '511300');
INSERT INTO `jay_area` VALUES ('2354', '511323', '蓬安县', '511300');
INSERT INTO `jay_area` VALUES ('2355', '511324', '仪陇县', '511300');
INSERT INTO `jay_area` VALUES ('2356', '511325', '西充县', '511300');
INSERT INTO `jay_area` VALUES ('2357', '511381', '阆中市', '511300');
INSERT INTO `jay_area` VALUES ('2358', '511401', '市辖区', '511400');
INSERT INTO `jay_area` VALUES ('2359', '511402', '东坡区', '511400');
INSERT INTO `jay_area` VALUES ('2360', '511421', '仁寿县', '511400');
INSERT INTO `jay_area` VALUES ('2361', '511422', '彭山县', '511400');
INSERT INTO `jay_area` VALUES ('2362', '511423', '洪雅县', '511400');
INSERT INTO `jay_area` VALUES ('2363', '511424', '丹棱县', '511400');
INSERT INTO `jay_area` VALUES ('2364', '511425', '青神县', '511400');
INSERT INTO `jay_area` VALUES ('2365', '511501', '市辖区', '511500');
INSERT INTO `jay_area` VALUES ('2366', '511502', '翠屏区', '511500');
INSERT INTO `jay_area` VALUES ('2367', '511521', '宜宾县', '511500');
INSERT INTO `jay_area` VALUES ('2368', '511522', '南溪县', '511500');
INSERT INTO `jay_area` VALUES ('2369', '511523', '江安县', '511500');
INSERT INTO `jay_area` VALUES ('2370', '511524', '长宁县', '511500');
INSERT INTO `jay_area` VALUES ('2371', '511525', '高　县', '511500');
INSERT INTO `jay_area` VALUES ('2372', '511526', '珙　县', '511500');
INSERT INTO `jay_area` VALUES ('2373', '511527', '筠连县', '511500');
INSERT INTO `jay_area` VALUES ('2374', '511528', '兴文县', '511500');
INSERT INTO `jay_area` VALUES ('2375', '511529', '屏山县', '511500');
INSERT INTO `jay_area` VALUES ('2376', '511601', '市辖区', '511600');
INSERT INTO `jay_area` VALUES ('2377', '511602', '广安区', '511600');
INSERT INTO `jay_area` VALUES ('2378', '511621', '岳池县', '511600');
INSERT INTO `jay_area` VALUES ('2379', '511622', '武胜县', '511600');
INSERT INTO `jay_area` VALUES ('2380', '511623', '邻水县', '511600');
INSERT INTO `jay_area` VALUES ('2381', '511681', '华莹市', '511600');
INSERT INTO `jay_area` VALUES ('2382', '511701', '市辖区', '511700');
INSERT INTO `jay_area` VALUES ('2383', '511702', '通川区', '511700');
INSERT INTO `jay_area` VALUES ('2384', '511721', '达　县', '511700');
INSERT INTO `jay_area` VALUES ('2385', '511722', '宣汉县', '511700');
INSERT INTO `jay_area` VALUES ('2386', '511723', '开江县', '511700');
INSERT INTO `jay_area` VALUES ('2387', '511724', '大竹县', '511700');
INSERT INTO `jay_area` VALUES ('2388', '511725', '渠　县', '511700');
INSERT INTO `jay_area` VALUES ('2389', '511781', '万源市', '511700');
INSERT INTO `jay_area` VALUES ('2390', '511801', '市辖区', '511800');
INSERT INTO `jay_area` VALUES ('2391', '511802', '雨城区', '511800');
INSERT INTO `jay_area` VALUES ('2392', '511821', '名山县', '511800');
INSERT INTO `jay_area` VALUES ('2393', '511822', '荥经县', '511800');
INSERT INTO `jay_area` VALUES ('2394', '511823', '汉源县', '511800');
INSERT INTO `jay_area` VALUES ('2395', '511824', '石棉县', '511800');
INSERT INTO `jay_area` VALUES ('2396', '511825', '天全县', '511800');
INSERT INTO `jay_area` VALUES ('2397', '511826', '芦山县', '511800');
INSERT INTO `jay_area` VALUES ('2398', '511827', '宝兴县', '511800');
INSERT INTO `jay_area` VALUES ('2399', '511901', '市辖区', '511900');
INSERT INTO `jay_area` VALUES ('2400', '511902', '巴州区', '511900');
INSERT INTO `jay_area` VALUES ('2401', '511921', '通江县', '511900');
INSERT INTO `jay_area` VALUES ('2402', '511922', '南江县', '511900');
INSERT INTO `jay_area` VALUES ('2403', '511923', '平昌县', '511900');
INSERT INTO `jay_area` VALUES ('2404', '512001', '市辖区', '512000');
INSERT INTO `jay_area` VALUES ('2405', '512002', '雁江区', '512000');
INSERT INTO `jay_area` VALUES ('2406', '512021', '安岳县', '512000');
INSERT INTO `jay_area` VALUES ('2407', '512022', '乐至县', '512000');
INSERT INTO `jay_area` VALUES ('2408', '512081', '简阳市', '512000');
INSERT INTO `jay_area` VALUES ('2409', '513221', '汶川县', '513200');
INSERT INTO `jay_area` VALUES ('2410', '513222', '理　县', '513200');
INSERT INTO `jay_area` VALUES ('2411', '513223', '茂　县', '513200');
INSERT INTO `jay_area` VALUES ('2412', '513224', '松潘县', '513200');
INSERT INTO `jay_area` VALUES ('2413', '513225', '九寨沟县', '513200');
INSERT INTO `jay_area` VALUES ('2414', '513226', '金川县', '513200');
INSERT INTO `jay_area` VALUES ('2415', '513227', '小金县', '513200');
INSERT INTO `jay_area` VALUES ('2416', '513228', '黑水县', '513200');
INSERT INTO `jay_area` VALUES ('2417', '513229', '马尔康县', '513200');
INSERT INTO `jay_area` VALUES ('2418', '513230', '壤塘县', '513200');
INSERT INTO `jay_area` VALUES ('2419', '513231', '阿坝县', '513200');
INSERT INTO `jay_area` VALUES ('2420', '513232', '若尔盖县', '513200');
INSERT INTO `jay_area` VALUES ('2421', '513233', '红原县', '513200');
INSERT INTO `jay_area` VALUES ('2422', '513321', '康定县', '513300');
INSERT INTO `jay_area` VALUES ('2423', '513322', '泸定县', '513300');
INSERT INTO `jay_area` VALUES ('2424', '513323', '丹巴县', '513300');
INSERT INTO `jay_area` VALUES ('2425', '513324', '九龙县', '513300');
INSERT INTO `jay_area` VALUES ('2426', '513325', '雅江县', '513300');
INSERT INTO `jay_area` VALUES ('2427', '513326', '道孚县', '513300');
INSERT INTO `jay_area` VALUES ('2428', '513327', '炉霍县', '513300');
INSERT INTO `jay_area` VALUES ('2429', '513328', '甘孜县', '513300');
INSERT INTO `jay_area` VALUES ('2430', '513329', '新龙县', '513300');
INSERT INTO `jay_area` VALUES ('2431', '513330', '德格县', '513300');
INSERT INTO `jay_area` VALUES ('2432', '513331', '白玉县', '513300');
INSERT INTO `jay_area` VALUES ('2433', '513332', '石渠县', '513300');
INSERT INTO `jay_area` VALUES ('2434', '513333', '色达县', '513300');
INSERT INTO `jay_area` VALUES ('2435', '513334', '理塘县', '513300');
INSERT INTO `jay_area` VALUES ('2436', '513335', '巴塘县', '513300');
INSERT INTO `jay_area` VALUES ('2437', '513336', '乡城县', '513300');
INSERT INTO `jay_area` VALUES ('2438', '513337', '稻城县', '513300');
INSERT INTO `jay_area` VALUES ('2439', '513338', '得荣县', '513300');
INSERT INTO `jay_area` VALUES ('2440', '513401', '西昌市', '513400');
INSERT INTO `jay_area` VALUES ('2441', '513422', '木里藏族自治县', '513400');
INSERT INTO `jay_area` VALUES ('2442', '513423', '盐源县', '513400');
INSERT INTO `jay_area` VALUES ('2443', '513424', '德昌县', '513400');
INSERT INTO `jay_area` VALUES ('2444', '513425', '会理县', '513400');
INSERT INTO `jay_area` VALUES ('2445', '513426', '会东县', '513400');
INSERT INTO `jay_area` VALUES ('2446', '513427', '宁南县', '513400');
INSERT INTO `jay_area` VALUES ('2447', '513428', '普格县', '513400');
INSERT INTO `jay_area` VALUES ('2448', '513429', '布拖县', '513400');
INSERT INTO `jay_area` VALUES ('2449', '513430', '金阳县', '513400');
INSERT INTO `jay_area` VALUES ('2450', '513431', '昭觉县', '513400');
INSERT INTO `jay_area` VALUES ('2451', '513432', '喜德县', '513400');
INSERT INTO `jay_area` VALUES ('2452', '513433', '冕宁县', '513400');
INSERT INTO `jay_area` VALUES ('2453', '513434', '越西县', '513400');
INSERT INTO `jay_area` VALUES ('2454', '513435', '甘洛县', '513400');
INSERT INTO `jay_area` VALUES ('2455', '513436', '美姑县', '513400');
INSERT INTO `jay_area` VALUES ('2456', '513437', '雷波县', '513400');
INSERT INTO `jay_area` VALUES ('2457', '520101', '市辖区', '520100');
INSERT INTO `jay_area` VALUES ('2458', '520102', '南明区', '520100');
INSERT INTO `jay_area` VALUES ('2459', '520103', '云岩区', '520100');
INSERT INTO `jay_area` VALUES ('2460', '520111', '花溪区', '520100');
INSERT INTO `jay_area` VALUES ('2461', '520112', '乌当区', '520100');
INSERT INTO `jay_area` VALUES ('2462', '520113', '白云区', '520100');
INSERT INTO `jay_area` VALUES ('2463', '520114', '小河区', '520100');
INSERT INTO `jay_area` VALUES ('2464', '520121', '开阳县', '520100');
INSERT INTO `jay_area` VALUES ('2465', '520122', '息烽县', '520100');
INSERT INTO `jay_area` VALUES ('2466', '520123', '修文县', '520100');
INSERT INTO `jay_area` VALUES ('2467', '520181', '清镇市', '520100');
INSERT INTO `jay_area` VALUES ('2468', '520201', '钟山区', '520200');
INSERT INTO `jay_area` VALUES ('2469', '520203', '六枝特区', '520200');
INSERT INTO `jay_area` VALUES ('2470', '520221', '水城县', '520200');
INSERT INTO `jay_area` VALUES ('2471', '520222', '盘　县', '520200');
INSERT INTO `jay_area` VALUES ('2472', '520301', '市辖区', '520300');
INSERT INTO `jay_area` VALUES ('2473', '520302', '红花岗区', '520300');
INSERT INTO `jay_area` VALUES ('2474', '520303', '汇川区', '520300');
INSERT INTO `jay_area` VALUES ('2475', '520321', '遵义县', '520300');
INSERT INTO `jay_area` VALUES ('2476', '520322', '桐梓县', '520300');
INSERT INTO `jay_area` VALUES ('2477', '520323', '绥阳县', '520300');
INSERT INTO `jay_area` VALUES ('2478', '520324', '正安县', '520300');
INSERT INTO `jay_area` VALUES ('2479', '520325', '道真仡佬族苗族自治县', '520300');
INSERT INTO `jay_area` VALUES ('2480', '520326', '务川仡佬族苗族自治县', '520300');
INSERT INTO `jay_area` VALUES ('2481', '520327', '凤冈县', '520300');
INSERT INTO `jay_area` VALUES ('2482', '520328', '湄潭县', '520300');
INSERT INTO `jay_area` VALUES ('2483', '520329', '余庆县', '520300');
INSERT INTO `jay_area` VALUES ('2484', '520330', '习水县', '520300');
INSERT INTO `jay_area` VALUES ('2485', '520381', '赤水市', '520300');
INSERT INTO `jay_area` VALUES ('2486', '520382', '仁怀市', '520300');
INSERT INTO `jay_area` VALUES ('2487', '520401', '市辖区', '520400');
INSERT INTO `jay_area` VALUES ('2488', '520402', '西秀区', '520400');
INSERT INTO `jay_area` VALUES ('2489', '520421', '平坝县', '520400');
INSERT INTO `jay_area` VALUES ('2490', '520422', '普定县', '520400');
INSERT INTO `jay_area` VALUES ('2491', '520423', '镇宁布依族苗族自治县', '520400');
INSERT INTO `jay_area` VALUES ('2492', '520424', '关岭布依族苗族自治县', '520400');
INSERT INTO `jay_area` VALUES ('2493', '520425', '紫云苗族布依族自治县', '520400');
INSERT INTO `jay_area` VALUES ('2494', '522201', '铜仁市', '522200');
INSERT INTO `jay_area` VALUES ('2495', '522222', '江口县', '522200');
INSERT INTO `jay_area` VALUES ('2496', '522223', '玉屏侗族自治县', '522200');
INSERT INTO `jay_area` VALUES ('2497', '522224', '石阡县', '522200');
INSERT INTO `jay_area` VALUES ('2498', '522225', '思南县', '522200');
INSERT INTO `jay_area` VALUES ('2499', '522226', '印江土家族苗族自治县', '522200');
INSERT INTO `jay_area` VALUES ('2500', '522227', '德江县', '522200');
INSERT INTO `jay_area` VALUES ('2501', '522228', '沿河土家族自治县', '522200');
INSERT INTO `jay_area` VALUES ('2502', '522229', '松桃苗族自治县', '522200');
INSERT INTO `jay_area` VALUES ('2503', '522230', '万山特区', '522200');
INSERT INTO `jay_area` VALUES ('2504', '522301', '兴义市', '522300');
INSERT INTO `jay_area` VALUES ('2505', '522322', '兴仁县', '522300');
INSERT INTO `jay_area` VALUES ('2506', '522323', '普安县', '522300');
INSERT INTO `jay_area` VALUES ('2507', '522324', '晴隆县', '522300');
INSERT INTO `jay_area` VALUES ('2508', '522325', '贞丰县', '522300');
INSERT INTO `jay_area` VALUES ('2509', '522326', '望谟县', '522300');
INSERT INTO `jay_area` VALUES ('2510', '522327', '册亨县', '522300');
INSERT INTO `jay_area` VALUES ('2511', '522328', '安龙县', '522300');
INSERT INTO `jay_area` VALUES ('2512', '522401', '毕节市', '522400');
INSERT INTO `jay_area` VALUES ('2513', '522422', '大方县', '522400');
INSERT INTO `jay_area` VALUES ('2514', '522423', '黔西县', '522400');
INSERT INTO `jay_area` VALUES ('2515', '522424', '金沙县', '522400');
INSERT INTO `jay_area` VALUES ('2516', '522425', '织金县', '522400');
INSERT INTO `jay_area` VALUES ('2517', '522426', '纳雍县', '522400');
INSERT INTO `jay_area` VALUES ('2518', '522427', '威宁彝族回族苗族自治县', '522400');
INSERT INTO `jay_area` VALUES ('2519', '522428', '赫章县', '522400');
INSERT INTO `jay_area` VALUES ('2520', '522601', '凯里市', '522600');
INSERT INTO `jay_area` VALUES ('2521', '522622', '黄平县', '522600');
INSERT INTO `jay_area` VALUES ('2522', '522623', '施秉县', '522600');
INSERT INTO `jay_area` VALUES ('2523', '522624', '三穗县', '522600');
INSERT INTO `jay_area` VALUES ('2524', '522625', '镇远县', '522600');
INSERT INTO `jay_area` VALUES ('2525', '522626', '岑巩县', '522600');
INSERT INTO `jay_area` VALUES ('2526', '522627', '天柱县', '522600');
INSERT INTO `jay_area` VALUES ('2527', '522628', '锦屏县', '522600');
INSERT INTO `jay_area` VALUES ('2528', '522629', '剑河县', '522600');
INSERT INTO `jay_area` VALUES ('2529', '522630', '台江县', '522600');
INSERT INTO `jay_area` VALUES ('2530', '522631', '黎平县', '522600');
INSERT INTO `jay_area` VALUES ('2531', '522632', '榕江县', '522600');
INSERT INTO `jay_area` VALUES ('2532', '522633', '从江县', '522600');
INSERT INTO `jay_area` VALUES ('2533', '522634', '雷山县', '522600');
INSERT INTO `jay_area` VALUES ('2534', '522635', '麻江县', '522600');
INSERT INTO `jay_area` VALUES ('2535', '522636', '丹寨县', '522600');
INSERT INTO `jay_area` VALUES ('2536', '522701', '都匀市', '522700');
INSERT INTO `jay_area` VALUES ('2537', '522702', '福泉市', '522700');
INSERT INTO `jay_area` VALUES ('2538', '522722', '荔波县', '522700');
INSERT INTO `jay_area` VALUES ('2539', '522723', '贵定县', '522700');
INSERT INTO `jay_area` VALUES ('2540', '522725', '瓮安县', '522700');
INSERT INTO `jay_area` VALUES ('2541', '522726', '独山县', '522700');
INSERT INTO `jay_area` VALUES ('2542', '522727', '平塘县', '522700');
INSERT INTO `jay_area` VALUES ('2543', '522728', '罗甸县', '522700');
INSERT INTO `jay_area` VALUES ('2544', '522729', '长顺县', '522700');
INSERT INTO `jay_area` VALUES ('2545', '522730', '龙里县', '522700');
INSERT INTO `jay_area` VALUES ('2546', '522731', '惠水县', '522700');
INSERT INTO `jay_area` VALUES ('2547', '522732', '三都水族自治县', '522700');
INSERT INTO `jay_area` VALUES ('2548', '530101', '市辖区', '530100');
INSERT INTO `jay_area` VALUES ('2549', '530102', '五华区', '530100');
INSERT INTO `jay_area` VALUES ('2550', '530103', '盘龙区', '530100');
INSERT INTO `jay_area` VALUES ('2551', '530111', '官渡区', '530100');
INSERT INTO `jay_area` VALUES ('2552', '530112', '西山区', '530100');
INSERT INTO `jay_area` VALUES ('2553', '530113', '东川区', '530100');
INSERT INTO `jay_area` VALUES ('2554', '530121', '呈贡县', '530100');
INSERT INTO `jay_area` VALUES ('2555', '530122', '晋宁县', '530100');
INSERT INTO `jay_area` VALUES ('2556', '530124', '富民县', '530100');
INSERT INTO `jay_area` VALUES ('2557', '530125', '宜良县', '530100');
INSERT INTO `jay_area` VALUES ('2558', '530126', '石林彝族自治县', '530100');
INSERT INTO `jay_area` VALUES ('2559', '530127', '嵩明县', '530100');
INSERT INTO `jay_area` VALUES ('2560', '530128', '禄劝彝族苗族自治县', '530100');
INSERT INTO `jay_area` VALUES ('2561', '530129', '寻甸回族彝族自治县', '530100');
INSERT INTO `jay_area` VALUES ('2562', '530181', '安宁市', '530100');
INSERT INTO `jay_area` VALUES ('2563', '530301', '市辖区', '530300');
INSERT INTO `jay_area` VALUES ('2564', '530302', '麒麟区', '530300');
INSERT INTO `jay_area` VALUES ('2565', '530321', '马龙县', '530300');
INSERT INTO `jay_area` VALUES ('2566', '530322', '陆良县', '530300');
INSERT INTO `jay_area` VALUES ('2567', '530323', '师宗县', '530300');
INSERT INTO `jay_area` VALUES ('2568', '530324', '罗平县', '530300');
INSERT INTO `jay_area` VALUES ('2569', '530325', '富源县', '530300');
INSERT INTO `jay_area` VALUES ('2570', '530326', '会泽县', '530300');
INSERT INTO `jay_area` VALUES ('2571', '530328', '沾益县', '530300');
INSERT INTO `jay_area` VALUES ('2572', '530381', '宣威市', '530300');
INSERT INTO `jay_area` VALUES ('2573', '530401', '市辖区', '530400');
INSERT INTO `jay_area` VALUES ('2574', '530402', '红塔区', '530400');
INSERT INTO `jay_area` VALUES ('2575', '530421', '江川县', '530400');
INSERT INTO `jay_area` VALUES ('2576', '530422', '澄江县', '530400');
INSERT INTO `jay_area` VALUES ('2577', '530423', '通海县', '530400');
INSERT INTO `jay_area` VALUES ('2578', '530424', '华宁县', '530400');
INSERT INTO `jay_area` VALUES ('2579', '530425', '易门县', '530400');
INSERT INTO `jay_area` VALUES ('2580', '530426', '峨山彝族自治县', '530400');
INSERT INTO `jay_area` VALUES ('2581', '530427', '新平彝族傣族自治县', '530400');
INSERT INTO `jay_area` VALUES ('2582', '530428', '元江哈尼族彝族傣族自治县', '530400');
INSERT INTO `jay_area` VALUES ('2583', '530501', '市辖区', '530500');
INSERT INTO `jay_area` VALUES ('2584', '530502', '隆阳区', '530500');
INSERT INTO `jay_area` VALUES ('2585', '530521', '施甸县', '530500');
INSERT INTO `jay_area` VALUES ('2586', '530522', '腾冲县', '530500');
INSERT INTO `jay_area` VALUES ('2587', '530523', '龙陵县', '530500');
INSERT INTO `jay_area` VALUES ('2588', '530524', '昌宁县', '530500');
INSERT INTO `jay_area` VALUES ('2589', '530601', '市辖区', '530600');
INSERT INTO `jay_area` VALUES ('2590', '530602', '昭阳区', '530600');
INSERT INTO `jay_area` VALUES ('2591', '530621', '鲁甸县', '530600');
INSERT INTO `jay_area` VALUES ('2592', '530622', '巧家县', '530600');
INSERT INTO `jay_area` VALUES ('2593', '530623', '盐津县', '530600');
INSERT INTO `jay_area` VALUES ('2594', '530624', '大关县', '530600');
INSERT INTO `jay_area` VALUES ('2595', '530625', '永善县', '530600');
INSERT INTO `jay_area` VALUES ('2596', '530626', '绥江县', '530600');
INSERT INTO `jay_area` VALUES ('2597', '530627', '镇雄县', '530600');
INSERT INTO `jay_area` VALUES ('2598', '530628', '彝良县', '530600');
INSERT INTO `jay_area` VALUES ('2599', '530629', '威信县', '530600');
INSERT INTO `jay_area` VALUES ('2600', '530630', '水富县', '530600');
INSERT INTO `jay_area` VALUES ('2601', '530701', '市辖区', '530700');
INSERT INTO `jay_area` VALUES ('2602', '530702', '古城区', '530700');
INSERT INTO `jay_area` VALUES ('2603', '530721', '玉龙纳西族自治县', '530700');
INSERT INTO `jay_area` VALUES ('2604', '530722', '永胜县', '530700');
INSERT INTO `jay_area` VALUES ('2605', '530723', '华坪县', '530700');
INSERT INTO `jay_area` VALUES ('2606', '530724', '宁蒗彝族自治县', '530700');
INSERT INTO `jay_area` VALUES ('2607', '530801', '市辖区', '530800');
INSERT INTO `jay_area` VALUES ('2608', '530802', '翠云区', '530800');
INSERT INTO `jay_area` VALUES ('2609', '530821', '普洱哈尼族彝族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2610', '530822', '墨江哈尼族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2611', '530823', '景东彝族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2612', '530824', '景谷傣族彝族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2613', '530825', '镇沅彝族哈尼族拉祜族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2614', '530826', '江城哈尼族彝族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2615', '530827', '孟连傣族拉祜族佤族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2616', '530828', '澜沧拉祜族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2617', '530829', '西盟佤族自治县', '530800');
INSERT INTO `jay_area` VALUES ('2618', '530901', '市辖区', '530900');
INSERT INTO `jay_area` VALUES ('2619', '530902', '临翔区', '530900');
INSERT INTO `jay_area` VALUES ('2620', '530921', '凤庆县', '530900');
INSERT INTO `jay_area` VALUES ('2621', '530922', '云　县', '530900');
INSERT INTO `jay_area` VALUES ('2622', '530923', '永德县', '530900');
INSERT INTO `jay_area` VALUES ('2623', '530924', '镇康县', '530900');
INSERT INTO `jay_area` VALUES ('2624', '530925', '双江拉祜族佤族布朗族傣族自治县', '530900');
INSERT INTO `jay_area` VALUES ('2625', '530926', '耿马傣族佤族自治县', '530900');
INSERT INTO `jay_area` VALUES ('2626', '530927', '沧源佤族自治县', '530900');
INSERT INTO `jay_area` VALUES ('2627', '532301', '楚雄市', '532300');
INSERT INTO `jay_area` VALUES ('2628', '532322', '双柏县', '532300');
INSERT INTO `jay_area` VALUES ('2629', '532323', '牟定县', '532300');
INSERT INTO `jay_area` VALUES ('2630', '532324', '南华县', '532300');
INSERT INTO `jay_area` VALUES ('2631', '532325', '姚安县', '532300');
INSERT INTO `jay_area` VALUES ('2632', '532326', '大姚县', '532300');
INSERT INTO `jay_area` VALUES ('2633', '532327', '永仁县', '532300');
INSERT INTO `jay_area` VALUES ('2634', '532328', '元谋县', '532300');
INSERT INTO `jay_area` VALUES ('2635', '532329', '武定县', '532300');
INSERT INTO `jay_area` VALUES ('2636', '532331', '禄丰县', '532300');
INSERT INTO `jay_area` VALUES ('2637', '532501', '个旧市', '532500');
INSERT INTO `jay_area` VALUES ('2638', '532502', '开远市', '532500');
INSERT INTO `jay_area` VALUES ('2639', '532522', '蒙自县', '532500');
INSERT INTO `jay_area` VALUES ('2640', '532523', '屏边苗族自治县', '532500');
INSERT INTO `jay_area` VALUES ('2641', '532524', '建水县', '532500');
INSERT INTO `jay_area` VALUES ('2642', '532525', '石屏县', '532500');
INSERT INTO `jay_area` VALUES ('2643', '532526', '弥勒县', '532500');
INSERT INTO `jay_area` VALUES ('2644', '532527', '泸西县', '532500');
INSERT INTO `jay_area` VALUES ('2645', '532528', '元阳县', '532500');
INSERT INTO `jay_area` VALUES ('2646', '532529', '红河县', '532500');
INSERT INTO `jay_area` VALUES ('2647', '532530', '金平苗族瑶族傣族自治县', '532500');
INSERT INTO `jay_area` VALUES ('2648', '532531', '绿春县', '532500');
INSERT INTO `jay_area` VALUES ('2649', '532532', '河口瑶族自治县', '532500');
INSERT INTO `jay_area` VALUES ('2650', '532621', '文山县', '532600');
INSERT INTO `jay_area` VALUES ('2651', '532622', '砚山县', '532600');
INSERT INTO `jay_area` VALUES ('2652', '532623', '西畴县', '532600');
INSERT INTO `jay_area` VALUES ('2653', '532624', '麻栗坡县', '532600');
INSERT INTO `jay_area` VALUES ('2654', '532625', '马关县', '532600');
INSERT INTO `jay_area` VALUES ('2655', '532626', '丘北县', '532600');
INSERT INTO `jay_area` VALUES ('2656', '532627', '广南县', '532600');
INSERT INTO `jay_area` VALUES ('2657', '532628', '富宁县', '532600');
INSERT INTO `jay_area` VALUES ('2658', '532801', '景洪市', '532800');
INSERT INTO `jay_area` VALUES ('2659', '532822', '勐海县', '532800');
INSERT INTO `jay_area` VALUES ('2660', '532823', '勐腊县', '532800');
INSERT INTO `jay_area` VALUES ('2661', '532901', '大理市', '532900');
INSERT INTO `jay_area` VALUES ('2662', '532922', '漾濞彝族自治县', '532900');
INSERT INTO `jay_area` VALUES ('2663', '532923', '祥云县', '532900');
INSERT INTO `jay_area` VALUES ('2664', '532924', '宾川县', '532900');
INSERT INTO `jay_area` VALUES ('2665', '532925', '弥渡县', '532900');
INSERT INTO `jay_area` VALUES ('2666', '532926', '南涧彝族自治县', '532900');
INSERT INTO `jay_area` VALUES ('2667', '532927', '巍山彝族回族自治县', '532900');
INSERT INTO `jay_area` VALUES ('2668', '532928', '永平县', '532900');
INSERT INTO `jay_area` VALUES ('2669', '532929', '云龙县', '532900');
INSERT INTO `jay_area` VALUES ('2670', '532930', '洱源县', '532900');
INSERT INTO `jay_area` VALUES ('2671', '532931', '剑川县', '532900');
INSERT INTO `jay_area` VALUES ('2672', '532932', '鹤庆县', '532900');
INSERT INTO `jay_area` VALUES ('2673', '533102', '瑞丽市', '533100');
INSERT INTO `jay_area` VALUES ('2674', '533103', '潞西市', '533100');
INSERT INTO `jay_area` VALUES ('2675', '533122', '梁河县', '533100');
INSERT INTO `jay_area` VALUES ('2676', '533123', '盈江县', '533100');
INSERT INTO `jay_area` VALUES ('2677', '533124', '陇川县', '533100');
INSERT INTO `jay_area` VALUES ('2678', '533321', '泸水县', '533300');
INSERT INTO `jay_area` VALUES ('2679', '533323', '福贡县', '533300');
INSERT INTO `jay_area` VALUES ('2680', '533324', '贡山独龙族怒族自治县', '533300');
INSERT INTO `jay_area` VALUES ('2681', '533325', '兰坪白族普米族自治县', '533300');
INSERT INTO `jay_area` VALUES ('2682', '533421', '香格里拉县', '533400');
INSERT INTO `jay_area` VALUES ('2683', '533422', '德钦县', '533400');
INSERT INTO `jay_area` VALUES ('2684', '533423', '维西傈僳族自治县', '533400');
INSERT INTO `jay_area` VALUES ('2685', '540101', '市辖区', '540100');
INSERT INTO `jay_area` VALUES ('2686', '540102', '城关区', '540100');
INSERT INTO `jay_area` VALUES ('2687', '540121', '林周县', '540100');
INSERT INTO `jay_area` VALUES ('2688', '540122', '当雄县', '540100');
INSERT INTO `jay_area` VALUES ('2689', '540123', '尼木县', '540100');
INSERT INTO `jay_area` VALUES ('2690', '540124', '曲水县', '540100');
INSERT INTO `jay_area` VALUES ('2691', '540125', '堆龙德庆县', '540100');
INSERT INTO `jay_area` VALUES ('2692', '540126', '达孜县', '540100');
INSERT INTO `jay_area` VALUES ('2693', '540127', '墨竹工卡县', '540100');
INSERT INTO `jay_area` VALUES ('2694', '542121', '昌都县', '542100');
INSERT INTO `jay_area` VALUES ('2695', '542122', '江达县', '542100');
INSERT INTO `jay_area` VALUES ('2696', '542123', '贡觉县', '542100');
INSERT INTO `jay_area` VALUES ('2697', '542124', '类乌齐县', '542100');
INSERT INTO `jay_area` VALUES ('2698', '542125', '丁青县', '542100');
INSERT INTO `jay_area` VALUES ('2699', '542126', '察雅县', '542100');
INSERT INTO `jay_area` VALUES ('2700', '542127', '八宿县', '542100');
INSERT INTO `jay_area` VALUES ('2701', '542128', '左贡县', '542100');
INSERT INTO `jay_area` VALUES ('2702', '542129', '芒康县', '542100');
INSERT INTO `jay_area` VALUES ('2703', '542132', '洛隆县', '542100');
INSERT INTO `jay_area` VALUES ('2704', '542133', '边坝县', '542100');
INSERT INTO `jay_area` VALUES ('2705', '542221', '乃东县', '542200');
INSERT INTO `jay_area` VALUES ('2706', '542222', '扎囊县', '542200');
INSERT INTO `jay_area` VALUES ('2707', '542223', '贡嘎县', '542200');
INSERT INTO `jay_area` VALUES ('2708', '542224', '桑日县', '542200');
INSERT INTO `jay_area` VALUES ('2709', '542225', '琼结县', '542200');
INSERT INTO `jay_area` VALUES ('2710', '542226', '曲松县', '542200');
INSERT INTO `jay_area` VALUES ('2711', '542227', '措美县', '542200');
INSERT INTO `jay_area` VALUES ('2712', '542228', '洛扎县', '542200');
INSERT INTO `jay_area` VALUES ('2713', '542229', '加查县', '542200');
INSERT INTO `jay_area` VALUES ('2714', '542231', '隆子县', '542200');
INSERT INTO `jay_area` VALUES ('2715', '542232', '错那县', '542200');
INSERT INTO `jay_area` VALUES ('2716', '542233', '浪卡子县', '542200');
INSERT INTO `jay_area` VALUES ('2717', '542301', '日喀则市', '542300');
INSERT INTO `jay_area` VALUES ('2718', '542322', '南木林县', '542300');
INSERT INTO `jay_area` VALUES ('2719', '542323', '江孜县', '542300');
INSERT INTO `jay_area` VALUES ('2720', '542324', '定日县', '542300');
INSERT INTO `jay_area` VALUES ('2721', '542325', '萨迦县', '542300');
INSERT INTO `jay_area` VALUES ('2722', '542326', '拉孜县', '542300');
INSERT INTO `jay_area` VALUES ('2723', '542327', '昂仁县', '542300');
INSERT INTO `jay_area` VALUES ('2724', '542328', '谢通门县', '542300');
INSERT INTO `jay_area` VALUES ('2725', '542329', '白朗县', '542300');
INSERT INTO `jay_area` VALUES ('2726', '542330', '仁布县', '542300');
INSERT INTO `jay_area` VALUES ('2727', '542331', '康马县', '542300');
INSERT INTO `jay_area` VALUES ('2728', '542332', '定结县', '542300');
INSERT INTO `jay_area` VALUES ('2729', '542333', '仲巴县', '542300');
INSERT INTO `jay_area` VALUES ('2730', '542334', '亚东县', '542300');
INSERT INTO `jay_area` VALUES ('2731', '542335', '吉隆县', '542300');
INSERT INTO `jay_area` VALUES ('2732', '542336', '聂拉木县', '542300');
INSERT INTO `jay_area` VALUES ('2733', '542337', '萨嘎县', '542300');
INSERT INTO `jay_area` VALUES ('2734', '542338', '岗巴县', '542300');
INSERT INTO `jay_area` VALUES ('2735', '542421', '那曲县', '542400');
INSERT INTO `jay_area` VALUES ('2736', '542422', '嘉黎县', '542400');
INSERT INTO `jay_area` VALUES ('2737', '542423', '比如县', '542400');
INSERT INTO `jay_area` VALUES ('2738', '542424', '聂荣县', '542400');
INSERT INTO `jay_area` VALUES ('2739', '542425', '安多县', '542400');
INSERT INTO `jay_area` VALUES ('2740', '542426', '申扎县', '542400');
INSERT INTO `jay_area` VALUES ('2741', '542427', '索　县', '542400');
INSERT INTO `jay_area` VALUES ('2742', '542428', '班戈县', '542400');
INSERT INTO `jay_area` VALUES ('2743', '542429', '巴青县', '542400');
INSERT INTO `jay_area` VALUES ('2744', '542430', '尼玛县', '542400');
INSERT INTO `jay_area` VALUES ('2745', '542521', '普兰县', '542500');
INSERT INTO `jay_area` VALUES ('2746', '542522', '札达县', '542500');
INSERT INTO `jay_area` VALUES ('2747', '542523', '噶尔县', '542500');
INSERT INTO `jay_area` VALUES ('2748', '542524', '日土县', '542500');
INSERT INTO `jay_area` VALUES ('2749', '542525', '革吉县', '542500');
INSERT INTO `jay_area` VALUES ('2750', '542526', '改则县', '542500');
INSERT INTO `jay_area` VALUES ('2751', '542527', '措勤县', '542500');
INSERT INTO `jay_area` VALUES ('2752', '542621', '林芝县', '542600');
INSERT INTO `jay_area` VALUES ('2753', '542622', '工布江达县', '542600');
INSERT INTO `jay_area` VALUES ('2754', '542623', '米林县', '542600');
INSERT INTO `jay_area` VALUES ('2755', '542624', '墨脱县', '542600');
INSERT INTO `jay_area` VALUES ('2756', '542625', '波密县', '542600');
INSERT INTO `jay_area` VALUES ('2757', '542626', '察隅县', '542600');
INSERT INTO `jay_area` VALUES ('2758', '542627', '朗　县', '542600');
INSERT INTO `jay_area` VALUES ('2759', '610101', '市辖区', '610100');
INSERT INTO `jay_area` VALUES ('2760', '610102', '新城区', '610100');
INSERT INTO `jay_area` VALUES ('2761', '610103', '碑林区', '610100');
INSERT INTO `jay_area` VALUES ('2762', '610104', '莲湖区', '610100');
INSERT INTO `jay_area` VALUES ('2763', '610111', '灞桥区', '610100');
INSERT INTO `jay_area` VALUES ('2764', '610112', '未央区', '610100');
INSERT INTO `jay_area` VALUES ('2765', '610113', '雁塔区', '610100');
INSERT INTO `jay_area` VALUES ('2766', '610114', '阎良区', '610100');
INSERT INTO `jay_area` VALUES ('2767', '610115', '临潼区', '610100');
INSERT INTO `jay_area` VALUES ('2768', '610116', '长安区', '610100');
INSERT INTO `jay_area` VALUES ('2769', '610122', '蓝田县', '610100');
INSERT INTO `jay_area` VALUES ('2770', '610124', '周至县', '610100');
INSERT INTO `jay_area` VALUES ('2771', '610125', '户　县', '610100');
INSERT INTO `jay_area` VALUES ('2772', '610126', '高陵县', '610100');
INSERT INTO `jay_area` VALUES ('2773', '610201', '市辖区', '610200');
INSERT INTO `jay_area` VALUES ('2774', '610202', '王益区', '610200');
INSERT INTO `jay_area` VALUES ('2775', '610203', '印台区', '610200');
INSERT INTO `jay_area` VALUES ('2776', '610204', '耀州区', '610200');
INSERT INTO `jay_area` VALUES ('2777', '610222', '宜君县', '610200');
INSERT INTO `jay_area` VALUES ('2778', '610301', '市辖区', '610300');
INSERT INTO `jay_area` VALUES ('2779', '610302', '渭滨区', '610300');
INSERT INTO `jay_area` VALUES ('2780', '610303', '金台区', '610300');
INSERT INTO `jay_area` VALUES ('2781', '610304', '陈仓区', '610300');
INSERT INTO `jay_area` VALUES ('2782', '610322', '凤翔县', '610300');
INSERT INTO `jay_area` VALUES ('2783', '610323', '岐山县', '610300');
INSERT INTO `jay_area` VALUES ('2784', '610324', '扶风县', '610300');
INSERT INTO `jay_area` VALUES ('2785', '610326', '眉　县', '610300');
INSERT INTO `jay_area` VALUES ('2786', '610327', '陇　县', '610300');
INSERT INTO `jay_area` VALUES ('2787', '610328', '千阳县', '610300');
INSERT INTO `jay_area` VALUES ('2788', '610329', '麟游县', '610300');
INSERT INTO `jay_area` VALUES ('2789', '610330', '凤　县', '610300');
INSERT INTO `jay_area` VALUES ('2790', '610331', '太白县', '610300');
INSERT INTO `jay_area` VALUES ('2791', '610401', '市辖区', '610400');
INSERT INTO `jay_area` VALUES ('2792', '610402', '秦都区', '610400');
INSERT INTO `jay_area` VALUES ('2793', '610403', '杨凌区', '610400');
INSERT INTO `jay_area` VALUES ('2794', '610404', '渭城区', '610400');
INSERT INTO `jay_area` VALUES ('2795', '610422', '三原县', '610400');
INSERT INTO `jay_area` VALUES ('2796', '610423', '泾阳县', '610400');
INSERT INTO `jay_area` VALUES ('2797', '610424', '乾　县', '610400');
INSERT INTO `jay_area` VALUES ('2798', '610425', '礼泉县', '610400');
INSERT INTO `jay_area` VALUES ('2799', '610426', '永寿县', '610400');
INSERT INTO `jay_area` VALUES ('2800', '610427', '彬　县', '610400');
INSERT INTO `jay_area` VALUES ('2801', '610428', '长武县', '610400');
INSERT INTO `jay_area` VALUES ('2802', '610429', '旬邑县', '610400');
INSERT INTO `jay_area` VALUES ('2803', '610430', '淳化县', '610400');
INSERT INTO `jay_area` VALUES ('2804', '610431', '武功县', '610400');
INSERT INTO `jay_area` VALUES ('2805', '610481', '兴平市', '610400');
INSERT INTO `jay_area` VALUES ('2806', '610501', '市辖区', '610500');
INSERT INTO `jay_area` VALUES ('2807', '610502', '临渭区', '610500');
INSERT INTO `jay_area` VALUES ('2808', '610521', '华　县', '610500');
INSERT INTO `jay_area` VALUES ('2809', '610522', '潼关县', '610500');
INSERT INTO `jay_area` VALUES ('2810', '610523', '大荔县', '610500');
INSERT INTO `jay_area` VALUES ('2811', '610524', '合阳县', '610500');
INSERT INTO `jay_area` VALUES ('2812', '610525', '澄城县', '610500');
INSERT INTO `jay_area` VALUES ('2813', '610526', '蒲城县', '610500');
INSERT INTO `jay_area` VALUES ('2814', '610527', '白水县', '610500');
INSERT INTO `jay_area` VALUES ('2815', '610528', '富平县', '610500');
INSERT INTO `jay_area` VALUES ('2816', '610581', '韩城市', '610500');
INSERT INTO `jay_area` VALUES ('2817', '610582', '华阴市', '610500');
INSERT INTO `jay_area` VALUES ('2818', '610601', '市辖区', '610600');
INSERT INTO `jay_area` VALUES ('2819', '610602', '宝塔区', '610600');
INSERT INTO `jay_area` VALUES ('2820', '610621', '延长县', '610600');
INSERT INTO `jay_area` VALUES ('2821', '610622', '延川县', '610600');
INSERT INTO `jay_area` VALUES ('2822', '610623', '子长县', '610600');
INSERT INTO `jay_area` VALUES ('2823', '610624', '安塞县', '610600');
INSERT INTO `jay_area` VALUES ('2824', '610625', '志丹县', '610600');
INSERT INTO `jay_area` VALUES ('2825', '610626', '吴旗县', '610600');
INSERT INTO `jay_area` VALUES ('2826', '610627', '甘泉县', '610600');
INSERT INTO `jay_area` VALUES ('2827', '610628', '富　县', '610600');
INSERT INTO `jay_area` VALUES ('2828', '610629', '洛川县', '610600');
INSERT INTO `jay_area` VALUES ('2829', '610630', '宜川县', '610600');
INSERT INTO `jay_area` VALUES ('2830', '610631', '黄龙县', '610600');
INSERT INTO `jay_area` VALUES ('2831', '610632', '黄陵县', '610600');
INSERT INTO `jay_area` VALUES ('2832', '610701', '市辖区', '610700');
INSERT INTO `jay_area` VALUES ('2833', '610702', '汉台区', '610700');
INSERT INTO `jay_area` VALUES ('2834', '610721', '南郑县', '610700');
INSERT INTO `jay_area` VALUES ('2835', '610722', '城固县', '610700');
INSERT INTO `jay_area` VALUES ('2836', '610723', '洋　县', '610700');
INSERT INTO `jay_area` VALUES ('2837', '610724', '西乡县', '610700');
INSERT INTO `jay_area` VALUES ('2838', '610725', '勉　县', '610700');
INSERT INTO `jay_area` VALUES ('2839', '610726', '宁强县', '610700');
INSERT INTO `jay_area` VALUES ('2840', '610727', '略阳县', '610700');
INSERT INTO `jay_area` VALUES ('2841', '610728', '镇巴县', '610700');
INSERT INTO `jay_area` VALUES ('2842', '610729', '留坝县', '610700');
INSERT INTO `jay_area` VALUES ('2843', '610730', '佛坪县', '610700');
INSERT INTO `jay_area` VALUES ('2844', '610801', '市辖区', '610800');
INSERT INTO `jay_area` VALUES ('2845', '610802', '榆阳区', '610800');
INSERT INTO `jay_area` VALUES ('2846', '610821', '神木县', '610800');
INSERT INTO `jay_area` VALUES ('2847', '610822', '府谷县', '610800');
INSERT INTO `jay_area` VALUES ('2848', '610823', '横山县', '610800');
INSERT INTO `jay_area` VALUES ('2849', '610824', '靖边县', '610800');
INSERT INTO `jay_area` VALUES ('2850', '610825', '定边县', '610800');
INSERT INTO `jay_area` VALUES ('2851', '610826', '绥德县', '610800');
INSERT INTO `jay_area` VALUES ('2852', '610827', '米脂县', '610800');
INSERT INTO `jay_area` VALUES ('2853', '610828', '佳　县', '610800');
INSERT INTO `jay_area` VALUES ('2854', '610829', '吴堡县', '610800');
INSERT INTO `jay_area` VALUES ('2855', '610830', '清涧县', '610800');
INSERT INTO `jay_area` VALUES ('2856', '610831', '子洲县', '610800');
INSERT INTO `jay_area` VALUES ('2857', '610901', '市辖区', '610900');
INSERT INTO `jay_area` VALUES ('2858', '610902', '汉滨区', '610900');
INSERT INTO `jay_area` VALUES ('2859', '610921', '汉阴县', '610900');
INSERT INTO `jay_area` VALUES ('2860', '610922', '石泉县', '610900');
INSERT INTO `jay_area` VALUES ('2861', '610923', '宁陕县', '610900');
INSERT INTO `jay_area` VALUES ('2862', '610924', '紫阳县', '610900');
INSERT INTO `jay_area` VALUES ('2863', '610925', '岚皋县', '610900');
INSERT INTO `jay_area` VALUES ('2864', '610926', '平利县', '610900');
INSERT INTO `jay_area` VALUES ('2865', '610927', '镇坪县', '610900');
INSERT INTO `jay_area` VALUES ('2866', '610928', '旬阳县', '610900');
INSERT INTO `jay_area` VALUES ('2867', '610929', '白河县', '610900');
INSERT INTO `jay_area` VALUES ('2868', '611001', '市辖区', '611000');
INSERT INTO `jay_area` VALUES ('2869', '611002', '商州区', '611000');
INSERT INTO `jay_area` VALUES ('2870', '611021', '洛南县', '611000');
INSERT INTO `jay_area` VALUES ('2871', '611022', '丹凤县', '611000');
INSERT INTO `jay_area` VALUES ('2872', '611023', '商南县', '611000');
INSERT INTO `jay_area` VALUES ('2873', '611024', '山阳县', '611000');
INSERT INTO `jay_area` VALUES ('2874', '611025', '镇安县', '611000');
INSERT INTO `jay_area` VALUES ('2875', '611026', '柞水县', '611000');
INSERT INTO `jay_area` VALUES ('2876', '620101', '市辖区', '620100');
INSERT INTO `jay_area` VALUES ('2877', '620102', '城关区', '620100');
INSERT INTO `jay_area` VALUES ('2878', '620103', '七里河区', '620100');
INSERT INTO `jay_area` VALUES ('2879', '620104', '西固区', '620100');
INSERT INTO `jay_area` VALUES ('2880', '620105', '安宁区', '620100');
INSERT INTO `jay_area` VALUES ('2881', '620111', '红古区', '620100');
INSERT INTO `jay_area` VALUES ('2882', '620121', '永登县', '620100');
INSERT INTO `jay_area` VALUES ('2883', '620122', '皋兰县', '620100');
INSERT INTO `jay_area` VALUES ('2884', '620123', '榆中县', '620100');
INSERT INTO `jay_area` VALUES ('2885', '620201', '市辖区', '620200');
INSERT INTO `jay_area` VALUES ('2886', '620301', '市辖区', '620300');
INSERT INTO `jay_area` VALUES ('2887', '620302', '金川区', '620300');
INSERT INTO `jay_area` VALUES ('2888', '620321', '永昌县', '620300');
INSERT INTO `jay_area` VALUES ('2889', '620401', '市辖区', '620400');
INSERT INTO `jay_area` VALUES ('2890', '620402', '白银区', '620400');
INSERT INTO `jay_area` VALUES ('2891', '620403', '平川区', '620400');
INSERT INTO `jay_area` VALUES ('2892', '620421', '靖远县', '620400');
INSERT INTO `jay_area` VALUES ('2893', '620422', '会宁县', '620400');
INSERT INTO `jay_area` VALUES ('2894', '620423', '景泰县', '620400');
INSERT INTO `jay_area` VALUES ('2895', '620501', '市辖区', '620500');
INSERT INTO `jay_area` VALUES ('2896', '620502', '秦城区', '620500');
INSERT INTO `jay_area` VALUES ('2897', '620503', '北道区', '620500');
INSERT INTO `jay_area` VALUES ('2898', '620521', '清水县', '620500');
INSERT INTO `jay_area` VALUES ('2899', '620522', '秦安县', '620500');
INSERT INTO `jay_area` VALUES ('2900', '620523', '甘谷县', '620500');
INSERT INTO `jay_area` VALUES ('2901', '620524', '武山县', '620500');
INSERT INTO `jay_area` VALUES ('2902', '620525', '张家川回族自治县', '620500');
INSERT INTO `jay_area` VALUES ('2903', '620601', '市辖区', '620600');
INSERT INTO `jay_area` VALUES ('2904', '620602', '凉州区', '620600');
INSERT INTO `jay_area` VALUES ('2905', '620621', '民勤县', '620600');
INSERT INTO `jay_area` VALUES ('2906', '620622', '古浪县', '620600');
INSERT INTO `jay_area` VALUES ('2907', '620623', '天祝藏族自治县', '620600');
INSERT INTO `jay_area` VALUES ('2908', '620701', '市辖区', '620700');
INSERT INTO `jay_area` VALUES ('2909', '620702', '甘州区', '620700');
INSERT INTO `jay_area` VALUES ('2910', '620721', '肃南裕固族自治县', '620700');
INSERT INTO `jay_area` VALUES ('2911', '620722', '民乐县', '620700');
INSERT INTO `jay_area` VALUES ('2912', '620723', '临泽县', '620700');
INSERT INTO `jay_area` VALUES ('2913', '620724', '高台县', '620700');
INSERT INTO `jay_area` VALUES ('2914', '620725', '山丹县', '620700');
INSERT INTO `jay_area` VALUES ('2915', '620801', '市辖区', '620800');
INSERT INTO `jay_area` VALUES ('2916', '620802', '崆峒区', '620800');
INSERT INTO `jay_area` VALUES ('2917', '620821', '泾川县', '620800');
INSERT INTO `jay_area` VALUES ('2918', '620822', '灵台县', '620800');
INSERT INTO `jay_area` VALUES ('2919', '620823', '崇信县', '620800');
INSERT INTO `jay_area` VALUES ('2920', '620824', '华亭县', '620800');
INSERT INTO `jay_area` VALUES ('2921', '620825', '庄浪县', '620800');
INSERT INTO `jay_area` VALUES ('2922', '620826', '静宁县', '620800');
INSERT INTO `jay_area` VALUES ('2923', '620901', '市辖区', '620900');
INSERT INTO `jay_area` VALUES ('2924', '620902', '肃州区', '620900');
INSERT INTO `jay_area` VALUES ('2925', '620921', '金塔县', '620900');
INSERT INTO `jay_area` VALUES ('2926', '620922', '安西县', '620900');
INSERT INTO `jay_area` VALUES ('2927', '620923', '肃北蒙古族自治县', '620900');
INSERT INTO `jay_area` VALUES ('2928', '620924', '阿克塞哈萨克族自治县', '620900');
INSERT INTO `jay_area` VALUES ('2929', '620981', '玉门市', '620900');
INSERT INTO `jay_area` VALUES ('2930', '620982', '敦煌市', '620900');
INSERT INTO `jay_area` VALUES ('2931', '621001', '市辖区', '621000');
INSERT INTO `jay_area` VALUES ('2932', '621002', '西峰区', '621000');
INSERT INTO `jay_area` VALUES ('2933', '621021', '庆城县', '621000');
INSERT INTO `jay_area` VALUES ('2934', '621022', '环　县', '621000');
INSERT INTO `jay_area` VALUES ('2935', '621023', '华池县', '621000');
INSERT INTO `jay_area` VALUES ('2936', '621024', '合水县', '621000');
INSERT INTO `jay_area` VALUES ('2937', '621025', '正宁县', '621000');
INSERT INTO `jay_area` VALUES ('2938', '621026', '宁　县', '621000');
INSERT INTO `jay_area` VALUES ('2939', '621027', '镇原县', '621000');
INSERT INTO `jay_area` VALUES ('2940', '621101', '市辖区', '621100');
INSERT INTO `jay_area` VALUES ('2941', '621102', '安定区', '621100');
INSERT INTO `jay_area` VALUES ('2942', '621121', '通渭县', '621100');
INSERT INTO `jay_area` VALUES ('2943', '621122', '陇西县', '621100');
INSERT INTO `jay_area` VALUES ('2944', '621123', '渭源县', '621100');
INSERT INTO `jay_area` VALUES ('2945', '621124', '临洮县', '621100');
INSERT INTO `jay_area` VALUES ('2946', '621125', '漳　县', '621100');
INSERT INTO `jay_area` VALUES ('2947', '621126', '岷　县', '621100');
INSERT INTO `jay_area` VALUES ('2948', '621201', '市辖区', '621200');
INSERT INTO `jay_area` VALUES ('2949', '621202', '武都区', '621200');
INSERT INTO `jay_area` VALUES ('2950', '621221', '成　县', '621200');
INSERT INTO `jay_area` VALUES ('2951', '621222', '文　县', '621200');
INSERT INTO `jay_area` VALUES ('2952', '621223', '宕昌县', '621200');
INSERT INTO `jay_area` VALUES ('2953', '621224', '康　县', '621200');
INSERT INTO `jay_area` VALUES ('2954', '621225', '西和县', '621200');
INSERT INTO `jay_area` VALUES ('2955', '621226', '礼　县', '621200');
INSERT INTO `jay_area` VALUES ('2956', '621227', '徽　县', '621200');
INSERT INTO `jay_area` VALUES ('2957', '621228', '两当县', '621200');
INSERT INTO `jay_area` VALUES ('2958', '622901', '临夏市', '622900');
INSERT INTO `jay_area` VALUES ('2959', '622921', '临夏县', '622900');
INSERT INTO `jay_area` VALUES ('2960', '622922', '康乐县', '622900');
INSERT INTO `jay_area` VALUES ('2961', '622923', '永靖县', '622900');
INSERT INTO `jay_area` VALUES ('2962', '622924', '广河县', '622900');
INSERT INTO `jay_area` VALUES ('2963', '622925', '和政县', '622900');
INSERT INTO `jay_area` VALUES ('2964', '622926', '东乡族自治县', '622900');
INSERT INTO `jay_area` VALUES ('2965', '622927', '积石山保安族东乡族撒拉族自治县', '622900');
INSERT INTO `jay_area` VALUES ('2966', '623001', '合作市', '623000');
INSERT INTO `jay_area` VALUES ('2967', '623021', '临潭县', '623000');
INSERT INTO `jay_area` VALUES ('2968', '623022', '卓尼县', '623000');
INSERT INTO `jay_area` VALUES ('2969', '623023', '舟曲县', '623000');
INSERT INTO `jay_area` VALUES ('2970', '623024', '迭部县', '623000');
INSERT INTO `jay_area` VALUES ('2971', '623025', '玛曲县', '623000');
INSERT INTO `jay_area` VALUES ('2972', '623026', '碌曲县', '623000');
INSERT INTO `jay_area` VALUES ('2973', '623027', '夏河县', '623000');
INSERT INTO `jay_area` VALUES ('2974', '630101', '市辖区', '630100');
INSERT INTO `jay_area` VALUES ('2975', '630102', '城东区', '630100');
INSERT INTO `jay_area` VALUES ('2976', '630103', '城中区', '630100');
INSERT INTO `jay_area` VALUES ('2977', '630104', '城西区', '630100');
INSERT INTO `jay_area` VALUES ('2978', '630105', '城北区', '630100');
INSERT INTO `jay_area` VALUES ('2979', '630121', '大通回族土族自治县', '630100');
INSERT INTO `jay_area` VALUES ('2980', '630122', '湟中县', '630100');
INSERT INTO `jay_area` VALUES ('2981', '630123', '湟源县', '630100');
INSERT INTO `jay_area` VALUES ('2982', '632121', '平安县', '632100');
INSERT INTO `jay_area` VALUES ('2983', '632122', '民和回族土族自治县', '632100');
INSERT INTO `jay_area` VALUES ('2984', '632123', '乐都县', '632100');
INSERT INTO `jay_area` VALUES ('2985', '632126', '互助土族自治县', '632100');
INSERT INTO `jay_area` VALUES ('2986', '632127', '化隆回族自治县', '632100');
INSERT INTO `jay_area` VALUES ('2987', '632128', '循化撒拉族自治县', '632100');
INSERT INTO `jay_area` VALUES ('2988', '632221', '门源回族自治县', '632200');
INSERT INTO `jay_area` VALUES ('2989', '632222', '祁连县', '632200');
INSERT INTO `jay_area` VALUES ('2990', '632223', '海晏县', '632200');
INSERT INTO `jay_area` VALUES ('2991', '632224', '刚察县', '632200');
INSERT INTO `jay_area` VALUES ('2992', '632321', '同仁县', '632300');
INSERT INTO `jay_area` VALUES ('2993', '632322', '尖扎县', '632300');
INSERT INTO `jay_area` VALUES ('2994', '632323', '泽库县', '632300');
INSERT INTO `jay_area` VALUES ('2995', '632324', '河南蒙古族自治县', '632300');
INSERT INTO `jay_area` VALUES ('2996', '632521', '共和县', '632500');
INSERT INTO `jay_area` VALUES ('2997', '632522', '同德县', '632500');
INSERT INTO `jay_area` VALUES ('2998', '632523', '贵德县', '632500');
INSERT INTO `jay_area` VALUES ('2999', '632524', '兴海县', '632500');
INSERT INTO `jay_area` VALUES ('3000', '632525', '贵南县', '632500');
INSERT INTO `jay_area` VALUES ('3001', '632621', '玛沁县', '632600');
INSERT INTO `jay_area` VALUES ('3002', '632622', '班玛县', '632600');
INSERT INTO `jay_area` VALUES ('3003', '632623', '甘德县', '632600');
INSERT INTO `jay_area` VALUES ('3004', '632624', '达日县', '632600');
INSERT INTO `jay_area` VALUES ('3005', '632625', '久治县', '632600');
INSERT INTO `jay_area` VALUES ('3006', '632626', '玛多县', '632600');
INSERT INTO `jay_area` VALUES ('3007', '632721', '玉树县', '632700');
INSERT INTO `jay_area` VALUES ('3008', '632722', '杂多县', '632700');
INSERT INTO `jay_area` VALUES ('3009', '632723', '称多县', '632700');
INSERT INTO `jay_area` VALUES ('3010', '632724', '治多县', '632700');
INSERT INTO `jay_area` VALUES ('3011', '632725', '囊谦县', '632700');
INSERT INTO `jay_area` VALUES ('3012', '632726', '曲麻莱县', '632700');
INSERT INTO `jay_area` VALUES ('3013', '632801', '格尔木市', '632800');
INSERT INTO `jay_area` VALUES ('3014', '632802', '德令哈市', '632800');
INSERT INTO `jay_area` VALUES ('3015', '632821', '乌兰县', '632800');
INSERT INTO `jay_area` VALUES ('3016', '632822', '都兰县', '632800');
INSERT INTO `jay_area` VALUES ('3017', '632823', '天峻县', '632800');
INSERT INTO `jay_area` VALUES ('3018', '640101', '市辖区', '640100');
INSERT INTO `jay_area` VALUES ('3019', '640104', '兴庆区', '640100');
INSERT INTO `jay_area` VALUES ('3020', '640105', '西夏区', '640100');
INSERT INTO `jay_area` VALUES ('3021', '640106', '金凤区', '640100');
INSERT INTO `jay_area` VALUES ('3022', '640121', '永宁县', '640100');
INSERT INTO `jay_area` VALUES ('3023', '640122', '贺兰县', '640100');
INSERT INTO `jay_area` VALUES ('3024', '640181', '灵武市', '640100');
INSERT INTO `jay_area` VALUES ('3025', '640201', '市辖区', '640200');
INSERT INTO `jay_area` VALUES ('3026', '640202', '大武口区', '640200');
INSERT INTO `jay_area` VALUES ('3027', '640205', '惠农区', '640200');
INSERT INTO `jay_area` VALUES ('3028', '640221', '平罗县', '640200');
INSERT INTO `jay_area` VALUES ('3029', '640301', '市辖区', '640300');
INSERT INTO `jay_area` VALUES ('3030', '640302', '利通区', '640300');
INSERT INTO `jay_area` VALUES ('3031', '640323', '盐池县', '640300');
INSERT INTO `jay_area` VALUES ('3032', '640324', '同心县', '640300');
INSERT INTO `jay_area` VALUES ('3033', '640381', '青铜峡市', '640300');
INSERT INTO `jay_area` VALUES ('3034', '640401', '市辖区', '640400');
INSERT INTO `jay_area` VALUES ('3035', '640402', '原州区', '640400');
INSERT INTO `jay_area` VALUES ('3036', '640422', '西吉县', '640400');
INSERT INTO `jay_area` VALUES ('3037', '640423', '隆德县', '640400');
INSERT INTO `jay_area` VALUES ('3038', '640424', '泾源县', '640400');
INSERT INTO `jay_area` VALUES ('3039', '640425', '彭阳县', '640400');
INSERT INTO `jay_area` VALUES ('3040', '640501', '市辖区', '640500');
INSERT INTO `jay_area` VALUES ('3041', '640502', '沙坡头区', '640500');
INSERT INTO `jay_area` VALUES ('3042', '640521', '中宁县', '640500');
INSERT INTO `jay_area` VALUES ('3043', '640522', '海原县', '640400');
INSERT INTO `jay_area` VALUES ('3044', '650101', '市辖区', '650100');
INSERT INTO `jay_area` VALUES ('3045', '650102', '天山区', '650100');
INSERT INTO `jay_area` VALUES ('3046', '650103', '沙依巴克区', '650100');
INSERT INTO `jay_area` VALUES ('3047', '650104', '新市区', '650100');
INSERT INTO `jay_area` VALUES ('3048', '650105', '水磨沟区', '650100');
INSERT INTO `jay_area` VALUES ('3049', '650106', '头屯河区', '650100');
INSERT INTO `jay_area` VALUES ('3050', '650107', '达坂城区', '650100');
INSERT INTO `jay_area` VALUES ('3051', '650108', '东山区', '650100');
INSERT INTO `jay_area` VALUES ('3052', '650121', '乌鲁木齐县', '650100');
INSERT INTO `jay_area` VALUES ('3053', '650201', '市辖区', '650200');
INSERT INTO `jay_area` VALUES ('3054', '650202', '独山子区', '650200');
INSERT INTO `jay_area` VALUES ('3055', '650203', '克拉玛依区', '650200');
INSERT INTO `jay_area` VALUES ('3056', '650204', '白碱滩区', '650200');
INSERT INTO `jay_area` VALUES ('3057', '650205', '乌尔禾区', '650200');
INSERT INTO `jay_area` VALUES ('3058', '652101', '吐鲁番市', '652100');
INSERT INTO `jay_area` VALUES ('3059', '652122', '鄯善县', '652100');
INSERT INTO `jay_area` VALUES ('3060', '652123', '托克逊县', '652100');
INSERT INTO `jay_area` VALUES ('3061', '652201', '哈密市', '652200');
INSERT INTO `jay_area` VALUES ('3062', '652222', '巴里坤哈萨克自治县', '652200');
INSERT INTO `jay_area` VALUES ('3063', '652223', '伊吾县', '652200');
INSERT INTO `jay_area` VALUES ('3064', '652301', '昌吉市', '652300');
INSERT INTO `jay_area` VALUES ('3065', '652302', '阜康市', '652300');
INSERT INTO `jay_area` VALUES ('3066', '652303', '米泉市', '652300');
INSERT INTO `jay_area` VALUES ('3067', '652323', '呼图壁县', '652300');
INSERT INTO `jay_area` VALUES ('3068', '652324', '玛纳斯县', '652300');
INSERT INTO `jay_area` VALUES ('3069', '652325', '奇台县', '652300');
INSERT INTO `jay_area` VALUES ('3070', '652327', '吉木萨尔县', '652300');
INSERT INTO `jay_area` VALUES ('3071', '652328', '木垒哈萨克自治县', '652300');
INSERT INTO `jay_area` VALUES ('3072', '652701', '博乐市', '652700');
INSERT INTO `jay_area` VALUES ('3073', '652722', '精河县', '652700');
INSERT INTO `jay_area` VALUES ('3074', '652723', '温泉县', '652700');
INSERT INTO `jay_area` VALUES ('3075', '652801', '库尔勒市', '652800');
INSERT INTO `jay_area` VALUES ('3076', '652822', '轮台县', '652800');
INSERT INTO `jay_area` VALUES ('3077', '652823', '尉犁县', '652800');
INSERT INTO `jay_area` VALUES ('3078', '652824', '若羌县', '652800');
INSERT INTO `jay_area` VALUES ('3079', '652825', '且末县', '652800');
INSERT INTO `jay_area` VALUES ('3080', '652826', '焉耆回族自治县', '652800');
INSERT INTO `jay_area` VALUES ('3081', '652827', '和静县', '652800');
INSERT INTO `jay_area` VALUES ('3082', '652828', '和硕县', '652800');
INSERT INTO `jay_area` VALUES ('3083', '652829', '博湖县', '652800');
INSERT INTO `jay_area` VALUES ('3084', '652901', '阿克苏市', '652900');
INSERT INTO `jay_area` VALUES ('3085', '652922', '温宿县', '652900');
INSERT INTO `jay_area` VALUES ('3086', '652923', '库车县', '652900');
INSERT INTO `jay_area` VALUES ('3087', '652924', '沙雅县', '652900');
INSERT INTO `jay_area` VALUES ('3088', '652925', '新和县', '652900');
INSERT INTO `jay_area` VALUES ('3089', '652926', '拜城县', '652900');
INSERT INTO `jay_area` VALUES ('3090', '652927', '乌什县', '652900');
INSERT INTO `jay_area` VALUES ('3091', '652928', '阿瓦提县', '652900');
INSERT INTO `jay_area` VALUES ('3092', '652929', '柯坪县', '652900');
INSERT INTO `jay_area` VALUES ('3093', '653001', '阿图什市', '653000');
INSERT INTO `jay_area` VALUES ('3094', '653022', '阿克陶县', '653000');
INSERT INTO `jay_area` VALUES ('3095', '653023', '阿合奇县', '653000');
INSERT INTO `jay_area` VALUES ('3096', '653024', '乌恰县', '653000');
INSERT INTO `jay_area` VALUES ('3097', '653101', '喀什市', '653100');
INSERT INTO `jay_area` VALUES ('3098', '653121', '疏附县', '653100');
INSERT INTO `jay_area` VALUES ('3099', '653122', '疏勒县', '653100');
INSERT INTO `jay_area` VALUES ('3100', '653123', '英吉沙县', '653100');
INSERT INTO `jay_area` VALUES ('3101', '653124', '泽普县', '653100');
INSERT INTO `jay_area` VALUES ('3102', '653125', '莎车县', '653100');
INSERT INTO `jay_area` VALUES ('3103', '653126', '叶城县', '653100');
INSERT INTO `jay_area` VALUES ('3104', '653127', '麦盖提县', '653100');
INSERT INTO `jay_area` VALUES ('3105', '653128', '岳普湖县', '653100');
INSERT INTO `jay_area` VALUES ('3106', '653129', '伽师县', '653100');
INSERT INTO `jay_area` VALUES ('3107', '653130', '巴楚县', '653100');
INSERT INTO `jay_area` VALUES ('3108', '653131', '塔什库尔干塔吉克自治县', '653100');
INSERT INTO `jay_area` VALUES ('3109', '653201', '和田市', '653200');
INSERT INTO `jay_area` VALUES ('3110', '653221', '和田县', '653200');
INSERT INTO `jay_area` VALUES ('3111', '653222', '墨玉县', '653200');
INSERT INTO `jay_area` VALUES ('3112', '653223', '皮山县', '653200');
INSERT INTO `jay_area` VALUES ('3113', '653224', '洛浦县', '653200');
INSERT INTO `jay_area` VALUES ('3114', '653225', '策勒县', '653200');
INSERT INTO `jay_area` VALUES ('3115', '653226', '于田县', '653200');
INSERT INTO `jay_area` VALUES ('3116', '653227', '民丰县', '653200');
INSERT INTO `jay_area` VALUES ('3117', '654002', '伊宁市', '654000');
INSERT INTO `jay_area` VALUES ('3118', '654003', '奎屯市', '654000');
INSERT INTO `jay_area` VALUES ('3119', '654021', '伊宁县', '654000');
INSERT INTO `jay_area` VALUES ('3120', '654022', '察布查尔锡伯自治县', '654000');
INSERT INTO `jay_area` VALUES ('3121', '654023', '霍城县', '654000');
INSERT INTO `jay_area` VALUES ('3122', '654024', '巩留县', '654000');
INSERT INTO `jay_area` VALUES ('3123', '654025', '新源县', '654000');
INSERT INTO `jay_area` VALUES ('3124', '654026', '昭苏县', '654000');
INSERT INTO `jay_area` VALUES ('3125', '654027', '特克斯县', '654000');
INSERT INTO `jay_area` VALUES ('3126', '654028', '尼勒克县', '654000');
INSERT INTO `jay_area` VALUES ('3127', '654201', '塔城市', '654200');
INSERT INTO `jay_area` VALUES ('3128', '654202', '乌苏市', '654200');
INSERT INTO `jay_area` VALUES ('3129', '654221', '额敏县', '654200');
INSERT INTO `jay_area` VALUES ('3130', '654223', '沙湾县', '654200');
INSERT INTO `jay_area` VALUES ('3131', '654224', '托里县', '654200');
INSERT INTO `jay_area` VALUES ('3132', '654225', '裕民县', '654200');
INSERT INTO `jay_area` VALUES ('3133', '654226', '和布克赛尔蒙古自治县', '654200');
INSERT INTO `jay_area` VALUES ('3134', '654301', '阿勒泰市', '654300');
INSERT INTO `jay_area` VALUES ('3135', '654321', '布尔津县', '654300');
INSERT INTO `jay_area` VALUES ('3136', '654322', '富蕴县', '654300');
INSERT INTO `jay_area` VALUES ('3137', '654323', '福海县', '654300');
INSERT INTO `jay_area` VALUES ('3138', '654324', '哈巴河县', '654300');
INSERT INTO `jay_area` VALUES ('3139', '654325', '青河县', '654300');
INSERT INTO `jay_area` VALUES ('3140', '654326', '吉木乃县', '654300');
INSERT INTO `jay_area` VALUES ('3141', '659001', '石河子市', '659000');
INSERT INTO `jay_area` VALUES ('3142', '659002', '阿拉尔市', '659000');
INSERT INTO `jay_area` VALUES ('3143', '659003', '图木舒克市', '659000');
INSERT INTO `jay_area` VALUES ('3144', '659004', '五家渠市', '659000');

-- ----------------------------
-- Table structure for `jay_article`
-- ----------------------------
DROP TABLE IF EXISTS `jay_article`;
CREATE TABLE `jay_article` (
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `cat_id` smallint(5) NOT NULL DEFAULT '0' COMMENT '类别ID',
  `section` int(11) DEFAULT '0' COMMENT '大分类id',
  `title` varchar(150) NOT NULL DEFAULT '' COMMENT '文章标题',
  `content` text NOT NULL COMMENT '文章内容',
  `descp` varchar(255) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `pic` varchar(50) DEFAULT '' COMMENT '文章缩略图',
  `status` tinyint(4) DEFAULT '1' COMMENT '1正常 0不显示',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `en_title` varchar(200) DEFAULT NULL,
  `en_content` text,
  `en_descp` varchar(255) DEFAULT NULL,
  `en_pic` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cat_id` (`cat_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1153 DEFAULT CHARSET=utf8 COMMENT='活动表';

-- ----------------------------
-- Records of jay_article
-- ----------------------------
INSERT INTO `jay_article` VALUES ('1', '7', '3', '保修日期', '<p>本产品全国联保，享受三包服务，质保期为：全国联保一年<br/>\r\n &nbsp; &nbsp; &nbsp; &nbsp; 如因质量问题享受7日内退货，15日内换货，15日以上在质保期内享受免费保修等三包服务！</p>', null, null, '', '1', '0', null, null, null, null);
INSERT INTO `jay_article` VALUES ('26', '88', '3', '商城手机版', '&lt;p&gt;TPshop的特色功能&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;手机移动端&lt;/p&gt;&lt;p&gt;1、 界面设计更为美观，更容易安全信任 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、 代码量少，访问速度快&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、 PC端功能在移动端实现并改进 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、 购物体验优良&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、 活动形式丰富（活动，优惠，特价 , 捆绑等） &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;6、 移动与PC信息同步， 支持APP套壳&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、 移动端网站有助于提升SEO&lt;/p&gt;&lt;p&gt;多语言站群&lt;/p&gt;&lt;p&gt;1、多个网站的集合，可统一管理会员/订单，商品信息&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、商品SEO信息可不同，不同域名绑定不同模板&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、对于一些内容或者配置都可分别进行设置&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、可同时支持分销站点，多语言子站，移动端，APP接入&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、开放API支持后端ERP对接业务对接&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;丰富的营销体系&lt;/p&gt;&lt;p&gt;系统支持 购物车活动、商品优惠、优惠券、积分抵用、成长值升级、\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;限时特价、商品包邮、捆绑销售等十多种促销活动手段，给客户更多的实惠，增强网站的粘度。&lt;/p&gt;&lt;p&gt;完善的事件中心&lt;/p&gt;&lt;p&gt;系统支持执行常用事件例如下订单，注册、付款成功、评论、发货等事件时触发邮件、积分、优惠券、\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;站内信、成长值等。&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;良好的购物体验&lt;/p&gt;&lt;p&gt;1、支持在列表快速加入购物车&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、支持10+多第三方联合登陆，缩短注册时间&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、可在一页完成地址，配送，支付的信息填写并且提交\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、支持PAYPAL快捷支付且支持游客下单，缩短购物时间&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、支持在线购物车，PC与移动端同步&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;6、购物车流程更专业更值得信任&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、支持后台未支付订单催款，未下单用户催单&lt;/p&gt;&lt;p&gt;改良版搜索体系&lt;/p&gt;&lt;p&gt;搜索是商品最重要入口，系统集成搜索联想、搜索拦截、\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;热门搜索、底纹搜索、全文搜索。&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;利于SEO优化&lt;/p&gt;&lt;p&gt;1、 全站95%代码DIV+CSS&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、 重要页面支持SEO修改&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、 全站生成.HTML 静态地址&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、 支持谷歌微格式&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、 商品评论批量伪造&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;6、 Sitemap发布，404设置，Wordpress博客&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、 商品，分类，新闻，标签，品牌等支持自定义URL链接&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;8、 代码更为精简，打开速度更快&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;9、 自带移动端，更利于移动搜索以及排名&lt;/p&gt;&lt;p&gt;商品展示体系&lt;/p&gt;&lt;p&gt;商品的排列支持按照分类，品牌，标签，特价，\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;每日更新，属性筛选&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;API对接&lt;/p&gt;&lt;p&gt;1、订单对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;2、商品推送 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、发货对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;4、月销量对接 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、库存对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;6、产品抓取对接 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、会员对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;8、更多API开放&lt;/p&gt;&lt;p&gt;操作更加简单&lt;/p&gt;&lt;p&gt;1、图文教程，视频教程，后台中文化，操作更加符合国人操作习惯。&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、付费高级用户又可以享受远程协助、电话服务、技术实施等服务。&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;支付物流完整&lt;/p&gt;&lt;p&gt;1、系统与Paypal、MoneyBookers、国际支付宝、Worldpay、GlobalCollect等主流第三方支付预先整合。&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、支持Fedex,DHL,TNT,UPS等物流方式，且支持个性化的物流计算方式，同时支持运费险又可帮客户减少风险。&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, null, '', '1', '0', null, null, null, null);
INSERT INTO `jay_article` VALUES ('28', '10', '3', '环境要求', '&lt;p&gt;PHP5.4以上版本&lt;/p&gt;&lt;p&gt;Mysql 5.5以上&lt;br/&gt;&lt;/p&gt;&lt;p&gt;支持的服务器和数据库环境&lt;/p&gt;&lt;p&gt;支持Windows/linux服务器环境&lt;/p&gt;&lt;p&gt;可运行于包括Apache、IIS和nginx在内的多种WEB服务器和模式&lt;/p&gt;&lt;p&gt;采用 ThinkPHP3.2 开发 jquery 最新版 + bootstrap 最新版&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, null, '', '1', '1450440900', null, null, null, null);
INSERT INTO `jay_article` VALUES ('29', '10', '3', '功能介绍', '&lt;p&gt;&amp;nbsp;简单实用的 商城功能.&amp;nbsp; 灵活的插件安装卸载, 齐全的视频教程 + 手册 不断的升级更新&lt;br/&gt;&lt;/p&gt;&lt;p&gt;TPshop 分为&amp;nbsp; PC端 + 微信端 + wap + app的android + ios&lt;br/&gt;&lt;/p&gt;', null, null, '', '1', '1450441002', null, null, null, null);
INSERT INTO `jay_article` VALUES ('30', '10', '3', '模块介绍', '&lt;p&gt;TPshop模块介绍&lt;br/&gt;&lt;/p&gt;', null, null, '', '1', '1450525815', null, null, null, null);
INSERT INTO `jay_article` VALUES ('31', '10', '3', 'tpshop目录结构介绍', '&lt;p&gt;&lt;img src=&quot;/Public/upload/article/2016/05-16/57389ea781868.png&quot; title=&quot;TPshop目录结构.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;以上图可以看出 TPshop目录结构非常简洁。&amp;nbsp; Application 下面 四个模块 分别是 Admin Api Home Mobile&amp;nbsp; 访问某个模块时是 域名/index.php/模块名称&lt;br/&gt;比如访问手机模块 www.tp-shop.cn/index.php/Mobile &lt;br/&gt;Runtime 是tpshop 的整个缓存文件夹 缓存了一些临时数据， 其中 Html 是静态页面缓存。&amp;nbsp; 如果需要清空缓存点击管理员后台右上角清楚缓存。&lt;br/&gt;如果需要修改缓存时间 可以修改index.php 页面的 define(&amp;#39;TPSHOP_CACHE_TIME&amp;#39;,1); // TPshop 缓存时间 把缓存时间改为 1秒钟&lt;br/&gt;静态页面文件在缓存在 Application\\Home\\Conf\\config.php 中配置， 看如下配置， 每行注释写的很清楚&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;pre class=&quot;brush:php;toolbar:false&quot;&gt;&amp;#39;HTML_CACHE_RULES&amp;#39;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;array(&amp;nbsp;&amp;nbsp;//&amp;nbsp;定义静态缓存规则\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;nbsp;定义格式1&amp;nbsp;数组方式\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;#39;静态地址&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;array(&amp;#39;静态规则&amp;#39;,&amp;nbsp;&amp;#39;有效期&amp;#39;,&amp;nbsp;&amp;#39;附加规则&amp;#39;),&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;index:index&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;首页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;#39;index:goodsList&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}&amp;#39;,300),&amp;nbsp;&amp;nbsp;//&amp;nbsp;列表页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;无参数&amp;nbsp;post&amp;nbsp;提交的很难缓存\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;index:goodsList&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{id}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;列表页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//ajax&amp;nbsp;请求的商品列表内容在&amp;nbsp;ajaxGoodsList&amp;nbsp;函数中&amp;nbsp;&amp;nbsp;S($keys,$html,300);&amp;nbsp;缓存\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;Goods:goodsInfo&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{id}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品详情页静态缓存&amp;nbsp;3秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;Goods:ajaxComment&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{goods_id}_{commentType}_{p}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品评论页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;Goods:ajaxConsult&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{goods_id}_{consult_type}_{p}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品咨询页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品详情的规格价格缓存在&amp;nbsp;ajaxGoodsPrice&amp;nbsp;函数里面&amp;nbsp;S($keys,$price,300);//&amp;nbsp;缓存数据300秒&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;channel:index&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{id}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;列表页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟\r\n),&lt;/pre&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;tpshop 上传的图片存贮在 \\Public\\upload&lt;br/&gt;tpshop 的插件目录在 \\plugins 里面包含 支付插件payment&amp;nbsp; 物流插件shipping&amp;nbsp; 已经登录插件login &amp;nbsp;&lt;br/&gt;tpshop 的模板在 \\Template\\pc&amp;nbsp; 和 \\Template\\mobile&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;tpshop 的公共配置文件目录 www\\Application\\Common 和 公共方法&lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;先来看看后台的切换模板。 &lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;/span&gt;&lt;br/&gt;&lt;img src=&quot;/Public/upload/article/2016/05-16/57389f31799d7.png&quot; title=&quot;模板切换.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;看上图切换模板其实就是修改了 Application\\Home\\Conf\\html.php 文件后台修改模板然后观察这个文件有什么变化， 如果是linux 这个文件必须有 写入权限&lt;br/&gt;看以下代码。 &lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;pre class=&quot;brush:php;toolbar:false&quot;&gt;&amp;lt;?php\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;return&amp;nbsp;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;VIEW_PATH&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;#39;./Template/pc/&amp;#39;,&amp;nbsp;//&amp;nbsp;改变某个模块的模板文件目录\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;DEFAULT_THEME&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;#39;default&amp;#39;,&amp;nbsp;//&amp;nbsp;模板名称&amp;nbsp;切换模板&amp;nbsp;就是修改这里\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;TMPL_PARSE_STRING&amp;#39;&amp;nbsp;&amp;nbsp;=&amp;gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;__PUBLIC__&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;/Common&amp;#39;,&amp;nbsp;//&amp;nbsp;更改默认的/Public&amp;nbsp;替换规则\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;__STATIC__&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;/Template/pc/default/Static&amp;#39;,&amp;nbsp;//&amp;nbsp;增加新的image&amp;nbsp;&amp;nbsp;css&amp;nbsp;js&amp;nbsp;&amp;nbsp;访问路径&amp;nbsp;&amp;nbsp;后面给&amp;nbsp;php&amp;nbsp;改了&amp;nbsp;&amp;nbsp;切换模板就是修改这里\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;#39;DATA_CACHE_TIME&amp;#39;=&amp;gt;60,&amp;nbsp;//&amp;nbsp;查询缓存时间\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;);\r\n?&amp;gt;\r\n\r\n看了如果有什么不明白的&amp;nbsp;可以下方评论，&amp;nbsp;不需要登录注册可以评论，&amp;nbsp;我们的管理员会给&lt;/pre&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;/span&gt;&lt;br/&gt;&lt;/p&gt;', null, null, '', '1', '1450525867', null, null, null, null);
INSERT INTO `jay_article` VALUES ('32', '10', '3', 'TPshop表结构', '&lt;p&gt;TPshop数据表结构介绍&lt;/p&gt;&lt;pre class=&quot;brush:sql;toolbar:false&quot;&gt;\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_account_log`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`log_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`user_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`frozen_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;冻结金额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`rank_points`&amp;nbsp;mediumint(9)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`pay_points`&amp;nbsp;mediumint(9)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付积分&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`change_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`change_desc`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`change_type`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`log_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_id`&amp;nbsp;(`user_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_ad`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_ad`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`ad_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pid`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位置ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`media_type`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告类型&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_link`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;链接地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_code`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;图片地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`start_time`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;投放时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`end_time`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;结束时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link_man`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;添加人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link_email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;添加人邮箱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link_phone`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;添加人联系电话&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`click_count`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`enabled`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`ad_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`enabled`&amp;nbsp;(`enabled`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`position_id`&amp;nbsp;(`pid`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=6&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_ad_position`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_ad_position`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`position_id`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`position_name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位置名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_width`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位宽度&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_height`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位高度&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`position_desc`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`position_style`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;模板&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_open`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;0关闭1开启&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`position_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=4&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_admin`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_admin`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`admin_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户名&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`password`&amp;nbsp;varchar(32)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ec_salt`&amp;nbsp;varchar(10)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;秘钥&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_login`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_ip`&amp;nbsp;varchar(15)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_list`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;允许操作行为&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`nav_list`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`lang_type`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`agency_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`suppliers_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`todolist`&amp;nbsp;longtext,\r\n&amp;nbsp;&amp;nbsp;`role_id`&amp;nbsp;smallint(5)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`admin_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_name`&amp;nbsp;(`user_name`)&amp;nbsp;USING&amp;nbsp;BTREE,\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`agency_id`&amp;nbsp;(`agency_id`)&amp;nbsp;USING&amp;nbsp;BTREE\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=4&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_admin_role`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_admin_role`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`role_id`&amp;nbsp;smallint(6)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`role_name`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`act_list`&amp;nbsp;text&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;权限列表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`role_desc`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`role_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_area_region`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_area_region`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`shipping_area_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`region_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`shipping_area_id`,`region_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_article`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_article`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`article_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`cat_id`&amp;nbsp;smallint(5)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;类别ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`title`&amp;nbsp;varchar(150)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;文章标题&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`content`&amp;nbsp;longtext&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`author`&amp;nbsp;varchar(30)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;文章作者&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`author_email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;作者邮箱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`keywords`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;关键字&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`article_type`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;2&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_open`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`file_url`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;附件地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`open_type`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;链接地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`description`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`article_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`cat_id`&amp;nbsp;(`cat_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=33&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8&amp;nbsp;ROW_FORMAT=DYNAMIC;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_article_cat`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_article_cat`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`cat_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`cat_name`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;类别名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`cat_type`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;夫级ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`show_in_nav`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`sort_order`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`cat_desc`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`keywords`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`cat_alias`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;别名标示&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`cat_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=16&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_back_goods`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_back_goods`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`rec_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`back_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;退货单ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`goods_sn`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`send_number`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_attr`&amp;nbsp;text&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品属性&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`rec_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`back_id`&amp;nbsp;(`back_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_id`&amp;nbsp;(`goods_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_back_order`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_back_order`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`back_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`delivery_sn`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货流水单号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_sn`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单编号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单iD&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`invoice_no`&amp;nbsp;varchar(50)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货单号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_id`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;物流id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_name`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;物流名字&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_user`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;操作人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`consignee`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`address`&amp;nbsp;varchar(250)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`country`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`province`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`city`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`district`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`sign_building`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`zipcode`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`tel`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`mobile`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`best_time`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`update_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`return_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`back_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_id`&amp;nbsp;(`user_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`order_id`&amp;nbsp;(`order_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_brand`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_brand`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`logo`&amp;nbsp;varchar(80)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌logo&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`desc`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`url`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=16&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_cart`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_cart`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;购物车表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`session_id`&amp;nbsp;char(32)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;session&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_sn`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品货号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`market_price`&amp;nbsp;decimal(10,2)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;市场价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_price`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;本店价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_num`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;购买数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_key`&amp;nbsp;varchar(64)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格key&amp;nbsp;对应tp_spec_goods_price&amp;nbsp;表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_key_name`&amp;nbsp;varchar(64)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格组合名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`bar_code`&amp;nbsp;varchar(64)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品条码&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`selected`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;购物车选中状态&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`session_id`&amp;nbsp;(`session_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=70&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_comment`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_comment`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`comment_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`username`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`content`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`rank`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;评论等级&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ip_address`&amp;nbsp;varchar(15)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_show`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否显示&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`comment_id`),\r\n&amp;nbsp;&amp;nbsp;K', null, null, '', '1', '1450525896', null, null, null, null);
INSERT INTO `jay_article` VALUES ('112', '1', '3', 'TPshop商城V1.0版震感发布', '&lt;p class=&quot;common_tit&quot;&gt;TPshop商城 -- ( Thinkphp shop的简称 ) B2C 商城免费开源&lt;/p&gt;&lt;p&gt;TPshop 是用thinkphp开发的shop 一款免费开源网店系统，适合企业及个人,包含 (微信商城 + wap + android + ios + pc) 二次开发非常方便,\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; 详细的TPshop使用手册 + TPshop二开手册 + TPshop 98小时的二开视频教程，使开发者得心应手, 一看就懂 一听就会, 代码清晰简洁,通俗易懂. 丰富的插件和多套模板支持, 易扩展.\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;是目前国内首家最为完善的开源商城系统。系统支持多语言版本，操作简单,安全稳定,是广大用户二次开发的最佳选择。（需获取正规商业授权，方可做商业运营使用）&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, null, '', '1', '1457696574', null, null, null, null);
INSERT INTO `jay_article` VALUES ('150', '41', '3', '产品PPT下载', '&lt;p&gt;产品PPT下载&lt;/p&gt;', null, null, '', '1', '1462267448', null, null, null, null);
INSERT INTO `jay_article` VALUES ('250', '1', '3', 'TPshop隐藏index.php', '<p>有些朋友提到关于TPshop 隐藏index.php 一问题， 可以修改 Application\\Common\\Conf\\config.php 文件代码 <br/></p><pre class=\"brush:php;toolbar:false\">&#39;common&#39;,\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;AUTH_CODE&#39;&nbsp;=&gt;&nbsp;&quot;TPSHOP&quot;,&nbsp;//安装完毕之后不要改变，否则所有密码都会出错\r\n&nbsp;&nbsp;&nbsp;&nbsp;//&#39;URL_CASE_INSENSITIVE&#39;&nbsp;=&gt;&nbsp;false,&nbsp;//URL大小写不敏感\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;LOAD_EXT_CONFIG&#39;=&gt;&#39;db,route&#39;,&nbsp;//&nbsp;加载数据库配置文件\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;LOAD_EXT_CONFIG&#39;=&gt;&#39;db&#39;,&nbsp;//&nbsp;加载数据库配置文件\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;URL_MODEL&#39;=&gt;2,&nbsp;//&nbsp;如果需要&nbsp;隐藏&nbsp;index.php&nbsp;&nbsp;打开这行&quot;URL_MODEL&quot;注释&nbsp;同时在apache环境下&nbsp;开启&nbsp;伪静态模块，&nbsp;&nbsp;如果在nginx&nbsp;下需要另外配置，参考thinkphp官网手册</pre><p><br/></p><p>有些环境刚修改上面还是不行，需要另外修改根目录下的 .htaccess&nbsp; 文件&nbsp;&nbsp;</p><pre class=\"brush:php;toolbar:false\">&nbsp;&nbsp;Options&nbsp;+FollowSymlinks\r\n&nbsp;&nbsp;RewriteEngine&nbsp;On\r\n\r\n&nbsp;&nbsp;RewriteCond&nbsp;%{REQUEST_FILENAME}&nbsp;!-d\r\n&nbsp;&nbsp;RewriteCond&nbsp;%{REQUEST_FILENAME}&nbsp;!-f\r\n&nbsp;&nbsp;#RewriteRule&nbsp;^(.*)$&nbsp;index.php/$1&nbsp;[QSA,PT,L]&nbsp;&nbsp;\r\n&nbsp;&nbsp;RewriteRule&nbsp;^(.*)$&nbsp;index.php?s=$1&nbsp;[QSA,PT,L]</pre><p>原来的<br/></p><p>&nbsp;RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]&nbsp; <br/></p><p>改成<br/></p><p>&nbsp;RewriteRule ^(.*)$ index.php?s=$1 [QSA,PT,L]&nbsp; <br/></p><p>重启apache&nbsp; 试试。</p><p><br/></p><p>对于nginx 用户 请查看thinkphp 官网手册说明<br/></p>', null, null, '', '1', '1465056409', null, null, null, null);
INSERT INTO `jay_article` VALUES ('259', '10', '3', 'TPshop添加后台菜单', '<p>\r\n	TPshop 添加一个菜单非常方便，只需要 2 步<br />\r\n<br />\r\n比如想添加微信管理下面的 组合回复\r\n</p>\r\n<p>\r\n	<img src=\"/Public/upload/article/2016/06-07/5756ceb3a08ce.jpg\" title=\"1.jpg\" />\r\n</p>\r\n<p>\r\n	第一先到模块管理 -&gt; 模块管理 找到微信管理\r\n</p>\r\n<p>\r\n	<img src=\"/Public/upload/article/2016/06-07/5756ceb3f29e4.jpg\" title=\"2.jpg\" />\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	<img src=\"/Public/upload/article/2016/06-07/5756cf086a2c3.jpg\" title=\"3.jpg\" />\r\n</p>\r\n<p>\r\n	<img src=\"/Public/upload/article/2016/06-07/5756cf199b4c2.jpg\" title=\"4.jpg\" />\r\n</p>\r\n<p>\r\n	照着上图找到对应文件 。\r\n</p>\r\n<p>\r\n	<img src=\"/Public/upload/article/2016/06-07/5756cf3436717.jpg\" title=\"5.jpg\" />\r\n</p>\r\n<p>\r\n	在对应的位置添加上即可\r\n</p>\r\n<p>\r\n	<br />\r\n</p>', null, 'sdf ', '20180923\\0157fb2d27c9e3b36c67b8cbbdd44626.jpg', '1', '1465228800', null, null, null, null);
INSERT INTO `jay_article` VALUES ('1151', '41', '3', '添加后台菜单', '&lt;p&gt;目前在后台公用函数文件function.php中getAllMenu方法里添加，&lt;/p&gt;&lt;p&gt;格式如下&lt;/p&gt;&lt;pre class=&quot;brush:php;toolbar:false&quot;&gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			&amp;#39;system&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;系统设置&amp;#39;,&amp;#39;icon&amp;#39;=&amp;gt;&amp;#39;fa-cog&amp;#39;,&amp;#39;sub_menu&amp;#39;=&amp;gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;网站设置&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;index&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;友情链接&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;linkList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Article&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;自定义导航&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;navigationList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;区域管理&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;region&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Tools&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;权限资源列表&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;right_list&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			)),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			&amp;#39;access&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;权限管理&amp;#39;,&amp;nbsp;&amp;#39;icon&amp;#39;=&amp;gt;&amp;#39;fa-gears&amp;#39;,&amp;nbsp;&amp;#39;sub_menu&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;管理员列表&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;index&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;角色管理&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;role&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;供应商管理&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;supplier&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;管理员日志&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;log&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			)),\r\n）\r\n\r\n例如需要在系统设置中加一个网站公告菜单\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;system&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;系统设置&amp;#39;,&amp;#39;icon&amp;#39;=&amp;gt;&amp;#39;fa-cog&amp;#39;,&amp;#39;sub_menu&amp;#39;=&amp;gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;网站设置&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;index&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;友情链接&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;linkList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Article&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;自定义导航&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;navigationList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;区域管理&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;region&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Tools&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;权限资源列表&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;right_list&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;网站公告&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;notice&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	)),&lt;/pre&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, null, '', '1', '1472042383', null, null, null, null);
INSERT INTO `jay_article` VALUES ('1152', '12', '3', '媒体信3我232322', '<p>\r\n	的司法地方\r\n</p>\r\n<p>\r\n	<strong>1</strong> \r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	<strong>3dddddddddd</strong> \r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	4\r\n</p>\r\n<p>\r\n	3\r\n</p>\r\n<p>\r\n	43434\r\n</p>', '1马努：昨天和妻儿看见一只秃鹰，他们难以置信马努：昨天和妻儿看见一只秃鹰，他们难以置信马努：昨天和妻儿看见一只秃鹰，他们难以置信马努：昨天和妻儿看见一只秃鹰，他们难以置信', '天气，话题5', '20180920\\4549b4bdb911ad912f596875854c57ae.png', '1', '1537372800', 'title', 'neiii', 'desc', null);

-- ----------------------------
-- Table structure for `jay_banner`
-- ----------------------------
DROP TABLE IF EXISTS `jay_banner`;
CREATE TABLE `jay_banner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page_id` int(11) DEFAULT NULL,
  `cat_id` int(11) DEFAULT NULL,
  `alt` varchar(50) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `pic` varchar(50) DEFAULT NULL,
  `sort` tinyint(4) DEFAULT NULL,
  `addtime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_banner
-- ----------------------------
INSERT INTO `jay_banner` VALUES ('2', '1', null, '首页广告', null, '20180801\\ae886eda5913ab145b6247c6ca77390d.jpg', '1', '1511933834');
INSERT INTO `jay_banner` VALUES ('4', '1', null, '首页广告', null, '20180801\\ecafa99c12584a4ecc752d646190a36a.jpg', '1', '1511960125');
INSERT INTO `jay_banner` VALUES ('6', '1', null, '3', null, '20180801\\69ac105f94bc75b9daec8c880f03252f.jpg', '1', '1533094387');

-- ----------------------------
-- Table structure for `jay_categories`
-- ----------------------------
DROP TABLE IF EXISTS `jay_categories`;
CREATE TABLE `jay_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `cat_name` varchar(20) DEFAULT NULL,
  `sort` tinyint(4) DEFAULT NULL,
  `addtime` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8 COMMENT='分类表';

-- ----------------------------
-- Records of jay_categories
-- ----------------------------
INSERT INTO `jay_categories` VALUES ('1', '0', '关于我们', '1', null);
INSERT INTO `jay_categories` VALUES ('2', '0', '啤酒', '2', null);
INSERT INTO `jay_categories` VALUES ('3', '0', '新闻', '3', null);
INSERT INTO `jay_categories` VALUES ('4', '0', '活动', '4', null);
INSERT INTO `jay_categories` VALUES ('5', '0', '周边', '5', null);
INSERT INTO `jay_categories` VALUES ('6', '0', '门店类型', '2', null);
INSERT INTO `jay_categories` VALUES ('7', '0', '其他2', '7', null);
INSERT INTO `jay_categories` VALUES ('8', '0', '其他3', '8', null);
INSERT INTO `jay_categories` VALUES ('9', '3', '得奖', '9', '2017-11-21 17:07:26');
INSERT INTO `jay_categories` VALUES ('10', '3', '新酒', '1', '2017-11-21 17:06:53');
INSERT INTO `jay_categories` VALUES ('12', '3', '内部', '2', '2017-11-21 17:07:12');
INSERT INTO `jay_categories` VALUES ('13', '3', '媒体', '3', '2017-11-21 17:07:19');
INSERT INTO `jay_categories` VALUES ('15', '2', '最新啤酒', '3', '2017-11-22 11:16:35');
INSERT INTO `jay_categories` VALUES ('16', '2', '常年供应', '12', '2017-10-27 09:55:24');
INSERT INTO `jay_categories` VALUES ('17', '2', '季节性', '1', '2017-11-22 11:16:55');
INSERT INTO `jay_categories` VALUES ('18', '2', '合酿啤酒', '1', '2017-11-22 11:17:02');
INSERT INTO `jay_categories` VALUES ('19', '2', '啤酒教室', '1', '2017-11-22 11:17:10');
INSERT INTO `jay_categories` VALUES ('20', '4', '探险会', '1', '2017-11-29 20:09:47');
INSERT INTO `jay_categories` VALUES ('22', '4', '悦读会', '1', '2017-11-29 20:09:59');
INSERT INTO `jay_categories` VALUES ('23', '4', '禅悦会', '1', '2017-11-29 20:10:18');
INSERT INTO `jay_categories` VALUES ('25', '5', 'T恤', '1', '2017-11-22 11:17:27');
INSERT INTO `jay_categories` VALUES ('26', '5', '牛啤经', '1', '2017-11-22 11:17:34');
INSERT INTO `jay_categories` VALUES ('27', '5', '族谱图', '1', '2017-11-22 11:17:40');
INSERT INTO `jay_categories` VALUES ('28', '6', '直营店', '1', '2017-11-22 13:01:05');
INSERT INTO `jay_categories` VALUES ('29', '6', '销售代理', '2', '2017-11-22 13:01:15');
INSERT INTO `jay_categories` VALUES ('30', '4', '风水讲堂', '4', '2017-11-29 20:10:32');

-- ----------------------------
-- Table structure for `jay_city`
-- ----------------------------
DROP TABLE IF EXISTS `jay_city`;
CREATE TABLE `jay_city` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `city` varchar(50) NOT NULL,
  `pcode` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=346 DEFAULT CHARSET=utf8 COMMENT='行政区域地州市信息表';

-- ----------------------------
-- Records of jay_city
-- ----------------------------
INSERT INTO `jay_city` VALUES ('1', '110100', '市辖区', '110000');
INSERT INTO `jay_city` VALUES ('2', '110200', '县', '110000');
INSERT INTO `jay_city` VALUES ('3', '120100', '市辖区', '120000');
INSERT INTO `jay_city` VALUES ('4', '120200', '县', '120000');
INSERT INTO `jay_city` VALUES ('5', '130100', '石家庄市', '130000');
INSERT INTO `jay_city` VALUES ('6', '130200', '唐山市', '130000');
INSERT INTO `jay_city` VALUES ('7', '130300', '秦皇岛市', '130000');
INSERT INTO `jay_city` VALUES ('8', '130400', '邯郸市', '130000');
INSERT INTO `jay_city` VALUES ('9', '130500', '邢台市', '130000');
INSERT INTO `jay_city` VALUES ('10', '130600', '保定市', '130000');
INSERT INTO `jay_city` VALUES ('11', '130700', '张家口市', '130000');
INSERT INTO `jay_city` VALUES ('12', '130800', '承德市', '130000');
INSERT INTO `jay_city` VALUES ('13', '130900', '沧州市', '130000');
INSERT INTO `jay_city` VALUES ('14', '131000', '廊坊市', '130000');
INSERT INTO `jay_city` VALUES ('15', '131100', '衡水市', '130000');
INSERT INTO `jay_city` VALUES ('16', '140100', '太原市', '140000');
INSERT INTO `jay_city` VALUES ('17', '140200', '大同市', '140000');
INSERT INTO `jay_city` VALUES ('18', '140300', '阳泉市', '140000');
INSERT INTO `jay_city` VALUES ('19', '140400', '长治市', '140000');
INSERT INTO `jay_city` VALUES ('20', '140500', '晋城市', '140000');
INSERT INTO `jay_city` VALUES ('21', '140600', '朔州市', '140000');
INSERT INTO `jay_city` VALUES ('22', '140700', '晋中市', '140000');
INSERT INTO `jay_city` VALUES ('23', '140800', '运城市', '140000');
INSERT INTO `jay_city` VALUES ('24', '140900', '忻州市', '140000');
INSERT INTO `jay_city` VALUES ('25', '141000', '临汾市', '140000');
INSERT INTO `jay_city` VALUES ('26', '141100', '吕梁市', '140000');
INSERT INTO `jay_city` VALUES ('27', '150100', '呼和浩特市', '150000');
INSERT INTO `jay_city` VALUES ('28', '150200', '包头市', '150000');
INSERT INTO `jay_city` VALUES ('29', '150300', '乌海市', '150000');
INSERT INTO `jay_city` VALUES ('30', '150400', '赤峰市', '150000');
INSERT INTO `jay_city` VALUES ('31', '150500', '通辽市', '150000');
INSERT INTO `jay_city` VALUES ('32', '150600', '鄂尔多斯市', '150000');
INSERT INTO `jay_city` VALUES ('33', '150700', '呼伦贝尔市', '150000');
INSERT INTO `jay_city` VALUES ('34', '150800', '巴彦淖尔市', '150000');
INSERT INTO `jay_city` VALUES ('35', '150900', '乌兰察布市', '150000');
INSERT INTO `jay_city` VALUES ('36', '152200', '兴安盟', '150000');
INSERT INTO `jay_city` VALUES ('37', '152500', '锡林郭勒盟', '150000');
INSERT INTO `jay_city` VALUES ('38', '152900', '阿拉善盟', '150000');
INSERT INTO `jay_city` VALUES ('39', '210100', '沈阳市', '210000');
INSERT INTO `jay_city` VALUES ('40', '210200', '大连市', '210000');
INSERT INTO `jay_city` VALUES ('41', '210300', '鞍山市', '210000');
INSERT INTO `jay_city` VALUES ('42', '210400', '抚顺市', '210000');
INSERT INTO `jay_city` VALUES ('43', '210500', '本溪市', '210000');
INSERT INTO `jay_city` VALUES ('44', '210600', '丹东市', '210000');
INSERT INTO `jay_city` VALUES ('45', '210700', '锦州市', '210000');
INSERT INTO `jay_city` VALUES ('46', '210800', '营口市', '210000');
INSERT INTO `jay_city` VALUES ('47', '210900', '阜新市', '210000');
INSERT INTO `jay_city` VALUES ('48', '211000', '辽阳市', '210000');
INSERT INTO `jay_city` VALUES ('49', '211100', '盘锦市', '210000');
INSERT INTO `jay_city` VALUES ('50', '211200', '铁岭市', '210000');
INSERT INTO `jay_city` VALUES ('51', '211300', '朝阳市', '210000');
INSERT INTO `jay_city` VALUES ('52', '211400', '葫芦岛市', '210000');
INSERT INTO `jay_city` VALUES ('53', '220100', '长春市', '220000');
INSERT INTO `jay_city` VALUES ('54', '220200', '吉林市', '220000');
INSERT INTO `jay_city` VALUES ('55', '220300', '四平市', '220000');
INSERT INTO `jay_city` VALUES ('56', '220400', '辽源市', '220000');
INSERT INTO `jay_city` VALUES ('57', '220500', '通化市', '220000');
INSERT INTO `jay_city` VALUES ('58', '220600', '白山市', '220000');
INSERT INTO `jay_city` VALUES ('59', '220700', '松原市', '220000');
INSERT INTO `jay_city` VALUES ('60', '220800', '白城市', '220000');
INSERT INTO `jay_city` VALUES ('61', '222400', '延边朝鲜族自治州', '220000');
INSERT INTO `jay_city` VALUES ('62', '230100', '哈尔滨市', '230000');
INSERT INTO `jay_city` VALUES ('63', '230200', '齐齐哈尔市', '230000');
INSERT INTO `jay_city` VALUES ('64', '230300', '鸡西市', '230000');
INSERT INTO `jay_city` VALUES ('65', '230400', '鹤岗市', '230000');
INSERT INTO `jay_city` VALUES ('66', '230500', '双鸭山市', '230000');
INSERT INTO `jay_city` VALUES ('67', '230600', '大庆市', '230000');
INSERT INTO `jay_city` VALUES ('68', '230700', '伊春市', '230000');
INSERT INTO `jay_city` VALUES ('69', '230800', '佳木斯市', '230000');
INSERT INTO `jay_city` VALUES ('70', '230900', '七台河市', '230000');
INSERT INTO `jay_city` VALUES ('71', '231000', '牡丹江市', '230000');
INSERT INTO `jay_city` VALUES ('72', '231100', '黑河市', '230000');
INSERT INTO `jay_city` VALUES ('73', '231200', '绥化市', '230000');
INSERT INTO `jay_city` VALUES ('74', '232700', '大兴安岭地区', '230000');
INSERT INTO `jay_city` VALUES ('75', '310100', '市辖区', '310000');
INSERT INTO `jay_city` VALUES ('76', '310200', '县', '310000');
INSERT INTO `jay_city` VALUES ('77', '320100', '南京市', '320000');
INSERT INTO `jay_city` VALUES ('78', '320200', '无锡市', '320000');
INSERT INTO `jay_city` VALUES ('79', '320300', '徐州市', '320000');
INSERT INTO `jay_city` VALUES ('80', '320400', '常州市', '320000');
INSERT INTO `jay_city` VALUES ('81', '320500', '苏州市', '320000');
INSERT INTO `jay_city` VALUES ('82', '320600', '南通市', '320000');
INSERT INTO `jay_city` VALUES ('83', '320700', '连云港市', '320000');
INSERT INTO `jay_city` VALUES ('84', '320800', '淮安市', '320000');
INSERT INTO `jay_city` VALUES ('85', '320900', '盐城市', '320000');
INSERT INTO `jay_city` VALUES ('86', '321000', '扬州市', '320000');
INSERT INTO `jay_city` VALUES ('87', '321100', '镇江市', '320000');
INSERT INTO `jay_city` VALUES ('88', '321200', '泰州市', '320000');
INSERT INTO `jay_city` VALUES ('89', '321300', '宿迁市', '320000');
INSERT INTO `jay_city` VALUES ('90', '330100', '杭州市', '330000');
INSERT INTO `jay_city` VALUES ('91', '330200', '宁波市', '330000');
INSERT INTO `jay_city` VALUES ('92', '330300', '温州市', '330000');
INSERT INTO `jay_city` VALUES ('93', '330400', '嘉兴市', '330000');
INSERT INTO `jay_city` VALUES ('94', '330500', '湖州市', '330000');
INSERT INTO `jay_city` VALUES ('95', '330600', '绍兴市', '330000');
INSERT INTO `jay_city` VALUES ('96', '330700', '金华市', '330000');
INSERT INTO `jay_city` VALUES ('97', '330800', '衢州市', '330000');
INSERT INTO `jay_city` VALUES ('98', '330900', '舟山市', '330000');
INSERT INTO `jay_city` VALUES ('99', '331000', '台州市', '330000');
INSERT INTO `jay_city` VALUES ('100', '331100', '丽水市', '330000');
INSERT INTO `jay_city` VALUES ('101', '340100', '合肥市', '340000');
INSERT INTO `jay_city` VALUES ('102', '340200', '芜湖市', '340000');
INSERT INTO `jay_city` VALUES ('103', '340300', '蚌埠市', '340000');
INSERT INTO `jay_city` VALUES ('104', '340400', '淮南市', '340000');
INSERT INTO `jay_city` VALUES ('105', '340500', '马鞍山市', '340000');
INSERT INTO `jay_city` VALUES ('106', '340600', '淮北市', '340000');
INSERT INTO `jay_city` VALUES ('107', '340700', '铜陵市', '340000');
INSERT INTO `jay_city` VALUES ('108', '340800', '安庆市', '340000');
INSERT INTO `jay_city` VALUES ('109', '341000', '黄山市', '340000');
INSERT INTO `jay_city` VALUES ('110', '341100', '滁州市', '340000');
INSERT INTO `jay_city` VALUES ('111', '341200', '阜阳市', '340000');
INSERT INTO `jay_city` VALUES ('112', '341300', '宿州市', '340000');
INSERT INTO `jay_city` VALUES ('113', '341400', '巢湖市', '340000');
INSERT INTO `jay_city` VALUES ('114', '341500', '六安市', '340000');
INSERT INTO `jay_city` VALUES ('115', '341600', '亳州市', '340000');
INSERT INTO `jay_city` VALUES ('116', '341700', '池州市', '340000');
INSERT INTO `jay_city` VALUES ('117', '341800', '宣城市', '340000');
INSERT INTO `jay_city` VALUES ('118', '350100', '福州市', '350000');
INSERT INTO `jay_city` VALUES ('119', '350200', '厦门市', '350000');
INSERT INTO `jay_city` VALUES ('120', '350300', '莆田市', '350000');
INSERT INTO `jay_city` VALUES ('121', '350400', '三明市', '350000');
INSERT INTO `jay_city` VALUES ('122', '350500', '泉州市', '350000');
INSERT INTO `jay_city` VALUES ('123', '350600', '漳州市', '350000');
INSERT INTO `jay_city` VALUES ('124', '350700', '南平市', '350000');
INSERT INTO `jay_city` VALUES ('125', '350800', '龙岩市', '350000');
INSERT INTO `jay_city` VALUES ('126', '350900', '宁德市', '350000');
INSERT INTO `jay_city` VALUES ('127', '360100', '南昌市', '360000');
INSERT INTO `jay_city` VALUES ('128', '360200', '景德镇市', '360000');
INSERT INTO `jay_city` VALUES ('129', '360300', '萍乡市', '360000');
INSERT INTO `jay_city` VALUES ('130', '360400', '九江市', '360000');
INSERT INTO `jay_city` VALUES ('131', '360500', '新余市', '360000');
INSERT INTO `jay_city` VALUES ('132', '360600', '鹰潭市', '360000');
INSERT INTO `jay_city` VALUES ('133', '360700', '赣州市', '360000');
INSERT INTO `jay_city` VALUES ('134', '360800', '吉安市', '360000');
INSERT INTO `jay_city` VALUES ('135', '360900', '宜春市', '360000');
INSERT INTO `jay_city` VALUES ('136', '361000', '抚州市', '360000');
INSERT INTO `jay_city` VALUES ('137', '361100', '上饶市', '360000');
INSERT INTO `jay_city` VALUES ('138', '370100', '济南市', '370000');
INSERT INTO `jay_city` VALUES ('139', '370200', '青岛市', '370000');
INSERT INTO `jay_city` VALUES ('140', '370300', '淄博市', '370000');
INSERT INTO `jay_city` VALUES ('141', '370400', '枣庄市', '370000');
INSERT INTO `jay_city` VALUES ('142', '370500', '东营市', '370000');
INSERT INTO `jay_city` VALUES ('143', '370600', '烟台市', '370000');
INSERT INTO `jay_city` VALUES ('144', '370700', '潍坊市', '370000');
INSERT INTO `jay_city` VALUES ('145', '370800', '济宁市', '370000');
INSERT INTO `jay_city` VALUES ('146', '370900', '泰安市', '370000');
INSERT INTO `jay_city` VALUES ('147', '371000', '威海市', '370000');
INSERT INTO `jay_city` VALUES ('148', '371100', '日照市', '370000');
INSERT INTO `jay_city` VALUES ('149', '371200', '莱芜市', '370000');
INSERT INTO `jay_city` VALUES ('150', '371300', '临沂市', '370000');
INSERT INTO `jay_city` VALUES ('151', '371400', '德州市', '370000');
INSERT INTO `jay_city` VALUES ('152', '371500', '聊城市', '370000');
INSERT INTO `jay_city` VALUES ('153', '371600', '滨州市', '370000');
INSERT INTO `jay_city` VALUES ('154', '371700', '荷泽市', '370000');
INSERT INTO `jay_city` VALUES ('155', '410100', '郑州市', '410000');
INSERT INTO `jay_city` VALUES ('156', '410200', '开封市', '410000');
INSERT INTO `jay_city` VALUES ('157', '410300', '洛阳市', '410000');
INSERT INTO `jay_city` VALUES ('158', '410400', '平顶山市', '410000');
INSERT INTO `jay_city` VALUES ('159', '410500', '安阳市', '410000');
INSERT INTO `jay_city` VALUES ('160', '410600', '鹤壁市', '410000');
INSERT INTO `jay_city` VALUES ('161', '410700', '新乡市', '410000');
INSERT INTO `jay_city` VALUES ('162', '410800', '焦作市', '410000');
INSERT INTO `jay_city` VALUES ('163', '410900', '濮阳市', '410000');
INSERT INTO `jay_city` VALUES ('164', '411000', '许昌市', '410000');
INSERT INTO `jay_city` VALUES ('165', '411100', '漯河市', '410000');
INSERT INTO `jay_city` VALUES ('166', '411200', '三门峡市', '410000');
INSERT INTO `jay_city` VALUES ('167', '411300', '南阳市', '410000');
INSERT INTO `jay_city` VALUES ('168', '411400', '商丘市', '410000');
INSERT INTO `jay_city` VALUES ('169', '411500', '信阳市', '410000');
INSERT INTO `jay_city` VALUES ('170', '411600', '周口市', '410000');
INSERT INTO `jay_city` VALUES ('171', '411700', '驻马店市', '410000');
INSERT INTO `jay_city` VALUES ('172', '420100', '武汉市', '420000');
INSERT INTO `jay_city` VALUES ('173', '420200', '黄石市', '420000');
INSERT INTO `jay_city` VALUES ('174', '420300', '十堰市', '420000');
INSERT INTO `jay_city` VALUES ('175', '420500', '宜昌市', '420000');
INSERT INTO `jay_city` VALUES ('176', '420600', '襄樊市', '420000');
INSERT INTO `jay_city` VALUES ('177', '420700', '鄂州市', '420000');
INSERT INTO `jay_city` VALUES ('178', '420800', '荆门市', '420000');
INSERT INTO `jay_city` VALUES ('179', '420900', '孝感市', '420000');
INSERT INTO `jay_city` VALUES ('180', '421000', '荆州市', '420000');
INSERT INTO `jay_city` VALUES ('181', '421100', '黄冈市', '420000');
INSERT INTO `jay_city` VALUES ('182', '421200', '咸宁市', '420000');
INSERT INTO `jay_city` VALUES ('183', '421300', '随州市', '420000');
INSERT INTO `jay_city` VALUES ('184', '422800', '恩施土家族苗族自治州', '420000');
INSERT INTO `jay_city` VALUES ('185', '429000', '省直辖行政单位', '420000');
INSERT INTO `jay_city` VALUES ('186', '430100', '长沙市', '430000');
INSERT INTO `jay_city` VALUES ('187', '430200', '株洲市', '430000');
INSERT INTO `jay_city` VALUES ('188', '430300', '湘潭市', '430000');
INSERT INTO `jay_city` VALUES ('189', '430400', '衡阳市', '430000');
INSERT INTO `jay_city` VALUES ('190', '430500', '邵阳市', '430000');
INSERT INTO `jay_city` VALUES ('191', '430600', '岳阳市', '430000');
INSERT INTO `jay_city` VALUES ('192', '430700', '常德市', '430000');
INSERT INTO `jay_city` VALUES ('193', '430800', '张家界市', '430000');
INSERT INTO `jay_city` VALUES ('194', '430900', '益阳市', '430000');
INSERT INTO `jay_city` VALUES ('195', '431000', '郴州市', '430000');
INSERT INTO `jay_city` VALUES ('196', '431100', '永州市', '430000');
INSERT INTO `jay_city` VALUES ('197', '431200', '怀化市', '430000');
INSERT INTO `jay_city` VALUES ('198', '431300', '娄底市', '430000');
INSERT INTO `jay_city` VALUES ('199', '433100', '湘西土家族苗族自治州', '430000');
INSERT INTO `jay_city` VALUES ('200', '440100', '广州市', '440000');
INSERT INTO `jay_city` VALUES ('201', '440200', '韶关市', '440000');
INSERT INTO `jay_city` VALUES ('202', '440300', '深圳市', '440000');
INSERT INTO `jay_city` VALUES ('203', '440400', '珠海市', '440000');
INSERT INTO `jay_city` VALUES ('204', '440500', '汕头市', '440000');
INSERT INTO `jay_city` VALUES ('205', '440600', '佛山市', '440000');
INSERT INTO `jay_city` VALUES ('206', '440700', '江门市', '440000');
INSERT INTO `jay_city` VALUES ('207', '440800', '湛江市', '440000');
INSERT INTO `jay_city` VALUES ('208', '440900', '茂名市', '440000');
INSERT INTO `jay_city` VALUES ('209', '441200', '肇庆市', '440000');
INSERT INTO `jay_city` VALUES ('210', '441300', '惠州市', '440000');
INSERT INTO `jay_city` VALUES ('211', '441400', '梅州市', '440000');
INSERT INTO `jay_city` VALUES ('212', '441500', '汕尾市', '440000');
INSERT INTO `jay_city` VALUES ('213', '441600', '河源市', '440000');
INSERT INTO `jay_city` VALUES ('214', '441700', '阳江市', '440000');
INSERT INTO `jay_city` VALUES ('215', '441800', '清远市', '440000');
INSERT INTO `jay_city` VALUES ('216', '441900', '东莞市', '440000');
INSERT INTO `jay_city` VALUES ('217', '442000', '中山市', '440000');
INSERT INTO `jay_city` VALUES ('218', '445100', '潮州市', '440000');
INSERT INTO `jay_city` VALUES ('219', '445200', '揭阳市', '440000');
INSERT INTO `jay_city` VALUES ('220', '445300', '云浮市', '440000');
INSERT INTO `jay_city` VALUES ('221', '450100', '南宁市', '450000');
INSERT INTO `jay_city` VALUES ('222', '450200', '柳州市', '450000');
INSERT INTO `jay_city` VALUES ('223', '450300', '桂林市', '450000');
INSERT INTO `jay_city` VALUES ('224', '450400', '梧州市', '450000');
INSERT INTO `jay_city` VALUES ('225', '450500', '北海市', '450000');
INSERT INTO `jay_city` VALUES ('226', '450600', '防城港市', '450000');
INSERT INTO `jay_city` VALUES ('227', '450700', '钦州市', '450000');
INSERT INTO `jay_city` VALUES ('228', '450800', '贵港市', '450000');
INSERT INTO `jay_city` VALUES ('229', '450900', '玉林市', '450000');
INSERT INTO `jay_city` VALUES ('230', '451000', '百色市', '450000');
INSERT INTO `jay_city` VALUES ('231', '451100', '贺州市', '450000');
INSERT INTO `jay_city` VALUES ('232', '451200', '河池市', '450000');
INSERT INTO `jay_city` VALUES ('233', '451300', '来宾市', '450000');
INSERT INTO `jay_city` VALUES ('234', '451400', '崇左市', '450000');
INSERT INTO `jay_city` VALUES ('235', '460100', '海口市', '460000');
INSERT INTO `jay_city` VALUES ('236', '460200', '三亚市', '460000');
INSERT INTO `jay_city` VALUES ('237', '469000', '省直辖县级行政单位', '460000');
INSERT INTO `jay_city` VALUES ('238', '500100', '市辖区', '500000');
INSERT INTO `jay_city` VALUES ('239', '500200', '县', '500000');
INSERT INTO `jay_city` VALUES ('240', '500300', '市', '500000');
INSERT INTO `jay_city` VALUES ('241', '510100', '成都市', '510000');
INSERT INTO `jay_city` VALUES ('242', '510300', '自贡市', '510000');
INSERT INTO `jay_city` VALUES ('243', '510400', '攀枝花市', '510000');
INSERT INTO `jay_city` VALUES ('244', '510500', '泸州市', '510000');
INSERT INTO `jay_city` VALUES ('245', '510600', '德阳市', '510000');
INSERT INTO `jay_city` VALUES ('246', '510700', '绵阳市', '510000');
INSERT INTO `jay_city` VALUES ('247', '510800', '广元市', '510000');
INSERT INTO `jay_city` VALUES ('248', '510900', '遂宁市', '510000');
INSERT INTO `jay_city` VALUES ('249', '511000', '内江市', '510000');
INSERT INTO `jay_city` VALUES ('250', '511100', '乐山市', '510000');
INSERT INTO `jay_city` VALUES ('251', '511300', '南充市', '510000');
INSERT INTO `jay_city` VALUES ('252', '511400', '眉山市', '510000');
INSERT INTO `jay_city` VALUES ('253', '511500', '宜宾市', '510000');
INSERT INTO `jay_city` VALUES ('254', '511600', '广安市', '510000');
INSERT INTO `jay_city` VALUES ('255', '511700', '达州市', '510000');
INSERT INTO `jay_city` VALUES ('256', '511800', '雅安市', '510000');
INSERT INTO `jay_city` VALUES ('257', '511900', '巴中市', '510000');
INSERT INTO `jay_city` VALUES ('258', '512000', '资阳市', '510000');
INSERT INTO `jay_city` VALUES ('259', '513200', '阿坝藏族羌族自治州', '510000');
INSERT INTO `jay_city` VALUES ('260', '513300', '甘孜藏族自治州', '510000');
INSERT INTO `jay_city` VALUES ('261', '513400', '凉山彝族自治州', '510000');
INSERT INTO `jay_city` VALUES ('262', '520100', '贵阳市', '520000');
INSERT INTO `jay_city` VALUES ('263', '520200', '六盘水市', '520000');
INSERT INTO `jay_city` VALUES ('264', '520300', '遵义市', '520000');
INSERT INTO `jay_city` VALUES ('265', '520400', '安顺市', '520000');
INSERT INTO `jay_city` VALUES ('266', '522200', '铜仁地区', '520000');
INSERT INTO `jay_city` VALUES ('267', '522300', '黔西南布依族苗族自治州', '520000');
INSERT INTO `jay_city` VALUES ('268', '522400', '毕节地区', '520000');
INSERT INTO `jay_city` VALUES ('269', '522600', '黔东南苗族侗族自治州', '520000');
INSERT INTO `jay_city` VALUES ('270', '522700', '黔南布依族苗族自治州', '520000');
INSERT INTO `jay_city` VALUES ('271', '530100', '昆明市', '530000');
INSERT INTO `jay_city` VALUES ('272', '530300', '曲靖市', '530000');
INSERT INTO `jay_city` VALUES ('273', '530400', '玉溪市', '530000');
INSERT INTO `jay_city` VALUES ('274', '530500', '保山市', '530000');
INSERT INTO `jay_city` VALUES ('275', '530600', '昭通市', '530000');
INSERT INTO `jay_city` VALUES ('276', '530700', '丽江市', '530000');
INSERT INTO `jay_city` VALUES ('277', '530800', '思茅市', '530000');
INSERT INTO `jay_city` VALUES ('278', '530900', '临沧市', '530000');
INSERT INTO `jay_city` VALUES ('279', '532300', '楚雄彝族自治州', '530000');
INSERT INTO `jay_city` VALUES ('280', '532500', '红河哈尼族彝族自治州', '530000');
INSERT INTO `jay_city` VALUES ('281', '532600', '文山壮族苗族自治州', '530000');
INSERT INTO `jay_city` VALUES ('282', '532800', '西双版纳傣族自治州', '530000');
INSERT INTO `jay_city` VALUES ('283', '532900', '大理白族自治州', '530000');
INSERT INTO `jay_city` VALUES ('284', '533100', '德宏傣族景颇族自治州', '530000');
INSERT INTO `jay_city` VALUES ('285', '533300', '怒江傈僳族自治州', '530000');
INSERT INTO `jay_city` VALUES ('286', '533400', '迪庆藏族自治州', '530000');
INSERT INTO `jay_city` VALUES ('287', '540100', '拉萨市', '540000');
INSERT INTO `jay_city` VALUES ('288', '542100', '昌都地区', '540000');
INSERT INTO `jay_city` VALUES ('289', '542200', '山南地区', '540000');
INSERT INTO `jay_city` VALUES ('290', '542300', '日喀则地区', '540000');
INSERT INTO `jay_city` VALUES ('291', '542400', '那曲地区', '540000');
INSERT INTO `jay_city` VALUES ('292', '542500', '阿里地区', '540000');
INSERT INTO `jay_city` VALUES ('293', '542600', '林芝地区', '540000');
INSERT INTO `jay_city` VALUES ('294', '610100', '西安市', '610000');
INSERT INTO `jay_city` VALUES ('295', '610200', '铜川市', '610000');
INSERT INTO `jay_city` VALUES ('296', '610300', '宝鸡市', '610000');
INSERT INTO `jay_city` VALUES ('297', '610400', '咸阳市', '610000');
INSERT INTO `jay_city` VALUES ('298', '610500', '渭南市', '610000');
INSERT INTO `jay_city` VALUES ('299', '610600', '延安市', '610000');
INSERT INTO `jay_city` VALUES ('300', '610700', '汉中市', '610000');
INSERT INTO `jay_city` VALUES ('301', '610800', '榆林市', '610000');
INSERT INTO `jay_city` VALUES ('302', '610900', '安康市', '610000');
INSERT INTO `jay_city` VALUES ('303', '611000', '商洛市', '610000');
INSERT INTO `jay_city` VALUES ('304', '620100', '兰州市', '620000');
INSERT INTO `jay_city` VALUES ('305', '620200', '嘉峪关市', '620000');
INSERT INTO `jay_city` VALUES ('306', '620300', '金昌市', '620000');
INSERT INTO `jay_city` VALUES ('307', '620400', '白银市', '620000');
INSERT INTO `jay_city` VALUES ('308', '620500', '天水市', '620000');
INSERT INTO `jay_city` VALUES ('309', '620600', '武威市', '620000');
INSERT INTO `jay_city` VALUES ('310', '620700', '张掖市', '620000');
INSERT INTO `jay_city` VALUES ('311', '620800', '平凉市', '620000');
INSERT INTO `jay_city` VALUES ('312', '620900', '酒泉市', '620000');
INSERT INTO `jay_city` VALUES ('313', '621000', '庆阳市', '620000');
INSERT INTO `jay_city` VALUES ('314', '621100', '定西市', '620000');
INSERT INTO `jay_city` VALUES ('315', '621200', '陇南市', '620000');
INSERT INTO `jay_city` VALUES ('316', '622900', '临夏回族自治州', '620000');
INSERT INTO `jay_city` VALUES ('317', '623000', '甘南藏族自治州', '620000');
INSERT INTO `jay_city` VALUES ('318', '630100', '西宁市', '630000');
INSERT INTO `jay_city` VALUES ('319', '632100', '海东地区', '630000');
INSERT INTO `jay_city` VALUES ('320', '632200', '海北藏族自治州', '630000');
INSERT INTO `jay_city` VALUES ('321', '632300', '黄南藏族自治州', '630000');
INSERT INTO `jay_city` VALUES ('322', '632500', '海南藏族自治州', '630000');
INSERT INTO `jay_city` VALUES ('323', '632600', '果洛藏族自治州', '630000');
INSERT INTO `jay_city` VALUES ('324', '632700', '玉树藏族自治州', '630000');
INSERT INTO `jay_city` VALUES ('325', '632800', '海西蒙古族藏族自治州', '630000');
INSERT INTO `jay_city` VALUES ('326', '640100', '银川市', '640000');
INSERT INTO `jay_city` VALUES ('327', '640200', '石嘴山市', '640000');
INSERT INTO `jay_city` VALUES ('328', '640300', '吴忠市', '640000');
INSERT INTO `jay_city` VALUES ('329', '640400', '固原市', '640000');
INSERT INTO `jay_city` VALUES ('330', '640500', '中卫市', '640000');
INSERT INTO `jay_city` VALUES ('331', '650100', '乌鲁木齐市', '650000');
INSERT INTO `jay_city` VALUES ('332', '650200', '克拉玛依市', '650000');
INSERT INTO `jay_city` VALUES ('333', '652100', '吐鲁番地区', '650000');
INSERT INTO `jay_city` VALUES ('334', '652200', '哈密地区', '650000');
INSERT INTO `jay_city` VALUES ('335', '652300', '昌吉回族自治州', '650000');
INSERT INTO `jay_city` VALUES ('336', '652700', '博尔塔拉蒙古自治州', '650000');
INSERT INTO `jay_city` VALUES ('337', '652800', '巴音郭楞蒙古自治州', '650000');
INSERT INTO `jay_city` VALUES ('338', '652900', '阿克苏地区', '650000');
INSERT INTO `jay_city` VALUES ('339', '653000', '克孜勒苏柯尔克孜自治州', '650000');
INSERT INTO `jay_city` VALUES ('340', '653100', '喀什地区', '650000');
INSERT INTO `jay_city` VALUES ('341', '653200', '和田地区', '650000');
INSERT INTO `jay_city` VALUES ('342', '654000', '伊犁哈萨克自治州', '650000');
INSERT INTO `jay_city` VALUES ('343', '654200', '塔城地区', '650000');
INSERT INTO `jay_city` VALUES ('344', '654300', '阿勒泰地区', '650000');
INSERT INTO `jay_city` VALUES ('345', '659000', '省直辖行政单位', '650000');

-- ----------------------------
-- Table structure for `jay_content`
-- ----------------------------
DROP TABLE IF EXISTS `jay_content`;
CREATE TABLE `jay_content` (
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `cat_id` smallint(5) NOT NULL DEFAULT '0' COMMENT '类别ID',
  `section` int(11) DEFAULT '0' COMMENT '大分类id',
  `title` varchar(150) NOT NULL DEFAULT '' COMMENT '文章标题',
  `content` longtext NOT NULL COMMENT '文章内容',
  `descp` varchar(255) DEFAULT NULL,
  `pic` varchar(50) DEFAULT '' COMMENT '文章缩略图',
  `status` tinyint(4) DEFAULT '1' COMMENT '1正常 0不显示',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `sort` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cat_id` (`cat_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1159 DEFAULT CHARSET=utf8 COMMENT='活动表';

-- ----------------------------
-- Records of jay_content
-- ----------------------------
INSERT INTO `jay_content` VALUES ('1', '7', '3', '保修日期', '<p>本产品全国联保，享受三包服务，质保期为：全国联保一年<br/>\r\n &nbsp; &nbsp; &nbsp; &nbsp; 如因质量问题享受7日内退货，15日内换货，15日以上在质保期内享受免费保修等三包服务！</p>', null, '', '1', '0', null);
INSERT INTO `jay_content` VALUES ('26', '88', '3', '商城手机版', '&lt;p&gt;TPshop的特色功能&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;手机移动端&lt;/p&gt;&lt;p&gt;1、 界面设计更为美观，更容易安全信任 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、 代码量少，访问速度快&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、 PC端功能在移动端实现并改进 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、 购物体验优良&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、 活动形式丰富（活动，优惠，特价 , 捆绑等） &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;6、 移动与PC信息同步， 支持APP套壳&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、 移动端网站有助于提升SEO&lt;/p&gt;&lt;p&gt;多语言站群&lt;/p&gt;&lt;p&gt;1、多个网站的集合，可统一管理会员/订单，商品信息&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、商品SEO信息可不同，不同域名绑定不同模板&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、对于一些内容或者配置都可分别进行设置&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、可同时支持分销站点，多语言子站，移动端，APP接入&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、开放API支持后端ERP对接业务对接&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;丰富的营销体系&lt;/p&gt;&lt;p&gt;系统支持 购物车活动、商品优惠、优惠券、积分抵用、成长值升级、\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;限时特价、商品包邮、捆绑销售等十多种促销活动手段，给客户更多的实惠，增强网站的粘度。&lt;/p&gt;&lt;p&gt;完善的事件中心&lt;/p&gt;&lt;p&gt;系统支持执行常用事件例如下订单，注册、付款成功、评论、发货等事件时触发邮件、积分、优惠券、\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;站内信、成长值等。&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;良好的购物体验&lt;/p&gt;&lt;p&gt;1、支持在列表快速加入购物车&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、支持10+多第三方联合登陆，缩短注册时间&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、可在一页完成地址，配送，支付的信息填写并且提交\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、支持PAYPAL快捷支付且支持游客下单，缩短购物时间&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、支持在线购物车，PC与移动端同步&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;6、购物车流程更专业更值得信任&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、支持后台未支付订单催款，未下单用户催单&lt;/p&gt;&lt;p&gt;改良版搜索体系&lt;/p&gt;&lt;p&gt;搜索是商品最重要入口，系统集成搜索联想、搜索拦截、\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;热门搜索、底纹搜索、全文搜索。&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;利于SEO优化&lt;/p&gt;&lt;p&gt;1、 全站95%代码DIV+CSS&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、 重要页面支持SEO修改&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、 全站生成.HTML 静态地址&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;4、 支持谷歌微格式&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、 商品评论批量伪造&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;6、 Sitemap发布，404设置，Wordpress博客&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、 商品，分类，新闻，标签，品牌等支持自定义URL链接&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;8、 代码更为精简，打开速度更快&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;9、 自带移动端，更利于移动搜索以及排名&lt;/p&gt;&lt;p&gt;商品展示体系&lt;/p&gt;&lt;p&gt;商品的排列支持按照分类，品牌，标签，特价，\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;每日更新，属性筛选&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;API对接&lt;/p&gt;&lt;p&gt;1、订单对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;2、商品推送 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;3、发货对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;4、月销量对接 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;5、库存对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;6、产品抓取对接 &lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;7、会员对接&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;8、更多API开放&lt;/p&gt;&lt;p&gt;操作更加简单&lt;/p&gt;&lt;p&gt;1、图文教程，视频教程，后台中文化，操作更加符合国人操作习惯。&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、付费高级用户又可以享受远程协助、电话服务、技术实施等服务。&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;&lt;/p&gt;&lt;p&gt;支付物流完整&lt;/p&gt;&lt;p&gt;1、系统与Paypal、MoneyBookers、国际支付宝、Worldpay、GlobalCollect等主流第三方支付预先整合。&lt;br/&gt;\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;2、支持Fedex,DHL,TNT,UPS等物流方式，且支持个性化的物流计算方式，同时支持运费险又可帮客户减少风险。&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, '', '1', '0', null);
INSERT INTO `jay_content` VALUES ('28', '10', '3', '环境要求', '&lt;p&gt;PHP5.4以上版本&lt;/p&gt;&lt;p&gt;Mysql 5.5以上&lt;br/&gt;&lt;/p&gt;&lt;p&gt;支持的服务器和数据库环境&lt;/p&gt;&lt;p&gt;支持Windows/linux服务器环境&lt;/p&gt;&lt;p&gt;可运行于包括Apache、IIS和nginx在内的多种WEB服务器和模式&lt;/p&gt;&lt;p&gt;采用 ThinkPHP3.2 开发 jquery 最新版 + bootstrap 最新版&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1450440900', null);
INSERT INTO `jay_content` VALUES ('29', '10', '3', '功能介绍', '&lt;p&gt;&amp;nbsp;简单实用的 商城功能.&amp;nbsp; 灵活的插件安装卸载, 齐全的视频教程 + 手册 不断的升级更新&lt;br/&gt;&lt;/p&gt;&lt;p&gt;TPshop 分为&amp;nbsp; PC端 + 微信端 + wap + app的android + ios&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1450441002', null);
INSERT INTO `jay_content` VALUES ('30', '10', '3', '模块介绍', '&lt;p&gt;TPshop模块介绍&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1450525815', null);
INSERT INTO `jay_content` VALUES ('31', '10', '2', 'tpshop目录结构介绍', '&lt;p&gt;&lt;img src=&quot;/Public/upload/article/2016/05-16/57389ea781868.png&quot; title=&quot;TPshop目录结构.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;以上图可以看出 TPshop目录结构非常简洁。&amp;nbsp; Application 下面 四个模块 分别是 Admin Api Home Mobile&amp;nbsp; 访问某个模块时是 域名/index.php/模块名称&lt;br/&gt;比如访问手机模块 www.tp-shop.cn/index.php/Mobile &lt;br/&gt;Runtime 是tpshop 的整个缓存文件夹 缓存了一些临时数据， 其中 Html 是静态页面缓存。&amp;nbsp; 如果需要清空缓存点击管理员后台右上角清楚缓存。&lt;br/&gt;如果需要修改缓存时间 可以修改index.php 页面的 define(&amp;#39;TPSHOP_CACHE_TIME&amp;#39;,1); // TPshop 缓存时间 把缓存时间改为 1秒钟&lt;br/&gt;静态页面文件在缓存在 Application\\Home\\Conf\\config.php 中配置， 看如下配置， 每行注释写的很清楚&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;pre class=&quot;brush:php;toolbar:false&quot;&gt;&amp;#39;HTML_CACHE_RULES&amp;#39;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;array(&amp;nbsp;&amp;nbsp;//&amp;nbsp;定义静态缓存规则\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;nbsp;定义格式1&amp;nbsp;数组方式\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;#39;静态地址&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;array(&amp;#39;静态规则&amp;#39;,&amp;nbsp;&amp;#39;有效期&amp;#39;,&amp;nbsp;&amp;#39;附加规则&amp;#39;),&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;index:index&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;首页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;#39;index:goodsList&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}&amp;#39;,300),&amp;nbsp;&amp;nbsp;//&amp;nbsp;列表页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;无参数&amp;nbsp;post&amp;nbsp;提交的很难缓存\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;index:goodsList&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{id}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;列表页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//ajax&amp;nbsp;请求的商品列表内容在&amp;nbsp;ajaxGoodsList&amp;nbsp;函数中&amp;nbsp;&amp;nbsp;S($keys,$html,300);&amp;nbsp;缓存\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;Goods:goodsInfo&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{id}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品详情页静态缓存&amp;nbsp;3秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;Goods:ajaxComment&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{goods_id}_{commentType}_{p}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品评论页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;Goods:ajaxConsult&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{goods_id}_{consult_type}_{p}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品咨询页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;nbsp;商品详情的规格价格缓存在&amp;nbsp;ajaxGoodsPrice&amp;nbsp;函数里面&amp;nbsp;S($keys,$price,300);//&amp;nbsp;缓存数据300秒&amp;nbsp;&amp;nbsp;\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;channel:index&amp;#39;=&amp;gt;array(&amp;#39;{:module}_{:controller}_{:action}_{id}&amp;#39;,TPSHOP_CACHE_TIME),&amp;nbsp;&amp;nbsp;//&amp;nbsp;列表页静态缓存&amp;nbsp;TPSHOP_CACHE_TIME秒钟\r\n),&lt;/pre&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;tpshop 上传的图片存贮在 \\Public\\upload&lt;br/&gt;tpshop 的插件目录在 \\plugins 里面包含 支付插件payment&amp;nbsp; 物流插件shipping&amp;nbsp; 已经登录插件login &amp;nbsp;&lt;br/&gt;tpshop 的模板在 \\Template\\pc&amp;nbsp; 和 \\Template\\mobile&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;tpshop 的公共配置文件目录 www\\Application\\Common 和 公共方法&lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;先来看看后台的切换模板。 &lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;/span&gt;&lt;br/&gt;&lt;img src=&quot;/Public/upload/article/2016/05-16/57389f31799d7.png&quot; title=&quot;模板切换.png&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;看上图切换模板其实就是修改了 Application\\Home\\Conf\\html.php 文件后台修改模板然后观察这个文件有什么变化， 如果是linux 这个文件必须有 写入权限&lt;br/&gt;看以下代码。 &lt;br/&gt;&lt;/span&gt;&lt;/p&gt;&lt;pre class=&quot;brush:php;toolbar:false&quot;&gt;&amp;lt;?php\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;return&amp;nbsp;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;VIEW_PATH&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;#39;./Template/pc/&amp;#39;,&amp;nbsp;//&amp;nbsp;改变某个模块的模板文件目录\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;DEFAULT_THEME&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;#39;default&amp;#39;,&amp;nbsp;//&amp;nbsp;模板名称&amp;nbsp;切换模板&amp;nbsp;就是修改这里\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;TMPL_PARSE_STRING&amp;#39;&amp;nbsp;&amp;nbsp;=&amp;gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;__PUBLIC__&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;/Common&amp;#39;,&amp;nbsp;//&amp;nbsp;更改默认的/Public&amp;nbsp;替换规则\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;__STATIC__&amp;#39;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;/Template/pc/default/Static&amp;#39;,&amp;nbsp;//&amp;nbsp;增加新的image&amp;nbsp;&amp;nbsp;css&amp;nbsp;js&amp;nbsp;&amp;nbsp;访问路径&amp;nbsp;&amp;nbsp;后面给&amp;nbsp;php&amp;nbsp;改了&amp;nbsp;&amp;nbsp;切换模板就是修改这里\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;//&amp;#39;DATA_CACHE_TIME&amp;#39;=&amp;gt;60,&amp;nbsp;//&amp;nbsp;查询缓存时间\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;);\r\n?&amp;gt;\r\n\r\n看了如果有什么不明白的&amp;nbsp;可以下方评论，&amp;nbsp;不需要登录注册可以评论，&amp;nbsp;我们的管理员会给&lt;/pre&gt;&lt;p&gt;&lt;span style=&quot;font-size: 18px;&quot;&gt;&lt;/span&gt;&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1450525867', null);
INSERT INTO `jay_content` VALUES ('32', '10', '2', 'TPshop表结构', '&lt;p&gt;TPshop数据表结构介绍&lt;/p&gt;&lt;pre class=&quot;brush:sql;toolbar:false&quot;&gt;\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_account_log`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`log_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`user_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`frozen_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;冻结金额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`rank_points`&amp;nbsp;mediumint(9)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`pay_points`&amp;nbsp;mediumint(9)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付积分&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`change_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`change_desc`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`change_type`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`log_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_id`&amp;nbsp;(`user_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_ad`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_ad`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`ad_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pid`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位置ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`media_type`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告类型&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_link`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;链接地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_code`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;图片地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`start_time`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;投放时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`end_time`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;结束时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link_man`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;添加人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link_email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;添加人邮箱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link_phone`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;添加人联系电话&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`click_count`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`enabled`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`ad_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`enabled`&amp;nbsp;(`enabled`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`position_id`&amp;nbsp;(`pid`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=6&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_ad_position`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_ad_position`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`position_id`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`position_name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位置名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_width`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位宽度&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ad_height`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告位高度&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`position_desc`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;广告描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`position_style`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;模板&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_open`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;0关闭1开启&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`position_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=4&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_admin`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_admin`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`admin_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户名&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`password`&amp;nbsp;varchar(32)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ec_salt`&amp;nbsp;varchar(10)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;秘钥&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_login`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_ip`&amp;nbsp;varchar(15)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_list`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;允许操作行为&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`nav_list`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`lang_type`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`agency_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`suppliers_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`todolist`&amp;nbsp;longtext,\r\n&amp;nbsp;&amp;nbsp;`role_id`&amp;nbsp;smallint(5)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`admin_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_name`&amp;nbsp;(`user_name`)&amp;nbsp;USING&amp;nbsp;BTREE,\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`agency_id`&amp;nbsp;(`agency_id`)&amp;nbsp;USING&amp;nbsp;BTREE\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=4&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_admin_role`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_admin_role`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`role_id`&amp;nbsp;smallint(6)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`role_name`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`act_list`&amp;nbsp;text&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;权限列表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`role_desc`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;角色描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`role_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_area_region`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_area_region`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`shipping_area_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`region_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`shipping_area_id`,`region_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_article`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_article`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`article_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`cat_id`&amp;nbsp;smallint(5)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;类别ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`title`&amp;nbsp;varchar(150)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;文章标题&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`content`&amp;nbsp;longtext&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`author`&amp;nbsp;varchar(30)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;文章作者&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`author_email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;作者邮箱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`keywords`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;关键字&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`article_type`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;2&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_open`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`file_url`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;附件地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`open_type`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`link`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;链接地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`description`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`article_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`cat_id`&amp;nbsp;(`cat_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=33&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8&amp;nbsp;ROW_FORMAT=DYNAMIC;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_article_cat`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_article_cat`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`cat_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`cat_name`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;类别名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`cat_type`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;夫级ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`show_in_nav`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`sort_order`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`cat_desc`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`keywords`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`cat_alias`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;别名标示&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`cat_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=16&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_back_goods`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_back_goods`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`rec_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`back_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;退货单ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`goods_sn`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`send_number`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_attr`&amp;nbsp;text&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品属性&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`rec_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`back_id`&amp;nbsp;(`back_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_id`&amp;nbsp;(`goods_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_back_order`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_back_order`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`back_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`delivery_sn`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货流水单号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_sn`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单编号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单iD&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`invoice_no`&amp;nbsp;varchar(50)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货单号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_id`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;物流id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_name`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;物流名字&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_user`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;操作人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`consignee`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`address`&amp;nbsp;varchar(250)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`country`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`province`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`city`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`district`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`sign_building`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`zipcode`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`tel`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`mobile`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`best_time`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`update_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`return_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`back_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_id`&amp;nbsp;(`user_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`order_id`&amp;nbsp;(`order_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_brand`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_brand`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`logo`&amp;nbsp;varchar(80)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌logo&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`desc`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`url`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=16&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_cart`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_cart`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;购物车表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`session_id`&amp;nbsp;char(32)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;session&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_sn`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品货号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`market_price`&amp;nbsp;decimal(10,2)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;市场价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_price`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;本店价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_num`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;购买数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_key`&amp;nbsp;varchar(64)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格key&amp;nbsp;对应tp_spec_goods_price&amp;nbsp;表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_key_name`&amp;nbsp;varchar(64)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格组合名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`bar_code`&amp;nbsp;varchar(64)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品条码&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`selected`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;购物车选中状态&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`session_id`&amp;nbsp;(`session_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=70&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_comment`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_comment`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`comment_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`username`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`content`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`rank`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;评论等级&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ip_address`&amp;nbsp;varchar(15)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_show`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否显示&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`comment_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`parent_id`&amp;nbsp;(`parent_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`id_value`&amp;nbsp;(`goods_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_config`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_config`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;smallint(6)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`value`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`inc_type`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`desc`&amp;nbsp;varchar(50)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=16&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_coupon`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_coupon`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(8)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;优惠券名字&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`type`&amp;nbsp;tinyint(1)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发放类型&amp;nbsp;1&amp;nbsp;按订单发放&amp;nbsp;2&amp;nbsp;注册&amp;nbsp;3&amp;nbsp;邀请&amp;nbsp;4&amp;nbsp;按用户发放&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`money`&amp;nbsp;decimal(6,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;优惠券金额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`condition`&amp;nbsp;decimal(6,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用条件&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`send_start_time`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发放开始时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`send_end_time`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发放结束时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`use_start_time`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用开始时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`use_end_time`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用结束时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`use_num`&amp;nbsp;int(6)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;已使用数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;添加时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`send_num`&amp;nbsp;int(6)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发放数量(按用户发放类型)&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=6&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_coupon_list`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_coupon_list`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(8)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`cid`&amp;nbsp;int(8)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;优惠券&amp;nbsp;对应coupon表id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`type`&amp;nbsp;tinyint(1)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发放类型&amp;nbsp;1&amp;nbsp;按订单发放&amp;nbsp;2&amp;nbsp;注册&amp;nbsp;3&amp;nbsp;邀请&amp;nbsp;4&amp;nbsp;按用户发放&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`uid`&amp;nbsp;int(8)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_id`&amp;nbsp;int(8)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`use_time`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`code`&amp;nbsp;varchar(10)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;优惠券兑换码&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=4&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_delivery_goods`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_delivery_goods`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`rec_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`delivery_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`product_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`product_sn`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`brand_name`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`goods_sn`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`is_real`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`extension_code`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`send_number`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_attr`&amp;nbsp;text,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`rec_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`delivery_id`&amp;nbsp;(`delivery_id`,`goods_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_id`&amp;nbsp;(`goods_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=15&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_delivery_order`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_delivery_order`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`delivery_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`delivery_sn`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`order_sn`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`order_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`invoice_no`&amp;nbsp;varchar(50)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_id`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_name`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_user`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`consignee`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`address`&amp;nbsp;varchar(250)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`country`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`province`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`city`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`district`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`sign_building`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`zipcode`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`tel`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`mobile`&amp;nbsp;varchar(60)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`best_time`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`postscript`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`how_oos`&amp;nbsp;varchar(120)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`insure_fee`&amp;nbsp;decimal(10,2)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_fee`&amp;nbsp;decimal(10,2)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`update_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`suppliers_id`&amp;nbsp;smallint(5)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`agency_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`delivery_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_id`&amp;nbsp;(`user_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`order_id`&amp;nbsp;(`order_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=12&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_goods`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_goods`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`cat_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;分类id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_sn`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品编号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`click_count`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;点击数&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`brand_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;品牌id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`kc_count`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;库存数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pl_count`&amp;nbsp;smallint(5)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品评论数&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`weight`&amp;nbsp;int(11)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品重量克为单位&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`market_price`&amp;nbsp;decimal(10,2)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;市场价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shop_price`&amp;nbsp;decimal(10,2)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;本店价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`member_price`&amp;nbsp;decimal(10,2)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;默认会员价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`keywords`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品关键词&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_remark`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品简单描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_content`&amp;nbsp;text&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf16&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品详细描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`original_img`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品上传原始图&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_real`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否为实物&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_on_sale`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否上架&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_baoyou`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否包邮0否1是&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`on_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品上架时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order`&amp;nbsp;smallint(4)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_tuijian`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否推荐&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_new`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否新品&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_hot`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否热卖&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_update`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;最后更新时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_type`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品所属类型id，取值表goods_type的cat_id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_type`&amp;nbsp;smallint(5)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格类型，取值表goods_type的cat_id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`goods_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_sn`&amp;nbsp;(`goods_sn`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`cat_id`&amp;nbsp;(`cat_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`last_update`&amp;nbsp;(`last_update`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`brand_id`&amp;nbsp;(`brand_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_number`&amp;nbsp;(`kc_count`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_weight`&amp;nbsp;(`weight`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`sort_order`&amp;nbsp;(`order`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=38&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_goods_attr`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_goods_attr`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`goods_attr_id`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`attr_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`attr_value`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`attr_price`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`goods_attr_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_id`&amp;nbsp;(`goods_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`attr_id`&amp;nbsp;(`attr_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=403&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_goods_attribute`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_goods_attribute`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`attr_id`&amp;nbsp;int(11)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;属性id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`attr_name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;属性名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`type_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;属性分类id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`attr_index`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;0不需要检索&amp;nbsp;1关键字检索&amp;nbsp;2范围检索&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`attr_type`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;0唯一属性&amp;nbsp;1单选属性&amp;nbsp;2复选属性&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`attr_input_type`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;&amp;nbsp;0&amp;nbsp;手工录入&amp;nbsp;1从列表中选择&amp;nbsp;2多行文本框&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`attr_values`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;可选值列表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;属性排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`attr_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`cat_id`&amp;nbsp;(`type_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=223&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_goods_category`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_goods_category`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品分类id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(90)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品分类名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;父id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id_path`&amp;nbsp;varchar(128)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;家族图谱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`level`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;等级&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`sort_order`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;顺序排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_show`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否显示&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_type`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品分类对应的商品类型&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`filter_spec`&amp;nbsp;varchar(512)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;帅选规格&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`filter_attr`&amp;nbsp;varchar(512)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;帅选属性&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`image`&amp;nbsp;varchar(512)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;分类图片&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`parent_id`&amp;nbsp;(`parent_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=844&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_goods_category4`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_goods_category4`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品分类id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(90)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品分类名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;父id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id_path`&amp;nbsp;varchar(128)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;家族图谱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`level`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;等级&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`sort_order`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;顺序排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_show`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否显示&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`filter_attr`&amp;nbsp;varchar(255)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;帅选属性&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`image`&amp;nbsp;varchar(512)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;分类图片&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`parent_id`&amp;nbsp;(`parent_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=508&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_goods_images`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_goods_images`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`img_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`imgage_url`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`img_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_id`&amp;nbsp;(`goods_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=62&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_goods_type`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_goods_type`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=15&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_navigation`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_navigation`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;前台导航表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(32)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;导航名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_show`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否显示&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_new`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否新窗口&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`url`&amp;nbsp;varchar(256)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;链接地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=8&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=latin1;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_order`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_order`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`order_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_sn`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单编号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单状态&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货状态&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付状态&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`consignee`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;收货人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`country`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;国家&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`province`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;省份&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`city`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;城市&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`district`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;县区&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`address`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`zipcode`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;邮政编码&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`mobile`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;手机&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;邮件&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_code`&amp;nbsp;varchar(32)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;物流code&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_name`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;物流名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_code`&amp;nbsp;varchar(32)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付code&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_name`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付方式名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`invoice_title`&amp;nbsp;varchar(256)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发票抬头&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_price`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品总价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_price`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;邮费&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用余额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`coupon_price`&amp;nbsp;decimal(10,2)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用优惠券抵多少钱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`integral`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用积分&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`integral_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;使用积分抵多少钱&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_amount`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;应付款金额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`add_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;下单时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`confirm_time`&amp;nbsp;int(10)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;收货确认时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`invoice_no`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;发货单号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_note`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付备注&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`discount`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;打折金额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_cod`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否货到付款&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`order_id`),\r\n&amp;nbsp;&amp;nbsp;UNIQUE&amp;nbsp;KEY&amp;nbsp;`order_sn`&amp;nbsp;(`order_sn`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_id`&amp;nbsp;(`user_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`order_status`&amp;nbsp;(`order_status`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`shipping_status`&amp;nbsp;(`shipping_status`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`pay_status`&amp;nbsp;(`pay_status`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`shipping_id`&amp;nbsp;(`shipping_code`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`pay_id`&amp;nbsp;(`pay_code`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=4&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_order_action`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_order_action`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`action_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`order_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_user`&amp;nbsp;varchar(30)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;操作人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_status`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_place`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`action_note`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;操作备注&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`log_time`&amp;nbsp;int(11)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;操作时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`action_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`order_id`&amp;nbsp;(`order_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=44&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_order_goods`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_order_goods`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`rec_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;表id自增&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;订单id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;视频名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_sn`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品货号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_num`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;购买数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`market_price`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;市场价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_price`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;本店价&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_key`&amp;nbsp;varchar(128)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格key&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_key_name`&amp;nbsp;varchar(128)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;规格对应的中文名字&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`bar_code`&amp;nbsp;varchar(64)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;条码&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`rec_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`order_id`&amp;nbsp;(`order_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`goods_id`&amp;nbsp;(`goods_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=10&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_payment`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_payment`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`pay_id`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`pay_code`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_name`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;支付方式名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_fee`&amp;nbsp;varchar(10)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;手续费&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_desc`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;描述&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_order`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_config`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;配置&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`enabled`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;开启&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_cod`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否货到付款&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_online`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否在线支付&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`pay_id`),\r\n&amp;nbsp;&amp;nbsp;UNIQUE&amp;nbsp;KEY&amp;nbsp;`pay_code`&amp;nbsp;(`pay_code`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_plugin`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_plugin`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`code`&amp;nbsp;varchar(13)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;插件编码&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(55)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;中文名字&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`version`&amp;nbsp;varchar(13)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`author`&amp;nbsp;varchar(30)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`config`&amp;nbsp;text&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;配置信息&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`config_value`&amp;nbsp;text&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;配置值信息&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`desc`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`status`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否启用&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`type`&amp;nbsp;varchar(50)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;插件类型&amp;nbsp;payment支付&amp;nbsp;login&amp;nbsp;登陆&amp;nbsp;shipping物流&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`icon`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;图标&amp;#39;\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_region`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_region`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`level`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=3524&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=gbk;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_shipping_area`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_shipping_area`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`shipping_area_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`shipping_area_name`&amp;nbsp;varchar(150)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`shipping_code`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`config`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`update_time`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`is_default`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否默认&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`shipping_area_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`shipping_id`&amp;nbsp;(`shipping_code`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=25&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_shop_config`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_shop_config`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;smallint(5)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`code`&amp;nbsp;varchar(30)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`type`&amp;nbsp;varchar(10)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`store_range`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;存储范围&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`store_path`&amp;nbsp;varchar(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;存储路径&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`value`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`sort`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;UNIQUE&amp;nbsp;KEY&amp;nbsp;`code`&amp;nbsp;(`code`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`parent_id`&amp;nbsp;(`parent_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_spec`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_spec`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;规格表&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`type_id`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;规格类型&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(55)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;规格名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`order`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`search_index`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;是否需要检索&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=12&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_spec_goods_price`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_spec_goods_price`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`key`&amp;nbsp;varchar(255)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`key_name`&amp;nbsp;varchar(255)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`price`&amp;nbsp;decimal(10,2)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`kc_count`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;10&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;库存数量&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`bar_code`&amp;nbsp;varchar(32)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品&amp;nbsp;条形码&amp;#39;\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_spec_image`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_spec_image`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格图片表id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`spec_image_id`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;规格项id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`src`&amp;nbsp;varchar(512)&amp;nbsp;CHARACTER&amp;nbsp;SET&amp;nbsp;utf8&amp;nbsp;COLLATE&amp;nbsp;utf8_bin&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;商品规格图片路径&amp;#39;\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=latin1;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_spec_item`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_spec_item`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`spec_id`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`item`&amp;nbsp;varchar(54)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=41&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_system_module`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_system_module`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`mod_id`&amp;nbsp;smallint(6)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`module`&amp;nbsp;enum(&amp;#39;top&amp;#39;,&amp;#39;menu&amp;#39;,&amp;#39;module&amp;#39;)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;module&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`level`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;3&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`ctl`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`act`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`title`&amp;nbsp;varchar(20)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`visible`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`orderby`&amp;nbsp;smallint(6)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;50&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`dateline`&amp;nbsp;int(10)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`mod_id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_user_address`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_user_address`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`address_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`consignee`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;收货人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;邮箱地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`country`&amp;nbsp;smallint(5)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`province`&amp;nbsp;smallint(5)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;省份&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`city`&amp;nbsp;smallint(5)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;城市&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`district`&amp;nbsp;smallint(5)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;地区&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`address`&amp;nbsp;varchar(120)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`zipcode`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;邮政编码&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`mobile`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;手机&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`is_default`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;默认收货地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`address_id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`user_id`&amp;nbsp;(`user_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=12&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_users`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_users`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`user_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`email`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`username`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户名&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`password`&amp;nbsp;varchar(32)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`sex`&amp;nbsp;tinyint(1)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`birthday`&amp;nbsp;date&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0000-00-00&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;用户金额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`frozen_money`&amp;nbsp;decimal(10,2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0.00&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;冻结金额&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pay_points`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;消费积分&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`rank_points`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`address_id`&amp;nbsp;mediumint(8)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;默认收货地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`reg_time`&amp;nbsp;int(10)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;注册时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_login`&amp;nbsp;int(11)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;最后登录时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_time`&amp;nbsp;datetime&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0000-00-00&amp;nbsp;00:00:00&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`last_ip`&amp;nbsp;varchar(15)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;最后登录ip&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`user_rank`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`parent_id`&amp;nbsp;mediumint(9)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;推荐人&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`qq`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`mobile`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`is_validated`&amp;nbsp;tinyint(3)&amp;nbsp;unsigned&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`user_id`),\r\n&amp;nbsp;&amp;nbsp;UNIQUE&amp;nbsp;KEY&amp;nbsp;`user_name`&amp;nbsp;(`username`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`email`&amp;nbsp;(`email`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`parent_id`&amp;nbsp;(`parent_id`)\r\n)&amp;nbsp;&amp;nbsp;AUTO_INCREMENT=2&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_wx_img`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_wx_img`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`keyword`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`desc`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;简介&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`pic`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;封面图片&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`url`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;图文外链地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`createtime`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`uptatetime`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`token`&amp;nbsp;char(30)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`title`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`goods_id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`goods_name`&amp;nbsp;varchar(50)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8&amp;nbsp;COMMENT=&amp;#39;微信图文&amp;#39;;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_wx_keyword`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_wx_keyword`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`keyword`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`pid`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`token`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`module`&amp;nbsp;varchar(15)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`precision`&amp;nbsp;tinyint(1)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`precisions`&amp;nbsp;tinyint(1)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;0&amp;nbsp;包含匹配&amp;nbsp;1&amp;nbsp;完全匹配&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`pid`&amp;nbsp;(`pid`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`token`&amp;nbsp;(`token`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_wx_menu`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_wx_menu`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`level`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;1&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;菜单级别&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`name`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`sort`&amp;nbsp;int(5)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;排序&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`type`&amp;nbsp;tinyint(1)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;0&amp;nbsp;view&amp;nbsp;1&amp;nbsp;click&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`value`&amp;nbsp;varchar(255)&amp;nbsp;DEFAULT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`token`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`pid`&amp;nbsp;int(11)&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;上级菜单&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_wx_news`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_wx_news`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`keyword`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`createtime`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`uptatetime`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`token`&amp;nbsp;char(30)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`img_id`&amp;nbsp;varchar(50)&amp;nbsp;DEFAULT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;图文组合id&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8&amp;nbsp;COMMENT=&amp;#39;微信图文&amp;#39;;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_wx_text`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_wx_text`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`uid`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`uname`&amp;nbsp;varchar(90)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`keyword`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`precisions`&amp;nbsp;tinyint(1)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`text`&amp;nbsp;text&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`createtime`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`updatetime`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`click`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`token`&amp;nbsp;char(30)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`uid`&amp;nbsp;(`uid`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8&amp;nbsp;COMMENT=&amp;#39;文本回复表&amp;#39;;\r\n\r\n/*Table&amp;nbsp;structure&amp;nbsp;for&amp;nbsp;table&amp;nbsp;`tp_wx_user`&amp;nbsp;*/\r\n\r\nCREATE&amp;nbsp;TABLE&amp;nbsp;`tp_wx_user`&amp;nbsp;(\r\n&amp;nbsp;&amp;nbsp;`id`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;AUTO_INCREMENT,\r\n&amp;nbsp;&amp;nbsp;`uid`&amp;nbsp;int(11)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`wxname`&amp;nbsp;varchar(60)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;公众号名称&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`aeskey`&amp;nbsp;varchar(45)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`encode`&amp;nbsp;tinyint(1)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`appid`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`appsecret`&amp;nbsp;varchar(50)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`wxid`&amp;nbsp;varchar(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;公众号原始ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`weixin`&amp;nbsp;char(20)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;微信号&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`headerpic`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;头像地址&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`token`&amp;nbsp;char(255)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`w_token`&amp;nbsp;varchar(150)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;微信对接token&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`create_time`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`updatetime`&amp;nbsp;varchar(13)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`tplcontentid`&amp;nbsp;varchar(2)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;内容模版ID&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`share_ticket`&amp;nbsp;varchar(150)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;分享ticket&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`share_dated`&amp;nbsp;char(15)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`authorizer_access_token`&amp;nbsp;varchar(200)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`authorizer_refresh_token`&amp;nbsp;varchar(200)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`authorizer_expires`&amp;nbsp;char(10)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`type`&amp;nbsp;tinyint(1)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;DEFAULT&amp;nbsp;&amp;#39;0&amp;#39;&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;类型&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`web_access_token`&amp;nbsp;varchar(200)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;&amp;nbsp;网页授权token&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`web_refresh_token`&amp;nbsp;varchar(200)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`web_expires`&amp;nbsp;char(10)&amp;nbsp;NOT&amp;nbsp;NULL&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;过期时间&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;`qr`&amp;nbsp;varchar(200)&amp;nbsp;NOT&amp;nbsp;NULL,\r\n&amp;nbsp;&amp;nbsp;`menu_config`&amp;nbsp;text&amp;nbsp;COMMENT&amp;nbsp;&amp;#39;菜单&amp;#39;,\r\n&amp;nbsp;&amp;nbsp;PRIMARY&amp;nbsp;KEY&amp;nbsp;(`id`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`uid`&amp;nbsp;(`uid`),\r\n&amp;nbsp;&amp;nbsp;KEY&amp;nbsp;`uid_2`&amp;nbsp;(`uid`)\r\n)&amp;nbsp;&amp;nbsp;DEFAULT&amp;nbsp;CHARSET=utf8&amp;nbsp;COMMENT=&amp;#39;微信公共帐号&amp;#39;;&lt;/pre&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1450525896', null);
INSERT INTO `jay_content` VALUES ('112', '1', '2', 'TPshop商城V1.0版震感发布', '&lt;p class=&quot;common_tit&quot;&gt;TPshop商城 -- ( Thinkphp shop的简称 ) B2C 商城免费开源&lt;/p&gt;&lt;p&gt;TPshop 是用thinkphp开发的shop 一款免费开源网店系统，适合企业及个人,包含 (微信商城 + wap + android + ios + pc) 二次开发非常方便,\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; 详细的TPshop使用手册 + TPshop二开手册 + TPshop 98小时的二开视频教程，使开发者得心应手, 一看就懂 一听就会, 代码清晰简洁,通俗易懂. 丰富的插件和多套模板支持, 易扩展.\r\n &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp; &amp;nbsp;是目前国内首家最为完善的开源商城系统。系统支持多语言版本，操作简单,安全稳定,是广大用户二次开发的最佳选择。（需获取正规商业授权，方可做商业运营使用）&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1457696574', null);
INSERT INTO `jay_content` VALUES ('150', '41', '2', '产品PPT下载', '&lt;p&gt;产品PPT下载&lt;/p&gt;', null, '', '1', '1462267448', '5');
INSERT INTO `jay_content` VALUES ('250', '1', '3', 'TPshop隐藏index.php', '<p>有些朋友提到关于TPshop 隐藏index.php 一问题， 可以修改 Application\\Common\\Conf\\config.php 文件代码 <br/></p><pre class=\"brush:php;toolbar:false\">&#39;common&#39;,\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;AUTH_CODE&#39;&nbsp;=&gt;&nbsp;&quot;TPSHOP&quot;,&nbsp;//安装完毕之后不要改变，否则所有密码都会出错\r\n&nbsp;&nbsp;&nbsp;&nbsp;//&#39;URL_CASE_INSENSITIVE&#39;&nbsp;=&gt;&nbsp;false,&nbsp;//URL大小写不敏感\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;LOAD_EXT_CONFIG&#39;=&gt;&#39;db,route&#39;,&nbsp;//&nbsp;加载数据库配置文件\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;LOAD_EXT_CONFIG&#39;=&gt;&#39;db&#39;,&nbsp;//&nbsp;加载数据库配置文件\r\n&nbsp;&nbsp;&nbsp;&nbsp;&#39;URL_MODEL&#39;=&gt;2,&nbsp;//&nbsp;如果需要&nbsp;隐藏&nbsp;index.php&nbsp;&nbsp;打开这行&quot;URL_MODEL&quot;注释&nbsp;同时在apache环境下&nbsp;开启&nbsp;伪静态模块，&nbsp;&nbsp;如果在nginx&nbsp;下需要另外配置，参考thinkphp官网手册</pre><p><br/></p><p>有些环境刚修改上面还是不行，需要另外修改根目录下的 .htaccess&nbsp; 文件&nbsp;&nbsp;</p><pre class=\"brush:php;toolbar:false\">&nbsp;&nbsp;Options&nbsp;+FollowSymlinks\r\n&nbsp;&nbsp;RewriteEngine&nbsp;On\r\n\r\n&nbsp;&nbsp;RewriteCond&nbsp;%{REQUEST_FILENAME}&nbsp;!-d\r\n&nbsp;&nbsp;RewriteCond&nbsp;%{REQUEST_FILENAME}&nbsp;!-f\r\n&nbsp;&nbsp;#RewriteRule&nbsp;^(.*)$&nbsp;index.php/$1&nbsp;[QSA,PT,L]&nbsp;&nbsp;\r\n&nbsp;&nbsp;RewriteRule&nbsp;^(.*)$&nbsp;index.php?s=$1&nbsp;[QSA,PT,L]</pre><p>原来的<br/></p><p>&nbsp;RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]&nbsp; <br/></p><p>改成<br/></p><p>&nbsp;RewriteRule ^(.*)$ index.php?s=$1 [QSA,PT,L]&nbsp; <br/></p><p>重启apache&nbsp; 试试。</p><p><br/></p><p>对于nginx 用户 请查看thinkphp 官网手册说明<br/></p>', null, '', '1', '1465056409', null);
INSERT INTO `jay_content` VALUES ('259', '1', '3', 'TPshop添加后台菜单', '&lt;p&gt;TPshop 添加一个菜单非常方便，只需要 2 步&lt;br/&gt;&lt;br/&gt;比如想添加微信管理下面的 组合回复&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/Public/upload/article/2016/06-07/5756ceb3a08ce.jpg&quot; style=&quot;float:none;&quot; title=&quot;1.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;第一先到模块管理 -&amp;gt; 模块管理 找到微信管理&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/Public/upload/article/2016/06-07/5756ceb3f29e4.jpg&quot; style=&quot;float:none;&quot; title=&quot;2.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/Public/upload/article/2016/06-07/5756cf086a2c3.jpg&quot; title=&quot;3.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/Public/upload/article/2016/06-07/5756cf199b4c2.jpg&quot; title=&quot;4.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;照着上图找到对应文件 。&lt;/p&gt;&lt;p&gt;&lt;img src=&quot;/Public/upload/article/2016/06-07/5756cf3436717.jpg&quot; title=&quot;5.jpg&quot;/&gt;&lt;/p&gt;&lt;p&gt;在对应的位置添加上即可&lt;br/&gt;&lt;/p&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1465306953', null);
INSERT INTO `jay_content` VALUES ('1151', '41', '3', '添加后台菜单', '&lt;p&gt;目前在后台公用函数文件function.php中getAllMenu方法里添加，&lt;/p&gt;&lt;p&gt;格式如下&lt;/p&gt;&lt;pre class=&quot;brush:php;toolbar:false&quot;&gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			&amp;#39;system&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;系统设置&amp;#39;,&amp;#39;icon&amp;#39;=&amp;gt;&amp;#39;fa-cog&amp;#39;,&amp;#39;sub_menu&amp;#39;=&amp;gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;网站设置&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;index&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;友情链接&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;linkList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Article&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;自定义导航&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;navigationList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;区域管理&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;region&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Tools&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;权限资源列表&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;right_list&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			)),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			&amp;#39;access&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;权限管理&amp;#39;,&amp;nbsp;&amp;#39;icon&amp;#39;=&amp;gt;&amp;#39;fa-gears&amp;#39;,&amp;nbsp;&amp;#39;sub_menu&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;管理员列表&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;index&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;角色管理&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;role&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;供应商管理&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;supplier&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;					array(&amp;#39;name&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;&amp;#39;管理员日志&amp;#39;,&amp;nbsp;&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;log&amp;#39;,&amp;nbsp;&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Admin&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;			)),\r\n）\r\n\r\n例如需要在系统设置中加一个网站公告菜单\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;#39;system&amp;#39;&amp;nbsp;=&amp;gt;&amp;nbsp;array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;系统设置&amp;#39;,&amp;#39;icon&amp;#39;=&amp;gt;&amp;#39;fa-cog&amp;#39;,&amp;#39;sub_menu&amp;#39;=&amp;gt;array(\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;网站设置&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;index&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;友情链接&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;linkList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Article&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;自定义导航&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;navigationList&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;区域管理&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;region&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;Tools&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;权限资源列表&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;right_list&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;array(&amp;#39;name&amp;#39;=&amp;gt;&amp;#39;网站公告&amp;#39;,&amp;#39;act&amp;#39;=&amp;gt;&amp;#39;notice&amp;#39;,&amp;#39;control&amp;#39;=&amp;gt;&amp;#39;System&amp;#39;),\r\n&amp;nbsp;&amp;nbsp;&amp;nbsp;&amp;nbsp;	)),&lt;/pre&gt;&lt;p&gt;&lt;br/&gt;&lt;/p&gt;', null, '', '1', '1472042383', null);
INSERT INTO `jay_content` VALUES ('1152', '12', '3', '媒体信3我232322', '<p>\r\n	的司法地方\r\n</p>\r\n<p>\r\n	<strong>1</strong> \r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	<strong>3dddddddddd</strong> \r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	4\r\n</p>\r\n<p>\r\n	3\r\n</p>\r\n<p>\r\n	43434\r\n</p>', '1马努：昨天和妻儿看见一只秃鹰，他们难以置信马努：昨天和妻儿看见一只秃鹰，他们难以置信马努：昨天和妻儿看见一只秃鹰，他们难以置信马努：昨天和妻儿看见一只秃鹰，他们难以置信', '20171121\\b3e8ce6cdea0ab9f8f7b6b87e1e989f3.jpg', '1', '1511366400', null);
INSERT INTO `jay_content` VALUES ('1156', '0', '1', 'PHP 程序员', '<b>工作地址</b><br />\r\n<p>\r\n	成都\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<b>职位描述</b><br />\r\n<p>\r\n	维护\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<p>\r\n	<br />\r\n</p>\r\n<b>职位要求</b><br />\r\n<p>\r\n	写代码\r\n</p>\r\n<p>\r\n	7年经验\r\n</p>', null, '', '1', '1511322423', null);
INSERT INTO `jay_content` VALUES ('1157', '0', '2', '斯蒂芬是否开黑', '是的第三方rr', null, '20171129\\6dc469dfc9b71743cca93a9e5a61c454.png', '1', '1511322642', '3');
INSERT INTO `jay_content` VALUES ('1158', '0', '1', '44', '<b>工作地址</b><br />\r\n<br />\r\n<b>职位描述</b><br />\r\n<br />\r\n<b>职位要求</b><br />\r\n<br />', null, '', '1', '1511707017', null);

-- ----------------------------
-- Table structure for `jay_member`
-- ----------------------------
DROP TABLE IF EXISTS `jay_member`;
CREATE TABLE `jay_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(32) DEFAULT NULL COMMENT '用户token，唯一',
  `openid` varchar(100) DEFAULT NULL COMMENT '微信openid',
  `nickname` varchar(30) DEFAULT NULL COMMENT '昵称',
  `head` varchar(255) DEFAULT NULL COMMENT '微信头像',
  `username` varchar(20) DEFAULT NULL COMMENT '姓名',
  `phone` varchar(12) DEFAULT NULL COMMENT '手机号',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `truename` varchar(20) DEFAULT NULL,
  `sex` varchar(2) DEFAULT NULL,
  `addtime` varchar(20) DEFAULT NULL COMMENT '注册时间',
  `vipcode` varchar(30) DEFAULT NULL COMMENT '会员编号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `tokenunique` (`token`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='会员表';

-- ----------------------------
-- Records of jay_member
-- ----------------------------
INSERT INTO `jay_member` VALUES ('1', '233', '1sdfsf', '昵称', '11.png', 'des', '13778823023', 'sf@sf.com', 'df才', '男', '2017', '0803155800000601');
INSERT INTO `jay_member` VALUES ('2', null, null, null, null, null, null, null, null, null, null, null);

-- ----------------------------
-- Table structure for `jay_order`
-- ----------------------------
DROP TABLE IF EXISTS `jay_order`;
CREATE TABLE `jay_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` varchar(30) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `totalfee` decimal(10,2) DEFAULT '0.00' COMMENT '订单总金额',
  `payamount` decimal(10,2) DEFAULT '0.00' COMMENT '实际付款金额',
  `discountfee` decimal(10,2) DEFAULT '0.00' COMMENT '积分抵扣金额',
  `discountpoints` int(11) DEFAULT '0' COMMENT '抵扣使用积分',
  `status` tinyint(4) DEFAULT '0' COMMENT '-1无效  0新订单；1已付款；2已入住完成；5（支付）取消订单 6退款成功',
  `del` tinyint(4) DEFAULT '0' COMMENT '管理员删除',
  `starttime` varchar(20) DEFAULT NULL,
  `endtime` varchar(20) DEFAULT NULL,
  `addtime` int(11) DEFAULT NULL COMMENT '下单时间',
  `paytime` int(11) DEFAULT NULL COMMENT '支付时间',
  `canceltime` int(11) DEFAULT NULL COMMENT '取消时间',
  `refundtime` int(11) DEFAULT NULL COMMENT '退款时间',
  `transaction_id` varchar(100) DEFAULT NULL COMMENT '微信订单号',
  `refund_id` varchar(100) DEFAULT NULL COMMENT '微信退款单号',
  PRIMARY KEY (`id`),
  UNIQUE KEY `orderNo` (`order_no`) USING BTREE,
  KEY `userid` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COMMENT='订单主表';

-- ----------------------------
-- Records of jay_order
-- ----------------------------
INSERT INTO `jay_order` VALUES ('1', 'GI3GH4093U40', '1', '3.00', '3.00', '0.00', '0', '0', '0', '2018-07-12', '2018-07-14', null, null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('2', 'afdjfdjeowiHGEOI', '1', '12.00', '12.00', '0.00', '0', '2', '1', '2018-07-12', '2018-07-14', null, null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('3', 'GRWLAJGOI42', '1', '54.00', '43.00', '0.00', '0', '2', '0', '2018-07-12', '2018-07-14', null, null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('4', '18080212001', '1', '16.00', '16.00', '0.00', '0', '-1', '0', '2018-08-02', '2018-08-03', '1533184948', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('5', '18080212002', '1', '16.00', '16.00', '0.00', '0', '-1', '0', '2018-08-02', '2018-08-03', '1533185118', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('6', '18080212003', '1', '41.00', '41.00', '0.00', '0', '-1', '0', '2018-08-02', '2018-08-03', '1533185192', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('7', '18080214001', '1', '44.00', '44.00', '0.00', '0', '-1', '0', '2018-08-08', '2018-08-11', '1533190982', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('8', '18080309001', '1', '3.00', '3.00', '0.00', '0', '2', '0', '2018-08-03', '2018-08-04', '1533259859', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('9', '18091510001', '1', '3.00', '3.00', '0.00', '0', '2', '0', '2018-09-15', '2018-09-16', '1536979835', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('10', '18092016004', '1', '0.01', '0.01', '0.00', '0', '2', '0', '2018-09-25', '2018-09-16', '1536980626', null, null, null, '4200000169201809205143254662', null);
INSERT INTO `jay_order` VALUES ('11', '18092510001', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842596', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('12', '18092510002', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842598', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('13', '18092510003', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842599', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('14', '18092510004', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842600', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('15', '18092510005', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842601', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('16', '18092510006', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842602', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('17', '18092510007', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842603', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('18', '18092510008', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842607', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('19', '18092510009', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842616', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('20', '180925100010', null, '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842619', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('21', '18092510011', '1', '3.00', '3.00', '0.00', '0', '-1', '0', '2018-10-15', '2018-10-22', '1537842671', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('22', '18092816001', '1', '16.00', '16.00', '0.00', '0', '-1', '0', '2018-10-05', '2018-10-19', '1538122561', null, null, null, null, null);
INSERT INTO `jay_order` VALUES ('23', '18092816002', '1', '58.00', '58.00', '0.00', '0', '-1', '0', '2018-10-05', '2018-10-19', '1538122660', null, null, null, null, null);

-- ----------------------------
-- Table structure for `jay_order_room`
-- ----------------------------
DROP TABLE IF EXISTS `jay_order_room`;
CREATE TABLE `jay_order_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL,
  `num` tinyint(4) DEFAULT '1' COMMENT '房间数量',
  `night` tinyint(4) DEFAULT '1' COMMENT '几晚',
  `price` decimal(10,2) DEFAULT '0.00',
  `username` varchar(20) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `remark` varchar(30) DEFAULT NULL COMMENT '留言',
  PRIMARY KEY (`id`),
  KEY `orderid` (`order_id`),
  KEY `roomid` (`room_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_order_room
-- ----------------------------
INSERT INTO `jay_order_room` VALUES ('1', '1', '1', '2', '1', '1', '1.00', '李红', '1377882323', '快两年');
INSERT INTO `jay_order_room` VALUES ('2', '2', '1', '1', '1', '1', '1.00', '放假哦诶我', '1346546455', '后台');
INSERT INTO `jay_order_room` VALUES ('3', '3', '1', '1', '1', '1', '0.00', '各位', '13756565656', '3 ');
INSERT INTO `jay_order_room` VALUES ('4', '4', '1', '2', '1', '1', '3.00', '李红', '13555555555', '测试');
INSERT INTO `jay_order_room` VALUES ('5', '5', '1', '2', '1', '1', '3.00', '李红', '13555555555', '测试');
INSERT INTO `jay_order_room` VALUES ('6', '6', '1', '2', '1', '1', '3.00', '里面', '13904584035', '');
INSERT INTO `jay_order_room` VALUES ('7', '7', '1', '1', '3', '3', '2.00', '贵宾', '13888888888', '哈哈');
INSERT INTO `jay_order_room` VALUES ('8', '8', '1', '2', '1', '0', '3.00', 't87g8g', '13546475889', '');
INSERT INTO `jay_order_room` VALUES ('9', '9', '1', '2', '1', '0', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('10', '10', '1', '2', '1', '0', '3.00', 'des', '15828218481', '');
INSERT INTO `jay_order_room` VALUES ('11', '11', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('12', '12', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('13', '13', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('14', '14', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('15', '15', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('16', '16', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('17', '17', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('18', '18', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('19', '19', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('20', '20', null, '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('21', '21', '1', '2', '1', '7', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('22', '22', '1', '2', '1', '14', '3.00', 'des', '13778823023', '');
INSERT INTO `jay_order_room` VALUES ('23', '23', '1', '1', '1', '14', '2.00', 'des', '13778823023', '');

-- ----------------------------
-- Table structure for `jay_order_service`
-- ----------------------------
DROP TABLE IF EXISTS `jay_order_service`;
CREATE TABLE `jay_order_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `servicename` varchar(40) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `orderid` (`order_id`),
  KEY `service` (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_order_service
-- ----------------------------
INSERT INTO `jay_order_service` VALUES ('1', '3', '1', '1', 'RGSG', '1.00');
INSERT INTO `jay_order_service` VALUES ('2', '1', '1', '2', '43T4', '2.00');
INSERT INTO `jay_order_service` VALUES ('3', '1', '1', '3', 'G3', '3.00');
INSERT INTO `jay_order_service` VALUES ('4', '4', '1', '2', '水中贵族', '8.00');
INSERT INTO `jay_order_service` VALUES ('5', '4', '1', '3', '农夫山泉', '5.00');
INSERT INTO `jay_order_service` VALUES ('6', '5', '1', '2', '水中贵族', '8.00');
INSERT INTO `jay_order_service` VALUES ('7', '5', '1', '3', '农夫山泉', '5.00');
INSERT INTO `jay_order_service` VALUES ('8', '6', '1', '2', '水中贵族', '8.00');
INSERT INTO `jay_order_service` VALUES ('9', '6', '1', '3', '农夫山泉', '5.00');
INSERT INTO `jay_order_service` VALUES ('10', '6', '1', '4', '口香糖', '25.00');
INSERT INTO `jay_order_service` VALUES ('11', '7', '1', '2', '水中贵族', '8.00');
INSERT INTO `jay_order_service` VALUES ('12', '7', '1', '3', '农夫山泉', '5.00');
INSERT INTO `jay_order_service` VALUES ('13', '7', '1', '4', '口香糖', '25.00');
INSERT INTO `jay_order_service` VALUES ('14', '22', '1', '2', '水中贵族', '8.00');
INSERT INTO `jay_order_service` VALUES ('15', '22', '1', '3', '农夫山泉', '5.00');
INSERT INTO `jay_order_service` VALUES ('16', '23', '1', '3', '农夫山泉', '5.00');
INSERT INTO `jay_order_service` VALUES ('17', '23', '1', '4', '口香糖', '25.00');

-- ----------------------------
-- Table structure for `jay_page`
-- ----------------------------
DROP TABLE IF EXISTS `jay_page`;
CREATE TABLE `jay_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `photo1` varchar(50) DEFAULT NULL,
  `photo2` varchar(50) DEFAULT NULL,
  `photo3` varchar(50) DEFAULT NULL,
  `photo4` varchar(50) DEFAULT NULL,
  `content` text,
  `add_time` int(11) DEFAULT NULL,
  `en_title` varchar(50) DEFAULT NULL,
  `en_content` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_page
-- ----------------------------
INSERT INTO `jay_page` VALUES ('1', '1', '预定协议', '20171126\\804d7d477c62344e03a3aa7363f6c346.jpg', '', '20171126\\d3754f5d80183b236762d7e7a7d9906b.jpg', '', '<p>\r\n	预定协议\r\n</p>\r\n<p>\r\n	预定协议\r\n</p>\r\n<p>\r\n	预定协议\r\n</p>', '1532484570', '', '');
INSERT INTO `jay_page` VALUES ('2', '1', '退款说明', null, null, null, null, '退款说明退款说明', '1532484621', null, null);
INSERT INTO `jay_page` VALUES ('3', '1', '退订政策', null, null, null, null, '<p>\r\n	退订政策\r\n</p>\r\n<p>\r\n	退订政策\r\n</p>\r\n<p>\r\n	退订政策\r\n</p>', '1537844037', '', '');

-- ----------------------------
-- Table structure for `jay_provence`
-- ----------------------------
DROP TABLE IF EXISTS `jay_provence`;
CREATE TABLE `jay_provence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL,
  `provence` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COMMENT='省份信息表';

-- ----------------------------
-- Records of jay_provence
-- ----------------------------
INSERT INTO `jay_provence` VALUES ('1', '110000', '北京市');
INSERT INTO `jay_provence` VALUES ('2', '120000', '天津市');
INSERT INTO `jay_provence` VALUES ('3', '130000', '河北省');
INSERT INTO `jay_provence` VALUES ('4', '140000', '山西省');
INSERT INTO `jay_provence` VALUES ('5', '150000', '内蒙古自治区');
INSERT INTO `jay_provence` VALUES ('6', '210000', '辽宁省');
INSERT INTO `jay_provence` VALUES ('7', '220000', '吉林省');
INSERT INTO `jay_provence` VALUES ('8', '230000', '黑龙江省');
INSERT INTO `jay_provence` VALUES ('9', '310000', '上海市');
INSERT INTO `jay_provence` VALUES ('10', '320000', '江苏省');
INSERT INTO `jay_provence` VALUES ('11', '330000', '浙江省');
INSERT INTO `jay_provence` VALUES ('12', '340000', '安徽省');
INSERT INTO `jay_provence` VALUES ('13', '350000', '福建省');
INSERT INTO `jay_provence` VALUES ('14', '360000', '江西省');
INSERT INTO `jay_provence` VALUES ('15', '370000', '山东省');
INSERT INTO `jay_provence` VALUES ('16', '410000', '河南省');
INSERT INTO `jay_provence` VALUES ('17', '420000', '湖北省');
INSERT INTO `jay_provence` VALUES ('18', '430000', '湖南省');
INSERT INTO `jay_provence` VALUES ('19', '440000', '广东省');
INSERT INTO `jay_provence` VALUES ('20', '450000', '广西壮族自治区');
INSERT INTO `jay_provence` VALUES ('21', '460000', '海南省');
INSERT INTO `jay_provence` VALUES ('22', '500000', '重庆市');
INSERT INTO `jay_provence` VALUES ('23', '510000', '四川省');
INSERT INTO `jay_provence` VALUES ('24', '520000', '贵州省');
INSERT INTO `jay_provence` VALUES ('25', '530000', '云南省');
INSERT INTO `jay_provence` VALUES ('26', '540000', '西藏自治区');
INSERT INTO `jay_provence` VALUES ('27', '610000', '陕西省');
INSERT INTO `jay_provence` VALUES ('28', '620000', '甘肃省');
INSERT INTO `jay_provence` VALUES ('29', '630000', '青海省');
INSERT INTO `jay_provence` VALUES ('30', '640000', '宁夏回族自治区');
INSERT INTO `jay_provence` VALUES ('31', '650000', '新疆维吾尔自治区');
INSERT INTO `jay_provence` VALUES ('32', '710000', '台湾省');
INSERT INTO `jay_provence` VALUES ('33', '810000', '香港特别行政区');
INSERT INTO `jay_provence` VALUES ('34', '820000', '澳门特别行政区');

-- ----------------------------
-- Table structure for `jay_room`
-- ----------------------------
DROP TABLE IF EXISTS `jay_room`;
CREATE TABLE `jay_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) DEFAULT NULL,
  `type` tinyint(4) DEFAULT '1' COMMENT '1套房；2普通',
  `num` int(11) DEFAULT '0' COMMENT '房间数量',
  `pic` varchar(50) DEFAULT NULL,
  `feature` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT '0.00',
  `originalprice` decimal(10,2) DEFAULT '0.00' COMMENT '原价',
  `photo1` varchar(50) DEFAULT NULL,
  `photo2` varchar(50) DEFAULT NULL,
  `photo3` varchar(50) DEFAULT NULL,
  `photo4` varchar(50) DEFAULT NULL,
  `photo5` varchar(50) DEFAULT NULL,
  `photo6` varchar(50) DEFAULT NULL,
  `descp` varchar(300) DEFAULT NULL COMMENT '描述',
  `introduction` text COMMENT '说明',
  `beizhu` varchar(50) DEFAULT NULL,
  `serviceIds` varchar(100) DEFAULT NULL COMMENT '配套服务id',
  `addtime` int(11) DEFAULT NULL COMMENT '添加时间',
  `status` tinyint(4) DEFAULT '1' COMMENT '1上架',
  `sort` tinyint(4) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='房型表';

-- ----------------------------
-- Records of jay_room
-- ----------------------------
INSERT INTO `jay_room` VALUES ('1', '香格里拉双人间', '1', '44', '20180723\\028161f96cec3fbc08aa496d0ad641c1.png', '嘎嘎嘎格瓦格', '2.00', '0.00', '20180723\\513e7a23faa385d0afb1e0c269671543.png', '20180723\\03d455f1bb5e2de34f88237e118401b0.png', '', '', '20180723\\a24a864cce8ed4580629778661169951.png', '', 'ageagwfgewag或任何', '<p>\r\n	阿哥完工阿旺\r\n</p>\r\n<p>\r\n	sefaesfasfaf\r\n</p>\r\n<p>\r\n	个阿哥\r\n</p>\r\n<p>\r\n	ffdsfdsfsdf是\r\n</p>\r\n<p>\r\n	<br />\r\n</p>', null, '2,3,4', '1532316089', '1', '14');
INSERT INTO `jay_room` VALUES ('2', '黄龙溪套房', '2', '10', '20180723\\71ec537e7f14a49d68a1cd60a990597b.png', '嘎嘎嘎格瓦格', '3.00', '0.00', '20180801\\9dc6ad8d4070ecfbe19510bb1ccb2641.jpg', '20180801\\ebec8a89d13018b60172be784aaeb139.jpg', '', '', '', '', '更让', '割让', null, '2,3,4', '1532326073', '1', '1');

-- ----------------------------
-- Table structure for `jay_roomservice`
-- ----------------------------
DROP TABLE IF EXISTS `jay_roomservice`;
CREATE TABLE `jay_roomservice` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(40) DEFAULT NULL COMMENT '服务名称',
  `price` decimal(10,2) DEFAULT NULL,
  `addtime` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='服务表';

-- ----------------------------
-- Records of jay_roomservice
-- ----------------------------
INSERT INTO `jay_roomservice` VALUES ('2', '水中贵族', '8.00', '1532163039');
INSERT INTO `jay_roomservice` VALUES ('3', '农夫山泉', '5.00', '1532163153');
INSERT INTO `jay_roomservice` VALUES ('4', '口香糖', '25.00', '1532163173');

-- ----------------------------
-- Table structure for `jay_store`
-- ----------------------------
DROP TABLE IF EXISTS `jay_store`;
CREATE TABLE `jay_store` (
  `id` int(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '表id',
  `cat_id` smallint(5) NOT NULL DEFAULT '1' COMMENT '门店类型',
  `pic` varchar(50) DEFAULT '' COMMENT '店铺logo',
  `title` varchar(150) NOT NULL DEFAULT '' COMMENT '文章标题',
  `ssq` varchar(30) DEFAULT NULL COMMENT '省市区',
  `provence_id` varchar(11) DEFAULT NULL,
  `city_id` varchar(11) DEFAULT NULL,
  `area_id` varchar(11) DEFAULT NULL,
  `address` varchar(120) DEFAULT NULL COMMENT '地址',
  `tel` varchar(12) DEFAULT NULL COMMENT '电话',
  `businesstime` varchar(18) DEFAULT NULL COMMENT '营业时间',
  `lng` varchar(10) DEFAULT NULL COMMENT '经度',
  `lat` varchar(10) DEFAULT NULL COMMENT '维度',
  `content` longtext NOT NULL COMMENT '介绍内容',
  `status` tinyint(4) DEFAULT '1' COMMENT '1上架 0不显示',
  `sort` int(11) DEFAULT '1' COMMENT '排序',
  `add_time` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '添加时间',
  `pic_logo` varchar(50) DEFAULT NULL,
  `pic_photo1` varchar(50) DEFAULT NULL,
  `pic_photo2` varchar(50) DEFAULT NULL,
  `pic_photo3` varchar(50) DEFAULT NULL,
  `pic_photo4` varchar(50) DEFAULT NULL,
  `pic_tg1` varchar(50) DEFAULT NULL,
  `pic_tg2` varchar(50) DEFAULT NULL,
  `pic_menu1` varchar(50) DEFAULT NULL,
  `pic_menu1_1` varchar(50) DEFAULT NULL,
  `pic_menu2` varchar(50) DEFAULT NULL,
  `pic_menu2_2` varchar(50) DEFAULT NULL,
  `pic_menu3` varchar(50) DEFAULT NULL,
  `pic_menu3_3` varchar(50) DEFAULT NULL,
  `en_title` varchar(100) DEFAULT NULL,
  `en_ssq` varchar(100) DEFAULT NULL,
  `en_address` varchar(100) DEFAULT NULL,
  `en_content` text,
  PRIMARY KEY (`id`),
  KEY `cat_id` (`cat_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='门店表';

-- ----------------------------
-- Records of jay_store
-- ----------------------------
INSERT INTO `jay_store` VALUES ('1', '28', '', '东坡湖店', '湖北省鄂州市梁子湖区', '420000', '420700', '420702', '红星路2', '18983298399', '12:33-21:00', '114.90107', '30.320852', '描述1', '1', '1', '1511575533', '', '', '', '', '', '20171125\\1d90839847e3a6a9136f0a0223adfce2.jpg', '20171125\\1c11a429ece8eb6495c3bdb65c3a3972.jpg', '', '', '', '', '20171125\\dd6e7ea52dab82beae02f8765616f627.jpg', '', null, null, null, null);
INSERT INTO `jay_store` VALUES ('2', '29', '', '致青春酒吧', '湖南省湘潭市岳塘区', '430000', '430300', '430304', '红星路2', '18983298399', '12:33-21:00', '113.023578', '27.927715', '131212', '1', '1', '1511617778', '20171125\\75f5aa92936f947c98fc323bcdf560e4.jpg', '20171125\\e9429493be3a48cb2b5343e481c9ce1b.jpg', '20171125\\9f6e62825ba1862e263b8a532e4b60ec.jpg', '20171125\\bc807a1c0fbee67641ab88d2171baf58.jpg', '', '', '', '', '', '', '', '', '', null, null, null, null);
INSERT INTO `jay_store` VALUES ('3', '28', '', '建设路店', '吉林省通化市集安市', '220000', '220500', '220582', '青年路', '18983298399', '12:33-21:00', '126.220999', '41.856775', '司法局', '1', '1', '1511704957', '', '', '', '', '', '20171126\\88d069d8afcd2ea95612ded83e6a0336.jpg', '', '', '', '', '20171126\\121e9a896ea23ecb64f69d0fcc238679.jpg', '', '', '1', '2', '3', '4');
INSERT INTO `jay_store` VALUES ('4', '29', '', '冰河路酒吧', '山东省烟台市龙口市', '370000', '370600', '370681', '德胜路', '18983298399', '12:33-21:00', '120.523977', '37.610251', '订单', '1', '1', '1511705140', '', '20171126\\02e85c63dfbd715103627cd3a5e68b40.jpg', '', '', '', '', '', '', '', '', '', '', '', '11', '22', '33', '44');

-- ----------------------------
-- Table structure for `jay_sys_admin`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_admin`;
CREATE TABLE `jay_sys_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jname` varchar(20) DEFAULT NULL COMMENT '登录账号',
  `jpass` varchar(50) DEFAULT NULL COMMENT '登录密码',
  `nickname` varchar(20) DEFAULT NULL COMMENT '昵称',
  `head` varchar(60) DEFAULT NULL COMMENT '头像',
  `tel` varchar(12) DEFAULT NULL COMMENT '手机号',
  `last_login_time` varchar(20) DEFAULT NULL COMMENT '上次登录时间',
  `role_id` int(11) DEFAULT NULL COMMENT '角色id',
  `dllkey` varchar(32) DEFAULT NULL COMMENT '动态码',
  `addtime` varchar(22) DEFAULT NULL COMMENT '添加时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nameunique` (`jname`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8 COMMENT='管理员账号表';

-- ----------------------------
-- Records of jay_sys_admin
-- ----------------------------
INSERT INTO `jay_sys_admin` VALUES ('100', 'admin', '956497e59024554d38d14456984d8551dec8254d', 'administrator', '20170818\\8d92a88ad82586c99ed61005d84de256.png', null, '2018-09-29 14:02:20', '1', '4f9871b039374147817dc4fb40886422', null);
INSERT INTO `jay_sys_admin` VALUES ('102', 'test123', 'e0a2d05f29a20be30781380f7e66161985a254d6', '哈伦裤', '', null, '2017-10-27 14:57:54', '2', 'd9edeadf17f3e6243cd3e406ab27cae9', '2017-08-04 10:44:07');

-- ----------------------------
-- Table structure for `jay_sys_adminlogs`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_adminlogs`;
CREATE TABLE `jay_sys_adminlogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `admin_id` int(11) DEFAULT NULL,
  `admin_name` varchar(30) DEFAULT NULL,
  `intro` varchar(50) DEFAULT NULL,
  `addtime` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8 COMMENT='管理员操作日志';

-- ----------------------------
-- Records of jay_sys_adminlogs
-- ----------------------------
INSERT INTO `jay_sys_adminlogs` VALUES ('140', '100', 'admin', '批量删除日志', '2018-08-04 09:46:54');
INSERT INTO `jay_sys_adminlogs` VALUES ('141', '100', 'admin', '修改新闻：媒体信3我232322', '2018-09-20 16:30:06');
INSERT INTO `jay_sys_adminlogs` VALUES ('142', '100', 'admin', '删除分类：合酿', '2018-09-20 16:34:52');
INSERT INTO `jay_sys_adminlogs` VALUES ('143', '100', 'admin', '修改新闻：媒体信3我232322', '2018-09-23 14:57:51');
INSERT INTO `jay_sys_adminlogs` VALUES ('144', '100', 'admin', '修改新闻：TPshop添加后台菜单', '2018-09-23 14:58:35');
INSERT INTO `jay_sys_adminlogs` VALUES ('145', '100', 'admin', '添加页面：退订政策', '2018-09-25 10:51:20');
INSERT INTO `jay_sys_adminlogs` VALUES ('146', '100', 'admin', '修改页面：退订政策', '2018-09-25 10:53:57');
INSERT INTO `jay_sys_adminlogs` VALUES ('147', '100', 'admin', '修改房型：黄龙溪套房', '2018-09-28 15:19:36');
INSERT INTO `jay_sys_adminlogs` VALUES ('148', '100', 'admin', '客人入住：10', '2018-09-29 14:08:31');

-- ----------------------------
-- Table structure for `jay_sys_albums`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_albums`;
CREATE TABLE `jay_sys_albums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modul` varchar(20) DEFAULT 'product' COMMENT '模块枚举名称',
  `entity_id` int(11) DEFAULT '0' COMMENT '实体id',
  `filename` varchar(100) DEFAULT NULL COMMENT '图片名称',
  `descp` varchar(20) DEFAULT NULL COMMENT '描述',
  `sort` tinyint(4) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='相册图片集';

-- ----------------------------
-- Records of jay_sys_albums
-- ----------------------------

-- ----------------------------
-- Table structure for `jay_sys_authority`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_authority`;
CREATE TABLE `jay_sys_authority` (
  `role_id` int(11) NOT NULL DEFAULT '0' COMMENT '角色id',
  `node_id` int(11) NOT NULL DEFAULT '0' COMMENT '权限id',
  PRIMARY KEY (`role_id`,`node_id`),
  UNIQUE KEY `ids` (`role_id`,`node_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_sys_authority
-- ----------------------------
INSERT INTO `jay_sys_authority` VALUES ('1', '1');
INSERT INTO `jay_sys_authority` VALUES ('1', '2');
INSERT INTO `jay_sys_authority` VALUES ('1', '3');
INSERT INTO `jay_sys_authority` VALUES ('1', '4');
INSERT INTO `jay_sys_authority` VALUES ('1', '5');
INSERT INTO `jay_sys_authority` VALUES ('1', '6');
INSERT INTO `jay_sys_authority` VALUES ('1', '7');
INSERT INTO `jay_sys_authority` VALUES ('2', '1');
INSERT INTO `jay_sys_authority` VALUES ('2', '14');
INSERT INTO `jay_sys_authority` VALUES ('2', '19');
INSERT INTO `jay_sys_authority` VALUES ('2', '22');
INSERT INTO `jay_sys_authority` VALUES ('2', '23');

-- ----------------------------
-- Table structure for `jay_sys_config`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_config`;
CREATE TABLE `jay_sys_config` (
  `label` varchar(20) DEFAULT NULL,
  `field` varchar(30) NOT NULL DEFAULT '',
  `value` varchar(100) DEFAULT NULL,
  `type` varchar(12) DEFAULT 'text',
  `width` varchar(10) DEFAULT '300px' COMMENT 'text宽度',
  `alt` varchar(30) DEFAULT NULL COMMENT '针对图片的描述',
  `btntxt` varchar(30) DEFAULT '上传' COMMENT '上传按钮文字',
  `info` varchar(50) DEFAULT NULL,
  `tab` tinyint(4) DEFAULT '1' COMMENT '1=网站设置；2=微信设置',
  `sort` tinyint(4) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`field`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='系统配置表';

-- ----------------------------
-- Records of jay_sys_config
-- ----------------------------
INSERT INTO `jay_sys_config` VALUES ('域名', 'domain', 'test.jdyd.com', 'text', '300px', null, null, null, '1', '1');
INSERT INTO `jay_sys_config` VALUES ('电话', 'lxwmdh', '+86 1234 555 666', 'text', '300px', null, null, null, '3', '1');
INSERT INTO `jay_sys_config` VALUES ('地址', 'lxwmdz', '四川省 成都市 新津县 瑞通路140号', 'text', '300px', null, null, null, '3', '1');
INSERT INTO `jay_sys_config` VALUES ('名字', 'lxwmmm', '成都新津明宇丽雅悦酒店', 'text', '300px', null, null, null, '3', '1');
INSERT INTO `jay_sys_config` VALUES ('mchid', 'mchid', '1508626171', 'text', '300px', null, null, '商户id', '2', '3');
INSERT INTO `jay_sys_config` VALUES ('首页标题', 'title', '成都新津明宇丽雅悦酒店', 'text', '300px', '悦购汇', null, '请填写首页标题', '1', '1');
INSERT INTO `jay_sys_config` VALUES ('appid', 'wx_appid', 'wx86ffecda7e042e20', 'text', '300px', null, null, '公众号appid', '2', '1');
INSERT INTO `jay_sys_config` VALUES ('appsecret', 'wx_appsecret', '512e64fbd2f2a744519a1f5caa110219', 'text', '300px', null, null, '公众号appsecret', '2', '2');
INSERT INTO `jay_sys_config` VALUES ('微官网地址', 'wx_http', 'http网址', 'text', '300px', null, null, null, '2', '6');
INSERT INTO `jay_sys_config` VALUES ('key', 'wx_key', 'xhnf8795op47HdrXhu3ciouIHU89gfg3', 'text', '300px', null, null, '商户平台设置的key', '2', '4');
INSERT INTO `jay_sys_config` VALUES ('微信状态', 'wx_status', '2', 'radio', '300px', '[\"配置环境\",\"正式环境\"]', null, '从1开始', '2', '5');
INSERT INTO `jay_sys_config` VALUES ('token', 'wx_token', '32位加密token', 'text', '300px', null, null, '/system/Wxtoken', '2', '1');
INSERT INTO `jay_sys_config` VALUES ('素材接口', 'wx_viewurl', 'article/info', 'text', '300px', null, null, null, '2', '7');

-- ----------------------------
-- Table structure for `jay_sys_group`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_group`;
CREATE TABLE `jay_sys_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) DEFAULT NULL COMMENT '分组标题',
  `code` varchar(20) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1' COMMENT '1=显示； 0=不显示',
  `icon` varchar(20) DEFAULT 'tasks' COMMENT 'icon图标',
  `sort` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_sys_group
-- ----------------------------
INSERT INTO `jay_sys_group` VALUES ('1', '系统', 'system', '1', 'tasks', '21');
INSERT INTO `jay_sys_group` VALUES ('2', '微信', 'wechat', '1', 'tasks', '5');
INSERT INTO `jay_sys_group` VALUES ('4', '内容', 'index', '1', 'tasks', '1');
INSERT INTO `jay_sys_group` VALUES ('5', '用户', 'user', '1', 'tasks', '2');
INSERT INTO `jay_sys_group` VALUES ('6', '活动', 'news', '0', 'tasks', '3');
INSERT INTO `jay_sys_group` VALUES ('7', '房型', 'mendian', '1', 'tasks', '4');
INSERT INTO `jay_sys_group` VALUES ('8', '新闻', 'news', '0', 'tasks', '5');
INSERT INTO `jay_sys_group` VALUES ('9', '门店', 'store', '0', 'tasks', '6');
INSERT INTO `jay_sys_group` VALUES ('10', '订单', 'order', '1', 'tasks', '5');

-- ----------------------------
-- Table structure for `jay_sys_nodes`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_nodes`;
CREATE TABLE `jay_sys_nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(20) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL COMMENT '分组id',
  `codes` varchar(200) DEFAULT NULL COMMENT '操作代码',
  `args` varchar(50) DEFAULT NULL COMMENT '参数{"abc":22, "eee":"dd"}',
  `type` tinyint(4) DEFAULT '1' COMMENT '1菜单； 2操作',
  `status` tinyint(4) DEFAULT '1' COMMENT '1=启用；0无效',
  `icon` varchar(20) DEFAULT 'tasks' COMMENT '菜单图标',
  `sort` tinyint(4) DEFAULT NULL COMMENT '排序，升序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='菜单/操作节点设置';

-- ----------------------------
-- Records of jay_sys_nodes
-- ----------------------------
INSERT INTO `jay_sys_nodes` VALUES ('1', '权限节点', '1', 'nodes/index', '{\"abc\":22, \"eee\":\"dd\"}', '1', '1', 'tasks', '12');
INSERT INTO `jay_sys_nodes` VALUES ('2', '节点操作', '1', 'nodes/add,nodes/edit,nodes/delete', null, '2', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('3', '账号管理', '1', 'admins/index', null, '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('4', '账号操作', '1', 'admins/add,admins/edit,admins/delete', null, '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('5', '角色设置', '1', 'roles/index', null, '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('6', '角色设置', '1', 'roles/add,roles/edit,role/delete', null, '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('7', '授权', '1', 'roles/auth', null, '2', '1', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('8', '分组导航', '1', 'group/index', null, '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('9', '分组操作', '1', 'group/add,group/edit,group/delete', null, '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('10', '素材管理', '2', 'wxsource/index', null, '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('11', '微信菜单', '2', 'wxmenu/index', null, '1', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('13', '编辑素材', '2', 'wxsource/edit,wxsource/add,wxsource/addtxt,wxsource/edittxt,wxsource/delete', null, '2', '1', 'tasks', '4');
INSERT INTO `jay_sys_nodes` VALUES ('14', '欢迎界面', '4', 'index/index', null, '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('15', '微信菜单编辑', '2', 'wxmenu/add,wxmenu/edit,wxmenu/delete,wxmenu/create', null, '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('16', '微信设置', '2', 'config/index', '', '1', '1', 'tasks', '5');
INSERT INTO `jay_sys_nodes` VALUES ('17', '关键词列表', '2', 'wxkey/index', null, '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('18', '关键词操作', '2', 'wxkey/add,wxkey/edit,wxkey/delete', null, '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('19', '活动分类', '4', 'Categories/index', '{\"section\":4}', '1', '0', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('20', '操作日志', '1', 'admins/logs', '1', '1', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('21', '删除操作日志', '1', 'admins/deleteLogs', '', '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('22', '活动列表', '4', 'actives/index', '', '1', '0', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('23', '活动编辑', '4', 'actives/edit,actives/add,actives/delete', '', '2', '0', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('24', '会员列表', '5', 'member/index', '', '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('25', '会员编辑', '5', 'member/edit,member/delete', '', '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('27', '新闻管理', '4', 'news/index', '', '1', '1', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('28', '新闻编辑', '4', 'news/add,news/edit,news/delete', '', '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('29', '新闻分类', '4', 'Categories/index', '{\"section\":3}', '1', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('31', '周边分类', '7', 'Categories/index', '{\"section\":5}', '1', '0', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('33', '分类编辑', '4', 'categories/add,categories/edit,categories/delete', '', '2', '1', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('34', '人才招聘', '4', 'job/index', '', '1', '0', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('35', '招聘信息编辑', '4', 'job/edit,job/add,job/delete', '', '2', '0', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('36', '常见问题', '4', 'question/index', '', '1', '1', 'tasks', '5');
INSERT INTO `jay_sys_nodes` VALUES ('37', '问题编辑', '4', 'question/add,question/edit,question/delete', '', '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('38', '直营店管理', '9', 'store/index', '{\"section\":28}', '1', '0', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('39', '门店编辑', '9', 'store/add,store/edit,store/delete', '', '2', '0', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('40', '门店类型', '9', 'Categories/index', '{\"section\":6}', '1', '0', 'tasks', '4');
INSERT INTO `jay_sys_nodes` VALUES ('45', '周边信息', '7', 'near/index', '', '1', '0', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('46', '周边内容维护', '7', 'near/add,near/edit,near/delete', '', '2', '0', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('47', '加盟店管理', '9', 'store/index', '{\"section\":29}', '1', '0', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('48', '单页内容', '4', 'page/index', '{\"section\":1}', '1', '1', 'tasks', '4');
INSERT INTO `jay_sys_nodes` VALUES ('49', '单页内容维护', '4', 'page/add,page/edit,page/delete', '', '2', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('50', 'banner管理', '4', 'banner/index', '', '1', '1', 'tasks', '6');
INSERT INTO `jay_sys_nodes` VALUES ('51', 'banner管理', '4', 'banner/add,banner/edit,banner/delete', '', '2', '1', 'tasks', '6');
INSERT INTO `jay_sys_nodes` VALUES ('52', '生活汇', '4', 'yue/index', '', '1', '0', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('53', '生活汇', '4', 'yue/add,yue/edit,yue/delete', '', '2', '0', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('54', '预定记录', '5', 'actives/apply', '', '1', '0', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('55', '删除预定', '5', 'actives/applydelete', '', '2', '0', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('56', '删除预定记录', '5', 'actives/deleteapply', '', '2', '0', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('57', '房型管理', '7', 'room/index', '', '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('58', '房型编辑', '7', 'room/add,room/edit,room/delete', '', '2', '1', 'tasks', '2');
INSERT INTO `jay_sys_nodes` VALUES ('59', '增值服务', '7', 'serviceitem/index', '', '1', '1', 'tasks', '3');
INSERT INTO `jay_sys_nodes` VALUES ('60', '服务编辑', '7', 'serviceitem/add,serviceitem/edit,serviceitem/delete', '', '2', '1', 'tasks', '5');
INSERT INTO `jay_sys_nodes` VALUES ('61', '订单管理', '10', 'order/index', '', '1', '1', 'tasks', '1');
INSERT INTO `jay_sys_nodes` VALUES ('62', '操作', '10', 'order/delete,order/refund,order/refuse,order/view,order/ruzhu', '', '2', '1', 'tasks', '2');

-- ----------------------------
-- Table structure for `jay_sys_roles`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_roles`;
CREATE TABLE `jay_sys_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(20) DEFAULT NULL,
  `remarks` varchar(30) DEFAULT NULL COMMENT '备注',
  `status` tinyint(4) DEFAULT '1' COMMENT '1',
  `addtime` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of jay_sys_roles
-- ----------------------------
INSERT INTO `jay_sys_roles` VALUES ('1', '系统管理员', '超级管理员，超级权限', '1', '2017-08-01');
INSERT INTO `jay_sys_roles` VALUES ('2', '测试', '测试', '1', '2017-08-01');
INSERT INTO `jay_sys_roles` VALUES ('3', '产品维护1', '负责产品模块的文化1', '1', '2017-08-07 15:04:58');

-- ----------------------------
-- Table structure for `jay_sys_temp_uploadimages`
-- ----------------------------
DROP TABLE IF EXISTS `jay_sys_temp_uploadimages`;
CREATE TABLE `jay_sys_temp_uploadimages` (
  `fileurl` varchar(100) NOT NULL DEFAULT '',
  `addtime` int(11) DEFAULT NULL,
  PRIMARY KEY (`fileurl`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='图片上传的中间表，用于删除没用的图片';

-- ----------------------------
-- Records of jay_sys_temp_uploadimages
-- ----------------------------
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\0d03cc5cfd5b496a66a818c7462e43ff.png', '1503043553');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\0ff0b14ea3f39f87c2259c9d044c8357.png', '1503044356');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\16c0152676354046a9e5703c26cacc6c.png', '1503045736');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\19761945de3986e44262c62cce62f3c3.png', '1503045731');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\248b98ddb6d407c567f96f9ab4fce167.png', '1503041578');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\276511df0b98e120750b884010f6e3a6.png', '1503042497');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\2aa5be47643376fe12b747957098fc67.png', '1503041558');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\2cd0505118b2baaedf5e469acab49a10.png', '1503041453');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\2e573327adc3f07b331627171d613417.png', '1503042566');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\378aa6c5f27351cfb28a560fff56bbc3.png', '1503042560');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\3a40e5eb369ec7b3a8f57fcb86e811ff.png', '1503041575');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\43d54f8af0e5f0cf71beac76a1db7004.png', '1503042566');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\45e8623671a97378ffb2725209c11688.png', '1503041638');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\4f7feffe19c906412147936316490cd3.png', '1503042560');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\5c3ee2c92211a95c9dae1284971e7dda.png', '1503042560');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\603b1f5ea2b28c607d843e95aed43124.png', '1503045993');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\655110f0ead3a843fdef017eba17b188.png', '1503041755');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\65535bdb13ec52b9190a84a65fe07b92.png', '1503042566');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\6a5610d36ccb324996c7446135e8ee53.png', '1503042560');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\6af5b93e645b58c73b50edfbb07fbc4b.png', '1503041578');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\6e7ef4b711684e78b98e1d29ede03cd3.png', '1503042566');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\6e9b9d128b4f77f6f42d6411cf3eae61.png', '1503042497');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\7271d78320eeff1059316c38e4d51928.png', '1503042481');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\736bcc2d890bc792b677fc56c71002f4.png', '1503042215');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\74fdf31d06c6b2b408014845c19b8547.png', '1503045253');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\7cfbd20efefc505eb2d7552492eece7d.png', '1503042497');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\7f80820eecef37e3f486002585a7e344.png', '1503042566');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\8169e1e9109d42cef3552296c8149c47.png', '1503046206');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\82ae3c00a717390d9dd31aa6e7dfa7cf.png', '1503042215');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\90ce184635aeff7f2de6dcc32446ef41.png', '1503042566');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\975ed1378bb61fcfcf7de5928db5289e.png', '1503042561');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\a25ca46d0244b894c7aeeb501b5e428f.png', '1503042481');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\aff4bca011d70dfb52439a01c6666d67.png', '1503042561');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\b8ce01652d339080da46f86dc3ac758f.jpg', '1503042860');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\c568ca08df2e4da0da4d65edb726281e.png', '1503042962');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\c617c3028f13e7d0c602b9348a0aeec5.png', '1503045748');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\c7c0dc232837ffdc0221614e37d507db.png', '1503041259');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\cf31732f941dfd31b696dab02e745df9.png', '1503042561');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\cf9594caee1f0d517fd7026eaa111d60.png', '1503042561');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\d343b2fe1464279ec4beba9ee58035b9.png', '1503042481');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\d7211d17cff85a3b09a0714adc3ab407.png', '1503042566');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\d7286426ec21dd57dd58d2e176854265.png', '1503041755');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\df4ecbf97a35445ca995c2063465f674.png', '1503042446');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\e6b2fe65efdeb2b63b785288af2b380f.png', '1503045743');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\eeb07707643fb52281d7c06f3e60611b.png', '1503042215');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\f21ef4bf977ebff5603adabe157e552a.png', '1503044356');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\f76c0672ced1332f31d37d97491e6bf0.png', '1503041578');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\f7c22f0898e4105d04cb8c2a170f201a.png', '1503042565');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\fbcff8c97e9e9c356f0f80fcd2b945c4.png', '1503044129');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170818\\fbdfe2ab46cfa47d99ba485ea2909b09.png', '1503042561');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170819\\8646ca40841b1fba13d71587a42de3b7.png', '1503127321');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170819\\88344238435a810881858282220a7500.png', '1503128652');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170819\\9479f8e9e79edd68cc2d1c2e7187044f.png', '1503128683');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20170819\\9621636c717dfdbb23a3e1485b1ee3fd.png', '1503129697');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171025\\4944c8388b3a64f70db54365a38e8df1.jpg', '1508894027');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171025\\53e828b480cbbf298724caba1a433ae7.jpg', '1508894286');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171025\\97ce7154f27beb29739d00d545ac3845.jpg', '1508894360');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171025\\a07d48f70288fb23016a23c17245f740.jpg', '1508894071');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171025\\d46b9205548fe98101061a2aacc1de9f.jpg', '1508894337');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171027\\ebe41dc7ca1124e9a9161e8db0334043.jpg', '1509086925');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171121\\95fbd6e8200e960bf96f82ba748f61c4.png', '1511245503');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171121\\d8a52af9a7e263e529663ef8418f394d.png', '1511246657');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171124\\5275f6059211ff8007bfd1eed0e70db2.jpg', '1511488747');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171124\\63f1e3198364d166eba5df49d226bde7.jpg', '1511488728');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171124\\8b52c8ee5537681949f2250d176bbbc8.jpg', '1511488712');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171124\\9dca3ae9468bc047a21d3876265a8b80.jpg', '1511488878');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171124\\a632e5a9a5a96b76c24b6db3c109dd22.jpg', '1511488880');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171124\\c0d9e3ad77f7bf9e77a8eb86d80eb500.jpg', '1511488745');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171124\\fa4fb2160b0d69101df0ba7ed18e1646.jpg', '1511488705');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171125\\2281622bc3c2b2308d92219a4fe1830e.jpg', '1511597941');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171125\\58800e8619c66300ca6a285e49a2ceff.jpg', '1511617655');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171125\\81ec22f5bce57c7beccf40524ab623fa.jpg', '1511617541');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171125\\cd7ee00a1470f30ff14fe0e72973ccbc.jpg', '1511617555');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\197b64a8f4e22d2cb37be7addaa84f14.png', '1511969963');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\44f6a468cbd974ac0185413615b03f24.jpg', '1511969939');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\66e1d0640923527a44216e65152135be.jpg', '1511970008');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\6dc469dfc9b71743cca93a9e5a61c454.png', '1511959463');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\79a04357f673fdacf9db86777e016c96.jpg', '1511969984');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\8cdf1a1ec1a07e850452c9b98c9ace77.jpg', '1511969380');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\b1bb263872e7e771f46bb22de62f74ac.jpg', '1511969973');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171129\\fca53f1d60f89c2985ead97e8b8f34c5.jpg', '1511969952');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171130\\571fafadb6aa937ab0ed7aa9f5826c9e.jpg', '1512055052');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20171130\\9aa4f51b2eff3ae32d0081201f08f11b.png', '1512055210');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20180723\\03d455f1bb5e2de34f88237e118401b0.png', '1532315960');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20180723\\513e7a23faa385d0afb1e0c269671543.png', '1532315956');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20180723\\a24a864cce8ed4580629778661169951.png', '1532321249');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20180801\\9dc6ad8d4070ecfbe19510bb1ccb2641.jpg', '1533105743');
INSERT INTO `jay_sys_temp_uploadimages` VALUES ('20180801\\ebec8a89d13018b60172be784aaeb139.jpg', '1533105763');

-- ----------------------------
-- Table structure for `jay_wx_attachment`
-- ----------------------------
DROP TABLE IF EXISTS `jay_wx_attachment`;
CREATE TABLE `jay_wx_attachment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sourceid` int(11) DEFAULT NULL,
  `type` tinyint(4) DEFAULT '1' COMMENT '1阅读记录 2点赞记录 3评论',
  `userid` int(11) DEFAULT NULL COMMENT '会员id',
  `vtime` varchar(22) DEFAULT NULL COMMENT '具体时间',
  `commen` varchar(80) DEFAULT NULL COMMENT '评论内容',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='微信资源 数据记录表（阅读、点赞、评论记录）';

-- ----------------------------
-- Records of jay_wx_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for `jay_wx_keywords`
-- ----------------------------
DROP TABLE IF EXISTS `jay_wx_keywords`;
CREATE TABLE `jay_wx_keywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(20) DEFAULT NULL,
  `groupid` int(11) DEFAULT NULL,
  `addtime` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_wx_keywords
-- ----------------------------
INSERT INTO `jay_wx_keywords` VALUES ('1', '默认', '2', '2016-05-03 10:13:19');
INSERT INTO `jay_wx_keywords` VALUES ('5', '电话', '8', '2016-07-03 19:52:45');
INSERT INTO `jay_wx_keywords` VALUES ('6', '联系', '8', '2016-07-03 19:52:55');
INSERT INTO `jay_wx_keywords` VALUES ('7', '员工', '9', '2016-12-13 09:45:51');
INSERT INTO `jay_wx_keywords` VALUES ('8', '232', '10', '2017-10-25 09:03:58');
INSERT INTO `jay_wx_keywords` VALUES ('9', '联系', '13', '2017-10-24 20:43:41');

-- ----------------------------
-- Table structure for `jay_wx_menu`
-- ----------------------------
DROP TABLE IF EXISTS `jay_wx_menu`;
CREATE TABLE `jay_wx_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT '0',
  `name` varchar(20) DEFAULT NULL COMMENT '菜单名称',
  `type` varchar(20) DEFAULT NULL COMMENT '菜单类型， click/view',
  `key` varchar(32) DEFAULT NULL COMMENT 'click对应的值',
  `url` varchar(150) DEFAULT NULL COMMENT 'view对应的网址',
  `iscode` tinyint(4) DEFAULT '0' COMMENT '1是否加密',
  `groupid` int(11) DEFAULT NULL COMMENT 'click绑定的素材id',
  `addtime` varchar(22) DEFAULT NULL,
  `sort` tinyint(4) DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_wx_menu
-- ----------------------------
INSERT INTO `jay_wx_menu` VALUES ('1', '-1', '关注', 'subscribe', null, '', '0', '6', '2016-07-03 20:02:16', '126');
INSERT INTO `jay_wx_menu` VALUES ('2', '-1', '取消关注', 'unsubscribe', null, '', '0', null, '2016-07-03 19:53:17', '127');
INSERT INTO `jay_wx_menu` VALUES ('16', '0', '微邮局', 'click', 'e5d38f9ea8ebc077f765520923b77828', '', '0', '0', '2016-12-12 17:30:55', '1');
INSERT INTO `jay_wx_menu` VALUES ('17', '0', '微商城', 'click', 'e370fe1e4c9852f3ccd88140de20b081', '', '0', '0', '2016-12-12 17:31:03', '2');
INSERT INTO `jay_wx_menu` VALUES ('18', '0', '服务中心', 'click', 'a6bc31061573531db1a6245523c65bb0', '', '0', '0', '2016-12-12 17:31:10', '3');
INSERT INTO `jay_wx_menu` VALUES ('19', '16', '金融服务', 'view', '4fe39f7b495eb9c07032f76e497972ef', 'http://www.ycpostwgw.cn/index.php/Shop/Zixun/index/validate/1.html', '1', '0', '2016-12-12 17:40:44', '4');
INSERT INTO `jay_wx_menu` VALUES ('20', '16', '函件传媒', 'view', '5dfc810002e8ee455130351a7aa3b065', 'http://mp.weixin.qq.com/s?__biz=MzI1MzAxMzM0NQ==&mid=2651574766&idx=1&sn=43aca8e5298c3630960068dbaabafd34&chksm=f2258de0c55204f6dead826a9dde8a7d5d9392', '0', '0', '2016-12-12 17:33:16', '5');
INSERT INTO `jay_wx_menu` VALUES ('21', '16', '报刊订阅', 'click', '0ad85975c865ee36ab37e6bf67a977b5', 'http://wxbk.dg11185.com/index.do', '0', '12', '2017-10-24 20:42:36', '1');
INSERT INTO `jay_wx_menu` VALUES ('22', '16', '邮品收藏', 'view', '7e9991aa96b582602915831617335043', 'http://weidian.com/s/894557508', '1', '0', '2017-10-24 19:06:29', '2');
INSERT INTO `jay_wx_menu` VALUES ('23', '16', '寄递服务', 'view', '2a58925b7f5ca2ff79ad6bec65f84032', 'http://www.ycpostwgw.cn/index.php/Shop/Pikup/home/validate/1.html', '1', '0', '2016-12-12 17:40:55', '3');
INSERT INTO `jay_wx_menu` VALUES ('24', '17', '综合商城', 'view', '657bc641b8803dffdcf91847a3a8f822', 'http://www.ycpostwgw.cn/index.php/Shop/Index/index/validate/1.html', '1', '0', '2016-12-12 17:39:25', '1');
INSERT INTO `jay_wx_menu` VALUES ('25', '18', '幸运大转盘', 'view', '6e59a758bd6d2b4c4e8b87d6202a49a9', 'http://www.ycpostwgw.cn/index.php/Shop/Games/index.html', '1', '0', '2016-12-12 17:35:37', '5');
INSERT INTO `jay_wx_menu` VALUES ('26', '18', '我的订单', 'view', 'a0a518faa894a93bb57039a2a80632fb', 'http://www.ycpostwgw.cn/index.php/Shop/Order/index/validate/1.html', '1', '0', '2016-12-12 17:41:06', '4');
INSERT INTO `jay_wx_menu` VALUES ('27', '18', '查询服务', 'view', 'fbaec1e13b454e31751b458d8d86cc9e', 'http://www.ycpostwgw.cn/index.php/Shop/SearchPage/index/validate/1.html', '1', '0', '2016-12-12 17:41:15', '3');
INSERT INTO `jay_wx_menu` VALUES ('28', '18', '留言板', 'view', '9303196a68b73717fcf2ac4d59a6aa71', 'http://www.ycpostwgw.cn/index.php/Shop/Liuyan/index/validate/1.html', '1', '0', '2016-12-12 17:41:22', '2');
INSERT INTO `jay_wx_menu` VALUES ('29', '18', '员工入口', 'view', 'f6a31b84257a8ad491e373801b30a5db', 'http://www.ycpostwgw.cn/index.php/Home/Index/tg', '1', '0', '2016-12-14 14:32:36', '1');
INSERT INTO `jay_wx_menu` VALUES ('30', '17', '积分商城', 'view', 'cbfcc28e71788002ae59057454b8e6b5', 'http://111.75.223.93:8013/jxjf/uleIndexUI.action', '0', '0', '2017-02-20 17:52:38', '2');

-- ----------------------------
-- Table structure for `jay_wx_qrcode`
-- ----------------------------
DROP TABLE IF EXISTS `jay_wx_qrcode`;
CREATE TABLE `jay_wx_qrcode` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `qname` varchar(20) DEFAULT NULL,
  `ticket` varchar(200) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `addtime` varchar(22) DEFAULT NULL,
  `status` tinyint(4) DEFAULT '1' COMMENT '1有效  0无效',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='场景二维码';

-- ----------------------------
-- Records of jay_wx_qrcode
-- ----------------------------
INSERT INTO `jay_wx_qrcode` VALUES ('6', '成华区', 'gQHz8DoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL1MwTzdRUXJtV09ZaDdZU2huMjlkAAIE3sclVwMEAAAAAA==', 'http://weixin.qq.com/q/S0O7QQrmWOYh7YShn29d', '2016-05-01 17:09:48', '1');

-- ----------------------------
-- Table structure for `jay_wx_sourcegroup`
-- ----------------------------
DROP TABLE IF EXISTS `jay_wx_sourcegroup`;
CREATE TABLE `jay_wx_sourcegroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createtime` int(11) DEFAULT NULL,
  `msgtype` tinyint(4) DEFAULT '1' COMMENT '1图文 2文字',
  `returnstr` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_wx_sourcegroup
-- ----------------------------

-- ----------------------------
-- Table structure for `jay_wx_sourceitems`
-- ----------------------------
DROP TABLE IF EXISTS `jay_wx_sourceitems`;
CREATE TABLE `jay_wx_sourceitems` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupid` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `abstract` varchar(200) DEFAULT NULL,
  `pic` varchar(50) DEFAULT NULL,
  `content` text,
  `addtime` int(11) DEFAULT NULL,
  `type` tinyint(4) DEFAULT '1' COMMENT '1本网页打开  2网页跳转打开',
  `iscode` tinyint(4) DEFAULT '0' COMMENT '1进行网页授权加密',
  `url` varchar(255) DEFAULT NULL COMMENT '点击页面跳转url/原文链接',
  `sort` tinyint(4) DEFAULT '1' COMMENT '排序',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jay_wx_sourceitems
-- ----------------------------
INSERT INTO `jay_wx_sourceitems` VALUES ('1', '1', '宝兴县仁朵生态1', '', '20160429/5722c4a60450f.png', '', '1461896381', '1', '0', '', '0');
INSERT INTO `jay_wx_sourceitems` VALUES ('3', '2', '李克强夜访成都宽窄巷  主持国务院常务会议2', '4月25日晚8时20分许，一辆中巴车悄然停在成都宽窄巷的巷口。李克强及随行10多人...', '20160429/5722c6311eee2.png', '<p style=\"font-size:16px;font-family:SimSun;color:#2B2B2B;\">\r\n	4月<strong>25日晚8时20分许，一辆</strong>中巴车悄然停在成都宽窄巷的巷口。李克强及随行10多人走下车来。像一位游客一样，他一连走访了几家小店铺，并买了几样别具特色的旅游纪念品和书籍。在一间啤酒屋前，他还向一位外国游客推荐起了<a href=\"http://country.huanqiu.com/china\" class=\"linkAbout\" target=\"_blank\">中国</a>的“青岛啤酒”。\r\n</p>\r\n<p style=\"font-size:16px;font-family:SimSun;color:#2B2B2B;\">\r\n	表面看，这只是一趟“闲庭信步”似的观光行程，但事实上，总理在每个摊位前的驻足，都是一场“小型调研”。他向多位店主详细询问生意变化状况、税费负担情况，以及对即将推出的“营改增”意见，实地感知“市场温度”。\r\n</p>\r\n<p style=\"font-size:16px;font-family:SimSun;color:#2B2B2B;\">\r\n	“巷子可以窄，造福百姓的思路一定要宽”\r\n</p>', '1462236765', '2', '0', '', '0');
INSERT INTO `jay_wx_sourceitems` VALUES ('4', '2', '省份出台户籍改革方 部分地区放宽落户条件', '<pstyle=\"font-size:16px;font-family:SimSun;color:#2B2B2B;\"><strong>29省份出台户改方案</strong></p><pstyle=\"f...', '20160429/5722c63947f84.png', '<p style=\"font-size:16px;font-family:SimSun;color:#2B2B2B;\">\r\n	<strong>29省份出台户改方案</strong>\r\n</p>\r\n<p style=\"font-size:16px;font-family:SimSun;color:#2B2B2B;\">\r\n	国家发改委规划司司长徐林4月19日在新闻发布会上透露，国务院出台户籍制度改革方案之后，目前全国有28个省市自治区出台了户籍制度改革的具体方案，还有几个地方还没有出，所以今年首要任务是使所有的地方都能够出台具体落实国务院户籍制度改革的做法和政策。\r\n</p>\r\n<p style=\"font-size:16px;font-family:SimSun;color:#2B2B2B;\">\r\n	随后在4月25日，上海对外公布《关于进一步推进本市户籍制度改革的若干意见》。至此，目前中国出台户籍制度改革方案的省份增加到29个。\r\n</p>', '1462236765', '1', '1', '', '1');
INSERT INTO `jay_wx_sourceitems` VALUES ('5', '10', '测试11111', '收费但是防守打法在要', '20170819\\8646ca40841b1fba13d71587a42de3b7.png', '似懂非懂佛挡杀佛', '1508894294', '2', '0', 'http://test.xieenjie.com/system/wxsource/edit/id/10.html', '0');
INSERT INTO `jay_wx_sourceitems` VALUES ('6', '11', '请填写接口配置信息1', '信息需要你有自己的服务器资源，填写的URL需要正确响应微信发送的T2', '20170819\\88344238435a810881858282220a7500.png', '<p>\r\n	这里是个<strong>编辑器</strong> \r\n</p>\r\n<p>\r\n	<strong>爽肤水4</strong>\r\n</p>\r\n<p>\r\n	<strong>想</strong> \r\n</p>', '1503129698', '1', '0', '3', '0');
INSERT INTO `jay_wx_sourceitems` VALUES ('7', '11', '设置JS接口安全域后5', '通过关注该测试号，开发者即可在该域名下调用微信开放的JS接口6', '20170819\\9479f8e9e79edd68cc2d1c2e7187044f.png', '<span style=\"color:#222222;font-family:\" font-size:14px;background-color:#ffffff;\"=\"\">通过关注<span style=\"background-color:#99BB00;\">该测试号，开发者即可</span>在该域名下调<em>用微信开放的JS接口</em></span><span style=\"color:#222222;font-family:\" font-size:14px;background-color:#ffffff;\"=\"\"><em>通过关注该测试号，开发者即可在该域名下调用微信开放的JS接口</em></span><span style=\"color:#222222;font-family:\" font-size:14px;background-color:#ffffff;\"=\"\"><em>通过关注该测试号，开发者即可在该域名下调用</em>微信开放的JS接口</span><span style=\"color:#222222;font-family:\" font-size:14px;background-color:#ffffff;\"=\"\">通过关注该测试号，开发者即可在该域名下调用微信开放的JS接口8</span>', '1503129698', '1', '1', '7', '1');
INSERT INTO `jay_wx_sourceitems` VALUES ('10', '16', '添加add111', 'fuck', '20171025\\d46b9205548fe98101061a2aacc1de9f.jpg', 'fuc1', '1508894500', '1', '0', '', '0');
