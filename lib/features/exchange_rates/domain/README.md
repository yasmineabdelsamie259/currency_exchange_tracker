# Domain boundary

Pure Dart currency/quote entities, the repository contract, and GetExchangeRates
live here. Domain code must not import Flutter, Dio, storage, data sources, or
presentation. Daily changes operate on unrounded EGP-per-foreign-unit rates.
