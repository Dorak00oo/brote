import 'dart:math' as math;

/// Tipo de préstamo
enum LoanType {
  given,      // Préstamo que yo di (me deben)
  received,   // Préstamo que recibí (yo debo)
}

/// Estado del préstamo
enum LoanStatus {
  active,     // Préstamo activo
  paidOff,    // Pagado completamente
  defaulted,  // Incumplido
  cancelled,  // Cancelado
}

/// Frecuencia de pago
enum PaymentFrequency {
  weekly,     // Semanal
  biweekly,   // Quincenal
  monthly,    // Mensual
  quarterly,  // Trimestral
  yearly,     // Anual
  custom,     // Personalizado
}

/// Modelo para préstamos
class Loan {
  final String id;
  final String name;                    // Nombre/Descripción del préstamo
  final String? borrowerOrLender;       // Nombre del prestatario o prestamista
  final LoanType type;
  final double principalAmount;         // Monto principal
  final double interestRate;            // Tasa de interés (% anual)
  final int totalInstallments;          // Número total de cuotas
  final double installmentAmount;       // Monto por cuota
  final DateTime startDate;             // Fecha de inicio
  final DateTime? endDate;              // Fecha de finalización esperada
  final PaymentFrequency paymentFrequency;
  final LoanStatus status;
  final String? notes;
  final double paidAmount;              // Monto total pagado hasta ahora
  final int paidInstallments;           // Cuotas pagadas
  final String? iconName;               // Icono del préstamo
  final String? color;                  // Color del préstamo (hex)
  final String? notificationDays;       // Días del mes para notificación (ej: "1,15,28")

  Loan({
    required this.id,
    required this.name,
    this.borrowerOrLender,
    required this.type,
    required this.principalAmount,
    required this.interestRate,
    required this.totalInstallments,
    required this.installmentAmount,
    required this.startDate,
    this.endDate,
    this.paymentFrequency = PaymentFrequency.monthly,
    this.status = LoanStatus.active,
    this.notes,
    this.paidAmount = 0.0,
    this.paidInstallments = 0,
    this.iconName,
    this.color,
    this.notificationDays,
  });

  /// Monto total a pagar (principal + intereses)
  double get totalAmount => installmentAmount * totalInstallments;

  /// Total de intereses
  double get totalInterest => totalAmount - principalAmount;

  /// Monto restante por pagar
  double get remainingAmount => totalAmount - paidAmount;

  /// Cuotas restantes
  int get remainingInstallments => totalInstallments - paidInstallments;

  /// Porcentaje pagado
  double get paidPercentage {
    if (totalAmount <= 0) return 0;
    return (paidAmount / totalAmount) * 100;
  }

  /// Si el préstamo está completamente pagado
  bool get isPaidOff => paidAmount >= totalAmount || status == LoanStatus.paidOff;

  /// Próxima fecha de pago
  DateTime? get nextPaymentDate {
    if (isPaidOff) return null;
    
    final daysBetween = _getDaysBetweenPayments();
    return startDate.add(Duration(days: daysBetween * (paidInstallments + 1)));
  }

  int _getDaysBetweenPayments() {
    switch (paymentFrequency) {
      case PaymentFrequency.weekly:
        return 7;
      case PaymentFrequency.biweekly:
        return 14;
      case PaymentFrequency.monthly:
        return 30;
      case PaymentFrequency.quarterly:
        return 90;
      case PaymentFrequency.yearly:
        return 365;
      case PaymentFrequency.custom:
        return 30; // Por defecto mensual
    }
  }

  /// Lista de días de notificación
  List<int> get notificationDaysList {
    if (notificationDays == null || notificationDays!.isEmpty) return [];
    return notificationDays!.split(',').map((s) => int.tryParse(s.trim()) ?? 0).where((d) => d > 0).toList();
  }

  /// Calcular cuota mensual usando fórmula de amortización
  static double calculateInstallment({
    required double principal,
    required double annualInterestRate,
    required int totalInstallments,
    PaymentFrequency frequency = PaymentFrequency.monthly,
  }) {
    if (annualInterestRate == 0) {
      return principal / totalInstallments;
    }

    // Convertir tasa anual a tasa del período
    final periodsPerYear = _getPeriodsPerYear(frequency);
    final periodRate = annualInterestRate / 100 / periodsPerYear;

    // Fórmula de cuota: M = P * [r(1+r)^n] / [(1+r)^n - 1]
    final numerator = periodRate * math.pow(1 + periodRate, totalInstallments);
    final denominator = math.pow(1 + periodRate, totalInstallments) - 1;

    return principal * (numerator / denominator);
  }

