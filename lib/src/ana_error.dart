

/// DioError describes the error info  when request failed.
class AnaError implements Exception {
  AnaError({
    this.error,
  });

  /// The original error/exception object; It's usually not null when `type`
  /// is DioErrorType.other
  dynamic error;

  StackTrace? _stackTrace;

  set stackTrace(StackTrace? stack) => _stackTrace = stack;

  StackTrace? get stackTrace => _stackTrace;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'error : $message';
    if (error is Error) {
      msg += '\n${(error as Error).stackTrace}';
    }
    if (_stackTrace != null) {
      msg += '\nSource stack:\n$stackTrace';
    }
    return msg;
  }
}
