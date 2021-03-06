package org.n52.emodnet.eurofleets.feeder.sta;

import com.fasterxml.jackson.databind.JsonNode;
import org.n52.emodnet.eurofleets.feeder.model.Datastream;
import org.n52.emodnet.eurofleets.feeder.model.FeatureOfInterest;
import org.n52.emodnet.eurofleets.feeder.model.ObservedProperty;
import org.n52.emodnet.eurofleets.feeder.model.Sensor;
import org.n52.emodnet.eurofleets.feeder.model.Thing;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Headers;
import retrofit2.http.PATCH;
import retrofit2.http.POST;
import retrofit2.http.Path;

public interface RetrofitSensorThingsAPI {

    @POST("FeaturesOfInterest")
    @Headers("Content-Type: application/json")
    Call<Void> createFeature(@Body FeatureOfInterest featureOfInterest);

    @GET("FeaturesOfInterest({id})")
    @Headers("Accept: application/json")
    Call<JsonNode> getFeature(@Path("id") String id);

    @POST("Things")
    @Headers("Content-Type: application/json")
    Call<Void> createThing(@Body Thing thing);

    @GET("Things({id})")
    @Headers("Content-Type: application/json")
    Call<JsonNode> getThing(@Path("id") String id);

    @PATCH("Things({id})")
    Call<Void> updateThing(@Path("id") String id, @Body Thing thing);

    @GET("Sensors({id})")
    @Headers("Content-Type: application/json")
    Call<JsonNode> getSensor(@Path("id") String id);

    @POST("Sensors")
    @Headers("Content-Type: application/json")
    Call<Void> createSensor(@Body Sensor sensor);

    @GET("ObservedProperties({id})")
    @Headers("Content-Type: application/json")
    Call<JsonNode> getObservedProperty(@Path("id") String id);

    @POST("ObservedProperties")
    @Headers("Content-Type: application/json")
    Call<Void> createObservedProperty(@Body ObservedProperty sensor);

    @GET("Datastreams({id})")
    @Headers("Content-Type: application/json")
    Call<JsonNode> getDataStream(@Path("id") String id);

    @POST("Datastreams")
    @Headers("Content-Type: application/json")
    Call<Void> createDataStream(@Body Datastream sensor);
}
