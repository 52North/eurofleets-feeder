package org.n52.emodnet.eurofleets.feeder;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.CoordinateXY;
import org.locationtech.jts.geom.GeometryFactory;
import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.Feature;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.Sensor;
import org.n52.emodnet.eurofleets.feeder.model.Thing;
import org.n52.emodnet.eurofleets.feeder.sta.SensorThingsApi;
import org.n52.shetland.ogc.om.OmConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.net.URL;
import java.time.Duration;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.temporal.IsoFields;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@Component
public class ThingRepository {
    private static final String TIME_ZONE = "UTC";
    private static final ZoneId TIME_ZONE_ID = ZoneId.of(TIME_ZONE);
    private static final String UPDATE_FOI_PROPERTY = "updateFOI";
    private static final String IS_MOBILE = "isMobile";
    private static final String APPLICATION_VND_GEO_JSON = "application/vnd.geo+json";
    private final ReadWriteLock lock = new ReentrantReadWriteLock();
    private final ThingConfiguration thingConfiguration;
    private final GeometryFactory geometryFactory;
    private final SensorThingsApi sta;
    private Thing thing;
    private Sensor sensor;
    private Datastreams datastreams;
    private FeatureOfInterest featureOfInterest;

    @Autowired
    public ThingRepository(ThingConfiguration thingConfiguration, SensorThingsApi sta,
                           GeometryFactory geometryFactory) {
        this.thingConfiguration = Objects.requireNonNull(thingConfiguration);
        this.sta = Objects.requireNonNull(sta);
        this.geometryFactory = Objects.requireNonNull(geometryFactory);
    }

    public Datastreams getDatastreams() {
        lock.readLock().lock();
        try {
            return datastreams;
        } finally {
            lock.readLock().unlock();
        }
    }

    @PostConstruct
    public void init() {
        lock.writeLock().lock();
        try {
            createObservedProperties();
            thing = createThing();
            sensor = createSensor(thing);
            featureOfInterest = createFeatureOfInterest(thing);
            datastreams = createDatastreams(thing, sensor);
        } finally {
            lock.writeLock().unlock();
        }
    }

    private void createObservedProperties() {
        lock.writeLock().lock();
        try {
            ObservedProperties.ALL.forEach(sta::create);
        } finally {
            lock.writeLock().unlock();
        }
    }

    private Datastreams createDatastreams(Thing thing, Sensor sensor) {
        lock.writeLock().lock();
        try {
            return new Datastreams(ObservedProperties.ALL.stream()
                                                         .map(op -> createDatastream(thing, sensor, op))
                                                         .peek(sta::create)
                                                         .toArray(Datastream[]::new));
        } finally {
            lock.writeLock().unlock();
        }
    }

    private Sensor createSensor(Thing thing) {
        lock.writeLock().lock();
        try {
            Sensor sensor = new Sensor();
            sensor.setId(thing.getId());
            sensor.setDescription(thing.getDescription());
            sensor.setName(thing.getName());
            sensor.setMetadata(Optional.ofNullable(thingConfiguration.getMetadata()).map(URL::toExternalForm)
                                       .orElse(""));
            sensor.setEncodingType(thingConfiguration.getMetadataType());
            sta.create(sensor);
            return sensor;
        } finally {
            lock.writeLock().unlock();
        }
    }

    private Datastream createDatastream(Thing thing, Sensor sensor, ObservedProperty observedProperty) {
        lock.writeLock().lock();
        try {
            Datastream datastream = new Datastream();
            datastream.setObservationType(OmConstants.OBS_TYPE_MEASUREMENT);
            datastream.setObservedProperty(observedProperty);
            datastream.setUnitOfMeasurement(ObservedProperties.UNITS.get(observedProperty));
            datastream.setSensor(sensor);
            datastream.setThing(thing);

            double[] observedArea = thingConfiguration.getObservedArea();
            if (observedArea != null && observedArea.length > 0) {
                datastream.setObservedArea(geometryFactory.createPolygon(new Coordinate[]{
                        new CoordinateXY(observedArea[0], observedArea[1]),
                        new CoordinateXY(observedArea[2], observedArea[1]),
                        new CoordinateXY(observedArea[2], observedArea[3]),
                        new CoordinateXY(observedArea[0], observedArea[3]),
                        new CoordinateXY(observedArea[0], observedArea[1])
                }));
            }

            datastream.setId(String.format("%s_%s", thing.getId(), observedProperty.getId()));
            datastream.setName(observedProperty.getName());
            datastream.setDescription(String.format("%s measured by the %s", observedProperty
                                                                                     .getName(), thing.getName()));
            return datastream;
        } finally {
            lock.writeLock().unlock();
        }
    }

