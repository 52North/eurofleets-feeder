package org.n52.emodnet.eurofleets.feeder.datagram;

import org.n52.emodnet.eurofleets.feeder.ObservedProperties;

public class MeteorologyDatagram extends Datagram {

    public MeteorologyDatagram(String value) throws DatagramParseException {
        super(value,
              ObservedProperties.WIND_MEAN,
              ObservedProperties.WIND_GUST,
              ObservedProperties.WIND_DIRECTION,
              ObservedProperties.AIR_TEMPERATURE,
              ObservedProperties.HUMIDITY,
              ObservedProperties.SOLAR_RADIATION,
              ObservedProperties.PRESSURE);
    }
}
