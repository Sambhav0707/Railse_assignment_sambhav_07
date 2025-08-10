import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:railse_assignment/features/home/data/models/order_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<Order> orders = [];
  HomeBloc() : super(HomeInitial()) {
    on<AddOrderEvent>(addOrder);
    on<StartTaskEvent>(startTask);
    on<ChangeStartDateEvent>(changeStartDate);
    on<ChangeDeadlineDateEvent>(changeDeadlineDate);
    on<CompleteTaskEvent>(completeTask);
    // ### CHANGE THIS #### - Add initial dummy data
    _addInitialData();
  }

  void _addInitialData() {
    orders.addAll([
      Order(
        orderType: 'Order',
        id: '1043',
        ownerName: 'Sandhya',
        orderTask: 'Arrange Pickup',
        isPriority: true,
        hasStarted: true,
        orderStatus: 'Overdue',
        startDate: DateTime(2025, 8, 5),
      ),
      Order(
        orderType: 'Entity',
        id: '2559',
        ownerName: 'Arman',
        orderTask: 'Adhoc Task',
        isPriority: false,
        hasStarted: true,
        orderStatus: 'Overdue',
        startDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Order(
        orderType: 'Order',
        id: '1020',
        ownerName: 'Sandhya',
        orderTask: 'Collect Payment',
        isPriority: true,
        hasStarted: false,
        orderStatus: 'Due',
        startDate: DateTime(2025, 8, 15),
      ),
    ]);
  }

  void addOrder(AddOrderEvent event, Emitter<HomeState> emit) {
    orders.add(event.order);
    emit(HomeOrderAddedSuccessState());
  }

  void startTask(StartTaskEvent event, Emitter<HomeState> emit) {
    emit(
      HomeOrderStartedSuccessState(
        order: Order(
          orderType: event.order.orderType,
          id: event.order.id,
          ownerName: event.order.ownerName,
          orderTask: event.order.orderTask,
          isPriority: event.order.isPriority,
          hasStarted: true,
          orderStatus: "Overdue",
          startDate: DateTime.now(),
        ),
      ),
    );
  }

  void changeStartDate(ChangeStartDateEvent event, Emitter<HomeState> emit) {
    emit(HomeOrderStartDateChangedSuccessState(startdate: event.startDate));
  }

  void changeDeadlineDate(
    ChangeDeadlineDateEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(
      HomeOrderDeadlineDateChangedSuccessState(
        order: Order(
          orderType: event.order.orderType,
          id: event.order.id,
          ownerName: event.order.ownerName,
          orderTask: event.order.orderTask,
          isPriority: event.order.isPriority,
          hasStarted: event.order.hasStarted,
          orderStatus:
              event.deadlineDate.isAfter(event.order.startDate)
                  ? "Overdue"
                  : "Due",
          startDate: event.deadlineDate,
        ),
      ),
    );
  }

  void completeTask(CompleteTaskEvent event, Emitter<HomeState> emit) {
    emit(
      HomeOrderCompletedSuccessState(
        order: Order(
          orderType: event.order.orderType,
          id: event.order.id,
          ownerName: event.order.ownerName,
          orderTask: event.order.orderTask,
          isPriority: event.order.isPriority,
          hasStarted: event.order.hasStarted,
          orderStatus: "Completed",
          startDate: event.order.startDate,
        ),
      ),
    );
  }
}
