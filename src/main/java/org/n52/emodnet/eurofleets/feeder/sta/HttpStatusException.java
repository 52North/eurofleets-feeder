package org.n52.emodnet.eurofleets.feeder.sta;

public class HttpStatusException extends RuntimeException {
    private final int status;

    public HttpStatusException(int status) {
        this(status, null, null);
    }

    public HttpStatusException(int status, String message) {
        this(status, message, null);
    }

    public HttpStatusException(int status, String message, Throwable cause) {
        super(formatMessage(status, message), cause);
        this.status = status;
    }

    public HttpStatusException(int status, Throwable cause) {
        this(status, null, cause);
    }

    public int getStatus() {
        return status;
    }

    private static String formatMessage(int status, String message) {
        return message == null ? Integer.toString(status) : String.format("%d: %s", status, message);
    }

}
