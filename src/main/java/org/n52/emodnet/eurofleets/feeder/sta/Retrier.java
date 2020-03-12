package org.n52.emodnet.eurofleets.feeder.sta;

import org.n52.janmayen.function.Predicates;
import org.n52.janmayen.function.ThrowingRunnable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.Objects;
import java.util.concurrent.Callable;
import java.util.function.IntPredicate;
import java.util.function.IntToLongFunction;
import java.util.function.Predicate;

/**
 * Responsible for executing a call and retrying until it succeeds based on configured strategies.
 *
 * @author Alex Objelean
 * @see <a href="https://github.com/alexo/retrier">Source</a>
 * @see <a href="https://github.com/alexo/retrier/blob/master/LICENSE">License</a>
 */
public class Retrier {
    private static final Logger LOG = LoggerFactory.getLogger(Retrier.class);

    private static final Retrier SINGLE_ATTEMPT = new Builder()
                                                          .withStopStrategy(Strategies.stopAfter(1))
                                                          .build();

    /**
     * Retrier that executes every operation exactly once. The operation is never retried. All exceptions are propagated
     * to the caller.
     */
    public static Retrier singleAttempt() {
        return SINGLE_ATTEMPT;
    }

    /**
     * Strategies used to check if the retry is required given a failed execution.
     */
    private final Predicate<Exception> exceptionRetryStrategy;
    /**
     * Strategies used to check if the retry is required given a successful execution with a result.
     */
    private final Predicate<Object> resultRetryStrategy;
    /**
     * Strategies used to check if the retry should be stopped given the provided number of attempts already performed.
     * Useful to limit the total number of attempts to a bounded value. By default this value is unbounded.
     */
    private final IntPredicate stopStrategy;
    /**
     * How much time (in milliseconds) to wait between retry attempts. Any result less or equal to zero => no wait.
     */
    private final IntToLongFunction waitStrategy;

    /**
     * Utility class responsible for creating several useful types of wait strategy used by Retrier.
     *
     * @author Alex Objelean
     */
    public static class Strategies {
        public static IntToLongFunction waitExponential(double backoffBase) {
            return attempts -> {
                if (attempts <= 0) {
                    return 0L;
                }
                return Math.min(1000L, Math.round(Math.pow(backoffBase, attempts)));
            };
        }

        /**
         * @param delay in millis to wait between retries.
         * @return a wait strategy which always return the constant delay.
         */
        public static IntToLongFunction waitConstantly(long delay) {
            return x -> delay;
        }

        public static IntToLongFunction waitExponential() {
            return waitExponential(2);
        }

        /**
         * Limit the number of attempts to a fixed value.
         */
        public static IntPredicate stopAfter(int maxAttempts) {
            return attempts -> attempts >= maxAttempts;
        }

        /**
         * Retry only if any of the provided exceptions was thrown
         */
        @SafeVarargs
        public static Predicate<Exception> retryOn(Class<? extends Throwable>... exceptions) {
            return exception -> Arrays.stream(exceptions).anyMatch(clazz -> clazz.isInstance(exception));
        }
    }

    /**
     * Default builder will retry on any exception for unlimited number of times without waiting between executions.
     */
    public static class Builder {
        private Predicate<Exception> failedRetryStrategy = Predicates.alwaysTrue();
        private Predicate<Object> resultRetryStrategy = result -> false;
        private IntPredicate stopStrategy = attempt -> false;
        private IntToLongFunction waitStrategy = attempt -> 0L;

        public Retrier build() {
            return new Retrier(failedRetryStrategy, resultRetryStrategy, stopStrategy, waitStrategy);
        }

        public Builder withFailedRetryStrategy(Predicate<Exception> failedRetryStrategy) {
            this.failedRetryStrategy = Objects.requireNonNull(failedRetryStrategy);
            return this;
        }

        public Builder withResultRetryStrategy(Predicate<Object> resultRetryStrategy) {
            this.resultRetryStrategy = Objects.requireNonNull(resultRetryStrategy);
            return this;
        }

        public Builder withStopStrategy(IntPredicate stopStrategy) {
            this.stopStrategy = Objects.requireNonNull(stopStrategy);
            return this;
        }

        public Builder withWaitStrategy(IntToLongFunction waitStrategy) {
            this.waitStrategy = Objects.requireNonNull(waitStrategy);
            return this;
        }
    }

    private Retrier(Predicate<Exception> exceptionRetryStrategy,
                    Predicate<Object> resultRetryStrategy,
                    IntPredicate stopStrategy,
                    IntToLongFunction waitStrategy) {
        this.exceptionRetryStrategy = exceptionRetryStrategy;
        this.resultRetryStrategy = resultRetryStrategy;
        this.stopStrategy = stopStrategy;
        this.waitStrategy = waitStrategy;
    }

    public void execute(ThrowingRunnable<Exception> runnable) throws Exception {
        execute((Callable<Void>) () -> {
            runnable.run();
            return null;
        });
    }

    /**
     * Invokes the provided {@link Callable} and retries the execution if required based on how this {@link Retrier} is
     * configured.
     *
     * @param callable to execute in context of {@link Retrier}
     * @return the result of callable invocation.
     * @throws Exception if the original callback execution failed and {@link Retrier} has decided to stop retrying.
     */
    public <T> T execute(Callable<T> callable) throws Exception {
        int attempts = 0;
        boolean shouldRetry;
        boolean attemptFailed = false;
        boolean interrupted;
        T result = null;
        Exception error = null;
        do {
            try {
                attempts++;
                error = null;
                attemptFailed = false;

                result = callable.call();
                attemptFailed = resultRetryStrategy.test(result);
            } catch (Exception e) {
                attemptFailed = exceptionRetryStrategy.test(e);
                error = e;
            } finally {
                interrupted = Thread.interrupted() || isInterruptedException(error);

                boolean canNotRetry = stopStrategy.test(attempts);
                shouldRetry = !interrupted && attemptFailed && !canNotRetry;

                if (!interrupted && attemptFailed) {
                    if (!canNotRetry) {
                        long waitMillis = waitStrategy.applyAsLong(attempts);
                        if (waitMillis > 0) {
                            LOG.info("Attempt {} failed, retrying in {}", attempts,
                                     Duration.of(waitMillis, ChronoUnit.MILLIS));
                            try {
                                Thread.sleep(waitMillis);
                            } catch (InterruptedException e) {
                                shouldRetry = false;
                                interrupted = true;
                            }
                        } else {
                            LOG.info("Attempt {} failed, retrying now", attempts);
                        }
                    } else {
                        LOG.info("Attempt {} failed, giving up", attempts);
                    }
                }
            }
        } while (shouldRetry);

        if (interrupted) {
            LOG.info("Attempt {} failed, interrupted", attempts);
            Thread.currentThread().interrupt();
        }

        if (error != null) {
            throw error;
        }
        return result;
    }

    private static boolean isInterruptedException(Throwable root) {
        Throwable current = root;
        while (current != null && !(current instanceof InterruptedException)) {
            current = current.getCause();
        }
        return current != null;
    }

}
