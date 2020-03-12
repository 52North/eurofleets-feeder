package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.time.OffsetDateTime;
import java.util.List;

public class Observation {
    private Object result;
    private OffsetDateTime phenomenonTime;
    private OffsetDateTime resultTime;
    private List<Parameter> parameters;
    private Datastream datastream;
    private FeatureOfInterest featureOfInterest;

    @JsonGetter(JsonConstants.RESULT_TIME)
    public OffsetDateTime getResultTime() {
        return resultTime;
    }

    @JsonSetter(JsonConstants.RESULT_TIME)
    public void setResultTime(OffsetDateTime resultTime) {
        this.resultTime = resultTime;
    }

    @JsonGetter(JsonConstants.RESULT)
    public Object getResult() {
        return result;
    }

    @JsonSetter(JsonConstants.RESULT)
    public void setResult(Object result) {
        this.result = result;
    }

    @JsonGetter(JsonConstants.PHENOMENON_TIME)
    public OffsetDateTime getPhenomenonTime() {
        return phenomenonTime;
    }

    @JsonSetter(JsonConstants.PHENOMENON_TIME)
    public void setPhenomenonTime(OffsetDateTime phenomenonTime) {
        this.phenomenonTime = phenomenonTime;
    }

    @JsonGetter(JsonConstants.PARAMETERS)
    public List<Parameter> getParameters() {
        return parameters;
    }

    @JsonSetter(JsonConstants.PARAMETERS)
    public void setParameters(List<Parameter> parameters) {
        this.parameters = parameters;
    }

    @JsonGetter(JsonConstants.DATASTREAM)
    @JsonSerialize(as = IdentifiedEntity.class)
    public Datastream getDatastream() {
        return datastream;
    }

    @JsonSetter(JsonConstants.DATASTREAM)
    public void setDatastream(Datastream datastream) {
        this.datastream = datastream;
    }

    @JsonGetter(JsonConstants.FEATURE_OF_INTEREST)
    @JsonSerialize(as = IdentifiedEntity.class)
    public FeatureOfInterest getFeatureOfInterest() {
        return featureOfInterest;
    }

    @JsonSetter(JsonConstants.FEATURE_OF_INTEREST)
    public void setFeatureOfInterest(FeatureOfInterest featureOfInterest) {
        this.featureOfInterest = featureOfInterest;
    }

    @Override
    public String toString() {
        return String.format("Observation{datastream=%s, time=%s}", datastream, phenomenonTime);
    }
}
