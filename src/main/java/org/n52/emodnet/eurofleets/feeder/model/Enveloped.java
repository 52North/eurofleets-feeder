package org.n52.emodnet.eurofleets.feeder.model;

import org.locationtech.jts.geom.Envelope;

public interface Enveloped {
    Envelope getEnvelope();
}
