package org.n52.emodnet.eurofleets.feeder;

import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class Datastreams {

    private final Map<ObservedProperty, Datastream> datastreams;

    public Datastreams(Datastream... datastreams) {
        this.datastreams = new HashMap<>(datastreams.length);
        for (Datastream ds : datastreams) {
            this.datastreams.put(ds.getObservedProperty(), ds);
        }
    }

    public Collection<Datastream> all() {
        return Collections.unmodifiableCollection(datastreams.values());
    }

    public Datastream get(ObservedProperty observedProperty) {
        return datastreams.get(observedProperty);
    }

}
