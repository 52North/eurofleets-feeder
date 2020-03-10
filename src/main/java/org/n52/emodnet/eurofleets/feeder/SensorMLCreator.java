package org.n52.emodnet.eurofleets.feeder;

import org.apache.xmlbeans.XmlCursor;
import org.apache.xmlbeans.XmlObject;
import org.apache.xmlbeans.XmlOptions;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.UnitOfMeasurement;
import org.n52.shetland.ogc.UoM;
import org.n52.shetland.ogc.gml.GmlConstants;
import org.n52.shetland.ogc.sensorML.SensorML20Constants;
import org.n52.shetland.ogc.sensorML.elements.SmlIo;
import org.n52.shetland.ogc.sensorML.v20.PhysicalComponent;
import org.n52.shetland.ogc.swe.SweConstants;
import org.n52.shetland.ogc.swe.simpleType.SweObservableProperty;
import org.n52.shetland.ogc.swe.simpleType.SweQuantity;
import org.n52.shetland.w3c.W3CConstants;
import org.n52.svalbard.encode.AbstractXmlEncoder;
import org.n52.svalbard.encode.Encoder;
import org.n52.svalbard.encode.EncoderRepository;
import org.n52.svalbard.encode.GmlEncoderv321;
import org.n52.svalbard.encode.SensorMLEncoderv20;
import org.n52.svalbard.encode.SweCommonEncoderv20;
import org.n52.svalbard.encode.XmlEncoderKey;
import org.n52.svalbard.encode.exception.EncodingException;

import javax.xml.namespace.QName;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Map.Entry;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toList;

public class SensorMLCreator {

    public static void main(String[] args) throws EncodingException {
        final PhysicalComponent physicalComponent = new PhysicalComponent();

        final ObservedProperty[] position = {ObservedProperties.LONGITUDE,
                                             ObservedProperties.LATITUDE,
                                             ObservedProperties.HEADING,
                                             ObservedProperties.SPEED,
                                             ObservedProperties.DEPTH,
                                             ObservedProperties.COURSE_OVER_GROUND,
                                             ObservedProperties.SPEED_OVER_GROUND};
        final ObservedProperty[] meteorolgy = {ObservedProperties.WIND_MEAN,
                                               ObservedProperties.WIND_GUST,
                                               ObservedProperties.WIND_DIRECTION,
                                               ObservedProperties.AIR_TEMPERATURE,
                                               ObservedProperties.HUMIDITY,
                                               ObservedProperties.SOLAR_RADIATION,
                                               ObservedProperties.PRESSURE,
                                               ObservedProperties.WATER_TEMPERATURE};
        final ObservedProperty[] thermosalinity = {ObservedProperties.SALINITY,
                                                   ObservedProperties.WATER_TEMPERATURE,
                                                   ObservedProperties.RAW_FLUOROMETRY,
                                                   ObservedProperties.CONDUCTIVITY,
                                                   ObservedProperties.DENSITY};

        physicalComponent.setInputs(Stream.of(position, meteorolgy, thermosalinity).flatMap(Arrays::stream)
                                          .map(op -> new SmlIo().setIoName(op.getId())
                                                                .setIoValue(createSweObservableProperty(op)))
                                          .collect(toList()));
        physicalComponent.setOutputs(Stream.of(position, meteorolgy, thermosalinity).flatMap(Arrays::stream)
                                           .map(op -> new SmlIo().setIoName(op.getId()).setIoValue(createQuantity(op)))
                                           .collect(toList()));

        System.out.println(encode(SensorML20Constants.NS_SML_20, physicalComponent));
    }

    private static SweObservableProperty createSweObservableProperty(ObservedProperty op) {
        final SweObservableProperty sweObservableProperty = new SweObservableProperty();
        sweObservableProperty.setIdentifier(op.getId());
        sweObservableProperty.setName(op.getName());
        sweObservableProperty.setLabel(op.getName());
        sweObservableProperty.setDefinition(op.getDefinition());
        sweObservableProperty.setDescription(op.getDescription());
        return sweObservableProperty;
    }

