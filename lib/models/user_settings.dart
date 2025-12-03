/// Período de reinicio del balance
enum BalanceResetPeriod {
  daily, // Diario
  weekly, // Semanal
  monthly, // Mensual
  total, // Total (sin reinicio)
}

extension BalanceResetPeriodExtension on BalanceResetPeriod {
  String get displayName {
    switch (this) {
      case BalanceResetPeriod.daily:
        return 'Diario';
      case BalanceResetPeriod.weekly:
        return 'Semanal';
      case BalanceResetPeriod.monthly:
        return 'Mensual';
      case BalanceResetPeriod.total:
        return 'Total';
    }
  }

  String get displayNameShort {
    switch (this) {
      case BalanceResetPeriod.daily:
        return 'Hoy';
      case BalanceResetPeriod.weekly:
        return 'Esta semana';
      case BalanceResetPeriod.monthly:
        return 'Este mes';
      case BalanceResetPeriod.total:
        return 'Total acumulado';
    }
  }
}

/// Configuración del usuario
class UserSettings {
  final String id;
  final int monthStartDay; // Día del mes en que inicia el período (1-28)
  final String currency; // Moneda preferida (USD, EUR, MXN, etc.)
  final String currencySymbol; // Símbolo de moneda ($, €, etc.)
  final String thousandsSeparator; // Separador de miles (',' o '.')
  final String decimalSeparator; // Separador decimal ('.' o ',')
  final bool notificationsEnabled; // Si las notificaciones están habilitadas
  final bool budgetAlertsEnabled; // Alertas de presupuesto
  final bool loanRemindersEnabled; // Recordatorios de préstamos
  final bool savingsRemindersEnabled; // Recordatorios de ahorro
  final bool notificationPermissionAsked; // Si ya se pidieron permisos de notificaciones
  final BalanceResetPeriod balanceResetPeriod; // Período de reinicio del balance
  final int? balanceResetDayOfMonth; // Día del mes para reinicio mensual (1-28)
  final int? balanceResetDayOfWeek; // Día de la semana para reinicio semanal (1=lunes, 7=domingo)
  final String? theme; // Tema de la app
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserSettings({
    required this.id,
    this.monthStartDay = 1,
    this.currency = 'COP',
    this.currencySymbol = '\$',
    this.thousandsSeparator = ',',
    this.decimalSeparator = '.',
    this.notificationsEnabled = true,
    this.budgetAlertsEnabled = true,
    this.loanRemindersEnabled = true,
    this.savingsRemindersEnabled = true,
    this.notificationPermissionAsked = false,
    this.balanceResetPeriod = BalanceResetPeriod.total,
    this.balanceResetDayOfMonth,
    this.balanceResetDayOfWeek,
    this.theme,
    required this.createdAt,
    this.updatedAt,
  });

  /// Configuración por defecto
  factory UserSettings.defaults() {
    return UserSettings(
      id: 'default_user',
      monthStartDay: 1,
      currency: 'COP',
      currencySymbol: '\$',
      thousandsSeparator: ',',
      decimalSeparator: '.',
      notificationsEnabled: true,
      budgetAlertsEnabled: true,
      loanRemindersEnabled: true,
      savingsRemindersEnabled: true,
      notificationPermissionAsked: false,
      balanceResetPeriod: BalanceResetPeriod.total,
      balanceResetDayOfMonth: null,
      balanceResetDayOfWeek: null,
      createdAt: DateTime.now(),
    );
  }

