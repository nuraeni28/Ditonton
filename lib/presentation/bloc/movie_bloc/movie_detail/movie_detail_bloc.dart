import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases_movie/get_movie_detail.dart';
import 'package:ditonton/domain/usecases_movie/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases_movie/get_watchlist_status_movies.dart';
import 'package:ditonton/domain/usecases_movie/remove_watchlist_movies.dart';
import 'package:ditonton/domain/usecases_movie/save_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail/movie_detail_event.dart';
import 'package:bloc/bloc.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_detail/movie_detail_state.dart';

class DetailBlocMovie extends Bloc<DetailEventMovie, DetailStateMovie> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatusMovie getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  static const watchListAdd = 'Added to Watchlist';
  static const watchListRemove = 'Removed from Watchlist';

  DetailBlocMovie(this.getMovieDetail, this.getMovieRecommendations,
      this.getWatchListStatus, this.saveWatchlist, this.removeWatchlist)
      : super(DetailStateMovie.initial()) {
    on<OnDetailList>(
      (event, emit) async {
        emit(state.copyWith(
          movieDetailState: RequestState.Loading,
        ));
        final result = await getMovieDetail.execute(event.id);
        final recomendation = await getMovieRecommendations.execute(event.id);

        result.fold(
          (failure) {
            emit(state.copyWith(
              movieDetailState: RequestState.Error,
              message: failure.message,
            ));
          },
          (detail) {
            emit(state.copyWith(
              movieRecommendationState: RequestState.Loading,
              message: '',
              movieDetailState: RequestState.Loaded,
              movieDetail: detail,
            ));
            recomendation.fold((failure) {
              emit(state.copyWith(
                movieRecommendationState: RequestState.Error,
                message: failure.message,
              ));
            }, (recomended) {
              emit(state.copyWith(
                movieRecommendations: recomended,
                movieRecommendationState: RequestState.Loaded,
                message: '',
              ));
            });
          },
        );
      },
    );
    on<AddWatchlist>(
      (event, emit) async {
        final result = await saveWatchlist.execute(event.movieDetail);

        result.fold(
          (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
          (added) {
            emit(state.copyWith(
              watchlistMessage: watchListAdd,
            ));
          },
        );

        add(WatchlistStatus(event.movieDetail.id));
      },
    );
    on<EraseWatchlist>(
      (event, emit) async {
        final result = await removeWatchlist.execute(event.movieDetail);
        result.fold(
          (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
          (added) {
            emit(state.copyWith(
              watchlistMessage: watchListRemove,
            ));
          },
        );
        add(WatchlistStatus(event.movieDetail.id));
      },
    );
    on<WatchlistStatus>(
      (event, emit) async {
        final result = await getWatchListStatus.execute(event.id);
        emit(state.copyWith(isAddedToWatchlist: result));
      },
    );
  }
}
