package org.n52.emodnet.eurofleets.feeder.datagram;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;

public interface DateTimeFormatters {

    DateTimeFormatter HHMMSS = new DateTimeFormatterBuilder()
                                       .appendValue(ChronoField.HOUR_OF_DAY, 2)
                                       .appendValue(ChronoField.MINUTE_OF_HOUR, 2)
                                       .appendValue(ChronoField.SECOND_OF_MINUTE, 2)
                                       .toFormatter();
    DateTimeFormatter YYYYMMDD = new DateTimeFormatterBuilder()
                                         .appendValueReduced(ChronoField.YEAR, 2, 4, LocalDate.of(2000, 1, 1))
                                         .appendValue(ChronoField.MONTH_OF_YEAR, 2)
                                         .appendValue(ChronoField.DAY_OF_MONTH, 2)
                                         .toFormatter();
    DateTimeFormatter DDMMYYYY = new DateTimeFormatterBuilder()
                                         .appendValue(ChronoField.DAY_OF_MONTH, 2)
                                         .appendValue(ChronoField.MONTH_OF_YEAR, 2)
                                         .appendValueReduced(ChronoField.YEAR, 2, 4, LocalDate.of(2000, 1, 1))
                                         .toFormatter();
}
