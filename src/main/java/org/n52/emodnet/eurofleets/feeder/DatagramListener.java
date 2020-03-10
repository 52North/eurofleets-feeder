package org.n52.emodnet.eurofleets.feeder;

import org.n52.emodnet.eurofleets.feeder.datagram.Datagram;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Objects;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingDeque;

public interface DatagramListener {
    void onDatagram(Datagram value);
}