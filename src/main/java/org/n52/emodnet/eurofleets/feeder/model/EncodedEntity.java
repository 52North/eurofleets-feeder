package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public class EncodedEntity extends DescribedEntity {
    private String encodingType;

    @JsonGetter(JsonConstants.ENCODING_TYPE)
    public String getEncodingType() {
        return this.encodingType;
    }

    @JsonSetter(JsonConstants.ENCODING_TYPE)
    public void setEncodingType(String encodingType) {
        this.encodingType = encodingType;
    }
}
