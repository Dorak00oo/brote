enum TransactionType {
  income,
  expense,
}

// Tipo de pago
enum PaymentType {
  full,        // Pago entero
  partial,     // Abono
  installment, // Cuota
}

// Método de pago/cobro
enum PaymentMethod {
  cash,     // Efectivo
  transfer, // Transferencia
}

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String? description;
  final String? source; // Fuente de ingreso (salario, freelance, inversiones, bonos)
  
  // Campos opcionales de tipo de pago
  final PaymentType? paymentType; // Tipo de pago (entero, abono, cuota)
  final int? installmentNumber;   // Número de cuota si es tipo cuota
  final int? totalInstallments;   // Total de cuotas si es tipo cuota
  
  // Campos opcionales de método de ingreso
  final PaymentMethod? paymentMethod; // Efectivo o transferencia
  final String? sourceBank;           // Banco de origen (transferencia)
  final String? destinationAccount;   // Cuenta destino (banco, alcancía, bolsillo)

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    this.source,
    this.paymentType,
    this.installmentNumber,
    this.totalInstallments,
    this.paymentMethod,
    this.sourceBank,
    this.destinationAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.toString(),
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
      'source': source,
      'paymentType': paymentType?.toString(),
      'installmentNumber': installmentNumber,
      'totalInstallments': totalInstallments,
      'paymentMethod': paymentMethod?.toString(),
      'sourceBank': sourceBank,
      'destinationAccount': destinationAccount,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      type: json['type'] == 'TransactionType.income'
          ? TransactionType.income
          : TransactionType.expense,
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      source: json['source'],
      paymentType: json['paymentType'] != null
          ? PaymentType.values.firstWhere(
              (e) => e.toString() == json['paymentType'],
              orElse: () => PaymentType.full,
            )
          : null,
      installmentNumber: json['installmentNumber'],
      totalInstallments: json['totalInstallments'],
      paymentMethod: json['paymentMethod'] != null
          ? PaymentMethod.values.firstWhere(
              (e) => e.toString() == json['paymentMethod'],
              orElse: () => PaymentMethod.cash,
            )
          : null,
      sourceBank: json['sourceBank'],
      destinationAccount: json['destinationAccount'],
    );
  }

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
    String? description,
    String? source,
    PaymentType? paymentType,
    int? installmentNumber,
    int? totalInstallments,
    PaymentMethod? paymentMethod,
    String? sourceBank,
    String? destinationAccount,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      source: source ?? this.source,
      paymentType: paymentType ?? this.paymentType,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      sourceBank: sourceBank ?? this.sourceBank,
      destinationAccount: destinationAccount ?? this.destinationAccount,
    );
  }
}

