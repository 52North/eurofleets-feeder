package org.n52.emodnet.eurofleets.feeder.datagram;

import org.locationtech.jts.geom.CoordinateXY;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.locationtech.jts.geom.PrecisionModel;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class Datagram {
    private static final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(PrecisionModel.FLOATING), 4326);
    private final String[] line;
    private final OffsetDateTime dateTime;
    private final Point geometry;
    private final Map<ObservedProperty, Number> values;

    public Datagram(String value, ObservedProperty... observedProperties) throws DatagramParseException {
        this.line = parseLine(value, observedProperties.length + 5);
        //ignore split[0]

        LocalDate date = parseDate(line[1]);
        LocalTime time;
        try {
            time = LocalTime.parse(line[2], DateTimeFormatters.HHMMSS);
        } catch (DateTimeParseException e) {
            throw new DatagramParseException("error parsing date", e);
        }

        try {
            double x = Double.parseDouble(line[3]);
            double y = Double.parseDouble(line[4]);
            this.geometry = geometryFactory.createPoint(new CoordinateXY(x, y));
        } catch (NumberFormatException e) {
            throw new DatagramParseException("error parsing coordinate", e);
        }

        this.dateTime = date.atTime(time).atOffset(ZoneOffset.UTC);
        this.values = new HashMap<>();
        for (int i = 0; i < observedProperties.length; i++) {
            String stringValue = line[5 + i];
            if (!stringValue.isEmpty()) {
                values.put(observedProperties[i], Double.parseDouble(stringValue));
            }
        }

    }

    private LocalDate parseDate(String value) throws DatagramParseException {
        LocalDate date1 = null;
        LocalDate date2 = null;
        DateTimeParseException e1 = null;
        DateTimeParseException e2 = null;

        try {
            date1 = LocalDate.parse(value, DateTimeFormatters.YYYYMMDD);
        } catch (DateTimeParseException e) {
            e1 = e;
        }

        try {
            date2 = LocalDate.parse(value, DateTimeFormatters.DDMMYYYY);
        } catch (DateTimeParseException e) {
            e2 = e;
        }

        if (e1 == null) {
            if (e2 == null) {
                if (date1.compareTo(date2) < 0) {
                    return date2;
                } else {
                    return date1;
                }
            } else {
                return date1;
            }
        } else {
            if (e2 == null) {
                return date2;
            } else {
                e1.addSuppressed(e2);
                throw new DatagramParseException("error parsing date", e1);
            }
        }
    }

    public Set<ObservedProperty> getObservedProperties() {
        return Collections.unmodifiableSet(values.keySet());
    }

    public Number getValue(ObservedProperty observedProperty) {
        return values.get(observedProperty);
    }

    public boolean hasValue(ObservedProperty observedProperty) {
        return values.containsKey(observedProperty) && values.get(observedProperty) != null;
    }

    public Point getGeometry() {
        return geometry;
    }

    private static String[] parseLine(String value, int expectedValues) throws DatagramParseException {
        if (value == null || value.isEmpty()) {
            throw new DatagramParseException(String.format("invalid datagram: <%s>", value));
        }
        String[] split = value.split(",", -1);
        if (split.length < expectedValues) {
            throw new DatagramParseException(String.format("invalid datagram: <%s>", value));
        }
        return split;
    }

    public OffsetDateTime getDateTime() {
        return this.dateTime;
    }

    public String toString() {
        return String.join(",", line);
    }
}
