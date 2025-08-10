part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeOrderAddedSuccessState extends HomeState {}

final class HomeOrderStartedSuccessState extends HomeState {
  final Order order;
  HomeOrderStartedSuccessState({required this.order});
}

final class HomeOrderStartDateChangedSuccessState extends HomeState {
  final DateTime startdate;
  HomeOrderStartDateChangedSuccessState({required this.startdate});
}

final class HomeOrderDeadlineDateChangedSuccessState extends HomeState {
  final Order order;
  HomeOrderDeadlineDateChangedSuccessState({required this.order});
}

final class HomeOrderCompletedSuccessState extends HomeState {
  final Order order;
  HomeOrderCompletedSuccessState({required this.order});
}
