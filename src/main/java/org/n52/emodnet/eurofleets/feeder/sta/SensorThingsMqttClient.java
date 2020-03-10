package org.n52.emodnet.eurofleets.feeder.sta;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectWriter;
import org.eclipse.paho.client.mqttv3.IMqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.n52.emodnet.eurofleets.feeder.model.Location;
import org.n52.emodnet.eurofleets.feeder.model.Observation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.Objects;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

@Service
public class SensorThingsMqttClient implements ObservationCreator, LocationCreator, AutoCloseable {
    private static final Logger LOG = LoggerFactory.getLogger(SensorThingsMqttClient.class);
    private final BlockingQueue<Message> queue = new LinkedBlockingDeque<>();
    private final Thread thread;
    private final IMqttClient mqttClient;
    private final ObjectWriter objectWriter;
    private boolean closed;

    @Autowired
    public SensorThingsMqttClient(IMqttClient mqttClient, ObjectWriter objectWriter) {
        this.mqttClient = Objects.requireNonNull(mqttClient);
        this.objectWriter = Objects.requireNonNull(objectWriter);
        this.thread = new Thread(this::consumer);
        this.thread.start();
    }

    @Override
    public void create(Location location) {
        create(new Message("Locations", location));
    }

    @Override
    public void create(Observation observation) {
        create(new Message("Observations", observation));
    }

    @Override
    public void close() {
        closed = true;
        thread.interrupt();
    }

    private void create(Message message) {
        if (closed) {
            throw new IllegalStateException("closed");
        }
        if (!queue.offer(message)) {
            LOG.error("could not enqueue message");
        } else {
            LOG.info("Enqueued message for topic {}: {}", message.getTopic(), message.getWritable());
        }
    }

    private void consumer() {
        while (!closed) {
            try {
                publish(queue.take());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                return;
            }
        }
    }

    private void publish(Message message) {
        try {
            String payload = objectWriter.writeValueAsString(message.getWritable());
            mqttClient.publish(message.getTopic(), payload.getBytes(StandardCharsets.UTF_8), 1, false);
            LOG.info("Published message for topic {}: {}", message.getTopic(), payload);
        } catch (MqttException | JsonProcessingException e) {
            LOG.error("could not publish MQTT message", e);
        }
    }

    private static final class Message {
        private final String topic;
        private final Object writable;

        public Message(String topic, Object writable) {
            this.topic = Objects.requireNonNull(topic);
            this.writable = Objects.requireNonNull(writable);
        }

        public String getTopic() {
            return topic;
        }

        public Object getWritable() {
            return writable;
        }
    }

}
