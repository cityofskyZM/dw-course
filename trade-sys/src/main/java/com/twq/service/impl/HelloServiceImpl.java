package com.twq.service.impl;

import com.twq.dao.HelloDao;
import com.twq.service.HelloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class HelloServiceImpl implements HelloService {

    @Autowired
    private HelloDao helloDao;

    @Override
    public String getHello() {
        return helloDao.findHello();
    }
}
