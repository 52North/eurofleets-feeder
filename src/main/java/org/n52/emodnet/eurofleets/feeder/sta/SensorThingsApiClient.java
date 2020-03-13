package org.n52.emodnet.eurofleets.feeder.sta;

import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.Location;
import org.n52.emodnet.eurofleets.feeder.model.Observation;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.Sensor;
import org.n52.emodnet.eurofleets.feeder.model.Thing;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
public class SensorThingsApiClient implements SensorThingsApi {
    private final SensorThingsApiHttpClient http;
    private final SensorThingsApiMqttClient mqtt;

    public SensorThingsApiClient(SensorThingsApiHttpClient http, SensorThingsApiMqttClient mqtt) {
        this.http = Objects.requireNonNull(http);
        this.mqtt = Objects.requireNonNull(mqtt);
    }

    @Override
    public void create(Thing thing) {
        http.create(thing);
    }

    @Override
    public void create(Sensor sensor) {
        http.create(sensor);
    }

    @Override
    public void create(Datastream datastream) {
        http.create(datastream);
    }

    @Override
    public void create(ObservedProperty observedProperty) {
        http.create(observedProperty);
    }

    @Override
    public void create(FeatureOfInterest featureOfInterest) {
        http.create(featureOfInterest);
    }

    @Override
    public void update(String id, Thing thing) {
        http.update(id, thing);
    }

    @Override
    public void create(Location location) {
        mqtt.create(location);
    }

    @Override
    public void create(Observation observation) {
        mqtt.create(observation);
    }
}
