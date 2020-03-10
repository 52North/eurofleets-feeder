package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public interface Defined {
    @JsonGetter(JsonConstants.DEFINITION)
    String getDefinition();

    @JsonSetter(JsonConstants.DEFINITION)
    void setDefinition(String definition);
}
