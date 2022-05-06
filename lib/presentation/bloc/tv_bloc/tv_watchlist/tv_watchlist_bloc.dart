import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases_tv/get_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist/tv_watchlist_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_watchlist/tv_watchlist_state.dart';

class WatchlistBlocTv
    extends Bloc<WatchlistEventTv, WatchlistStateTv> {
  final GetWatchlistTv getWatchlist;

  WatchlistBlocTv(this.getWatchlist) : super(WatchlistEmpty()) {
    on<WatchlistTv>(
      (event, emit) async {
        emit(WatchlistLoading());
        final result = await getWatchlist.execute();

        result.fold(
          (failure) {
            emit(WatchlistError(
              failure.message,
            ));
          },
          (data) {
            emit(WatchlistHasData(data));
          },
        );
      },
    );
  }
}
