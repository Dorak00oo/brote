// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isRecurringMeta =
      const VerificationMeta('isRecurring');
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>(
      'is_recurring', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_recurring" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _recurringFrequencyMeta =
      const VerificationMeta('recurringFrequency');
  @override
  late final GeneratedColumn<String> recurringFrequency =
      GeneratedColumn<String>('recurring_frequency', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        amount,
        type,
        category,
        date,
        description,
        source,
        isRecurring,
        recurringFrequency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('is_recurring')) {
      context.handle(
          _isRecurringMeta,
          isRecurring.isAcceptableOrUnknown(
              data['is_recurring']!, _isRecurringMeta));
    }
    if (data.containsKey('recurring_frequency')) {
      context.handle(
          _recurringFrequencyMeta,
          recurringFrequency.isAcceptableOrUnknown(
              data['recurring_frequency']!, _recurringFrequencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      isRecurring: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurringFrequency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurring_frequency']),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final DateTime date;
  final String? description;
  final String? source;
  final bool isRecurring;
  final String? recurringFrequency;
  const Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.type,
      required this.category,
      required this.date,
      this.description,
      this.source,
      required this.isRecurring,
      this.recurringFrequency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurringFrequency != null) {
      map['recurring_frequency'] = Variable<String>(recurringFrequency);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      type: Value(type),
      category: Value(category),
      date: Value(date),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      isRecurring: Value(isRecurring),
      recurringFrequency: recurringFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringFrequency),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String?>(json['description']),
      source: serializer.fromJson<String?>(json['source']),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurringFrequency:
          serializer.fromJson<String?>(json['recurringFrequency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String?>(description),
      'source': serializer.toJson<String?>(source),
      'isRecurring': serializer.toJson<bool>(isRecurring),
      'recurringFrequency': serializer.toJson<String?>(recurringFrequency),
    };
  }

  Transaction copyWith(
          {String? id,
          String? title,
          double? amount,
          String? type,
          String? category,
          DateTime? date,
          Value<String?> description = const Value.absent(),
          Value<String?> source = const Value.absent(),
          bool? isRecurring,
          Value<String?> recurringFrequency = const Value.absent()}) =>
      Transaction(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        category: category ?? this.category,
        date: date ?? this.date,
        description: description.present ? description.value : this.description,
        source: source.present ? source.value : this.source,
        isRecurring: isRecurring ?? this.isRecurring,
        recurringFrequency: recurringFrequency.present
            ? recurringFrequency.value
            : this.recurringFrequency,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      date: data.date.present ? data.date.value : this.date,
      description:
          data.description.present ? data.description.value : this.description,
      source: data.source.present ? data.source.value : this.source,
      isRecurring:
          data.isRecurring.present ? data.isRecurring.value : this.isRecurring,
      recurringFrequency: data.recurringFrequency.present
          ? data.recurringFrequency.value
          : this.recurringFrequency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringFrequency: $recurringFrequency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, amount, type, category, date,
      description, source, isRecurring, recurringFrequency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.category == this.category &&
          other.date == this.date &&
          other.description == this.description &&
          other.source == this.source &&
          other.isRecurring == this.isRecurring &&
          other.recurringFrequency == this.recurringFrequency);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> category;
  final Value<DateTime> date;
  final Value<String?> description;
  final Value<String?> source;
  final Value<bool> isRecurring;
  final Value<String?> recurringFrequency;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringFrequency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String category,
    required DateTime date,
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.isRecurring = const Value.absent(),
    this.recurringFrequency = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        type = Value(type),
        category = Value(category),
        date = Value(date);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? category,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<String>? source,
    Expression<bool>? isRecurring,
    Expression<String>? recurringFrequency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
      if (isRecurring != null) 'is_recurring': isRecurring,
      if (recurringFrequency != null) 'recurring_frequency': recurringFrequency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? type,
      Value<String>? category,
      Value<DateTime>? date,
      Value<String?>? description,
      Value<String?>? source,
      Value<bool>? isRecurring,
      Value<String?>? recurringFrequency,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      source: source ?? this.source,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringFrequency: recurringFrequency ?? this.recurringFrequency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isRecurring.present) {
      map['is_recurring'] = Variable<bool>(isRecurring.value);
    }
    if (recurringFrequency.present) {
      map['recurring_frequency'] = Variable<String>(recurringFrequency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('isRecurring: $isRecurring, ')
          ..write('recurringFrequency: $recurringFrequency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _maxAmountMeta =
      const VerificationMeta('maxAmount');
  @override
  late final GeneratedColumn<double> maxAmount = GeneratedColumn<double>(
      'max_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, category, maxAmount, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(Insertable<Budget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('max_amount')) {
      context.handle(_maxAmountMeta,
          maxAmount.isAcceptableOrUnknown(data['max_amount']!, _maxAmountMeta));
    } else if (isInserting) {
      context.missing(_maxAmountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      maxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_amount'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String category;
  final double maxAmount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Budget(
      {required this.id,
      required this.category,
      required this.maxAmount,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['max_amount'] = Variable<double>(maxAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      category: Value(category),
      maxAmount: Value(maxAmount),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Budget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      maxAmount: serializer.fromJson<double>(json['maxAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'maxAmount': serializer.toJson<double>(maxAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Budget copyWith(
          {String? id,
          String? category,
          double? maxAmount,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Budget(
        id: id ?? this.id,
        category: category ?? this.category,
        maxAmount: maxAmount ?? this.maxAmount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      maxAmount: data.maxAmount.present ? data.maxAmount.value : this.maxAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('maxAmount: $maxAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, category, maxAmount, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.category == this.category &&
          other.maxAmount == this.maxAmount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> category;
  final Value<double> maxAmount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.maxAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String category,
    required double maxAmount,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        category = Value(category),
        maxAmount = Value(maxAmount),
        createdAt = Value(createdAt);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<double>? maxAmount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (maxAmount != null) 'max_amount': maxAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith(
      {Value<String>? id,
      Value<String>? category,
      Value<double>? maxAmount,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return BudgetsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      maxAmount: maxAmount ?? this.maxAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (maxAmount.present) {
      map['max_amount'] = Variable<double>(maxAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('maxAmount: $maxAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, Alert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentAmountMeta =
      const VerificationMeta('currentAmount');
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxAmountMeta =
      const VerificationMeta('maxAmount');
  @override
  late final GeneratedColumn<double> maxAmount = GeneratedColumn<double>(
      'max_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _percentageMeta =
      const VerificationMeta('percentage');
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
      'percentage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        category,
        type,
        currentAmount,
        maxAmount,
        percentage,
        createdAt,
        isRead
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(Insertable<Alert> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
          _currentAmountMeta,
          currentAmount.isAcceptableOrUnknown(
              data['current_amount']!, _currentAmountMeta));
    } else if (isInserting) {
      context.missing(_currentAmountMeta);
    }
    if (data.containsKey('max_amount')) {
      context.handle(_maxAmountMeta,
          maxAmount.isAcceptableOrUnknown(data['max_amount']!, _maxAmountMeta));
    } else if (isInserting) {
      context.missing(_maxAmountMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
          _percentageMeta,
          percentage.isAcceptableOrUnknown(
              data['percentage']!, _percentageMeta));
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alert(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_amount'])!,
      maxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_amount'])!,
      percentage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}percentage'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class Alert extends DataClass implements Insertable<Alert> {
  final String id;
  final String category;
  final String type;
  final double currentAmount;
  final double maxAmount;
  final double percentage;
  final DateTime createdAt;
  final bool isRead;
  const Alert(
      {required this.id,
      required this.category,
      required this.type,
      required this.currentAmount,
      required this.maxAmount,
      required this.percentage,
      required this.createdAt,
      required this.isRead});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    map['type'] = Variable<String>(type);
    map['current_amount'] = Variable<double>(currentAmount);
    map['max_amount'] = Variable<double>(maxAmount);
    map['percentage'] = Variable<double>(percentage);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      category: Value(category),
      type: Value(type),
      currentAmount: Value(currentAmount),
      maxAmount: Value(maxAmount),
      percentage: Value(percentage),
      createdAt: Value(createdAt),
      isRead: Value(isRead),
    );
  }

  factory Alert.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alert(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      type: serializer.fromJson<String>(json['type']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      maxAmount: serializer.fromJson<double>(json['maxAmount']),
      percentage: serializer.fromJson<double>(json['percentage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'type': serializer.toJson<String>(type),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'maxAmount': serializer.toJson<double>(maxAmount),
      'percentage': serializer.toJson<double>(percentage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  Alert copyWith(
          {String? id,
          String? category,
          String? type,
          double? currentAmount,
          double? maxAmount,
          double? percentage,
          DateTime? createdAt,
          bool? isRead}) =>
      Alert(
        id: id ?? this.id,
        category: category ?? this.category,
        type: type ?? this.type,
        currentAmount: currentAmount ?? this.currentAmount,
        maxAmount: maxAmount ?? this.maxAmount,
        percentage: percentage ?? this.percentage,
        createdAt: createdAt ?? this.createdAt,
        isRead: isRead ?? this.isRead,
      );
  Alert copyWithCompanion(AlertsCompanion data) {
    return Alert(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      type: data.type.present ? data.type.value : this.type,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      maxAmount: data.maxAmount.present ? data.maxAmount.value : this.maxAmount,
      percentage:
          data.percentage.present ? data.percentage.value : this.percentage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alert(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('maxAmount: $maxAmount, ')
          ..write('percentage: $percentage, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, type, currentAmount, maxAmount,
      percentage, createdAt, isRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alert &&
          other.id == this.id &&
          other.category == this.category &&
          other.type == this.type &&
          other.currentAmount == this.currentAmount &&
          other.maxAmount == this.maxAmount &&
          other.percentage == this.percentage &&
          other.createdAt == this.createdAt &&
          other.isRead == this.isRead);
}

class AlertsCompanion extends UpdateCompanion<Alert> {
  final Value<String> id;
  final Value<String> category;
  final Value<String> type;
  final Value<double> currentAmount;
  final Value<double> maxAmount;
  final Value<double> percentage;
  final Value<DateTime> createdAt;
  final Value<bool> isRead;
  final Value<int> rowid;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.type = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.maxAmount = const Value.absent(),
    this.percentage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertsCompanion.insert({
    required String id,
    required String category,
    required String type,
    required double currentAmount,
    required double maxAmount,
    required double percentage,
    required DateTime createdAt,
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        category = Value(category),
        type = Value(type),
        currentAmount = Value(currentAmount),
        maxAmount = Value(maxAmount),
        percentage = Value(percentage),
        createdAt = Value(createdAt);
  static Insertable<Alert> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? type,
    Expression<double>? currentAmount,
    Expression<double>? maxAmount,
    Expression<double>? percentage,
    Expression<DateTime>? createdAt,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (type != null) 'type': type,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (maxAmount != null) 'max_amount': maxAmount,
      if (percentage != null) 'percentage': percentage,
      if (createdAt != null) 'created_at': createdAt,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertsCompanion copyWith(
      {Value<String>? id,
      Value<String>? category,
      Value<String>? type,
      Value<double>? currentAmount,
      Value<double>? maxAmount,
      Value<double>? percentage,
      Value<DateTime>? createdAt,
      Value<bool>? isRead,
      Value<int>? rowid}) {
    return AlertsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      type: type ?? this.type,
      currentAmount: currentAmount ?? this.currentAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      percentage: percentage ?? this.percentage,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (maxAmount.present) {
      map['max_amount'] = Variable<double>(maxAmount.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('type: $type, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('maxAmount: $maxAmount, ')
          ..write('percentage: $percentage, ')
          ..write('createdAt: $createdAt, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomCategoriesTable extends CustomCategories
    with TableInfo<$CustomCategoriesTable, CustomCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_categories';
  @override
  VerificationContext validateIntegrity(Insertable<CustomCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  CustomCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomCategory(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $CustomCategoriesTable createAlias(String alias) {
    return $CustomCategoriesTable(attachedDatabase, alias);
  }
}

class CustomCategory extends DataClass implements Insertable<CustomCategory> {
  final String name;
  const CustomCategory({required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    return map;
  }

  CustomCategoriesCompanion toCompanion(bool nullToAbsent) {
    return CustomCategoriesCompanion(
      name: Value(name),
    );
  }

  factory CustomCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomCategory(
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
    };
  }

  CustomCategory copyWith({String? name}) => CustomCategory(
        name: name ?? this.name,
      );
  CustomCategory copyWithCompanion(CustomCategoriesCompanion data) {
    return CustomCategory(
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategory(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => name.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomCategory && other.name == this.name);
}

class CustomCategoriesCompanion extends UpdateCompanion<CustomCategory> {
  final Value<String> name;
  final Value<int> rowid;
  const CustomCategoriesCompanion({
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomCategoriesCompanion.insert({
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CustomCategory> custom({
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomCategoriesCompanion copyWith({Value<String>? name, Value<int>? rowid}) {
    return CustomCategoriesCompanion(
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomCategoriesCompanion(')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomIncomeSourcesTable extends CustomIncomeSources
    with TableInfo<$CustomIncomeSourcesTable, CustomIncomeSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomIncomeSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_income_sources';
  @override
  VerificationContext validateIntegrity(Insertable<CustomIncomeSource> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  CustomIncomeSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomIncomeSource(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $CustomIncomeSourcesTable createAlias(String alias) {
    return $CustomIncomeSourcesTable(attachedDatabase, alias);
  }
}

class CustomIncomeSource extends DataClass
    implements Insertable<CustomIncomeSource> {
  final String name;
  const CustomIncomeSource({required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    return map;
  }

  CustomIncomeSourcesCompanion toCompanion(bool nullToAbsent) {
    return CustomIncomeSourcesCompanion(
      name: Value(name),
    );
  }

  factory CustomIncomeSource.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomIncomeSource(
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
    };
  }

  CustomIncomeSource copyWith({String? name}) => CustomIncomeSource(
        name: name ?? this.name,
      );
  CustomIncomeSource copyWithCompanion(CustomIncomeSourcesCompanion data) {
    return CustomIncomeSource(
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomIncomeSource(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => name.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomIncomeSource && other.name == this.name);
}

class CustomIncomeSourcesCompanion extends UpdateCompanion<CustomIncomeSource> {
  final Value<String> name;
  final Value<int> rowid;
  const CustomIncomeSourcesCompanion({
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomIncomeSourcesCompanion.insert({
    required String name,
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CustomIncomeSource> custom({
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomIncomeSourcesCompanion copyWith(
      {Value<String>? name, Value<int>? rowid}) {
    return CustomIncomeSourcesCompanion(
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomIncomeSourcesCompanion(')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentAmountMeta =
      const VerificationMeta('currentAmount');
  @override
  late final GeneratedColumn<double> currentAmount = GeneratedColumn<double>(
      'current_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notificationDaysMeta =
      const VerificationMeta('notificationDays');
  @override
  late final GeneratedColumn<String> notificationDays = GeneratedColumn<String>(
      'notification_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        targetAmount,
        currentAmount,
        createdAt,
        targetDate,
        status,
        iconName,
        color,
        notificationDays
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(Insertable<SavingsGoal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('current_amount')) {
      context.handle(
          _currentAmountMeta,
          currentAmount.isAcceptableOrUnknown(
              data['current_amount']!, _currentAmountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('notification_days')) {
      context.handle(
          _notificationDaysMeta,
          notificationDays.isAcceptableOrUnknown(
              data['notification_days']!, _notificationDaysMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_amount'])!,
      currentAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_amount'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      notificationDays: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_days']),
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final String id;
  final String name;
  final String? description;
  final double targetAmount;
  final double currentAmount;
  final DateTime createdAt;
  final DateTime? targetDate;
  final String status;
  final String? iconName;
  final String? color;
  final String? notificationDays;
  const SavingsGoal(
      {required this.id,
      required this.name,
      this.description,
      required this.targetAmount,
      required this.currentAmount,
      required this.createdAt,
      this.targetDate,
      required this.status,
      this.iconName,
      this.color,
      this.notificationDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['target_amount'] = Variable<double>(targetAmount);
    map['current_amount'] = Variable<double>(currentAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || notificationDays != null) {
      map['notification_days'] = Variable<String>(notificationDays);
    }
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      createdAt: Value(createdAt),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      status: Value(status),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      notificationDays: notificationDays == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationDays),
    );
  }

  factory SavingsGoal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      currentAmount: serializer.fromJson<double>(json['currentAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      status: serializer.fromJson<String>(json['status']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      color: serializer.fromJson<String?>(json['color']),
      notificationDays: serializer.fromJson<String?>(json['notificationDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'currentAmount': serializer.toJson<double>(currentAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'status': serializer.toJson<String>(status),
      'iconName': serializer.toJson<String?>(iconName),
      'color': serializer.toJson<String?>(color),
      'notificationDays': serializer.toJson<String?>(notificationDays),
    };
  }

  SavingsGoal copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          double? targetAmount,
          double? currentAmount,
          DateTime? createdAt,
          Value<DateTime?> targetDate = const Value.absent(),
          String? status,
          Value<String?> iconName = const Value.absent(),
          Value<String?> color = const Value.absent(),
          Value<String?> notificationDays = const Value.absent()}) =>
      SavingsGoal(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        targetAmount: targetAmount ?? this.targetAmount,
        currentAmount: currentAmount ?? this.currentAmount,
        createdAt: createdAt ?? this.createdAt,
        targetDate: targetDate.present ? targetDate.value : this.targetDate,
        status: status ?? this.status,
        iconName: iconName.present ? iconName.value : this.iconName,
        color: color.present ? color.value : this.color,
        notificationDays: notificationDays.present
            ? notificationDays.value
            : this.notificationDays,
      );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      status: data.status.present ? data.status.value : this.status,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      color: data.color.present ? data.color.value : this.color,
      notificationDays: data.notificationDays.present
          ? data.notificationDays.value
          : this.notificationDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('notificationDays: $notificationDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      targetAmount,
      currentAmount,
      createdAt,
      targetDate,
      status,
      iconName,
      color,
      notificationDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.createdAt == this.createdAt &&
          other.targetDate == this.targetDate &&
          other.status == this.status &&
          other.iconName == this.iconName &&
          other.color == this.color &&
          other.notificationDays == this.notificationDays);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> targetAmount;
  final Value<double> currentAmount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> targetDate;
  final Value<String> status;
  final Value<String?> iconName;
  final Value<String?> color;
  final Value<String?> notificationDays;
  final Value<int> rowid;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
    this.notificationDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required double targetAmount,
    this.currentAmount = const Value.absent(),
    required DateTime createdAt,
    this.targetDate = const Value.absent(),
    this.status = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
    this.notificationDays = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        targetAmount = Value(targetAmount),
        createdAt = Value(createdAt);
  static Insertable<SavingsGoal> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? targetAmount,
    Expression<double>? currentAmount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? targetDate,
    Expression<String>? status,
    Expression<String>? iconName,
    Expression<String>? color,
    Expression<String>? notificationDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (targetDate != null) 'target_date': targetDate,
      if (status != null) 'status': status,
      if (iconName != null) 'icon_name': iconName,
      if (color != null) 'color': color,
      if (notificationDays != null) 'notification_days': notificationDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsGoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<double>? targetAmount,
      Value<double>? currentAmount,
      Value<DateTime>? createdAt,
      Value<DateTime?>? targetDate,
      Value<String>? status,
      Value<String?>? iconName,
      Value<String?>? color,
      Value<String?>? notificationDays,
      Value<int>? rowid}) {
    return SavingsGoalsCompanion(
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
      notificationDays: notificationDays ?? this.notificationDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<double>(currentAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (notificationDays.present) {
      map['notification_days'] = Variable<String>(notificationDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('targetDate: $targetDate, ')
          ..write('status: $status, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('notificationDays: $notificationDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsContributionsTable extends SavingsContributions
    with TableInfo<$SavingsContributionsTable, SavingsContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _savingsGoalIdMeta =
      const VerificationMeta('savingsGoalId');
  @override
  late final GeneratedColumn<String> savingsGoalId = GeneratedColumn<String>(
      'savings_goal_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES savings_goals (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, savingsGoalId, amount, date, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_contributions';
  @override
  VerificationContext validateIntegrity(
      Insertable<SavingsContribution> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('savings_goal_id')) {
      context.handle(
          _savingsGoalIdMeta,
          savingsGoalId.isAcceptableOrUnknown(
              data['savings_goal_id']!, _savingsGoalIdMeta));
    } else if (isInserting) {
      context.missing(_savingsGoalIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsContribution(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      savingsGoalId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}savings_goal_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $SavingsContributionsTable createAlias(String alias) {
    return $SavingsContributionsTable(attachedDatabase, alias);
  }
}

class SavingsContribution extends DataClass
    implements Insertable<SavingsContribution> {
  final String id;
  final String savingsGoalId;
  final double amount;
  final DateTime date;
  final String? note;
  const SavingsContribution(
      {required this.id,
      required this.savingsGoalId,
      required this.amount,
      required this.date,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['savings_goal_id'] = Variable<String>(savingsGoalId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SavingsContributionsCompanion toCompanion(bool nullToAbsent) {
    return SavingsContributionsCompanion(
      id: Value(id),
      savingsGoalId: Value(savingsGoalId),
      amount: Value(amount),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SavingsContribution.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsContribution(
      id: serializer.fromJson<String>(json['id']),
      savingsGoalId: serializer.fromJson<String>(json['savingsGoalId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'savingsGoalId': serializer.toJson<String>(savingsGoalId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
    };
  }

  SavingsContribution copyWith(
          {String? id,
          String? savingsGoalId,
          double? amount,
          DateTime? date,
          Value<String?> note = const Value.absent()}) =>
      SavingsContribution(
        id: id ?? this.id,
        savingsGoalId: savingsGoalId ?? this.savingsGoalId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        note: note.present ? note.value : this.note,
      );
  SavingsContribution copyWithCompanion(SavingsContributionsCompanion data) {
    return SavingsContribution(
      id: data.id.present ? data.id.value : this.id,
      savingsGoalId: data.savingsGoalId.present
          ? data.savingsGoalId.value
          : this.savingsGoalId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsContribution(')
          ..write('id: $id, ')
          ..write('savingsGoalId: $savingsGoalId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, savingsGoalId, amount, date, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsContribution &&
          other.id == this.id &&
          other.savingsGoalId == this.savingsGoalId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.note == this.note);
}

class SavingsContributionsCompanion
    extends UpdateCompanion<SavingsContribution> {
  final Value<String> id;
  final Value<String> savingsGoalId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<int> rowid;
  const SavingsContributionsCompanion({
    this.id = const Value.absent(),
    this.savingsGoalId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsContributionsCompanion.insert({
    required String id,
    required String savingsGoalId,
    required double amount,
    required DateTime date,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        savingsGoalId = Value(savingsGoalId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<SavingsContribution> custom({
    Expression<String>? id,
    Expression<String>? savingsGoalId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (savingsGoalId != null) 'savings_goal_id': savingsGoalId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsContributionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? savingsGoalId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String?>? note,
      Value<int>? rowid}) {
    return SavingsContributionsCompanion(
      id: id ?? this.id,
      savingsGoalId: savingsGoalId ?? this.savingsGoalId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (savingsGoalId.present) {
      map['savings_goal_id'] = Variable<String>(savingsGoalId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsContributionsCompanion(')
          ..write('id: $id, ')
          ..write('savingsGoalId: $savingsGoalId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestmentsTable extends Investments
    with TableInfo<$InvestmentsTable, Investment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _initialAmountMeta =
      const VerificationMeta('initialAmount');
  @override
  late final GeneratedColumn<double> initialAmount = GeneratedColumn<double>(
      'initial_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currentValueMeta =
      const VerificationMeta('currentValue');
  @override
  late final GeneratedColumn<double> currentValue = GeneratedColumn<double>(
      'current_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _expectedReturnRateMeta =
      const VerificationMeta('expectedReturnRate');
  @override
  late final GeneratedColumn<double> expectedReturnRate =
      GeneratedColumn<double>('expected_return_rate', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _purchaseDateMeta =
      const VerificationMeta('purchaseDate');
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
      'purchase_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _soldDateMeta =
      const VerificationMeta('soldDate');
  @override
  late final GeneratedColumn<DateTime> soldDate = GeneratedColumn<DateTime>(
      'sold_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _soldAmountMeta =
      const VerificationMeta('soldAmount');
  @override
  late final GeneratedColumn<double> soldAmount = GeneratedColumn<double>(
      'sold_amount', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _platformOrBrokerMeta =
      const VerificationMeta('platformOrBroker');
  @override
  late final GeneratedColumn<String> platformOrBroker = GeneratedColumn<String>(
      'platform_or_broker', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _compoundingFrequencyMeta =
      const VerificationMeta('compoundingFrequency');
  @override
  late final GeneratedColumn<int> compoundingFrequency = GeneratedColumn<int>(
      'compounding_frequency', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(12));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notificationDaysMeta =
      const VerificationMeta('notificationDays');
  @override
  late final GeneratedColumn<String> notificationDays = GeneratedColumn<String>(
      'notification_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        type,
        initialAmount,
        currentValue,
        expectedReturnRate,
        purchaseDate,
        soldDate,
        soldAmount,
        status,
        platformOrBroker,
        notes,
        compoundingFrequency,
        iconName,
        color,
        notificationDays
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investments';
  @override
  VerificationContext validateIntegrity(Insertable<Investment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('initial_amount')) {
      context.handle(
          _initialAmountMeta,
          initialAmount.isAcceptableOrUnknown(
              data['initial_amount']!, _initialAmountMeta));
    } else if (isInserting) {
      context.missing(_initialAmountMeta);
    }
    if (data.containsKey('current_value')) {
      context.handle(
          _currentValueMeta,
          currentValue.isAcceptableOrUnknown(
              data['current_value']!, _currentValueMeta));
    } else if (isInserting) {
      context.missing(_currentValueMeta);
    }
    if (data.containsKey('expected_return_rate')) {
      context.handle(
          _expectedReturnRateMeta,
          expectedReturnRate.isAcceptableOrUnknown(
              data['expected_return_rate']!, _expectedReturnRateMeta));
    } else if (isInserting) {
      context.missing(_expectedReturnRateMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
          _purchaseDateMeta,
          purchaseDate.isAcceptableOrUnknown(
              data['purchase_date']!, _purchaseDateMeta));
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('sold_date')) {
      context.handle(_soldDateMeta,
          soldDate.isAcceptableOrUnknown(data['sold_date']!, _soldDateMeta));
    }
    if (data.containsKey('sold_amount')) {
      context.handle(
          _soldAmountMeta,
          soldAmount.isAcceptableOrUnknown(
              data['sold_amount']!, _soldAmountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('platform_or_broker')) {
      context.handle(
          _platformOrBrokerMeta,
          platformOrBroker.isAcceptableOrUnknown(
              data['platform_or_broker']!, _platformOrBrokerMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('compounding_frequency')) {
      context.handle(
          _compoundingFrequencyMeta,
          compoundingFrequency.isAcceptableOrUnknown(
              data['compounding_frequency']!, _compoundingFrequencyMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('notification_days')) {
      context.handle(
          _notificationDaysMeta,
          notificationDays.isAcceptableOrUnknown(
              data['notification_days']!, _notificationDaysMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Investment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Investment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      initialAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}initial_amount'])!,
      currentValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_value'])!,
      expectedReturnRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}expected_return_rate'])!,
      purchaseDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}purchase_date'])!,
      soldDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sold_date']),
      soldAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}sold_amount']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      platformOrBroker: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}platform_or_broker']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      compoundingFrequency: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}compounding_frequency'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      notificationDays: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_days']),
    );
  }

  @override
  $InvestmentsTable createAlias(String alias) {
    return $InvestmentsTable(attachedDatabase, alias);
  }
}

class Investment extends DataClass implements Insertable<Investment> {
  final String id;
  final String name;
  final String? description;
  final String type;
  final double initialAmount;
  final double currentValue;
  final double expectedReturnRate;
  final DateTime purchaseDate;
  final DateTime? soldDate;
  final double? soldAmount;
  final String status;
  final String? platformOrBroker;
  final String? notes;
  final int compoundingFrequency;
  final String? iconName;
  final String? color;
  final String? notificationDays;
  const Investment(
      {required this.id,
      required this.name,
      this.description,
      required this.type,
      required this.initialAmount,
      required this.currentValue,
      required this.expectedReturnRate,
      required this.purchaseDate,
      this.soldDate,
      this.soldAmount,
      required this.status,
      this.platformOrBroker,
      this.notes,
      required this.compoundingFrequency,
      this.iconName,
      this.color,
      this.notificationDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    map['initial_amount'] = Variable<double>(initialAmount);
    map['current_value'] = Variable<double>(currentValue);
    map['expected_return_rate'] = Variable<double>(expectedReturnRate);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    if (!nullToAbsent || soldDate != null) {
      map['sold_date'] = Variable<DateTime>(soldDate);
    }
    if (!nullToAbsent || soldAmount != null) {
      map['sold_amount'] = Variable<double>(soldAmount);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || platformOrBroker != null) {
      map['platform_or_broker'] = Variable<String>(platformOrBroker);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['compounding_frequency'] = Variable<int>(compoundingFrequency);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || notificationDays != null) {
      map['notification_days'] = Variable<String>(notificationDays);
    }
    return map;
  }

  InvestmentsCompanion toCompanion(bool nullToAbsent) {
    return InvestmentsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      initialAmount: Value(initialAmount),
      currentValue: Value(currentValue),
      expectedReturnRate: Value(expectedReturnRate),
      purchaseDate: Value(purchaseDate),
      soldDate: soldDate == null && nullToAbsent
          ? const Value.absent()
          : Value(soldDate),
      soldAmount: soldAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(soldAmount),
      status: Value(status),
      platformOrBroker: platformOrBroker == null && nullToAbsent
          ? const Value.absent()
          : Value(platformOrBroker),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      compoundingFrequency: Value(compoundingFrequency),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      notificationDays: notificationDays == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationDays),
    );
  }

  factory Investment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Investment(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      initialAmount: serializer.fromJson<double>(json['initialAmount']),
      currentValue: serializer.fromJson<double>(json['currentValue']),
      expectedReturnRate:
          serializer.fromJson<double>(json['expectedReturnRate']),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      soldDate: serializer.fromJson<DateTime?>(json['soldDate']),
      soldAmount: serializer.fromJson<double?>(json['soldAmount']),
      status: serializer.fromJson<String>(json['status']),
      platformOrBroker: serializer.fromJson<String?>(json['platformOrBroker']),
      notes: serializer.fromJson<String?>(json['notes']),
      compoundingFrequency:
          serializer.fromJson<int>(json['compoundingFrequency']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      color: serializer.fromJson<String?>(json['color']),
      notificationDays: serializer.fromJson<String?>(json['notificationDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'initialAmount': serializer.toJson<double>(initialAmount),
      'currentValue': serializer.toJson<double>(currentValue),
      'expectedReturnRate': serializer.toJson<double>(expectedReturnRate),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'soldDate': serializer.toJson<DateTime?>(soldDate),
      'soldAmount': serializer.toJson<double?>(soldAmount),
      'status': serializer.toJson<String>(status),
      'platformOrBroker': serializer.toJson<String?>(platformOrBroker),
      'notes': serializer.toJson<String?>(notes),
      'compoundingFrequency': serializer.toJson<int>(compoundingFrequency),
      'iconName': serializer.toJson<String?>(iconName),
      'color': serializer.toJson<String?>(color),
      'notificationDays': serializer.toJson<String?>(notificationDays),
    };
  }

  Investment copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          String? type,
          double? initialAmount,
          double? currentValue,
          double? expectedReturnRate,
          DateTime? purchaseDate,
          Value<DateTime?> soldDate = const Value.absent(),
          Value<double?> soldAmount = const Value.absent(),
          String? status,
          Value<String?> platformOrBroker = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? compoundingFrequency,
          Value<String?> iconName = const Value.absent(),
          Value<String?> color = const Value.absent(),
          Value<String?> notificationDays = const Value.absent()}) =>
      Investment(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        initialAmount: initialAmount ?? this.initialAmount,
        currentValue: currentValue ?? this.currentValue,
        expectedReturnRate: expectedReturnRate ?? this.expectedReturnRate,
        purchaseDate: purchaseDate ?? this.purchaseDate,
        soldDate: soldDate.present ? soldDate.value : this.soldDate,
        soldAmount: soldAmount.present ? soldAmount.value : this.soldAmount,
        status: status ?? this.status,
        platformOrBroker: platformOrBroker.present
            ? platformOrBroker.value
            : this.platformOrBroker,
        notes: notes.present ? notes.value : this.notes,
        compoundingFrequency: compoundingFrequency ?? this.compoundingFrequency,
        iconName: iconName.present ? iconName.value : this.iconName,
        color: color.present ? color.value : this.color,
        notificationDays: notificationDays.present
            ? notificationDays.value
            : this.notificationDays,
      );
  Investment copyWithCompanion(InvestmentsCompanion data) {
    return Investment(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      initialAmount: data.initialAmount.present
          ? data.initialAmount.value
          : this.initialAmount,
      currentValue: data.currentValue.present
          ? data.currentValue.value
          : this.currentValue,
      expectedReturnRate: data.expectedReturnRate.present
          ? data.expectedReturnRate.value
          : this.expectedReturnRate,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      soldDate: data.soldDate.present ? data.soldDate.value : this.soldDate,
      soldAmount:
          data.soldAmount.present ? data.soldAmount.value : this.soldAmount,
      status: data.status.present ? data.status.value : this.status,
      platformOrBroker: data.platformOrBroker.present
          ? data.platformOrBroker.value
          : this.platformOrBroker,
      notes: data.notes.present ? data.notes.value : this.notes,
      compoundingFrequency: data.compoundingFrequency.present
          ? data.compoundingFrequency.value
          : this.compoundingFrequency,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      color: data.color.present ? data.color.value : this.color,
      notificationDays: data.notificationDays.present
          ? data.notificationDays.value
          : this.notificationDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Investment(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('currentValue: $currentValue, ')
          ..write('expectedReturnRate: $expectedReturnRate, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('soldDate: $soldDate, ')
          ..write('soldAmount: $soldAmount, ')
          ..write('status: $status, ')
          ..write('platformOrBroker: $platformOrBroker, ')
          ..write('notes: $notes, ')
          ..write('compoundingFrequency: $compoundingFrequency, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('notificationDays: $notificationDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      type,
      initialAmount,
      currentValue,
      expectedReturnRate,
      purchaseDate,
      soldDate,
      soldAmount,
      status,
      platformOrBroker,
      notes,
      compoundingFrequency,
      iconName,
      color,
      notificationDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Investment &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.type == this.type &&
          other.initialAmount == this.initialAmount &&
          other.currentValue == this.currentValue &&
          other.expectedReturnRate == this.expectedReturnRate &&
          other.purchaseDate == this.purchaseDate &&
          other.soldDate == this.soldDate &&
          other.soldAmount == this.soldAmount &&
          other.status == this.status &&
          other.platformOrBroker == this.platformOrBroker &&
          other.notes == this.notes &&
          other.compoundingFrequency == this.compoundingFrequency &&
          other.iconName == this.iconName &&
          other.color == this.color &&
          other.notificationDays == this.notificationDays);
}

class InvestmentsCompanion extends UpdateCompanion<Investment> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> type;
  final Value<double> initialAmount;
  final Value<double> currentValue;
  final Value<double> expectedReturnRate;
  final Value<DateTime> purchaseDate;
  final Value<DateTime?> soldDate;
  final Value<double?> soldAmount;
  final Value<String> status;
  final Value<String?> platformOrBroker;
  final Value<String?> notes;
  final Value<int> compoundingFrequency;
  final Value<String?> iconName;
  final Value<String?> color;
  final Value<String?> notificationDays;
  final Value<int> rowid;
  const InvestmentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.initialAmount = const Value.absent(),
    this.currentValue = const Value.absent(),
    this.expectedReturnRate = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.soldDate = const Value.absent(),
    this.soldAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.platformOrBroker = const Value.absent(),
    this.notes = const Value.absent(),
    this.compoundingFrequency = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
    this.notificationDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String type,
    required double initialAmount,
    required double currentValue,
    required double expectedReturnRate,
    required DateTime purchaseDate,
    this.soldDate = const Value.absent(),
    this.soldAmount = const Value.absent(),
    this.status = const Value.absent(),
    this.platformOrBroker = const Value.absent(),
    this.notes = const Value.absent(),
    this.compoundingFrequency = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
    this.notificationDays = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        initialAmount = Value(initialAmount),
        currentValue = Value(currentValue),
        expectedReturnRate = Value(expectedReturnRate),
        purchaseDate = Value(purchaseDate);
  static Insertable<Investment> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? type,
    Expression<double>? initialAmount,
    Expression<double>? currentValue,
    Expression<double>? expectedReturnRate,
    Expression<DateTime>? purchaseDate,
    Expression<DateTime>? soldDate,
    Expression<double>? soldAmount,
    Expression<String>? status,
    Expression<String>? platformOrBroker,
    Expression<String>? notes,
    Expression<int>? compoundingFrequency,
    Expression<String>? iconName,
    Expression<String>? color,
    Expression<String>? notificationDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (initialAmount != null) 'initial_amount': initialAmount,
      if (currentValue != null) 'current_value': currentValue,
      if (expectedReturnRate != null)
        'expected_return_rate': expectedReturnRate,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (soldDate != null) 'sold_date': soldDate,
      if (soldAmount != null) 'sold_amount': soldAmount,
      if (status != null) 'status': status,
      if (platformOrBroker != null) 'platform_or_broker': platformOrBroker,
      if (notes != null) 'notes': notes,
      if (compoundingFrequency != null)
        'compounding_frequency': compoundingFrequency,
      if (iconName != null) 'icon_name': iconName,
      if (color != null) 'color': color,
      if (notificationDays != null) 'notification_days': notificationDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String>? type,
      Value<double>? initialAmount,
      Value<double>? currentValue,
      Value<double>? expectedReturnRate,
      Value<DateTime>? purchaseDate,
      Value<DateTime?>? soldDate,
      Value<double?>? soldAmount,
      Value<String>? status,
      Value<String?>? platformOrBroker,
      Value<String?>? notes,
      Value<int>? compoundingFrequency,
      Value<String?>? iconName,
      Value<String?>? color,
      Value<String?>? notificationDays,
      Value<int>? rowid}) {
    return InvestmentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      initialAmount: initialAmount ?? this.initialAmount,
      currentValue: currentValue ?? this.currentValue,
      expectedReturnRate: expectedReturnRate ?? this.expectedReturnRate,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      soldDate: soldDate ?? this.soldDate,
      soldAmount: soldAmount ?? this.soldAmount,
      status: status ?? this.status,
      platformOrBroker: platformOrBroker ?? this.platformOrBroker,
      notes: notes ?? this.notes,
      compoundingFrequency: compoundingFrequency ?? this.compoundingFrequency,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      notificationDays: notificationDays ?? this.notificationDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (initialAmount.present) {
      map['initial_amount'] = Variable<double>(initialAmount.value);
    }
    if (currentValue.present) {
      map['current_value'] = Variable<double>(currentValue.value);
    }
    if (expectedReturnRate.present) {
      map['expected_return_rate'] = Variable<double>(expectedReturnRate.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (soldDate.present) {
      map['sold_date'] = Variable<DateTime>(soldDate.value);
    }
    if (soldAmount.present) {
      map['sold_amount'] = Variable<double>(soldAmount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (platformOrBroker.present) {
      map['platform_or_broker'] = Variable<String>(platformOrBroker.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (compoundingFrequency.present) {
      map['compounding_frequency'] = Variable<int>(compoundingFrequency.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (notificationDays.present) {
      map['notification_days'] = Variable<String>(notificationDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('initialAmount: $initialAmount, ')
          ..write('currentValue: $currentValue, ')
          ..write('expectedReturnRate: $expectedReturnRate, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('soldDate: $soldDate, ')
          ..write('soldAmount: $soldAmount, ')
          ..write('status: $status, ')
          ..write('platformOrBroker: $platformOrBroker, ')
          ..write('notes: $notes, ')
          ..write('compoundingFrequency: $compoundingFrequency, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('notificationDays: $notificationDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvestmentValueHistoryTable extends InvestmentValueHistory
    with TableInfo<$InvestmentValueHistoryTable, InvestmentValueHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvestmentValueHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _investmentIdMeta =
      const VerificationMeta('investmentId');
  @override
  late final GeneratedColumn<String> investmentId = GeneratedColumn<String>(
      'investment_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES investments (id)'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, investmentId, value, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'investment_value_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<InvestmentValueHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('investment_id')) {
      context.handle(
          _investmentIdMeta,
          investmentId.isAcceptableOrUnknown(
              data['investment_id']!, _investmentIdMeta));
    } else if (isInserting) {
      context.missing(_investmentIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvestmentValueHistoryData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvestmentValueHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      investmentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}investment_id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $InvestmentValueHistoryTable createAlias(String alias) {
    return $InvestmentValueHistoryTable(attachedDatabase, alias);
  }
}

class InvestmentValueHistoryData extends DataClass
    implements Insertable<InvestmentValueHistoryData> {
  final String id;
  final String investmentId;
  final double value;
  final DateTime date;
  const InvestmentValueHistoryData(
      {required this.id,
      required this.investmentId,
      required this.value,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['investment_id'] = Variable<String>(investmentId);
    map['value'] = Variable<double>(value);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  InvestmentValueHistoryCompanion toCompanion(bool nullToAbsent) {
    return InvestmentValueHistoryCompanion(
      id: Value(id),
      investmentId: Value(investmentId),
      value: Value(value),
      date: Value(date),
    );
  }

  factory InvestmentValueHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvestmentValueHistoryData(
      id: serializer.fromJson<String>(json['id']),
      investmentId: serializer.fromJson<String>(json['investmentId']),
      value: serializer.fromJson<double>(json['value']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'investmentId': serializer.toJson<String>(investmentId),
      'value': serializer.toJson<double>(value),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  InvestmentValueHistoryData copyWith(
          {String? id, String? investmentId, double? value, DateTime? date}) =>
      InvestmentValueHistoryData(
        id: id ?? this.id,
        investmentId: investmentId ?? this.investmentId,
        value: value ?? this.value,
        date: date ?? this.date,
      );
  InvestmentValueHistoryData copyWithCompanion(
      InvestmentValueHistoryCompanion data) {
    return InvestmentValueHistoryData(
      id: data.id.present ? data.id.value : this.id,
      investmentId: data.investmentId.present
          ? data.investmentId.value
          : this.investmentId,
      value: data.value.present ? data.value.value : this.value,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentValueHistoryData(')
          ..write('id: $id, ')
          ..write('investmentId: $investmentId, ')
          ..write('value: $value, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, investmentId, value, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvestmentValueHistoryData &&
          other.id == this.id &&
          other.investmentId == this.investmentId &&
          other.value == this.value &&
          other.date == this.date);
}

class InvestmentValueHistoryCompanion
    extends UpdateCompanion<InvestmentValueHistoryData> {
  final Value<String> id;
  final Value<String> investmentId;
  final Value<double> value;
  final Value<DateTime> date;
  final Value<int> rowid;
  const InvestmentValueHistoryCompanion({
    this.id = const Value.absent(),
    this.investmentId = const Value.absent(),
    this.value = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvestmentValueHistoryCompanion.insert({
    required String id,
    required String investmentId,
    required double value,
    required DateTime date,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        investmentId = Value(investmentId),
        value = Value(value),
        date = Value(date);
  static Insertable<InvestmentValueHistoryData> custom({
    Expression<String>? id,
    Expression<String>? investmentId,
    Expression<double>? value,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (investmentId != null) 'investment_id': investmentId,
      if (value != null) 'value': value,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvestmentValueHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? investmentId,
      Value<double>? value,
      Value<DateTime>? date,
      Value<int>? rowid}) {
    return InvestmentValueHistoryCompanion(
      id: id ?? this.id,
      investmentId: investmentId ?? this.investmentId,
      value: value ?? this.value,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (investmentId.present) {
      map['investment_id'] = Variable<String>(investmentId.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvestmentValueHistoryCompanion(')
          ..write('id: $id, ')
          ..write('investmentId: $investmentId, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoansTable extends Loans with TableInfo<$LoansTable, Loan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _borrowerOrLenderMeta =
      const VerificationMeta('borrowerOrLender');
  @override
  late final GeneratedColumn<String> borrowerOrLender = GeneratedColumn<String>(
      'borrower_or_lender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _principalAmountMeta =
      const VerificationMeta('principalAmount');
  @override
  late final GeneratedColumn<double> principalAmount = GeneratedColumn<double>(
      'principal_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _interestRateMeta =
      const VerificationMeta('interestRate');
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
      'interest_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalInstallmentsMeta =
      const VerificationMeta('totalInstallments');
  @override
  late final GeneratedColumn<int> totalInstallments = GeneratedColumn<int>(
      'total_installments', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _installmentAmountMeta =
      const VerificationMeta('installmentAmount');
  @override
  late final GeneratedColumn<double> installmentAmount =
      GeneratedColumn<double>('installment_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _paymentFrequencyMeta =
      const VerificationMeta('paymentFrequency');
  @override
  late final GeneratedColumn<String> paymentFrequency = GeneratedColumn<String>(
      'payment_frequency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('monthly'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paidAmountMeta =
      const VerificationMeta('paidAmount');
  @override
  late final GeneratedColumn<double> paidAmount = GeneratedColumn<double>(
      'paid_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paidInstallmentsMeta =
      const VerificationMeta('paidInstallments');
  @override
  late final GeneratedColumn<int> paidInstallments = GeneratedColumn<int>(
      'paid_installments', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notificationDaysMeta =
      const VerificationMeta('notificationDays');
  @override
  late final GeneratedColumn<String> notificationDays = GeneratedColumn<String>(
      'notification_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        borrowerOrLender,
        type,
        principalAmount,
        interestRate,
        totalInstallments,
        installmentAmount,
        startDate,
        endDate,
        paymentFrequency,
        status,
        notes,
        paidAmount,
        paidInstallments,
        iconName,
        color,
        notificationDays
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loans';
  @override
  VerificationContext validateIntegrity(Insertable<Loan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('borrower_or_lender')) {
      context.handle(
          _borrowerOrLenderMeta,
          borrowerOrLender.isAcceptableOrUnknown(
              data['borrower_or_lender']!, _borrowerOrLenderMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('principal_amount')) {
      context.handle(
          _principalAmountMeta,
          principalAmount.isAcceptableOrUnknown(
              data['principal_amount']!, _principalAmountMeta));
    } else if (isInserting) {
      context.missing(_principalAmountMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
          _interestRateMeta,
          interestRate.isAcceptableOrUnknown(
              data['interest_rate']!, _interestRateMeta));
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('total_installments')) {
      context.handle(
          _totalInstallmentsMeta,
          totalInstallments.isAcceptableOrUnknown(
              data['total_installments']!, _totalInstallmentsMeta));
    } else if (isInserting) {
      context.missing(_totalInstallmentsMeta);
    }
    if (data.containsKey('installment_amount')) {
      context.handle(
          _installmentAmountMeta,
          installmentAmount.isAcceptableOrUnknown(
              data['installment_amount']!, _installmentAmountMeta));
    } else if (isInserting) {
      context.missing(_installmentAmountMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('payment_frequency')) {
      context.handle(
          _paymentFrequencyMeta,
          paymentFrequency.isAcceptableOrUnknown(
              data['payment_frequency']!, _paymentFrequencyMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('paid_amount')) {
      context.handle(
          _paidAmountMeta,
          paidAmount.isAcceptableOrUnknown(
              data['paid_amount']!, _paidAmountMeta));
    }
    if (data.containsKey('paid_installments')) {
      context.handle(
          _paidInstallmentsMeta,
          paidInstallments.isAcceptableOrUnknown(
              data['paid_installments']!, _paidInstallmentsMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('notification_days')) {
      context.handle(
          _notificationDaysMeta,
          notificationDays.isAcceptableOrUnknown(
              data['notification_days']!, _notificationDaysMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Loan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Loan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      borrowerOrLender: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}borrower_or_lender']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      principalAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}principal_amount'])!,
      interestRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}interest_rate'])!,
      totalInstallments: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_installments'])!,
      installmentAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}installment_amount'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      paymentFrequency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_frequency'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      paidAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}paid_amount'])!,
      paidInstallments: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_installments'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      notificationDays: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_days']),
    );
  }

  @override
  $LoansTable createAlias(String alias) {
    return $LoansTable(attachedDatabase, alias);
  }
}

class Loan extends DataClass implements Insertable<Loan> {
  final String id;
  final String name;
  final String? borrowerOrLender;
  final String type;
  final double principalAmount;
  final double interestRate;
  final int totalInstallments;
  final double installmentAmount;
  final DateTime startDate;
  final DateTime? endDate;
  final String paymentFrequency;
  final String status;
  final String? notes;
  final double paidAmount;
  final int paidInstallments;
  final String? iconName;
  final String? color;
  final String? notificationDays;
  const Loan(
      {required this.id,
      required this.name,
      this.borrowerOrLender,
      required this.type,
      required this.principalAmount,
      required this.interestRate,
      required this.totalInstallments,
      required this.installmentAmount,
      required this.startDate,
      this.endDate,
      required this.paymentFrequency,
      required this.status,
      this.notes,
      required this.paidAmount,
      required this.paidInstallments,
      this.iconName,
      this.color,
      this.notificationDays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || borrowerOrLender != null) {
      map['borrower_or_lender'] = Variable<String>(borrowerOrLender);
    }
    map['type'] = Variable<String>(type);
    map['principal_amount'] = Variable<double>(principalAmount);
    map['interest_rate'] = Variable<double>(interestRate);
    map['total_installments'] = Variable<int>(totalInstallments);
    map['installment_amount'] = Variable<double>(installmentAmount);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['payment_frequency'] = Variable<String>(paymentFrequency);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['paid_amount'] = Variable<double>(paidAmount);
    map['paid_installments'] = Variable<int>(paidInstallments);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || notificationDays != null) {
      map['notification_days'] = Variable<String>(notificationDays);
    }
    return map;
  }

  LoansCompanion toCompanion(bool nullToAbsent) {
    return LoansCompanion(
      id: Value(id),
      name: Value(name),
      borrowerOrLender: borrowerOrLender == null && nullToAbsent
          ? const Value.absent()
          : Value(borrowerOrLender),
      type: Value(type),
      principalAmount: Value(principalAmount),
      interestRate: Value(interestRate),
      totalInstallments: Value(totalInstallments),
      installmentAmount: Value(installmentAmount),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      paymentFrequency: Value(paymentFrequency),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      paidAmount: Value(paidAmount),
      paidInstallments: Value(paidInstallments),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      notificationDays: notificationDays == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationDays),
    );
  }

  factory Loan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Loan(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      borrowerOrLender: serializer.fromJson<String?>(json['borrowerOrLender']),
      type: serializer.fromJson<String>(json['type']),
      principalAmount: serializer.fromJson<double>(json['principalAmount']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      totalInstallments: serializer.fromJson<int>(json['totalInstallments']),
      installmentAmount: serializer.fromJson<double>(json['installmentAmount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      paymentFrequency: serializer.fromJson<String>(json['paymentFrequency']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      paidAmount: serializer.fromJson<double>(json['paidAmount']),
      paidInstallments: serializer.fromJson<int>(json['paidInstallments']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      color: serializer.fromJson<String?>(json['color']),
      notificationDays: serializer.fromJson<String?>(json['notificationDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'borrowerOrLender': serializer.toJson<String?>(borrowerOrLender),
      'type': serializer.toJson<String>(type),
      'principalAmount': serializer.toJson<double>(principalAmount),
      'interestRate': serializer.toJson<double>(interestRate),
      'totalInstallments': serializer.toJson<int>(totalInstallments),
      'installmentAmount': serializer.toJson<double>(installmentAmount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'paymentFrequency': serializer.toJson<String>(paymentFrequency),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'paidAmount': serializer.toJson<double>(paidAmount),
      'paidInstallments': serializer.toJson<int>(paidInstallments),
      'iconName': serializer.toJson<String?>(iconName),
      'color': serializer.toJson<String?>(color),
      'notificationDays': serializer.toJson<String?>(notificationDays),
    };
  }

  Loan copyWith(
          {String? id,
          String? name,
          Value<String?> borrowerOrLender = const Value.absent(),
          String? type,
          double? principalAmount,
          double? interestRate,
          int? totalInstallments,
          double? installmentAmount,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          String? paymentFrequency,
          String? status,
          Value<String?> notes = const Value.absent(),
          double? paidAmount,
          int? paidInstallments,
          Value<String?> iconName = const Value.absent(),
          Value<String?> color = const Value.absent(),
          Value<String?> notificationDays = const Value.absent()}) =>
      Loan(
        id: id ?? this.id,
        name: name ?? this.name,
        borrowerOrLender: borrowerOrLender.present
            ? borrowerOrLender.value
            : this.borrowerOrLender,
        type: type ?? this.type,
        principalAmount: principalAmount ?? this.principalAmount,
        interestRate: interestRate ?? this.interestRate,
        totalInstallments: totalInstallments ?? this.totalInstallments,
        installmentAmount: installmentAmount ?? this.installmentAmount,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        paymentFrequency: paymentFrequency ?? this.paymentFrequency,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        paidAmount: paidAmount ?? this.paidAmount,
        paidInstallments: paidInstallments ?? this.paidInstallments,
        iconName: iconName.present ? iconName.value : this.iconName,
        color: color.present ? color.value : this.color,
        notificationDays: notificationDays.present
            ? notificationDays.value
            : this.notificationDays,
      );
  Loan copyWithCompanion(LoansCompanion data) {
    return Loan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      borrowerOrLender: data.borrowerOrLender.present
          ? data.borrowerOrLender.value
          : this.borrowerOrLender,
      type: data.type.present ? data.type.value : this.type,
      principalAmount: data.principalAmount.present
          ? data.principalAmount.value
          : this.principalAmount,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      totalInstallments: data.totalInstallments.present
          ? data.totalInstallments.value
          : this.totalInstallments,
      installmentAmount: data.installmentAmount.present
          ? data.installmentAmount.value
          : this.installmentAmount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      paymentFrequency: data.paymentFrequency.present
          ? data.paymentFrequency.value
          : this.paymentFrequency,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      paidAmount:
          data.paidAmount.present ? data.paidAmount.value : this.paidAmount,
      paidInstallments: data.paidInstallments.present
          ? data.paidInstallments.value
          : this.paidInstallments,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      color: data.color.present ? data.color.value : this.color,
      notificationDays: data.notificationDays.present
          ? data.notificationDays.value
          : this.notificationDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Loan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('borrowerOrLender: $borrowerOrLender, ')
          ..write('type: $type, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('paymentFrequency: $paymentFrequency, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('notificationDays: $notificationDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      borrowerOrLender,
      type,
      principalAmount,
      interestRate,
      totalInstallments,
      installmentAmount,
      startDate,
      endDate,
      paymentFrequency,
      status,
      notes,
      paidAmount,
      paidInstallments,
      iconName,
      color,
      notificationDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Loan &&
          other.id == this.id &&
          other.name == this.name &&
          other.borrowerOrLender == this.borrowerOrLender &&
          other.type == this.type &&
          other.principalAmount == this.principalAmount &&
          other.interestRate == this.interestRate &&
          other.totalInstallments == this.totalInstallments &&
          other.installmentAmount == this.installmentAmount &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.paymentFrequency == this.paymentFrequency &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.paidAmount == this.paidAmount &&
          other.paidInstallments == this.paidInstallments &&
          other.iconName == this.iconName &&
          other.color == this.color &&
          other.notificationDays == this.notificationDays);
}

class LoansCompanion extends UpdateCompanion<Loan> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> borrowerOrLender;
  final Value<String> type;
  final Value<double> principalAmount;
  final Value<double> interestRate;
  final Value<int> totalInstallments;
  final Value<double> installmentAmount;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> paymentFrequency;
  final Value<String> status;
  final Value<String?> notes;
  final Value<double> paidAmount;
  final Value<int> paidInstallments;
  final Value<String?> iconName;
  final Value<String?> color;
  final Value<String?> notificationDays;
  final Value<int> rowid;
  const LoansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.borrowerOrLender = const Value.absent(),
    this.type = const Value.absent(),
    this.principalAmount = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.totalInstallments = const Value.absent(),
    this.installmentAmount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.paymentFrequency = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.paidInstallments = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
    this.notificationDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoansCompanion.insert({
    required String id,
    required String name,
    this.borrowerOrLender = const Value.absent(),
    required String type,
    required double principalAmount,
    required double interestRate,
    required int totalInstallments,
    required double installmentAmount,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.paymentFrequency = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.paidAmount = const Value.absent(),
    this.paidInstallments = const Value.absent(),
    this.iconName = const Value.absent(),
    this.color = const Value.absent(),
    this.notificationDays = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        principalAmount = Value(principalAmount),
        interestRate = Value(interestRate),
        totalInstallments = Value(totalInstallments),
        installmentAmount = Value(installmentAmount),
        startDate = Value(startDate);
  static Insertable<Loan> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? borrowerOrLender,
    Expression<String>? type,
    Expression<double>? principalAmount,
    Expression<double>? interestRate,
    Expression<int>? totalInstallments,
    Expression<double>? installmentAmount,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? paymentFrequency,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<double>? paidAmount,
    Expression<int>? paidInstallments,
    Expression<String>? iconName,
    Expression<String>? color,
    Expression<String>? notificationDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (borrowerOrLender != null) 'borrower_or_lender': borrowerOrLender,
      if (type != null) 'type': type,
      if (principalAmount != null) 'principal_amount': principalAmount,
      if (interestRate != null) 'interest_rate': interestRate,
      if (totalInstallments != null) 'total_installments': totalInstallments,
      if (installmentAmount != null) 'installment_amount': installmentAmount,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (paymentFrequency != null) 'payment_frequency': paymentFrequency,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (paidAmount != null) 'paid_amount': paidAmount,
      if (paidInstallments != null) 'paid_installments': paidInstallments,
      if (iconName != null) 'icon_name': iconName,
      if (color != null) 'color': color,
      if (notificationDays != null) 'notification_days': notificationDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoansCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? borrowerOrLender,
      Value<String>? type,
      Value<double>? principalAmount,
      Value<double>? interestRate,
      Value<int>? totalInstallments,
      Value<double>? installmentAmount,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<String>? paymentFrequency,
      Value<String>? status,
      Value<String?>? notes,
      Value<double>? paidAmount,
      Value<int>? paidInstallments,
      Value<String?>? iconName,
      Value<String?>? color,
      Value<String?>? notificationDays,
      Value<int>? rowid}) {
    return LoansCompanion(
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
      notificationDays: notificationDays ?? this.notificationDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (borrowerOrLender.present) {
      map['borrower_or_lender'] = Variable<String>(borrowerOrLender.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (principalAmount.present) {
      map['principal_amount'] = Variable<double>(principalAmount.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (totalInstallments.present) {
      map['total_installments'] = Variable<int>(totalInstallments.value);
    }
    if (installmentAmount.present) {
      map['installment_amount'] = Variable<double>(installmentAmount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (paymentFrequency.present) {
      map['payment_frequency'] = Variable<String>(paymentFrequency.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (paidAmount.present) {
      map['paid_amount'] = Variable<double>(paidAmount.value);
    }
    if (paidInstallments.present) {
      map['paid_installments'] = Variable<int>(paidInstallments.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (notificationDays.present) {
      map['notification_days'] = Variable<String>(notificationDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('borrowerOrLender: $borrowerOrLender, ')
          ..write('type: $type, ')
          ..write('principalAmount: $principalAmount, ')
          ..write('interestRate: $interestRate, ')
          ..write('totalInstallments: $totalInstallments, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('paymentFrequency: $paymentFrequency, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('paidAmount: $paidAmount, ')
          ..write('paidInstallments: $paidInstallments, ')
          ..write('iconName: $iconName, ')
          ..write('color: $color, ')
          ..write('notificationDays: $notificationDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoanPaymentsTable extends LoanPayments
    with TableInfo<$LoanPaymentsTable, LoanPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoanPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loanIdMeta = const VerificationMeta('loanId');
  @override
  late final GeneratedColumn<String> loanId = GeneratedColumn<String>(
      'loan_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES loans (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _installmentNumberMeta =
      const VerificationMeta('installmentNumber');
  @override
  late final GeneratedColumn<int> installmentNumber = GeneratedColumn<int>(
      'installment_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, loanId, amount, date, installmentNumber, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loan_payments';
  @override
  VerificationContext validateIntegrity(Insertable<LoanPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('loan_id')) {
      context.handle(_loanIdMeta,
          loanId.isAcceptableOrUnknown(data['loan_id']!, _loanIdMeta));
    } else if (isInserting) {
      context.missing(_loanIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('installment_number')) {
      context.handle(
          _installmentNumberMeta,
          installmentNumber.isAcceptableOrUnknown(
              data['installment_number']!, _installmentNumberMeta));
    } else if (isInserting) {
      context.missing(_installmentNumberMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoanPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoanPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      loanId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}loan_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      installmentNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}installment_number'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $LoanPaymentsTable createAlias(String alias) {
    return $LoanPaymentsTable(attachedDatabase, alias);
  }
}

class LoanPayment extends DataClass implements Insertable<LoanPayment> {
  final String id;
  final String loanId;
  final double amount;
  final DateTime date;
  final int installmentNumber;
  final String? notes;
  const LoanPayment(
      {required this.id,
      required this.loanId,
      required this.amount,
      required this.date,
      required this.installmentNumber,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['loan_id'] = Variable<String>(loanId);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['installment_number'] = Variable<int>(installmentNumber);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  LoanPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LoanPaymentsCompanion(
      id: Value(id),
      loanId: Value(loanId),
      amount: Value(amount),
      date: Value(date),
      installmentNumber: Value(installmentNumber),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory LoanPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoanPayment(
      id: serializer.fromJson<String>(json['id']),
      loanId: serializer.fromJson<String>(json['loanId']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      installmentNumber: serializer.fromJson<int>(json['installmentNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'loanId': serializer.toJson<String>(loanId),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'installmentNumber': serializer.toJson<int>(installmentNumber),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  LoanPayment copyWith(
          {String? id,
          String? loanId,
          double? amount,
          DateTime? date,
          int? installmentNumber,
          Value<String?> notes = const Value.absent()}) =>
      LoanPayment(
        id: id ?? this.id,
        loanId: loanId ?? this.loanId,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        installmentNumber: installmentNumber ?? this.installmentNumber,
        notes: notes.present ? notes.value : this.notes,
      );
  LoanPayment copyWithCompanion(LoanPaymentsCompanion data) {
    return LoanPayment(
      id: data.id.present ? data.id.value : this.id,
      loanId: data.loanId.present ? data.loanId.value : this.loanId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      installmentNumber: data.installmentNumber.present
          ? data.installmentNumber.value
          : this.installmentNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LoanPayment(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, loanId, amount, date, installmentNumber, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoanPayment &&
          other.id == this.id &&
          other.loanId == this.loanId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.installmentNumber == this.installmentNumber &&
          other.notes == this.notes);
}

class LoanPaymentsCompanion extends UpdateCompanion<LoanPayment> {
  final Value<String> id;
  final Value<String> loanId;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<int> installmentNumber;
  final Value<String?> notes;
  final Value<int> rowid;
  const LoanPaymentsCompanion({
    this.id = const Value.absent(),
    this.loanId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.installmentNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LoanPaymentsCompanion.insert({
    required String id,
    required String loanId,
    required double amount,
    required DateTime date,
    required int installmentNumber,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        loanId = Value(loanId),
        amount = Value(amount),
        date = Value(date),
        installmentNumber = Value(installmentNumber);
  static Insertable<LoanPayment> custom({
    Expression<String>? id,
    Expression<String>? loanId,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<int>? installmentNumber,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loanId != null) 'loan_id': loanId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (installmentNumber != null) 'installment_number': installmentNumber,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LoanPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? loanId,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<int>? installmentNumber,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return LoanPaymentsCompanion(
      id: id ?? this.id,
      loanId: loanId ?? this.loanId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (loanId.present) {
      map['loan_id'] = Variable<String>(loanId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (installmentNumber.present) {
      map['installment_number'] = Variable<int>(installmentNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoanPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('loanId: $loanId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('installmentNumber: $installmentNumber, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _monthStartDayMeta =
      const VerificationMeta('monthStartDay');
  @override
  late final GeneratedColumn<int> monthStartDay = GeneratedColumn<int>(
      'month_start_day', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('COP'));
  static const VerificationMeta _currencySymbolMeta =
      const VerificationMeta('currencySymbol');
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
      'currency_symbol', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('\$'));
  static const VerificationMeta _thousandsSeparatorMeta =
      const VerificationMeta('thousandsSeparator');
  @override
  late final GeneratedColumn<String> thousandsSeparator =
      GeneratedColumn<String>('thousands_separator', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(','));
  static const VerificationMeta _decimalSeparatorMeta =
      const VerificationMeta('decimalSeparator');
  @override
  late final GeneratedColumn<String> decimalSeparator = GeneratedColumn<String>(
      'decimal_separator', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('.'));
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _budgetAlertsEnabledMeta =
      const VerificationMeta('budgetAlertsEnabled');
  @override
  late final GeneratedColumn<bool> budgetAlertsEnabled = GeneratedColumn<bool>(
      'budget_alerts_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("budget_alerts_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _loanRemindersEnabledMeta =
      const VerificationMeta('loanRemindersEnabled');
  @override
  late final GeneratedColumn<bool> loanRemindersEnabled = GeneratedColumn<bool>(
      'loan_reminders_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("loan_reminders_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _savingsRemindersEnabledMeta =
      const VerificationMeta('savingsRemindersEnabled');
  @override
  late final GeneratedColumn<bool> savingsRemindersEnabled =
      GeneratedColumn<bool>('savings_reminders_enabled', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("savings_reminders_enabled" IN (0, 1))'),
          defaultValue: const Constant(true));
  static const VerificationMeta _notificationPermissionAskedMeta =
      const VerificationMeta('notificationPermissionAsked');
  @override
  late final GeneratedColumn<bool> notificationPermissionAsked =
      GeneratedColumn<bool>('notification_permission_asked', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("notification_permission_asked" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
      'theme', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        monthStartDay,
        currency,
        currencySymbol,
        thousandsSeparator,
        decimalSeparator,
        notificationsEnabled,
        budgetAlertsEnabled,
        loanRemindersEnabled,
        savingsRemindersEnabled,
        notificationPermissionAsked,
        theme,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('month_start_day')) {
      context.handle(
          _monthStartDayMeta,
          monthStartDay.isAcceptableOrUnknown(
              data['month_start_day']!, _monthStartDayMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
          _currencySymbolMeta,
          currencySymbol.isAcceptableOrUnknown(
              data['currency_symbol']!, _currencySymbolMeta));
    }
    if (data.containsKey('thousands_separator')) {
      context.handle(
          _thousandsSeparatorMeta,
          thousandsSeparator.isAcceptableOrUnknown(
              data['thousands_separator']!, _thousandsSeparatorMeta));
    }
    if (data.containsKey('decimal_separator')) {
      context.handle(
          _decimalSeparatorMeta,
          decimalSeparator.isAcceptableOrUnknown(
              data['decimal_separator']!, _decimalSeparatorMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    if (data.containsKey('budget_alerts_enabled')) {
      context.handle(
          _budgetAlertsEnabledMeta,
          budgetAlertsEnabled.isAcceptableOrUnknown(
              data['budget_alerts_enabled']!, _budgetAlertsEnabledMeta));
    }
    if (data.containsKey('loan_reminders_enabled')) {
      context.handle(
          _loanRemindersEnabledMeta,
          loanRemindersEnabled.isAcceptableOrUnknown(
              data['loan_reminders_enabled']!, _loanRemindersEnabledMeta));
    }
    if (data.containsKey('savings_reminders_enabled')) {
      context.handle(
          _savingsRemindersEnabledMeta,
          savingsRemindersEnabled.isAcceptableOrUnknown(
              data['savings_reminders_enabled']!,
              _savingsRemindersEnabledMeta));
    }
    if (data.containsKey('notification_permission_asked')) {
      context.handle(
          _notificationPermissionAskedMeta,
          notificationPermissionAsked.isAcceptableOrUnknown(
              data['notification_permission_asked']!,
              _notificationPermissionAskedMeta));
    }
    if (data.containsKey('theme')) {
      context.handle(
          _themeMeta, theme.isAcceptableOrUnknown(data['theme']!, _themeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      monthStartDay: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month_start_day'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      currencySymbol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}currency_symbol'])!,
      thousandsSeparator: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}thousands_separator'])!,
      decimalSeparator: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}decimal_separator'])!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
      budgetAlertsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}budget_alerts_enabled'])!,
      loanRemindersEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}loan_reminders_enabled'])!,
      savingsRemindersEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}savings_reminders_enabled'])!,
      notificationPermissionAsked: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}notification_permission_asked'])!,
      theme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsTableData extends DataClass
    implements Insertable<UserSettingsTableData> {
  final String id;
  final int monthStartDay;
  final String currency;
  final String currencySymbol;
  final String thousandsSeparator;
  final String decimalSeparator;
  final bool notificationsEnabled;
  final bool budgetAlertsEnabled;
  final bool loanRemindersEnabled;
  final bool savingsRemindersEnabled;
  final bool notificationPermissionAsked;
  final String? theme;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const UserSettingsTableData(
      {required this.id,
      required this.monthStartDay,
      required this.currency,
      required this.currencySymbol,
      required this.thousandsSeparator,
      required this.decimalSeparator,
      required this.notificationsEnabled,
      required this.budgetAlertsEnabled,
      required this.loanRemindersEnabled,
      required this.savingsRemindersEnabled,
      required this.notificationPermissionAsked,
      this.theme,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['month_start_day'] = Variable<int>(monthStartDay);
    map['currency'] = Variable<String>(currency);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['thousands_separator'] = Variable<String>(thousandsSeparator);
    map['decimal_separator'] = Variable<String>(decimalSeparator);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    map['budget_alerts_enabled'] = Variable<bool>(budgetAlertsEnabled);
    map['loan_reminders_enabled'] = Variable<bool>(loanRemindersEnabled);
    map['savings_reminders_enabled'] = Variable<bool>(savingsRemindersEnabled);
    map['notification_permission_asked'] =
        Variable<bool>(notificationPermissionAsked);
    if (!nullToAbsent || theme != null) {
      map['theme'] = Variable<String>(theme);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      monthStartDay: Value(monthStartDay),
      currency: Value(currency),
      currencySymbol: Value(currencySymbol),
      thousandsSeparator: Value(thousandsSeparator),
      decimalSeparator: Value(decimalSeparator),
      notificationsEnabled: Value(notificationsEnabled),
      budgetAlertsEnabled: Value(budgetAlertsEnabled),
      loanRemindersEnabled: Value(loanRemindersEnabled),
      savingsRemindersEnabled: Value(savingsRemindersEnabled),
      notificationPermissionAsked: Value(notificationPermissionAsked),
      theme:
          theme == null && nullToAbsent ? const Value.absent() : Value(theme),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory UserSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsTableData(
      id: serializer.fromJson<String>(json['id']),
      monthStartDay: serializer.fromJson<int>(json['monthStartDay']),
      currency: serializer.fromJson<String>(json['currency']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      thousandsSeparator:
          serializer.fromJson<String>(json['thousandsSeparator']),
      decimalSeparator: serializer.fromJson<String>(json['decimalSeparator']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
      budgetAlertsEnabled:
          serializer.fromJson<bool>(json['budgetAlertsEnabled']),
      loanRemindersEnabled:
          serializer.fromJson<bool>(json['loanRemindersEnabled']),
      savingsRemindersEnabled:
          serializer.fromJson<bool>(json['savingsRemindersEnabled']),
      notificationPermissionAsked:
          serializer.fromJson<bool>(json['notificationPermissionAsked']),
      theme: serializer.fromJson<String?>(json['theme']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'monthStartDay': serializer.toJson<int>(monthStartDay),
      'currency': serializer.toJson<String>(currency),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'thousandsSeparator': serializer.toJson<String>(thousandsSeparator),
      'decimalSeparator': serializer.toJson<String>(decimalSeparator),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'budgetAlertsEnabled': serializer.toJson<bool>(budgetAlertsEnabled),
      'loanRemindersEnabled': serializer.toJson<bool>(loanRemindersEnabled),
      'savingsRemindersEnabled':
          serializer.toJson<bool>(savingsRemindersEnabled),
      'notificationPermissionAsked':
          serializer.toJson<bool>(notificationPermissionAsked),
      'theme': serializer.toJson<String?>(theme),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  UserSettingsTableData copyWith(
          {String? id,
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
          Value<String?> theme = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      UserSettingsTableData(
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
        notificationPermissionAsked:
            notificationPermissionAsked ?? this.notificationPermissionAsked,
        theme: theme.present ? theme.value : this.theme,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  UserSettingsTableData copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      monthStartDay: data.monthStartDay.present
          ? data.monthStartDay.value
          : this.monthStartDay,
      currency: data.currency.present ? data.currency.value : this.currency,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      thousandsSeparator: data.thousandsSeparator.present
          ? data.thousandsSeparator.value
          : this.thousandsSeparator,
      decimalSeparator: data.decimalSeparator.present
          ? data.decimalSeparator.value
          : this.decimalSeparator,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      budgetAlertsEnabled: data.budgetAlertsEnabled.present
          ? data.budgetAlertsEnabled.value
          : this.budgetAlertsEnabled,
      loanRemindersEnabled: data.loanRemindersEnabled.present
          ? data.loanRemindersEnabled.value
          : this.loanRemindersEnabled,
      savingsRemindersEnabled: data.savingsRemindersEnabled.present
          ? data.savingsRemindersEnabled.value
          : this.savingsRemindersEnabled,
      notificationPermissionAsked: data.notificationPermissionAsked.present
          ? data.notificationPermissionAsked.value
          : this.notificationPermissionAsked,
      theme: data.theme.present ? data.theme.value : this.theme,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableData(')
          ..write('id: $id, ')
          ..write('monthStartDay: $monthStartDay, ')
          ..write('currency: $currency, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('thousandsSeparator: $thousandsSeparator, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('budgetAlertsEnabled: $budgetAlertsEnabled, ')
          ..write('loanRemindersEnabled: $loanRemindersEnabled, ')
          ..write('savingsRemindersEnabled: $savingsRemindersEnabled, ')
          ..write('notificationPermissionAsked: $notificationPermissionAsked, ')
          ..write('theme: $theme, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      monthStartDay,
      currency,
      currencySymbol,
      thousandsSeparator,
      decimalSeparator,
      notificationsEnabled,
      budgetAlertsEnabled,
      loanRemindersEnabled,
      savingsRemindersEnabled,
      notificationPermissionAsked,
      theme,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsTableData &&
          other.id == this.id &&
          other.monthStartDay == this.monthStartDay &&
          other.currency == this.currency &&
          other.currencySymbol == this.currencySymbol &&
          other.thousandsSeparator == this.thousandsSeparator &&
          other.decimalSeparator == this.decimalSeparator &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.budgetAlertsEnabled == this.budgetAlertsEnabled &&
          other.loanRemindersEnabled == this.loanRemindersEnabled &&
          other.savingsRemindersEnabled == this.savingsRemindersEnabled &&
          other.notificationPermissionAsked ==
              this.notificationPermissionAsked &&
          other.theme == this.theme &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsTableCompanion
    extends UpdateCompanion<UserSettingsTableData> {
  final Value<String> id;
  final Value<int> monthStartDay;
  final Value<String> currency;
  final Value<String> currencySymbol;
  final Value<String> thousandsSeparator;
  final Value<String> decimalSeparator;
  final Value<bool> notificationsEnabled;
  final Value<bool> budgetAlertsEnabled;
  final Value<bool> loanRemindersEnabled;
  final Value<bool> savingsRemindersEnabled;
  final Value<bool> notificationPermissionAsked;
  final Value<String?> theme;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.monthStartDay = const Value.absent(),
    this.currency = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.thousandsSeparator = const Value.absent(),
    this.decimalSeparator = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.budgetAlertsEnabled = const Value.absent(),
    this.loanRemindersEnabled = const Value.absent(),
    this.savingsRemindersEnabled = const Value.absent(),
    this.notificationPermissionAsked = const Value.absent(),
    this.theme = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    required String id,
    this.monthStartDay = const Value.absent(),
    this.currency = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.thousandsSeparator = const Value.absent(),
    this.decimalSeparator = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.budgetAlertsEnabled = const Value.absent(),
    this.loanRemindersEnabled = const Value.absent(),
    this.savingsRemindersEnabled = const Value.absent(),
    this.notificationPermissionAsked = const Value.absent(),
    this.theme = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt);
  static Insertable<UserSettingsTableData> custom({
    Expression<String>? id,
    Expression<int>? monthStartDay,
    Expression<String>? currency,
    Expression<String>? currencySymbol,
    Expression<String>? thousandsSeparator,
    Expression<String>? decimalSeparator,
    Expression<bool>? notificationsEnabled,
    Expression<bool>? budgetAlertsEnabled,
    Expression<bool>? loanRemindersEnabled,
    Expression<bool>? savingsRemindersEnabled,
    Expression<bool>? notificationPermissionAsked,
    Expression<String>? theme,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (monthStartDay != null) 'month_start_day': monthStartDay,
      if (currency != null) 'currency': currency,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (thousandsSeparator != null) 'thousands_separator': thousandsSeparator,
      if (decimalSeparator != null) 'decimal_separator': decimalSeparator,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (budgetAlertsEnabled != null)
        'budget_alerts_enabled': budgetAlertsEnabled,
      if (loanRemindersEnabled != null)
        'loan_reminders_enabled': loanRemindersEnabled,
      if (savingsRemindersEnabled != null)
        'savings_reminders_enabled': savingsRemindersEnabled,
      if (notificationPermissionAsked != null)
        'notification_permission_asked': notificationPermissionAsked,
      if (theme != null) 'theme': theme,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? monthStartDay,
      Value<String>? currency,
      Value<String>? currencySymbol,
      Value<String>? thousandsSeparator,
      Value<String>? decimalSeparator,
      Value<bool>? notificationsEnabled,
      Value<bool>? budgetAlertsEnabled,
      Value<bool>? loanRemindersEnabled,
      Value<bool>? savingsRemindersEnabled,
      Value<bool>? notificationPermissionAsked,
      Value<String?>? theme,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return UserSettingsTableCompanion(
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
      notificationPermissionAsked:
          notificationPermissionAsked ?? this.notificationPermissionAsked,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (monthStartDay.present) {
      map['month_start_day'] = Variable<int>(monthStartDay.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (thousandsSeparator.present) {
      map['thousands_separator'] = Variable<String>(thousandsSeparator.value);
    }
    if (decimalSeparator.present) {
      map['decimal_separator'] = Variable<String>(decimalSeparator.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (budgetAlertsEnabled.present) {
      map['budget_alerts_enabled'] = Variable<bool>(budgetAlertsEnabled.value);
    }
    if (loanRemindersEnabled.present) {
      map['loan_reminders_enabled'] =
          Variable<bool>(loanRemindersEnabled.value);
    }
    if (savingsRemindersEnabled.present) {
      map['savings_reminders_enabled'] =
          Variable<bool>(savingsRemindersEnabled.value);
    }
    if (notificationPermissionAsked.present) {
      map['notification_permission_asked'] =
          Variable<bool>(notificationPermissionAsked.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('monthStartDay: $monthStartDay, ')
          ..write('currency: $currency, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('thousandsSeparator: $thousandsSeparator, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('budgetAlertsEnabled: $budgetAlertsEnabled, ')
          ..write('loanRemindersEnabled: $loanRemindersEnabled, ')
          ..write('savingsRemindersEnabled: $savingsRemindersEnabled, ')
          ..write('notificationPermissionAsked: $notificationPermissionAsked, ')
          ..write('theme: $theme, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransactionsTable extends RecurringTransactions
    with TableInfo<$RecurringTransactionsTable, RecurringTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayOfMonthMeta =
      const VerificationMeta('dayOfMonth');
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
      'day_of_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dayOfWeekMeta =
      const VerificationMeta('dayOfWeek');
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
      'day_of_week', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastProcessedDateMeta =
      const VerificationMeta('lastProcessedDate');
  @override
  late final GeneratedColumn<DateTime> lastProcessedDate =
      GeneratedColumn<DateTime>('last_processed_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        amount,
        type,
        category,
        source,
        frequency,
        dayOfMonth,
        dayOfWeek,
        startDate,
        endDate,
        lastProcessedDate,
        isActive,
        description
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transactions';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecurringTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
          _dayOfMonthMeta,
          dayOfMonth.isAcceptableOrUnknown(
              data['day_of_month']!, _dayOfMonthMeta));
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
          _dayOfWeekMeta,
          dayOfWeek.isAcceptableOrUnknown(
              data['day_of_week']!, _dayOfWeekMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('last_processed_date')) {
      context.handle(
          _lastProcessedDateMeta,
          lastProcessedDate.isAcceptableOrUnknown(
              data['last_processed_date']!, _lastProcessedDateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      dayOfMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_month']),
      dayOfWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_week']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      lastProcessedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_processed_date']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
    );
  }

  @override
  $RecurringTransactionsTable createAlias(String alias) {
    return $RecurringTransactionsTable(attachedDatabase, alias);
  }
}

class RecurringTransaction extends DataClass
    implements Insertable<RecurringTransaction> {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String? source;
  final String frequency;
  final int? dayOfMonth;
  final int? dayOfWeek;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? lastProcessedDate;
  final bool isActive;
  final String? description;
  const RecurringTransaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.type,
      required this.category,
      this.source,
      required this.frequency,
      this.dayOfMonth,
      this.dayOfWeek,
      required this.startDate,
      this.endDate,
      this.lastProcessedDate,
      required this.isActive,
      this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<double>(amount);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || dayOfMonth != null) {
      map['day_of_month'] = Variable<int>(dayOfMonth);
    }
    if (!nullToAbsent || dayOfWeek != null) {
      map['day_of_week'] = Variable<int>(dayOfWeek);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || lastProcessedDate != null) {
      map['last_processed_date'] = Variable<DateTime>(lastProcessedDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  RecurringTransactionsCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransactionsCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      type: Value(type),
      category: Value(category),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      frequency: Value(frequency),
      dayOfMonth: dayOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfMonth),
      dayOfWeek: dayOfWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfWeek),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      lastProcessedDate: lastProcessedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProcessedDate),
      isActive: Value(isActive),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory RecurringTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransaction(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      source: serializer.fromJson<String?>(json['source']),
      frequency: serializer.fromJson<String>(json['frequency']),
      dayOfMonth: serializer.fromJson<int?>(json['dayOfMonth']),
      dayOfWeek: serializer.fromJson<int?>(json['dayOfWeek']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      lastProcessedDate:
          serializer.fromJson<DateTime?>(json['lastProcessedDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'source': serializer.toJson<String?>(source),
      'frequency': serializer.toJson<String>(frequency),
      'dayOfMonth': serializer.toJson<int?>(dayOfMonth),
      'dayOfWeek': serializer.toJson<int?>(dayOfWeek),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'lastProcessedDate': serializer.toJson<DateTime?>(lastProcessedDate),
      'isActive': serializer.toJson<bool>(isActive),
      'description': serializer.toJson<String?>(description),
    };
  }

  RecurringTransaction copyWith(
          {String? id,
          String? title,
          double? amount,
          String? type,
          String? category,
          Value<String?> source = const Value.absent(),
          String? frequency,
          Value<int?> dayOfMonth = const Value.absent(),
          Value<int?> dayOfWeek = const Value.absent(),
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          Value<DateTime?> lastProcessedDate = const Value.absent(),
          bool? isActive,
          Value<String?> description = const Value.absent()}) =>
      RecurringTransaction(
        id: id ?? this.id,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        category: category ?? this.category,
        source: source.present ? source.value : this.source,
        frequency: frequency ?? this.frequency,
        dayOfMonth: dayOfMonth.present ? dayOfMonth.value : this.dayOfMonth,
        dayOfWeek: dayOfWeek.present ? dayOfWeek.value : this.dayOfWeek,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        lastProcessedDate: lastProcessedDate.present
            ? lastProcessedDate.value
            : this.lastProcessedDate,
        isActive: isActive ?? this.isActive,
        description: description.present ? description.value : this.description,
      );
  RecurringTransaction copyWithCompanion(RecurringTransactionsCompanion data) {
    return RecurringTransaction(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      source: data.source.present ? data.source.value : this.source,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      dayOfMonth:
          data.dayOfMonth.present ? data.dayOfMonth.value : this.dayOfMonth,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      lastProcessedDate: data.lastProcessedDate.present
          ? data.lastProcessedDate.value
          : this.lastProcessedDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      description:
          data.description.present ? data.description.value : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransaction(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('source: $source, ')
          ..write('frequency: $frequency, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('lastProcessedDate: $lastProcessedDate, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      amount,
      type,
      category,
      source,
      frequency,
      dayOfMonth,
      dayOfWeek,
      startDate,
      endDate,
      lastProcessedDate,
      isActive,
      description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransaction &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.category == this.category &&
          other.source == this.source &&
          other.frequency == this.frequency &&
          other.dayOfMonth == this.dayOfMonth &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.lastProcessedDate == this.lastProcessedDate &&
          other.isActive == this.isActive &&
          other.description == this.description);
}

class RecurringTransactionsCompanion
    extends UpdateCompanion<RecurringTransaction> {
  final Value<String> id;
  final Value<String> title;
  final Value<double> amount;
  final Value<String> type;
  final Value<String> category;
  final Value<String?> source;
  final Value<String> frequency;
  final Value<int?> dayOfMonth;
  final Value<int?> dayOfWeek;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime?> lastProcessedDate;
  final Value<bool> isActive;
  final Value<String?> description;
  final Value<int> rowid;
  const RecurringTransactionsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.source = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.lastProcessedDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringTransactionsCompanion.insert({
    required String id,
    required String title,
    required double amount,
    required String type,
    required String category,
    this.source = const Value.absent(),
    required String frequency,
    this.dayOfMonth = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.lastProcessedDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        amount = Value(amount),
        type = Value(type),
        category = Value(category),
        frequency = Value(frequency),
        startDate = Value(startDate);
  static Insertable<RecurringTransaction> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? source,
    Expression<String>? frequency,
    Expression<int>? dayOfMonth,
    Expression<int>? dayOfWeek,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? lastProcessedDate,
    Expression<bool>? isActive,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (source != null) 'source': source,
      if (frequency != null) 'frequency': frequency,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (lastProcessedDate != null) 'last_processed_date': lastProcessedDate,
      if (isActive != null) 'is_active': isActive,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<double>? amount,
      Value<String>? type,
      Value<String>? category,
      Value<String?>? source,
      Value<String>? frequency,
      Value<int?>? dayOfMonth,
      Value<int?>? dayOfWeek,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<DateTime?>? lastProcessedDate,
      Value<bool>? isActive,
      Value<String?>? description,
      Value<int>? rowid}) {
    return RecurringTransactionsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      source: source ?? this.source,
      frequency: frequency ?? this.frequency,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lastProcessedDate: lastProcessedDate ?? this.lastProcessedDate,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (lastProcessedDate.present) {
      map['last_processed_date'] = Variable<DateTime>(lastProcessedDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('source: $source, ')
          ..write('frequency: $frequency, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('lastProcessedDate: $lastProcessedDate, ')
          ..write('isActive: $isActive, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $CustomCategoriesTable customCategories =
      $CustomCategoriesTable(this);
  late final $CustomIncomeSourcesTable customIncomeSources =
      $CustomIncomeSourcesTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $SavingsContributionsTable savingsContributions =
      $SavingsContributionsTable(this);
  late final $InvestmentsTable investments = $InvestmentsTable(this);
  late final $InvestmentValueHistoryTable investmentValueHistory =
      $InvestmentValueHistoryTable(this);
  late final $LoansTable loans = $LoansTable(this);
  late final $LoanPaymentsTable loanPayments = $LoanPaymentsTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $RecurringTransactionsTable recurringTransactions =
      $RecurringTransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        transactions,
        budgets,
        alerts,
        customCategories,
        customIncomeSources,
        savingsGoals,
        savingsContributions,
        investments,
        investmentValueHistory,
        loans,
        loanPayments,
        userSettingsTable,
        recurringTransactions
      ];
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  required String id,
  required String title,
  required double amount,
  required String type,
  required String category,
  required DateTime date,
  Value<String?> description,
  Value<String?> source,
  Value<bool> isRecurring,
  Value<String?> recurringFrequency,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String> type,
  Value<String> category,
  Value<DateTime> date,
  Value<String?> description,
  Value<String?> source,
  Value<bool> isRecurring,
  Value<String?> recurringFrequency,
  Value<int> rowid,
});

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recurringFrequency => $composableBuilder(
      column: $table.recurringFrequency,
      builder: (column) => ColumnFilters(column));
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurringFrequency => $composableBuilder(
      column: $table.recurringFrequency,
      builder: (column) => ColumnOrderings(column));
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isRecurring => $composableBuilder(
      column: $table.isRecurring, builder: (column) => column);

  GeneratedColumn<String> get recurringFrequency => $composableBuilder(
      column: $table.recurringFrequency, builder: (column) => column);
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringFrequency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            title: title,
            amount: amount,
            type: type,
            category: category,
            date: date,
            description: description,
            source: source,
            isRecurring: isRecurring,
            recurringFrequency: recurringFrequency,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            required String type,
            required String category,
            required DateTime date,
            Value<String?> description = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<bool> isRecurring = const Value.absent(),
            Value<String?> recurringFrequency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            type: type,
            category: category,
            date: date,
            description: description,
            source: source,
            isRecurring: isRecurring,
            recurringFrequency: recurringFrequency,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (
      Transaction,
      BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>
    ),
    Transaction,
    PrefetchHooks Function()>;
typedef $$BudgetsTableCreateCompanionBuilder = BudgetsCompanion Function({
  required String id,
  required String category,
  required double maxAmount,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$BudgetsTableUpdateCompanionBuilder = BudgetsCompanion Function({
  Value<String> id,
  Value<String> category,
  Value<double> maxAmount,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxAmount => $composableBuilder(
      column: $table.maxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxAmount => $composableBuilder(
      column: $table.maxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get maxAmount =>
      $composableBuilder(column: $table.maxAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
    Budget,
    PrefetchHooks Function()> {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> maxAmount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion(
            id: id,
            category: category,
            maxAmount: maxAmount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String category,
            required double maxAmount,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BudgetsCompanion.insert(
            id: id,
            category: category,
            maxAmount: maxAmount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BudgetsTable,
    Budget,
    $$BudgetsTableFilterComposer,
    $$BudgetsTableOrderingComposer,
    $$BudgetsTableAnnotationComposer,
    $$BudgetsTableCreateCompanionBuilder,
    $$BudgetsTableUpdateCompanionBuilder,
    (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
    Budget,
    PrefetchHooks Function()>;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  required String id,
  required String category,
  required String type,
  required double currentAmount,
  required double maxAmount,
  required double percentage,
  required DateTime createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<String> id,
  Value<String> category,
  Value<String> type,
  Value<double> currentAmount,
  Value<double> maxAmount,
  Value<double> percentage,
  Value<DateTime> createdAt,
  Value<bool> isRead,
  Value<int> rowid,
});

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxAmount => $composableBuilder(
      column: $table.maxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxAmount => $composableBuilder(
      column: $table.maxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<double> get maxAmount =>
      $composableBuilder(column: $table.maxAmount, builder: (column) => column);

  GeneratedColumn<double> get percentage => $composableBuilder(
      column: $table.percentage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$AlertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, BaseReferences<_$AppDatabase, $AlertsTable, Alert>),
    Alert,
    PrefetchHooks Function()> {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> currentAmount = const Value.absent(),
            Value<double> maxAmount = const Value.absent(),
            Value<double> percentage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion(
            id: id,
            category: category,
            type: type,
            currentAmount: currentAmount,
            maxAmount: maxAmount,
            percentage: percentage,
            createdAt: createdAt,
            isRead: isRead,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String category,
            required String type,
            required double currentAmount,
            required double maxAmount,
            required double percentage,
            required DateTime createdAt,
            Value<bool> isRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertsCompanion.insert(
            id: id,
            category: category,
            type: type,
            currentAmount: currentAmount,
            maxAmount: maxAmount,
            percentage: percentage,
            createdAt: createdAt,
            isRead: isRead,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, BaseReferences<_$AppDatabase, $AlertsTable, Alert>),
    Alert,
    PrefetchHooks Function()>;
typedef $$CustomCategoriesTableCreateCompanionBuilder
    = CustomCategoriesCompanion Function({
  required String name,
  Value<int> rowid,
});
typedef $$CustomCategoriesTableUpdateCompanionBuilder
    = CustomCategoriesCompanion Function({
  Value<String> name,
  Value<int> rowid,
});

class $$CustomCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$CustomCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$CustomCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomCategoriesTable> {
  $$CustomCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CustomCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomCategoriesTable,
    CustomCategory,
    $$CustomCategoriesTableFilterComposer,
    $$CustomCategoriesTableOrderingComposer,
    $$CustomCategoriesTableAnnotationComposer,
    $$CustomCategoriesTableCreateCompanionBuilder,
    $$CustomCategoriesTableUpdateCompanionBuilder,
    (
      CustomCategory,
      BaseReferences<_$AppDatabase, $CustomCategoriesTable, CustomCategory>
    ),
    CustomCategory,
    PrefetchHooks Function()> {
  $$CustomCategoriesTableTableManager(
      _$AppDatabase db, $CustomCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomCategoriesCompanion(
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomCategoriesCompanion.insert(
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomCategoriesTable,
    CustomCategory,
    $$CustomCategoriesTableFilterComposer,
    $$CustomCategoriesTableOrderingComposer,
    $$CustomCategoriesTableAnnotationComposer,
    $$CustomCategoriesTableCreateCompanionBuilder,
    $$CustomCategoriesTableUpdateCompanionBuilder,
    (
      CustomCategory,
      BaseReferences<_$AppDatabase, $CustomCategoriesTable, CustomCategory>
    ),
    CustomCategory,
    PrefetchHooks Function()>;
typedef $$CustomIncomeSourcesTableCreateCompanionBuilder
    = CustomIncomeSourcesCompanion Function({
  required String name,
  Value<int> rowid,
});
typedef $$CustomIncomeSourcesTableUpdateCompanionBuilder
    = CustomIncomeSourcesCompanion Function({
  Value<String> name,
  Value<int> rowid,
});

class $$CustomIncomeSourcesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomIncomeSourcesTable> {
  $$CustomIncomeSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));
}

class $$CustomIncomeSourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomIncomeSourcesTable> {
  $$CustomIncomeSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$CustomIncomeSourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomIncomeSourcesTable> {
  $$CustomIncomeSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CustomIncomeSourcesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomIncomeSourcesTable,
    CustomIncomeSource,
    $$CustomIncomeSourcesTableFilterComposer,
    $$CustomIncomeSourcesTableOrderingComposer,
    $$CustomIncomeSourcesTableAnnotationComposer,
    $$CustomIncomeSourcesTableCreateCompanionBuilder,
    $$CustomIncomeSourcesTableUpdateCompanionBuilder,
    (
      CustomIncomeSource,
      BaseReferences<_$AppDatabase, $CustomIncomeSourcesTable,
          CustomIncomeSource>
    ),
    CustomIncomeSource,
    PrefetchHooks Function()> {
  $$CustomIncomeSourcesTableTableManager(
      _$AppDatabase db, $CustomIncomeSourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomIncomeSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomIncomeSourcesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomIncomeSourcesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomIncomeSourcesCompanion(
            name: name,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomIncomeSourcesCompanion.insert(
            name: name,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomIncomeSourcesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomIncomeSourcesTable,
    CustomIncomeSource,
    $$CustomIncomeSourcesTableFilterComposer,
    $$CustomIncomeSourcesTableOrderingComposer,
    $$CustomIncomeSourcesTableAnnotationComposer,
    $$CustomIncomeSourcesTableCreateCompanionBuilder,
    $$CustomIncomeSourcesTableUpdateCompanionBuilder,
    (
      CustomIncomeSource,
      BaseReferences<_$AppDatabase, $CustomIncomeSourcesTable,
          CustomIncomeSource>
    ),
    CustomIncomeSource,
    PrefetchHooks Function()>;
typedef $$SavingsGoalsTableCreateCompanionBuilder = SavingsGoalsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> description,
  required double targetAmount,
  Value<double> currentAmount,
  required DateTime createdAt,
  Value<DateTime?> targetDate,
  Value<String> status,
  Value<String?> iconName,
  Value<String?> color,
  Value<String?> notificationDays,
  Value<int> rowid,
});
typedef $$SavingsGoalsTableUpdateCompanionBuilder = SavingsGoalsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<double> targetAmount,
  Value<double> currentAmount,
  Value<DateTime> createdAt,
  Value<DateTime?> targetDate,
  Value<String> status,
  Value<String?> iconName,
  Value<String?> color,
  Value<String?> notificationDays,
  Value<int> rowid,
});

final class $$SavingsGoalsTableReferences
    extends BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal> {
  $$SavingsGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SavingsContributionsTable,
      List<SavingsContribution>> _savingsContributionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.savingsContributions,
          aliasName: $_aliasNameGenerator(
              db.savingsGoals.id, db.savingsContributions.savingsGoalId));

  $$SavingsContributionsTableProcessedTableManager
      get savingsContributionsRefs {
    final manager = $$SavingsContributionsTableTableManager(
            $_db, $_db.savingsContributions)
        .filter(
            (f) => f.savingsGoalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_savingsContributionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays,
      builder: (column) => ColumnFilters(column));

  Expression<bool> savingsContributionsRefs(
      Expression<bool> Function($$SavingsContributionsTableFilterComposer f)
          f) {
    final $$SavingsContributionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.savingsContributions,
        getReferencedColumn: (t) => t.savingsGoalId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavingsContributionsTableFilterComposer(
              $db: $db,
              $table: $db.savingsContributions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays,
      builder: (column) => ColumnOrderings(column));
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get targetAmount => $composableBuilder(
      column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<double> get currentAmount => $composableBuilder(
      column: $table.currentAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
      column: $table.targetDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays, builder: (column) => column);

  Expression<T> savingsContributionsRefs<T extends Object>(
      Expression<T> Function($$SavingsContributionsTableAnnotationComposer a)
          f) {
    final $$SavingsContributionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.savingsContributions,
            getReferencedColumn: (t) => t.savingsGoalId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SavingsContributionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.savingsContributions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SavingsGoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavingsGoalsTable,
    SavingsGoal,
    $$SavingsGoalsTableFilterComposer,
    $$SavingsGoalsTableOrderingComposer,
    $$SavingsGoalsTableAnnotationComposer,
    $$SavingsGoalsTableCreateCompanionBuilder,
    $$SavingsGoalsTableUpdateCompanionBuilder,
    (SavingsGoal, $$SavingsGoalsTableReferences),
    SavingsGoal,
    PrefetchHooks Function({bool savingsContributionsRefs})> {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> targetAmount = const Value.absent(),
            Value<double> currentAmount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> notificationDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavingsGoalsCompanion(
            id: id,
            name: name,
            description: description,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            createdAt: createdAt,
            targetDate: targetDate,
            status: status,
            iconName: iconName,
            color: color,
            notificationDays: notificationDays,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required double targetAmount,
            Value<double> currentAmount = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> targetDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> notificationDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavingsGoalsCompanion.insert(
            id: id,
            name: name,
            description: description,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            createdAt: createdAt,
            targetDate: targetDate,
            status: status,
            iconName: iconName,
            color: color,
            notificationDays: notificationDays,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SavingsGoalsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({savingsContributionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (savingsContributionsRefs) db.savingsContributions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (savingsContributionsRefs)
                    await $_getPrefetchedData<SavingsGoal, $SavingsGoalsTable,
                            SavingsContribution>(
                        currentTable: table,
                        referencedTable: $$SavingsGoalsTableReferences
                            ._savingsContributionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SavingsGoalsTableReferences(db, table, p0)
                                .savingsContributionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.savingsGoalId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SavingsGoalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SavingsGoalsTable,
    SavingsGoal,
    $$SavingsGoalsTableFilterComposer,
    $$SavingsGoalsTableOrderingComposer,
    $$SavingsGoalsTableAnnotationComposer,
    $$SavingsGoalsTableCreateCompanionBuilder,
    $$SavingsGoalsTableUpdateCompanionBuilder,
    (SavingsGoal, $$SavingsGoalsTableReferences),
    SavingsGoal,
    PrefetchHooks Function({bool savingsContributionsRefs})>;
typedef $$SavingsContributionsTableCreateCompanionBuilder
    = SavingsContributionsCompanion Function({
  required String id,
  required String savingsGoalId,
  required double amount,
  required DateTime date,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$SavingsContributionsTableUpdateCompanionBuilder
    = SavingsContributionsCompanion Function({
  Value<String> id,
  Value<String> savingsGoalId,
  Value<double> amount,
  Value<DateTime> date,
  Value<String?> note,
  Value<int> rowid,
});

final class $$SavingsContributionsTableReferences extends BaseReferences<
    _$AppDatabase, $SavingsContributionsTable, SavingsContribution> {
  $$SavingsContributionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SavingsGoalsTable _savingsGoalIdTable(_$AppDatabase db) =>
      db.savingsGoals.createAlias($_aliasNameGenerator(
          db.savingsContributions.savingsGoalId, db.savingsGoals.id));

  $$SavingsGoalsTableProcessedTableManager get savingsGoalId {
    final $_column = $_itemColumn<String>('savings_goal_id')!;

    final manager = $$SavingsGoalsTableTableManager($_db, $_db.savingsGoals)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_savingsGoalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SavingsContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsContributionsTable> {
  $$SavingsContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$SavingsGoalsTableFilterComposer get savingsGoalId {
    final $$SavingsGoalsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.savingsGoalId,
        referencedTable: $db.savingsGoals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavingsGoalsTableFilterComposer(
              $db: $db,
              $table: $db.savingsGoals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavingsContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsContributionsTable> {
  $$SavingsContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$SavingsGoalsTableOrderingComposer get savingsGoalId {
    final $$SavingsGoalsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.savingsGoalId,
        referencedTable: $db.savingsGoals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavingsGoalsTableOrderingComposer(
              $db: $db,
              $table: $db.savingsGoals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavingsContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsContributionsTable> {
  $$SavingsContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$SavingsGoalsTableAnnotationComposer get savingsGoalId {
    final $$SavingsGoalsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.savingsGoalId,
        referencedTable: $db.savingsGoals,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SavingsGoalsTableAnnotationComposer(
              $db: $db,
              $table: $db.savingsGoals,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SavingsContributionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SavingsContributionsTable,
    SavingsContribution,
    $$SavingsContributionsTableFilterComposer,
    $$SavingsContributionsTableOrderingComposer,
    $$SavingsContributionsTableAnnotationComposer,
    $$SavingsContributionsTableCreateCompanionBuilder,
    $$SavingsContributionsTableUpdateCompanionBuilder,
    (SavingsContribution, $$SavingsContributionsTableReferences),
    SavingsContribution,
    PrefetchHooks Function({bool savingsGoalId})> {
  $$SavingsContributionsTableTableManager(
      _$AppDatabase db, $SavingsContributionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsContributionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsContributionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> savingsGoalId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavingsContributionsCompanion(
            id: id,
            savingsGoalId: savingsGoalId,
            amount: amount,
            date: date,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String savingsGoalId,
            required double amount,
            required DateTime date,
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SavingsContributionsCompanion.insert(
            id: id,
            savingsGoalId: savingsGoalId,
            amount: amount,
            date: date,
            note: note,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SavingsContributionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({savingsGoalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (savingsGoalId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.savingsGoalId,
                    referencedTable: $$SavingsContributionsTableReferences
                        ._savingsGoalIdTable(db),
                    referencedColumn: $$SavingsContributionsTableReferences
                        ._savingsGoalIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SavingsContributionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SavingsContributionsTable,
        SavingsContribution,
        $$SavingsContributionsTableFilterComposer,
        $$SavingsContributionsTableOrderingComposer,
        $$SavingsContributionsTableAnnotationComposer,
        $$SavingsContributionsTableCreateCompanionBuilder,
        $$SavingsContributionsTableUpdateCompanionBuilder,
        (SavingsContribution, $$SavingsContributionsTableReferences),
        SavingsContribution,
        PrefetchHooks Function({bool savingsGoalId})>;
typedef $$InvestmentsTableCreateCompanionBuilder = InvestmentsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> description,
  required String type,
  required double initialAmount,
  required double currentValue,
  required double expectedReturnRate,
  required DateTime purchaseDate,
  Value<DateTime?> soldDate,
  Value<double?> soldAmount,
  Value<String> status,
  Value<String?> platformOrBroker,
  Value<String?> notes,
  Value<int> compoundingFrequency,
  Value<String?> iconName,
  Value<String?> color,
  Value<String?> notificationDays,
  Value<int> rowid,
});
typedef $$InvestmentsTableUpdateCompanionBuilder = InvestmentsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String> type,
  Value<double> initialAmount,
  Value<double> currentValue,
  Value<double> expectedReturnRate,
  Value<DateTime> purchaseDate,
  Value<DateTime?> soldDate,
  Value<double?> soldAmount,
  Value<String> status,
  Value<String?> platformOrBroker,
  Value<String?> notes,
  Value<int> compoundingFrequency,
  Value<String?> iconName,
  Value<String?> color,
  Value<String?> notificationDays,
  Value<int> rowid,
});

final class $$InvestmentsTableReferences
    extends BaseReferences<_$AppDatabase, $InvestmentsTable, Investment> {
  $$InvestmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InvestmentValueHistoryTable,
      List<InvestmentValueHistoryData>> _investmentValueHistoryRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.investmentValueHistory,
          aliasName: $_aliasNameGenerator(
              db.investments.id, db.investmentValueHistory.investmentId));

  $$InvestmentValueHistoryTableProcessedTableManager
      get investmentValueHistoryRefs {
    final manager = $$InvestmentValueHistoryTableTableManager(
            $_db, $_db.investmentValueHistory)
        .filter(
            (f) => f.investmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_investmentValueHistoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$InvestmentsTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialAmount => $composableBuilder(
      column: $table.initialAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get expectedReturnRate => $composableBuilder(
      column: $table.expectedReturnRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get soldDate => $composableBuilder(
      column: $table.soldDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get soldAmount => $composableBuilder(
      column: $table.soldAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platformOrBroker => $composableBuilder(
      column: $table.platformOrBroker,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get compoundingFrequency => $composableBuilder(
      column: $table.compoundingFrequency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays,
      builder: (column) => ColumnFilters(column));

  Expression<bool> investmentValueHistoryRefs(
      Expression<bool> Function($$InvestmentValueHistoryTableFilterComposer f)
          f) {
    final $$InvestmentValueHistoryTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.investmentValueHistory,
            getReferencedColumn: (t) => t.investmentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InvestmentValueHistoryTableFilterComposer(
                  $db: $db,
                  $table: $db.investmentValueHistory,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$InvestmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialAmount => $composableBuilder(
      column: $table.initialAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentValue => $composableBuilder(
      column: $table.currentValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get expectedReturnRate => $composableBuilder(
      column: $table.expectedReturnRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get soldDate => $composableBuilder(
      column: $table.soldDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get soldAmount => $composableBuilder(
      column: $table.soldAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platformOrBroker => $composableBuilder(
      column: $table.platformOrBroker,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get compoundingFrequency => $composableBuilder(
      column: $table.compoundingFrequency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays,
      builder: (column) => ColumnOrderings(column));
}

class $$InvestmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentsTable> {
  $$InvestmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get initialAmount => $composableBuilder(
      column: $table.initialAmount, builder: (column) => column);

  GeneratedColumn<double> get currentValue => $composableBuilder(
      column: $table.currentValue, builder: (column) => column);

  GeneratedColumn<double> get expectedReturnRate => $composableBuilder(
      column: $table.expectedReturnRate, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
      column: $table.purchaseDate, builder: (column) => column);

  GeneratedColumn<DateTime> get soldDate =>
      $composableBuilder(column: $table.soldDate, builder: (column) => column);

  GeneratedColumn<double> get soldAmount => $composableBuilder(
      column: $table.soldAmount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get platformOrBroker => $composableBuilder(
      column: $table.platformOrBroker, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get compoundingFrequency => $composableBuilder(
      column: $table.compoundingFrequency, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays, builder: (column) => column);

  Expression<T> investmentValueHistoryRefs<T extends Object>(
      Expression<T> Function($$InvestmentValueHistoryTableAnnotationComposer a)
          f) {
    final $$InvestmentValueHistoryTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.investmentValueHistory,
            getReferencedColumn: (t) => t.investmentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$InvestmentValueHistoryTableAnnotationComposer(
                  $db: $db,
                  $table: $db.investmentValueHistory,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$InvestmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestmentsTable,
    Investment,
    $$InvestmentsTableFilterComposer,
    $$InvestmentsTableOrderingComposer,
    $$InvestmentsTableAnnotationComposer,
    $$InvestmentsTableCreateCompanionBuilder,
    $$InvestmentsTableUpdateCompanionBuilder,
    (Investment, $$InvestmentsTableReferences),
    Investment,
    PrefetchHooks Function({bool investmentValueHistoryRefs})> {
  $$InvestmentsTableTableManager(_$AppDatabase db, $InvestmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> initialAmount = const Value.absent(),
            Value<double> currentValue = const Value.absent(),
            Value<double> expectedReturnRate = const Value.absent(),
            Value<DateTime> purchaseDate = const Value.absent(),
            Value<DateTime?> soldDate = const Value.absent(),
            Value<double?> soldAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> platformOrBroker = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> compoundingFrequency = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> notificationDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentsCompanion(
            id: id,
            name: name,
            description: description,
            type: type,
            initialAmount: initialAmount,
            currentValue: currentValue,
            expectedReturnRate: expectedReturnRate,
            purchaseDate: purchaseDate,
            soldDate: soldDate,
            soldAmount: soldAmount,
            status: status,
            platformOrBroker: platformOrBroker,
            notes: notes,
            compoundingFrequency: compoundingFrequency,
            iconName: iconName,
            color: color,
            notificationDays: notificationDays,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            required String type,
            required double initialAmount,
            required double currentValue,
            required double expectedReturnRate,
            required DateTime purchaseDate,
            Value<DateTime?> soldDate = const Value.absent(),
            Value<double?> soldAmount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> platformOrBroker = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> compoundingFrequency = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> notificationDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentsCompanion.insert(
            id: id,
            name: name,
            description: description,
            type: type,
            initialAmount: initialAmount,
            currentValue: currentValue,
            expectedReturnRate: expectedReturnRate,
            purchaseDate: purchaseDate,
            soldDate: soldDate,
            soldAmount: soldAmount,
            status: status,
            platformOrBroker: platformOrBroker,
            notes: notes,
            compoundingFrequency: compoundingFrequency,
            iconName: iconName,
            color: color,
            notificationDays: notificationDays,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InvestmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({investmentValueHistoryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (investmentValueHistoryRefs) db.investmentValueHistory
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (investmentValueHistoryRefs)
                    await $_getPrefetchedData<Investment, $InvestmentsTable,
                            InvestmentValueHistoryData>(
                        currentTable: table,
                        referencedTable: $$InvestmentsTableReferences
                            ._investmentValueHistoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$InvestmentsTableReferences(db, table, p0)
                                .investmentValueHistoryRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.investmentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$InvestmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InvestmentsTable,
    Investment,
    $$InvestmentsTableFilterComposer,
    $$InvestmentsTableOrderingComposer,
    $$InvestmentsTableAnnotationComposer,
    $$InvestmentsTableCreateCompanionBuilder,
    $$InvestmentsTableUpdateCompanionBuilder,
    (Investment, $$InvestmentsTableReferences),
    Investment,
    PrefetchHooks Function({bool investmentValueHistoryRefs})>;
typedef $$InvestmentValueHistoryTableCreateCompanionBuilder
    = InvestmentValueHistoryCompanion Function({
  required String id,
  required String investmentId,
  required double value,
  required DateTime date,
  Value<int> rowid,
});
typedef $$InvestmentValueHistoryTableUpdateCompanionBuilder
    = InvestmentValueHistoryCompanion Function({
  Value<String> id,
  Value<String> investmentId,
  Value<double> value,
  Value<DateTime> date,
  Value<int> rowid,
});

final class $$InvestmentValueHistoryTableReferences extends BaseReferences<
    _$AppDatabase, $InvestmentValueHistoryTable, InvestmentValueHistoryData> {
  $$InvestmentValueHistoryTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $InvestmentsTable _investmentIdTable(_$AppDatabase db) =>
      db.investments.createAlias($_aliasNameGenerator(
          db.investmentValueHistory.investmentId, db.investments.id));

  $$InvestmentsTableProcessedTableManager get investmentId {
    final $_column = $_itemColumn<String>('investment_id')!;

    final manager = $$InvestmentsTableTableManager($_db, $_db.investments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_investmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InvestmentValueHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $InvestmentValueHistoryTable> {
  $$InvestmentValueHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  $$InvestmentsTableFilterComposer get investmentId {
    final $$InvestmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.investmentId,
        referencedTable: $db.investments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestmentsTableFilterComposer(
              $db: $db,
              $table: $db.investments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvestmentValueHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $InvestmentValueHistoryTable> {
  $$InvestmentValueHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  $$InvestmentsTableOrderingComposer get investmentId {
    final $$InvestmentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.investmentId,
        referencedTable: $db.investments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestmentsTableOrderingComposer(
              $db: $db,
              $table: $db.investments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvestmentValueHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvestmentValueHistoryTable> {
  $$InvestmentValueHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$InvestmentsTableAnnotationComposer get investmentId {
    final $$InvestmentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.investmentId,
        referencedTable: $db.investments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InvestmentsTableAnnotationComposer(
              $db: $db,
              $table: $db.investments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InvestmentValueHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvestmentValueHistoryTable,
    InvestmentValueHistoryData,
    $$InvestmentValueHistoryTableFilterComposer,
    $$InvestmentValueHistoryTableOrderingComposer,
    $$InvestmentValueHistoryTableAnnotationComposer,
    $$InvestmentValueHistoryTableCreateCompanionBuilder,
    $$InvestmentValueHistoryTableUpdateCompanionBuilder,
    (InvestmentValueHistoryData, $$InvestmentValueHistoryTableReferences),
    InvestmentValueHistoryData,
    PrefetchHooks Function({bool investmentId})> {
  $$InvestmentValueHistoryTableTableManager(
      _$AppDatabase db, $InvestmentValueHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvestmentValueHistoryTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$InvestmentValueHistoryTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvestmentValueHistoryTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> investmentId = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentValueHistoryCompanion(
            id: id,
            investmentId: investmentId,
            value: value,
            date: date,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String investmentId,
            required double value,
            required DateTime date,
            Value<int> rowid = const Value.absent(),
          }) =>
              InvestmentValueHistoryCompanion.insert(
            id: id,
            investmentId: investmentId,
            value: value,
            date: date,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InvestmentValueHistoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({investmentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (investmentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.investmentId,
                    referencedTable: $$InvestmentValueHistoryTableReferences
                        ._investmentIdTable(db),
                    referencedColumn: $$InvestmentValueHistoryTableReferences
                        ._investmentIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InvestmentValueHistoryTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $InvestmentValueHistoryTable,
        InvestmentValueHistoryData,
        $$InvestmentValueHistoryTableFilterComposer,
        $$InvestmentValueHistoryTableOrderingComposer,
        $$InvestmentValueHistoryTableAnnotationComposer,
        $$InvestmentValueHistoryTableCreateCompanionBuilder,
        $$InvestmentValueHistoryTableUpdateCompanionBuilder,
        (InvestmentValueHistoryData, $$InvestmentValueHistoryTableReferences),
        InvestmentValueHistoryData,
        PrefetchHooks Function({bool investmentId})>;
typedef $$LoansTableCreateCompanionBuilder = LoansCompanion Function({
  required String id,
  required String name,
  Value<String?> borrowerOrLender,
  required String type,
  required double principalAmount,
  required double interestRate,
  required int totalInstallments,
  required double installmentAmount,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<String> paymentFrequency,
  Value<String> status,
  Value<String?> notes,
  Value<double> paidAmount,
  Value<int> paidInstallments,
  Value<String?> iconName,
  Value<String?> color,
  Value<String?> notificationDays,
  Value<int> rowid,
});
typedef $$LoansTableUpdateCompanionBuilder = LoansCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> borrowerOrLender,
  Value<String> type,
  Value<double> principalAmount,
  Value<double> interestRate,
  Value<int> totalInstallments,
  Value<double> installmentAmount,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String> paymentFrequency,
  Value<String> status,
  Value<String?> notes,
  Value<double> paidAmount,
  Value<int> paidInstallments,
  Value<String?> iconName,
  Value<String?> color,
  Value<String?> notificationDays,
  Value<int> rowid,
});

final class $$LoansTableReferences
    extends BaseReferences<_$AppDatabase, $LoansTable, Loan> {
  $$LoansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LoanPaymentsTable, List<LoanPayment>>
      _loanPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.loanPayments,
          aliasName: $_aliasNameGenerator(db.loans.id, db.loanPayments.loanId));

  $$LoanPaymentsTableProcessedTableManager get loanPaymentsRefs {
    final manager = $$LoanPaymentsTableTableManager($_db, $_db.loanPayments)
        .filter((f) => f.loanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_loanPaymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LoansTableFilterComposer extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get borrowerOrLender => $composableBuilder(
      column: $table.borrowerOrLender,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get principalAmount => $composableBuilder(
      column: $table.principalAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalInstallments => $composableBuilder(
      column: $table.totalInstallments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentFrequency => $composableBuilder(
      column: $table.paymentFrequency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays,
      builder: (column) => ColumnFilters(column));

  Expression<bool> loanPaymentsRefs(
      Expression<bool> Function($$LoanPaymentsTableFilterComposer f) f) {
    final $$LoanPaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loanPayments,
        getReferencedColumn: (t) => t.loanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoanPaymentsTableFilterComposer(
              $db: $db,
              $table: $db.loanPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LoansTableOrderingComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get borrowerOrLender => $composableBuilder(
      column: $table.borrowerOrLender,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get principalAmount => $composableBuilder(
      column: $table.principalAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get interestRate => $composableBuilder(
      column: $table.interestRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalInstallments => $composableBuilder(
      column: $table.totalInstallments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentFrequency => $composableBuilder(
      column: $table.paymentFrequency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays,
      builder: (column) => ColumnOrderings(column));
}

class $$LoansTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoansTable> {
  $$LoansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get borrowerOrLender => $composableBuilder(
      column: $table.borrowerOrLender, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get principalAmount => $composableBuilder(
      column: $table.principalAmount, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
      column: $table.interestRate, builder: (column) => column);

  GeneratedColumn<int> get totalInstallments => $composableBuilder(
      column: $table.totalInstallments, builder: (column) => column);

  GeneratedColumn<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get paymentFrequency => $composableBuilder(
      column: $table.paymentFrequency, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get paidAmount => $composableBuilder(
      column: $table.paidAmount, builder: (column) => column);

  GeneratedColumn<int> get paidInstallments => $composableBuilder(
      column: $table.paidInstallments, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get notificationDays => $composableBuilder(
      column: $table.notificationDays, builder: (column) => column);

  Expression<T> loanPaymentsRefs<T extends Object>(
      Expression<T> Function($$LoanPaymentsTableAnnotationComposer a) f) {
    final $$LoanPaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.loanPayments,
        getReferencedColumn: (t) => t.loanId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoanPaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.loanPayments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LoansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoansTable,
    Loan,
    $$LoansTableFilterComposer,
    $$LoansTableOrderingComposer,
    $$LoansTableAnnotationComposer,
    $$LoansTableCreateCompanionBuilder,
    $$LoansTableUpdateCompanionBuilder,
    (Loan, $$LoansTableReferences),
    Loan,
    PrefetchHooks Function({bool loanPaymentsRefs})> {
  $$LoansTableTableManager(_$AppDatabase db, $LoansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> borrowerOrLender = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> principalAmount = const Value.absent(),
            Value<double> interestRate = const Value.absent(),
            Value<int> totalInstallments = const Value.absent(),
            Value<double> installmentAmount = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String> paymentFrequency = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<int> paidInstallments = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> notificationDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoansCompanion(
            id: id,
            name: name,
            borrowerOrLender: borrowerOrLender,
            type: type,
            principalAmount: principalAmount,
            interestRate: interestRate,
            totalInstallments: totalInstallments,
            installmentAmount: installmentAmount,
            startDate: startDate,
            endDate: endDate,
            paymentFrequency: paymentFrequency,
            status: status,
            notes: notes,
            paidAmount: paidAmount,
            paidInstallments: paidInstallments,
            iconName: iconName,
            color: color,
            notificationDays: notificationDays,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> borrowerOrLender = const Value.absent(),
            required String type,
            required double principalAmount,
            required double interestRate,
            required int totalInstallments,
            required double installmentAmount,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<String> paymentFrequency = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<double> paidAmount = const Value.absent(),
            Value<int> paidInstallments = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> notificationDays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoansCompanion.insert(
            id: id,
            name: name,
            borrowerOrLender: borrowerOrLender,
            type: type,
            principalAmount: principalAmount,
            interestRate: interestRate,
            totalInstallments: totalInstallments,
            installmentAmount: installmentAmount,
            startDate: startDate,
            endDate: endDate,
            paymentFrequency: paymentFrequency,
            status: status,
            notes: notes,
            paidAmount: paidAmount,
            paidInstallments: paidInstallments,
            iconName: iconName,
            color: color,
            notificationDays: notificationDays,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$LoansTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({loanPaymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (loanPaymentsRefs) db.loanPayments],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loanPaymentsRefs)
                    await $_getPrefetchedData<Loan, $LoansTable, LoanPayment>(
                        currentTable: table,
                        referencedTable:
                            $$LoansTableReferences._loanPaymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LoansTableReferences(db, table, p0)
                                .loanPaymentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.loanId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LoansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoansTable,
    Loan,
    $$LoansTableFilterComposer,
    $$LoansTableOrderingComposer,
    $$LoansTableAnnotationComposer,
    $$LoansTableCreateCompanionBuilder,
    $$LoansTableUpdateCompanionBuilder,
    (Loan, $$LoansTableReferences),
    Loan,
    PrefetchHooks Function({bool loanPaymentsRefs})>;
typedef $$LoanPaymentsTableCreateCompanionBuilder = LoanPaymentsCompanion
    Function({
  required String id,
  required String loanId,
  required double amount,
  required DateTime date,
  required int installmentNumber,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$LoanPaymentsTableUpdateCompanionBuilder = LoanPaymentsCompanion
    Function({
  Value<String> id,
  Value<String> loanId,
  Value<double> amount,
  Value<DateTime> date,
  Value<int> installmentNumber,
  Value<String?> notes,
  Value<int> rowid,
});

final class $$LoanPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $LoanPaymentsTable, LoanPayment> {
  $$LoanPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LoansTable _loanIdTable(_$AppDatabase db) => db.loans
      .createAlias($_aliasNameGenerator(db.loanPayments.loanId, db.loans.id));

  $$LoansTableProcessedTableManager get loanId {
    final $_column = $_itemColumn<String>('loan_id')!;

    final manager = $$LoansTableTableManager($_db, $_db.loans)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LoanPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get installmentNumber => $composableBuilder(
      column: $table.installmentNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$LoansTableFilterComposer get loanId {
    final $$LoansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.loanId,
        referencedTable: $db.loans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoansTableFilterComposer(
              $db: $db,
              $table: $db.loans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoanPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get installmentNumber => $composableBuilder(
      column: $table.installmentNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$LoansTableOrderingComposer get loanId {
    final $$LoansTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.loanId,
        referencedTable: $db.loans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoansTableOrderingComposer(
              $db: $db,
              $table: $db.loans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoanPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoanPaymentsTable> {
  $$LoanPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get installmentNumber => $composableBuilder(
      column: $table.installmentNumber, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$LoansTableAnnotationComposer get loanId {
    final $$LoansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.loanId,
        referencedTable: $db.loans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LoansTableAnnotationComposer(
              $db: $db,
              $table: $db.loans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LoanPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LoanPaymentsTable,
    LoanPayment,
    $$LoanPaymentsTableFilterComposer,
    $$LoanPaymentsTableOrderingComposer,
    $$LoanPaymentsTableAnnotationComposer,
    $$LoanPaymentsTableCreateCompanionBuilder,
    $$LoanPaymentsTableUpdateCompanionBuilder,
    (LoanPayment, $$LoanPaymentsTableReferences),
    LoanPayment,
    PrefetchHooks Function({bool loanId})> {
  $$LoanPaymentsTableTableManager(_$AppDatabase db, $LoanPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoanPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoanPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoanPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> loanId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> installmentNumber = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoanPaymentsCompanion(
            id: id,
            loanId: loanId,
            amount: amount,
            date: date,
            installmentNumber: installmentNumber,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String loanId,
            required double amount,
            required DateTime date,
            required int installmentNumber,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LoanPaymentsCompanion.insert(
            id: id,
            loanId: loanId,
            amount: amount,
            date: date,
            installmentNumber: installmentNumber,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$LoanPaymentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({loanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (loanId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.loanId,
                    referencedTable:
                        $$LoanPaymentsTableReferences._loanIdTable(db),
                    referencedColumn:
                        $$LoanPaymentsTableReferences._loanIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LoanPaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LoanPaymentsTable,
    LoanPayment,
    $$LoanPaymentsTableFilterComposer,
    $$LoanPaymentsTableOrderingComposer,
    $$LoanPaymentsTableAnnotationComposer,
    $$LoanPaymentsTableCreateCompanionBuilder,
    $$LoanPaymentsTableUpdateCompanionBuilder,
    (LoanPayment, $$LoanPaymentsTableReferences),
    LoanPayment,
    PrefetchHooks Function({bool loanId})>;
typedef $$UserSettingsTableTableCreateCompanionBuilder
    = UserSettingsTableCompanion Function({
  required String id,
  Value<int> monthStartDay,
  Value<String> currency,
  Value<String> currencySymbol,
  Value<String> thousandsSeparator,
  Value<String> decimalSeparator,
  Value<bool> notificationsEnabled,
  Value<bool> budgetAlertsEnabled,
  Value<bool> loanRemindersEnabled,
  Value<bool> savingsRemindersEnabled,
  Value<bool> notificationPermissionAsked,
  Value<String?> theme,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$UserSettingsTableTableUpdateCompanionBuilder
    = UserSettingsTableCompanion Function({
  Value<String> id,
  Value<int> monthStartDay,
  Value<String> currency,
  Value<String> currencySymbol,
  Value<String> thousandsSeparator,
  Value<String> decimalSeparator,
  Value<bool> notificationsEnabled,
  Value<bool> budgetAlertsEnabled,
  Value<bool> loanRemindersEnabled,
  Value<bool> savingsRemindersEnabled,
  Value<bool> notificationPermissionAsked,
  Value<String?> theme,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get monthStartDay => $composableBuilder(
      column: $table.monthStartDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get thousandsSeparator => $composableBuilder(
      column: $table.thousandsSeparator,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get decimalSeparator => $composableBuilder(
      column: $table.decimalSeparator,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get budgetAlertsEnabled => $composableBuilder(
      column: $table.budgetAlertsEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get loanRemindersEnabled => $composableBuilder(
      column: $table.loanRemindersEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get savingsRemindersEnabled => $composableBuilder(
      column: $table.savingsRemindersEnabled,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationPermissionAsked => $composableBuilder(
      column: $table.notificationPermissionAsked,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get monthStartDay => $composableBuilder(
      column: $table.monthStartDay,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get thousandsSeparator => $composableBuilder(
      column: $table.thousandsSeparator,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get decimalSeparator => $composableBuilder(
      column: $table.decimalSeparator,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get budgetAlertsEnabled => $composableBuilder(
      column: $table.budgetAlertsEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get loanRemindersEnabled => $composableBuilder(
      column: $table.loanRemindersEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get savingsRemindersEnabled => $composableBuilder(
      column: $table.savingsRemindersEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationPermissionAsked => $composableBuilder(
      column: $table.notificationPermissionAsked,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get theme => $composableBuilder(
      column: $table.theme, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get monthStartDay => $composableBuilder(
      column: $table.monthStartDay, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
      column: $table.currencySymbol, builder: (column) => column);

  GeneratedColumn<String> get thousandsSeparator => $composableBuilder(
      column: $table.thousandsSeparator, builder: (column) => column);

  GeneratedColumn<String> get decimalSeparator => $composableBuilder(
      column: $table.decimalSeparator, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  GeneratedColumn<bool> get budgetAlertsEnabled => $composableBuilder(
      column: $table.budgetAlertsEnabled, builder: (column) => column);

  GeneratedColumn<bool> get loanRemindersEnabled => $composableBuilder(
      column: $table.loanRemindersEnabled, builder: (column) => column);

  GeneratedColumn<bool> get savingsRemindersEnabled => $composableBuilder(
      column: $table.savingsRemindersEnabled, builder: (column) => column);

  GeneratedColumn<bool> get notificationPermissionAsked => $composableBuilder(
      column: $table.notificationPermissionAsked, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserSettingsTableTable,
    UserSettingsTableData,
    $$UserSettingsTableTableFilterComposer,
    $$UserSettingsTableTableOrderingComposer,
    $$UserSettingsTableTableAnnotationComposer,
    $$UserSettingsTableTableCreateCompanionBuilder,
    $$UserSettingsTableTableUpdateCompanionBuilder,
    (
      UserSettingsTableData,
      BaseReferences<_$AppDatabase, $UserSettingsTableTable,
          UserSettingsTableData>
    ),
    UserSettingsTableData,
    PrefetchHooks Function()> {
  $$UserSettingsTableTableTableManager(
      _$AppDatabase db, $UserSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> monthStartDay = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> currencySymbol = const Value.absent(),
            Value<String> thousandsSeparator = const Value.absent(),
            Value<String> decimalSeparator = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<bool> budgetAlertsEnabled = const Value.absent(),
            Value<bool> loanRemindersEnabled = const Value.absent(),
            Value<bool> savingsRemindersEnabled = const Value.absent(),
            Value<bool> notificationPermissionAsked = const Value.absent(),
            Value<String?> theme = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsTableCompanion(
            id: id,
            monthStartDay: monthStartDay,
            currency: currency,
            currencySymbol: currencySymbol,
            thousandsSeparator: thousandsSeparator,
            decimalSeparator: decimalSeparator,
            notificationsEnabled: notificationsEnabled,
            budgetAlertsEnabled: budgetAlertsEnabled,
            loanRemindersEnabled: loanRemindersEnabled,
            savingsRemindersEnabled: savingsRemindersEnabled,
            notificationPermissionAsked: notificationPermissionAsked,
            theme: theme,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<int> monthStartDay = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> currencySymbol = const Value.absent(),
            Value<String> thousandsSeparator = const Value.absent(),
            Value<String> decimalSeparator = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
            Value<bool> budgetAlertsEnabled = const Value.absent(),
            Value<bool> loanRemindersEnabled = const Value.absent(),
            Value<bool> savingsRemindersEnabled = const Value.absent(),
            Value<bool> notificationPermissionAsked = const Value.absent(),
            Value<String?> theme = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserSettingsTableCompanion.insert(
            id: id,
            monthStartDay: monthStartDay,
            currency: currency,
            currencySymbol: currencySymbol,
            thousandsSeparator: thousandsSeparator,
            decimalSeparator: decimalSeparator,
            notificationsEnabled: notificationsEnabled,
            budgetAlertsEnabled: budgetAlertsEnabled,
            loanRemindersEnabled: loanRemindersEnabled,
            savingsRemindersEnabled: savingsRemindersEnabled,
            notificationPermissionAsked: notificationPermissionAsked,
            theme: theme,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserSettingsTableTable,
    UserSettingsTableData,
    $$UserSettingsTableTableFilterComposer,
    $$UserSettingsTableTableOrderingComposer,
    $$UserSettingsTableTableAnnotationComposer,
    $$UserSettingsTableTableCreateCompanionBuilder,
    $$UserSettingsTableTableUpdateCompanionBuilder,
    (
      UserSettingsTableData,
      BaseReferences<_$AppDatabase, $UserSettingsTableTable,
          UserSettingsTableData>
    ),
    UserSettingsTableData,
    PrefetchHooks Function()>;
typedef $$RecurringTransactionsTableCreateCompanionBuilder
    = RecurringTransactionsCompanion Function({
  required String id,
  required String title,
  required double amount,
  required String type,
  required String category,
  Value<String?> source,
  required String frequency,
  Value<int?> dayOfMonth,
  Value<int?> dayOfWeek,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<DateTime?> lastProcessedDate,
  Value<bool> isActive,
  Value<String?> description,
  Value<int> rowid,
});
typedef $$RecurringTransactionsTableUpdateCompanionBuilder
    = RecurringTransactionsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<double> amount,
  Value<String> type,
  Value<String> category,
  Value<String?> source,
  Value<String> frequency,
  Value<int?> dayOfMonth,
  Value<int?> dayOfWeek,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<DateTime?> lastProcessedDate,
  Value<bool> isActive,
  Value<String?> description,
  Value<int> rowid,
});

class $$RecurringTransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
      column: $table.dayOfWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastProcessedDate => $composableBuilder(
      column: $table.lastProcessedDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));
}

class $$RecurringTransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
      column: $table.dayOfWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastProcessedDate => $composableBuilder(
      column: $table.lastProcessedDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));
}

class $$RecurringTransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTable> {
  $$RecurringTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastProcessedDate => $composableBuilder(
      column: $table.lastProcessedDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);
}

class $$RecurringTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecurringTransactionsTable,
    RecurringTransaction,
    $$RecurringTransactionsTableFilterComposer,
    $$RecurringTransactionsTableOrderingComposer,
    $$RecurringTransactionsTableAnnotationComposer,
    $$RecurringTransactionsTableCreateCompanionBuilder,
    $$RecurringTransactionsTableUpdateCompanionBuilder,
    (
      RecurringTransaction,
      BaseReferences<_$AppDatabase, $RecurringTransactionsTable,
          RecurringTransaction>
    ),
    RecurringTransaction,
    PrefetchHooks Function()> {
  $$RecurringTransactionsTableTableManager(
      _$AppDatabase db, $RecurringTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransactionsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<int?> dayOfMonth = const Value.absent(),
            Value<int?> dayOfWeek = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime?> lastProcessedDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringTransactionsCompanion(
            id: id,
            title: title,
            amount: amount,
            type: type,
            category: category,
            source: source,
            frequency: frequency,
            dayOfMonth: dayOfMonth,
            dayOfWeek: dayOfWeek,
            startDate: startDate,
            endDate: endDate,
            lastProcessedDate: lastProcessedDate,
            isActive: isActive,
            description: description,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required double amount,
            required String type,
            required String category,
            Value<String?> source = const Value.absent(),
            required String frequency,
            Value<int?> dayOfMonth = const Value.absent(),
            Value<int?> dayOfWeek = const Value.absent(),
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime?> lastProcessedDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecurringTransactionsCompanion.insert(
            id: id,
            title: title,
            amount: amount,
            type: type,
            category: category,
            source: source,
            frequency: frequency,
            dayOfMonth: dayOfMonth,
            dayOfWeek: dayOfWeek,
            startDate: startDate,
            endDate: endDate,
            lastProcessedDate: lastProcessedDate,
            isActive: isActive,
            description: description,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecurringTransactionsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $RecurringTransactionsTable,
        RecurringTransaction,
        $$RecurringTransactionsTableFilterComposer,
        $$RecurringTransactionsTableOrderingComposer,
        $$RecurringTransactionsTableAnnotationComposer,
        $$RecurringTransactionsTableCreateCompanionBuilder,
        $$RecurringTransactionsTableUpdateCompanionBuilder,
        (
          RecurringTransaction,
          BaseReferences<_$AppDatabase, $RecurringTransactionsTable,
              RecurringTransaction>
        ),
        RecurringTransaction,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
  $$CustomCategoriesTableTableManager get customCategories =>
      $$CustomCategoriesTableTableManager(_db, _db.customCategories);
  $$CustomIncomeSourcesTableTableManager get customIncomeSources =>
      $$CustomIncomeSourcesTableTableManager(_db, _db.customIncomeSources);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$SavingsContributionsTableTableManager get savingsContributions =>
      $$SavingsContributionsTableTableManager(_db, _db.savingsContributions);
  $$InvestmentsTableTableManager get investments =>
      $$InvestmentsTableTableManager(_db, _db.investments);
  $$InvestmentValueHistoryTableTableManager get investmentValueHistory =>
      $$InvestmentValueHistoryTableTableManager(
          _db, _db.investmentValueHistory);
  $$LoansTableTableManager get loans =>
      $$LoansTableTableManager(_db, _db.loans);
  $$LoanPaymentsTableTableManager get loanPayments =>
      $$LoanPaymentsTableTableManager(_db, _db.loanPayments);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(_db, _db.recurringTransactions);
}
