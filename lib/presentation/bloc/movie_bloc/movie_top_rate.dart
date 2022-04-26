import 'package:ditonton/domain/usecases_movie/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases_movie/get_top_rated_movies.dart';

class TopRatedMovie extends Bloc<EventMovie, StateMovie> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovie(this._getTopRatedMovies) : super(MovieEmpty()) {
    on<OnListMovie>(
      (event, emit) async {
        emit(MovieLoading());
        final result = await _getTopRatedMovies.execute();

        result.fold(
          (failure) {
            emit(MovieError(failure.message));
          },
          (data) {
            emit(MovieHasData(data));
          },
        );
      },
    );
  }
}
