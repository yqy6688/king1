package com.travel.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.travel.entity.CustomerFollow;
import com.travel.mapper.CustomerFollowMapper;
import com.travel.service.CustomerFollowService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerFollowServiceImpl extends ServiceImpl<CustomerFollowMapper, CustomerFollow> implements CustomerFollowService {

    @Override
    public List<CustomerFollow> getFollowsByCustomerId(Long customerId) {
        return baseMapper.selectList(null);
    }

    @Override
    public List<CustomerFollow> getPendingFollows() {
        return baseMapper.selectList(null);
    }
}
