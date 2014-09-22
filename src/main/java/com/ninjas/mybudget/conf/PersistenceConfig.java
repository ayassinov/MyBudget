package com.ninjas.mybudget.conf;

import org.postgresql.ds.PGPoolingDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.hibernate4.HibernateExceptionTranslator;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.Database;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;
import java.sql.SQLException;

/**
 * @author ayassinov on 22/09/14.
 */
@Configuration
@EnableJpaRepositories(basePackages = "com.ninjas.mybudget.repository")
@EnableTransactionManagement
public class PersistenceConfig {

    // @Autowired
    // private MyBudgetConfig configuration;

    @Bean
    public DataSource dataSource() throws SQLException {
        // final MyBudgetConfig.DataBase dataBase = configuration.getApp().getDataBase();


        PGPoolingDataSource source = new PGPoolingDataSource();

        source.setDataSourceName("MyBudget DataSource");
        source.setServerName("localhost");
        source.setDatabaseName("mybudget");
        source.setUser("postgres");
        source.setPassword("root");
        source.setMaxConnections(10);
        return source;
    }

    //@Bean
    public EntityManagerFactory entityManagerFactory() throws SQLException {
        final HibernateJpaVendorAdapter hibernateJpaVendorAdapter = new HibernateJpaVendorAdapter();
        hibernateJpaVendorAdapter.setDatabase(Database.POSTGRESQL);
        hibernateJpaVendorAdapter.setGenerateDdl(true);
        hibernateJpaVendorAdapter.setShowSql(true);

        LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();

        factory.setJpaVendorAdapter(hibernateJpaVendorAdapter);
        factory.setPackagesToScan("com.ninjas.mybudget.core.domain.*");
        factory.setDataSource(dataSource());
        factory.afterPropertiesSet();

        return factory.getObject();
    }

    @Bean
    public EntityManager entityManager() throws SQLException {
        return entityManagerFactory().createEntityManager();
    }

    @Bean
    public PlatformTransactionManager transactionManager() throws SQLException {

        JpaTransactionManager txManager = new JpaTransactionManager();
        txManager.setEntityManagerFactory(entityManagerFactory());
        return txManager;
    }

    @Bean
    public HibernateExceptionTranslator hibernateExceptionTranslator() {
        return new HibernateExceptionTranslator();
    }
}
