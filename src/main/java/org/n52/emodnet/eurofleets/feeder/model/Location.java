package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.util.List;

public class Location extends EncodedEntity {
    private Feature location;
    private List<IdentifiedEntity> things;

    @JsonGetter(JsonConstants.LOCATION)
    public Feature getLocation() {
        return location;
    }

    @JsonSetter(JsonConstants.LOCATION)
    public void setLocation(Feature location) {
        this.location = location;
    }

    @JsonGetter(JsonConstants.THINGS)
    @JsonSerialize(typing = JsonSerialize.Typing.STATIC)
    public List<IdentifiedEntity> getThings() {
        return things;
    }

    @JsonSetter(JsonConstants.THINGS)
    public void setThings(List<IdentifiedEntity> things) {
        this.things = things;
    }

    @Override
    public String toString() {
        return String.format("Location{location=%s, things=%s}", location, things);
    }
}
