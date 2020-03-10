package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public class Sensor extends EncodedEntity {

    private String metadata;

    @JsonGetter(JsonConstants.METADATA)
    public String getMetadata() {
        return metadata;
    }

    @JsonSetter(JsonConstants.METADATA)
    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
}