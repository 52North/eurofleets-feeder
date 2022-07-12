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
    public static final String OBS_TYPE_SENSOR_ML = "http://www.52north.org/def/observationType/OGC-OM/2.0/OM_SensorML20Observation";
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
        this.lock.readLock().lock();
        try {
            return this.datastreams;
        } finally {
            this.lock.readLock().unlock();
        }
    }

    @PostConstruct
    public void init() {
        this.lock.writeLock().lock();
        try {
            createObservedProperties();
            this.thing = createThing();
            this.sensor = createSensor(this.thing);
            this.featureOfInterest = createFeatureOfInterest(this.thing);
            this.datastreams = createDatastreams(this.thing, this.sensor);
        } finally {
            this.lock.writeLock().unlock();
        }
    }

    private void createObservedProperties() {
        this.lock.writeLock().lock();
        try {
            ObservedProperties.ALL.forEach(this.sta::create);
        } finally {
            this.lock.writeLock().unlock();
        }
    }

    private Datastreams createDatastreams(Thing thing, Sensor sensor) {
        this.lock.writeLock().lock();
        try {
            return new Datastreams(ObservedProperties.ALL.stream().map(op -> {
                String observationType = op == ObservedProperties.EVENTS ? OBS_TYPE_SENSOR_ML
                                                                         : OmConstants.OBS_TYPE_MEASUREMENT;
                return createDatastream(thing, sensor, op, observationType);
            }).peek(this.sta::create).toArray(Datastream[]::new));
        } finally {
            this.lock.writeLock().unlock();
        }
    }

    private Sensor createSensor(Thing thing) {
        this.lock.writeLock().lock();
        try {
            Sensor sensor = new Sensor();
            sensor.setId(thing.getId());
            sensor.setDescription(thing.getDescription());
            sensor.setName(thing.getName());
            sensor.setMetadata(Optional.ofNullable(this.thingConfiguration.getMetadata()).map(URL::toExternalForm)
                                       .orElse(""));
            sensor.setEncodingType(this.thingConfiguration.getMetadataType());
            this.sta.create(sensor);
            return sensor;
        } finally {
            this.lock.writeLock().unlock();
        }
    }

    private Datastream createDatastream(Thing thing, Sensor sensor, ObservedProperty observedProperty,
                                        String observationType) {
        this.lock.writeLock().lock();
        try {
            Datastream datastream = new Datastream();
            datastream.setObservationType(observationType);
            datastream.setObservedProperty(observedProperty);
            datastream.setUnitOfMeasurement(ObservedProperties.UNITS.get(observedProperty));
            datastream.setSensor(sensor);
            datastream.setThing(thing);

            double[] observedArea = this.thingConfiguration.getObservedArea();
            if (observedArea != null && observedArea.length > 0) {
                Coordinate[] coordinates = {new CoordinateXY(observedArea[0], observedArea[1]),
                                            new CoordinateXY(observedArea[2], observedArea[1]),
                                            new CoordinateXY(observedArea[2], observedArea[3]),
                                            new CoordinateXY(observedArea[0], observedArea[3]),
                                            new CoordinateXY(observedArea[0], observedArea[1])};
                datastream.setObservedArea(this.geometryFactory.createPolygon(coordinates));
            }

            datastream.setId(String.format("%s_%s", thing.getId(), observedProperty.getId()));
            datastream.setName(observedProperty.getName());
            datastream.setDescription(String.format("%s measured by the %s", observedProperty.getName(), thing.getName()));
            return datastream;
        } finally {
            this.lock.writeLock().unlock();
        }
    }

    private Thing createThing() {
        this.lock.writeLock().lock();
        try {
            Thing thing = new Thing();
            thing.setId(this.thingConfiguration.getId());
            thing.setName(this.thingConfiguration.getName());
            thing.setDescription(this.thingConfiguration.getDescription());
            thing.setProperties(createProperties(null));
            this.sta.create(thing);
            return thing;
        } finally {
            this.lock.writeLock().unlock();
        }
    }

    public Sensor getSensor() {
        this.lock.readLock().lock();
        try {
            return this.sensor;
        } finally {
            this.lock.readLock().unlock();
        }
    }

    public Thing getThing() {
        this.lock.readLock().lock();
        try {
            return this.thing;
        } finally {
            this.lock.readLock().unlock();
        }
    }

    public FeatureOfInterest getFeatureOfInterest() {
        this.lock.readLock().lock();
        try {
            return this.featureOfInterest;
        } finally {
            this.lock.readLock().unlock();
        }
    }

    private FeatureOfInterest createFeatureOfInterest(Thing thing) {
        this.lock.writeLock().lock();
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
            this.lock.writeLock().unlock();
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
        feature.setGeometry(this.geometryFactory.createLineString());
        return feature;
    }

    /**
     * Create a new feature of interest on week changes.
     */
    @Scheduled(cron = "1 0 0 * * *", zone = TIME_ZONE)
    public void updateFeature() {
        if (isNewWeek()) {
            this.lock.writeLock().lock();
            try {
                this.featureOfInterest = createFeatureOfInterest(this.thing);
            } finally {
                this.lock.writeLock().unlock();
            }
        }
    }

    private void updateThingWithFeatureId(Thing thing, FeatureOfInterest featureOfInterest) {
        this.lock.writeLock().lock();
        try {
            Thing update = new Thing();
            update.setProperties(createProperties(featureOfInterest));
            this.sta.update(thing.getId(), update);
        } finally {
            this.lock.writeLock().unlock();
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
        return today.get(IsoFields.WEEK_BASED_YEAR) != yesterday.get(IsoFields.WEEK_BASED_YEAR) || today.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR) != yesterday.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
    }
}
