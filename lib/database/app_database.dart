import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ========== TABLA DE TRANSACCIONES ==========
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'income' o 'expense'
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().nullable()();
  TextColumn get source => text().nullable()(); // Fuente de ingreso
  BoolColumn get isRecurring => boolean().withDefault(const Constant(false))();
  TextColumn get recurringFrequency =>
      text().nullable()(); // weekly, monthly, yearly

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE PRESUPUESTOS ==========
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  RealColumn get maxAmount => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE ALERTAS ==========
class Alerts extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  TextColumn get type => text()(); // 'warning' o 'exceeded'
  RealColumn get currentAmount => real()();
  RealColumn get maxAmount => real()();
  RealColumn get percentage => real()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE CATEGORÍAS PERSONALIZADAS ==========
class CustomCategories extends Table {
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {name};
}

// ========== TABLA DE FUENTES DE INGRESO PERSONALIZADAS ==========
class CustomIncomeSources extends Table {
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {name};
}

// ========== TABLA DE FUENTES PREDEFINIDAS OCULTAS ==========
class HiddenDefaultIncomeSources extends Table {
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {name};
}

// ========== TABLA DE CATEGORÍAS PREDEFINIDAS OCULTAS ==========
class HiddenDefaultCategories extends Table {
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {name};
}

