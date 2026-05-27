package com.saude.listener;

import com.saude.dao.ConexaoDB;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ConexaoDB.inicializar();
    }
}
