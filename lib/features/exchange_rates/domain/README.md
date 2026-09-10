# Domain boundary

Pure Dart entities, the repository contract, and the two use cases will live here
when rate behavior is implemented. Domain code must not import Flutter, HTTP,
preferences, data sources, or presentation. Repository policy will combine remote
and local snapshots; BLoCs will consume the domain contract/use cases.
