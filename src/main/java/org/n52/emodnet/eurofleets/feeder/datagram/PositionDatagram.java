package org.n52.emodnet.eurofleets.feeder.datagram;

import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

public class PositionDatagram extends Datagram {

    public PositionDatagram(String value) throws DatagramParseException {
        super(value,
              ObservedProperties.LONGITUDE,
              ObservedProperties.LATITUDE,
              ObservedProperties.HEADING,
              ObservedProperties.SPEED,
              ObservedProperties.DEPTH,
              ObservedProperties.COURSE_OVER_GROUND,
              ObservedProperties.SPEED_OVER_GROUND);
    }

}
