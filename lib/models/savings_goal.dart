/// Estado de una meta de ahorro
enum SavingsGoalStatus {
  active,     // En progreso
  completed,  // Completada
  cancelled,  // Cancelada
}

/// Frecuencia de aportes para metas de ahorro
enum ContributionFrequency {
  daily,      // Diario
  weekly,     // Semanal
  biweekly,   // Quincenal
  monthly,    // Mensual
  custom,     // Personalizado
}

/// Extensión para nombres de frecuencia
extension ContributionFrequencyExtension on ContributionFrequency {
  String get displayName {
    switch (this) {
      case ContributionFrequency.daily:
        return 'Diario';
      case ContributionFrequency.weekly:
        return 'Semanal';
      case ContributionFrequency.biweekly:
        return 'Quincenal';
      case ContributionFrequency.monthly:
        return 'Mensual';
      case ContributionFrequency.custom:
        return 'Personalizado';
    }
  }
}

/// Modelo para metas de ahorro
class SavingsGoal {
  final String id;
  final String name;
  final String? description;
  final double targetAmount;     // Monto objetivo
  final double currentAmount;    // Monto ahorrado actualmente
  final DateTime createdAt;
  final DateTime? targetDate;    // Fecha límite opcional
  final SavingsGoalStatus status;
  final String? iconName;        // Icono para la meta
  final String? color;           // Color de la meta
  final ContributionFrequency contributionFrequency; // Frecuencia de aportes
  final String? notificationDays;    // Días para notificación según frecuencia
  final String? notificationTime;    // Hora de notificación (HH:mm)

  SavingsGoal({
    required this.id,
    required this.name,
    this.description,
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.createdAt,
    this.targetDate,
    this.status = SavingsGoalStatus.active,
    this.iconName,
    this.color,
    this.contributionFrequency = ContributionFrequency.monthly,
    this.notificationDays,
    this.notificationTime,
  });

  /// Porcentaje de progreso (0-100)
  double get progressPercentage {
    if (targetAmount <= 0) return 0;
    final percentage = (currentAmount / targetAmount) * 100;
    return percentage > 100 ? 100 : percentage;
  }

  /// Monto restante para completar la meta
  double get remainingAmount {
    final remaining = targetAmount - currentAmount;
    return remaining > 0 ? remaining : 0;
  }

  /// Si la meta está completada
  bool get isCompleted => currentAmount >= targetAmount;

  /// Días restantes hasta la fecha límite
  int? get daysRemaining {
    if (targetDate == null) return null;
    final difference = targetDate!.difference(DateTime.now()).inDays;
    return difference > 0 ? difference : 0;
  }

  /// Ahorro diario requerido para alcanzar la meta
  double? get dailySavingsRequired {
    if (targetDate == null || isCompleted) return null;
    final days = daysRemaining;
    if (days == null || days <= 0) return remainingAmount;
    return remainingAmount / days;
  }

  /// Lista de días de notificación
  List<int> get notificationDaysList {
    if (notificationDays == null || notificationDays!.isEmpty) return [];
    return notificationDays!.split(',').map((s) => int.tryParse(s.trim()) ?? 0).where((d) => d > 0).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'createdAt': createdAt.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'status': status.name,
      'iconName': iconName,
      'color': color,
      'contributionFrequency': contributionFrequency.name,
      'notificationDays': notificationDays,
      'notificationTime': notificationTime,
    };
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      targetDate: json['targetDate'] != null 
          ? DateTime.parse(json['targetDate']) 
          : null,
      status: SavingsGoalStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => SavingsGoalStatus.active,
      ),
      iconName: json['iconName'],
      color: json['color'],
      contributionFrequency: ContributionFrequency.values.firstWhere(
        (f) => f.name == json['contributionFrequency'],
        orElse: () => ContributionFrequency.monthly,
      ),
      notificationDays: json['notificationDays'] as String?,
      notificationTime: json['notificationTime'] as String?,
    );
  }

  SavingsGoal copyWith({
    String? id,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? createdAt,
    DateTime? targetDate,
    SavingsGoalStatus? status,
    String? iconName,
    String? color,
    ContributionFrequency? contributionFrequency,
    Object? notificationDays = _sentinel,
    Object? notificationTime = _sentinel,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      createdAt: createdAt ?? this.createdAt,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      contributionFrequency: contributionFrequency ?? this.contributionFrequency,
      notificationDays: notificationDays == _sentinel 
          ? this.notificationDays 
          : notificationDays as String?,
      notificationTime: notificationTime == _sentinel
          ? this.notificationTime
          : notificationTime as String?,
    );
  }
}

// Sentinel para distinguir "no pasado" de "null explícito"
const _sentinel = Object();

/// Modelo para contribuciones a metas de ahorro
class SavingsContribution {
  final String id;
  final String savingsGoalId;
  final double amount;
  final DateTime date;
  final String? note;

  SavingsContribution({
    required this.id,
    required this.savingsGoalId,
    required this.amount,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'savingsGoalId': savingsGoalId,
      'amount': amount,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory SavingsContribution.fromJson(Map<String, dynamic> json) {
    return SavingsContribution(
      id: json['id'],
      savingsGoalId: json['savingsGoalId'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      note: json['note'],
    );
  }
}
