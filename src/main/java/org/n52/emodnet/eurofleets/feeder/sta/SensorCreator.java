package org.n52.emodnet.eurofleets.feeder.sta;

import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.Sensor;

public interface SensorCreator {
    void create(Sensor sensor);

}
