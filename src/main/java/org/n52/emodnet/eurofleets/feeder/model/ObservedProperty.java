package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public class ObservedProperty extends DescribedEntity {
    public ObservedProperty(String id, String name, String definition) {
        this(id, name, name, definition);
    }

    public ObservedProperty(String id, String name, String description, String definition) {
        super(id, name, description);
        this.definition = definition;
    }

    public ObservedProperty() {}

    @JsonGetter(JsonConstants.DEFINITION)
    public String getDefinition() {
        return definition;
    }

    @JsonSetter(JsonConstants.DEFINITION)
    public void setDefinition(String definition) {
        this.definition = definition;
    }

    private String definition;

}