    private static SweQuantity createQuantity(ObservedProperty op) {
        final SweQuantity ioValue = new SweQuantity();
        ioValue.setLabel(op.getName());
        ioValue.setDefinition(op.getDefinition());
        ioValue.setDescription(op.getDescription());
        ioValue.setName(op.getId());
        final UnitOfMeasurement unitOfMeasurement = ObservedProperties.UNITS.get(op);
        ioValue.setUom(new UoM(unitOfMeasurement.getName())
                               .setUom(unitOfMeasurement.getSymbol())
                               .setLink(unitOfMeasurement.getDefinition()));
        return ioValue;
    }

    private static <T> String encode(String namespace, T o) throws EncodingException {
        XmlOptions xmlOptions = new XmlOptions().setSavePrettyPrint()
                                                .setSaveSuggestedPrefixes(getPrefixMap());

        EncoderRepository encoderRepository = new EncoderRepository();
        encoderRepository.setEncoders(new HashSet<>(Arrays.asList(new SensorMLEncoderv20(),
                                                                  new SweCommonEncoderv20(),
                                                                  new GmlEncoderv321())));
        encoderRepository.init();
        for (Encoder<?, ?> encoder : encoderRepository.getEncoders()) {
            ((AbstractXmlEncoder<?, ?>) encoder).setXmlOptions(() -> xmlOptions);
            ((AbstractXmlEncoder<?, ?>) encoder).setEncoderRepository(encoderRepository);
        }

        XmlEncoderKey key = new XmlEncoderKey(namespace, o);
        Encoder<XmlObject, T> encoder = encoderRepository.getEncoder(key);
        return fixNamespaces(encoder.encode(o)).xmlText(xmlOptions);
    }

    private static XmlObject fixNamespaces(XmlObject xmlObject) {
        XmlCursor xmlCursor = xmlObject.newCursor();
        try {
            xmlCursor.toFirstChild();
            xmlCursor.toNextToken();
            for (Entry<String, String> e : getPrefixMap().entrySet()) {
                xmlCursor.insertAttributeWithValue(new QName(null, e.getValue(), "xmlns"), e.getKey());
            }
        } finally {
            xmlCursor.dispose();
        }
        return xmlObject;
    }

    private static Map<String, String> getPrefixMap() {
        HashMap<String, String> prefixes = new HashMap<>();
        //prefixes.put(OmConstants.NS_OM_2, OmConstants.NS_OM_PREFIX);
        //prefixes.put(OmConstants.NS_GMD, OmConstants.NS_GMD_PREFIX);
        //prefixes.put(SfConstants.NS_SA, SfConstants.NS_SA_PREFIX);
        //prefixes.put(SfConstants.NS_SAMS, SfConstants.NS_SAMS_PREFIX);
        //prefixes.put(SfConstants.NS_SF, SfConstants.NS_SF_PREFIX);
        //prefixes.put(SfConstants.NS_SPEC, SfConstants.NS_SPEC_PREFIX);
        //prefixes.put(Sos2Constants.NS_SOS_20, SosConstants.NS_SOS_PREFIX);
        //prefixes.put(SwesConstants.NS_SWES_20, SwesConstants.NS_SWES_PREFIX);
        //prefixes.put(W3CConstants.NS_XSI, W3CConstants.NS_XSI_PREFIX);
        //prefixes.put(W3CConstants.NS_XS, W3CConstants.NS_XS_PREFIX);
        prefixes.put(W3CConstants.NS_XLINK, W3CConstants.NS_XLINK_PREFIX);
        prefixes.put(SweConstants.NS_SWE_20, SweConstants.NS_SWE_PREFIX);
        prefixes.put(GmlConstants.NS_GML_32, GmlConstants.NS_GML_PREFIX);
        prefixes.put(SensorML20Constants.NS_SML_20, SensorML20Constants.NS_SML_PREFIX);
        return prefixes;
    }
}
