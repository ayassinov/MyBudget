/*
 * Copyright 2014 Parisian Ninjas
 *
 * Licensed under the MIT License;
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://opensource.org/licenses/MIT
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.ninjas.mybudget;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.validator.constraints.NotEmpty;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.validation.constraints.NotNull;

/**
 * @author ayassinov on 18/07/14
 */
@Getter
@Setter
@Component
@ToString
@Order(value = Ordered.HIGHEST_PRECEDENCE)
@ConfigurationProperties(prefix = "mybudget")
public class MyBudgetConfig {

    private static final Logger LOG = LoggerFactory.getLogger(MyBudgetConfig.class);

    @NotNull
    private AppConfig app;

    private GraphiteConfig graphite;

    @PostConstruct
    public void postConstruct() {
        LOG.info("MyBudget Configuration loaded successfully with this parameters: [{}]", toString());
    }

    public static enum RunModeEnum {

        DEV, PROD, TEST;

        public String toString() {

            switch (this) {
                case DEV:
                    return "development";
                case PROD:
                    return "production";
                case TEST:
                    return "test";
                default:
                    throw new EnumConstantNotPresentException(RunModeEnum.class, this.name());
            }
        }
    }

    @Getter
    @Setter
    @ToString
    public static class GraphiteConfig {

        @NotEmpty(message = "ApiKey is mandatory")
        private String apiKey;

        @NotEmpty(message = "Host is mandatory")
        private String host;

        @NotEmpty(message = "Port is mandatory")
        private int port;

        @NotNull(message = "Activate should have a value of true or false")
        private boolean activate;
    }


    /**
     * @author ayassinov on 15/08/14.
     */
    @Getter
    @Setter
    @ToString
    public static class AppConfig {
        @NotNull(message = "Running Mode is one of (DEV,PROD,TEST)")
        private RunModeEnum mode;

        @NotNull(message = "Version cannot be null or empty")
        private String version;

        @NotNull(message = "Name cannot be null or empty")
        private String name;

        @NotNull(message = "API Version cannot be null or empty")
        private String apiVersion;

        @NotNull(message = "ResponseFormat cannot be null or empty")
        private String responseFormat;

        private String bugSnag = null;

        private DataBase dataBase;

        public AppConfig() {

        }
    }

    @Getter
    @Setter
    @ToString
    public static class DataBase {

        @NotNull(message = "Host cannot be null or empty")
        private String host;

        @NotNull(message = "Data base name cannot be null or empty")
        private String dataBaseName;

        @NotNull(message = "User name cannot be null or empty")
        private String userName;

        @NotNull(message = "Password cannot be null or empty")
        private String password;

        @NotNull(message = "Max connection cannot be null or empty")
        private int maxConnection;
    }
}
