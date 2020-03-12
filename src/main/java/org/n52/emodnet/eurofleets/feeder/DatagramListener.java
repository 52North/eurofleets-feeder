package org.n52.emodnet.eurofleets.feeder;

import org.n52.emodnet.eurofleets.feeder.datagram.Datagram;

public interface DatagramListener {
    void onDatagram(Datagram value);
}