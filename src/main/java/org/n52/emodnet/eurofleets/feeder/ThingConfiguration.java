package org.n52.emodnet.eurofleets.feeder;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "feeder.thing")
public class ThingConfiguration {
    private String id;
    private String name;
    private String description;
    private double[] observedArea;

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
}
