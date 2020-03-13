package org.n52.emodnet.eurofleets.feeder.sta;

import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.Location;
import org.n52.emodnet.eurofleets.feeder.model.Observation;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.Sensor;
import org.n52.emodnet.eurofleets.feeder.model.Thing;

public interface SensorThingsApi {
    void create(Thing thing);

    void create(Sensor sensor);

    void create(Datastream datastream);

    void create(ObservedProperty observedProperty);

    void create(FeatureOfInterest featureOfInterest);

    void update(String id, Thing thing);

    void create(Location location);

    void create(Observation observation);
}
