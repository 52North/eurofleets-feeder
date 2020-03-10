package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.util.Collection;

public class Thing extends DescribedEntity {
    private Collection<Datastream> datastreams;

    @JsonGetter(JsonConstants.DATASTREAMS)
    public Collection<Datastream> getDatastreams() {
        return datastreams;
    }

    @JsonSetter(JsonConstants.DATASTREAMS)
    public void setDatastreams(Collection<Datastream> datastreams) {
        this.datastreams = datastreams;
    }

}
