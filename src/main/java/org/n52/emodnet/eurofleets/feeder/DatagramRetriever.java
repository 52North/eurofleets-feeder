package org.n52.emodnet.eurofleets.feeder;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import org.apache.http.HttpHeaders;
import org.n52.emodnet.eurofleets.feeder.datagram.Datagram;
import org.n52.emodnet.eurofleets.feeder.datagram.DatagramParseException;
import org.n52.emodnet.eurofleets.feeder.datagram.MeteorologyDatagram;
import org.n52.emodnet.eurofleets.feeder.datagram.NavigationDatagram;
import org.n52.emodnet.eurofleets.feeder.datagram.ThermosalinityDatagram;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URL;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;
import java.util.Objects;
import java.util.regex.Pattern;

@Service
public class DatagramRetriever {
    private static final Logger LOG = LoggerFactory.getLogger(DatagramRetriever.class);
    private static final String TEXT_PLAIN = "text/plain";
    public static final String ACCEPT_HEADER = "*/*";
    private final Retriever positionRetriever;
    private final Retriever meteorologyRetriever;
    private final Retriever thermosalinityRetriever;

    @Autowired
    public DatagramRetriever(DatagramListener listener, Call.Factory httpClient,
                             @Value("${feeder.retrieval.navigation.url}") URL positionURL,
                             @Value("${feeder.retrieval.navigation.repeating:false}") boolean positionRepeating,
                             @Value("${feeder.retrieval.meteorology.url}") URL meteorologyURL,
                             @Value("${feeder.retrieval.meteorology.repeating:false}") boolean meteorologyRepeating,
                             @Value("${feeder.retrieval.thermosalinity.url}") URL thermosalinityURL,
                             @Value("${feeder.retrieval.thermosalinity.repeating:false}") boolean thermosalinityRepeating) {
        this.positionRetriever = createRetriever(NavigationDatagram::new, positionURL, listener, httpClient, positionRepeating);
        this.meteorologyRetriever = createRetriever(MeteorologyDatagram::new, meteorologyURL, listener, httpClient, meteorologyRepeating);
        this.thermosalinityRetriever = createRetriever(ThermosalinityDatagram::new, thermosalinityURL, listener, httpClient, thermosalinityRepeating);

    }

    private Retriever createRetriever(DatagramParser parser, URL url, DatagramListener listener,
                                      Call.Factory httpClient, boolean repeating) {
        return repeating ? new RepeatingRetriever(parser, url, listener, httpClient)
                         : new DefaultRetriever(parser, url, listener, httpClient);
    }

    @Scheduled(fixedDelayString = "${feeder.retrieval.navigation.schedule}")
    public void retrievePosition() {
        this.positionRetriever.retrieve();
    }

    @Scheduled(fixedDelayString = "${feeder.retrieval.meteorology.schedule}")
    public void retrieveMeteorology() {
        this.meteorologyRetriever.retrieve();
    }

    @Scheduled(fixedDelayString = "${feeder.retrieval.thermosalinity.schedule}")
    public void retrieveThermosalinity() {
        this.thermosalinityRetriever.retrieve();
    }

    private interface Retriever {
        void retrieve();
    }

    private static class RepeatingRetriever implements Callback, Retriever {
        private static final Pattern DATE_TIME_PATTERN = Pattern.compile(",[\\d]{8},[\\d]{6},");
        private static final ZoneId UTC = ZoneId.of("UTC");
        private static final DateTimeFormatter FORMATTER = new DateTimeFormatterBuilder()
                                                                   .appendLiteral(",")
                                                                   .appendValue(ChronoField.YEAR, 4)
                                                                   .appendValue(ChronoField.MONTH_OF_YEAR, 2)
                                                                   .appendValue(ChronoField.DAY_OF_MONTH, 2)
                                                                   .appendLiteral(",")
                                                                   .appendValue(ChronoField.HOUR_OF_DAY, 2)
                                                                   .appendValue(ChronoField.MINUTE_OF_HOUR, 2)
                                                                   .appendValue(ChronoField.SECOND_OF_MINUTE, 2)
                                                                   .appendLiteral(",")
                                                                   .toFormatter();
        private final DatagramParser parser;
        private final DatagramListener listener;
        private String[] stringBody;

        private RepeatingRetriever(DatagramParser parser, URL url, DatagramListener listener,
                                   Call.Factory callFactory) {
            this.parser = Objects.requireNonNull(parser);
            this.listener = Objects.requireNonNull(listener);
            callFactory.newCall(new Request.Builder().get().url(url).header(HttpHeaders.ACCEPT, ACCEPT_HEADER)
                                                     .build()).enqueue(this);
        }

        @Override
        public void retrieve() {
            if (stringBody != null) {
                OffsetDateTime now = OffsetDateTime.now(UTC);
                try {
                    String line = DATE_TIME_PATTERN.matcher(stringBody[(int) (now.toEpochSecond() % stringBody.length)])
                                                   .replaceFirst(FORMATTER.format(now));
                    listener.onDatagram(parser.parse(line));
                } catch (DatagramParseException e) {
                    LOG.error("could not parse datagram", e);
                }

            }
        }

        @Override
        public void onFailure(Call call, IOException e) {
            LOG.error("call to {} failed: {}", call.request().url(), e.getMessage());
        }

        @Override
        public synchronized void onResponse(Call call, Response response) throws IOException {
            if (response.code() == 200) {
                final ResponseBody body = response.body();
                if (body == null) {
                    LOG.error("call to {} didn't return a response body", call.request().url());
                } else {
                    stringBody = body.string().split("\n");
                }
            }
        }
    }

    private static class DefaultRetriever implements Callback, Retriever {
        private final DatagramParser parser;
        private final URL url;
        private final DatagramListener listener;
        private final Call.Factory callFactory;

        private Datagram last;

        private DefaultRetriever(DatagramParser parser, URL url, DatagramListener listener, Call.Factory callFactory) {
            this.parser = Objects.requireNonNull(parser);
            this.url = Objects.requireNonNull(url);
            this.listener = Objects.requireNonNull(listener);
            this.callFactory = Objects.requireNonNull(callFactory);
        }

        @Override
        public void retrieve() {
            callFactory.newCall(createRequest()).enqueue(this);
        }

        private Request createRequest() {
            return new Request.Builder().get().url(url).header(HttpHeaders.ACCEPT, ACCEPT_HEADER).build();
        }

        @Override
        public void onFailure(Call call, IOException e) {
            LOG.error("call to {} failed: {}", call.request().url(), e.getMessage());
        }

        @Override
        public synchronized void onResponse(Call call, Response response) throws IOException {
            if (response.code() == 200) {
                final ResponseBody body = response.body();

                if (body == null) {
                    LOG.error("call to {} didn't return a response body", call.request().url());
                } else {
                    try {

                        Datagram datagram = parser.parse(body.string());
                        if (last == null || !last.getDateTime().isEqual(datagram.getDateTime())) {
                            listener.onDatagram(datagram);
                        } else {
                            LOG.debug("No new datagram since {}", last.getDateTime());
                        }
                        last = datagram;
                    } catch (DatagramParseException e) {
                        LOG.error("could not parse datagram", e);
                    }
                }
            } else {
                response.close();
            }
        }
    }

    private interface DatagramParser {
        Datagram parse(String value) throws DatagramParseException;
    }

}
