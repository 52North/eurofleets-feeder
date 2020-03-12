package org.n52.emodnet.eurofleets.feeder.config;

import com.google.common.base.Throwables;
import org.eclipse.paho.client.mqttv3.IMqttAsyncClient;
import org.eclipse.paho.client.mqttv3.MqttAsyncClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.n52.emodnet.eurofleets.feeder.sta.Retrier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.ConnectException;
import java.util.UUID;
import java.util.function.IntToLongFunction;

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
    public IMqttAsyncClient mqttAsyncClient() throws MqttException {
        MqttAsyncClient mqttClient = new MqttAsyncClient(endpoint, mqttClientId(), mqttClientPersistence());
        try {
            createRetrier().execute(() -> {
                mqttClient.connect(mqttConnectOptions()).waitForCompletion();
            });
        } catch (Exception e) {
            Throwables.propagateIfPossible(e, MqttException.class);
            throw new MqttException(e);
        }

        return new DisconnectingMqttAsyncClient(mqttClient);
    }

    private Retrier createRetrier() {
        IntToLongFunction exponential = Retrier.Strategies.waitExponential();
        IntToLongFunction waitStrategy = attempts -> 1000L * exponential.applyAsLong(attempts);
        return new Retrier.Builder()
                                  .withWaitStrategy(waitStrategy)
                                  .withStopStrategy(Retrier.Strategies.stopAfter(10))
                                  .withFailedRetryStrategy(Retrier.Strategies.retryOn(ConnectException.class))
                                  .build();
    }

    private String mqttClientId() {
        return "eurofleets-feeder-" + UUID.randomUUID();
    }

    @Bean
    public MemoryPersistence mqttClientPersistence() {
        return new MemoryPersistence();
    }

    private static class DisconnectingMqttAsyncClient extends DelegatingMqttAsyncClient {
        public DisconnectingMqttAsyncClient(MqttAsyncClient mqttClient) {
            super(mqttClient);
        }

        @Override
        public void close() throws MqttException {
            try {
                if (isConnected()) {
                    disconnect().waitForCompletion();
                }
            } finally {
                super.close();
            }
        }
    }
}
