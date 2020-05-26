package org.n52.emodnet.eurofleets.feeder;

import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.Point;
import org.n52.emodnet.eurofleets.feeder.datagram.Datagram;
import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.Feature;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.Location;
import org.n52.emodnet.eurofleets.feeder.model.Observation;
import org.n52.emodnet.eurofleets.feeder.model.Parameter;
import org.n52.emodnet.eurofleets.feeder.model.Thing;
import org.n52.emodnet.eurofleets.feeder.sta.SensorThingsApi;
import org.n52.shetland.ogc.om.OmConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.Collections;
import java.util.Objects;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@Service
public class SensorThingsDatagramListener implements DatagramListener {
    private static final Logger LOG = LoggerFactory.getLogger(SensorThingsDatagramListener.class);
    private final ThingRepository thingRepository;
    private final Datastreams ds;
    private final FeatureOfInterest featureOfInterest;
    private final SensorThingsApi sta;
    private final Lock lock = new ReentrantLock();
    private Point latestPoint;

    @Autowired
    public SensorThingsDatagramListener(ThingRepository thingRepository, SensorThingsApi sta) {
        this.thingRepository = Objects.requireNonNull(thingRepository);
        this.sta = Objects.requireNonNull(sta);
        this.ds = thingRepository.getDatastreams();
        this.featureOfInterest = thingRepository.getFeatureOfInterest();
    }

    private Location createLocationUpdate(Geometry geometry) {
        Thing thing = this.thingRepository.getThing();
        Location location = new Location();
        location.setName(String.format("Location of %s", thing.getName()));
        location.setDescription(String.format("Location of %s", thing.getName()));
        location.setThings(Collections.singletonList(thing));
        location.setEncodingType("application/vnd.geo+json");
        Feature feature = new Feature();
        feature.setGeometry(geometry);
        location.setLocation(feature);
        return location;
    }

    private Observation createObservation(Datastream datastream, OffsetDateTime time, Point geometry, Number result) {
        Observation observation = new Observation();
        observation.setDatastream(datastream);
        observation.setFeatureOfInterest(featureOfInterest);
        observation.setParameters(Collections.singletonList(createLocationParameter(geometry)));
        observation.setPhenomenonTime(time);
        observation.setResultTime(time);
        observation.setResult(result);
        return observation;
    }

    private Parameter createLocationParameter(Point geometry) {
        return new Parameter(OmConstants.PARAM_NAME_SAMPLING_GEOMETRY, geometry);
    }

    @Override
    public void onDatagram(Datagram dg) {

        lock.lock();
        try {
            Point position = dg.getGeometry();
            if (!position.equalsExact(latestPoint)) {
                latestPoint = position;
                LOG.info("publishing location {}", latestPoint);
                sta.create(createLocationUpdate(latestPoint));
            }
        } finally {
            lock.unlock();
        }
        dg.getObservedProperties().stream().filter(dg::hasValue)
          .map(op -> createObservation(ds.get(op), dg.getDateTime(), dg.getGeometry(), dg.getValue(op)))
          .peek(observation -> LOG.info("publishing observation {}", observation))
          .forEach(sta::create);
    }

}
