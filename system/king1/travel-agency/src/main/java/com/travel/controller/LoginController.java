package com.travel.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.travel.entity.SysUser;
import com.travel.mapper.SysUserMapper;
import com.travel.utils.Result;
import com.travel.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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

        QueryWrapper<SysUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", username);
        SysUser user = sysUserMapper.selectOne(queryWrapper);

        if (user == null) {
            return Result.error(401, "用户名不存在");
        }
        
        // --- 核心调试区域 ---
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("========== 登录请求调试信息 ==========");
        System.out.println("1. 前端传来的用户名: " + username);
        System.out.println("2. 前端传来的明文密码: " + password);
        System.out.println("3. 数据库查出的加密密文: " + user.getPassword());
        
        boolean isMatch = encoder.matches(password, user.getPassword());
        System.out.println("4. BCrypt 校验结果 (true为成功, false为失败): " + isMatch);
        System.out.println("======================================");
        // -------------------

        if (!isMatch) {
            return Result.error(401, "密码错误");
        }

        if (user.getStatus() == 0) {
            return Result.error(401, "账号已被禁用");
        }
        
        Map<String, Object> claims = new HashMap<>();
        claims.put("username", user.getUsername());
        claims.put("userId", user.getId());
        String token = jwtUtils.generateToken(claims);

        user.setPassword(null);
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("user", user);

        return Result.success(data);
    }
    
    // 临时端点：生成密码哈希
    @GetMapping("/generate-password")
    public Result<String> generatePassword(@RequestParam String password) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String encodedPassword = encoder.encode(password);
        System.out.println("密码: " + password);
        System.out.println("BCrypt 哈希: " + encodedPassword);
        return Result.success(encodedPassword);
    }
}