package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.locationtech.jts.geom.Polygon;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public class Datastream extends DescribedEntity {
    private UnitOfMeasurement unitOfMeasurement;
    private String observationType;
    private Polygon observedArea;
    private ObservedProperty observedProperty;
    private Sensor sensor;
    private Thing thing;

    @JsonGetter(JsonConstants.THING)
    @JsonSerialize(as = IdentifiedEntity.class)
    public Thing getThing() {
        return this.thing;
    }

    @JsonSetter(JsonConstants.THING)
    public void setThing(Thing thing) {
        this.thing = thing;
    }

    @JsonGetter(JsonConstants.UNIT_OF_MEASUREMENT)
    public UnitOfMeasurement getUnitOfMeasurement() {
        return this.unitOfMeasurement;
    }

    @JsonSetter(JsonConstants.UNIT_OF_MEASUREMENT)
    public void setUnitOfMeasurement(UnitOfMeasurement unitOfMeasurement) {
        this.unitOfMeasurement = unitOfMeasurement;
    }

    @JsonGetter(JsonConstants.OBSERVATION_TYPE)
    public String getObservationType() {
        return this.observationType;
    }

    @JsonSetter(JsonConstants.OBSERVATION_TYPE)
    public void setObservationType(String observationType) {
        this.observationType = observationType;
    }

    @JsonGetter(JsonConstants.OBSERVED_AREA)
    public Polygon getObservedArea() {
        return this.observedArea;
    }

    @JsonSetter(JsonConstants.OBSERVED_AREA)
    public void setObservedArea(Polygon observedArea) {
        this.observedArea = observedArea;
    }

    @JsonGetter(JsonConstants.OBSERVED_PROPERTY)
    @JsonSerialize(as = IdentifiedEntity.class)
    public ObservedProperty getObservedProperty() {
        return this.observedProperty;
    }

    @JsonSetter(JsonConstants.OBSERVED_PROPERTY)
    public void setObservedProperty(ObservedProperty observedProperty) {
        this.observedProperty = observedProperty;
    }

    @JsonGetter(JsonConstants.SENSOR)
    @JsonSerialize(as = IdentifiedEntity.class)
    public Sensor getSensor() {
        return this.sensor;
    }

    @JsonSetter(JsonConstants.SENSOR)
    public void setSensor(Sensor sensor) {
        this.sensor = sensor;
    }
}
