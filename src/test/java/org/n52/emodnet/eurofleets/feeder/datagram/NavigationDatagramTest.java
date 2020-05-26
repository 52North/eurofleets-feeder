package org.n52.emodnet.eurofleets.feeder.datagram;

import org.junit.jupiter.api.Test;
import org.locationtech.jts.geom.CoordinateXY;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.PrecisionModel;
import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.nullValue;

class NavigationDatagramTest {
    private final GeometryFactory geometryFactory = new GeometryFactory(new PrecisionModel(PrecisionModel.FLOATING), 4326);

    @Test
    public void testParsePsd() throws DatagramParseException {
        final NavigationDatagram parse = new NavigationDatagram("$PSDGPOS,20160524,122542,-003.871477,35.664951,112.5,7.5,1366.2,112.03,7.5");

        assertThat(parse.getDateTime(), is(OffsetDateTime
                                                   .of(2016, 5, 24, 12, 25, 42, 0, ZoneOffset.UTC)));

        assertThat(parse.getGeometry(), is(geometryFactory
                                                   .createPoint(new CoordinateXY(-3.871477, 35.664951))));

        assertThat(parse.getValue(ObservedProperties.HEADING), is(112.5));
        assertThat(parse.getValue(ObservedProperties.SPEED), is(7.5));
        assertThat(parse.getValue(ObservedProperties.DEPTH), is(1366.2));
        assertThat(parse.getValue(ObservedProperties.COURSE_OVER_GROUND), is(112.03));
        assertThat(parse.getValue(ObservedProperties.SPEED_OVER_GROUND), is(7.5));

    }

    @Test
    public void testParseBel() throws DatagramParseException {
        final NavigationDatagram parse = new NavigationDatagram("$BELPOS,200312,071900,3.198552,51.335977,211.10001,,8.9,,0.041");

        assertThat(parse.getDateTime(), is(OffsetDateTime
                                                   .of(2020, 3, 12, 7, 19, 0, 0, ZoneOffset.UTC)));

        assertThat(parse.getGeometry(), is(geometryFactory
                                                   .createPoint(new CoordinateXY(3.198552, 51.335977))));

        assertThat(parse.getValue(ObservedProperties.HEADING), is(211.10001));
        assertThat(parse.getValue(ObservedProperties.SPEED), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.DEPTH), is(8.9));
        assertThat(parse.getValue(ObservedProperties.COURSE_OVER_GROUND), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.SPEED_OVER_GROUND), is(0.041));

    }

    @Test
    public void testNew() throws DatagramParseException {
        final NavigationDatagram parse = new NavigationDatagram("$HESNAV,20200416,211444,-15.2985287,27.4632204,353.30,,,359.04,3.40");
        assertThat(parse.getGeometry(), is(geometryFactory.createPoint(new CoordinateXY(-15.2985287, 27.4632204))));

    }
}