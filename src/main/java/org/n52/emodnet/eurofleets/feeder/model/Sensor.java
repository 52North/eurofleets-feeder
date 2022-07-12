package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public class Sensor extends EncodedEntity {

    private String metadata;

    @JsonInclude(JsonInclude.Include.ALWAYS)
    @JsonGetter(JsonConstants.METADATA)
    public String getMetadata() {
        return this.metadata;
    }

    @JsonSetter(JsonConstants.METADATA)
    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
}
