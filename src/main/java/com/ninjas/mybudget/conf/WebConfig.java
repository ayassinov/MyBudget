package com.ninjas.mybudget.conf;

import com.codahale.metrics.MetricRegistry;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.guava.GuavaModule;
import com.fasterxml.jackson.datatype.joda.JodaModule;
import com.ninjas.mybudget.MyBudgetConfig;
import com.ninjas.mybudget.conf.vendor.FuzzyEnumModule;
import com.ninjas.mybudget.conf.vendor.GuavaExtrasModule;
import com.ninjas.mybudget.conf.vendor.MovieTimeJsonMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.embedded.EmbeddedServletContainerFactory;
import org.springframework.boot.context.embedded.jetty.JettyEmbeddedServletContainerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;

import javax.annotation.PostConstruct;

/**
 * @author ayassinov on 15/08/14.
 */
@Configuration
public class WebConfig {

    @Autowired
    private MyBudgetConfig config;

    @Autowired
    private MetricRegistry metricRegistry;

    private ObjectMapper objectMapper;

    @Bean
    public EmbeddedServletContainerFactory servletContainer() {
        return new JettyEmbeddedServletContainerFactory();
    }

    /**
     * Configure Jackson mapper with our preferences
     *
     * @return Jackson converter
     */
    @Bean
    public MappingJackson2HttpMessageConverter configureMapper() {
        final MovieTimeJsonMapper jsonMapper = new MovieTimeJsonMapper();
        jsonMapper.setObjectMapper(objectMapper());
        return jsonMapper;
    }

    /**
     * Return an Jackson Object Mapper to convert from/to Java Object to JsonNode types.
     *
     * @return Object mapper
     */
    @Bean
    public ObjectMapper objectMapper() {
        if (objectMapper != null)
            return objectMapper;

        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JodaModule());
        objectMapper.registerModule(new FuzzyEnumModule());
        objectMapper.registerModule(new GuavaExtrasModule());
        objectMapper.registerModule(new GuavaModule());

        objectMapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);

        objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.CAMEL_CASE_TO_LOWER_CASE_WITH_UNDERSCORES);
        return objectMapper;
    }


    @PostConstruct
    public void postConstruct() {
        if (config == null)
            throw new NullPointerException("MovieTimeConfig is mandatory. Check Spring autowiring");
    }
}
