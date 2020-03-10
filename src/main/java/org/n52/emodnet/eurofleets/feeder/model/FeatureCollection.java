package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import jdk.nashorn.internal.ir.ObjectNode;
import org.locationtech.jts.geom.Envelope;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.util.ArrayList;
import java.util.List;
import java.util.RandomAccess;

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = JsonConstants.TYPE)
@JsonSubTypes({@JsonSubTypes.Type(name = "FeatureCollection", value = FeatureCollection.class)})
public class FeatureCollection implements Enveloped {
    private ObjectNode properties;
    private List<Feature> features;

    @JsonGetter(JsonConstants.FEATURES)
    public List<Feature> getFeatures() {
        return features;
    }

    @JsonSetter(JsonConstants.FEATURES)
    public void setFeatures(List<Feature> features) {
        if (features instanceof RandomAccess) {
            this.features = features;
        } else if (features == null) {
            this.features = null;
        } else {
            this.features = new ArrayList<>(features);

        }

        this.features = features;
    }

    @JsonGetter(JsonConstants.PROPERTIES)
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
        Envelope envelope = new Envelope();
        getFeatures().stream().map(Feature::getEnvelope).forEach(envelope::expandToInclude);
        return envelope;
    }

    public Feature getFeature(int i) {
        if (features == null) {
            throw new IndexOutOfBoundsException();
        }
        return features.get(i);
    }

    public int size() {
        return features == null ? 0 : features.size();
    }

    public boolean isEmpty() {
        return size() == 0;
    }
}
