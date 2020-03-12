package org.n52.emodnet.eurofleets.feeder;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@EnableConfigurationProperties
@SpringBootApplication
public class EurofleetsFeederApplication {

    public static void main(String[] args) {
        SpringApplication.run(EurofleetsFeederApplication.class, args);
    }
}
