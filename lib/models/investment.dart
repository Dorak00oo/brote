import 'dart:math' as math;
// Reusar el enum de periodicidad de loan.dart
import 'loan.dart' show InterestRatePeriod, InterestRatePeriodExtension;
// Re-exportarlo para que esté disponible cuando se importe investment.dart
export 'loan.dart' show InterestRatePeriod, InterestRatePeriodExtension;

/// Tipo de inversión
enum InvestmentType {
  stocks,       // Acciones
  bonds,        // Bonos
  crypto,       // Criptomonedas
  realEstate,   // Bienes raíces
  mutualFunds,  // Fondos mutuos
  etf,          // ETFs
  forex,        // Divisas
  commodities,  // Materias primas
  savings,      // Cuenta de ahorro con intereses
  other,        // Otros
}

/// Estado de una inversión
enum InvestmentStatus {
  active,     // Inversión activa
  sold,       // Vendida/Liquidada
  cancelled,  // Cancelada
}

/// Modelo para inversiones
class Investment {
  final String id;
  final String name;
  final String? description;
  final InvestmentType type;
  final double initialAmount;           // Monto inicial invertido
  final double currentValue;            // Valor actual
  final double expectedReturnRate;      // Tasa de rentabilidad esperada
  final InterestRatePeriod returnRatePeriod; // Periodicidad de la tasa
  final DateTime purchaseDate;          // Fecha de compra/inversión
  final DateTime? soldDate;             // Fecha de venta (si aplica)
  final double? soldAmount;             // Monto de venta (si aplica)
  final InvestmentStatus status;
  final String? platformOrBroker;       // Plataforma o broker
  final String? notes;
  final int? compoundingFrequency;      // Frecuencia de capitalización (veces al año)
  final String? iconName;               // Icono de la inversión
  final String? color;                  // Color de la inversión (hex)
  final String? notificationDays;       // Días del mes para notificación (ej: "1,15,28")
  final String? notificationTime;       // Hora de notificación (HH:mm)

  Investment({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.initialAmount,
    required this.currentValue,
    required this.expectedReturnRate,
    this.returnRatePeriod = InterestRatePeriod.yearly,
    required this.purchaseDate,
    this.soldDate,
    this.soldAmount,
    this.status = InvestmentStatus.active,
    this.platformOrBroker,
    this.notes,
    this.compoundingFrequency = 12, // Mensual por defecto
    this.iconName,
    this.color,
    this.notificationDays,
    this.notificationTime,
  });

  /// Obtener la tasa de rentabilidad convertida a anual
  double get annualReturnRate {
    return expectedReturnRate * returnRatePeriod.periodsPerYear;
  }

  /// Ganancia/Pérdida absoluta
  double get absoluteReturn => currentValue - initialAmount;

  /// Ganancia/Pérdida porcentual
  double get percentageReturn {
    if (initialAmount <= 0) return 0;
    return ((currentValue - initialAmount) / initialAmount) * 100;
  }

  /// Si la inversión tiene ganancia
  bool get isProfit => currentValue > initialAmount;

  /// Tiempo en días desde la compra
  int get daysHeld {
    final endDate = soldDate ?? DateTime.now();
    return endDate.difference(purchaseDate).inDays;
  }

  /// Rendimiento anualizado
  double get annualizedReturn {
    if (daysHeld <= 0 || initialAmount <= 0) return 0;
    final years = daysHeld / 365;
    if (years <= 0) return percentageReturn;
    return (((currentValue / initialAmount) - 1) / years) * 100;
  }

