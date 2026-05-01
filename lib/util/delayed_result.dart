import 'package:equatable/equatable.dart';

class DelayedResult<T> extends Equatable {
  final T? value;
  final Exception? error;
  final bool isInProgress;
  final bool loadMoreInProgress;

  const DelayedResult.fromError(Exception e)
      : value = null,
        error = e,
        loadMoreInProgress = false,
        isInProgress = false;


  const DelayedResult.fromValue(T result)
      : value = result,
        error = null,
        loadMoreInProgress = false,
        isInProgress = false;

  const DelayedResult.inProgress()
      : value = null,
        error = null,
        loadMoreInProgress = false,
        isInProgress = true;

  const DelayedResult.idle()
      : value = null,
        error = null,
        loadMoreInProgress = false,
        isInProgress = false;

  const DelayedResult.loadMore()
      : value = null,
        error = null,
        loadMoreInProgress = true,
        isInProgress = false;

  bool get isSuccessful => value != null;

  bool get isError => error != null;

  bool get isIdle => value == null && error == null && !isInProgress;

  @override
  List<Object?> get props => [value, error, loadMoreInProgress, isInProgress];
}