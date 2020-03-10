package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.locationtech.jts.geom.Polygon;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public class Datastream extends DescribedEntity {
    private UnitOfMeasurement unitOfMeasurement;
    private String observationType;
    private Polygon observedArea;
    private ObservedProperty observedProperty;
    private Sensor sensor;

    @JsonGetter(JsonConstants.UNIT_OF_MEASUREMENT)
    public UnitOfMeasurement getUnitOfMeasurement() {
        return unitOfMeasurement;
    }

    @JsonSetter(JsonConstants.UNIT_OF_MEASUREMENT)
    public void setUnitOfMeasurement(UnitOfMeasurement unitOfMeasurement) {
        this.unitOfMeasurement = unitOfMeasurement;
    }

    @JsonGetter(JsonConstants.OBSERVATION_TYPE)
    public String getObservationType() {
        return observationType;
    }

    @JsonSetter(JsonConstants.OBSERVATION_TYPE)
    public void setObservationType(String observationType) {
        this.observationType = observationType;
    }

    @JsonGetter(JsonConstants.OBSERVED_AREA)
    public Polygon getObservedArea() {
        return observedArea;
    }

    @JsonSetter(JsonConstants.OBSERVED_AREA)
    public void setObservedArea(Polygon observedArea) {
        this.observedArea = observedArea;
    }

    @JsonGetter(JsonConstants.OBSERVED_PROPERTY)
    public ObservedProperty getObservedProperty() {
        return observedProperty;
    }

    @JsonSetter(JsonConstants.OBSERVED_PROPERTY)
    public void setObservedProperty(ObservedProperty observedProperty) {
        this.observedProperty = observedProperty;
    }

    @JsonGetter(JsonConstants.SENSOR)
    public Sensor getSensor() {
        return sensor;
    }

    @JsonSetter(JsonConstants.SENSOR)
    public void setSensor(Sensor sensor) {
        this.sensor = sensor;
    }
}
