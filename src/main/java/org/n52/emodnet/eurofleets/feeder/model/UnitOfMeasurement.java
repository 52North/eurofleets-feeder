package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

public class UnitOfMeasurement implements Named, Defined {
    private String name;
    private String symbol;
    private String definition;

    public UnitOfMeasurement() {}

    public UnitOfMeasurement(String name, String symbol, String definition) {
        this.name = name;
        this.definition = definition;
        this.symbol = symbol;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @JsonGetter(JsonConstants.SYMBOL)
    public String getSymbol() {
        return symbol;
    }

    @JsonSetter(JsonConstants.SYMBOL)
    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    @Override
    public String getDefinition() {
        return definition;
    }

    @Override
    public void setDefinition(String definition) {
        this.definition = definition;
    }

}
