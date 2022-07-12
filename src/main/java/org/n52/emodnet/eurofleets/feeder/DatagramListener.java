package org.n52.emodnet.eurofleets.feeder;

import org.n52.emodnet.eurofleets.feeder.datagram.Datagram;

@FunctionalInterface
public interface DatagramListener {
    void onDatagram(Datagram value);
}