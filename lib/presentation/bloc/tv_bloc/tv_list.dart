import 'package:ditonton/domain/usecases_tv/get_now_playing_tv.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv_bloc/tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListTv extends Bloc<EventTv, StateTv> {
  final GetNowPlayingTv _getNowPlayingTv;

  ListTv(this._getNowPlayingTv) : super(TvEmpty()) {
    on<OnListTv>(
      (event, emit) async {
        emit(TvLoading());
        final result = await _getNowPlayingTv.execute();

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