  static int _getPeriodsPerYear(PaymentFrequency frequency) {
    switch (frequency) {
      case PaymentFrequency.weekly:
        return 52;
      case PaymentFrequency.biweekly:
        return 26;
      case PaymentFrequency.monthly:
        return 12;
      case PaymentFrequency.quarterly:
        return 4;
      case PaymentFrequency.yearly:
        return 1;
      case PaymentFrequency.custom:
        return 12;
    }
  }

  /// Generar tabla de amortización
  List<AmortizationEntry> generateAmortizationTable() {
    final entries = <AmortizationEntry>[];
    double balance = principalAmount;
    final periodsPerYear = _getPeriodsPerYear(paymentFrequency);
    final periodRate = interestRate / 100 / periodsPerYear;
    final daysBetween = _getDaysBetweenPayments();

    for (int i = 1; i <= totalInstallments; i++) {
      final interest = balance * periodRate;
      final principal = installmentAmount - interest;
      balance -= principal;
      
      entries.add(AmortizationEntry(
        installmentNumber: i,
        date: startDate.add(Duration(days: daysBetween * i)),
        installmentAmount: installmentAmount,
        principalPortion: principal,
        interestPortion: interest,
        remainingBalance: balance > 0 ? balance : 0,
        isPaid: i <= paidInstallments,
      ));
    }

    return entries;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'borrowerOrLender': borrowerOrLender,
      'type': type.name,
      'principalAmount': principalAmount,
      'interestRate': interestRate,
      'totalInstallments': totalInstallments,
      'installmentAmount': installmentAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'paymentFrequency': paymentFrequency.name,
      'status': status.name,
      'notes': notes,
      'paidAmount': paidAmount,
      'paidInstallments': paidInstallments,
      'iconName': iconName,
      'color': color,
      'notificationDays': notificationDays,
    };
  }

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      name: json['name'],
      borrowerOrLender: json['borrowerOrLender'],
      type: LoanType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => LoanType.received,
      ),
      principalAmount: (json['principalAmount'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      totalInstallments: json['totalInstallments'] as int,
      installmentAmount: (json['installmentAmount'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate']) 
          : null,
      paymentFrequency: PaymentFrequency.values.firstWhere(
        (f) => f.name == json['paymentFrequency'],
        orElse: () => PaymentFrequency.monthly,
      ),
      status: LoanStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => LoanStatus.active,
      ),
      notes: json['notes'],
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      paidInstallments: json['paidInstallments'] as int? ?? 0,
      iconName: json['iconName'],
      color: json['color'],
      notificationDays: json['notificationDays'] as String?,
    );
  }

  Loan copyWith({
    String? id,
    String? name,
    String? borrowerOrLender,
    LoanType? type,
    double? principalAmount,
    double? interestRate,
    int? totalInstallments,
    double? installmentAmount,
    DateTime? startDate,
    DateTime? endDate,
    PaymentFrequency? paymentFrequency,
    LoanStatus? status,
    String? notes,
    double? paidAmount,
    int? paidInstallments,
    String? iconName,
    String? color,
    Object? notificationDays = _loanSentinel,
  }) {
    return Loan(
      id: id ?? this.id,
      name: name ?? this.name,
      borrowerOrLender: borrowerOrLender ?? this.borrowerOrLender,
      type: type ?? this.type,
      principalAmount: principalAmount ?? this.principalAmount,
      interestRate: interestRate ?? this.interestRate,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      paidAmount: paidAmount ?? this.paidAmount,
      paidInstallments: paidInstallments ?? this.paidInstallments,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      notificationDays: notificationDays == _loanSentinel 
          ? this.notificationDays 
          : notificationDays as String?,
    );
  }
}

// Sentinel para distinguir "no pasado" de "null explícito"
const _loanSentinel = Object();

/// Entrada de la tabla de amortización
class AmortizationEntry {
  final int installmentNumber;
  final DateTime date;
  final double installmentAmount;
  final double principalPortion;
  final double interestPortion;
  final double remainingBalance;
  final bool isPaid;

  AmortizationEntry({
    required this.installmentNumber,
    required this.date,
    required this.installmentAmount,
    required this.principalPortion,
    required this.interestPortion,
    required this.remainingBalance,
    required this.isPaid,
  });
}

/// Modelo para pagos de préstamos
class LoanPayment {
  final String id;
  final String loanId;
  final double amount;
  final DateTime date;
  final int installmentNumber;
  final String? notes;

  LoanPayment({
    required this.id,
    required this.loanId,
    required this.amount,
    required this.date,
    required this.installmentNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loanId': loanId,
      'amount': amount,
      'date': date.toIso8601String(),
      'installmentNumber': installmentNumber,
      'notes': notes,
    };
  }

  factory LoanPayment.fromJson(Map<String, dynamic> json) {
    return LoanPayment(
      id: json['id'],
      loanId: json['loanId'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      installmentNumber: json['installmentNumber'] as int,
      notes: json['notes'],
    );
  }
}
