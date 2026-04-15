package com.travel.controller;

import com.travel.utils.Result;
import com.travel.utils.JwtUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/login")
public class LoginController {

    @PostMapping
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> loginForm) {
        String username = loginForm.get("username");
        String password = loginForm.get("password");

        // 模拟登录验证
        if ("admin".equals(username) && "123456".equals(password)) {
            // 生成token
            Map<String, Object> claims = new HashMap<>();
            claims.put("username", username);
            claims.put("role", "admin");
            String token = new JwtUtils().generateToken(claims);

            // 构建返回数据
            Map<String, Object> data = new HashMap<>();
            data.put("token", token);
            data.put("user", Map.of(
                    "id", 1,
                    "username", username,
                    "name", "系统管理员",
                    "role", "admin"
            ));

            return Result.success(data);
        } else {
            return Result.error(401, "用户名或密码错误");
        }
    }
}
