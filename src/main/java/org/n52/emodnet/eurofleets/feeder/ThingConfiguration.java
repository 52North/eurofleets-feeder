package org.n52.emodnet.eurofleets.feeder;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.net.URL;

@Configuration
@ConfigurationProperties(prefix = "feeder.thing")
public class ThingConfiguration {
    private String id;
    private String name;
    private String description;
    private double[] observedArea;
    private URL metadata;
    private String metadataType = "http://www.opengis.net/doc/IS/SensorML/2.0";

    public String getMetadataType() {
        return metadataType;
    }

    public void setMetadataType(String metadataType) {
        this.metadataType = metadataType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double[] getObservedArea() {
        return observedArea;
    }

    public void setObservedArea(double[] observedArea) {
        this.observedArea = observedArea;
    }

    public URL getMetadata() {
        return metadata;
    }

    public void setMetadata(URL metadata) {
        this.metadata = metadata;
    }
}
