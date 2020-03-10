package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public interface Named {
    @JsonGetter(JsonConstants.NAME)
    String getName();

    @JsonSetter(JsonConstants.NAME)
    void setName(String name);
}
