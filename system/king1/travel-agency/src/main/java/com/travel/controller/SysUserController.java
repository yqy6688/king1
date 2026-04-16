package com.travel.controller;

import com.travel.entity.SysUser;
import com.travel.mapper.SysUserMapper;
import com.travel.utils.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/sys/user")
public class SysUserController {

    @Autowired
    private SysUserMapper sysUserMapper;

    // 获取所有用户列表 (对应前端 loadUsers)
    @GetMapping("/list")
    public Result<List<SysUser>> list() {
        List<SysUser> users = sysUserMapper.selectList(null);
        // 清除密码字段防止泄露
        users.forEach(u -> u.setPassword(null));
        return Result.success(users);
    }

    // 删除用户 (对应前端 deleteUser)
    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        sysUserMapper.deleteById(id);
        return Result.success("删除成功");
    }
    
    // 保存或更新用户 (留给你自己完善 POST 接口)
}