  /// Formatea un número con separadores de miles
  String formatNumber(double number, {int decimals = 2}) {
    final parts = number.toStringAsFixed(decimals).split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    // Agregar separadores de miles
    final buffer = StringBuffer();
    int count = 0;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(thousandsSeparator);
      }
      buffer.write(integerPart[i]);
      count++;
    }

    final formatted = buffer.toString().split('').reversed.join();

    if (decimals > 0) {
      return '$formatted$decimalSeparator$decimalPart';
    }
    return formatted;
  }

  /// Formatea un monto con símbolo de moneda
  String formatCurrency(double amount, {int decimals = 2}) {
    return '$currencySymbol${formatNumber(amount, decimals: decimals)}';
  }

  /// Obtiene la fecha de inicio del período actual basado en monthStartDay
  DateTime getCurrentPeriodStart() {
    final now = DateTime.now();
    final currentDay = now.day;

    if (currentDay >= monthStartDay) {
      // El período actual empezó este mes
      return DateTime(now.year, now.month, monthStartDay);
    } else {
      // El período actual empezó el mes pasado
      final previousMonth = DateTime(now.year, now.month - 1, 1);
      return DateTime(previousMonth.year, previousMonth.month, monthStartDay);
    }
  }

  /// Obtiene la fecha de fin del período actual
  DateTime getCurrentPeriodEnd() {
    final start = getCurrentPeriodStart();
    // El período termina un día antes del inicio del siguiente período
    final nextPeriodStart =
        DateTime(start.year, start.month + 1, monthStartDay);
    return nextPeriodStart.subtract(const Duration(days: 1));
  }

  /// Verifica si una fecha está dentro del período actual
  bool isInCurrentPeriod(DateTime date) {
    final start = getCurrentPeriodStart();
    final end = getCurrentPeriodEnd();
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }

  /// Obtiene el rango del período para una fecha específica
  DateRange getPeriodForDate(DateTime date) {
    // Encontrar el inicio del período que contiene esta fecha
    int year = date.year;
    int month = date.month;

    if (date.day < monthStartDay) {
      // La fecha está antes del día de inicio, pertenece al período anterior
      if (month == 1) {
        year -= 1;
        month = 12;
      } else {
        month -= 1;
      }
    }

    final start = DateTime(year, month, monthStartDay);
    final nextPeriodStart = DateTime(month == 12 ? year + 1 : year,
        month == 12 ? 1 : month + 1, monthStartDay);
    final end = nextPeriodStart.subtract(const Duration(days: 1));

    return DateRange(start: start, end: end);
  }

  /// Días restantes en el período actual
  int get daysRemainingInPeriod {
    final end = getCurrentPeriodEnd();
    return end.difference(DateTime.now()).inDays;
  }

  /// Días transcurridos en el período actual
  int get daysElapsedInPeriod {
    final start = getCurrentPeriodStart();
    return DateTime.now().difference(start).inDays;
  }

  /// Días totales del período actual
  int get totalDaysInPeriod {
    final start = getCurrentPeriodStart();
    final end = getCurrentPeriodEnd();
    return end.difference(start).inDays + 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monthStartDay': monthStartDay,
      'currency': currency,
      'currencySymbol': currencySymbol,
      'thousandsSeparator': thousandsSeparator,
      'decimalSeparator': decimalSeparator,
      'notificationsEnabled': notificationsEnabled,
      'budgetAlertsEnabled': budgetAlertsEnabled,
      'loanRemindersEnabled': loanRemindersEnabled,
      'savingsRemindersEnabled': savingsRemindersEnabled,
      'notificationPermissionAsked': notificationPermissionAsked,
      'balanceResetPeriod': balanceResetPeriod.name,
      'balanceResetDayOfMonth': balanceResetDayOfMonth,
      'balanceResetDayOfWeek': balanceResetDayOfWeek,
      'theme': theme,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    BalanceResetPeriod resetPeriod = BalanceResetPeriod.total;
    if (json['balanceResetPeriod'] != null) {
      try {
        resetPeriod = BalanceResetPeriod.values.firstWhere(
          (e) => e.name == json['balanceResetPeriod'],
          orElse: () => BalanceResetPeriod.total,
        );
      } catch (_) {
        resetPeriod = BalanceResetPeriod.total;
      }
    }
    
    return UserSettings(
      id: json['id'],
      monthStartDay: json['monthStartDay'] as int? ?? 1,
      currency: json['currency'] as String? ?? 'COP',
      currencySymbol: json['currencySymbol'] as String? ?? '\$',
      thousandsSeparator: json['thousandsSeparator'] as String? ?? ',',
      decimalSeparator: json['decimalSeparator'] as String? ?? '.',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      budgetAlertsEnabled: json['budgetAlertsEnabled'] as bool? ?? true,
      loanRemindersEnabled: json['loanRemindersEnabled'] as bool? ?? true,
      savingsRemindersEnabled: json['savingsRemindersEnabled'] as bool? ?? true,
      notificationPermissionAsked: json['notificationPermissionAsked'] as bool? ?? false,
      balanceResetPeriod: resetPeriod,
      balanceResetDayOfMonth: json['balanceResetDayOfMonth'] as int?,
      balanceResetDayOfWeek: json['balanceResetDayOfWeek'] as int?,
      theme: json['theme'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  UserSettings copyWith({
    String? id,
    int? monthStartDay,
    String? currency,
    String? currencySymbol,
    String? thousandsSeparator,
    String? decimalSeparator,
    bool? notificationsEnabled,
    bool? budgetAlertsEnabled,
    bool? loanRemindersEnabled,
    bool? savingsRemindersEnabled,
    bool? notificationPermissionAsked,
    BalanceResetPeriod? balanceResetPeriod,
    int? balanceResetDayOfMonth,
    int? balanceResetDayOfWeek,
    String? theme,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      id: id ?? this.id,
      monthStartDay: monthStartDay ?? this.monthStartDay,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      thousandsSeparator: thousandsSeparator ?? this.thousandsSeparator,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
      loanRemindersEnabled: loanRemindersEnabled ?? this.loanRemindersEnabled,
      savingsRemindersEnabled:
          savingsRemindersEnabled ?? this.savingsRemindersEnabled,
      notificationPermissionAsked: notificationPermissionAsked ?? this.notificationPermissionAsked,
      balanceResetPeriod: balanceResetPeriod ?? this.balanceResetPeriod,
      balanceResetDayOfMonth: balanceResetDayOfMonth ?? this.balanceResetDayOfMonth,
      balanceResetDayOfWeek: balanceResetDayOfWeek ?? this.balanceResetDayOfWeek,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Modelo para rangos de fechas
class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({required this.start, required this.end});

  bool contains(DateTime date) {
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
        date.isBefore(end.add(const Duration(days: 1)));
  }

  int get totalDays => end.difference(start).inDays + 1;
}
