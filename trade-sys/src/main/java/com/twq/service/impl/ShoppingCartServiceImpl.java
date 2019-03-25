package com.twq.service.impl;

import com.twq.dao.ShoppingCartDao;
import com.twq.service.ShoppingCartService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ShoppingCartServiceImpl implements ShoppingCartService {

    private Logger logger = LoggerFactory.getLogger(ShoppingCartServiceImpl.class);

    @Autowired
    private ShoppingCartDao shoppingCartDao;

    @Override
    public void addProduct2Cart() {
        logger.info("starting addProduct2Cart in service");
        shoppingCartDao.addProduct2Cart();
        logger.info("end addProduct2Cart in service");
    }
}
