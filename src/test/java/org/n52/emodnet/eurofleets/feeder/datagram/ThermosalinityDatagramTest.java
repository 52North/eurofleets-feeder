package org.n52.emodnet.eurofleets.feeder.datagram;

import org.junit.jupiter.api.Test;
import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;

class ThermosalinityDatagramTest {

    @Test
    public void testParse() throws DatagramParseException {
        final ThermosalinityDatagram parse = new ThermosalinityDatagram(" $PSDGTSS,20160524,001332,20.4955,35.7082,25.171204,49.298992,1.150183,9999.9004");

        assertThat(parse.getDateTime(), is(OffsetDateTime
                                                   .of(2016, 5, 24, 0, 13, 32, 0, ZoneOffset.UTC)));
        assertThat(parse.getValue(ObservedProperties.SALINITY), is(20.4955));
        assertThat(parse.getValue(ObservedProperties.WATER_TEMPERATURE), is(35.7082));
        assertThat(parse.getValue(ObservedProperties.RAW_FLUOROMETRY), is(25.171204));
        assertThat(parse.getValue(ObservedProperties.CONDUCTIVITY), is(49.298992));
        assertThat(parse.getValue(ObservedProperties.DENSITY), is(1.150183));

    }
}