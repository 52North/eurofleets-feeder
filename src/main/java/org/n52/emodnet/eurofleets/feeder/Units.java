package org.n52.emodnet.eurofleets.feeder;

import org.n52.emodnet.eurofleets.feeder.model.UnitOfMeasurement;

public interface Units {
    UnitOfMeasurement DEGREES = new UnitOfMeasurement("Degrees", "deg", "http://vocab.nerc.ac.uk/collection/P06/current/UAAA/");
    UnitOfMeasurement KNOTS = new UnitOfMeasurement("Knots", "kn", "http://vocab.nerc.ac.uk/collection/P06/current/UKNT/");
    UnitOfMeasurement METRES = new UnitOfMeasurement("Metres", "m", "http://vocab.nerc.ac.uk/collection/P06/current/ULAA/");
    UnitOfMeasurement METRES_PER_SECOND = new UnitOfMeasurement("Metres per second", "m/s", "http://vocab.nerc.ac.uk/collection/P06/current/UVAA/");
    UnitOfMeasurement DEGREES_CELSIUS = new UnitOfMeasurement("Degrees Celsius", "degC", "http://vocab.nerc.ac.uk/collection/P06/current/UPAA/");
    UnitOfMeasurement PERCENT = new UnitOfMeasurement("Percent", "%", "http://vocab.nerc.ac.uk/collection/P06/current/UPCT/");
    UnitOfMeasurement WATTS_PER_SQUARE_METRE = new UnitOfMeasurement("Watts per square metre", "W/m^2", "http://vocab.nerc.ac.uk/collection/P06/current/UFAA/");
    UnitOfMeasurement HECTOPASCALS = new UnitOfMeasurement("Hectopascals", "hPa", "http://vocab.nerc.ac.uk/collection/P06/current/HPAX/");
    UnitOfMeasurement PSU = new UnitOfMeasurement("PSU", "psu", "http://vocab.nerc.ac.uk/collection/P06/current/UUUU/");
    UnitOfMeasurement VOLTS = new UnitOfMeasurement("Volts", "V", "http://vocab.nerc.ac.uk/collection/P06/current/UVLT/");
    UnitOfMeasurement SIEMENS_PER_METRE = new UnitOfMeasurement("Siemens per metre", "S/m", "http://vocab.nerc.ac.uk/collection/P06/current/UECA/");
    UnitOfMeasurement KILOGRAMS_PER_CUBIC_METRE = new UnitOfMeasurement("Kilograms per cubic metre", "kg/m^3", "http://vocab.nerc.ac.uk/collection/P06/current/UKMC/");
}
