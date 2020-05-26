package org.n52.emodnet.eurofleets.feeder.datagram;

import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

public class NavigationDatagram extends Datagram {

    public NavigationDatagram(String value) throws DatagramParseException {
        super(value,
              ObservedProperties.HEADING,
              ObservedProperties.SPEED,
              ObservedProperties.DEPTH,
              ObservedProperties.COURSE_OVER_GROUND,
              ObservedProperties.SPEED_OVER_GROUND);
    }

}
