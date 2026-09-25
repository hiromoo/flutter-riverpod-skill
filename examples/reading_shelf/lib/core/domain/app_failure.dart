import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

enum AppFailureKind { network, notFound, invalidData, unknown }

@freezed
abstract class AppFailure with _$AppFailure {
  const factory AppFailure({required AppFailureKind kind}) = _AppFailure;
}

class AppFailureException implements Exception {
  const AppFailureException(this.failure);

  final AppFailure failure;
}
