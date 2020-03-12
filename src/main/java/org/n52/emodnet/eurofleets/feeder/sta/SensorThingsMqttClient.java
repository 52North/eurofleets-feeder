package org.n52.emodnet.eurofleets.feeder.sta;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectWriter;
import org.eclipse.paho.client.mqttv3.IMqttActionListener;
import org.eclipse.paho.client.mqttv3.IMqttAsyncClient;
import org.eclipse.paho.client.mqttv3.IMqttToken;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.n52.emodnet.eurofleets.feeder.model.Location;
import org.n52.emodnet.eurofleets.feeder.model.Observation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
public class SensorThingsMqttClient implements ObservationCreator, LocationCreator {
    private static final Logger LOG = LoggerFactory.getLogger(SensorThingsMqttClient.class);
    private final IMqttAsyncClient mqttClient;
    private final ObjectWriter objectWriter;
    private boolean closed;

    @Autowired
    public SensorThingsMqttClient(IMqttAsyncClient mqttClient, ObjectWriter objectWriter) {
        this.mqttClient = Objects.requireNonNull(mqttClient);
        this.objectWriter = Objects.requireNonNull(objectWriter);
    }

    @Override
    public void create(Location location) {
        publish("Locations", location);
    }

    @Override
    public void create(Observation observation) {
        publish("Observations", observation);
    }

    private void publish(String topic, Object writable) {
        try {
            mqttClient.publish(topic, objectWriter.writeValueAsBytes(writable), 1, false)
                      .setActionCallback(new IMqttActionListener() {
                          @Override
                          public void onSuccess(IMqttToken asyncActionToken) {
                              LOG.info("Published message for topic {}: {}", topic, writable);
                          }

                          @Override
                          public void onFailure(IMqttToken asyncActionToken, Throwable exception) {
                              String errorMessage = String.format("Failed to publish message for topic %s: %s",
                                                                  topic, writable);
                              LOG.error(errorMessage, exception);
                          }
                      });
        } catch (MqttException | JsonProcessingException e) {
            LOG.error("could not publish MQTT message", e);
        }
    }
}
