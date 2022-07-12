package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Observation {
    private Object result;
    private OffsetDateTime phenomenonTime;
    private OffsetDateTime resultTime;
    private List<Parameter> parameters;
    private Datastream datastream;
    private FeatureOfInterest featureOfInterest;

    @JsonGetter(JsonConstants.RESULT_TIME)
    public OffsetDateTime getResultTime() {
        return this.resultTime;
    }

    @JsonSetter(JsonConstants.RESULT_TIME)
    public void setResultTime(OffsetDateTime resultTime) {
        this.resultTime = resultTime;
    }

    @JsonGetter(JsonConstants.RESULT)
    public Object getResult() {
        return this.result;
    }

    @JsonSetter(JsonConstants.RESULT)
    public void setResult(Object result) {
        this.result = result;
    }

    @JsonGetter(JsonConstants.PHENOMENON_TIME)
    public OffsetDateTime getPhenomenonTime() {
        return this.phenomenonTime;
    }

    @JsonSetter(JsonConstants.PHENOMENON_TIME)
    public void setPhenomenonTime(OffsetDateTime phenomenonTime) {
        this.phenomenonTime = phenomenonTime;
    }

    @JsonGetter(JsonConstants.PARAMETERS)
    @JsonSerialize(using = ParameterJsonSerializer.class)
    public List<Parameter> getParameters() {
        return this.parameters;
    }

    @JsonSetter(JsonConstants.PARAMETERS)
    @JsonDeserialize(using = ParameterJsonDeserializer.class)
    public void setParameters(List<Parameter> parameters) {
        this.parameters = parameters;
    }

    @JsonGetter(JsonConstants.DATASTREAM)
    @JsonSerialize(as = IdentifiedEntity.class)
    public Datastream getDatastream() {
        return this.datastream;
    }

    @JsonSetter(JsonConstants.DATASTREAM)
    public void setDatastream(Datastream datastream) {
        this.datastream = datastream;
    }

    @JsonGetter(JsonConstants.FEATURE_OF_INTEREST)
    @JsonSerialize(as = IdentifiedEntity.class)
    public FeatureOfInterest getFeatureOfInterest() {
        return this.featureOfInterest;
    }

    @JsonSetter(JsonConstants.FEATURE_OF_INTEREST)
    public void setFeatureOfInterest(FeatureOfInterest featureOfInterest) {
        this.featureOfInterest = featureOfInterest;
    }

    @Override
    public String toString() {
        return String.format("Observation{datastream=%s, time=%s}", this.datastream, this.phenomenonTime);
    }

    private static class ParameterJsonDeserializer extends JsonDeserializer<List<Parameter>> {
        private static final TypeReference<Map<String, Object>> MAP_TYPE = new TypeReference<Map<String, Object>>() {};

        @Override
        public List<Parameter> deserialize(JsonParser p, DeserializationContext ctxt)
                throws IOException {
            Map<String, Object> map = p.readValueAs(MAP_TYPE);
            return map.entrySet().stream().map(e -> new Parameter(e.getKey(), e.getValue()))
                      .collect(Collectors.toList());
        }
    }

    private static class ParameterJsonSerializer extends JsonSerializer<List<Parameter>> {
        @Override
        public void serialize(List<Parameter> value, JsonGenerator gen, SerializerProvider serializers)
                throws IOException {
            if (value == null) {
                gen.writeNull();
            } else {
                gen.writeStartObject();
                for (Parameter parameter : value) {
                    gen.writeFieldName(parameter.getName());
                    gen.writeObject(parameter.getValue());
                }
                gen.writeEndObject();
            }
        }
    }
}
