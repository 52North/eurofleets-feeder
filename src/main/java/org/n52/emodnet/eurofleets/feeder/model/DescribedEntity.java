package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.util.Map;

public class DescribedEntity extends IdentifiedEntity implements Named, Described {
    private String name;
    private String description;
    private Map<String, Object> properties;

    public DescribedEntity() {
    }

    public DescribedEntity(String id, String name, String description) {
        super(id);
        this.name = name;
        this.description = description;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String getDescription() {
        return this.description;
    }

    @Override
    public void setDescription(String description) {
        this.description = description;
    }

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    @JsonGetter(JsonConstants.PROPERTIES)
    public Map<String, Object> getProperties() {
        return properties;
    }

    @JsonSetter(JsonConstants.PROPERTIES)
    public void setProperties(Map<String, Object> properties) {
        this.properties = properties;
    }
}
