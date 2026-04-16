package com.travel.controller;

import com.travel.entity.SysUser;
import com.travel.mapper.SysUserMapper;
import com.travel.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import java.util.List;

@RestController
@RequestMapping("/sys/user")
public class SysUserController {

    @Autowired
    private SysUserMapper sysUserMapper;

    @GetMapping("/list")
    public Result<List<SysUser>> list() {
        List<SysUser> users = sysUserMapper.selectList(null);
        // 密码脱敏
        users.forEach(u -> u.setPassword(null));
        return Result.success(users);
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        sysUserMapper.deleteById(id);
        return Result.success("删除成功");
    }

    // --- 下面是新加的保存/新增用户接口 ---
    @PostMapping
    public Result<String> add(@RequestBody SysUser user) {
        // 1. 检查用户名是否已存在，防止重复添加
        QueryWrapper<SysUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", user.getUsername());
        if (sysUserMapper.selectCount(queryWrapper) > 0) {
            return Result.error(400, "用户名已存在，请更换一个");
        }

        // 2. 密码加密处理
        // 如果前端在新增时没有传密码，我们默认给一个初始密码 "123456"
        String rawPassword = (user.getPassword() != null && !user.getPassword().isEmpty()) 
                             ? user.getPassword() : "123456";
                             
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        user.setPassword(encoder.encode(rawPassword)); 

        // 3. 设置默认状态
        if (user.getStatus() == null) {
            user.setStatus(1); // 默认状态为 1（启用）
        }

        // 4. 执行数据库插入操作
        sysUserMapper.insert(user);
        
        return Result.success("新增用户成功");
    }
}