// ========== TABLA DE METAS DE AHORRO ==========
class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get targetDate => dateTime().nullable()();
  TextColumn get status => text()
      .withDefault(const Constant('active'))(); // active, completed, cancelled
  TextColumn get iconName => text().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get contributionFrequency => text().withDefault(
      const Constant('monthly'))(); // daily, weekly, biweekly, monthly, custom
  TextColumn get notificationDays =>
      text().nullable()(); // Días para notificación según frecuencia
  TextColumn get notificationTime =>
      text().nullable()(); // Hora de notificación (HH:mm)

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE CONTRIBUCIONES A METAS DE AHORRO ==========
class SavingsContributions extends Table {
  TextColumn get id => text()();
  TextColumn get savingsGoalId => text().references(SavingsGoals, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE INVERSIONES ==========
class Investments extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text()(); // stocks, bonds, crypto, realEstate, etc.
  RealColumn get initialAmount => real()();
  RealColumn get currentValue => real()();
  RealColumn get expectedReturnRate => real()(); // Tasa de rentabilidad
  TextColumn get returnRatePeriod => text().withDefault(
      const Constant('yearly'))(); // daily, weekly, monthly, yearly
  DateTimeColumn get purchaseDate => dateTime()();
  DateTimeColumn get soldDate => dateTime().nullable()();
  RealColumn get soldAmount => real().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('active'))(); // active, sold, cancelled
  TextColumn get platformOrBroker => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get compoundingFrequency =>
      integer().withDefault(const Constant(12))(); // Veces al año
  TextColumn get iconName => text().nullable()(); // Icono personalizado
  TextColumn get color => text().nullable()(); // Color personalizado (hex)
  TextColumn get notificationDays =>
      text().nullable()(); // Días del mes para notificación (ej: "1,15,28")
  TextColumn get notificationTime =>
      text().nullable()(); // Hora de notificación (HH:mm)

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE HISTORIAL DE VALORES DE INVERSIÓN ==========
class InvestmentValueHistory extends Table {
  TextColumn get id => text()();
  TextColumn get investmentId => text().references(Investments, #id)();
  RealColumn get value => real()();
  DateTimeColumn get date => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE PRÉSTAMOS ==========
class Loans extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get borrowerOrLender =>
      text().nullable()(); // Nombre del prestatario/prestamista
  TextColumn get type =>
      text()(); // 'given' (yo presté) o 'received' (me prestaron)
  RealColumn get principalAmount => real()();
  RealColumn get interestRate => real()(); // Tasa de interés
  TextColumn get interestRatePeriod => text().withDefault(
      const Constant('yearly'))(); // daily, weekly, monthly, yearly
  IntColumn get totalInstallments => integer()();
  RealColumn get installmentAmount => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get paymentFrequency => text().withDefault(const Constant(
      'monthly'))(); // weekly, biweekly, monthly, quarterly, yearly
  TextColumn get status => text().withDefault(
      const Constant('active'))(); // active, paidOff, defaulted, cancelled
  TextColumn get notes => text().nullable()();
  RealColumn get paidAmount => real().withDefault(const Constant(0.0))();
  IntColumn get paidInstallments => integer().withDefault(const Constant(0))();
  TextColumn get iconName => text().nullable()(); // Icono personalizado
  TextColumn get color => text().nullable()(); // Color personalizado (hex)
  TextColumn get notificationDays =>
      text().nullable()(); // Selección principal de notificación
  IntColumn get notificationDayOfMonth => integer()
      .nullable()(); // Día del mes para notificaciones trimestrales/anuales
  TextColumn get notificationTime =>
      text().nullable()(); // Hora de notificación (HH:mm)

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE PAGOS DE PRÉSTAMOS ==========
class LoanPayments extends Table {
  TextColumn get id => text()();
  TextColumn get loanId => text().references(Loans, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  IntColumn get installmentNumber => integer()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ========== TABLA DE CONFIGURACIÓN DEL USUARIO ==========
class UserSettingsTable extends Table {
  TextColumn get id => text()();
  IntColumn get monthStartDay =>
      integer().withDefault(const Constant(1))(); // 1-28
  TextColumn get currency => text().withDefault(const Constant('COP'))();
  TextColumn get currencySymbol => text().withDefault(const Constant('\$'))();
  TextColumn get thousandsSeparator =>
      text().withDefault(const Constant(','))();
  TextColumn get decimalSeparator => text().withDefault(const Constant('.'))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get budgetAlertsEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get loanRemindersEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get savingsRemindersEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get notificationPermissionAsked => boolean()
      .withDefault(const Constant(false))(); // Si ya se pidieron permisos
  TextColumn get balanceResetPeriod => text().withDefault(
      const Constant('total'))(); // Período de reinicio del balance
  IntColumn get balanceResetDayOfMonth =>
      integer().nullable()(); // Día del mes para reinicio mensual (1-28)
  IntColumn get balanceResetDayOfWeek => integer()
      .nullable()(); // Día de la semana para reinicio semanal (1=lunes, 7=domingo)
  TextColumn get theme => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'user_settings';
}

// ========== TABLA DE INGRESOS RECURRENTES ==========
class RecurringTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'income' o 'expense'
  TextColumn get category => text()();
  TextColumn get source => text().nullable()();
  TextColumn get frequency =>
      text()(); // weekly, biweekly, monthly, quarterly, yearly
  IntColumn get dayOfMonth =>
      integer().nullable()(); // Día del mes para frecuencia mensual
  IntColumn get dayOfWeek =>
      integer().nullable()(); // Día de la semana (1-7) para frecuencia semanal
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get lastProcessedDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get description => text().nullable()();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get notificationHour =>
      integer().nullable()(); // Hora de notificación (0-23)
  IntColumn get notificationMinute =>
      integer().nullable()(); // Minuto de notificación (0-59)
  TextColumn get linkedFinanceModule =>
      text().nullable()(); // 'loan' o 'savings'
  TextColumn get linkedLoanId => text().nullable()(); // ID del préstamo vinculado
  TextColumn get linkedSavingsGoalId =>
      text().nullable()(); // ID de la meta de ahorro vinculada

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Transactions,
  Budgets,
  Alerts,
  CustomCategories,
  CustomIncomeSources,
  HiddenDefaultIncomeSources,
  HiddenDefaultCategories,
  SavingsGoals,
  SavingsContributions,
  Investments,
  InvestmentValueHistory,
  Loans,
  LoanPayments,
  UserSettingsTable,
  RecurringTransactions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 16;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insertar configuración por defecto
        await into(userSettingsTable).insert(
          UserSettingsTableCompanion.insert(
            id: 'default_user',
            createdAt: DateTime.now(),
          ),
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Migración de versión 1 a 2
          await m.createTable(savingsGoals);
          await m.createTable(savingsContributions);
          await m.createTable(investments);
          await m.createTable(investmentValueHistory);
          await m.createTable(loans);
          await m.createTable(loanPayments);
          await m.createTable(userSettingsTable);
          await m.createTable(recurringTransactions);

          // Insertar configuración por defecto si no existe
          await into(userSettingsTable).insert(
            UserSettingsTableCompanion.insert(
              id: 'default_user',
              createdAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
        }
        if (from < 3) {
          // Migración de versión 2 a 3
          // Crear tabla de fuentes de ingreso personalizadas
          await m.createTable(customIncomeSources);

          // Agregar columnas de formato de números a user_settings
          await customStatement(
            'ALTER TABLE user_settings ADD COLUMN thousands_separator TEXT NOT NULL DEFAULT ","',
          );
          await customStatement(
            'ALTER TABLE user_settings ADD COLUMN decimal_separator TEXT NOT NULL DEFAULT "."',
          );
        }
        if (from < 4) {
          // Migración de versión 3 a 4
          // Agregar iconName y color a inversiones
          await customStatement(
            'ALTER TABLE investments ADD COLUMN icon_name TEXT',
          );
          await customStatement(
            'ALTER TABLE investments ADD COLUMN color TEXT',
          );
          // Agregar iconName y color a préstamos
          await customStatement(
            'ALTER TABLE loans ADD COLUMN icon_name TEXT',
          );
          await customStatement(
            'ALTER TABLE loans ADD COLUMN color TEXT',
          );
        }
        if (from < 5) {
          // Migración de versión 4 a 5
          // Agregar notificationDay a ahorros, inversiones y préstamos
          await customStatement(
            'ALTER TABLE savings_goals ADD COLUMN notification_day INTEGER',
          );
          await customStatement(
            'ALTER TABLE investments ADD COLUMN notification_day INTEGER',
          );
          await customStatement(
            'ALTER TABLE loans ADD COLUMN notification_day INTEGER',
          );
        }
        if (from < 6) {
          // Migración de versión 5 a 6
          // Agregar campo para rastrear si se pidieron permisos de notificaciones
          await customStatement(
            'ALTER TABLE user_settings ADD COLUMN notification_permission_asked INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (from < 7) {
          // Migración de versión 6 a 7
          // Cambiar notification_day (INTEGER) a notification_days (TEXT) para soportar múltiples días

          // Agregar nuevas columnas TEXT
          await customStatement(
            'ALTER TABLE savings_goals ADD COLUMN notification_days TEXT',
          );
          await customStatement(
            'ALTER TABLE investments ADD COLUMN notification_days TEXT',
          );
          await customStatement(
            'ALTER TABLE loans ADD COLUMN notification_days TEXT',
          );

          // Migrar datos existentes de notification_day a notification_days
          await customStatement(
            'UPDATE savings_goals SET notification_days = CAST(notification_day AS TEXT) WHERE notification_day IS NOT NULL',
          );
          await customStatement(
            'UPDATE investments SET notification_days = CAST(notification_day AS TEXT) WHERE notification_day IS NOT NULL',
          );
          await customStatement(
            'UPDATE loans SET notification_days = CAST(notification_day AS TEXT) WHERE notification_day IS NOT NULL',
          );
        }
        if (from < 8) {
          // Migración de versión 7 a 8
          // Crear tablas para ocultar fuentes de ingreso y categorías predefinidas
          await m.createTable(hiddenDefaultIncomeSources);
          await m.createTable(hiddenDefaultCategories);
        }
        if (from < 9) {
          // Migración de versión 8 a 9
          // Agregar periodicidad de tasa de interés a préstamos
          await customStatement(
            "ALTER TABLE loans ADD COLUMN interest_rate_period TEXT NOT NULL DEFAULT 'yearly'",
          );
        }
        if (from < 10) {
          // Migración de versión 9 a 10
          // Agregar periodicidad de tasa de rentabilidad a inversiones
          // Esta migración es esencial para bases de datos antiguas (versión 9)
          // que no tienen la columna return_rate_period.
          // Para instalaciones nuevas, la columna se crea automáticamente en onCreate.
          // Usamos un enfoque que verifica si la columna existe antes de agregarla
          // para evitar errores de "duplicate column name"
          try {
            // Intentar agregar la columna
          await customStatement(
            "ALTER TABLE investments ADD COLUMN return_rate_period TEXT NOT NULL DEFAULT 'yearly'",
          );
          } catch (e) {
            // Si falla, verificar si es por columna duplicada
            final errorString = e.toString();
            // Si NO es un error de columna duplicada, relanzar el error
            if (!errorString.contains('duplicate column') &&
                !errorString.contains('duplicate column name') &&
                !errorString.contains('SQL logic error')) {
              rethrow;
            }
            // Si es error de columna duplicada, ignorar silenciosamente
            // La columna ya existe, lo cual es correcto
          }
        }
        if (from < 11) {
          // Migración de versión 10 a 11
          // Agregar campos adicionales de notificación a préstamos
          await customStatement(
            'ALTER TABLE loans ADD COLUMN notification_day_of_month INTEGER',
          );
          await customStatement(
            'ALTER TABLE loans ADD COLUMN notification_time TEXT',
          );
        }
        if (from < 12) {
          // Migración de versión 11 a 12
          // Agregar hora de notificación a ahorros e inversiones
          await customStatement(
            'ALTER TABLE savings_goals ADD COLUMN notification_time TEXT',
          );
          await customStatement(
            'ALTER TABLE investments ADD COLUMN notification_time TEXT',
          );
        }
        if (from < 13) {
          // Migración de versión 12 a 13
          // Agregar frecuencia de aportes a ahorros
          await customStatement(
            "ALTER TABLE savings_goals ADD COLUMN contribution_frequency TEXT DEFAULT 'monthly'",
          );
        }
        if (from < 14) {
          // Migración de versión 13 a 14
          // Agregar período de reinicio del balance
          await customStatement(
            "ALTER TABLE user_settings ADD COLUMN balance_reset_period TEXT NOT NULL DEFAULT 'total'",
          );
        }
        if (from < 15) {
          // Migración de versión 14 a 15
          // Agregar día del mes y día de la semana para reinicio personalizado
          await customStatement(
            'ALTER TABLE user_settings ADD COLUMN balance_reset_day_of_month INTEGER',
          );
          await customStatement(
            'ALTER TABLE user_settings ADD COLUMN balance_reset_day_of_week INTEGER',
          );
        }
        if (from < 16) {
          // Migración de versión 15 a 16
          // Verificar y agregar columna theme si no existe
          try {
            // Verificar si la columna ya existe antes de agregarla
            final result = await customSelect(
              "PRAGMA table_info(user_settings)",
              readsFrom: {},
            ).get();

            final hasColumn = result.any(
                (row) => row.data['name']?.toString().toLowerCase() == 'theme');

            if (!hasColumn) {
              await customStatement(
                "ALTER TABLE user_settings ADD COLUMN theme TEXT",
              );
            }
          } catch (e) {
            // Si falla la verificación, intentar agregar la columna directamente
            // y si falla por duplicado, ignorarlo
            try {
              await customStatement(
                "ALTER TABLE user_settings ADD COLUMN theme TEXT",
              );
            } catch (e2) {
              final errorMsg = e2.toString().toLowerCase();
              if (!errorMsg.contains('duplicate column') &&
                  !errorMsg.contains('duplicate column name')) {
                rethrow;
              }
              // La columna ya existe, continuar sin error
            }
          }
        }
      },
    );
  }

  // ========== TRANSACCIONES ==========
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();

  Stream<List<Transaction>> watchAllTransactions() =>
      select(transactions).watch();

  Future<Transaction?> getTransactionById(String id) {
    return (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime start, DateTime end) {
    return (select(transactions)
          ..where((t) =>
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<Transaction>> getTransactionsByType(String type) {
    return (select(transactions)
          ..where((t) => t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<List<Transaction>> getTransactionsByCategory(String category) {
    return (select(transactions)
          ..where((t) => t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction, mode: InsertMode.replace);
  }

  Future<bool> updateTransaction(TransactionsCompanion transaction) {
    return update(transactions).replace(transaction);
  }

  Future<int> deleteTransaction(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  // Suma de transacciones por tipo en un rango de fechas
  Future<double> sumTransactionsByTypeAndDateRange(
      String type, DateTime start, DateTime end) async {
    final result = await (select(transactions)
          ..where((t) =>
              t.type.equals(type) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end)))
        .get();
    return result.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  // ========== PRESUPUESTOS ==========
  Future<List<Budget>> getAllBudgets() => select(budgets).get();

  Stream<List<Budget>> watchAllBudgets() => select(budgets).watch();

  Future<Budget?> getBudgetByCategory(String category) {
    return (select(budgets)..where((b) => b.category.equals(category)))
        .getSingleOrNull();
  }

  Future<int> insertBudget(BudgetsCompanion budget) {
    return into(budgets).insert(budget, mode: InsertMode.replace);
  }

  Future<bool> updateBudget(BudgetsCompanion budget) {
    return update(budgets).replace(budget);
  }

  Future<int> deleteBudget(String id) {
    return (delete(budgets)..where((b) => b.id.equals(id))).go();
  }

  // ========== ALERTAS ==========
  Future<List<Alert>> getAllAlerts() => select(alerts).get();

  Stream<List<Alert>> watchAllAlerts() => select(alerts).watch();

  Future<List<Alert>> getUnreadAlerts() {
    return (select(alerts)..where((a) => a.isRead.equals(false))).get();
  }

  Future<int> insertAlert(AlertsCompanion alert) {
    return into(alerts).insert(alert, mode: InsertMode.replace);
  }

  Future<bool> updateAlert(AlertsCompanion alert) {
    return update(alerts).replace(alert);
  }

  Future<int> deleteAlert(String id) {
    return (delete(alerts)..where((a) => a.id.equals(id))).go();
  }

  Future<int> deleteAlertsByCategory(String category) {
    return (delete(alerts)
          ..where((a) => a.category.equals(category) & a.isRead.equals(false)))
        .go();
  }

  Future<int> markAlertAsRead(String id) {
    return (update(alerts)..where((a) => a.id.equals(id)))
        .write(const AlertsCompanion(isRead: Value(true)));
  }

  Future<int> clearAllAlerts() {
    return delete(alerts).go();
  }

  // ========== CATEGORÍAS PERSONALIZADAS ==========
  Future<List<CustomCategory>> getAllCustomCategories() =>
      select(customCategories).get();

  Stream<List<CustomCategory>> watchAllCustomCategories() =>
      select(customCategories).watch();

  Future<int> insertCustomCategory(String name) {
    return into(customCategories)
        .insert(CustomCategoriesCompanion.insert(name: name));
  }

  Future<int> deleteCustomCategory(String name) {
    return (delete(customCategories)..where((c) => c.name.equals(name))).go();
  }

  // ========== FUENTES DE INGRESO PERSONALIZADAS ==========
  Future<List<CustomIncomeSource>> getAllCustomIncomeSources() =>
      select(customIncomeSources).get();

  Stream<List<CustomIncomeSource>> watchAllCustomIncomeSources() =>
      select(customIncomeSources).watch();

  Future<int> insertCustomIncomeSource(String name) {
    return into(customIncomeSources)
        .insert(CustomIncomeSourcesCompanion.insert(name: name));
  }

  Future<int> deleteCustomIncomeSource(String name) {
    return (delete(customIncomeSources)..where((c) => c.name.equals(name)))
        .go();
  }

  // ========== FUENTES DE INGRESO PREDEFINIDAS OCULTAS ==========
  Future<List<HiddenDefaultIncomeSource>> getAllHiddenDefaultIncomeSources() =>
      select(hiddenDefaultIncomeSources).get();

  Future<int> hideDefaultIncomeSource(String name) {
    return into(hiddenDefaultIncomeSources).insert(
      HiddenDefaultIncomeSourcesCompanion.insert(name: name),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<int> unhideDefaultIncomeSource(String name) {
    return (delete(hiddenDefaultIncomeSources)
          ..where((c) => c.name.equals(name)))
        .go();
  }

  Future<void> unhideAllDefaultIncomeSources() {
    return delete(hiddenDefaultIncomeSources).go();
  }

  // ========== CATEGORÍAS PREDEFINIDAS OCULTAS ==========
  Future<List<HiddenDefaultCategory>> getAllHiddenDefaultCategories() =>
      select(hiddenDefaultCategories).get();

  Future<int> hideDefaultCategory(String name) {
    return into(hiddenDefaultCategories).insert(
      HiddenDefaultCategoriesCompanion.insert(name: name),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<int> unhideDefaultCategory(String name) {
    return (delete(hiddenDefaultCategories)..where((c) => c.name.equals(name)))
        .go();
  }

  Future<void> unhideAllDefaultCategories() {
    return delete(hiddenDefaultCategories).go();
  }

  // ========== METAS DE AHORRO ==========
  Future<List<SavingsGoal>> getAllSavingsGoals() => select(savingsGoals).get();

  Stream<List<SavingsGoal>> watchAllSavingsGoals() =>
      select(savingsGoals).watch();

  Stream<List<SavingsGoal>> watchActiveSavingsGoals() {
    return (select(savingsGoals)..where((s) => s.status.equals('active')))
        .watch();
  }

  Future<SavingsGoal?> getSavingsGoalById(String id) {
    return (select(savingsGoals)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> insertSavingsGoal(SavingsGoalsCompanion goal) {
    return into(savingsGoals).insert(goal, mode: InsertMode.replace);
  }

  Future<bool> updateSavingsGoal(SavingsGoalsCompanion goal) {
    return update(savingsGoals).replace(goal);
  }

  Future<int> deleteSavingsGoal(String id) async {
    // Primero eliminar contribuciones asociadas
    await (delete(savingsContributions)
          ..where((c) => c.savingsGoalId.equals(id)))
        .go();
    return (delete(savingsGoals)..where((s) => s.id.equals(id))).go();
  }

  // Actualizar monto actual de meta de ahorro
  Future<void> updateSavingsGoalAmount(String goalId, double newAmount) async {
    await (update(savingsGoals)..where((s) => s.id.equals(goalId)))
        .write(SavingsGoalsCompanion(currentAmount: Value(newAmount)));

    // Verificar si se completó la meta
    final goal = await getSavingsGoalById(goalId);
    if (goal != null && newAmount >= goal.targetAmount) {
      await (update(savingsGoals)..where((s) => s.id.equals(goalId)))
          .write(const SavingsGoalsCompanion(status: Value('completed')));
    }
  }

  // ========== CONTRIBUCIONES A METAS DE AHORRO ==========
  Future<List<SavingsContribution>> getContributionsByGoalId(String goalId) {
    return (select(savingsContributions)
          ..where((c) => c.savingsGoalId.equals(goalId))
          ..orderBy([(c) => OrderingTerm.desc(c.date)]))
        .get();
  }

  Stream<List<SavingsContribution>> watchContributionsByGoalId(String goalId) {
    return (select(savingsContributions)
          ..where((c) => c.savingsGoalId.equals(goalId))
          ..orderBy([(c) => OrderingTerm.desc(c.date)]))
        .watch();
  }

  Future<int> insertSavingsContribution(
      SavingsContributionsCompanion contribution) async {
    final result = await into(savingsContributions).insert(contribution);

    // Actualizar el monto actual de la meta
    final goal = await getSavingsGoalById(contribution.savingsGoalId.value);
    if (goal != null) {
      final newAmount = goal.currentAmount + contribution.amount.value;
      await updateSavingsGoalAmount(
          contribution.savingsGoalId.value, newAmount);
    }

    return result;
  }

  Future<int> deleteSavingsContribution(
      String id, String goalId, double amount) async {
    final result = await (delete(savingsContributions)
          ..where((c) => c.id.equals(id)))
        .go();

    // Actualizar el monto de la meta
    final goal = await getSavingsGoalById(goalId);
    if (goal != null) {
      final newAmount = goal.currentAmount - amount;
      await (update(savingsGoals)..where((s) => s.id.equals(goalId))).write(
          SavingsGoalsCompanion(
              currentAmount: Value(newAmount > 0 ? newAmount : 0)));
    }

    return result;
  }

  // ========== INVERSIONES ==========
  Future<List<Investment>> getAllInvestments() => select(investments).get();

  Stream<List<Investment>> watchAllInvestments() => select(investments).watch();

  Stream<List<Investment>> watchActiveInvestments() {
    return (select(investments)..where((i) => i.status.equals('active')))
        .watch();
  }

  Future<Investment?> getInvestmentById(String id) {
    return (select(investments)..where((i) => i.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Investment>> getInvestmentsByType(String type) {
    return (select(investments)
          ..where((i) => i.type.equals(type))
          ..orderBy([(i) => OrderingTerm.desc(i.purchaseDate)]))
        .get();
  }

  Future<int> insertInvestment(InvestmentsCompanion investment) {
    return into(investments).insert(investment, mode: InsertMode.replace);
  }

  Future<bool> updateInvestment(InvestmentsCompanion investment) {
    return update(investments).replace(investment);
  }

  Future<int> deleteInvestment(String id) async {
    // Primero eliminar historial de valores
    await (delete(investmentValueHistory)
          ..where((h) => h.investmentId.equals(id)))
        .go();
    return (delete(investments)..where((i) => i.id.equals(id))).go();
  }

  // Actualizar valor actual de inversión
  Future<void> updateInvestmentValue(
      String investmentId, double newValue) async {
    await (update(investments)..where((i) => i.id.equals(investmentId)))
        .write(InvestmentsCompanion(currentValue: Value(newValue)));

    // Registrar en historial
    await into(investmentValueHistory).insert(
      InvestmentValueHistoryCompanion.insert(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        investmentId: investmentId,
        value: newValue,
        date: DateTime.now(),
      ),
    );
  }

  // Vender inversión
  Future<void> sellInvestment(String investmentId, double soldAmount) async {
    await (update(investments)..where((i) => i.id.equals(investmentId)))
        .write(InvestmentsCompanion(
      status: const Value('sold'),
      soldDate: Value(DateTime.now()),
      soldAmount: Value(soldAmount),
    ));
  }

  // Suma total de inversiones activas
  Future<double> getTotalActiveInvestmentsValue() async {
    final result = await (select(investments)
          ..where((i) => i.status.equals('active')))
        .get();
    return result.fold<double>(0.0, (sum, i) => sum + i.currentValue);
  }

  // Suma total invertido
  Future<double> getTotalInvestedAmount() async {
    final result = await (select(investments)
          ..where((i) => i.status.equals('active')))
        .get();
    return result.fold<double>(0.0, (sum, i) => sum + i.initialAmount);
  }

  // ========== HISTORIAL DE VALORES DE INVERSIÓN ==========
  Future<List<InvestmentValueHistoryData>> getInvestmentHistory(
      String investmentId) {
    return (select(investmentValueHistory)
          ..where((h) => h.investmentId.equals(investmentId))
          ..orderBy([(h) => OrderingTerm.asc(h.date)]))
        .get();
  }

  // ========== PRÉSTAMOS ==========
  Future<List<Loan>> getAllLoans() => select(loans).get();

  Stream<List<Loan>> watchAllLoans() => select(loans).watch();

  Stream<List<Loan>> watchActiveLoans() {
    return (select(loans)..where((l) => l.status.equals('active'))).watch();
  }

  Future<Loan?> getLoanById(String id) {
    return (select(loans)..where((l) => l.id.equals(id))).getSingleOrNull();
  }

  Future<List<Loan>> getLoansByType(String type) {
    return (select(loans)
          ..where((l) => l.type.equals(type))
          ..orderBy([(l) => OrderingTerm.desc(l.startDate)]))
        .get();
  }

  Future<int> insertLoan(LoansCompanion loan) {
    return into(loans).insert(loan, mode: InsertMode.replace);
  }

  Future<bool> updateLoan(LoansCompanion loan) {
    return update(loans).replace(loan);
  }

  Future<int> deleteLoan(String id) async {
    // Primero eliminar pagos asociados
    await (delete(loanPayments)..where((p) => p.loanId.equals(id))).go();
    return (delete(loans)..where((l) => l.id.equals(id))).go();
  }

  // Suma de préstamos que debo (received)
  Future<double> getTotalDebt() async {
    final result = await (select(loans)
          ..where((l) => l.type.equals('received') & l.status.equals('active')))
        .get();
    return result.fold<double>(
        0.0, (sum, l) => sum + (l.principalAmount - l.paidAmount));
  }

  // Suma de préstamos que me deben (given)
  Future<double> getTotalReceivables() async {
    final result = await (select(loans)
          ..where((l) => l.type.equals('given') & l.status.equals('active')))
        .get();
    return result.fold<double>(
        0.0, (sum, l) => sum + (l.principalAmount - l.paidAmount));
  }

  // ========== PAGOS DE PRÉSTAMOS ==========
  Future<List<LoanPayment>> getPaymentsByLoanId(String loanId) {
    return (select(loanPayments)
          ..where((p) => p.loanId.equals(loanId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  Stream<List<LoanPayment>> watchPaymentsByLoanId(String loanId) {
    return (select(loanPayments)
          ..where((p) => p.loanId.equals(loanId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .watch();
  }

  Future<int> insertLoanPayment(LoanPaymentsCompanion payment) async {
    final result = await into(loanPayments).insert(payment);

    // Actualizar el préstamo
    final loan = await getLoanById(payment.loanId.value);
    if (loan != null) {
      final newPaidAmount = loan.paidAmount + payment.amount.value;
      final newPaidInstallments = loan.paidInstallments + 1;

      String newStatus = loan.status;
      if (newPaidAmount >= (loan.installmentAmount * loan.totalInstallments)) {
        newStatus = 'paidOff';
      }

      await (update(loans)..where((l) => l.id.equals(payment.loanId.value)))
          .write(LoansCompanion(
        paidAmount: Value(newPaidAmount),
        paidInstallments: Value(newPaidInstallments),
        status: Value(newStatus),
      ));
    }

    return result;
  }

  Future<int> deleteLoanPayment(String id, String loanId, double amount) async {
    final result =
        await (delete(loanPayments)..where((p) => p.id.equals(id))).go();

    // Actualizar el préstamo
    final loan = await getLoanById(loanId);
    if (loan != null) {
      final newPaidAmount = loan.paidAmount - amount;
      final newPaidInstallments = loan.paidInstallments - 1;

      await (update(loans)..where((l) => l.id.equals(loanId)))
          .write(LoansCompanion(
        paidAmount: Value(newPaidAmount > 0 ? newPaidAmount : 0),
        paidInstallments:
            Value(newPaidInstallments > 0 ? newPaidInstallments : 0),
        status: const Value('active'),
      ));
    }

    return result;
  }

  // ========== CONFIGURACIÓN DEL USUARIO ==========
  Future<UserSettingsTableData?> getUserSettings() {
    return (select(userSettingsTable)
          ..where((s) => s.id.equals('default_user')))
        .getSingleOrNull();
  }

  Stream<UserSettingsTableData?> watchUserSettings() {
    return (select(userSettingsTable)
          ..where((s) => s.id.equals('default_user')))
        .watchSingleOrNull();
  }

  Future<int> updateUserSettings(UserSettingsTableCompanion settings) {
    return (update(userSettingsTable)
          ..where((s) => s.id.equals('default_user')))
        .write(settings.copyWith(updatedAt: Value(DateTime.now())));
  }

  Future<void> setMonthStartDay(int day) async {
    if (day < 1 || day > 28) {
      throw ArgumentError('El día debe estar entre 1 y 28');
    }
    await updateUserSettings(
        UserSettingsTableCompanion(monthStartDay: Value(day)));
  }

  // ========== TRANSACCIONES RECURRENTES ==========
  Future<List<RecurringTransaction>> getAllRecurringTransactions() =>
      select(recurringTransactions).get();

  Stream<List<RecurringTransaction>> watchActiveRecurringTransactions() {
    return (select(recurringTransactions)
          ..where((r) => r.isActive.equals(true)))
        .watch();
  }

  Future<int> insertRecurringTransaction(
      RecurringTransactionsCompanion transaction) {
    return into(recurringTransactions)
        .insert(transaction, mode: InsertMode.replace);
  }

  Future<bool> updateRecurringTransaction(
      RecurringTransactionsCompanion transaction) {
    return update(recurringTransactions).replace(transaction);
  }

  Future<int> deleteRecurringTransaction(String id) {
    return (delete(recurringTransactions)..where((r) => r.id.equals(id))).go();
  }

  // Procesar transacciones recurrentes
  Future<void> processRecurringTransactions() async {
    final activeRecurring = await (select(recurringTransactions)
          ..where((r) => r.isActive.equals(true)))
        .get();

    final now = DateTime.now();

    for (final recurring in activeRecurring) {
      // Verificar si ya expiró
      if (recurring.endDate != null && recurring.endDate!.isBefore(now)) {
        await (update(recurringTransactions)
              ..where((r) => r.id.equals(recurring.id)))
            .write(
                const RecurringTransactionsCompanion(isActive: Value(false)));
        continue;
      }

      // Calcular la fecha/hora esperada para procesar esta transacción
      final expectedDateTime = _calculateExpectedProcessingDateTime(
        recurring: recurring,
        now: now,
      );

      if (expectedDateTime == null) {
        continue; // No es momento de procesar aún
      }

      // Verificar si ya pasó la fecha/hora esperada y si toca procesar
      // expectedDateTime ya fue verificado que no es null arriba
      if (now.isAfter(expectedDateTime) || now.isAtSameMomentAs(expectedDateTime)) {
        if (recurring.lastProcessedDate == null ||
            _shouldProcessRecurring(recurring, now)) {
          // Usar la fecha/hora esperada (no ahora) para mantener consistencia
          final processingDate = expectedDateTime.isBefore(now) 
              ? expectedDateTime 
              : DateTime(
                  now.year,
                  now.month,
                  now.day,
                  expectedDateTime.hour,
                  expectedDateTime.minute,
                );

          // Crear la transacción
          await insertTransaction(TransactionsCompanion.insert(
            id: '${recurring.id}_${processingDate.millisecondsSinceEpoch}',
            title: recurring.title,
            amount: recurring.amount,
            type: recurring.type,
            category: recurring.category,
            date: processingDate,
            description: Value(
                'Transacción recurrente: ${recurring.description ?? recurring.title}'),
            source: Value(recurring.source),
            isRecurring: const Value(true),
            recurringFrequency: Value(recurring.frequency),
          ));

          // Actualizar fecha de último procesamiento
          await (update(recurringTransactions)
                ..where((r) => r.id.equals(recurring.id)))
              .write(
                  RecurringTransactionsCompanion(lastProcessedDate: Value(processingDate)));
        }
      }
    }
  }

  /// Calcular la fecha/hora esperada para procesar una transacción recurrente
  DateTime? _calculateExpectedProcessingDateTime({
    required RecurringTransaction recurring,
    required DateTime now,
  }) {
    // Determinar la hora a usar: notificación si está configurada, sino 1pm (13:00)
    final processingHour = recurring.notificationHour ?? 13;
    final processingMinute = recurring.notificationMinute ?? 0;

    // Si la fecha de inicio es en el futuro, usar esa fecha con la hora configurada
    if (recurring.startDate.isAfter(now)) {
      return DateTime(
        recurring.startDate.year,
        recurring.startDate.month,
        recurring.startDate.day,
        processingHour,
        processingMinute,
      );
    }

    // Calcular la próxima fecha según la frecuencia
    DateTime? nextDate;

    switch (recurring.frequency) {
      case 'weekly':
        if (recurring.dayOfWeek == null) return null;
        // Calcular próximo día de la semana
        final dayOfWeek = recurring.dayOfWeek!;
        final daysUntilNext = (dayOfWeek - now.weekday + 7) % 7;
        if (daysUntilNext == 0) {
          // Si es hoy, verificar si ya pasó la hora
          final todayAtTime = DateTime(
            now.year,
            now.month,
            now.day,
            processingHour,
            processingMinute,
          );
          if (now.isBefore(todayAtTime)) {
            return todayAtTime;
          }
          // Si ya pasó, usar la próxima semana
          nextDate = now.add(const Duration(days: 7));
        } else {
          nextDate = now.add(Duration(days: daysUntilNext));
        }
        break;

      case 'biweekly':
        // Cada 14 días desde la fecha de inicio
        final daysSinceStart = now.difference(recurring.startDate).inDays;
        final periodsPassed = daysSinceStart ~/ 14;
        nextDate = recurring.startDate.add(Duration(days: (periodsPassed + 1) * 14));
        break;

      case 'monthly':
        if (recurring.dayOfMonth == null) return null;
        // Próximo mes con el día especificado
        final dayOfMonth = recurring.dayOfMonth!;
        nextDate = DateTime(now.year, now.month, dayOfMonth, processingHour, processingMinute);
        if (nextDate.isBefore(now) || (nextDate.day != dayOfMonth)) {
          // Si ya pasó este mes o el día no existe, ir al siguiente mes
          nextDate = DateTime(now.year, now.month + 1, dayOfMonth, processingHour, processingMinute);
        }
        break;

      case 'quarterly':
        // Cada 3 meses desde la fecha de inicio
        final monthsSinceStart = (now.year - recurring.startDate.year) * 12 + now.month - recurring.startDate.month;
        final quartersPassed = monthsSinceStart ~/ 3;
        nextDate = DateTime(
          recurring.startDate.year,
          recurring.startDate.month + (quartersPassed + 1) * 3,
          recurring.startDate.day,
          processingHour,
          processingMinute,
        );
        break;

      case 'yearly':
        // Cada año desde la fecha de inicio
        nextDate = DateTime(
          now.year + 1,
          recurring.startDate.month,
          recurring.startDate.day,
          processingHour,
          processingMinute,
        );
        break;

      default:
        return null;
    }

    // Asegurar que la hora y minuto sean correctos
    // nextDate siempre tiene un valor aquí (el switch retorna null en default antes de llegar aquí)
    final finalDate = DateTime(
      nextDate.year,
      nextDate.month,
      nextDate.day,
      processingHour,
      processingMinute,
    );

    // Si hay fecha de fin y la próxima fecha la excede, no procesar
    final endDate = recurring.endDate;
    if (endDate != null && finalDate.isAfter(endDate)) {
      return null;
    }

    return finalDate;
  }

  bool _shouldProcessRecurring(RecurringTransaction recurring, DateTime now) {
    final lastProcessed = recurring.lastProcessedDate;
    if (lastProcessed == null) return true;

    switch (recurring.frequency) {
      case 'weekly':
        return now.difference(lastProcessed).inDays >= 7;
      case 'biweekly':
        return now.difference(lastProcessed).inDays >= 14;
      case 'monthly':
        return lastProcessed.month != now.month ||
            lastProcessed.year != now.year;
      case 'quarterly':
        final monthsDiff = (now.year - lastProcessed.year) * 12 +
            now.month -
            lastProcessed.month;
        return monthsDiff >= 3;
      case 'yearly':
        return now.year > lastProcessed.year;
      default:
        return false;
    }
  }

  // ========== REPORTES Y ESTADÍSTICAS ==========

  // Resumen financiero del período actual
  Future<Map<String, double>> getPeriodSummary(
      DateTime start, DateTime end) async {
    final income =
        await sumTransactionsByTypeAndDateRange('income', start, end);
    final expenses =
        await sumTransactionsByTypeAndDateRange('expense', start, end);
    final investments = await getTotalActiveInvestmentsValue();
    final debt = await getTotalDebt();
    final receivables = await getTotalReceivables();

    final savingsGoalsList = await (select(savingsGoals)
          ..where((s) => s.status.equals('active')))
        .get();
    final totalSavings =
        savingsGoalsList.fold(0.0, (sum, s) => sum + s.currentAmount);

    return {
      'income': income,
      'expenses': expenses,
      'balance': income - expenses,
      'investments': investments,
      'debt': debt,
      'receivables': receivables,
      'savings': totalSavings,
      'netWorth':
          (income - expenses) + investments + receivables - debt + totalSavings,
    };
  }

  // Gastos por categoría en un período
  Future<Map<String, double>> getExpensesByCategory(
      DateTime start, DateTime end) async {
    final result = await (select(transactions)
          ..where((t) =>
              t.type.equals('expense') &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end)))
        .get();

    final Map<String, double> byCategory = {};
    for (final t in result) {
      byCategory[t.category] = (byCategory[t.category] ?? 0) + t.amount;
    }
    return byCategory;
  }

  // Ingresos por fuente en un período
  Future<Map<String, double>> getIncomeBySource(
      DateTime start, DateTime end) async {
    final result = await (select(transactions)
          ..where((t) =>
              t.type.equals('income') &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end)))
        .get();

    final Map<String, double> bySource = {};
    for (final t in result) {
      final source = t.source ?? 'Otros';
      bySource[source] = (bySource[source] ?? 0) + t.amount;
    }
    return bySource;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'brote_finances.db'));
    return NativeDatabase(file);
  });
}
