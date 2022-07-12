package org.n52.emodnet.eurofleets.feeder;

import com.google.common.collect.ImmutableMap;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.UnitOfMeasurement;

import java.util.Map;
import java.util.Set;

public interface ObservedProperties {
    ObservedProperty PRESSURE = new ObservedProperty("pressure", "Atmospheric Pressure", "http://vocab.nerc.ac.uk/collection/P02/current/CAPH/");
    ObservedProperty WATER_TEMPERATURE = new ObservedProperty("water_temperature", "Water Temperature", "http://vocab.nerc.ac.uk/collection/P02/current/TEMP/");
    ObservedProperty RAW_FLUOROMETRY = new ObservedProperty("raw_fluorometry", "Raw Fluorometry", "http://vocab.nerc.ac.uk/collection/P02/current/FVLT/");
    ObservedProperty CONDUCTIVITY = new ObservedProperty("conductivity", "Conductivity", "http://vocab.nerc.ac.uk/collection/P02/current/CNDC/");
    ObservedProperty DENSITY = new ObservedProperty("density", "Density (SIGMA-T)", "http://vocab.nerc.ac.uk/collection/P02/current/SIGT/");
    ObservedProperty SALINITY = new ObservedProperty("salinity", "Salinity", "http://vocab.nerc.ac.uk/collection/P02/current/PSAL/");
    ObservedProperty HEADING = new ObservedProperty("heading", "Heading", "http://vocab.nerc.ac.uk/collection/P01/current/HDNGGP01/");
    ObservedProperty SPEED = new ObservedProperty("speed", "Speed", "http://vocab.nerc.ac.uk/collection/P01/current/APSAWM01/");
    ObservedProperty DEPTH = new ObservedProperty("depth", "Depth", "http://vocab.nerc.ac.uk/collection/P07/current/CFV13N17/");
    ObservedProperty COURSE_OVER_GROUND = new ObservedProperty("course_over_ground", "Course over ground", "http://vocab.nerc.ac.uk/collection/P01/current/APDAZZ01/");
    ObservedProperty SPEED_OVER_GROUND = new ObservedProperty("speed_over_ground", "Speed over ground", "http://vocab.nerc.ac.uk/collection/P01/current/APSAGP01/");
    ObservedProperty WIND_SPEED = new ObservedProperty("wind_speed", "Wind Speed", "http://vocab.nerc.ac.uk/collection/P07/current/CFSN0038/");
    ObservedProperty WIND_DIRECTION = new ObservedProperty("wind_direction", "Wind Direction", "http://vocab.nerc.ac.uk/collection/P01/current/EGTDZZ01/");
    ObservedProperty AIR_TEMPERATURE = new ObservedProperty("air_temperature", "Air temperature", "http://vocab.nerc.ac.uk/collection/P02/current/CDTA/");
    ObservedProperty HUMIDITY = new ObservedProperty("humidity", "Relative Humidity", "http://vocab.nerc.ac.uk/collection/P01/current/CHUMZZ01/");
    ObservedProperty SOLAR_RADIATION = new ObservedProperty("solar_radiation", "Solar Radiation", "http://vocab.nerc.ac.uk/collection/P02/current/CSLR/");
    ObservedProperty LONGITUDE = new ObservedProperty("longitude", "Longitude", "http://vocab.nerc.ac.uk/collection/P01/current/ALONZZ01/");
    ObservedProperty LATITUDE = new ObservedProperty("latitude", "Latitude", "http://vocab.nerc.ac.uk/collection/P01/current/ALATZZ01/");
    ObservedProperty EVENTS = new ObservedProperty("events", "Events", "http://www.opengis.net/sensorml/2.0#Event");
    Map<ObservedProperty, UnitOfMeasurement> UNITS = ImmutableMap.<ObservedProperty, UnitOfMeasurement>builder()
                                                                 .put(HEADING, Units.DEGREES).put(SPEED, Units.KNOTS)
                                                                 .put(DEPTH, Units.METRES)
                                                                 .put(SPEED_OVER_GROUND, Units.KNOTS)
                                                                 .put(COURSE_OVER_GROUND, Units.DEGREES)
                                                                 .put(WIND_SPEED, Units.METRES_PER_SECOND)
                                                                 .put(WIND_DIRECTION, Units.DEGREES)
                                                                 .put(AIR_TEMPERATURE, Units.DEGREES_CELSIUS)
                                                                 .put(HUMIDITY, Units.PERCENT)
                                                                 .put(SOLAR_RADIATION, Units.WATTS_PER_SQUARE_METRE)
                                                                 .put(PRESSURE, Units.HECTOPASCALS)
                                                                 .put(WATER_TEMPERATURE, Units.DEGREES_CELSIUS)
                                                                 .put(SALINITY, Units.PSU)
                                                                 .put(RAW_FLUOROMETRY, Units.VOLTS)
                                                                 .put(CONDUCTIVITY, Units.SIEMENS_PER_METRE)
                                                                 .put(DENSITY, Units.KILOGRAMS_PER_CUBIC_METRE)
                                                                 .put(LATITUDE, Units.DEGREES)
                                                                 .put(LONGITUDE, Units.DEGREES)
                                                                 .put(EVENTS, Units.INAPPLICABLE)
                                                                 .build();

    Set<ObservedProperty> ALL = UNITS.keySet();

}
