package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.util.Objects;

public interface Intentified extends Comparable<IdentifiedEntity> {
    @JsonGetter(JsonConstants.IOT_ID)
    String getId();

    @JsonSetter(JsonConstants.IOT_ID)
    void setId(String id);

}
