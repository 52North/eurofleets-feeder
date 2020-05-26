package org.n52.emodnet.eurofleets.feeder.datagram;

import org.junit.jupiter.api.Test;
import org.locationtech.jts.geom.CoordinateXY;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.nullValue;

class MeteorologyDatagramTest {
    private final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(PrecisionModel.FLOATING), 4326);
    @Test
    public void testParsePsd() throws DatagramParseException {
        final MeteorologyDatagram parse = new MeteorologyDatagram("$PSDGMET,20160505,003250,3.198552,51.335977,5.30,5.98,5.38,16.77,103.20,0.00,1014.66,17.4");

        assertThat(parse.getDateTime(), is(OffsetDateTime
                                                   .of(2016, 5, 5, 0, 32, 50, 0, ZoneOffset.UTC)));
        assertThat(parse.getGeometry(), is(geometryFactory
                                                   .createPoint(new CoordinateXY(3.198552, 51.335977))));

        assertThat(parse.getValue(ObservedProperties.WIND_MEAN), is(5.3));
        assertThat(parse.getValue(ObservedProperties.WIND_GUST), is(5.98));
        assertThat(parse.getValue(ObservedProperties.WIND_DIRECTION), is(5.38));
        assertThat(parse.getValue(ObservedProperties.AIR_TEMPERATURE), is(16.77));
        assertThat(parse.getValue(ObservedProperties.HUMIDITY), is(103.20));
        assertThat(parse.getValue(ObservedProperties.SOLAR_RADIATION), is(0.0));
        assertThat(parse.getValue(ObservedProperties.PRESSURE), is(1014.660));

    }

    @Test
    public void testParseBel() throws DatagramParseException {
        final MeteorologyDatagram parse = new MeteorologyDatagram("$BELMET,200312,071900,3.198552,51.335977,10.8,,57.999996,8.551559,,,1011.3877,");
        assertThat(parse.getGeometry(), is(geometryFactory
                                                   .createPoint(new CoordinateXY(3.198552, 51.335977))));

        assertThat(parse.getDateTime(), is(OffsetDateTime.of(2020, 3, 12, 7, 19, 0, 0, ZoneOffset.UTC)));
        assertThat(parse.getValue(ObservedProperties.WIND_MEAN), is(10.8));
        assertThat(parse.getValue(ObservedProperties.WIND_GUST), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.WIND_DIRECTION), is(57.999996));
        assertThat(parse.getValue(ObservedProperties.AIR_TEMPERATURE), is(8.551559));
        assertThat(parse.getValue(ObservedProperties.HUMIDITY), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.SOLAR_RADIATION), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.PRESSURE), is(1011.3877));
    }

    @Test
    public void testDDMMYY() {
        assertThat(LocalDate.parse("190220", DateTimeFormatters.DDMMYYYY),
                   is(LocalDate.of(2020, 2, 19)));
    }

    @Test
    public void testParsePsdOld() throws DatagramParseException {
        final MeteorologyDatagram parse = new MeteorologyDatagram("$PSDGMET,190220,115715,3.198552,51.335977,1.81411,1.81411,140,13.23305,61.39138,283.5505,1038.438");
        assertThat(parse.getGeometry(), is(geometryFactory
                                                   .createPoint(new CoordinateXY(3.198552, 51.335977))));

        assertThat(parse.getDateTime(), is(OffsetDateTime.of(2020, 2, 19, 11, 57, 15, 0, ZoneOffset.UTC)));
        assertThat(parse.getValue(ObservedProperties.WIND_MEAN), is(1.81411));
        assertThat(parse.getValue(ObservedProperties.WIND_GUST), is(1.81411));
        assertThat(parse.getValue(ObservedProperties.WIND_DIRECTION), is(140.0));
        assertThat(parse.getValue(ObservedProperties.AIR_TEMPERATURE), is(13.23305));
        assertThat(parse.getValue(ObservedProperties.HUMIDITY), is(61.39138));
        assertThat(parse.getValue(ObservedProperties.SOLAR_RADIATION), is(283.5505));
        assertThat(parse.getValue(ObservedProperties.PRESSURE), is(1038.438));
    }

}