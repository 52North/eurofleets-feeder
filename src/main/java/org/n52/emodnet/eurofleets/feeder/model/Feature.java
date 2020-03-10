package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import jdk.nashorn.internal.ir.ObjectNode;
import org.locationtech.jts.geom.Envelope;
import org.locationtech.jts.geom.Geometry;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = JsonConstants.TYPE)
@JsonSubTypes({@JsonSubTypes.Type(name = "Feature", value = Feature.class)})
public class Feature implements Enveloped {
    private String id;
    private Geometry geometry;
    private ObjectNode properties;

    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    @JsonGetter(JsonConstants.ID)
    public String getId() {
        return id;
    }

    @JsonSetter(JsonConstants.ID)
    public void setId(String id) {
        this.id = id;
    }

    @JsonGetter(JsonConstants.GEOMETRY)
    public Geometry getGeometry() {
        return geometry;
    }

    @JsonSetter(JsonConstants.GEOMETRY)
    public void setGeometry(Geometry geometry) {
        this.geometry = geometry;
    }

    @JsonGetter(JsonConstants.PROPERTIES)
    @JsonInclude(JsonInclude.Include.NON_EMPTY)
    public ObjectNode getProperties() {
        return properties;
    }

    @JsonSetter(JsonConstants.PROPERTIES)
    public void setProperties(ObjectNode properties) {
        this.properties = properties;
    }

    @JsonIgnore
    @Override
    public Envelope getEnvelope() {
        return geometry.getEnvelopeInternal();
    }
}
