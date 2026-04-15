package com.travel.entity;

import lombok.Data;

import java.util.Date;

@Data
public class SysUser {
    private Long id;
    private String username;
    private String password;
    private String name;
    private String phone;
    private String email;
    private String department;
    private Integer status;
    private Date createTime;
    private Date updateTime;
}
