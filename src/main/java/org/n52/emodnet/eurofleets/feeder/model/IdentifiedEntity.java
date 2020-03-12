package org.n52.emodnet.eurofleets.feeder.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.Objects;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class IdentifiedEntity implements Intentified {
    private String id;

    public IdentifiedEntity() {}

    public IdentifiedEntity(String id) {
        this.id = Objects.requireNonNull(id);
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    @Override
    public int compareTo(IdentifiedEntity o) {
        return getId().compareTo(o.getId());
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof IdentifiedEntity)) {
            return false;
        }
        IdentifiedEntity that = (IdentifiedEntity) o;
        return Objects.equals(getId(), that.getId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return String.format("%s{id='%s'}", getClass().getSimpleName(), getId());
    }
}
