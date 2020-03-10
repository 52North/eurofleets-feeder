package org.n52.emodnet.eurofleets.feeder.datagram;

public class DatagramParseException extends Exception {
    public DatagramParseException() {
    }

    public DatagramParseException(String message) {
        super(message);
    }

    public DatagramParseException(String message, Throwable cause) {
        super(message, cause);
    }

    public DatagramParseException(Throwable cause) {
        super(cause);
    }

    protected DatagramParseException(String message, Throwable cause, boolean enableSuppression,
                                     boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
