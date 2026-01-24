import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../models/transaction.dart' as models;
import '../models/budget.dart' as models;
import '../models/alert.dart' as models;
import '../models/savings_goal.dart' as models;
import '../models/investment.dart' as models;
import '../models/loan.dart' as models;
import '../models/user_settings.dart' as models;
import '../database/app_database.dart';
import '../database/app_database.dart' as db;
import '../services/notification_service.dart';

class FinanceService extends ChangeNotifier {
  final AppDatabase _db;

  // Datos en memoria
  List<models.Transaction> _transactions = [];
  List<String> _customCategories = [];
  List<String> _customIncomeSources = [];
  List<String> _hiddenDefaultCategories = [];
  List<String> _hiddenDefaultIncomeSources = [];
  List<models.Budget> _budgets = [];
  List<models.Alert> _alerts = [];
  List<models.SavingsGoal> _savingsGoals = [];
  List<models.Investment> _investments = [];
  List<models.Loan> _loans = [];
  models.UserSettings? _userSettings;
  double _balance = 0.0;

  // ========== GETTERS ==========
  List<models.Transaction> get transactions => _transactions;
  List<String> get customCategories => _customCategories;
  List<String> get customIncomeSources => _customIncomeSources;
  List<models.Budget> get budgets => _budgets;
  List<models.Alert> get alerts => _alerts.where((a) => !a.isRead).toList();
  List<models.Alert> get allAlerts => _alerts;
  List<models.SavingsGoal> get savingsGoals => _savingsGoals;
  List<models.SavingsGoal> get activeSavingsGoals => _savingsGoals
      .where((s) => s.status == models.SavingsGoalStatus.active)
      .toList();
  List<models.Investment> get investments => _investments;
  List<models.Investment> get activeInvestments => _investments
      .where((i) => i.status == models.InvestmentStatus.active)
      .toList();
  List<models.Loan> get loans => _loans;
  List<models.Loan> get activeLoans =>
      _loans.where((l) => l.status == models.LoanStatus.active).toList();
  models.UserSettings get userSettings =>
      _userSettings ?? models.UserSettings.defaults();
  // Día de inicio del mes configurado por el usuario
  int get monthStartDay => _userSettings?.monthStartDay ?? 1;

  // ========== CATEGORÍAS PREDEFINIDAS ==========
  static const List<String> defaultExpenseCategories = [
    'Alimentación',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Educación',
    'Compras',
    'Servicios',
    'Vivienda',
    'Otros',
  ];

  static const List<String> defaultIncomeSources = [
    'Salario',
    'Freelance',
    'Inversiones',
    'Bonos',
    'Intereses',
    'Alquiler',
    'Otros',
  ];

  static const List<String> investmentTypes = [
    'Acciones',
    'Bonos',
    'Criptomonedas',
    'Bienes Raíces',
    'Fondos Mutuos',
    'ETFs',
    'Divisas (Forex)',
    'Materias Primas',
    'Cuenta de Ahorro',
    'Otros',
  ];

  List<String> get allExpenseCategories => [
        ...defaultExpenseCategories.where((c) => !_hiddenDefaultCategories.contains(c)),
        ..._customCategories,
      ];

  List<String> get allIncomeSources => [
        ...defaultIncomeSources.where((s) => !_hiddenDefaultIncomeSources.contains(s)),
        ..._customIncomeSources,
      ];

  // Getters para fuentes/categorías ocultas
  List<String> get hiddenDefaultCategories => _hiddenDefaultCategories;
  List<String> get hiddenDefaultIncomeSources => _hiddenDefaultIncomeSources;

