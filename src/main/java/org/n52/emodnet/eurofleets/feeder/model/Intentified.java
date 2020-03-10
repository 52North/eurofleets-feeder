package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public interface Intentified extends Comparable<IdentifiedEntity> {
    @JsonGetter(JsonConstants.IOT_ID)
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    String getId();

    @JsonSetter(JsonConstants.IOT_ID)
    void setId(String id);

}
