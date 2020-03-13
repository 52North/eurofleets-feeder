package org.n52.emodnet.eurofleets.feeder.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import okhttp3.OkHttpClient;
import org.n52.emodnet.eurofleets.feeder.sta.RetrofitSensorThingsAPI;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

import java.net.URL;

@Configuration
public class RetrofitConfiguration {
    private Retrofit.Builder retrofit(JacksonConverterFactory factory, OkHttpClient client) {
        return new Retrofit.Builder().addConverterFactory(factory).client(client);
    }

    @Bean
    public JacksonConverterFactory jacksonConverterFactory(ObjectMapper mapper) {
        return JacksonConverterFactory.create(mapper);
    }

    @Bean
    public RetrofitSensorThingsAPI sensorThingsAPI(JacksonConverterFactory factory, OkHttpClient client,
                                                   @Value("${feeder.sta.http.url}") URL endpoint) {
        return retrofit(factory, client).baseUrl(endpoint).build().create(RetrofitSensorThingsAPI.class);
    }

}
