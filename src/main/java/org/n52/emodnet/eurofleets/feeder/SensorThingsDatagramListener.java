package org.n52.emodnet.eurofleets.feeder;

import org.locationtech.jts.geom.CoordinateXY;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.GeometryFactory;
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
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.stream.Stream;

@Service
public class SensorThingsDatagramListener implements DatagramListener {
    private static final Logger LOG = LoggerFactory.getLogger(SensorThingsDatagramListener.class);
    private final ThingRepository thingRepository;
    private final GeometryFactory geometryFactory;
    private final Datastreams ds;
    private final FeatureOfInterest featureOfInterest;
    private final SensorThingsApi sta;
    private final ReentrantReadWriteLock readWriteLock = new ReentrantReadWriteLock();
    private Point latestPoint;

    @Autowired
    public SensorThingsDatagramListener(ThingRepository thingRepository,
                                        GeometryFactory geometryFactory,
                                        SensorThingsApi sta) {
        this.thingRepository = Objects.requireNonNull(thingRepository);
        this.geometryFactory = Objects.requireNonNull(geometryFactory);
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

    private Observation createObservation(Datastream datastream, OffsetDateTime time, Number result) {
        readWriteLock.readLock().lock();
        try {
            Observation observation = new Observation();
            observation.setDatastream(datastream);
            observation.setFeatureOfInterest(featureOfInterest);
            observation.setParameters(Collections.singletonList(createLocationParameter()));
            observation.setPhenomenonTime(time);
            observation.setResultTime(time);
            observation.setResult(result);
            return observation;
        } finally {
            readWriteLock.readLock().unlock();
        }
    }

    private Parameter createLocationParameter() {
        return new Parameter(OmConstants.PARAM_NAME_SAMPLING_GEOMETRY, latestPoint);
    }

    private void publish(Location locationUpdate) {
        sta.create(locationUpdate);
    }

    private void publish(Stream<Observation> observations) {
        observations.peek(observation -> LOG.info("publishing observation {}", observation))
                    .forEach(sta::create);
    }

    @Override
    public void onDatagram(Datagram dg) {
        if (dg.hasValue(ObservedProperties.LONGITUDE) &&
            dg.hasValue(ObservedProperties.LATITUDE)) {
            readWriteLock.writeLock().lock();
            try {
                latestPoint = geometryFactory.createPoint(new CoordinateXY(
                        dg.getValue(ObservedProperties.LONGITUDE).doubleValue(),
                        dg.getValue(ObservedProperties.LATITUDE).doubleValue()));
                publish(createLocationUpdate(latestPoint));
            } finally {
                readWriteLock.writeLock().unlock();
            }
        }
        readWriteLock.readLock().lock();
        try {
            if (latestPoint == null) {
                LOG.warn("Did not yet receive any position, ignoring datagram {}", dg);
                return;
            }

            publish(dg.getObservedProperties().stream()
                      .filter(dg::hasValue)
                      .map(op -> createObservation(ds.get(op), dg.getDateTime(), dg.getValue(op))));
        } finally {
            readWriteLock.readLock().unlock();
        }

    }
}
