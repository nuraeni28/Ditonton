
import 'package:ditonton/presentation/bloc/movie_bloc/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie_bloc/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases_movie/get_popular_movies.dart';



class PopularMovie extends Bloc<EventMovie, StateMovie> {
  final GetPopularMovies _getPopularMovies;

  PopularMovie(this._getPopularMovies) : super(MovieEmpty()) {
    on<OnListMovie>(
      (event, emit) async {
        emit(MovieLoading());
        final result = await _getPopularMovies.execute();

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
