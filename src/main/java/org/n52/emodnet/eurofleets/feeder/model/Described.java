package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public interface Described {
    @JsonGetter(JsonConstants.DESCRIPTION)
    String getDescription();

    @JsonSetter(JsonConstants.DESCRIPTION)
    void setDescription(String description);
}
