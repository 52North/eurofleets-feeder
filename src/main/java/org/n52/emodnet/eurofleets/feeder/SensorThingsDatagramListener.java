package org.n52.emodnet.eurofleets.feeder;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Geometry;
import org.locationtech.jts.geom.Point;
import org.n52.emodnet.eurofleets.feeder.datagram.Datagram;
import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.Feature;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.Location;
import org.n52.emodnet.eurofleets.feeder.model.Observation;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
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
import java.util.stream.Stream;

@Service
public class SensorThingsDatagramListener implements DatagramListener {
    private static final Logger LOG = LoggerFactory.getLogger(SensorThingsDatagramListener.class);
    private final ThingRepository thingRepository;
    private final Datastreams datastreams;
    private final SensorThingsApi sta;
    private final Lock lock = new ReentrantLock();
    private Point latestPoint;

    @Autowired
    public SensorThingsDatagramListener(ThingRepository thingRepository, SensorThingsApi sta) {
        this.thingRepository = Objects.requireNonNull(thingRepository);
        this.sta = Objects.requireNonNull(sta);
        this.datastreams = thingRepository.getDatastreams();
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
        observation.setFeatureOfInterest(thingRepository.getFeatureOfInterest());
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
    public void onDatagram(Datagram datagram) {
        boolean includeLocation = false;
        lock.lock();
        try {
            Point position = datagram.getGeometry();
            includeLocation = latestPoint == null || !position.equalsExact(latestPoint);
            if (includeLocation) {
                latestPoint = position;
                LOG.info("publishing location {}", latestPoint);
                sta.create(createLocationUpdate(latestPoint));
            }
        } finally {
            lock.unlock();
        }

        Stream<Observation> observationStream = datagram.getObservedProperties().stream()
                                                        .filter(datagram::hasValue)
                                                        .map(observedProperty -> createObservation(datagram,
                                                                                                   observedProperty));

        Stream.concat(includeLocation ? createLocationObservations(datagram) : Stream.empty(), observationStream)
              .peek(observation -> LOG.info("publishing observation {}", observation))
              .forEach(sta::create);
    }

    private Observation createObservation(Datagram datagram, ObservedProperty observedProperty) {
        Datastream datastream = datastreams.get(observedProperty);
        Number value = datagram.getValue(observedProperty);
        OffsetDateTime time = datagram.getDateTime();
        return createObservation(datastream, time, datagram.getGeometry(), value);
    }

    private Stream<Observation> createLocationObservations(Datagram dg) {
        Point geometry = dg.getGeometry();
        OffsetDateTime time = dg.getDateTime();
        Coordinate coordinate = geometry.getCoordinate();
        Datastream lonDatastream = datastreams.get(ObservedProperties.LONGITUDE);
        Datastream latDatastream = datastreams.get(ObservedProperties.LATITUDE);
        Observation lon = createObservation(lonDatastream, time, geometry, coordinate.getX());
        Observation lat = createObservation(latDatastream, time, geometry, coordinate.getY());
        return Stream.of(lon, lat);
    }

}
