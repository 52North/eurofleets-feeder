package org.n52.emodnet.eurofleets.feeder.datagram;

import org.junit.jupiter.api.Test;
import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.nullValue;

class ThermosalinityDatagramTest {

    @Test
    public void testParsePsd() throws DatagramParseException {
        final ThermosalinityDatagram parse = new ThermosalinityDatagram(" $PSDGTSS,20160524,001332,20.4955,35.7082,25.171204,49.298992,1.150183,9999.9004");

        assertThat(parse.getDateTime(), is(OffsetDateTime
                                                   .of(2016, 5, 24, 0, 13, 32, 0, ZoneOffset.UTC)));
        assertThat(parse.getValue(ObservedProperties.SALINITY), is(20.4955));
        assertThat(parse.getValue(ObservedProperties.WATER_TEMPERATURE), is(35.7082));
        assertThat(parse.getValue(ObservedProperties.RAW_FLUOROMETRY), is(25.171204));
        assertThat(parse.getValue(ObservedProperties.CONDUCTIVITY), is(49.298992));
        assertThat(parse.getValue(ObservedProperties.DENSITY), is(1.150183));
    }

    @Test
    public void testParseBel() throws DatagramParseException {
        final ThermosalinityDatagram parse = new ThermosalinityDatagram("$BELTSS,200311,044500,28.885399,8.032499,,30.746801,22.471699");

        assertThat(parse.getDateTime(), is(OffsetDateTime.of(2020, 3, 11, 4, 45, 0, 0, ZoneOffset.UTC)));
        assertThat(parse.getValue(ObservedProperties.SALINITY), is(28.885399));
        assertThat(parse.getValue(ObservedProperties.WATER_TEMPERATURE), is(8.032499));
        assertThat(parse.getValue(ObservedProperties.RAW_FLUOROMETRY), is(nullValue()));
        assertThat(parse.getValue(ObservedProperties.CONDUCTIVITY), is(30.746801));
        assertThat(parse.getValue(ObservedProperties.DENSITY), is(22.471699));
    }
}