import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({required this.getHomeDataUseCase}) : super(const HomeState()) {
    on<HomeDataRequested>(_onHomeDataRequested);
  }

  Future<void> _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    final result = await getHomeDataUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: failure.message,
      )),
      (items) => emit(state.copyWith(
        status: HomeStatus.loaded,
        items: items,
      )),
    );
  }
}