  /// Valor futuro proyectado basado en tasa de retorno esperada
  double projectedValue(int months) {
    if (status != InvestmentStatus.active) return currentValue;
    // Usar la tasa anualizada para los cálculos
    final rate = annualReturnRate / 100;
    final n = compoundingFrequency ?? 12;
    final t = months / 12;
    // Fórmula de interés compuesto: A = P(1 + r/n)^(nt)
    return currentValue * math.pow(1 + (rate / n), n * t);
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
      'type': type.name,
      'initialAmount': initialAmount,
      'currentValue': currentValue,
      'expectedReturnRate': expectedReturnRate,
      'returnRatePeriod': returnRatePeriod.name,
      'purchaseDate': purchaseDate.toIso8601String(),
      'soldDate': soldDate?.toIso8601String(),
      'soldAmount': soldAmount,
      'status': status.name,
      'platformOrBroker': platformOrBroker,
      'notes': notes,
      'compoundingFrequency': compoundingFrequency,
      'iconName': iconName,
      'color': color,
      'notificationDays': notificationDays,
      'notificationTime': notificationTime,
    };
  }

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: InvestmentType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => InvestmentType.other,
      ),
      initialAmount: (json['initialAmount'] as num).toDouble(),
      currentValue: (json['currentValue'] as num).toDouble(),
      expectedReturnRate: (json['expectedReturnRate'] as num).toDouble(),
      returnRatePeriod: InterestRatePeriod.values.firstWhere(
        (p) => p.name == json['returnRatePeriod'],
        orElse: () => InterestRatePeriod.yearly,
      ),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      soldDate: json['soldDate'] != null 
          ? DateTime.parse(json['soldDate']) 
          : null,
      soldAmount: json['soldAmount'] != null 
          ? (json['soldAmount'] as num).toDouble() 
          : null,
      status: InvestmentStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => InvestmentStatus.active,
      ),
      platformOrBroker: json['platformOrBroker'],
      notes: json['notes'],
      compoundingFrequency: json['compoundingFrequency'] as int?,
      iconName: json['iconName'],
      color: json['color'],
      notificationDays: json['notificationDays'] as String?,
      notificationTime: json['notificationTime'] as String?,
    );
  }

  Investment copyWith({
    String? id,
    String? name,
    String? description,
    InvestmentType? type,
    double? initialAmount,
    double? currentValue,
    double? expectedReturnRate,
    InterestRatePeriod? returnRatePeriod,
    DateTime? purchaseDate,
    DateTime? soldDate,
    double? soldAmount,
    InvestmentStatus? status,
    String? platformOrBroker,
    String? notes,
    int? compoundingFrequency,
    String? iconName,
    String? color,
    Object? notificationDays = _investmentSentinel,
    Object? notificationTime = _investmentSentinel,
  }) {
    return Investment(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      initialAmount: initialAmount ?? this.initialAmount,
      currentValue: currentValue ?? this.currentValue,
      expectedReturnRate: expectedReturnRate ?? this.expectedReturnRate,
      returnRatePeriod: returnRatePeriod ?? this.returnRatePeriod,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      soldDate: soldDate ?? this.soldDate,
      soldAmount: soldAmount ?? this.soldAmount,
      status: status ?? this.status,
      platformOrBroker: platformOrBroker ?? this.platformOrBroker,
      notes: notes ?? this.notes,
      compoundingFrequency: compoundingFrequency ?? this.compoundingFrequency,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      notificationDays: notificationDays == _investmentSentinel 
          ? this.notificationDays 
          : notificationDays as String?,
      notificationTime: notificationTime == _investmentSentinel
          ? this.notificationTime
          : notificationTime as String?,
    );
  }
}

// Sentinel para distinguir "no pasado" de "null explícito"
const _investmentSentinel = Object();

/// Modelo para historial de valores de inversión
class InvestmentValueHistory {
  final String id;
  final String investmentId;
  final double value;
  final DateTime date;

  InvestmentValueHistory({
    required this.id,
    required this.investmentId,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'investmentId': investmentId,
      'value': value,
      'date': date.toIso8601String(),
    };
  }

  factory InvestmentValueHistory.fromJson(Map<String, dynamic> json) {
    return InvestmentValueHistory(
      id: json['id'],
      investmentId: json['investmentId'],
      value: (json['value'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
