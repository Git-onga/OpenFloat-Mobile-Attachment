import 'package:equatable/equatable.dart';

import '../../domain/entities/home_item.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<HomeItem> items;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<HomeItem>? items,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
