import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/home_item.dart';
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

    // Try API with a short timeout
    try {
      final result = await getHomeDataUseCase()
          .timeout(const Duration(seconds: 3));

      result.fold(
        (_) => emit(state.copyWith(
          status: HomeStatus.loaded,
          items: _mockData,
        )),
        (items) => emit(state.copyWith(
          status: HomeStatus.loaded,
          items: items.isNotEmpty ? items : _mockData,
        )),
      );
    } catch (_) {
      // API timed out or threw — use mock data
      emit(state.copyWith(
        status: HomeStatus.loaded,
        items: _mockData,
      ));
    }
  }

  /// Mock data for demo / offline mode
  static List<HomeItem> get _mockData => [
        // --- Ongoing Job 1 ---
        HomeItem(
          id: 'JOB-2024-001',
          title: 'Plumbing Repair',
          description:
              'Burst pipe under kitchen sink. Water leaking onto floor.',
          createdAt: DateTime.now(),
          jobId: 'JOB-2024-001',
          jobStatus: 'In Progress',
          elapsedTime: '02:12:24',
          workerName: 'Muriuki James',
          workerProfession: 'Plumber',
          workerRating: 4,
          jobDetails:
              'Fix burst pipe under kitchen sink. Includes replacing damaged pipe section, sealing joints, and testing water pressure after repair. Materials to be provided by the service provider.',
          hourlyRate: 'KES 100/=',
          category: 'ongoing',
        ),

        // --- Ongoing Job 2 ---
        HomeItem(
          id: 'JOB-2024-042',
          title: 'Ceiling Painting',
          description:
              'Repaint living room ceiling after water damage. 3 coats needed.',
          createdAt: DateTime.now(),
          jobId: 'JOB-2024-042',
          jobStatus: 'In Progress',
          elapsedTime: '05:45:10',
          workerName: 'Wanjiku Njeri',
          workerProfession: 'Painter',
          workerRating: 5,
          jobDetails:
              'Ceiling repainting for living room (approx. 4x5m). Surface prep, primer application, and 3 coats of white matt emulsion. All paint and materials included. Dust sheets provided.',
          hourlyRate: 'KES 80/=',
          category: 'ongoing',
        ),

        // --- Booking 1 ---
        HomeItem(
          id: 'JOB-2024-056',
          title: 'Electrical Wiring',
          description:
              'New wiring for living room. 3 sockets + light switch.',
          createdAt: DateTime.now(),
          jobId: 'JOB-2024-056',
          jobStatus: 'Scheduled',
          elapsedTime: '00:00:00',
          workerName: 'Otieno Kip',
          workerProfession: 'Electrician',
          workerRating: 5,
          jobDetails:
              'Install new electrical wiring for living room renovation. Includes 3 wall sockets, 1 light switch, and ceiling light fixture. All materials provided.',
          hourlyRate: 'KES 150/=',
          category: 'booking',
        ),

        // --- Booking 2 ---
        HomeItem(
          id: 'JOB-2024-078',
          title: 'Garden Landscaping',
          description:
              'Full front yard landscaping. Grass, flower beds & stone path.',
          createdAt: DateTime.now(),
          jobId: 'JOB-2024-078',
          jobStatus: 'Confirmed',
          elapsedTime: '00:00:00',
          workerName: 'Kamau Mwangi',
          workerProfession: 'Landscaper',
          workerRating: 4,
          jobDetails:
              'Complete front yard landscaping (approx. 30sqm). Bermuda grass installation, 2 flower beds with seasonal plants, natural stone walkway, and drip irrigation setup.',
          hourlyRate: 'KES 120/=',
          category: 'booking',
        ),
      ];
}
