package org.n52.emodnet.eurofleets.feeder.config;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okio.Buffer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.Objects;

@Configuration
public class OkHttpConfiguration {

    @Bean
    public OkHttpClient okHttpClient() {
        return new OkHttpClient.Builder()
                       .followRedirects(true)
                       .followSslRedirects(true)
                       .addInterceptor(new LoggingInterceptor())
                       .build();
    }

    private static class LoggingInterceptor implements Interceptor {
        private final Logger log;

        LoggingInterceptor(Logger log) {
            this.log = Objects.requireNonNull(log);
        }

        LoggingInterceptor() {
            this(LoggerFactory.getLogger("okhttp3"));
        }

        @Override
        public Response intercept(Chain chain) throws IOException {
            Instant before = Instant.now();
            Request request = chain.request();
            Response response = chain.proceed(request);
            Instant after = Instant.now();
            String body = null;
            if (request.body() != null) {
                if (!request.body().isOneShot()) {
                    Buffer sink = new Buffer();
                    request.body().writeTo(sink);
                    body = new String(sink.readByteArray(), StandardCharsets.UTF_8);
                }
            }

            Duration duration = Duration.between(before, after);
            if (response.isSuccessful()) {
                if (body != null && !body.isEmpty()) {
                    this.log.debug("{} {} {}: {} {}",
                                   request.method(),
                                   body,
                                   request.url(),
                                   response.code(),
                                   duration);
                } else {
                    this.log.debug("{} {}: {} {}",
                                   request.method(),
                                   request.url(),
                                   response.code(),
                                   duration);
                }
            } else {
                if (body != null && !body.isEmpty()) {
                    this.log.warn("{} {} {}: {} {}",
                                  request.method(),
                                  body,
                                  request.url(),
                                  response.code(),
                                  duration);
                } else {
                    this.log.warn("{} {}: {} {}",
                                  request.method(),
                                  request.url(),
                                  response.code(),
                                  duration);
                }
            }
            return response;
        }
    }
}
