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
import org.n52.emodnet.eurofleets.feeder.model.UnitOfMeasurement;
import org.n52.emodnet.eurofleets.feeder.sta.FeatureOfInterestCreator;
import org.n52.emodnet.eurofleets.feeder.sta.ObservedPropertyCreator;
import org.n52.emodnet.eurofleets.feeder.sta.SensorCreator;
import org.n52.emodnet.eurofleets.feeder.sta.ThingCreator;
import org.n52.emodnet.eurofleets.feeder.sta.ThingUpdater;
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
import java.util.Collections;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@Component
public class ThingRepository {
    private static final String TIME_ZONE = "UTC";
    private static final ZoneId TIME_ZONE_ID = ZoneId.of(TIME_ZONE);
    private static final String UPDATE_FOI_PROPERTY = "updateFOI";
    private static final String APPLICATION_VND_GEO_JSON = "application/vnd.geo+json";
    private final ThingConfiguration thingConfiguration;
    private final ThingCreator thingCreator;
    private final FeatureOfInterestCreator featureOfInterestCreator;
    private final ThingUpdater thingUpdater;
    private final SensorCreator sensorCreator;
    private final ObservedPropertyCreator observedPropertyCreator;
    private final GeometryFactory geometryFactory;
    private final ReadWriteLock lock = new ReentrantReadWriteLock();
    private Thing thing;
    private Sensor sensor;
    private Datastreams datastreams;
    private FeatureOfInterest featureOfInterest;

    @Autowired
    public ThingRepository(ThingConfiguration thingConfiguration,
                           ThingCreator thingCreator,
                           FeatureOfInterestCreator featureOfInterestCreator,
                           ThingUpdater thingUpdater,
                           SensorCreator sensorCreator,
                           ObservedPropertyCreator observedPropertyCreator,
                           GeometryFactory geometryFactory) {
        this.thingConfiguration = Objects.requireNonNull(thingConfiguration);
        this.thingCreator = Objects.requireNonNull(thingCreator);
        this.featureOfInterestCreator = Objects.requireNonNull(featureOfInterestCreator);
        this.thingUpdater = Objects.requireNonNull(thingUpdater);
        this.sensorCreator = Objects.requireNonNull(sensorCreator);
        this.observedPropertyCreator = Objects.requireNonNull(observedPropertyCreator);
        this.geometryFactory = Objects.requireNonNull(geometryFactory);
    }

    public Datastreams getDatastreams() {
        return datastreams;
    }

    @PostConstruct
    public void init() {
        lock.writeLock().lock();
        try {
            thing = createThing();
            sensor = createSensor(thing);
            sensorCreator.create(sensor);
            datastreams = createDatastreams(thing, sensor);

            ObservedProperties.ALL.forEach(observedPropertyCreator::create);

            thing.setDatastreams(datastreams.all());
            featureOfInterest = createFeatureOfInterest(thing);
            featureOfInterestCreator.create(featureOfInterest);
            thing.setProperties(Collections.singletonMap(UPDATE_FOI_PROPERTY, featureOfInterest.getId()));
            thingCreator.create(thing);
        } finally {
            lock.writeLock().unlock();
        }
    }

    private Datastreams createDatastreams(Thing thing, Sensor sensor) {
        return new Datastreams(ObservedProperties.ALL.stream()
                                                     .map(op -> createDatastream(thing, sensor, op,
                                                                                 ObservedProperties.UNITS.get(op)))
                                                     .toArray(Datastream[]::new));
    }

    private Sensor createSensor(Thing thing) {
        Sensor sensor = new Sensor();
        sensor.setId(thing.getId());
        sensor.setDescription(thing.getDescription());
        sensor.setName(thing.getName());
        sensor.setMetadata(Optional.ofNullable(thingConfiguration.getMetadata()).map(URL::toExternalForm).orElse(""));
        sensor.setEncodingType(thingConfiguration.getMetadataType());
        return sensor;
    }

    /*
        private Sensor createSensor(Thing thing, ObservedProperty observedProperty) {
            Sensor sensor = new Sensor();
            sensor.setId(String.format("%s_%s", thing.getId(), observedProperty.getId()));
            sensor.setDescription(String.format("Sensor for %s of %s", observedProperty.getName(), thing.getName()));
            sensor.setName(String.format("%s Sensor", observedProperty.getName()));
            sensor.setMetadata(thingConfiguration.getMetadata().toExternalForm());
            sensor.setEncodingType(thingConfiguration.getMetadataType());
            return sensor;
        }
    */
    private Datastream createDatastream(Thing thing, Sensor sensor, ObservedProperty property, UnitOfMeasurement uom) {
        Datastream datastream = new Datastream();
        datastream.setObservationType(OmConstants.OBS_TYPE_MEASUREMENT);
        datastream.setObservedProperty(property);
        datastream.setUnitOfMeasurement(uom);
        datastream.setSensor(sensor);

        double[] observedArea = thingConfiguration.getObservedArea();

        datastream.setObservedArea(geometryFactory.createPolygon(new Coordinate[]{
                new CoordinateXY(observedArea[0], observedArea[1]),
                new CoordinateXY(observedArea[2], observedArea[1]),
                new CoordinateXY(observedArea[2], observedArea[3]),
                new CoordinateXY(observedArea[0], observedArea[3]),
                new CoordinateXY(observedArea[0], observedArea[1])
        }));

        datastream.setId(String.format("%s_%s", thing.getId(), property.getId()));
        datastream.setName(property.getName());
        datastream.setDescription(String.format("%s measured by the %s", property.getName(), thing.getName()));
        return datastream;
    }

    private Thing createThing() {
        Thing thing = new Thing();
        thing.setId(thingConfiguration.getId());
        thing.setName(thingConfiguration.getName());
        thing.setDescription(thingConfiguration.getDescription());
        thing.setProperties(Collections.singletonMap("updateFOI", "foiName"));
        return thing;
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
        FeatureOfInterest featureOfInterest = new FeatureOfInterest();
        OffsetDateTime now = OffsetDateTime.now(TIME_ZONE_ID);
        int year = now.get(IsoFields.WEEK_BASED_YEAR);
        int week = now.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
        featureOfInterest.setId(getFeatureOfInterestId(thing, year, week));
        featureOfInterest.setName(getFeatureOfInterestName(thing, year, week));
        featureOfInterest.setDescription(thing.getDescription());
        featureOfInterest.setEncodingType(APPLICATION_VND_GEO_JSON);
        featureOfInterest.setFeature(createEmptyFeature());
        return featureOfInterest;
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
                this.featureOfInterestCreator.create(featureOfInterest);
                this.thing.setProperties(Collections.singletonMap(UPDATE_FOI_PROPERTY, this.featureOfInterest.getId()));
                Thing update = new Thing();
                update.setProperties(thing.getProperties());
                thingUpdater.update(thing.getId(), update);
            } finally {
                lock.writeLock().unlock();
            }
        }
    }

    private boolean isNewWeek() {
        OffsetDateTime today = OffsetDateTime.now(TIME_ZONE_ID);
        OffsetDateTime yesterday = today.minus(Duration.parse("PT12H"));
        return today.get(IsoFields.WEEK_BASED_YEAR) != yesterday.get(IsoFields.WEEK_BASED_YEAR) ||
               today.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR) != yesterday.get(IsoFields.WEEK_OF_WEEK_BASED_YEAR);
    }
}
