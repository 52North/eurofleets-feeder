package org.n52.emodnet.eurofleets.feeder.datagram;

import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

public class ThermosalinityDatagram extends Datagram {

    public ThermosalinityDatagram(String value) throws DatagramParseException {
        super(value,
              ObservedProperties.SALINITY,
              ObservedProperties.WATER_TEMPERATURE,
              ObservedProperties.RAW_FLUOROMETRY,
              ObservedProperties.CONDUCTIVITY,
              ObservedProperties.DENSITY);
    }

}
