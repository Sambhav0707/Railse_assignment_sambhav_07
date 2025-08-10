part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class AddOrderEvent extends HomeEvent {
  final Order order;
  AddOrderEvent({required this.order});
}

class StartTaskEvent extends HomeEvent {
  final Order order;
  StartTaskEvent({required this.order});
}

class ChangeStartDateEvent extends HomeEvent{
  final DateTime startDate;
  ChangeStartDateEvent({required this.startDate});
  
}

class ChangeDeadlineDateEvent extends HomeEvent{
  final DateTime deadlineDate;
  final Order order;
  ChangeDeadlineDateEvent({required this.deadlineDate, required this.order});
}

class CompleteTaskEvent extends HomeEvent{
  final Order order;
  CompleteTaskEvent({required this.order});
}
