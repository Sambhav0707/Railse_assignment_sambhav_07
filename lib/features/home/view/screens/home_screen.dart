import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:railse_assignment/features/home/bloc/home_bloc.dart';
import 'package:railse_assignment/features/home/view/widgets/add_order_dialouge.dart';
import 'package:railse_assignment/features/home/view/widgets/order_container_widget.dart';
import 'package:railse_assignment/features/home/data/models/order_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              _showAddOrderDialog(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeOrderAddedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order added successfully')),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<HomeBloc>();
          if (bloc.orders.isEmpty) {
            return const Center(child: Text('No orders found'));
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: bloc.orders.length,
            itemBuilder: (context, index) {
              final order = bloc.orders[index];
              return OrderContainerWidget(
                showDashedLine: true,
                order: order,
                onTap: () {
                  bloc.add(CompleteTaskEvent(order: order));
                  if (state is HomeOrderCompletedSuccessState) {
                    order.orderStatus = state.order.orderStatus;
                  }
                },
                onStartTask: () {
                  // ### CHANGE THIS #### - Update the specific order's task status
                  bloc.orders[index].hasStarted = true;
                  bloc.orders[index].startDate = DateTime.now();
                  bloc.orders[index].orderStatus = "Overdue";
                  bloc.emit(
                    HomeOrderStartedSuccessState(order: bloc.orders[index]),
                  );
                },
                onChangeStartDate: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: order.startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    // ### CHANGE THIS #### - Update the specific order's start date
                    bloc.orders[index].startDate = date;
                    bloc.emit(
                      HomeOrderStartDateChangedSuccessState(startdate: date),
                    );
                  }
                },
                onChangeDeadlineDate: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: order.startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (date != null) {
                    // ### CHANGE THIS #### - Update the specific order's deadline date and status
                    bloc.orders[index].startDate = date;
                    // Update status based on the new deadline date
                    if (date.isAfter(DateTime.now())) {
                      bloc.orders[index].orderStatus = "Due";
                      bloc.orders[index].hasStarted = false;
                    } else {
                      bloc.orders[index].orderStatus = "Overdue";
                      bloc.orders[index].hasStarted = true;
                    }

                    bloc.emit(
                      HomeOrderDeadlineDateChangedSuccessState(
                        order: bloc.orders[index],
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  // ### CHANGE THIS #### - Show add order dialog
  void _showAddOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddOrderDialog();
      },
    );
  }
}
// ### CHANGE THIS #### - Add Order Dialog Widget
