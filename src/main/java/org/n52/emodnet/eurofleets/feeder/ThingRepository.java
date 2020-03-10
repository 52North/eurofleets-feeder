package org.n52.emodnet.eurofleets.feeder;

import com.google.common.collect.ImmutableMap;
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
import org.n52.emodnet.eurofleets.feeder.sta.ThingCreator;
import org.n52.shetland.ogc.om.OmConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.Collections;
import java.util.Objects;

@Component
public class ThingRepository {
    private final ThingConfiguration thingConfiguration;
    private final ThingCreator thingCreator;
    private final FeatureOfInterestCreator featureOfInterestCreator;
    private Thing thing;
    private Datastreams datastreams;
    private FeatureOfInterest featureOfInterest;
    private final GeometryFactory geometryFactory;

    @Autowired
    public ThingRepository(ThingConfiguration thingConfiguration,
                           ThingCreator thingCreator,
                           FeatureOfInterestCreator featureOfInterestCreator,
                           GeometryFactory geometryFactory) {
        this.thingConfiguration = Objects.requireNonNull(thingConfiguration);
        this.thingCreator = Objects.requireNonNull(thingCreator);
        this.featureOfInterestCreator = Objects.requireNonNull(featureOfInterestCreator);
        this.geometryFactory = Objects.requireNonNull(geometryFactory);
    }

    public Datastreams getDatastreams() {
        return datastreams;
    }

    @PostConstruct
    public void init() {
        thing = createThing();
        datastreams = createDatastreams();
        thing.setDatastreams(datastreams.all());
        featureOfInterest = createFeatureOfInterest();
        featureOfInterestCreator.create(featureOfInterest);
        thing.setProperties(Collections.singletonMap("updateFOI", featureOfInterest.getId()));
        thingCreator.create(thing);

    }



    private Datastreams createDatastreams() {

        return new Datastreams(createDatastream(thing, ObservedProperties.LONGITUDE, Units.DEGREES),
                               createDatastream(thing, ObservedProperties.LATITUDE, Units.DEGREES),
                               createDatastream(thing, ObservedProperties.HEADING, Units.DEGREES),
                               createDatastream(thing, ObservedProperties.SPEED, Units.KNOTS),
                               createDatastream(thing, ObservedProperties.DEPTH, Units.METRES),
                               createDatastream(thing, ObservedProperties.WIND_MEAN, Units.METRES_PER_SECOND),
                               createDatastream(thing, ObservedProperties.SPEED_OVER_GROUND, Units.KNOTS),
                               createDatastream(thing, ObservedProperties.COURSE_OVER_GROUND, Units.DEGREES),
                               createDatastream(thing, ObservedProperties.WIND_GUST, Units.METRES_PER_SECOND),
                               createDatastream(thing, ObservedProperties.WIND_DIRECTION, Units.DEGREES),
                               createDatastream(thing, ObservedProperties.AIR_TEMPERATURE, Units.DEGREES_CELSIUS),
                               createDatastream(thing, ObservedProperties.HUMIDITY, Units.PERCENT),
                               createDatastream(thing, ObservedProperties.SOLAR_RADIATION, Units.WATTS_PER_SQUARE_METRE),
                               createDatastream(thing, ObservedProperties.PRESSURE, Units.HECTOPASCALS),
                               createDatastream(thing, ObservedProperties.WATER_TEMPERATURE, Units.DEGREES_CELSIUS),
                               createDatastream(thing, ObservedProperties.SALINITY, Units.PSU),
                               createDatastream(thing, ObservedProperties.RAW_FLUOROMETRY, Units.VOLTS),
                               createDatastream(thing, ObservedProperties.CONDUCTIVITY, Units.SIEMENS_PER_METRE),
                               createDatastream(thing, ObservedProperties.DENSITY, Units.KILOGRAMS_PER_CUBIC_METRE));
    }

    private Sensor createSensor(Thing thing, ObservedProperty observedProperty) {
        Sensor sensor = new Sensor();
        sensor.setId(String.format("%s_%s", thing.getId(), observedProperty.getId()));
        sensor.setDescription(String.format("Sensor for %s of %s", observedProperty.getName(), thing.getName()));
        sensor.setName(String.format("%s Sensor", observedProperty.getName()));
        String sensorMetadata = "sensorMetadata";
        String sensorEncodingType = "http://www.opengis.net/doc/IS/SensorML/2.0";
        sensor.setMetadata(sensorMetadata);
        sensor.setEncodingType(sensorEncodingType);
        return sensor;
    }

    private Datastream createDatastream(Thing thing, ObservedProperty property, UnitOfMeasurement uom) {
        Datastream datastream = new Datastream();
        datastream.setObservationType(OmConstants.OBS_TYPE_MEASUREMENT);
        datastream.setObservedProperty(property);
        datastream.setUnitOfMeasurement(uom);
        datastream.setSensor(createSensor(thing, property));

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

    public Thing getThing() {
        return thing;
    }

    public FeatureOfInterest getFeatureOfInterest() {
        return featureOfInterest;
    }

    private FeatureOfInterest createFeatureOfInterest() {
        FeatureOfInterest featureOfInterest = new FeatureOfInterest();
        Feature feature = new Feature();
        feature.setGeometry(geometryFactory.createLineString());
        featureOfInterest.setId(thing.getId());
        featureOfInterest.setName(thing.getName());
        featureOfInterest.setDescription(thing.getDescription());
        featureOfInterest.setEncodingType("application/vnd.geo+json");
        featureOfInterest.setFeature(feature);
        return featureOfInterest;

    }

}
