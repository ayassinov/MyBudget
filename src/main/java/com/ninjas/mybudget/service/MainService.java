package com.ninjas.mybudget.service;

import com.codahale.metrics.Timer;
import com.google.common.base.Optional;
import com.google.common.base.Preconditions;
import com.ninjas.mybudget.MyBudgetConfig;
import com.ninjas.mybudget.core.domain.Information;
import com.ninjas.mybudget.core.util.MetricManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.endpoint.mvc.EndpointHandlerMapping;
import org.springframework.boot.actuate.endpoint.mvc.MvcEndpoint;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author ayassinov on 08/09/14.
 */
@Service
public class MainService {

    private final String className = this.getClass().getCanonicalName();

    private final MyBudgetConfig config;
    private final EndpointHandlerMapping endpointHandlerMapping;

    @Autowired
    public MainService(MyBudgetConfig config,
                       @SuppressWarnings("SpringJavaAutowiringInspection") EndpointHandlerMapping endpointHandlerMapping) {
        this.config = config;
        this.endpointHandlerMapping = endpointHandlerMapping;
    }

    public Information getAppInformation() {
        final Optional<Timer.Context> timer = MetricManager.startTimer(className, "getAppInformation");
        try {
            final MyBudgetConfig.AppConfig configApp = config.getApp();
            Preconditions.checkNotNull(configApp, "Application configuration cannot be null");
            return new Information(configApp.getName(), configApp.getVersion(), configApp.getApiVersion());
        } finally {
            MetricManager.stopTimer(timer);
        }
    }

    public List<String> listManageEndPoints() {
        final Optional<Timer.Context> timer = MetricManager.startTimer(className, "listManageEndPoints");
        try {
            final List<String> endpoints = new ArrayList<>();
            for (MvcEndpoint endpoint : endpointHandlerMapping.getEndpoints())
                endpoints.add(endpoint.getPath());
            endpoints.add("/task");
            endpoints.add("/status");
            return endpoints;
        } finally {
            MetricManager.stopTimer(timer);
        }
    }
}
