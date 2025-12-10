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
    await _db.processRecurringTransactions();
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
    );
  }

  TransactionsCompanion _toDbTransaction(models.Transaction transaction) {
    return TransactionsCompanion.insert(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      type: transaction.type == models.TransactionType.income
          ? 'income'
          : 'expense',
      category: transaction.category,
      date: transaction.date,
      description: Value(transaction.description),
      source: Value(transaction.source),
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
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final transaction = _transactions.firstWhere((t) => t.id == id);
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
      filtered = filtered.where((t) => t.category == category).toList();
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
      } catch (e) {
        debugPrint('Error adding category: $e');
        rethrow;
      }
    }
  }

  Future<void> deleteCustomCategory(String category) async {
    try {
      await _db.deleteCustomCategory(category);
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
      } catch (e) {
        debugPrint('Error adding income source: $e');
        rethrow;
      }
    }
  }

  Future<void> deleteCustomIncomeSource(String source) async {
    try {
      await _db.deleteCustomIncomeSource(source);
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
      {String? note, DateTime? date}) async {
    try {
      await _db.insertSavingsContribution(SavingsContributionsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        savingsGoalId: goalId,
        amount: amount,
        date: date ?? DateTime.now(),
        note: Value(note),
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
      {String? notes, DateTime? date}) async {
    try {
      await _db.insertLoanPayment(LoanPaymentsCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        loanId: loanId,
        amount: amount,
        date: date ?? DateTime.now(),
        installmentNumber: installmentNumber,
        notes: Value(notes),
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
              ))
          .toList();
    } catch (e) {
      debugPrint('Error getting loan payments: $e');
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

  // ========== RESUMEN FINANCIERO ==========
  Future<Map<String, double>> getFinancialSummary() async {
    final start = userSettings.getCurrentPeriodStart();
    final end = userSettings.getCurrentPeriodEnd();
    return _db.getPeriodSummary(start, end);
  }
}
