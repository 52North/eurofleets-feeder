package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonSetter;
import org.n52.emodnet.eurofleets.feeder.JsonConstants;

import java.util.Objects;

public class Parameter implements Named {

    private String name;

    private Object value;

    public Parameter() {
    }

    public Parameter(String name, Object value) {
        this.name = name;
        this.value = value;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    @JsonGetter(JsonConstants.VALUE)
    public Object getValue() {
        return value;
    }

    @JsonSetter(JsonConstants.VALUE)
    public void setValue(Object value) {
        this.value = value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Parameter)) {
            return false;
        }
        Parameter parameter = (Parameter) o;
        return Objects.equals(getName(), parameter.getName()) &&
               Objects.equals(getValue(), parameter.getValue());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getName(), getValue());
    }

    @Override
    public String toString() {
        return String.format("Parameter{name='%s', value=%s}", name, value);
    }
}
