// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppFailure {
  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  AppFailure([
    this.message = 'Sorry, something went wrong. Please try again later.',
    this.cause,
    this.stackTrace,
  ]);

  @override
  String toString() => 'AppFailure(message: $message, cause: $cause)';
}

/// Returns a message suitable for showing to the user for [error], which may be
/// an [AppFailure] propagated through an `AsyncValue.error` or any other object
/// thrown further up the stack.
String describeError(Object? error) => switch (error) {
  AppFailure(message: final message) => message,
  null => 'Sorry, something went wrong. Please try again later.',
  _ => error.toString(),
};
