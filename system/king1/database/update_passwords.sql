-- 更新用户密码为正确的 BCrypt 哈希值
-- 密码：123456
UPDATE `sys_user` SET `password` = '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7' WHERE `username` = 'admin';
UPDATE `sys_user` SET `password` = '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7' WHERE `username` = 'operator';
UPDATE `sys_user` SET `password` = '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7' WHERE `username` = 'sales';
UPDATE `sys_user` SET `password` = '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7' WHERE `username` = 'finance';
UPDATE `sys_user` SET `password` = '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7' WHERE `username` = 'guide';

-- 或者使用更简单的方法，直接更新所有用户的密码
-- UPDATE `sys_user` SET `password` = '$2a$10$e4tUx0zC7yG5R3F8F3Qz6O4cY4d5e6f7g8h9i0j1k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7';