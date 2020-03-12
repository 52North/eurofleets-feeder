package org.n52.emodnet.eurofleets.feeder.config;

import org.eclipse.paho.client.mqttv3.IMqttActionListener;
import org.eclipse.paho.client.mqttv3.IMqttAsyncClient;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.IMqttMessageListener;
import org.eclipse.paho.client.mqttv3.IMqttToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.util.Objects;

public abstract class DelegatingMqttAsyncClient implements IMqttAsyncClient {
    private final IMqttAsyncClient delegate;

    public DelegatingMqttAsyncClient(IMqttAsyncClient delegate) {
        this.delegate = Objects.requireNonNull(delegate);
    }

    @Override
    public IMqttToken connect() throws MqttException {
        return delegate.connect();
    }

    @Override
    public IMqttToken connect(MqttConnectOptions options) throws MqttException {
        return delegate.connect(options);
    }

    @Override
    public IMqttToken connect(Object userContext,
                              IMqttActionListener callback) throws MqttException {
        return delegate.connect(userContext, callback);
    }

    @Override
    public IMqttToken connect(MqttConnectOptions options, Object userContext,
                              IMqttActionListener callback) throws MqttException {
        return delegate.connect(options, userContext, callback);
    }

    @Override
    public IMqttToken disconnect() throws MqttException {
        return delegate.disconnect();
    }

    @Override
    public IMqttToken disconnect(long quiesceTimeout) throws MqttException {
        return delegate.disconnect(quiesceTimeout);
    }

    @Override
    public IMqttToken disconnect(Object userContext,
                                 IMqttActionListener callback) throws MqttException {
        return delegate.disconnect(userContext, callback);
    }

    @Override
    public IMqttToken disconnect(long quiesceTimeout, Object userContext,
                                 IMqttActionListener callback) throws MqttException {
        return delegate.disconnect(quiesceTimeout, userContext, callback);
    }

    @Override
    public void disconnectForcibly() throws MqttException {
        delegate.disconnectForcibly();
    }

    @Override
    public void disconnectForcibly(long disconnectTimeout) throws MqttException {
        delegate.disconnectForcibly(disconnectTimeout);
    }

    @Override
    public void disconnectForcibly(long quiesceTimeout, long disconnectTimeout) throws MqttException {
        delegate.disconnectForcibly(quiesceTimeout, disconnectTimeout);
    }

    @Override
    public boolean isConnected() {
        return delegate.isConnected();
    }

    @Override
    public String getClientId() {
        return delegate.getClientId();
    }

    @Override
    public String getServerURI() {
        return delegate.getServerURI();
    }

    @Override
    public IMqttDeliveryToken publish(String topic, byte[] payload, int qos,
                                      boolean retained) throws MqttException {
        return delegate.publish(topic, payload, qos, retained);
    }

    @Override
    public IMqttDeliveryToken publish(String topic, byte[] payload, int qos,
                                      boolean retained, Object userContext,
                                      IMqttActionListener callback) throws MqttException {
        return delegate.publish(topic, payload, qos, retained, userContext, callback);
    }

    @Override
    public IMqttDeliveryToken publish(String topic,
                                      MqttMessage message) throws MqttException {
        return delegate.publish(topic, message);
    }

    @Override
    public IMqttDeliveryToken publish(String topic,
                                      MqttMessage message,
                                      Object userContext,
                                      IMqttActionListener callback) throws MqttException {
        return delegate.publish(topic, message, userContext, callback);
    }

    @Override
    public IMqttToken subscribe(String topicFilter, int qos) throws MqttException {
        return delegate.subscribe(topicFilter, qos);
    }

    @Override
    public IMqttToken subscribe(String topicFilter, int qos, Object userContext,
                                IMqttActionListener callback) throws MqttException {
        return delegate.subscribe(topicFilter, qos, userContext, callback);
    }

    @Override
    public IMqttToken subscribe(String[] topicFilters, int[] qos) throws MqttException {
        return delegate.subscribe(topicFilters, qos);
    }

    @Override
    public IMqttToken subscribe(String[] topicFilters, int[] qos,
                                Object userContext,
                                IMqttActionListener callback) throws MqttException {
        return delegate.subscribe(topicFilters, qos, userContext, callback);
    }

    @Override
    public IMqttToken subscribe(String topicFilter, int qos, Object userContext,
                                IMqttActionListener callback,
                                IMqttMessageListener messageListener) throws MqttException {
        return delegate.subscribe(topicFilter, qos, userContext, callback, messageListener);
    }

    @Override
    public IMqttToken subscribe(String topicFilter, int qos,
                                IMqttMessageListener messageListener) throws MqttException {
        return delegate.subscribe(topicFilter, qos, messageListener);
    }

    @Override
    public IMqttToken subscribe(String[] topicFilters, int[] qos,
                                IMqttMessageListener[] messageListeners) throws MqttException {
        return delegate.subscribe(topicFilters, qos, messageListeners);
    }

    @Override
    public IMqttToken subscribe(String[] topicFilters, int[] qos,
                                Object userContext,
                                IMqttActionListener callback,
                                IMqttMessageListener[] messageListeners) throws MqttException {
        return delegate.subscribe(topicFilters, qos, userContext, callback, messageListeners);
    }

    @Override
    public IMqttToken unsubscribe(String topicFilter) throws MqttException {
        return delegate.unsubscribe(topicFilter);
    }

    @Override
    public IMqttToken unsubscribe(String[] topicFilters) throws MqttException {
        return delegate.unsubscribe(topicFilters);
    }

    @Override
    public IMqttToken unsubscribe(String topicFilter, Object userContext,
                                  IMqttActionListener callback) throws MqttException {
        return delegate.unsubscribe(topicFilter, userContext, callback);
    }

    @Override
    public IMqttToken unsubscribe(String[] topicFilters, Object userContext,
                                  IMqttActionListener callback) throws MqttException {
        return delegate.unsubscribe(topicFilters, userContext, callback);
    }

    @Override
    public boolean removeMessage(IMqttDeliveryToken token) throws MqttException {
        return delegate.removeMessage(token);
    }

    @Override
    public void setCallback(MqttCallback callback) {
        delegate.setCallback(callback);
    }

    @Override
    public IMqttDeliveryToken[] getPendingDeliveryTokens() {
        return delegate.getPendingDeliveryTokens();
    }

    @Override
    public void setManualAcks(boolean manualAcks) {
        delegate.setManualAcks(manualAcks);
    }

    @Override
    public void reconnect() throws MqttException {
        delegate.reconnect();
    }

    @Override
    public void messageArrivedComplete(int messageId, int qos) throws MqttException {
        delegate.messageArrivedComplete(messageId, qos);
    }

    @Override
    public void close() throws MqttException {
        delegate.close();
    }

}
