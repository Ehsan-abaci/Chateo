abstract class DataState<T> {
  final T? data;
  final List<String>? error;

  const DataState(this.data, this.error);
}

class DataSuccess<T> extends DataState<T> {
  final String? message;
  const DataSuccess(T? data, [this.message]) : super(data, null);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(List<String> error) : super(null, error);
}
