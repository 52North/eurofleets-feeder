package org.n52.emodnet.eurofleets.feeder.sta;

import org.n52.emodnet.eurofleets.feeder.model.Thing;

public interface ThingUpdater {
    void update(String id, Thing thing);
}
