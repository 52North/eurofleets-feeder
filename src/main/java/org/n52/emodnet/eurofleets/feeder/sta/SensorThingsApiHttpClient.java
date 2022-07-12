package org.n52.emodnet.eurofleets.feeder.sta;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.base.Throwables;
import okhttp3.ResponseBody;
import org.apache.http.HttpStatus;
import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.Intentified;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.Sensor;
import org.n52.emodnet.eurofleets.feeder.model.Thing;
import org.n52.janmayen.function.ThrowingRunnable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import retrofit2.Response;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.net.ConnectException;
import java.util.Objects;
import java.util.function.IntPredicate;
import java.util.function.IntToLongFunction;
import java.util.function.Predicate;

@Service
public class SensorThingsApiHttpClient {
    public static final Logger LOG = LoggerFactory.getLogger(SensorThingsApiHttpClient.class);
    private final RetrofitSensorThingsAPI api;
    private final Retrier retrier;

    private final ObjectMapper mapper;

    @Autowired
    public SensorThingsApiHttpClient(RetrofitSensorThingsAPI api, ObjectMapper mapper) {
        this.api = Objects.requireNonNull(api);
        this.mapper = Objects.requireNonNull(mapper);
        this.retrier = new Retrier.Builder()
                               .withWaitStrategy(getWaitStrategy())
                               .withStopStrategy(getStopStrategy())
                               .withFailedRetryStrategy(getFailedRetryStrategy())
                               .build();
    }

    private Predicate<Exception> getFailedRetryStrategy() {
        return x -> {
            if (x instanceof ConnectException) {
                LOG.info("retrying on connect exception: {}", x.getMessage());
                return true;
            }
            if (x instanceof HttpStatusException) {
                int status = ((HttpStatusException) x).getStatus();
                if (status == HttpStatus.SC_BAD_GATEWAY ||
                    status == HttpStatus.SC_GATEWAY_TIMEOUT ||
                    status == HttpStatus.SC_SERVICE_UNAVAILABLE) {
                    LOG.info("retrying on HTTP status {}", status);
                    return true;
                }
            }
            return false;
        };
    }

    private IntPredicate getStopStrategy() {
        return Retrier.Strategies.stopAfter(10);
    }

    private IntToLongFunction getWaitStrategy() {
        IntToLongFunction exponential = Retrier.Strategies.waitExponential();
        return attempts -> 1000L * exponential.applyAsLong(attempts);
    }

    public void create(FeatureOfInterest featureOfInterest) {
        LOG.info("creating feature of interest: {}", featureOfInterest);
        retryingExecute(() -> {
            if (this.api.getFeature(featureOfInterest.getId()).execute().isSuccessful()) {
                LOG.info("{} does already exist", featureOfInterest);
            } else {
                Response<Void> response = this.api.createFeature(featureOfInterest).execute();
                if (!response.isSuccessful() && response.code() != HttpStatus.SC_CONFLICT) {
                    checkForConflict(featureOfInterest, response);
                }
            }
        });
    }

    public void update(String id, Thing thing) {
        LOG.info("updating thing {}", thing);
        retryingExecute(() -> {
            Response<Void> response = this.api.updateThing(id, thing).execute();
            if (!response.isSuccessful()) {
                String body = null;
                ResponseBody errorBody = response.errorBody();
                if (errorBody != null) {
                    body = errorBody.string();
                }
                String message = String.format("could not update Thing{id=%s}: %s", id, body);
                throw new HttpStatusException(response.code(), message);
            }
        });
    }

    public void create(Thing thing) {
        LOG.info("creating thing {}", thing);
        retryingExecute(() -> {
            if (this.api.getThing(thing.getId()).execute().isSuccessful()) {
                LOG.info("{} does already exist", thing);
            } else {
                Response<Void> response = this.api.createThing(thing).execute();
                if (!response.isSuccessful() && response.code() != HttpStatus.SC_CONFLICT) {
                    checkForConflict(thing, response);
                }
            }
        });
    }

    public void create(ObservedProperty observedProperty) {
        LOG.info("creating observed property {}", observedProperty);
        retryingExecute(() -> {
            if (this.api.getObservedProperty(observedProperty.getId()).execute().isSuccessful()) {
                LOG.info("{} does already exist", observedProperty);
            } else {
                Response<Void> response = this.api.createObservedProperty(observedProperty).execute();
                if (!response.isSuccessful() && response.code() != HttpStatus.SC_CONFLICT) {
                    checkForConflict(observedProperty, response);
                }
            }
        });
    }

    public void create(Sensor sensor) {
        LOG.info("creating sensor {}", sensor);
        retryingExecute(() -> {
            if (this.api.getSensor(sensor.getId()).execute().isSuccessful()) {
                LOG.info("{} does already exist", sensor);
            } else {
                Response<Void> response = this.api.createSensor(sensor).execute();
                if (!response.isSuccessful() && response.code() != HttpStatus.SC_CONFLICT) {
                    checkForConflict(sensor, response);
                }
            }
        });
    }

    public void create(Datastream datastream) {
        LOG.info("creating datastream {}", datastream);
        retryingExecute(() -> {
            if (this.api.getDataStream(datastream.getId()).execute().isSuccessful()) {
                LOG.info("{} does already exist", datastream);
            } else {
                Response<Void> response = this.api.createDataStream(datastream).execute();
                if (!response.isSuccessful() && response.code() != HttpStatus.SC_CONFLICT) {
                    checkForConflict(datastream, response);
                }
            }
        });
    }

    private <T extends Intentified> void checkForConflict(T t, Response<Void> response) throws IOException {
        ResponseBody errorBody = response.errorBody();
        String body = null;
        if (errorBody != null) {
            body = errorBody.string();
        }
        if (body != null && body.contains("Identifier already exists")) {
            LOG.info("{} does already exist", t);
            return;
        }
        String message = String.format("could not create %s: %s", t, body);
        throw new HttpStatusException(response.code(), message);
    }

    private void retryingExecute(ThrowingRunnable<Exception> runnable) {
        try {
            this.retrier.execute(runnable);
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        } catch (Exception e) {
            Throwables.throwIfUnchecked(e);
            throw new RuntimeException(e);
        }
    }

}