    private Thing createThing() {
        lock.writeLock().lock();
        try {
            Thing thing = new Thing();
            thing.setId(thingConfiguration.getId());
            thing.setName(thingConfiguration.getName());
            thing.setDescription(thingConfiguration.getDescription());
            thing.setProperties(createProperties(null));
            sta.create(thing);
            return thing;
        } finally {
            lock.writeLock().unlock();
        }
    }

    public Sensor getSensor() {
        lock.readLock().lock();
        try {
            return sensor;
        } finally {
            lock.readLock().unlock();
        }
    }

    public Thing getThing() {
        lock.readLock().lock();
        try {
            return thing;
        } finally {
            lock.readLock().unlock();
        }
    }

    public FeatureOfInterest getFeatureOfInterest() {
        lock.readLock().lock();
        try {
            return featureOfInterest;
        } finally {
            lock.readLock().unlock();
        }
    }

    private FeatureOfInterest createFeatureOfInterest(Thing thing) {
        lock.writeLock().lock();
        try {
            FeatureOfInterest featureOfInterest = new FeatureOfInterest();
            OffsetDateTime now = OffsetDateTime.now(TIME_ZONE_ID);
            int year = now.get(IsoFields.WEEK_BASED_YEAR);
            int week = now.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
            featureOfInterest.setId(getFeatureOfInterestId(thing, year, week));
            featureOfInterest.setName(getFeatureOfInterestName(thing, year, week));
            featureOfInterest.setDescription(thing.getDescription());
            featureOfInterest.setEncodingType(APPLICATION_VND_GEO_JSON);
            featureOfInterest.setFeature(createEmptyFeature());
            this.sta.create(featureOfInterest);
            updateThingWithFeatureId(thing, featureOfInterest);
            return featureOfInterest;
        } finally {
            lock.writeLock().unlock();
        }
    }

    private String getFeatureOfInterestName(Thing thing, int year, int week) {
        return String.format("%s in week %d of %4d", thing.getName(), week, year);
    }

    private String getFeatureOfInterestId(Thing thing, int year, int week) {
        return String.format("%s-%4d-%2d", thing.getId(), year, week);
    }

    private Feature createEmptyFeature() {
        Feature feature = new Feature();
        feature.setGeometry(geometryFactory.createLineString());
        return feature;
    }

    /**
     * Create a new feature of interest on week changes.
     */
    @Scheduled(cron = "1 0 0 * * *", zone = TIME_ZONE)
    public void updateFeature() {
        if (isNewWeek()) {
            lock.writeLock().lock();
            try {
                this.featureOfInterest = createFeatureOfInterest(thing);
            } finally {
                lock.writeLock().unlock();
            }
        }
    }

    private void updateThingWithFeatureId(Thing thing, FeatureOfInterest featureOfInterest) {
        lock.writeLock().lock();
        try {
            Thing update = new Thing();
            update.setProperties(createProperties(featureOfInterest));
            sta.update(thing.getId(), update);
        } finally {
            lock.writeLock().unlock();
        }
    }

    private Map<String, Object> createProperties(FeatureOfInterest featureOfInterest) {
        Map<String, Object> properties = new HashMap<>();
        if (featureOfInterest != null) {
            properties.put(UPDATE_FOI_PROPERTY, featureOfInterest.getId());
        }
        properties.put(IS_MOBILE, true);
        return properties;
    }

    private boolean isNewWeek() {
        OffsetDateTime today = OffsetDateTime.now(TIME_ZONE_ID);
        OffsetDateTime yesterday = today.minus(Duration.parse("PT12H"));
        return today.get(IsoFields.WEEK_BASED_YEAR) != yesterday.get(IsoFields.WEEK_BASED_YEAR) ||
               today.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR) != yesterday.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
    }
}
