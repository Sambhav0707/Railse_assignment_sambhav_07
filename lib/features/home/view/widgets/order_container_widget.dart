import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:railse_assignment/features/home/data/models/order_model.dart';

// ### CHANGE THIS #### - Custom painter for dashed line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[400]!
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ### CHANGE THIS #### - Custom painter for solid line
class SolidLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey[300]!
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ### CHANGE THIS #### - Custom painter for vertical dashed line
class VerticalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey.shade500
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke;

    const dashHeight = 6.40;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OrderContainerWidget extends StatelessWidget {
  const OrderContainerWidget({
    super.key,
    required this.order,
    this.showDashedLine = false,
    required this.onTap,
    required this.onStartTask,
    required this.onChangeStartDate,
    required this.onChangeDeadlineDate,
  });

  final Order order;
  final bool showDashedLine; // Toggle between solid and dashed line
  final VoidCallback onTap;
  final VoidCallback onStartTask;
  final VoidCallback onChangeStartDate;
  final VoidCallback onChangeDeadlineDate;

  // ### CHANGE THIS #### - Helper method to format time difference in hours and minutes
  String _formatTimeDifference(DateTime startDate) {
    final difference = startDate.difference(DateTime.now());
    final hours = difference.inHours.abs();
    final minutes = difference.inMinutes.abs() % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    } else {
      return "${minutes}m";
    }
  }

  // ### CHANGE THIS #### - Helper method to format date as "Aug 21" format
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
    return "${months[date.month - 1]} ${date.day}";
  }

  // ### CHANGE THIS #### - Helper method to format due date information
  String _formatDueDate(DateTime startDate) {
    final now = DateTime.now();
    final dueDate = startDate;
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) {
      return "Overdue";
    } else if (difference == 0) {
      return "Due today";
    } else if (difference == 1) {
      return "Due tomorrow";
    } else {
      return "Due in $difference days";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .start, // ### CHANGE THIS #### - Changed to start alignment
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 5),
                  // Left colored indicator bar
                  if (order.orderStatus == "Due")
                    Container(
                      width: 4,
                      height: 100,
                      child: CustomPaint(painter: VerticalDashedLinePainter()),
                    )
                  else if (order.orderStatus == "Overdue" ||
                      order.orderStatus == "Completed")
                    Container(
                      width: 4,
                      height: 100,
                      decoration: BoxDecoration(
                        color:
                            order.orderStatus == "Overdue"
                                ? Colors.blue
                                : Colors.green,
                      ),
                    ),
                  const SizedBox(width: 12),

                  // Main content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order ID and Status row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // ### CHANGE THIS #### - Custom underline with adjustable vertical position
                            Text(
                              "${order.orderType}-${order.id}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue,
                                decorationThickness: 1,
                                decorationStyle: TextDecorationStyle.solid,
                              ),
                            ),
                            // dot icon
                            Icon(
                              Icons.more_vert,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Task description
                        Text(
                          order.orderTask,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        // Bottom row with owner and action/date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Owner name and priority
                            Row(
                              children: [
                                Text(
                                  order.ownerName,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (order.isPriority) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    child: const Text(
                                      'High Priority',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // // Right side - Action or Start Date
                            // _buildRightSection(),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ### CHANGE THIS #### - Status moved to the end of the row
                  Container(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ), // ### CHANGE THIS #### - Added right padding
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .end, // ### CHANGE THIS #### - Changed to align to the right
                      children: [
                        Row(
                          children: [
                            Text(
                              "${order.orderStatus}",
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    order.orderStatus == "Overdue"
                                        ? Colors.red
                                        : order.orderStatus == "Completed"
                                        ? Colors.green
                                        : Colors.yellow.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            if (order.orderStatus == "Due")
                              Text(
                                " - ${_formatDueDate(order.startDate)}", // ### CHANGE THIS #### - Updated to show due date information
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.yellow.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            if (order.orderStatus == "Overdue" &&
                                order.hasStarted == true)
                              Text(
                                " - ${_formatTimeDifference(order.startDate)}", // ### CHANGE THIS #### - Updated to show hours and minutes
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            const SizedBox(width: 4),

                            if (order.orderStatus == "Overdue" &&
                                    order.hasStarted == true ||
                                order.orderStatus == "Due")
                              GestureDetector(
                                onTap: onChangeDeadlineDate,
                                child: Icon(
                                  CupertinoIcons.square_pencil_fill,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                            if (order.orderStatus == "Completed")
                              Text(
                                " - ${_formatDate(DateTime.now())}", // ### CHANGE THIS #### - Updated to show hours and minutes
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                        if (order.orderStatus == "Overdue" &&
                                order.hasStarted == true ||
                            order.orderStatus == "Completed" &&
                                order.hasStarted == true ||
                            order.orderStatus == "Due" &&
                                order.hasStarted == true)
                          Text(
                            "Started: ${_formatDate(order.startDate)}", // ### CHANGE THIS #### - Updated to show "Aug 21" format
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (order.orderStatus == "Due" &&
                            order.hasStarted == false)
                          Row(
                            children: [
                              Text(
                                "Start: ${_formatDate(order.startDate)}", // ### CHANGE THIS #### - Updated to show "Aug 21" format
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: onChangeStartDate,
                                child: Icon(
                                  CupertinoIcons.square_pencil_fill,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 6),
                        if (order.orderStatus == "Overdue" &&
                            order.hasStarted == true)
                          GestureDetector(
                            onTap: onTap,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 13,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Mark as complete",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (order.orderStatus == "Due" &&
                            order.hasStarted == false)
                          GestureDetector(
                            onTap: onStartTask,
                            child: Row(
                              children: [
                                Icon(
                                  CupertinoIcons.play_circle_fill,
                                  size: 13,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Start Task",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),

              // ### CHANGE THIS #### - Custom painted line at bottom
              if (!order.hasStarted)
                CustomPaint(
                  size: const Size(
                    350,
                    1,
                  ), // ### CHANGE THIS #### - Decreased width from infinity to 200
                  painter: DashedLinePainter(),
                ),
              if (order.hasStarted)
                CustomPaint(
                  size: const Size(
                    350,
                    1,
                  ), // ### CHANGE THIS #### - Decreased width from infinity to 200
                  painter: SolidLinePainter(),
                ),
            ],
          ),

          // ### CHANGE THIS #### - Backdrop filter for completed orders
          if (order.orderStatus == "Completed")
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 0.4, sigmaY: 0.4),
                  child: Container(color: Colors.white.withValues(alpha: 0.45)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
