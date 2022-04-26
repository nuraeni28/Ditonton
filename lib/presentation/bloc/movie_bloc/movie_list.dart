
import 'package:ditonton/presentation/bloc/movie_bloc/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases_movie/get_now_playing_movies.dart';

class ListMovie extends Bloc<EventMovie, StateMovie> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  ListMovie(this._getNowPlayingMovies) : super(MovieEmpty()) {
    on<OnListMovie>(
      (event, emit) async {
        emit(MovieLoading());
        final result = await _getNowPlayingMovies.execute();

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
