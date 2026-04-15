-- 1. 用户表
CREATE TABLE `sys_user` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password` VARCHAR(100) NOT NULL COMMENT '密码',
  `name` VARCHAR(50) NOT NULL COMMENT '真实姓名',       
  `phone` VARCHAR(20) COMMENT '手机号',
  `email` VARCHAR(100) COMMENT '邮箱',  
  `department` VARCHAR(50) COMMENT '部门',
  `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 2. 角色表
CREATE TABLE `sys_role` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name` VARCHAR(50) NOT NULL COMMENT '角色名称',
  `code` VARCHAR(50) NOT NULL COMMENT '角色代码',
  `description` VARCHAR(200) COMMENT '角色描述',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 3. 权限表
CREATE TABLE `sys_permission` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `name` VARCHAR(50) NOT NULL COMMENT '权限名称',
  `code` VARCHAR(100) NOT NULL COMMENT '权限代码',
  `type` INT NOT NULL COMMENT '权限类型：1-菜单，2-按钮',
  `path` VARCHAR(200) COMMENT '菜单路径',
  `parent_id` BIGINT COMMENT '父权限ID',
  `order_num` INT DEFAULT 0 COMMENT '排序号',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  INDEX `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 4. 用户角色关联表
CREATE TABLE `sys_user_role` (
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `role_id` BIGINT NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`),
  FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 5. 角色权限关联表
CREATE TABLE `sys_role_permission` (
  `role_id` BIGINT NOT NULL COMMENT '角色ID',
  `permission_id` BIGINT NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`role_id`, `permission_id`),
  FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 6. 客户表
CREATE TABLE `customer` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `name` VARCHAR(50) NOT NULL COMMENT '客户姓名',
  `gender` INT COMMENT '性别：1-男，2-女',
  `phone` VARCHAR(20) NOT NULL COMMENT '手机号',
  `email` VARCHAR(100) COMMENT '邮箱',
  `id_card` VARCHAR(20) COMMENT '身份证号',
  `address` VARCHAR(200) COMMENT '地址',
  `level_id` BIGINT COMMENT '客户等级ID',
  `source` VARCHAR(50) COMMENT '客户来源',
  `total_consumption` DECIMAL(12,2) DEFAULT 0 COMMENT '总消费金额',
  `order_count` INT DEFAULT 0 COMMENT '订单数量',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_phone` (`phone`),
  INDEX `idx_level_id` (`level_id`),
  INDEX `idx_total_consumption` (`total_consumption`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户表';

-- 7. 客户等级表
CREATE TABLE `customer_level` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '等级ID',
  `name` VARCHAR(50) NOT NULL COMMENT '等级名称',
  `min_consumption` DECIMAL(12,2) NOT NULL COMMENT '最低消费金额',
  `discount` DECIMAL(5,2) DEFAULT 1.0 COMMENT '折扣系数',
  `description` VARCHAR(200) COMMENT '等级描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户等级表';

-- 8. 客户标签表
CREATE TABLE `customer_tag` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `name` VARCHAR(50) NOT NULL COMMENT '标签名称',
  `description` VARCHAR(200) COMMENT '标签描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户标签表';

-- 9. 客户标签关联表
CREATE TABLE `customer_tag_relation` (
  `customer_id` BIGINT NOT NULL COMMENT '客户ID',
  `tag_id` BIGINT NOT NULL COMMENT '标签ID',
  PRIMARY KEY (`customer_id`, `tag_id`),
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`tag_id`) REFERENCES `customer_tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户标签关联表';

-- 10. 客户跟进记录表
CREATE TABLE `customer_follow` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '跟进记录ID',
  `customer_id` BIGINT NOT NULL COMMENT '客户ID',
  `user_id` BIGINT NOT NULL COMMENT '跟进人ID',
  `follow_time` DATETIME NOT NULL COMMENT '跟进时间',
  `content` TEXT COMMENT '跟进内容',
  `next_follow_time` DATETIME COMMENT '下次跟进时间',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_customer_id` (`customer_id`),
  INDEX `idx_user_id` (`user_id`),
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户跟进记录表';

-- 11. 景点表
CREATE TABLE `scenic_spot` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '景点ID',
  `name` VARCHAR(100) NOT NULL COMMENT '景点名称',
  `address` VARCHAR(200) NOT NULL COMMENT '地址',
  `ticket_price` DECIMAL(10,2) NOT NULL COMMENT '门票价格',
  `opening_hours` VARCHAR(100) COMMENT '开放时间',
  `description` TEXT COMMENT '景点描述',
  `cover_image` VARCHAR(255) COMMENT '封面图片',
  `rating` DECIMAL(3,1) DEFAULT 0 COMMENT '评分',
  `visit_count` INT DEFAULT 0 COMMENT '访问次数',
  `category_id` BIGINT COMMENT '景点分类ID',
  `supplier_id` BIGINT COMMENT '供应商ID',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_category_id` (`category_id`),
  INDEX `idx_supplier_id` (`supplier_id`),
  INDEX `idx_rating` (`rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='景点表';

-- 12. 景点分类表
CREATE TABLE `scenic_category` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `description` VARCHAR(200) COMMENT '分类描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='景点分类表';

-- 13. 景点评价表
CREATE TABLE `scenic_comment` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '评价ID',
  `scenic_id` BIGINT NOT NULL COMMENT '景点ID',
  `customer_id` BIGINT NOT NULL COMMENT '客户ID',
  `rating` INT NOT NULL COMMENT '评分（1-5）',
  `content` TEXT COMMENT '评价内容',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_scenic_id` (`scenic_id`),
  INDEX `idx_customer_id` (`customer_id`),
  FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spot` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='景点评价表';

-- 14. 供应商表
CREATE TABLE `supplier` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
  `name` VARCHAR(100) NOT NULL COMMENT '供应商名称',
  `contact_person` VARCHAR(50) COMMENT '联系人',
  `contact_phone` VARCHAR(20) COMMENT '联系电话',
  `address` VARCHAR(200) COMMENT '地址',
  `description` TEXT COMMENT '供应商描述',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='供应商表';

-- 15. 旅游线路表
CREATE TABLE `travel_route` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '线路ID',
  `name` VARCHAR(100) NOT NULL COMMENT '线路名称',
  `description` TEXT COMMENT '线路描述',
  `days` INT NOT NULL COMMENT '行程天数',
  `type` VARCHAR(50) COMMENT '线路类型：多日游、主题游、定制游',
  `departure_city` VARCHAR(50) NOT NULL COMMENT '出发城市',
  `cost_price` DECIMAL(12,2) NOT NULL COMMENT '成本价',
  `sale_price` DECIMAL(12,2) NOT NULL COMMENT '销售价',
  `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1-上架，0-下架',
  `cover_image` VARCHAR(255) COMMENT '封面图片',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='旅游线路表';

-- 16. 线路行程表
CREATE TABLE `route_itinerary` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '行程ID',
  `route_id` BIGINT NOT NULL COMMENT '线路ID',
  `day` INT NOT NULL COMMENT '第几天',
  `title` VARCHAR(100) NOT NULL COMMENT '行程标题',
  `description` TEXT COMMENT '行程描述',
  `scenic_ids` VARCHAR(255) COMMENT '关联景点ID，逗号分隔',
  `hotel_id` BIGINT COMMENT '酒店ID',
  `transportation` VARCHAR(200) COMMENT '交通方式',
  PRIMARY KEY (`id`),
  INDEX `idx_route_id` (`route_id`),
  FOREIGN KEY (`route_id`) REFERENCES `travel_route` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='线路行程表';

-- 17. 导游表
CREATE TABLE `guide` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '导游ID',
  `name` VARCHAR(50) NOT NULL COMMENT '导游姓名',
  `phone` VARCHAR(20) NOT NULL COMMENT '手机号',
  `guide_card` VARCHAR(50) NOT NULL COMMENT '导游证号',
  `level` VARCHAR(50) COMMENT '导游等级',
  `experience` INT COMMENT '工作经验（年）',
  `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1-可用，0-不可用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_guide_card` (`guide_card`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='导游表';

-- 18. 车辆表
CREATE TABLE `vehicle` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '车辆ID',
  `plate_number` VARCHAR(20) NOT NULL COMMENT '车牌号',
  `model` VARCHAR(50) COMMENT '车型',
  `seat_count` INT NOT NULL COMMENT '座位数',
  `status` INT NOT NULL DEFAULT 1 COMMENT '状态：1-可用，0-不可用',
  `supplier_id` BIGINT COMMENT '供应商ID',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_plate_number` (`plate_number`),
  INDEX `idx_status` (`status`),
  INDEX `idx_supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='车辆表';

-- 19. 酒店表
CREATE TABLE `hotel` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '酒店ID',
  `name` VARCHAR(100) NOT NULL COMMENT '酒店名称',
  `address` VARCHAR(200) NOT NULL COMMENT '地址',
  `star_level` INT COMMENT '星级',
  `contact_phone` VARCHAR(20) COMMENT '联系电话',
  `supplier_id` BIGINT COMMENT '供应商ID',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_supplier_id` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='酒店表';

-- 20. 发团计划表
CREATE TABLE `group_plan` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '发团计划ID',
  `route_id` BIGINT NOT NULL COMMENT '线路ID',
  `group_code` VARCHAR(50) NOT NULL COMMENT '团号',
  `start_date` DATE NOT NULL COMMENT '出发日期',
  `end_date` DATE NOT NULL COMMENT '结束日期',
  `total_seats` INT NOT NULL COMMENT '总座位数',
  `booked_seats` INT DEFAULT 0 COMMENT '已预订座位数',
  `guide_id` BIGINT COMMENT '导游ID',
  `vehicle_id` BIGINT COMMENT '车辆ID',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态：pending-待发团，ongoing-进行中，completed-已完成，cancelled-已取消',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_code` (`group_code`),
  INDEX `idx_route_id` (`route_id`),
  INDEX `idx_start_date` (`start_date`),
  INDEX `idx_status` (`status`),
  FOREIGN KEY (`route_id`) REFERENCES `travel_route` (`id`),
  FOREIGN KEY (`guide_id`) REFERENCES `guide` (`id`),
  FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='发团计划表';

-- 21. 订单表
CREATE TABLE `order` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no` VARCHAR(50) NOT NULL COMMENT '订单号',
  `customer_id` BIGINT NOT NULL COMMENT '客户ID',
  `group_plan_id` BIGINT NOT NULL COMMENT '发团计划ID',
  `adult_count` INT NOT NULL DEFAULT 0 COMMENT '成人数量',
  `child_count` INT NOT NULL DEFAULT 0 COMMENT '儿童数量',
  `total_amount` DECIMAL(12,2) NOT NULL COMMENT '总金额',
  `actual_amount` DECIMAL(12,2) NOT NULL COMMENT '实际支付金额',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '状态：pending-待支付，paid-已支付，confirmed-已确认，completed-已完成，cancelled-已取消，refunded-已退款',
  `payment_time` DATETIME COMMENT '支付时间',
  `remark` VARCHAR(200) COMMENT '备注',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  INDEX `idx_customer_id` (`customer_id`),
  INDEX `idx_group_plan_id` (`group_plan_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_create_time` (`create_time`),
  FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`),
  FOREIGN KEY (`group_plan_id`) REFERENCES `group_plan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 22. 订单明细
CREATE TABLE `order_item` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id` BIGINT NOT NULL COMMENT '订单ID',
  `name` VARCHAR(50) NOT NULL COMMENT '乘客姓名',
  `id_card` VARCHAR(20) NOT NULL COMMENT '身份证号',
  `type` VARCHAR(10) NOT NULL COMMENT '类型：adult-成人，child-儿童',
  `price` DECIMAL(12,2) NOT NULL COMMENT '单价',
  PRIMARY KEY (`id`),
  INDEX `idx_order_id` (`order_id`),
  FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- 23. 订单状态日志
CREATE TABLE `order_status_log` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `order_id` BIGINT NOT NULL COMMENT '订单ID',
  `old_status` VARCHAR(20) NOT NULL COMMENT '旧状态',
  `new_status` VARCHAR(20) NOT NULL COMMENT '新状态',
  `operator` BIGINT COMMENT '操作人ID',
  `remark` VARCHAR(200) COMMENT '备注',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_order_id` (`order_id`),
  FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单状态日志表';

-- 24. 财务记录表
CREATE TABLE `financial_record` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '财务记录ID',
  `type` VARCHAR(20) NOT NULL COMMENT '类型：income-收入，expense-支出',
  `category` VARCHAR(50) NOT NULL COMMENT '分类',
  `amount` DECIMAL(12,2) NOT NULL COMMENT '金额',
  `related_id` BIGINT COMMENT '关联ID（如订单ID、供应商ID等）',
  `related_type` VARCHAR(20) COMMENT '关联类型',
  `payment_method` VARCHAR(50) COMMENT '支付方式',
  `remark` VARCHAR(200) COMMENT '备注',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_type` (`type`),
  INDEX `idx_category` (`category`),
  INDEX `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='财务记录表';

-- 25. 数据字典表
CREATE TABLE `sys_dict` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '字典ID',
  `type` VARCHAR(50) NOT NULL COMMENT '字典类型',
  `code` VARCHAR(50) NOT NULL COMMENT '字典编码',
  `name` VARCHAR(50) NOT NULL COMMENT '字典名称',
  `value` VARCHAR(255) COMMENT '字典值',
  `order_num` INT DEFAULT 0 COMMENT '排序号',
  PRIMARY KEY (`id`),
  INDEX `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='数据字典表';

-- 触发器：订单状态变更时记录日志
DELIMITER //
CREATE TRIGGER `order_status_change` AFTER UPDATE ON `order`
FOR EACH ROW
BEGIN
  IF OLD.status != NEW.status THEN
    INSERT INTO `order_status_log` (`order_id`, `old_status`, `new_status`, `remark`)
    VALUES (OLD.id, OLD.status, NEW.status, CONCAT('订单状态从', OLD.status, '变更为', NEW.status));
  END IF;
END //
DELIMITER ;

-- 触发器：订单支付后更新发团计划的已预订座位数
DELIMITER //
CREATE TRIGGER `update_booked_seats` AFTER UPDATE ON `order`
FOR EACH ROW
BEGIN
  IF OLD.status = 'pending' AND NEW.status = 'paid' THEN
    UPDATE `group_plan`
    SET `booked_seats` = `booked_seats` + NEW.adult_count + NEW.child_count
    WHERE `id` = NEW.group_plan_id;
  END IF;
END //
DELIMITER ;

-- 测试数据
-- 1. 角色数据
INSERT INTO `sys_role` (`name`, `code`, `description`) VALUES
('管理员', 'admin', '系统管理员，拥有所有权限'),
('计调', 'operator', '负责线路编排和资源调度'),
('销售', 'sales', '负责客户开发和订单处理'),
('财务', 'finance', '负责财务管理和报表'),
('导游', 'guide', '负责带团和客户服务');

-- 2. 权限数据
INSERT INTO `sys_permission` (`name`, `code`, `type`, `path`, `parent_id`, `order_num`) VALUES
('系统管理', 'sys:manage', 1, '/sys', NULL, 1),
('用户管理', 'sys:user:manage', 1, '/sys/user', 1, 1),
('用户列表', 'sys:user:list', 2, NULL, 2, 1),
('用户新增', 'sys:user:add', 2, NULL, 2, 2),
('用户编辑', 'sys:user:edit', 2, NULL, 2, 3),
('用户删除', 'sys:user:delete', 2, NULL, 2, 4),
('角色管理', 'sys:role:manage', 1, '/sys/role', 1, 2),
('角色列表', 'sys:role:list', 2, NULL, 7, 1),
('角色新增', 'sys:role:add', 2, NULL, 7, 2),
('角色编辑', 'sys:role:edit', 2, NULL, 7, 3),
('角色删除', 'sys:role:delete', 2, NULL, 7, 4),
('CRM管理', 'crm:manage', 1, '/crm', NULL, 2),
('客户管理', 'crm:customer:manage', 1, '/crm/customer', 12, 1),
('客户列表', 'crm:customer:list', 2, NULL, 13, 1),
('客户新增', 'crm:customer:add', 2, NULL, 13, 2),
('客户编辑', 'crm:customer:edit', 2, NULL, 13, 3),
('客户删除', 'crm:customer:delete', 2, NULL, 13, 4),
('客户跟进', 'crm:follow:manage', 1, '/crm/follow', 12, 2),
('跟进记录', 'crm:follow:list', 2, NULL, 18, 1),
('添加跟进', 'crm:follow:add', 2, NULL, 18, 2),
('景点管理', 'scenic:manage', 1, '/scenic', NULL, 3),
('景点列表', 'scenic:list', 2, NULL, 21, 1),
('景点新增', 'scenic:add', 2, NULL, 21, 2),
('景点编辑', 'scenic:edit', 2, NULL, 21, 3),
('景点删除', 'scenic:delete', 2, NULL, 21, 4),
('线路管理', 'route:manage', 1, '/route', NULL, 4),
('线路列表', 'route:list', 2, NULL, 25, 1),
('线路新增', 'route:add', 2, NULL, 25, 2),
('线路编辑', 'route:edit', 2, NULL, 25, 3),
('线路删除', 'route:delete', 2, NULL, 25, 4),
('调度管理', 'dispatch:manage', 1, '/dispatch', NULL, 5),
('发团计划', 'dispatch:group:list', 2, NULL, 29, 1),
('导游排班', 'dispatch:guide:list', 2, NULL, 29, 2),
('订单管理', 'order:manage', 1, '/order', NULL, 6),
('订单列表', 'order:list', 2, NULL, 32, 1),
('订单新增', 'order:add', 2, NULL, 32, 2),
('订单编辑', 'order:edit', 2, NULL, 32, 3),
('订单删除', 'order:delete', 2, NULL, 32, 4),
('财务管理', 'finance:manage', 1, '/finance', NULL, 7),
('财务记录', 'finance:record:list', 2, NULL, 36, 1),
('财务报表', 'finance:report:list', 2, NULL, 36, 2),
('数据大屏', 'dashboard:manage', 1, '/dashboard', NULL, 8),
('经营看板', 'dashboard:overview', 2, NULL, 39, 1),
('销售分析', 'dashboard:sales', 2, NULL, 39, 2),
('客户分析', 'dashboard:customer', 2, NULL, 39, 3);

-- 3. 角色权限关联
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`) VALUES
-- 管理员权限
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11),
(1, 12), (1, 13), (1, 14), (1, 15), (1, 16), (1, 17), (1, 18), (1, 19), (1, 20), (1, 21),
(1, 22), (1, 23), (1, 24), (1, 25), (1, 26), (1, 27), (1, 28), (1, 29), (1, 30), (1, 31),
(1, 32), (1, 33), (1, 34), (1, 35), (1, 36), (1, 37), (1, 38), (1, 39), (1, 40), (1, 41), (1, 42),
-- 计调权限
(2, 21), (2, 22), (2, 23), (2, 24), (2, 25), (2, 26), (2, 27), (2, 28), (2, 29), (2, 30), (2, 31),
-- 销售权限
(3, 12), (3, 13), (3, 14), (3, 15), (3, 16), (3, 17), (3, 18), (3, 19), (3, 20), (3, 32), (3, 33), (3, 34), (3, 35),
-- 财务权限
(4, 36), (4, 37), (4, 38),
-- 导游权限
(5, 32), (5, 40), (5, 41), (5, 42);

-- 4. 用户数据
INSERT INTO `sys_user` (`username`, `password`, `name`, `phone`, `email`, `department`, `status`) VALUES
('admin', '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7', '系统管理员', '13800138000', 'admin@example.com', '总经办', 1),
('operator', '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7', '计调员', '13800138001', 'operator@example.com', '计调部', 1),
('sales', '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7', '销售员', '13800138002', 'sales@example.com', '销售部', 1),
('finance', '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7', '财务员', '13800138003', 'finance@example.com', '财务部', 1),
('guide', '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7', '导游', '13800138004', 'guide@example.com', '导游部', 1);

-- 5. 用户角色关联
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- 6. 客户等级
INSERT INTO `customer_level` (`name`, `min_consumption`, `discount`, `description`) VALUES
('普通客户', 0, 1.0, '初始等级'),
('银卡客户', 5000, 0.95, '消费满5000元'),
('金卡客户', 10000, 0.9, '消费满10000元'),
('钻石客户', 20000, 0.85, '消费满20000元');

-- 7. 客户标签
INSERT INTO `customer_tag` (`name`, `description`) VALUES
('家庭游', '喜欢家庭出游'),
('亲子游', '带孩子出游'),
('蜜月游', '新婚夫妇'),
('老年游', '老年客户'),
('商务游', '商务出行'),
('背包客', '独自旅行'),
('摄影爱好者', '喜欢摄影'),
('美食爱好者', '注重美食体验');

-- 8. 客户数据
INSERT INTO `customer` (`name`, `gender`, `phone`, `email`, `id_card`, `address`, `level_id`, `source`, `total_consumption`, `order_count`) VALUES
('张三', 1, '13900139001', 'zhangsan@example.com', '110101199001011234', '北京市朝阳区', 2, '线下门店', 6500, 2),
('李四', 2, '13900139002', 'lisi@example.com', '110101199002022345', '上海市浦东新区', 1, '线上咨询', 2000, 1),
('王五', 1, '13900139003', 'wangwu@example.com', '110101199003033456', '广州市天河区', 3, '老客户介绍', 12000, 3),
('赵六', 2, '13900139004', 'zhaoliu@example.com', '110101199004044567', '深圳市南山区', 1, '社交媒体', 1500, 1),
('钱七', 1, '13900139005', 'qianqi@example.com', '110101199005055678', '杭州市西湖区', 4, '企业客户', 25000, 5),
('孙八', 2, '13900139006', 'sunba@example.com', '110101199006066789', '成都市锦江区', 2, '线下门店', 5500, 2),
('周九', 1, '13900139007', 'zhoujiu@example.com', '110101199007077890', '武汉市江汉区', 1, '线上咨询', 1800, 1),
('吴十', 2, '13900139008', 'wushi@example.com', '110101199008088901', '重庆市渝中区', 3, '老客户介绍', 11000, 3),
('郑十一', 1, '13900139009', 'zhengshiyi@example.com', '110101199009099012', '西安市碑林区', 1, '社交媒体', 1200, 1),
('王十二', 2, '13900139010', 'wangshier@example.com', '110101199010100123', '南京市玄武区', 2, '线下门店', 6000, 2),
('李十三', 1, '13900139011', 'lishisan@example.com', '110101199011111234', '天津市和平区', 3, '企业客户', 13000, 4),
('张十四', 2, '13900139012', 'zhangshisi@example.com', '110101199012122345', '苏州市姑苏区', 1, '线上咨询', 1600, 1),
('刘十五', 1, '13900139013', 'liushiwu@example.com', '110101199101013456', '长沙市岳麓区', 4, '老客户介绍', 22000, 5),
('陈十六', 2, '13900139014', 'chenshiliu@example.com', '110101199102024567', '青岛市市南区', 2, '社交媒体', 5800, 2),
('杨十七', 1, '13900139015', 'yangshiqi@example.com', '110101199103035678', '大连市中山区', 1, '线下门店', 1900, 1),
('黄十八', 2, '13900139016', 'huangshiba@example.com', '110101199104046789', '厦门市思明区', 3, '企业客户', 10500, 3),
('赵十九', 1, '13900139017', 'zhaoshijiu@example.com', '110101199105057890', '福州市鼓楼区', 1, '线上咨询', 1400, 1),
('孙二十', 2, '13900139018', 'sunershi@example.com', '110101199106068901', '宁波市鄞州区', 2, '老客户介绍', 5200, 2),
('周二十一', 1, '13900139019', 'zhouershiyi@example.com', '110101199107079012', '昆明市五华区', 3, '社交媒体', 9800, 3),
('吴二十二', 2, '13900139020', 'wuerershi@example.com', '110101199108080123', '贵阳市南明区', 1, '线下门店', 1700, 1);

-- 9. 客户标签关联
INSERT INTO `customer_tag_relation` (`customer_id`, `tag_id`) VALUES
(1, 1), (1, 3), (2, 2), (3, 4), (3, 5), (4, 6), (5, 5), (5, 8), (6, 1), (6, 2),
(7, 6), (8, 3), (8, 7), (9, 4), (10, 1), (10, 5), (11, 2), (11, 6), (12, 3), (13, 4),
(13, 8), (14, 1), (14, 7), (15, 2), (16, 5), (16, 6), (17, 3), (18, 1), (18, 4), (19, 2),
(19, 8), (20, 6), (20, 7);

-- 10. 客户跟进记录
INSERT INTO `customer_follow` (`customer_id`, `user_id`, `follow_time`, `content`, `next_follow_time`) VALUES
(1, 3, '2026-01-10 10:00:00', '电话沟通，了解客户出行需求', '2026-01-15 14:00:00'),
(2, 3, '2026-01-11 14:30:00', '线上咨询回复，推荐适合的线路', '2026-01-18 10:00:00'),
(3, 3, '2026-01-12 09:00:00', '老客户回访，了解上次旅行体验', '2026-02-12 09:00:00'),
(4, 3, '2026-01-13 15:00:00', '社交媒体互动，发送促销信息', '2026-01-20 15:00:00'),
(5, 3, '2026-01-14 11:00:00', '企业客户拜访，洽谈合作事宜', '2026-01-21 11:00:00'),
(6, 3, '2026-01-15 10:30:00', '线下门店接待，介绍新线路', '2026-01-22 10:30:00'),
(7, 3, '2026-01-16 14:00:00', '线上咨询回复，解答疑问', '2026-01-23 14:00:00'),
(8, 3, '2026-01-17 09:30:00', '老客户回访，推荐优惠活动', '2026-02-17 09:30:00'),
(9, 3, '2026-01-18 15:30:00', '社交媒体互动，分享旅行攻略', '2026-01-25 15:30:00'),
(10, 3, '2026-01-19 10:00:00', '线下门店接待，处理预订事宜', '2026-01-26 10:00:00');

-- 11. 供应商数据
INSERT INTO `supplier` (`name`, `contact_person`, `contact_phone`, `address`, `description`) VALUES
('山水旅行社', '张经理', '13800138100', '北京市朝阳区建国路', '主要提供国内旅游线路服务'),
('环球旅游', '李经理', '13800138101', '上海市浦东新区陆家嘴', '提供国际旅游和高端定制服务'),
('快乐假期', '王经理', '13800138102', '广州市天河区天河路', '专注于主题游和亲子游'),
('逍遥游', '赵经理', '13800138103', '深圳市南山区科技园', '提供自由行和半自助游服务'),
('省心旅游', '钱经理', '13800138104', '杭州市西湖区湖滨路', '主要提供省内短线游');

-- 12. 景点分类
INSERT INTO `scenic_category` (`name`, `description`) VALUES
('自然风光', '自然景观如山水、森林、湖泊等'),
('历史文化', '历史古迹、文化遗产等'),
('主题乐园', '游乐园、水上乐园等'),
('城市观光', '城市地标、商业区等'),
('休闲度假', '温泉、度假村等');

-- 13. 景点数据
INSERT INTO `scenic_spot` (`name`, `address`, `ticket_price`, `opening_hours`, `description`, `cover_image`, `rating`, `visit_count`, `category_id`, `supplier_id`) VALUES
('故宫博物院', '北京市东城区景山前街4号', 60, '8:30-17:00', '中国明清两代的皇家宫殿，世界文化遗产', 'https://example.com/gugong.jpg', 4.8, 1000000, 2, 1),
('长城', '北京市怀柔区', 40, '8:00-17:30', '中国古代伟大的防御工程，世界文化遗产', 'https://example.com/changcheng.jpg', 4.9, 800000, 2, 1),
('西湖', '浙江省杭州市西湖区', 0, '全天开放', '中国著名的风景名胜区，世界文化遗产', 'https://example.com/xihu.jpg', 4.7, 900000, 1, 5),
('黄山', '安徽省黄山市黄山区', 230, '全天开放', '以奇松、怪石、云海、温泉、冬雪五绝著称', 'https://example.com/huangshan.jpg', 4.9, 500000, 1, 5),
('张家界国家森林公园', '湖南省张家界市武陵源区', 248, '7:30-17:30', '以张家界地貌闻名，世界自然遗产', 'https://example.com/zhangjiajie.jpg', 4.8, 600000, 1, 3),
('九寨沟', '四川省阿坝藏族羌族自治州九寨沟县', 190, '8:00-17:00', '以翠海、叠瀑、彩林、雪峰、藏情、蓝冰六绝著称', 'https://example.com/jiuzhaigou.jpg', 4.9, 400000, 1, 4),
('三亚亚龙湾', '海南省三亚市亚龙湾国家旅游度假区', 0, '全天开放', '被誉为天下第一湾，以阳光、海水、沙滩著称', 'https://example.com/yalongwan.jpg', 4.6, 700000, 5, 3),
('迪士尼乐园', '上海市浦东新区川沙新镇', 399, '9:00-21:00', '世界知名的主题乐园', 'https://example.com/disney.jpg', 4.7, 800000, 3, 2),
('颐和园', '北京市海淀区新建宫门路19号', 30, '6:30-18:00', '中国古典园林，世界文化遗产', 'https://example.com/yiheyuan.jpg', 4.6, 600000, 2, 1),
('鼓浪屿', '福建省厦门市思明区', 80, '全天开放', '海上花园，世界文化遗产', 'https://example.com/gulangyu.jpg', 4.5, 500000, 4, 3),
('乐山大佛', '四川省乐山市市中区凌云路2435号', 80, '7:30-18:00', '世界最大的石刻佛像，世界文化与自然双重遗产', 'https://example.com/leshandafo.jpg', 4.7, 300000, 2, 4),
('秦始皇兵马俑', '陕西省西安市临潼区秦始皇陵以东1.5公里处', 120, '8:30-17:30', '世界第八大奇迹，世界文化遗产', 'https://example.com/bingmayong.jpg', 4.8, 700000, 2, 4),
('西双版纳热带植物园', '云南省西双版纳傣族自治州勐腊县', 80, '8:00-18:00', '中国最大的热带植物园', 'https://example.com/xishuangbanna.jpg', 4.6, 200000, 1, 4),
('乌镇', '浙江省嘉兴市桐乡市乌镇镇', 120, '8:00-17:30', '中国江南水乡古镇，世界文化遗产', 'https://example.com/wuzhen.jpg', 4.5, 400000, 2, 5),
('黄山温泉', '安徽省黄山市黄山区汤口镇', 238, '9:00-23:00', '黄山四大奇观之一', 'https://example.com/huangshanwenquan.jpg', 4.4, 150000, 5, 5),
('长隆欢乐世界', '广东省广州市番禺区迎宾路', 250, '9:30-18:00', '大型主题乐园', 'https://example.com/changlong.jpg', 4.6, 600000, 3, 3),
('鸟巢', '北京市朝阳区国家体育场南路1号', 50, '9:00-19:00', '2008年北京奥运会主体育场', 'https://example.com/niaochao.jpg', 4.3, 500000, 4, 1),
('上海外滩', '上海市黄浦区中山东一路', 0, '全天开放', '上海标志性景观', 'https://example.com/waitan.jpg', 4.5, 1000000, 4, 2),
('杭州宋城', '浙江省杭州市西湖区之江路148号', 310, '9:00-21:00', '大型宋文化主题公园', 'https://example.com/songcheng.jpg', 4.4, 300000, 3, 5),
('桂林山水', '广西壮族自治区桂林市', 0, '全天开放', '以山青、水秀、洞奇、石美著称', 'https://example.com/guilin.jpg', 4.8, 800000, 1, 3);

-- 14. 景点评价
INSERT INTO `scenic_comment` (`scenic_id`, `customer_id`, `rating`, `content`) VALUES
(1, 1, 5, '非常震撼，感受到了中国古代文化的博大精深'),
(1, 2, 4, '人很多，建议早上去'),
(2, 3, 5, '不到长城非好汉，确实很壮观'),
(2, 4, 4, '爬上去有点累，但是值得'),
(3, 5, 5, '西湖美景名不虚传，下次还会再来'),
(3, 6, 4, '环境优美，适合休闲散步'),
(4, 7, 5, '黄山云海太漂亮了，宛如仙境'),
(4, 8, 5, '黄山的日出非常壮观'),
(5, 9, 4, '张家界的山很奇特，值得一游'),
(5, 10, 5, '玻璃桥很刺激，景色绝美');

-- 15. 导游数据
INSERT INTO `guide` (`name`, `phone`, `guide_card`, `level`, `experience`, `status`) VALUES
('导游小王', '13800138201', 'D12345678', '高级导游', 5, 1),
('导游小李', '13800138202', 'D12345679', '中级导游', 3, 1),
('导游小张', '13800138203', 'D12345680', '初级导游', 1, 1),
('导游小刘', '13800138204', 'D12345681', '高级导游', 8, 1),
('导游小陈', '13800138205', 'D12345682', '中级导游', 4, 1);

-- 16. 车辆数据
INSERT INTO `vehicle` (`plate_number`, `model`, `seat_count`, `status`, `supplier_id`) VALUES
('京A12345', '宇通大巴', 50, 1, 1),
('沪B67890', '金龙大巴', 45, 1, 2),
('粤C13579', '中通大巴', 40, 1, 3),
('京A24680', '宇通大巴', 50, 1, 1),
('沪B98765', '金龙大巴', 45, 1, 2);

-- 17. 酒店数据
INSERT INTO `hotel` (`name`, `address`, `star_level`, `contact_phone`, `supplier_id`) VALUES
('北京王府井希尔顿酒店', '北京市东城区王府井东街8号', 5, '010-58128888', 1),
('上海外滩华尔道夫酒店', '上海市黄浦区中山东一路2号', 5, '021-63229988', 2),
('广州四季酒店', '广州市天河区珠江西路5号', 5, '020-88833388', 3),
('深圳福田香格里拉大酒店', '深圳市福田区益田路4088号', 5, '0755-88284088', 4),
('杭州西子湖四季酒店', '杭州市西湖区龙井路5号', 5, '0571-88298888', 5);

-- 18. 旅游线路数据
INSERT INTO `travel_route` (`name`, `description`, `days`, `type`, `departure_city`, `cost_price`, `sale_price`, `status`, `cover_image`) VALUES
('北京经典5日游', '游览故宫、长城、颐和园等北京著名景点', 5, '多日游', '北京', 1500, 2200, 1, 'https://example.com/beijing.jpg'),
('上海迪士尼3日游', '畅游上海迪士尼乐园，体验童话世界', 3, '主题游', '上海', 1200, 1800, 1, 'https://example.com/shanghai.jpg'),
('杭州西湖2日游', '漫步西湖，感受江南水乡韵味', 2, '多日游', '杭州', 800, 1200, 1, 'https://example.com/hangzhou.jpg'),
('黄山4日游', '登黄山，看云海日出', 4, '多日游', '合肥', 1800, 2600, 1, 'https://example.com/huangshan_route.jpg'),
('张家界3日游', '探索张家界神奇地貌', 3, '主题游', '长沙', 1500, 2200, 1, 'https://example.com/zhangjiajie_route.jpg'),
('三亚5日游', '享受阳光沙滩，体验海岛风情', 5, '休闲度假', '海口', 2000, 2800, 1, 'https://example.com/sanya.jpg'),
('九寨沟4日游', '欣赏九寨沟绝美风光', 4, '自然景观', '成都', 1600, 2400, 1, 'https://example.com/jiuzhaigou_route.jpg'),
('西安3日游', '感受古都文化，参观兵马俑', 3, '历史文化', '西安', 1000, 1600, 1, 'https://example.com/xian.jpg'),
('厦门2日游', '游览鼓浪屿，体验闽南风情', 2, '休闲度假', '厦门', 700, 1100, 1, 'https://example.com/xiamen.jpg'),
('桂林3日游', '欣赏桂林山水甲天下的美景', 3, '自然景观', '桂林', 900, 1500, 1, 'https://example.com/guilin_route.jpg');

-- 19. 线路行程数据
INSERT INTO `route_itinerary` (`route_id`, `day`, `title`, `description`, `scenic_ids`, `hotel_id`, `transportation`) VALUES
(1, 1, '故宫博物院', '游览故宫博物院，感受皇家文化', '1', 1, '旅游大巴'),
(1, 2, '长城', '登长城，体验不到长城非好汉', '2', 1, '旅游大巴'),
(1, 3, '颐和园', '游览颐和园，感受皇家园林魅力', '9', 1, '旅游大巴'),
(1, 4, '鸟巢', '参观鸟巢，感受奥运精神', '17', 1, '旅游大巴'),
(1, 5, '自由活动', '自由购物，结束行程', NULL, 1, '旅游大巴'),
(2, 1, '迪士尼乐园', '全天畅游迪士尼乐园', '8', 2, '旅游大巴'),
(2, 2, '迪士尼乐园', '继续游览迪士尼乐园', '8', 2, '旅游大巴'),
(2, 3, '上海外滩', '游览上海外滩，欣赏黄浦江美景', '18', 2, '旅游大巴'),
(3, 1, '西湖', '游览西湖主要景点', '3', 5, '旅游大巴'),
(3, 2, '杭州宋城', '游览杭州宋城，观看宋城千古情', '19', 5, '旅游大巴');

-- 20. 发团计划数据
INSERT INTO `group_plan` (`route_id`, `group_code`, `start_date`, `end_date`, `total_seats`, `booked_seats`, `guide_id`, `vehicle_id`, `status`) VALUES
(1, 'BJ20260401', '2026-04-01', '2026-04-05', 40, 25, 1, 1, 'pending'),
(1, 'BJ20260415', '2026-04-15', '2026-04-19', 40, 15, 2, 4, 'pending'),
(2, 'SH20260402', '2026-04-02', '2026-04-04', 30, 20, 3, 2, 'pending'),
(3, 'HZ20260403', '2026-04-03', '2026-04-04', 35, 10, 4, 3, 'pending'),
(4, 'HS20260405', '2026-04-05', '2026-04-08', 25, 8, 5, 1, 'pending');

-- 21. 订单数据
INSERT INTO `order` (`order_no`, `customer_id`, `group_plan_id`, `adult_count`, `child_count`, `total_amount`, `actual_amount`, `status`, `payment_time`, `remark`) VALUES
('ORD2026040001', 1, 1, 2, 1, 6600, 6270, 'paid', '2026-03-10 10:00:00', '银卡客户享受95折优惠'),
('ORD2026040002', 2, 1, 1, 0, 2200, 2200, 'pending', NULL, NULL),
('ORD2026040003', 3, 2, 2, 0, 4400, 3960, 'confirmed', '2026-03-11 14:00:00', '金卡客户享受9折优惠'),
('ORD2026040004', 4, 3, 1, 1, 3600, 3600, 'paid', '2026-03-12 09:00:00', NULL),
('ORD2026040005', 5, 4, 3, 0, 3600, 3060, 'completed', '2026-03-13 15:00:00', '钻石客户享受85折优惠'),
('ORD2026040006', 6, 5, 2, 0, 5200, 4940, 'paid', '2026-03-14 10:30:00', '银卡客户享受95折优惠'),
('ORD2026040007', 7, 1, 1, 0, 2200, 2200, 'pending', NULL, NULL),
('ORD2026040008', 8, 2, 2, 1, 6600, 5940, 'confirmed', '2026-03-15 14:30:00', '金卡客户享受9折优惠'),
('ORD2026040009', 9, 3, 1, 0, 1800, 1800, 'paid', '2026-03-16 09:30:00', NULL),
('ORD2026040010', 10, 4, 2, 0, 2400, 2280, 'paid', '2026-03-17 15:30:00', '银卡客户享受95折优惠');

-- 22. 订单明细数据
INSERT INTO `order_item` (`order_id`, `name`, `id_card`, `type`, `price`) VALUES
(1, '张三', '110101199001011234', 'adult', 2200),
(1, '张三妻子', '110101199002022345', 'adult', 2200),
(1, '张三孩子', '110101201501011234', 'child', 2200),
(2, '李四', '110101199002022345', 'adult', 2200),
(3, '王五', '110101199003033456', 'adult', 2200),
(3, '王五妻子', '110101199004044567', 'adult', 2200),
(4, '赵六', '110101199004044567', 'adult', 1800),
(4, '赵六孩子', '110101201601011234', 'child', 1800),
(5, '钱七', '110101199005055678', 'adult', 1200),
(5, '钱七妻子', '110101199006066789', 'adult', 1200),
(5, '钱七朋友', '110101199007077890', 'adult', 1200),
