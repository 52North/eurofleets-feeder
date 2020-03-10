package org.n52.emodnet.eurofleets.feeder.datagram;

import org.junit.jupiter.api.Test;
import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

class PositionDatagramTest {
    @Test
    public void testParse() throws DatagramParseException {
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
}