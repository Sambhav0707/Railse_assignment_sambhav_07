import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:railse_assignment/features/home/bloc/home_bloc.dart';
import 'package:railse_assignment/features/home/data/models/order_model.dart';

class AddOrderDialog extends StatefulWidget {
  const AddOrderDialog({super.key});

  @override
  State<AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _orderTypeController = TextEditingController();
  final _idController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _orderTaskController = TextEditingController();
  final _orderActionController = TextEditingController();

  bool _isPriority = false;
  bool _hasStarted = false;
  String _orderStatus = 'Due';
  DateTime _startDate = DateTime.now();

  @override
  void dispose() {
    _orderTypeController.dispose();
    _idController.dispose();
    _ownerNameController.dispose();
    _orderTaskController.dispose();
    _orderActionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add New Order',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Scrollable Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Type
                      TextFormField(
                        controller: _orderTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Order Type',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Order, Entity',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter order type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Order ID
                      TextFormField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          labelText: 'Order ID',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 1043',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter order ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Owner Name
                      TextFormField(
                        controller: _ownerNameController,
                        decoration: const InputDecoration(
                          labelText: 'Owner Name',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Sandhya',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter owner name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Order Task
                      TextFormField(
                        controller: _orderTaskController,
                        decoration: const InputDecoration(
                          labelText: 'Order Task',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Arrange Pickup',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter order task';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // // Order Action
                      // TextFormField(
                      //   controller: _orderActionController,
                      //   decoration: const InputDecoration(
                      //     labelText: 'Order Action',
                      //     border: OutlineInputBorder(),
                      //     hintText: 'e.g., Start Task',
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Please enter order action';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // const SizedBox(height: 16),

                      // Priority Checkbox
                      CheckboxListTile(
                        title: const Text('High Priority'),
                        value: _isPriority,
                        onChanged: (value) {
                          setState(() {
                            _isPriority = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      // Has Started Checkbox
                      CheckboxListTile(
                        title: const Text('Has Started'),
                        value: _hasStarted,
                        onChanged: (value) {
                          setState(() {
                            _hasStarted = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      // Order Status Dropdown
                      DropdownButtonFormField<String>(
                        value: _orderStatus,
                        decoration: const InputDecoration(
                          labelText: 'Order Status',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Due', child: Text('Due')),
                          DropdownMenuItem(
                            value: 'Overdue',
                            child: Text('Overdue'),
                          ),
                          DropdownMenuItem(
                            value: 'Completed',
                            child: Text('Completed'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _orderStatus = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Start Date Picker
                      ListTile(
                        title: const Text('Start Date'),
                        subtitle: Text(_formatDate(_startDate)),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() {
                              _startDate = date;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Add Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ### CHANGE THIS #### - Helper method to format date
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }

  // ### CHANGE THIS #### - Add order method
  void _addOrder() {
    if (_formKey.currentState!.validate()) {
      final newOrder = Order(
        orderType: _orderTypeController.text,
        id: _idController.text,
        ownerName: _ownerNameController.text,
        orderTask: _orderTaskController.text,
        isPriority: _isPriority,
        hasStarted: _hasStarted,
        orderStatus: _orderStatus,

        startDate: _startDate,
      );

      // Add to BLoC
      context.read<HomeBloc>().add(AddOrderEvent(order: newOrder));

      // Close dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
