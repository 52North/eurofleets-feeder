package org.n52.emodnet.eurofleets.feeder.datagram;

import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoField;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class Datagram {
    private static final DateTimeFormatter TIME_FORMATTER = new DateTimeFormatterBuilder()
                                                                    .appendValue(ChronoField.HOUR_OF_DAY, 2)
                                                                    .appendValue(ChronoField.MINUTE_OF_HOUR, 2)
                                                                    .appendValue(ChronoField.SECOND_OF_MINUTE, 2)
                                                                    .toFormatter();
    private static final DateTimeFormatter DATE_FORMATTER = new DateTimeFormatterBuilder()
                                                                    .appendValue(ChronoField.YEAR, 4)
                                                                    .appendValue(ChronoField.MONTH_OF_YEAR, 2)
                                                                    .appendValue(ChronoField.DAY_OF_MONTH, 2)
                                                                    .toFormatter();
    private final String[] line;
    private final OffsetDateTime dateTime;
    private final Map<ObservedProperty, Number> values;

    public Datagram(String value, ObservedProperty... observedProperties) throws DatagramParseException {
        this.line = parseLine(value, observedProperties.length + 3);
        //ignore split[0]
        LocalDate date;

        if (line[1].length() == 6) {
            line[1] = "20" + line[1];
        }

        try {
            date = LocalDate.parse(line[1], DATE_FORMATTER);
        } catch (DateTimeParseException e) {
            throw new DatagramParseException("error parsing date", e);
        }

        LocalTime time;
        try {
            time = LocalTime.parse(line[2], TIME_FORMATTER);
        } catch (
                  DateTimeParseException e) {
            throw new DatagramParseException("error parsing date", e);
        }
        this.dateTime = LocalDateTime.of(date, time).atOffset(ZoneOffset.UTC);
        this.values = new HashMap<>();
        for (
                int i = 0;
                i < observedProperties.length; i++) {
            String stringValue = line[3 + i];
            if (!stringValue.isEmpty()) {
                values.put(observedProperties[i], Double.parseDouble(stringValue));
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
