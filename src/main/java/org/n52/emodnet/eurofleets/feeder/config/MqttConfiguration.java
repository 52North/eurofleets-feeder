package org.n52.emodnet.eurofleets.feeder.config;

import org.eclipse.paho.client.mqttv3.IMqttClient;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.UUID;

@Configuration
public class MqttConfiguration {

    @Value("${feeder.sta.mqtt.url}")
    private String endpoint;
    @Value("${feeder.sta.mqtt.username}")
    private String username;
    @Value("${feeder.sta.mqtt.password}")
    private String password;

    @Bean
    public MqttConnectOptions mqttConnectOptions() {
        MqttConnectOptions options = new MqttConnectOptions();
        if (username != null && password != null && !username.isEmpty() && !password.isEmpty()) {
            options.setUserName(username);
            options.setPassword(password.toCharArray());
        }
        options.setCleanSession(true);
        options.setAutomaticReconnect(true);
        return options;
    }

    @Bean
    public IMqttClient mqttClient() throws MqttException {
        String clientId = "eurofleets-feeder-" + UUID.randomUUID();
        MqttClient mqttClient = new MqttClient(endpoint, clientId, mqttClientPersistence());
        mqttClient.connect(mqttConnectOptions());
        return mqttClient;
    }

    @Bean
    public MemoryPersistence mqttClientPersistence() {
        return new MemoryPersistence();
    }

}