  // ========== TOTALES ==========
  double get totalIncome {
    return _transactions
        .where((t) => t.type == models.TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((t) => t.type == models.TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Obtiene la fecha de inicio del período actual según balanceResetPeriod
  DateTime? _getPeriodStartDate() {
    if (_userSettings == null) return null;
    
    final resetPeriod = _userSettings!.balanceResetPeriod;
    if (resetPeriod == models.BalanceResetPeriod.total) {
      return null; // Sin filtro de período
    }
    
    final now = DateTime.now();
    DateTime startDate;
    
    switch (resetPeriod) {
      case models.BalanceResetPeriod.daily:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case models.BalanceResetPeriod.weekly:
        // Día de la semana configurado (por defecto lunes = 1)
        final configuredDayOfWeek = _userSettings!.balanceResetDayOfWeek ?? 1;
        final weekday = now.weekday;
        // Calcular días desde el día configurado de esta semana
        int daysFromConfiguredDay;
        if (weekday >= configuredDayOfWeek) {
          daysFromConfiguredDay = weekday - configuredDayOfWeek;
        } else {
          // Si el día actual es anterior al día configurado, ir a la semana pasada
          daysFromConfiguredDay = weekday + (7 - configuredDayOfWeek);
        }
        startDate = now.subtract(Duration(days: daysFromConfiguredDay));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case models.BalanceResetPeriod.monthly:
        // Día del mes configurado (por defecto día 1)
        final configuredDayOfMonth = _userSettings!.balanceResetDayOfMonth ?? 1;
        if (now.day >= configuredDayOfMonth) {
          // El período actual empezó este mes
          startDate = DateTime(now.year, now.month, configuredDayOfMonth);
        } else {
          // El período actual empezó el mes pasado
          final previousMonth = DateTime(now.year, now.month - 1, 1);
          startDate = DateTime(previousMonth.year, previousMonth.month, configuredDayOfMonth);
        }
        break;
      case models.BalanceResetPeriod.total:
        return null;
    }
    
    return startDate;
  }

  /// Obtiene la fecha de fin del período actual según balanceResetPeriod
  DateTime? _getPeriodEndDate() {
    final startDate = _getPeriodStartDate();
    if (startDate == null) return null;
    
    final resetPeriod = _userSettings!.balanceResetPeriod;
    final now = DateTime.now();
    
    switch (resetPeriod) {
      case models.BalanceResetPeriod.daily:
        // Fin del día actual
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case models.BalanceResetPeriod.weekly:
        // Fin de la semana (6 días después del inicio)
        final endDate = startDate.add(const Duration(days: 6));
        return DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      case models.BalanceResetPeriod.monthly:
        // Calcular el inicio del siguiente período mensual
        DateTime nextPeriodStart;
        if (startDate.month == 12) {
          nextPeriodStart = DateTime(startDate.year + 1, 1, startDate.day);
        } else {
          nextPeriodStart = DateTime(startDate.year, startDate.month + 1, startDate.day);
        }
        // Fin del período es un día antes del inicio del siguiente
        final endDate = nextPeriodStart.subtract(const Duration(days: 1));
        return DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
      case models.BalanceResetPeriod.total:
        return null;
    }
  }

  // Ingresos y gastos del período actual (respetando balanceResetPeriod)
  double get periodIncome {
    final startDate = _getPeriodStartDate();
    final endDate = _getPeriodEndDate();
    
    // Si no hay filtro de período, retornar todos los ingresos
    if (startDate == null || endDate == null) {
      return _transactions
          .where((t) => t.type == models.TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);
    }
    
    return _transactions
        .where((t) {
          if (t.type != models.TransactionType.income) return false;
          final tDate = DateTime(t.date.year, t.date.month, t.date.day);
          final start = DateTime(startDate.year, startDate.month, startDate.day);
          final end = DateTime(endDate.year, endDate.month, endDate.day);
          return !tDate.isBefore(start) && !tDate.isAfter(end);
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get periodExpenses {
    final startDate = _getPeriodStartDate();
    final endDate = _getPeriodEndDate();
    
    // Si no hay filtro de período, retornar todos los gastos
    if (startDate == null || endDate == null) {
      return _transactions
          .where((t) => t.type == models.TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);
    }
    
    return _transactions
        .where((t) {
          if (t.type != models.TransactionType.expense) return false;
          final tDate = DateTime(t.date.year, t.date.month, t.date.day);
          final start = DateTime(startDate.year, startDate.month, startDate.day);
          final end = DateTime(endDate.year, endDate.month, endDate.day);
          return !tDate.isBefore(start) && !tDate.isAfter(end);
        })
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Alias para compatibilidad
  double get monthlyIncome => periodIncome;
  double get monthlyExpenses => periodExpenses;

  // Total en metas de ahorro
  double get totalSavings {
    return _savingsGoals
        .where((s) => s.status == models.SavingsGoalStatus.active)
        .fold(0.0, (sum, s) => sum + s.currentAmount);
  }

  // Total en inversiones
  double get totalInvestmentsValue {
    return _investments
        .where((i) => i.status == models.InvestmentStatus.active)
        .fold(0.0, (sum, i) => sum + i.currentValue);
  }

  double get totalInvestedAmount {
    return _investments
        .where((i) => i.status == models.InvestmentStatus.active)
        .fold(0.0, (sum, i) => sum + i.initialAmount);
  }

  double get totalInvestmentReturn =>
      totalInvestmentsValue - totalInvestedAmount;

  // Total de deuda (préstamos que debo)
  double get totalDebt {
    return _loans
        .where((l) =>
            l.type == models.LoanType.received &&
            l.status == models.LoanStatus.active)
        .fold(0.0, (sum, l) => sum + l.remainingAmount);
  }

  // Total que me deben
  double get totalReceivables {
    return _loans
        .where((l) =>
            l.type == models.LoanType.given &&
            l.status == models.LoanStatus.active)
        .fold(0.0, (sum, l) => sum + l.remainingAmount);
  }

  // Patrimonio neto
  double get netWorth =>
      balance +
      totalInvestmentsValue +
      totalReceivables -
      totalDebt +
      totalSavings;

  // ========== CONSTRUCTOR ==========
  FinanceService(this._db) {
    _loadData();
    _setupListeners();
  }

  void _setupListeners() {
    _db.watchAllTransactions().listen((dbTransactions) {
      _transactions = dbTransactions.map(_fromDbTransaction).toList();
      _calculateBalance();
      notifyListeners();
    });

    _db.watchAllBudgets().listen((dbBudgets) {
      _budgets = dbBudgets.map(_fromDbBudget).toList();
      notifyListeners();
    });

    _db.watchAllAlerts().listen((dbAlerts) {
      _alerts = dbAlerts.map(_fromDbAlert).toList();
      notifyListeners();
    });

    _db.watchAllCustomCategories().listen((dbCategories) {
      _customCategories = dbCategories.map((c) => c.name).toList();
      notifyListeners();
    });

    _db.watchAllCustomIncomeSources().listen((dbSources) {
      _customIncomeSources = dbSources.map((s) => s.name).toList();
      notifyListeners();
    });

    _db.watchAllSavingsGoals().listen((dbGoals) {
      _savingsGoals = dbGoals.map(_fromDbSavingsGoal).toList();
      notifyListeners();
    });

    _db.watchAllInvestments().listen((dbInvestments) {
      _investments = dbInvestments.map(_fromDbInvestment).toList();
      notifyListeners();
    });

    _db.watchAllLoans().listen((dbLoans) {
      _loans = dbLoans.map(_fromDbLoan).toList();
      notifyListeners();
    });

    _db.watchUserSettings().listen((dbSettings) {
      if (dbSettings != null) {
        _userSettings = _fromDbUserSettings(dbSettings);
        notifyListeners();
      }
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadTransactions(),
      _loadCategories(),
      _loadIncomeSources(),
      _loadHiddenDefaultCategories(),
      _loadHiddenDefaultIncomeSources(),
      _loadBudgets(),
      _loadAlerts(),
      _loadSavingsGoals(),
      _loadInvestments(),
      _loadLoans(),
      _loadUserSettings(),
    ]);
    // Procesar transacciones recurrentes
    await processRecurringTransactions();
  }

  /// Procesar transacciones recurrentes y vincular con finanzas si corresponde
  Future<void> processRecurringTransactions() async {
    await _db.processRecurringTransactions();
    
    // Obtener transacciones recurrentes activas para vincular con finanzas
    final activeRecurring = await _db.getAllRecurringTransactions();
    final now = DateTime.now();
    
    for (final recurring in activeRecurring.where((r) => r.isActive)) {
      // Solo procesar si tiene vinculación y se procesó recientemente
      if (recurring.linkedFinanceModule != null && 
          recurring.lastProcessedDate != null &&
          recurring.lastProcessedDate!.isAfter(now.subtract(const Duration(minutes: 5)))) {
        
        try {
          // Buscar la transacción recién creada
          final recentTransactions = _transactions.where((t) => 
            t.title == recurring.title &&
            t.amount == recurring.amount &&
            t.date.isAfter(now.subtract(const Duration(minutes: 5)))
          ).toList();
          
          if (recentTransactions.isNotEmpty) {
            final transaction = recentTransactions.first;
            
            // Vincular con préstamo
            if (recurring.linkedFinanceModule == 'loan' && recurring.linkedLoanId != null) {
              final allLoans = [...loansReceived, ...loansGiven];
              try {
                final loan = allLoans.firstWhere((l) => l.id == recurring.linkedLoanId);
                await addLoanPayment(
                  recurring.linkedLoanId!,
                  transaction.amount,
                  loan.paidInstallments + 1,
                  date: transaction.date,
                  notes: 'Vinculado desde automático: ${recurring.title}',
                );
              } catch (e) {
                debugPrint('Error al vincular préstamo: $e');
              }
            }
            // Vincular con meta de ahorro
            else if (recurring.linkedFinanceModule == 'savings' && recurring.linkedSavingsGoalId != null) {
              try {
                await addSavingsContribution(
                  recurring.linkedSavingsGoalId!,
                  transaction.amount,
                  date: transaction.date,
                  note: 'Vinculado desde automático: ${recurring.title}',
                );
              } catch (e) {
                debugPrint('Error al vincular ahorro: $e');
              }
            }
          }
        } catch (e) {
          debugPrint('Error al vincular transacción recurrente: $e');
        }
      }
    }
  }

  // ========== CONVERSIÓN DE MODELOS: TRANSACCIONES ==========
  models.Transaction _fromDbTransaction(Transaction db) {
    return models.Transaction(
      id: db.id,
      title: db.title,
      amount: db.amount,
      type: db.type == 'income'
          ? models.TransactionType.income
          : models.TransactionType.expense,
      category: db.category,
      date: db.date,
      description: db.description,
      source: db.source,
      // Nuevos campos
      paymentType: db.paymentType != null
          ? models.PaymentType.values.firstWhere(
              (e) => e.toString() == 'PaymentType.${db.paymentType}',
              orElse: () => models.PaymentType.full,
            )
          : null,
      installmentNumber: db.installmentNumber,
      totalInstallments: db.totalInstallments,
      paymentMethod: db.paymentMethod != null
          ? models.PaymentMethod.values.firstWhere(
              (e) => e.toString() == 'PaymentMethod.${db.paymentMethod}',
              orElse: () => models.PaymentMethod.cash,
            )
          : null,
      sourceBank: db.sourceBank,
      destinationAccount: db.destinationAccount,
    );
  }

  TransactionsCompanion _toDbTransaction(models.Transaction transaction) {
    return TransactionsCompanion(
      id: Value(transaction.id),
      title: Value(transaction.title),
      amount: Value(transaction.amount),
      type: Value(transaction.type == models.TransactionType.income
          ? 'income'
          : 'expense'),
      category: Value(transaction.category),
      date: Value(transaction.date),
      description: Value(transaction.description),
      source: Value(transaction.source),
      // Nuevos campos
      paymentType: Value(transaction.paymentType?.name),
      installmentNumber: Value(transaction.installmentNumber),
      totalInstallments: Value(transaction.totalInstallments),
      paymentMethod: Value(transaction.paymentMethod?.name),
      sourceBank: Value(transaction.sourceBank),
      destinationAccount: Value(transaction.destinationAccount),
    );
  }

  // ========== CONVERSIÓN DE MODELOS: PRESUPUESTOS ==========
  models.Budget _fromDbBudget(Budget db) {
    return models.Budget(
      id: db.id,
      category: db.category,
      maxAmount: db.maxAmount,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
    );
  }

  BudgetsCompanion _toDbBudget(models.Budget budget) {
    return BudgetsCompanion.insert(
      id: budget.id,
      category: budget.category,
      maxAmount: budget.maxAmount,
      createdAt: budget.createdAt,
      updatedAt: Value(budget.updatedAt),
    );
  }

  // ========== CONVERSIÓN DE MODELOS: ALERTAS ==========
  models.Alert _fromDbAlert(Alert db) {
    return models.Alert(
      id: db.id,
      category: db.category,
      type: db.type == 'exceeded'
          ? models.AlertType.exceeded
          : models.AlertType.warning,
      currentAmount: db.currentAmount,
      maxAmount: db.maxAmount,
      percentage: db.percentage,
      createdAt: db.createdAt,
      isRead: db.isRead,
    );
  }

  AlertsCompanion _toDbAlert(models.Alert alert) {
    return AlertsCompanion.insert(
      id: alert.id,
      category: alert.category,
      type: alert.type == models.AlertType.exceeded ? 'exceeded' : 'warning',
      currentAmount: alert.currentAmount,
      maxAmount: alert.maxAmount,
      percentage: alert.percentage,
      createdAt: alert.createdAt,
      isRead: Value(alert.isRead),
    );
  }

  // ========== CONVERSIÓN DE MODELOS: METAS DE AHORRO ==========
  models.SavingsGoal _fromDbSavingsGoal(SavingsGoal db) {
    return models.SavingsGoal(
      id: db.id,
      name: db.name,
      description: db.description,
      targetAmount: db.targetAmount,
      currentAmount: db.currentAmount,
      createdAt: db.createdAt,
      targetDate: db.targetDate,
      status: models.SavingsGoalStatus.values.firstWhere(
        (s) => s.name == db.status,
        orElse: () => models.SavingsGoalStatus.active,
      ),
      iconName: db.iconName,
      color: db.color,
      contributionFrequency: models.ContributionFrequency.values.firstWhere(
        (f) => f.name == db.contributionFrequency,
        orElse: () => models.ContributionFrequency.monthly,
      ),
      notificationDays: db.notificationDays,
      notificationTime: db.notificationTime,
    );
  }

  SavingsGoalsCompanion _toDbSavingsGoal(models.SavingsGoal goal) {
    return SavingsGoalsCompanion.insert(
      id: goal.id,
      name: goal.name,
      description: Value(goal.description),
      targetAmount: goal.targetAmount,
      currentAmount: Value(goal.currentAmount),
      createdAt: goal.createdAt,
      targetDate: Value(goal.targetDate),
      status: Value(goal.status.name),
      iconName: Value(goal.iconName),
      color: Value(goal.color),
      contributionFrequency: Value(goal.contributionFrequency.name),
      notificationDays: Value(goal.notificationDays),
      notificationTime: Value(goal.notificationTime),
    );
  }

  // ========== CONVERSIÓN DE MODELOS: INVERSIONES ==========
  models.Investment _fromDbInvestment(Investment db) {
    return models.Investment(
      id: db.id,
      name: db.name,
      description: db.description,
      type: models.InvestmentType.values.firstWhere(
        (t) => t.name == db.type,
        orElse: () => models.InvestmentType.other,
      ),
      initialAmount: db.initialAmount,
      currentValue: db.currentValue,
      expectedReturnRate: db.expectedReturnRate,
      returnRatePeriod: models.InterestRatePeriod.values.firstWhere(
        (p) => p.name == db.returnRatePeriod,
        orElse: () => models.InterestRatePeriod.yearly,
      ),
      purchaseDate: db.purchaseDate,
      soldDate: db.soldDate,
      soldAmount: db.soldAmount,
      status: models.InvestmentStatus.values.firstWhere(
        (s) => s.name == db.status,
        orElse: () => models.InvestmentStatus.active,
      ),
      platformOrBroker: db.platformOrBroker,
      notes: db.notes,
      compoundingFrequency: db.compoundingFrequency,
      iconName: db.iconName,
      color: db.color,
      notificationDays: db.notificationDays,
      notificationTime: db.notificationTime,
    );
  }

  InvestmentsCompanion _toDbInvestment(models.Investment investment) {
    return InvestmentsCompanion.insert(
      id: investment.id,
      name: investment.name,
      description: Value(investment.description),
      type: investment.type.name,
      initialAmount: investment.initialAmount,
      currentValue: investment.currentValue,
      expectedReturnRate: investment.expectedReturnRate,
      returnRatePeriod: Value(investment.returnRatePeriod.name),
      purchaseDate: investment.purchaseDate,
      soldDate: Value(investment.soldDate),
      soldAmount: Value(investment.soldAmount),
      status: Value(investment.status.name),
      platformOrBroker: Value(investment.platformOrBroker),
      notes: Value(investment.notes),
      compoundingFrequency: Value(investment.compoundingFrequency ?? 12),
      iconName: Value(investment.iconName),
      color: Value(investment.color),
      notificationDays: Value(investment.notificationDays),
      notificationTime: Value(investment.notificationTime),
    );
  }

  // ========== CONVERSIÓN DE MODELOS: PRÉSTAMOS ==========
  models.Loan _fromDbLoan(Loan db) {
    return models.Loan(
      id: db.id,
      name: db.name,
      borrowerOrLender: db.borrowerOrLender,
      type: models.LoanType.values.firstWhere(
        (t) => t.name == db.type,
        orElse: () => models.LoanType.received,
      ),
      principalAmount: db.principalAmount,
      interestRate: db.interestRate,
      interestRatePeriod: models.InterestRatePeriod.values.firstWhere(
        (p) => p.name == db.interestRatePeriod,
        orElse: () => models.InterestRatePeriod.yearly,
      ),
      totalInstallments: db.totalInstallments,
      installmentAmount: db.installmentAmount,
      startDate: db.startDate,
      endDate: db.endDate,
      paymentFrequency: models.PaymentFrequency.values.firstWhere(
        (f) => f.name == db.paymentFrequency,
        orElse: () => models.PaymentFrequency.monthly,
      ),
      status: models.LoanStatus.values.firstWhere(
        (s) => s.name == db.status,
        orElse: () => models.LoanStatus.active,
      ),
      notes: db.notes,
      paidAmount: db.paidAmount,
      paidInstallments: db.paidInstallments,
      iconName: db.iconName,
      color: db.color,
      notificationDays: db.notificationDays,
      notificationDayOfMonth: db.notificationDayOfMonth,
      notificationTime: db.notificationTime,
    );
  }

  LoansCompanion _toDbLoan(models.Loan loan) {
    return LoansCompanion.insert(
      id: loan.id,
      name: loan.name,
      borrowerOrLender: Value(loan.borrowerOrLender),
      type: loan.type.name,
      principalAmount: loan.principalAmount,
      interestRate: loan.interestRate,
      interestRatePeriod: Value(loan.interestRatePeriod.name),
      totalInstallments: loan.totalInstallments,
      installmentAmount: loan.installmentAmount,
      startDate: loan.startDate,
      endDate: Value(loan.endDate),
      paymentFrequency: Value(loan.paymentFrequency.name),
      status: Value(loan.status.name),
      notes: Value(loan.notes),
      paidAmount: Value(loan.paidAmount),
      paidInstallments: Value(loan.paidInstallments),
      iconName: Value(loan.iconName),
      color: Value(loan.color),
      notificationDays: Value(loan.notificationDays),
      notificationDayOfMonth: Value(loan.notificationDayOfMonth),
      notificationTime: Value(loan.notificationTime),
    );
  }

  // ========== CONVERSIÓN DE MODELOS: CONFIGURACIÓN ==========
  models.UserSettings _fromDbUserSettings(UserSettingsTableData db) {
    models.BalanceResetPeriod resetPeriod = models.BalanceResetPeriod.total;
    try {
      resetPeriod = models.BalanceResetPeriod.values.firstWhere(
        (e) => e.name == db.balanceResetPeriod,
        orElse: () => models.BalanceResetPeriod.total,
      );
    } catch (_) {
      resetPeriod = models.BalanceResetPeriod.total;
    }

    models.ColorPalette palette = models.ColorPalette.green;
    try {
      palette = models.ColorPalette.values.firstWhere(
        (e) => e.name == db.colorPalette,
        orElse: () => models.ColorPalette.green,
      );
    } catch (_) {
      palette = models.ColorPalette.green;
    }
    
    return models.UserSettings(
      id: db.id,
      monthStartDay: db.monthStartDay,
      currency: db.currency,
      currencySymbol: db.currencySymbol,
      thousandsSeparator: db.thousandsSeparator,
      decimalSeparator: db.decimalSeparator,
      notificationsEnabled: db.notificationsEnabled,
      budgetAlertsEnabled: db.budgetAlertsEnabled,
      loanRemindersEnabled: db.loanRemindersEnabled,
      savingsRemindersEnabled: db.savingsRemindersEnabled,
      notificationPermissionAsked: db.notificationPermissionAsked,
      balanceResetPeriod: resetPeriod,
      balanceResetDayOfMonth: db.balanceResetDayOfMonth,
      balanceResetDayOfWeek: db.balanceResetDayOfWeek,
      theme: db.theme,
      colorPalette: palette,
      trendChartType: db.trendChartType,
      incomeChartType: db.incomeChartType,
      expenseChartType: db.expenseChartType,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
    );
  }

  // ========== TRANSACCIONES ==========
  Future<void> _loadTransactions() async {
    try {
      final dbTransactions = await _db.getAllTransactions();
      _transactions = dbTransactions.map(_fromDbTransaction).toList();
      _calculateBalance();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    }
  }

  void _calculateBalance() {
    _balance = totalIncome - totalExpenses;
  }

  /// Obtiene el balance según el período configurado
  double get balance {
    if (_userSettings == null) return _balance;
    
    final resetPeriod = _userSettings!.balanceResetPeriod;
    if (resetPeriod == models.BalanceResetPeriod.total) {
      return _balance;
    }
    
    // Calcular el balance solo para el período configurado
    final now = DateTime.now();
    DateTime startDate;
    
    switch (resetPeriod) {
      case models.BalanceResetPeriod.daily:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case models.BalanceResetPeriod.weekly:
        // Día de la semana configurado (por defecto lunes = 1)
        final configuredDayOfWeek = _userSettings!.balanceResetDayOfWeek ?? 1;
        final weekday = now.weekday;
        // Calcular días desde el día configurado de esta semana
        int daysFromConfiguredDay;
        if (weekday >= configuredDayOfWeek) {
          daysFromConfiguredDay = weekday - configuredDayOfWeek;
        } else {
          // Si el día actual es anterior al día configurado, ir a la semana pasada
          daysFromConfiguredDay = weekday + (7 - configuredDayOfWeek);
        }
        startDate = now.subtract(Duration(days: daysFromConfiguredDay));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case models.BalanceResetPeriod.monthly:
        // Día del mes configurado (por defecto día 1)
        final configuredDayOfMonth = _userSettings!.balanceResetDayOfMonth ?? 1;
        if (now.day >= configuredDayOfMonth) {
          // El período actual empezó este mes
          startDate = DateTime(now.year, now.month, configuredDayOfMonth);
        } else {
          // El período actual empezó el mes pasado
          final previousMonth = DateTime(now.year, now.month - 1, 1);
          startDate = DateTime(previousMonth.year, previousMonth.month, configuredDayOfMonth);
        }
        break;
      case models.BalanceResetPeriod.total:
        return _balance;
    }
    
    // Filtrar transacciones del período
    final periodTransactions = _transactions.where((t) {
      final tDate = DateTime(t.date.year, t.date.month, t.date.day);
      return !tDate.isBefore(startDate);
    }).toList();
    
    final periodIncome = periodTransactions
        .where((t) => t.type == models.TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final periodExpenses = periodTransactions
        .where((t) => t.type == models.TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    return periodIncome - periodExpenses;
  }
  
  /// Obtiene el balance total acumulado (sin filtro de período)
  double get totalBalance => _balance;

  Future<void> addTransaction(models.Transaction transaction) async {
    try {
      await _db.insertTransaction(_toDbTransaction(transaction));
      await _checkBudgets(transaction);
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(models.Transaction transaction) async {
    try {
      await _db.updateTransaction(_toDbTransaction(transaction));
      await _checkBudgets(transaction);
      
      // Sincronizar con contribuciones/pagos vinculados
      try {
        // Buscar contribuciones vinculadas
        final allGoals = _savingsGoals;
        for (final goal in allGoals) {
          final contributions = await getSavingsContributions(goal.id);
          final linkedContribution = contributions.firstWhere(
            (c) => c.transactionId == transaction.id,
            orElse: () => throw Exception('Not found'),
          );
          
          // Actualizar la contribución
          final updatedContribution = linkedContribution.copyWith(
            amount: transaction.amount,
            date: transaction.date,
            note: transaction.description,
          );
          await _db.updateSavingsContribution(SavingsContributionsCompanion(
            id: Value(updatedContribution.id),
            savingsGoalId: Value(updatedContribution.savingsGoalId),
            amount: Value(updatedContribution.amount),
            date: Value(updatedContribution.date),
            note: Value(updatedContribution.note),
            transactionId: Value(updatedContribution.transactionId),
          ));
          break; // Solo puede haber una contribución vinculada
        }
      } catch (_) {
        // No hay contribución vinculada, continuar
      }
      
      try {
        // Buscar pagos vinculados
        final allLoans = [...loansReceived, ...loansGiven];
        for (final loan in allLoans) {
          final payments = await getLoanPayments(loan.id);
          final linkedPayment = payments.firstWhere(
            (p) => p.transactionId == transaction.id,
            orElse: () => throw Exception('Not found'),
          );
          
          // Actualizar el pago
          final updatedPayment = linkedPayment.copyWith(
            amount: transaction.amount,
            date: transaction.date,
            notes: transaction.description,
          );
          await _db.updateLoanPayment(LoanPaymentsCompanion(
            id: Value(updatedPayment.id),
            loanId: Value(updatedPayment.loanId),
            amount: Value(updatedPayment.amount),
            date: Value(updatedPayment.date),
            installmentNumber: Value(updatedPayment.installmentNumber),
            notes: Value(updatedPayment.notes),
            transactionId: Value(updatedPayment.transactionId),
          ));
          break; // Solo puede haber un pago vinculado
        }
      } catch (_) {
        // No hay pago vinculado, continuar
      }
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final transaction = _transactions.firstWhere((t) => t.id == id);
      
      // Sincronizar con contribuciones/pagos vinculados
      try {
        // Buscar y eliminar contribuciones vinculadas
        final allGoals = _savingsGoals;
        for (final goal in allGoals) {
          final contributions = await getSavingsContributions(goal.id);
          final linkedContribution = contributions.firstWhere(
            (c) => c.transactionId == transaction.id,
            orElse: () => throw Exception('Not found'),
          );
          
          await _db.deleteSavingsContribution(linkedContribution.id);
          break;
        }
      } catch (_) {
        // No hay contribución vinculada, continuar
      }
      
      try {
        // Buscar y eliminar pagos vinculados
        final allLoans = [...loansReceived, ...loansGiven];
        for (final loan in allLoans) {
          final payments = await getLoanPayments(loan.id);
          final linkedPayment = payments.firstWhere(
            (p) => p.transactionId == transaction.id,
            orElse: () => throw Exception('Not found'),
          );
          
          await _db.deleteLoanPayment(linkedPayment.id);
          break;
        }
      } catch (_) {
        // No hay pago vinculado, continuar
      }
      
      await _db.deleteTransaction(id);
      await _checkBudgets(transaction, isDelete: true);
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  List<models.Transaction> getTransactionsByType(models.TransactionType type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  List<models.Transaction> getRecentTransactions({int limit = 5}) {
    final sorted = List<models.Transaction>.from(_transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  // Transacciones del período actual
  List<models.Transaction> get periodTransactions {
    final start = userSettings.getCurrentPeriodStart();
    final end = userSettings.getCurrentPeriodEnd();
    return _transactions
        .where((t) =>
            t.date.isAfter(start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  // Filtros de búsqueda
  List<models.Transaction> searchTransactions({
    String? query,
    models.TransactionType? type,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) {
    var filtered = List<models.Transaction>.from(_transactions);

    if (query != null && query.isNotEmpty) {
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(query.toLowerCase()) ||
            (t.description?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    }

    if (type != null) {
      filtered = filtered.where((t) => t.type == type).toList();
    }

    if (category != null && category.isNotEmpty) {
      // Buscar tanto en categoría como en fuente de ingreso
      filtered = filtered.where((t) => t.category == category || t.source == category).toList();
    }

    if (startDate != null) {
      filtered = filtered
          .where((t) =>
              t.date.isAfter(startDate.subtract(const Duration(days: 1))))
          .toList();
    }

    if (endDate != null) {
      filtered = filtered
          .where((t) => t.date.isBefore(endDate.add(const Duration(days: 1))))
          .toList();
    }

    if (minAmount != null) {
      filtered = filtered.where((t) => t.amount >= minAmount).toList();
    }

    if (maxAmount != null) {
      filtered = filtered.where((t) => t.amount <= maxAmount).toList();
    }

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  // Ingresos por fuente
  Map<String, double> getIncomeBySource() {
    final Map<String, double> incomeBySource = {};
    for (var transaction in _transactions
        .where((t) => t.type == models.TransactionType.income)) {
      final source = transaction.source ?? 'Otros';
      incomeBySource[source] =
          (incomeBySource[source] ?? 0.0) + transaction.amount;
    }
    return incomeBySource;
  }

  // Gastos por categoría
  Map<String, double> getExpensesByCategory() {
    final Map<String, double> expensesByCategory = {};
    for (var transaction in _transactions
        .where((t) => t.type == models.TransactionType.expense)) {
      expensesByCategory[transaction.category] =
          (expensesByCategory[transaction.category] ?? 0.0) +
              transaction.amount;
    }
    return expensesByCategory;
  }

  // Datos para gráfico de tendencia (últimos 6 meses)
  List<Map<String, dynamic>> getTrendData() {
    final List<Map<String, dynamic>> trendData = [];
    final now = DateTime.now();

    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthStart = DateTime(date.year, date.month, 1);
      final monthEnd = DateTime(date.year, date.month + 1, 0);

      final monthIncome = _transactions
          .where((t) =>
              t.type == models.TransactionType.income &&
              t.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
              t.date.isBefore(monthEnd.add(const Duration(days: 1))))
          .fold(0.0, (sum, t) => sum + t.amount);

      final monthExpenses = _transactions
          .where((t) =>
              t.type == models.TransactionType.expense &&
              t.date.isAfter(monthStart.subtract(const Duration(days: 1))) &&
              t.date.isBefore(monthEnd.add(const Duration(days: 1))))
          .fold(0.0, (sum, t) => sum + t.amount);

      trendData.add({
        'month': date.month,
        'year': date.year,
        'income': monthIncome,
        'expenses': monthExpenses,
      });
    }

    return trendData;
  }

  // ========== CATEGORÍAS ==========
  Future<void> _loadCategories() async {
    try {
      final dbCategories = await _db.getAllCustomCategories();
      _customCategories = dbCategories.map((c) => c.name).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> addCustomCategory(String category) async {
    if (!_customCategories.contains(category)) {
      try {
        await _db.insertCustomCategory(category);
        _customCategories.add(category);
        notifyListeners();
      } catch (e) {
        debugPrint('Error adding category: $e');
        rethrow;
      }
    }
  }

  Future<void> deleteCustomCategory(String category) async {
    try {
      final result = await _db.deleteCustomCategory(category);
      if (result > 0) {
        _customCategories.remove(category);
        notifyListeners();
      }
      debugPrint('deleteCustomCategory result: $result for category: $category');
    } catch (e) {
      debugPrint('Error deleting category: $e');
      rethrow;
    }
  }

  // ========== FUENTES DE INGRESO ==========
  Future<void> _loadIncomeSources() async {
    try {
      final dbSources = await _db.getAllCustomIncomeSources();
      _customIncomeSources = dbSources.map((s) => s.name).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading income sources: $e');
    }
  }

  Future<void> addCustomIncomeSource(String source) async {
    if (!_customIncomeSources.contains(source)) {
      try {
        await _db.insertCustomIncomeSource(source);
        _customIncomeSources.add(source);
        notifyListeners();
      } catch (e) {
        debugPrint('Error adding income source: $e');
        rethrow;
      }
    }
  }

  Future<void> deleteCustomIncomeSource(String source) async {
    try {
      final result = await _db.deleteCustomIncomeSource(source);
      if (result > 0) {
        _customIncomeSources.remove(source);
        notifyListeners();
      }
      debugPrint('deleteCustomIncomeSource result: $result for source: $source');
    } catch (e) {
      debugPrint('Error deleting income source: $e');
      rethrow;
    }
  }

  // ========== FUENTES/CATEGORÍAS PREDEFINIDAS OCULTAS ==========
  Future<void> _loadHiddenDefaultCategories() async {
    try {
      final dbHidden = await _db.getAllHiddenDefaultCategories();
      _hiddenDefaultCategories = dbHidden.map((h) => h.name).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading hidden categories: $e');
    }
  }

  Future<void> _loadHiddenDefaultIncomeSources() async {
    try {
      final dbHidden = await _db.getAllHiddenDefaultIncomeSources();
      _hiddenDefaultIncomeSources = dbHidden.map((h) => h.name).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading hidden income sources: $e');
    }
  }

  Future<void> hideDefaultCategory(String category) async {
    try {
      await _db.hideDefaultCategory(category);
      _hiddenDefaultCategories.add(category);
      notifyListeners();
    } catch (e) {
      debugPrint('Error hiding category: $e');
      rethrow;
    }
  }

  Future<void> unhideDefaultCategory(String category) async {
    try {
      await _db.unhideDefaultCategory(category);
      _hiddenDefaultCategories.remove(category);
      notifyListeners();
    } catch (e) {
      debugPrint('Error unhiding category: $e');
      rethrow;
    }
  }

  Future<void> hideDefaultIncomeSource(String source) async {
    try {
      await _db.hideDefaultIncomeSource(source);
      _hiddenDefaultIncomeSources.add(source);
      notifyListeners();
    } catch (e) {
      debugPrint('Error hiding income source: $e');
      rethrow;
    }
  }

  Future<void> unhideDefaultIncomeSource(String source) async {
    try {
      await _db.unhideDefaultIncomeSource(source);
      _hiddenDefaultIncomeSources.remove(source);
      notifyListeners();
    } catch (e) {
      debugPrint('Error unhiding income source: $e');
      rethrow;
    }
  }

  Future<void> restoreAllDefaultIncomeSources() async {
    try {
      await _db.unhideAllDefaultIncomeSources();
      _hiddenDefaultIncomeSources.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring income sources: $e');
      rethrow;
    }
  }

  Future<void> restoreAllDefaultCategories() async {
    try {
      await _db.unhideAllDefaultCategories();
      _hiddenDefaultCategories.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error restoring categories: $e');
      rethrow;
    }
  }

  // ========== PRESUPUESTOS ==========
  Future<void> _loadBudgets() async {
    try {
      final dbBudgets = await _db.getAllBudgets();
      _budgets = dbBudgets.map(_fromDbBudget).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading budgets: $e');
    }
  }

  Future<void> addBudget(models.Budget budget) async {
    try {
      // Eliminar presupuesto existente para la misma categoría
      final existing = await _db.getBudgetByCategory(budget.category);
      if (existing != null) {
        await _db.deleteBudget(existing.id);
      }
      await _db.insertBudget(_toDbBudget(budget));
      await _checkBudgetsForCategory(budget.category);
    } catch (e) {
      debugPrint('Error adding budget: $e');
      rethrow;
    }
  }

  Future<void> updateBudget(models.Budget budget) async {
    try {
      final updated = budget.copyWith(updatedAt: DateTime.now());
      await _db.updateBudget(_toDbBudget(updated));
      await _checkBudgetsForCategory(budget.category);
    } catch (e) {
      debugPrint('Error updating budget: $e');
      rethrow;
    }
  }

  Future<void> deleteBudget(String id) async {
    try {
      await _db.deleteBudget(id);
    } catch (e) {
      debugPrint('Error deleting budget: $e');
      rethrow;
    }
  }

  models.Budget? getBudgetForCategory(String category) {
    try {
      return _budgets.firstWhere((b) => b.category == category);
    } catch (e) {
      return null;
    }
  }

  double getSpentForCategory(String category) {
    final start = userSettings.getCurrentPeriodStart();
    final end = userSettings.getCurrentPeriodEnd();
    return _transactions
        .where((t) =>
            t.type == models.TransactionType.expense &&
            t.category == category &&
            t.date.isAfter(start.subtract(const Duration(days: 1))) &&
            t.date.isBefore(end.add(const Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // ========== ALERTAS ==========
  Future<void> _loadAlerts() async {
    try {
      final dbAlerts = await _db.getAllAlerts();
      _alerts = dbAlerts.map(_fromDbAlert).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading alerts: $e');
    }
  }

  Future<void> _checkBudgets(models.Transaction transaction,
      {bool isDelete = false}) async {
    if (transaction.type == models.TransactionType.expense) {
      await _checkBudgetsForCategory(transaction.category);
    }
  }

  Future<void> _checkBudgetsForCategory(String category) async {
    final budget = getBudgetForCategory(category);
    if (budget == null) return;

    final spent = getSpentForCategory(category);
    final percentage = (spent / budget.maxAmount) * 100;

    // Eliminar alertas antiguas de esta categoría
    await _db.deleteAlertsByCategory(category);

    if (percentage >= 100) {
      // Presupuesto excedido
      final alert = models.Alert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: category,
        type: models.AlertType.exceeded,
        currentAmount: spent,
        maxAmount: budget.maxAmount,
        percentage: percentage,
        createdAt: DateTime.now(),
      );
      await _db.insertAlert(_toDbAlert(alert));
    } else if (percentage >= 80) {
      // Advertencia (80% del presupuesto)
      final alert = models.Alert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        category: category,
        type: models.AlertType.warning,
        currentAmount: spent,
        maxAmount: budget.maxAmount,
        percentage: percentage,
        createdAt: DateTime.now(),
      );
      await _db.insertAlert(_toDbAlert(alert));
    }
  }

  Future<void> markAlertAsRead(String id) async {
    try {
      await _db.markAlertAsRead(id);
    } catch (e) {
      debugPrint('Error marking alert as read: $e');
      rethrow;
    }
  }

  Future<void> deleteAlert(String id) async {
    try {
      await _db.deleteAlert(id);
    } catch (e) {
      debugPrint('Error deleting alert: $e');
      rethrow;
    }
  }

  Future<void> clearAllAlerts() async {
    try {
      await _db.clearAllAlerts();
    } catch (e) {
      debugPrint('Error clearing alerts: $e');
      rethrow;
    }
  }

  // ========== METAS DE AHORRO ==========
  Future<void> _loadSavingsGoals() async {
    try {
      final dbGoals = await _db.getAllSavingsGoals();
      _savingsGoals = dbGoals.map(_fromDbSavingsGoal).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading savings goals: $e');
    }
  }

  Future<void> addSavingsGoal(models.SavingsGoal goal) async {
    try {
      await _db.insertSavingsGoal(_toDbSavingsGoal(goal));
    } catch (e) {
      debugPrint('Error adding savings goal: $e');
      rethrow;
    }
  }

  Future<void> updateSavingsGoal(models.SavingsGoal goal) async {
    try {
      await _db.updateSavingsGoal(_toDbSavingsGoal(goal));
      // Actualizar en memoria
      final index = _savingsGoals.indexWhere((g) => g.id == goal.id);
      if (index != -1) {
        _savingsGoals[index] = goal;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating savings goal: $e');
      rethrow;
    }
  }

  Future<void> deleteSavingsGoal(String id) async {
    try {
      await _db.deleteSavingsGoal(id);
    } catch (e) {
      debugPrint('Error deleting savings goal: $e');
      rethrow;
    }
  }

  Future<void> addSavingsContribution(String goalId, double amount,
      {String? note, DateTime? date, String? transactionId}) async {
    try {
      await _db.insertSavingsContribution(SavingsContributionsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        savingsGoalId: goalId,
        amount: amount,
        date: date ?? DateTime.now(),
        note: Value(note),
        transactionId: Value(transactionId),
      ));
    } catch (e) {
      debugPrint('Error adding savings contribution: $e');
      rethrow;
    }
  }

  Future<List<models.SavingsContribution>> getSavingsContributions(
      String goalId) async {
    try {
      final dbContributions = await _db.getContributionsByGoalId(goalId);
      return dbContributions
          .map((c) => models.SavingsContribution(
                id: c.id,
                savingsGoalId: c.savingsGoalId,
                amount: c.amount,
                date: c.date,
                note: c.note,
                transactionId: c.transactionId,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting savings contributions: $e');
      rethrow;
    }
  }

  // Completar o cancelar una meta
  Future<void> completeSavingsGoal(String id) async {
    try {
      final goal = _savingsGoals.firstWhere((g) => g.id == id);
      await _db.updateSavingsGoal(_toDbSavingsGoal(
        goal.copyWith(status: models.SavingsGoalStatus.completed),
      ));
    } catch (e) {
      debugPrint('Error completing savings goal: $e');
      rethrow;
    }
  }

  Future<void> cancelSavingsGoal(String id) async {
    try {
      final goal = _savingsGoals.firstWhere((g) => g.id == id);
      await _db.updateSavingsGoal(_toDbSavingsGoal(
        goal.copyWith(status: models.SavingsGoalStatus.cancelled),
      ));
    } catch (e) {
      debugPrint('Error cancelling savings goal: $e');
      rethrow;
    }
  }

  Future<void> reactivateSavingsGoal(String id) async {
    try {
      final goal = _savingsGoals.firstWhere((g) => g.id == id);
      await _db.updateSavingsGoal(_toDbSavingsGoal(
        goal.copyWith(status: models.SavingsGoalStatus.active),
      ));
    } catch (e) {
      debugPrint('Error reactivating savings goal: $e');
      rethrow;
    }
  }

  // ========== INVERSIONES ==========
  Future<void> _loadInvestments() async {
    try {
      final dbInvestments = await _db.getAllInvestments();
      _investments = dbInvestments.map(_fromDbInvestment).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading investments: $e');
    }
  }

  Future<void> addInvestment(models.Investment investment) async {
    try {
      await _db.insertInvestment(_toDbInvestment(investment));
    } catch (e) {
      debugPrint('Error adding investment: $e');
      rethrow;
    }
  }

  Future<void> updateInvestment(models.Investment investment) async {
    try {
      await _db.updateInvestment(_toDbInvestment(investment));
      // Actualizar en memoria
      final index = _investments.indexWhere((i) => i.id == investment.id);
      if (index != -1) {
        _investments[index] = investment;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating investment: $e');
      rethrow;
    }
  }

  Future<void> deleteInvestment(String id) async {
    try {
      await _db.deleteInvestment(id);
    } catch (e) {
      debugPrint('Error deleting investment: $e');
      rethrow;
    }
  }

  Future<void> updateInvestmentValue(
      String investmentId, double newValue) async {
    try {
      await _db.updateInvestmentValue(investmentId, newValue);
    } catch (e) {
      debugPrint('Error updating investment value: $e');
      rethrow;
    }
  }

  Future<void> sellInvestment(String investmentId, double soldAmount) async {
    try {
      await _db.sellInvestment(investmentId, soldAmount);
    } catch (e) {
      debugPrint('Error selling investment: $e');
      rethrow;
    }
  }

  Future<void> reactivateInvestment(String id) async {
    try {
      final investment = _investments.firstWhere((i) => i.id == id);
      await _db.updateInvestment(_toDbInvestment(
        investment.copyWith(
          status: models.InvestmentStatus.active,
          soldDate: null,
          soldAmount: null,
        ),
      ));
    } catch (e) {
      debugPrint('Error reactivating investment: $e');
      rethrow;
    }
  }

  // Inversiones por tipo
  Map<String, double> getInvestmentsByType() {
    final Map<String, double> byType = {};
    for (var investment in activeInvestments) {
      final typeName = _getInvestmentTypeName(investment.type);
      byType[typeName] = (byType[typeName] ?? 0.0) + investment.currentValue;
    }
    return byType;
  }

  String _getInvestmentTypeName(models.InvestmentType type) {
    switch (type) {
      case models.InvestmentType.stocks:
        return 'Acciones';
      case models.InvestmentType.bonds:
        return 'Bonos';
      case models.InvestmentType.crypto:
        return 'Criptomonedas';
      case models.InvestmentType.realEstate:
        return 'Bienes Raíces';
      case models.InvestmentType.mutualFunds:
        return 'Fondos Mutuos';
      case models.InvestmentType.etf:
        return 'ETFs';
      case models.InvestmentType.forex:
        return 'Divisas';
      case models.InvestmentType.commodities:
        return 'Materias Primas';
      case models.InvestmentType.savings:
        return 'Cuenta de Ahorro';
      case models.InvestmentType.other:
        return 'Otros';
    }
  }

  // ========== PRÉSTAMOS ==========
  Future<void> _loadLoans() async {
    try {
      final dbLoans = await _db.getAllLoans();
      _loans = dbLoans.map(_fromDbLoan).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading loans: $e');
    }
  }

  Future<void> addLoan(models.Loan loan) async {
    try {
      await _db.insertLoan(_toDbLoan(loan));
    } catch (e) {
      debugPrint('Error adding loan: $e');
      rethrow;
    }
  }

  Future<void> updateLoan(models.Loan loan) async {
    try {
      await _db.updateLoan(_toDbLoan(loan));
      // Actualizar en memoria
      final index = _loans.indexWhere((l) => l.id == loan.id);
      if (index != -1) {
        _loans[index] = loan;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating loan: $e');
      rethrow;
    }
  }

  Future<void> deleteLoan(String id) async {
    try {
      await _db.deleteLoan(id);
    } catch (e) {
      debugPrint('Error deleting loan: $e');
      rethrow;
    }
  }

  Future<void> reactivateLoan(String id) async {
    try {
      final loan = _loans.firstWhere((l) => l.id == id);
      await _db.updateLoan(_toDbLoan(
        loan.copyWith(status: models.LoanStatus.active),
      ));
    } catch (e) {
      debugPrint('Error reactivating loan: $e');
      rethrow;
    }
  }

  Future<void> addLoanPayment(
      String loanId, double amount, int installmentNumber,
      {String? notes, DateTime? date, String? transactionId}) async {
    try {
      await _db.insertLoanPayment(LoanPaymentsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        loanId: loanId,
        amount: amount,
        date: date ?? DateTime.now(),
        installmentNumber: installmentNumber,
        notes: Value(notes),
        transactionId: Value(transactionId),
      ));
    } catch (e) {
      debugPrint('Error adding loan payment: $e');
      rethrow;
    }
  }

  Future<List<models.LoanPayment>> getLoanPayments(String loanId) async {
    try {
      final dbPayments = await _db.getPaymentsByLoanId(loanId);
      return dbPayments
          .map((p) => models.LoanPayment(
                id: p.id,
                loanId: p.loanId,
                amount: p.amount,
                date: p.date,
                installmentNumber: p.installmentNumber,
                notes: p.notes,
                transactionId: p.transactionId,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting loan payments: $e');
      rethrow;
    }
  }

  // Editar y eliminar contribuciones de ahorro
  Future<void> updateSavingsContribution(models.SavingsContribution contribution) async {
    try {
      await _db.updateSavingsContribution(SavingsContributionsCompanion(
        id: Value(contribution.id),
        savingsGoalId: Value(contribution.savingsGoalId),
        amount: Value(contribution.amount),
        date: Value(contribution.date),
        note: Value(contribution.note),
        transactionId: Value(contribution.transactionId),
      ));
      
      // Si hay una transacción vinculada, actualizarla también
      if (contribution.transactionId != null) {
        try {
          final transaction = transactions.firstWhere(
            (t) => t.id == contribution.transactionId,
            orElse: () => throw Exception('Transaction not found'),
          );
          final updatedTransaction = transaction.copyWith(
            amount: contribution.amount,
            date: contribution.date,
            description: contribution.note,
          );
          await updateTransaction(updatedTransaction);
        } catch (e) {
          debugPrint('Error updating linked transaction: $e');
        }
      }
    } catch (e) {
      debugPrint('Error updating savings contribution: $e');
      rethrow;
    }
  }

  Future<void> deleteSavingsContribution(String contributionId) async {
    try {
      // Obtener la contribución para verificar si tiene transacción vinculada
      final allGoals = _savingsGoals;
      models.SavingsContribution? contribution;
      for (final goal in allGoals) {
        final contributions = await getSavingsContributions(goal.id);
        try {
          contribution = contributions.firstWhere((c) => c.id == contributionId);
          break;
        } catch (_) {
          continue;
        }
      }
      
      if (contribution == null) {
        throw Exception('Contribution not found');
      }
      
      // Si hay una transacción vinculada, eliminarla también
      if (contribution.transactionId != null) {
        try {
          await deleteTransaction(contribution.transactionId!);
        } catch (e) {
          debugPrint('Error deleting linked transaction: $e');
        }
      }
      
      await _db.deleteSavingsContribution(contributionId);
    } catch (e) {
      debugPrint('Error deleting savings contribution: $e');
      rethrow;
    }
  }

  // Editar y eliminar pagos de préstamos
  Future<void> updateLoanPayment(models.LoanPayment payment) async {
    try {
      await _db.updateLoanPayment(LoanPaymentsCompanion(
        id: Value(payment.id),
        loanId: Value(payment.loanId),
        amount: Value(payment.amount),
        date: Value(payment.date),
        installmentNumber: Value(payment.installmentNumber),
        notes: Value(payment.notes),
        transactionId: Value(payment.transactionId),
      ));
      
      // Si hay una transacción vinculada, actualizarla también
      if (payment.transactionId != null) {
        try {
          final transaction = transactions.firstWhere(
            (t) => t.id == payment.transactionId,
            orElse: () => throw Exception('Transaction not found'),
          );
          final updatedTransaction = transaction.copyWith(
            amount: payment.amount,
            date: payment.date,
            description: payment.notes,
          );
          await updateTransaction(updatedTransaction);
        } catch (e) {
          debugPrint('Error updating linked transaction: $e');
        }
      }
    } catch (e) {
      debugPrint('Error updating loan payment: $e');
      rethrow;
    }
  }

  Future<void> deleteLoanPayment(String paymentId) async {
    try {
      // Obtener el pago para verificar si tiene transacción vinculada
      final allLoans = [...loansReceived, ...loansGiven];
      models.LoanPayment? payment;
      for (final loan in allLoans) {
        final payments = await getLoanPayments(loan.id);
        try {
          payment = payments.firstWhere((p) => p.id == paymentId);
          break;
        } catch (_) {
          continue;
        }
      }
      
      if (payment == null) {
        throw Exception('Payment not found');
      }
      
      // Si hay una transacción vinculada, eliminarla también
      if (payment.transactionId != null) {
        try {
          await deleteTransaction(payment.transactionId!);
        } catch (e) {
          debugPrint('Error deleting linked transaction: $e');
        }
      }
      
      await _db.deleteLoanPayment(paymentId);
    } catch (e) {
      debugPrint('Error deleting loan payment: $e');
      rethrow;
    }
  }

  // Préstamos próximos a vencer
  List<models.Loan> get loansWithUpcomingPayments {
    final now = DateTime.now();
    return activeLoans.where((l) {
      final nextPayment = l.nextPaymentDate;
      if (nextPayment == null) return false;
      final daysUntil = nextPayment.difference(now).inDays;
      return daysUntil <= 7; // Préstamos con pago en los próximos 7 días
    }).toList();
  }

  // Préstamos que debo (yo recibí dinero)
  List<models.Loan> get loansReceived =>
      _loans.where((l) => l.type == models.LoanType.received).toList();

  // Préstamos que me deben (yo presté dinero)
  List<models.Loan> get loansGiven =>
      _loans.where((l) => l.type == models.LoanType.given).toList();

  // ========== CONFIGURACIÓN DEL USUARIO ==========
  Future<void> _loadUserSettings() async {
    try {
      final dbSettings = await _db.getUserSettings();
      if (dbSettings != null) {
        _userSettings = _fromDbUserSettings(dbSettings);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user settings: $e');
    }
  }

  Future<void> setMonthStartDay(int day) async {
    try {
      await _db.setMonthStartDay(day);
    } catch (e) {
      debugPrint('Error setting month start day: $e');
      rethrow;
    }
  }

  Future<void> updateCurrency(String currency, String symbol) async {
    try {
      await _db.updateUserSettings(UserSettingsTableCompanion(
        currency: Value(currency),
        currencySymbol: Value(symbol),
      ));
    } catch (e) {
      debugPrint('Error updating currency: $e');
      rethrow;
    }
  }

  Future<void> updateNumberFormat({
    required String thousandsSeparator,
    required String decimalSeparator,
  }) async {
    try {
      await _db.updateUserSettings(UserSettingsTableCompanion(
        thousandsSeparator: Value(thousandsSeparator),
        decimalSeparator: Value(decimalSeparator),
      ));
    } catch (e) {
      debugPrint('Error updating number format: $e');
      rethrow;
    }
  }

  /// Formatea un número con los separadores configurados
  String formatNumber(double number, {int decimals = 2}) {
    return userSettings.formatNumber(number, decimals: decimals);
  }

  /// Formatea un monto con símbolo de moneda
  String formatCurrency(double amount, {int decimals = 2}) {
    return userSettings.formatCurrency(amount, decimals: decimals);
  }

  Future<void> updateNotificationSettings({
    bool? notificationsEnabled,
    bool? budgetAlertsEnabled,
    bool? loanRemindersEnabled,
    bool? savingsRemindersEnabled,
  }) async {
    try {
      await _db.updateUserSettings(UserSettingsTableCompanion(
        notificationsEnabled: notificationsEnabled != null
            ? Value(notificationsEnabled)
            : const Value.absent(),
        budgetAlertsEnabled: budgetAlertsEnabled != null
            ? Value(budgetAlertsEnabled)
            : const Value.absent(),
        loanRemindersEnabled: loanRemindersEnabled != null
            ? Value(loanRemindersEnabled)
            : const Value.absent(),
        savingsRemindersEnabled: savingsRemindersEnabled != null
            ? Value(savingsRemindersEnabled)
            : const Value.absent(),
      ));
      // Actualizar el estado interno
      if (_userSettings != null) {
        _userSettings = _userSettings!.copyWith(
          notificationsEnabled: notificationsEnabled,
          budgetAlertsEnabled: budgetAlertsEnabled,
          loanRemindersEnabled: loanRemindersEnabled,
          savingsRemindersEnabled: savingsRemindersEnabled,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating notification settings: $e');
      rethrow;
    }
  }

  Future<void> markNotificationPermissionAsked() async {
    try {
      await _db.updateUserSettings(UserSettingsTableCompanion(
        notificationPermissionAsked: const Value(true),
      ));
      // Actualizar el estado interno
      if (_userSettings != null) {
        _userSettings = _userSettings!.copyWith(
          notificationPermissionAsked: true,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification permission asked: $e');
      rethrow;
    }
  }

  Future<void> updateBalanceResetPeriod(
    models.BalanceResetPeriod period, {
    int? dayOfMonth,
    int? dayOfWeek,
  }) async {
    try {
      await _db.updateUserSettings(UserSettingsTableCompanion(
        balanceResetPeriod: Value(period.name),
        balanceResetDayOfMonth: dayOfMonth != null ? Value(dayOfMonth) : const Value.absent(),
        balanceResetDayOfWeek: dayOfWeek != null ? Value(dayOfWeek) : const Value.absent(),
      ));
      // Actualizar el estado interno
      if (_userSettings != null) {
        _userSettings = _userSettings!.copyWith(
          balanceResetPeriod: period,
          balanceResetDayOfMonth: dayOfMonth,
          balanceResetDayOfWeek: dayOfWeek,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating balance reset period: $e');
      rethrow;
    }
  }

  Future<void> updateTheme(String theme) async {
    try {
      await _db.updateUserSettings(UserSettingsTableCompanion(
        theme: Value(theme),
      ));
      // El listener de la base de datos actualizará automáticamente el estado
      // pero también actualizamos inmediatamente para respuesta instantánea
      if (_userSettings != null) {
        _userSettings = _userSettings!.copyWith(
          theme: theme,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      } else {
        // Si aún no hay settings, forzar recarga
        await _loadUserSettings();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating theme: $e');
      rethrow;
    }
  }

  Future<void> updateColorPalette(models.ColorPalette palette) async {
    try {
      await _db.updateUserSettings(UserSettingsTableCompanion(
        colorPalette: Value(palette.name),
      ));
      // Actualizar inmediatamente para respuesta instantánea
      if (_userSettings != null) {
        _userSettings = _userSettings!.copyWith(
          colorPalette: palette,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      } else {
        await _loadUserSettings();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating color palette: $e');
      rethrow;
    }
  }

  Future<void> updateChartSettings({
    String? trendChartType,
    String? incomeChartType,
    String? expenseChartType,
  }) async {
    try {
      // Asegurar que tenemos la configuración actual
      if (_userSettings == null) {
        await _loadUserSettings();
      }
      
      if (_userSettings == null) {
        debugPrint('Error: No se pudo cargar la configuración del usuario');
        return;
      }
      
      // Preparar los valores a actualizar (usar valores actuales si no se proporcionan)
      final currentTrend = trendChartType ?? _userSettings!.trendChartType;
      final currentIncome = incomeChartType ?? _userSettings!.incomeChartType;
      final currentExpense = expenseChartType ?? _userSettings!.expenseChartType;
      
      // Actualizar en la base de datos - incluir todos los valores, no solo los que cambian
      // Esto asegura que la actualización funcione correctamente
      final companion = UserSettingsTableCompanion(
        trendChartType: Value(currentTrend),
        incomeChartType: Value(currentIncome),
        expenseChartType: Value(currentExpense),
      );
      
      final result = await _db.updateUserSettings(companion);
      debugPrint('updateUserSettings result: $result');
      
      // Actualizar en memoria inmediatamente para respuesta instantánea
      _userSettings = _userSettings!.copyWith(
        trendChartType: currentTrend,
        incomeChartType: currentIncome,
        expenseChartType: currentExpense,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
      
      // Forzar recarga desde la base de datos para verificar que los cambios se guardaron
      await Future.delayed(const Duration(milliseconds: 100));
      final dbSettings = await _db.getUserSettings();
      if (dbSettings != null) {
        final dbSettingsModel = _fromDbUserSettings(dbSettings);
        if (dbSettingsModel.trendChartType != currentTrend || 
            dbSettingsModel.incomeChartType != currentIncome ||
            dbSettingsModel.expenseChartType != currentExpense) {
          debugPrint('ADVERTENCIA: Los cambios no se guardaron correctamente en la base de datos');
          debugPrint('Esperado: trend=$currentTrend, income=$currentIncome, expense=$currentExpense');
          debugPrint('Obtenido: trend=${dbSettingsModel.trendChartType}, income=${dbSettingsModel.incomeChartType}, expense=${dbSettingsModel.expenseChartType}');
        } else {
          debugPrint('Configuración de gráficos actualizada correctamente: trend=$currentTrend, income=$currentIncome, expense=$currentExpense');
        }
        // Sincronizar con lo que está en la base de datos
        _userSettings = dbSettingsModel;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating chart settings: $e');
      rethrow;
    }
  }

  // ========== RESUMEN FINANCIERO ==========
  Future<Map<String, double>> getFinancialSummary() async {
    final start = userSettings.getCurrentPeriodStart();
    final end = userSettings.getCurrentPeriodEnd();
    return _db.getPeriodSummary(start, end);
  }

  // ========== TRANSACCIONES RECURRENTES (AUTOMÁTICOS) ==========
  Stream<List<db.RecurringTransaction>> watchRecurringTransactions() {
    return _db.watchActiveRecurringTransactions();
  }

  Future<void> saveRecurringTransaction({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String category,
    String? source,
    required String frequency,
    int? dayOfMonth,
    int? dayOfWeek,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
    bool notificationsEnabled = false,
    int? notificationHour,
    int? notificationMinute,
    String? linkedFinanceModule,
    String? linkedLoanId,
    String? linkedSavingsGoalId,
  }) async {
    try {
      await _db.insertRecurringTransaction(
        db.RecurringTransactionsCompanion.insert(
          id: id,
          title: title,
          amount: amount,
          type: type,
          category: category,
          source: Value(source),
          frequency: frequency,
          dayOfMonth: Value(dayOfMonth),
          dayOfWeek: Value(dayOfWeek),
          startDate: startDate,
          endDate: Value(endDate),
          description: Value(description),
          isActive: const Value(true),
          notificationsEnabled: Value(notificationsEnabled),
          notificationHour: Value(notificationHour),
          notificationMinute: Value(notificationMinute),
          linkedFinanceModule: Value(linkedFinanceModule),
          linkedLoanId: Value(linkedLoanId),
          linkedSavingsGoalId: Value(linkedSavingsGoalId),
        ),
      );

      // Cancelar notificación anterior si existe (para actualizaciones)
      await NotificationService().cancelAutomaticTransactionNotification(id);
      
      // Programar notificación si está habilitada
      if (notificationsEnabled && notificationHour != null && notificationMinute != null) {
        try {
          await NotificationService().scheduleAutomaticTransactionNotification(
            automaticId: id,
            title: title,
            amount: amount,
            isIncome: type == 'income',
            frequency: frequency,
            dayOfMonth: dayOfMonth,
            dayOfWeek: dayOfWeek,
            startDate: startDate,
            endDate: endDate,
            notificationHour: notificationHour,
            notificationMinute: notificationMinute,
          );
        } catch (e) {
          debugPrint('Error al programar notificación: $e');
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error saving recurring transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteRecurringTransaction(String id) async {
    try {
      // Cancelar notificación antes de eliminar
      await NotificationService().cancelAutomaticTransactionNotification(id);
      await _db.deleteRecurringTransaction(id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting recurring transaction: $e');
      rethrow;
    }
  }

  // ========== BACKUP / RESTORE ==========
  
  /// Exporta todos los datos de la app a un Map que puede ser serializado a JSON
  Future<Map<String, dynamic>> exportAllData() async {
    try {
      // Obtener todos los datos de la base de datos
      final transactions = await _db.getAllTransactions();
      final budgets = await _db.getAllBudgets();
      final alerts = await _db.getAllAlerts();
      final customCategories = await _db.getAllCustomCategories();
      final customIncomeSources = await _db.getAllCustomIncomeSources();
      final hiddenCategories = await _db.getAllHiddenDefaultCategories();
      final hiddenSources = await _db.getAllHiddenDefaultIncomeSources();
      final savingsGoals = await _db.getAllSavingsGoals();
      final investments = await _db.getAllInvestments();
      final loans = await _db.getAllLoans();
      final userSettings = await _db.getUserSettings();
      final recurringTransactions = await _db.getAllRecurringTransactions();
      
      // Obtener contribuciones y pagos para cada meta/préstamo
      final Map<String, List<Map<String, dynamic>>> savingsContributions = {};
      for (final goal in savingsGoals) {
        final contributions = await _db.getContributionsByGoalId(goal.id);
        savingsContributions[goal.id] = contributions.map((c) => {
          'id': c.id,
          'savingsGoalId': c.savingsGoalId,
          'amount': c.amount,
          'date': c.date.toIso8601String(),
          'note': c.note,
          'transactionId': c.transactionId,
        }).toList();
      }
      
      final Map<String, List<Map<String, dynamic>>> loanPayments = {};
      for (final loan in loans) {
        final payments = await _db.getPaymentsByLoanId(loan.id);
        loanPayments[loan.id] = payments.map((p) => {
          'id': p.id,
          'loanId': p.loanId,
          'amount': p.amount,
          'date': p.date.toIso8601String(),
          'installmentNumber': p.installmentNumber,
          'notes': p.notes,
          'transactionId': p.transactionId,
        }).toList();
      }
      
      // Obtener historial de inversiones
      final Map<String, List<Map<String, dynamic>>> investmentHistory = {};
      for (final inv in investments) {
        final history = await _db.getInvestmentHistory(inv.id);
        investmentHistory[inv.id] = history.map((h) => {
          'id': h.id,
          'investmentId': h.investmentId,
          'value': h.value,
          'date': h.date.toIso8601String(),
        }).toList();
      }
      
      return {
        'version': 1,
        'exportDate': DateTime.now().toIso8601String(),
        'transactions': transactions.map((t) => {
          'id': t.id,
          'title': t.title,
          'amount': t.amount,
          'type': t.type,
          'category': t.category,
          'date': t.date.toIso8601String(),
          'description': t.description,
          'source': t.source,
          'isRecurring': t.isRecurring,
          'recurringFrequency': t.recurringFrequency,
        }).toList(),
        'budgets': budgets.map((b) => {
          'id': b.id,
          'category': b.category,
          'maxAmount': b.maxAmount,
          'createdAt': b.createdAt.toIso8601String(),
          'updatedAt': b.updatedAt?.toIso8601String(),
        }).toList(),
        'alerts': alerts.map((a) => {
          'id': a.id,
          'category': a.category,
          'type': a.type,
          'currentAmount': a.currentAmount,
          'maxAmount': a.maxAmount,
          'percentage': a.percentage,
          'createdAt': a.createdAt.toIso8601String(),
          'isRead': a.isRead,
        }).toList(),
        'customCategories': customCategories.map((c) => c.name).toList(),
        'customIncomeSources': customIncomeSources.map((c) => c.name).toList(),
        'hiddenDefaultCategories': hiddenCategories.map((c) => c.name).toList(),
        'hiddenDefaultIncomeSources': hiddenSources.map((c) => c.name).toList(),
        'savingsGoals': savingsGoals.map((s) => {
          'id': s.id,
          'name': s.name,
          'description': s.description,
          'targetAmount': s.targetAmount,
          'currentAmount': s.currentAmount,
          'createdAt': s.createdAt.toIso8601String(),
          'targetDate': s.targetDate?.toIso8601String(),
          'status': s.status,
          'iconName': s.iconName,
          'color': s.color,
          'contributionFrequency': s.contributionFrequency,
          'notificationDays': s.notificationDays,
          'notificationTime': s.notificationTime,
        }).toList(),
        'savingsContributions': savingsContributions,
        'investments': investments.map((i) => {
          'id': i.id,
          'name': i.name,
          'description': i.description,
          'type': i.type,
          'initialAmount': i.initialAmount,
          'currentValue': i.currentValue,
          'expectedReturnRate': i.expectedReturnRate,
          'returnRatePeriod': i.returnRatePeriod,
          'purchaseDate': i.purchaseDate.toIso8601String(),
          'soldDate': i.soldDate?.toIso8601String(),
          'soldAmount': i.soldAmount,
          'status': i.status,
          'platformOrBroker': i.platformOrBroker,
          'notes': i.notes,
          'compoundingFrequency': i.compoundingFrequency,
          'iconName': i.iconName,
          'color': i.color,
          'notificationDays': i.notificationDays,
          'notificationTime': i.notificationTime,
        }).toList(),
        'investmentHistory': investmentHistory,
        'loans': loans.map((l) => {
          'id': l.id,
          'name': l.name,
          'borrowerOrLender': l.borrowerOrLender,
          'type': l.type,
          'principalAmount': l.principalAmount,
          'interestRate': l.interestRate,
          'interestRatePeriod': l.interestRatePeriod,
          'totalInstallments': l.totalInstallments,
          'installmentAmount': l.installmentAmount,
          'startDate': l.startDate.toIso8601String(),
          'endDate': l.endDate?.toIso8601String(),
          'paymentFrequency': l.paymentFrequency,
          'status': l.status,
          'notes': l.notes,
          'paidAmount': l.paidAmount,
          'paidInstallments': l.paidInstallments,
          'iconName': l.iconName,
          'color': l.color,
          'notificationDays': l.notificationDays,
          'notificationDayOfMonth': l.notificationDayOfMonth,
          'notificationTime': l.notificationTime,
        }).toList(),
        'loanPayments': loanPayments,
        'userSettings': userSettings != null ? {
          'id': userSettings.id,
          'monthStartDay': userSettings.monthStartDay,
          'currency': userSettings.currency,
          'currencySymbol': userSettings.currencySymbol,
          'thousandsSeparator': userSettings.thousandsSeparator,
          'decimalSeparator': userSettings.decimalSeparator,
          'notificationsEnabled': userSettings.notificationsEnabled,
          'budgetAlertsEnabled': userSettings.budgetAlertsEnabled,
          'loanRemindersEnabled': userSettings.loanRemindersEnabled,
          'savingsRemindersEnabled': userSettings.savingsRemindersEnabled,
          'notificationPermissionAsked': userSettings.notificationPermissionAsked,
          'balanceResetPeriod': userSettings.balanceResetPeriod,
          'balanceResetDayOfMonth': userSettings.balanceResetDayOfMonth,
          'balanceResetDayOfWeek': userSettings.balanceResetDayOfWeek,
          'theme': userSettings.theme,
          'trendChartType': userSettings.trendChartType,
          'incomeChartType': userSettings.incomeChartType,
          'expenseChartType': userSettings.expenseChartType,
          'createdAt': userSettings.createdAt.toIso8601String(),
          'updatedAt': userSettings.updatedAt?.toIso8601String(),
        } : null,
        'recurringTransactions': recurringTransactions.map((r) => {
          'id': r.id,
          'title': r.title,
          'amount': r.amount,
          'type': r.type,
          'category': r.category,
          'source': r.source,
          'frequency': r.frequency,
          'dayOfMonth': r.dayOfMonth,
          'dayOfWeek': r.dayOfWeek,
          'startDate': r.startDate.toIso8601String(),
          'endDate': r.endDate?.toIso8601String(),
          'lastProcessedDate': r.lastProcessedDate?.toIso8601String(),
          'isActive': r.isActive,
          'description': r.description,
          'notificationsEnabled': r.notificationsEnabled,
          'notificationHour': r.notificationHour,
          'notificationMinute': r.notificationMinute,
          'linkedFinanceModule': r.linkedFinanceModule,
          'linkedLoanId': r.linkedLoanId,
          'linkedSavingsGoalId': r.linkedSavingsGoalId,
        }).toList(),
      };
    } catch (e) {
      debugPrint('Error exporting data: $e');
      rethrow;
    }
  }
  
  /// Importa todos los datos desde un Map (deserializado de JSON)
  Future<void> importAllData(Map<String, dynamic> data) async {
    try {
      // Verificar versión del backup
      final version = data['version'] as int? ?? 1;
      if (version > 1) {
        throw Exception('Versión de backup no soportada');
      }
      
      // Importar transacciones
      final transactions = data['transactions'] as List<dynamic>? ?? [];
      for (final t in transactions) {
        await _db.insertTransaction(db.TransactionsCompanion(
          id: Value(t['id'] as String),
          title: Value(t['title'] as String),
          amount: Value((t['amount'] as num).toDouble()),
          type: Value(t['type'] as String),
          category: Value(t['category'] as String),
          date: Value(DateTime.parse(t['date'] as String)),
          description: Value(t['description'] as String?),
          source: Value(t['source'] as String?),
          isRecurring: Value(t['isRecurring'] as bool? ?? false),
          recurringFrequency: Value(t['recurringFrequency'] as String?),
        ));
      }
      
      // Importar presupuestos
      final budgets = data['budgets'] as List<dynamic>? ?? [];
      for (final b in budgets) {
        await _db.insertBudget(db.BudgetsCompanion(
          id: Value(b['id'] as String),
          category: Value(b['category'] as String),
          maxAmount: Value((b['maxAmount'] as num).toDouble()),
          createdAt: Value(DateTime.parse(b['createdAt'] as String)),
          updatedAt: Value(b['updatedAt'] != null ? DateTime.parse(b['updatedAt'] as String) : null),
        ));
      }
      
      // Importar alertas
      final alerts = data['alerts'] as List<dynamic>? ?? [];
      for (final a in alerts) {
        await _db.insertAlert(db.AlertsCompanion(
          id: Value(a['id'] as String),
          category: Value(a['category'] as String),
          type: Value(a['type'] as String),
          currentAmount: Value((a['currentAmount'] as num).toDouble()),
          maxAmount: Value((a['maxAmount'] as num).toDouble()),
          percentage: Value((a['percentage'] as num).toDouble()),
          createdAt: Value(DateTime.parse(a['createdAt'] as String)),
          isRead: Value(a['isRead'] as bool? ?? false),
        ));
      }
      
      // Importar categorías personalizadas
      final customCategories = data['customCategories'] as List<dynamic>? ?? [];
      for (final c in customCategories) {
        try {
          await _db.insertCustomCategory(c as String);
        } catch (_) {}
      }
      
      // Importar fuentes de ingreso personalizadas
      final customIncomeSources = data['customIncomeSources'] as List<dynamic>? ?? [];
      for (final c in customIncomeSources) {
        try {
          await _db.insertCustomIncomeSource(c as String);
        } catch (_) {}
      }
      
      // Importar categorías ocultas
      final hiddenCategories = data['hiddenDefaultCategories'] as List<dynamic>? ?? [];
      for (final c in hiddenCategories) {
        try {
          await _db.hideDefaultCategory(c as String);
        } catch (_) {}
      }
      
      // Importar fuentes ocultas
      final hiddenSources = data['hiddenDefaultIncomeSources'] as List<dynamic>? ?? [];
      for (final c in hiddenSources) {
        try {
          await _db.hideDefaultIncomeSource(c as String);
        } catch (_) {}
      }
      
      // Importar metas de ahorro
      final savingsGoals = data['savingsGoals'] as List<dynamic>? ?? [];
      for (final s in savingsGoals) {
        await _db.insertSavingsGoal(db.SavingsGoalsCompanion(
          id: Value(s['id'] as String),
          name: Value(s['name'] as String),
          description: Value(s['description'] as String?),
          targetAmount: Value((s['targetAmount'] as num).toDouble()),
          currentAmount: Value((s['currentAmount'] as num).toDouble()),
          createdAt: Value(DateTime.parse(s['createdAt'] as String)),
          targetDate: Value(s['targetDate'] != null ? DateTime.parse(s['targetDate'] as String) : null),
          status: Value(s['status'] as String),
          iconName: Value(s['iconName'] as String?),
          color: Value(s['color'] as String?),
          contributionFrequency: Value(s['contributionFrequency'] as String? ?? 'monthly'),
          notificationDays: Value(s['notificationDays'] as String?),
          notificationTime: Value(s['notificationTime'] as String?),
        ));
      }
      
      // Importar contribuciones de ahorro
      final savingsContributions = data['savingsContributions'] as Map<String, dynamic>? ?? {};
      for (final goalId in savingsContributions.keys) {
        final contributions = savingsContributions[goalId] as List<dynamic>? ?? [];
        for (final c in contributions) {
          try {
            await _db.into(_db.savingsContributions).insert(
              db.SavingsContributionsCompanion(
                id: Value(c['id'] as String),
                savingsGoalId: Value(c['savingsGoalId'] as String),
                amount: Value((c['amount'] as num).toDouble()),
                date: Value(DateTime.parse(c['date'] as String)),
                note: Value(c['note'] as String?),
                transactionId: Value(c['transactionId'] as String?),
              ),
              mode: InsertMode.insertOrIgnore,
            );
          } catch (_) {}
        }
      }
      
      // Importar inversiones
      final investments = data['investments'] as List<dynamic>? ?? [];
      for (final i in investments) {
        await _db.insertInvestment(db.InvestmentsCompanion(
          id: Value(i['id'] as String),
          name: Value(i['name'] as String),
          description: Value(i['description'] as String?),
          type: Value(i['type'] as String),
          initialAmount: Value((i['initialAmount'] as num).toDouble()),
          currentValue: Value((i['currentValue'] as num).toDouble()),
          expectedReturnRate: Value((i['expectedReturnRate'] as num).toDouble()),
          returnRatePeriod: Value(i['returnRatePeriod'] as String? ?? 'yearly'),
          purchaseDate: Value(DateTime.parse(i['purchaseDate'] as String)),
          soldDate: Value(i['soldDate'] != null ? DateTime.parse(i['soldDate'] as String) : null),
          soldAmount: Value(i['soldAmount'] != null ? (i['soldAmount'] as num).toDouble() : null),
          status: Value(i['status'] as String),
          platformOrBroker: Value(i['platformOrBroker'] as String?),
          notes: Value(i['notes'] as String?),
          compoundingFrequency: Value(i['compoundingFrequency'] as int? ?? 12),
          iconName: Value(i['iconName'] as String?),
          color: Value(i['color'] as String?),
          notificationDays: Value(i['notificationDays'] as String?),
          notificationTime: Value(i['notificationTime'] as String?),
        ));
      }
      
      // Importar historial de inversiones
      final investmentHistory = data['investmentHistory'] as Map<String, dynamic>? ?? {};
      for (final invId in investmentHistory.keys) {
        final history = investmentHistory[invId] as List<dynamic>? ?? [];
        for (final h in history) {
          try {
            await _db.into(_db.investmentValueHistory).insert(
              db.InvestmentValueHistoryCompanion(
                id: Value(h['id'] as String),
                investmentId: Value(h['investmentId'] as String),
                value: Value((h['value'] as num).toDouble()),
                date: Value(DateTime.parse(h['date'] as String)),
              ),
              mode: InsertMode.insertOrIgnore,
            );
          } catch (_) {}
        }
      }
      
      // Importar préstamos
      final loans = data['loans'] as List<dynamic>? ?? [];
      for (final l in loans) {
        await _db.insertLoan(db.LoansCompanion(
          id: Value(l['id'] as String),
          name: Value(l['name'] as String),
          borrowerOrLender: Value(l['borrowerOrLender'] as String?),
          type: Value(l['type'] as String),
          principalAmount: Value((l['principalAmount'] as num).toDouble()),
          interestRate: Value((l['interestRate'] as num).toDouble()),
          interestRatePeriod: Value(l['interestRatePeriod'] as String? ?? 'yearly'),
          totalInstallments: Value(l['totalInstallments'] as int),
          installmentAmount: Value((l['installmentAmount'] as num).toDouble()),
          startDate: Value(DateTime.parse(l['startDate'] as String)),
          endDate: Value(l['endDate'] != null ? DateTime.parse(l['endDate'] as String) : null),
          paymentFrequency: Value(l['paymentFrequency'] as String? ?? 'monthly'),
          status: Value(l['status'] as String),
          notes: Value(l['notes'] as String?),
          paidAmount: Value((l['paidAmount'] as num?)?.toDouble() ?? 0.0),
          paidInstallments: Value(l['paidInstallments'] as int? ?? 0),
          iconName: Value(l['iconName'] as String?),
          color: Value(l['color'] as String?),
          notificationDays: Value(l['notificationDays'] as String?),
          notificationDayOfMonth: Value(l['notificationDayOfMonth'] as int?),
          notificationTime: Value(l['notificationTime'] as String?),
        ));
      }
      
      // Importar pagos de préstamos
      final loanPayments = data['loanPayments'] as Map<String, dynamic>? ?? {};
      for (final loanId in loanPayments.keys) {
        final payments = loanPayments[loanId] as List<dynamic>? ?? [];
        for (final p in payments) {
          try {
            await _db.into(_db.loanPayments).insert(
              db.LoanPaymentsCompanion(
                id: Value(p['id'] as String),
                loanId: Value(p['loanId'] as String),
                amount: Value((p['amount'] as num).toDouble()),
                date: Value(DateTime.parse(p['date'] as String)),
                installmentNumber: Value(p['installmentNumber'] as int),
                notes: Value(p['notes'] as String?),
                transactionId: Value(p['transactionId'] as String?),
              ),
              mode: InsertMode.insertOrIgnore,
            );
          } catch (_) {}
        }
      }
      
      // Importar configuración del usuario
      final userSettings = data['userSettings'] as Map<String, dynamic>?;
      if (userSettings != null) {
        await _db.updateUserSettings(db.UserSettingsTableCompanion(
          monthStartDay: Value(userSettings['monthStartDay'] as int? ?? 1),
          currency: Value(userSettings['currency'] as String? ?? 'COP'),
          currencySymbol: Value(userSettings['currencySymbol'] as String? ?? '\$'),
          thousandsSeparator: Value(userSettings['thousandsSeparator'] as String? ?? ','),
          decimalSeparator: Value(userSettings['decimalSeparator'] as String? ?? '.'),
          notificationsEnabled: Value(userSettings['notificationsEnabled'] as bool? ?? true),
          budgetAlertsEnabled: Value(userSettings['budgetAlertsEnabled'] as bool? ?? true),
          loanRemindersEnabled: Value(userSettings['loanRemindersEnabled'] as bool? ?? true),
          savingsRemindersEnabled: Value(userSettings['savingsRemindersEnabled'] as bool? ?? true),
          notificationPermissionAsked: Value(userSettings['notificationPermissionAsked'] as bool? ?? false),
          balanceResetPeriod: Value(userSettings['balanceResetPeriod'] as String? ?? 'total'),
          balanceResetDayOfMonth: Value(userSettings['balanceResetDayOfMonth'] as int?),
          balanceResetDayOfWeek: Value(userSettings['balanceResetDayOfWeek'] as int?),
          theme: Value(userSettings['theme'] as String?),
          trendChartType: Value(userSettings['trendChartType'] as String? ?? 'bars'),
          incomeChartType: Value(userSettings['incomeChartType'] as String? ?? 'pie'),
          expenseChartType: Value(userSettings['expenseChartType'] as String? ?? 'pie'),
        ));
      }
      
      // Importar transacciones recurrentes
      final recurringTransactions = data['recurringTransactions'] as List<dynamic>? ?? [];
      for (final r in recurringTransactions) {
        await _db.insertRecurringTransaction(db.RecurringTransactionsCompanion(
          id: Value(r['id'] as String),
          title: Value(r['title'] as String),
          amount: Value((r['amount'] as num).toDouble()),
          type: Value(r['type'] as String),
          category: Value(r['category'] as String),
          source: Value(r['source'] as String?),
          frequency: Value(r['frequency'] as String),
          dayOfMonth: Value(r['dayOfMonth'] as int?),
          dayOfWeek: Value(r['dayOfWeek'] as int?),
          startDate: Value(DateTime.parse(r['startDate'] as String)),
          endDate: Value(r['endDate'] != null ? DateTime.parse(r['endDate'] as String) : null),
          lastProcessedDate: Value(r['lastProcessedDate'] != null ? DateTime.parse(r['lastProcessedDate'] as String) : null),
          isActive: Value(r['isActive'] as bool? ?? true),
          description: Value(r['description'] as String?),
          notificationsEnabled: Value(r['notificationsEnabled'] as bool? ?? false),
          notificationHour: Value(r['notificationHour'] as int?),
          notificationMinute: Value(r['notificationMinute'] as int?),
          linkedFinanceModule: Value(r['linkedFinanceModule'] as String?),
          linkedLoanId: Value(r['linkedLoanId'] as String?),
          linkedSavingsGoalId: Value(r['linkedSavingsGoalId'] as String?),
        ));
      }
      
      // Recargar todos los datos
      await _loadData();
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error importing data: $e');
      rethrow;
    }
  }
  
  /// Elimina todos los datos de la app
  Future<void> clearAllData() async {
    try {
      // Obtener datos actuales de la base de datos (no de memoria)
      final allTransactions = await _db.getAllTransactions();
      final allBudgets = await _db.getAllBudgets();
      final allCustomCategories = await _db.getAllCustomCategories();
      final allCustomIncomeSources = await _db.getAllCustomIncomeSources();
      final allSavingsGoals = await _db.getAllSavingsGoals();
      final allInvestments = await _db.getAllInvestments();
      final allLoans = await _db.getAllLoans();
      final allRecurring = await _db.getAllRecurringTransactions();
      
      // Eliminar todas las transacciones
      for (final t in allTransactions) {
        await _db.deleteTransaction(t.id);
      }
      
      // Eliminar todos los presupuestos
      for (final b in allBudgets) {
        await _db.deleteBudget(b.id);
      }
      
      // Eliminar todas las alertas
      await _db.clearAllAlerts();
      
      // Eliminar categorías personalizadas
      for (final c in allCustomCategories) {
        await _db.deleteCustomCategory(c.name);
      }
      
      // Eliminar fuentes personalizadas
      for (final c in allCustomIncomeSources) {
        await _db.deleteCustomIncomeSource(c.name);
      }
      
      // Restaurar categorías ocultas
      await _db.unhideAllDefaultCategories();
      await _db.unhideAllDefaultIncomeSources();
      
      // Eliminar metas de ahorro (incluye contribuciones)
      for (final s in allSavingsGoals) {
        await _db.deleteSavingsGoal(s.id);
      }
      
      // Eliminar inversiones (incluye historial)
      for (final i in allInvestments) {
        await _db.deleteInvestment(i.id);
      }
      
      // Eliminar préstamos (incluye pagos)
      for (final l in allLoans) {
        await _db.deleteLoan(l.id);
      }
      
      // Eliminar transacciones recurrentes
      for (final r in allRecurring) {
        await _db.deleteRecurringTransaction(r.id);
      }
      
      // Limpiar listas en memoria
      _transactions.clear();
      _budgets.clear();
      _alerts.clear();
      _customCategories.clear();
      _customIncomeSources.clear();
      _hiddenDefaultCategories.clear();
      _hiddenDefaultIncomeSources.clear();
      _savingsGoals.clear();
      _investments.clear();
      _loans.clear();
      
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error clearing data: $e');
      rethrow;
    }
  }
}
