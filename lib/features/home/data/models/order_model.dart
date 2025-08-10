class Order {
   String orderType;
   String id;
   String ownerName;
   String orderTask;
   bool isPriority;
    bool hasStarted;
   String orderStatus;
   DateTime startDate;

  Order({
    required this.orderType,
    required this.id,
    required this.ownerName,
    required this.orderTask,
    required this.isPriority,
    required this.hasStarted,
    required this.orderStatus,
    required this.startDate,
  });

  // Factory constructor to create Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderType: json['orderType'] ?? '',
      id: json['id'] ?? '',
      ownerName: json['ownerName'] ?? '',
      orderTask: json['orderTask'] ?? '',
      isPriority: json['isPriority'] ?? false,
      hasStarted: json['hasStarted'] ?? false,
      orderStatus: json['orderStatus'] ?? '',
      startDate:
          json['startDate'] != null
              ? DateTime.parse(json['startDate'])
              : DateTime.now(),
    );
  }

  // Convert Order to JSON
  Map<String, dynamic> toJson() {
    return {
      'orderType': orderType,
      'id': id,
      'ownerName': ownerName,
      'orderTask': orderTask,
      'isPriority': isPriority,
      'hasStarted': hasStarted,
      'orderStatus': orderStatus,
      'startDate': startDate.toIso8601String(),
    };
  }

  // Copy with method for creating modified copies
  Order copyWith({
    String? orderType,
    String? id,
    String? ownerName,
    String? orderTask,
    bool? isPriority,
    bool? hasStarted,
    String? orderStatus,
    DateTime? startDate,
  }) {
    return Order(
      orderType: orderType ?? this.orderType,
      id: id ?? this.id,
      ownerName: ownerName ?? this.ownerName,
      orderTask: orderTask ?? this.orderTask,
      isPriority: isPriority ?? this.isPriority,
      hasStarted: hasStarted ?? this.hasStarted,
      orderStatus: orderStatus ?? this.orderStatus,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  String toString() {
    return 'Order(orderType: $orderType, id: $id, ownerName: $ownerName, orderTask: $orderTask, isPriority: $isPriority, hasStarted: $hasStarted, orderStatus: $orderStatus, startDate: $startDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Order &&
        other.orderType == orderType &&
        other.id == id &&
        other.ownerName == ownerName &&
        other.orderTask == orderTask &&
        other.isPriority == isPriority &&
        other.hasStarted == hasStarted &&
        other.orderStatus == orderStatus &&
        other.startDate == startDate;
  }

  @override
  int get hashCode {
    return orderType.hashCode ^
        id.hashCode ^
        ownerName.hashCode ^
        orderTask.hashCode ^
        isPriority.hashCode ^
        hasStarted.hashCode ^
        orderStatus.hashCode ^
        startDate.hashCode;
  }
}
