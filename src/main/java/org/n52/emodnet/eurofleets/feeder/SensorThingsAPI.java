package org.n52.emodnet.eurofleets.feeder;

import com.fasterxml.jackson.databind.JsonNode;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.Thing;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.PATCH;
import retrofit2.http.POST;
import retrofit2.http.Path;

public interface SensorThingsAPI {

    @POST("FeaturesOfInterest")
    @Headers("Content-Type: application/json")
    Call<JsonNode> createFeature(@Body FeatureOfInterest featureOfInterest);

    @GET("FeaturesOfInterest({id})")
    @Headers("Accept: application/json")
    Call<JsonNode> getFeature(@Path("id") String id);

    @POST("Things")
    @Headers("Content-Type: application/json")
    Call<JsonNode> createThing(@Body Thing thing);

    @PATCH("Things({id})")
    Call<JsonNode> updateThing(@Path("id") String id, @Body Thing thing);
}
