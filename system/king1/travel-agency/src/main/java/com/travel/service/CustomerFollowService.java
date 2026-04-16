package com.travel.service;

import com.travel.entity.CustomerFollow;
import com.baomidou.mybatisplus.extension.service.IService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import java.util.List;

public interface CustomerFollowService extends IService<CustomerFollow> {
    List<CustomerFollow> getFollowsByCustomerId(Long customerId);
    List<CustomerFollow> getPendingFollows();
}

