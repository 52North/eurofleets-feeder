package org.n52.emodnet.eurofleets.feeder.sta;

import com.fasterxml.jackson.databind.JsonNode;
import okhttp3.ResponseBody;
import org.apache.http.HttpStatus;
import org.n52.emodnet.eurofleets.feeder.SensorThingsAPI;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.Thing;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import retrofit2.Response;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.Objects;

@Service
public class SensorThingsHttpClient implements FeatureOfInterestCreator, ThingCreator {
    private final SensorThingsAPI api;

    @Autowired
    public SensorThingsHttpClient(SensorThingsAPI api) {
        this.api = Objects.requireNonNull(api);
    }

    @Override
    public void create(FeatureOfInterest featureOfInterest) {
        try {

            if (!api.getFeature(featureOfInterest.getId()).execute().isSuccessful()) {
                Response<JsonNode> response = api.createFeature(featureOfInterest).execute();
                if (!response.isSuccessful() && response.code() != HttpStatus.SC_CONFLICT) {
                    ResponseBody errorBody = response.errorBody();
                    String body = null;
                    if (errorBody != null) {
                        body = errorBody.string();
                    }
                    if (body != null && body.contains("Identifier already exists")) {
                        return;
                    }
                    throw new HttpStatusException(response.code(), "could not create feature of interest: " + body);
                }
            }
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }

    @Override
    public void create(Thing thing) {
        try {
            Response<JsonNode> response = api.createThing(thing).execute();
            if (!response.isSuccessful() && response.code() != HttpStatus.SC_CONFLICT) {

                ResponseBody errorBody = response.errorBody();
                String body = null;
                if (errorBody != null) {
                    body = errorBody.string();
                }
                if (body != null && body.contains("Identifier already exists")) {
                    return;
                }
                throw new HttpStatusException(response.code(), "could not create thing: " + body);
            }
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
    }
}
