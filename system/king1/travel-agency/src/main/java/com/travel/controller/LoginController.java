package com.travel.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.travel.entity.SysUser;
import com.travel.mapper.SysUserMapper;
import com.travel.utils.Result;
import com.travel.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private SysUserMapper sysUserMapper;
    
    @Autowired
    private JwtUtils jwtUtils;

    @PostMapping
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> loginForm) {
        String username = loginForm.get("username");
        String password = loginForm.get("password");

        // 1. 查数据库验证用户
        QueryWrapper<SysUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        SysUser user = sysUserMapper.selectOne(queryWrapper);

        if (user == null) {
            return Result.error(401, "用户名不存在");
        }
        if (user.getStatus() == 0) {
            return Result.error(401, "账号已被禁用");
        }
        
        // 2. 生成真实 Token
        Map<String, Object> claims = new HashMap<>();
        claims.put("username", user.getUsername());
        claims.put("userId", user.getId());
        String token = jwtUtils.generateToken(claims);

        // 3. 密码脱敏（防止泄漏给前端）
        user.setPassword(null);

        // 4. 返回数据
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("user", user);

        return Result.success(data);
    }
}