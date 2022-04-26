import 'package:ditonton/domain/usecases_tv/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTv extends Bloc<EventTv, StateTv> {
  final GetPopularTv _getPopularTv;

  PopularTv(this._getPopularTv) : super(TvEmpty()) {
    on<OnListTv>(
      (event, emit) async {
        emit(TvLoading());
        final result = await _getPopularTv.execute();

        result.fold(
          (failure) {
            emit(TvError(failure.message));
          },
          (data) {
            emit(TvHasData(data));
          },
        );
      },
    );
  }
}
