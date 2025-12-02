enum AlertType {
  warning, // 80% del presupuesto
  exceeded, // Excedido
}

class Alert {
  final String id;
  final String category;
  final AlertType type;
  final double currentAmount;
  final double maxAmount;
  final double percentage;
  final DateTime createdAt;
  final bool isRead;

  Alert({
    required this.id,
    required this.category,
    required this.type,
    required this.currentAmount,
    required this.maxAmount,
    required this.percentage,
    required this.createdAt,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'type': type.toString(),
      'currentAmount': currentAmount,
      'maxAmount': maxAmount,
      'percentage': percentage,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      category: json['category'],
      type: json['type'] == 'AlertType.exceeded' ? AlertType.exceeded : AlertType.warning,
      currentAmount: json['currentAmount'].toDouble(),
      maxAmount: json['maxAmount'].toDouble(),
      percentage: json['percentage'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }

  Alert copyWith({
    String? id,
    String? category,
    AlertType? type,
    double? currentAmount,
    double? maxAmount,
    double? percentage,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return Alert(
      id: id ?? this.id,
      category: category ?? this.category,
      type: type ?? this.type,
      currentAmount: currentAmount ?? this.currentAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      percentage: percentage ?? this.percentage,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

