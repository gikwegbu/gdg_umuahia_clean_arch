/// Result is a sealed wrapper class for representing success or failure outcomes
/// of operations (such as API requests, local database fetches, etc.).
sealed class Result<T> {
  const Result();

  /// Utility helper to check if this is a Success state.
  bool get isSuccess => this is Success<T>;

  /// Utility helper to check if this is a Failure state.
  bool get isFailure => this is Failure<T>;

  /// Fold helper to unpack values or errors.
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(String message, Object? exception) onFailure,
  ) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      final failure = this as Failure<T>;
      return onFailure(failure.message, failure.exception);
    }
  }
}

/// Success state containing the successful generic payload [data].
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Failure state containing the failure [message] and an optional [exception].
class Failure<T> extends Result<T> {
  final String message;
  final Object? exception;
  const Failure(this.message, [this.exception]);
}
