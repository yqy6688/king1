package com.travel.entity;

import lombok.Data;

import java.util.Date;

@Data
public class CustomerFollow {
    private Long id;
    private Long customerId;
    private Long userId;
    private Date followTime;
    private String content;
    private Date nextFollowTime;
    private Date createTime;
}
