package org.n52.emodnet.eurofleets.feeder.datagram;

import org.junit.jupiter.api.Test;
import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.nullValue;

class PositionDatagramTest {
    @Test
    public void testParsePsd() throws DatagramParseException {
        final PositionDatagram parse = new PositionDatagram("$PSDGPOS,20160524,122542,-003.871477,35.664951,112.5,7.5,1366.2,112.03,7.5");

        assertThat(parse.getDateTime(), is(OffsetDateTime
                                                   .of(2016, 5, 24, 12, 25, 42, 0, ZoneOffset.UTC)));
        assertThat(parse.getValue(ObservedProperties.LONGITUDE), is(-3.871477));
        assertThat(parse.getValue(ObservedProperties.LATITUDE), is(35.664951));
        assertThat(parse.getValue(ObservedProperties.HEADING), is(112.5));
        assertThat(parse.getValue(ObservedProperties.SPEED), is(7.5));
        assertThat(parse.getValue(ObservedProperties.DEPTH), is(1366.2));
        assertThat(parse.getValue(ObservedProperties.COURSE_OVER_GROUND), is(112.03));
        assertThat(parse.getValue(ObservedProperties.SPEED_OVER_GROUND), is(7.5));

    }

    @Test
    public void testParseBel() throws DatagramParseException {
        final PositionDatagram parse = new PositionDatagram("$BELPOS,200312,071900,3.198552,51.335977,211.10001,,8.9,,0.041");

        assertThat(parse.getDateTime(), is(OffsetDateTime
                                                   .of(2020, 3, 12, 7, 19, 0, 0, ZoneOffset.UTC)));
        assertThat(parse.getValue(ObservedProperties.LONGITUDE), is(3.198552));
        assertThat(parse.getValue(ObservedProperties.LATITUDE), is(51.335977));
        assertThat(parse.getValue(ObservedProperties.HEADING), is(211.10001));
        assertThat(parse.getValue(ObservedProperties.SPEED), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.DEPTH), is(8.9));
        assertThat(parse.getValue(ObservedProperties.COURSE_OVER_GROUND), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.SPEED_OVER_GROUND), is(0.041));

    }
}