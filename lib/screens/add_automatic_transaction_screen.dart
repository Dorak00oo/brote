import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../database/app_database.dart' as db;
import '../models/loan.dart';
import '../main.dart';

class AddAutomaticTransactionScreen extends StatefulWidget {
  final db.RecurringTransaction? automatic;

  const AddAutomaticTransactionScreen({
    super.key,
    this.automatic,
  });

  @override
  State<AddAutomaticTransactionScreen> createState() =>
      _AddAutomaticTransactionScreenState();
}

class _AddAutomaticTransactionScreenState
    extends State<AddAutomaticTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountFocusNode = FocusNode();

  late bool _isIncome;
  String? _selectedCategory;
  String? _selectedSource;
  String _frequency = 'monthly';
  int? _dayOfMonth;
  int? _dayOfWeek;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  bool _notificationsEnabled = false;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;
  
  // Opciones opcionales de vinculación
  String? _selectedFinanceModule; // 'loan' o 'savings'
  String? _selectedLoanId; // Para vincular a préstamo
  String? _selectedSavingsGoalId; // Para vincular a meta de ahorro

  @override
  void initState() {
    super.initState();
    if (widget.automatic != null) {
      final a = widget.automatic!;
      _titleController.text = a.title;
      _amountController.text = a.amount.toString();
      _descriptionController.text = a.description ?? '';
      _isIncome = a.type == 'income';
      _selectedCategory = a.category;
      _selectedSource = a.source;
      _frequency = a.frequency;
      _dayOfMonth = a.dayOfMonth;
      _dayOfWeek = a.dayOfWeek;
      _startDate = a.startDate;
      _endDate = a.endDate;
      _notificationsEnabled = a.notificationsEnabled;
      if (a.notificationHour != null && a.notificationMinute != null) {
        _notificationTime = TimeOfDay(
          hour: a.notificationHour!,
          minute: a.notificationMinute!,
        );
      }
      _selectedFinanceModule = a.linkedFinanceModule;
      _selectedLoanId = a.linkedLoanId;
      _selectedSavingsGoalId = a.linkedSavingsGoalId;
    } else {
      _isIncome = true;
      _dayOfMonth = DateTime.now().day;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.read<FinanceService>();
    final isEditing = widget.automatic != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar automático' : 'Nuevo automático'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _deleteAutomatic(context, service),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Tipo de transacción
            _buildTypeSelector(),
            const SizedBox(height: 24),

            // Monto
            _buildAmountField(service),
            const SizedBox(height: 20),

            // Título
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                prefixIcon: const Icon(Icons.edit_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa un título';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Categoría o Fuente
            _isIncome
                ? _buildSourceDropdown(service)
                : _buildCategoryDropdown(service),
            const SizedBox(height: 16),

            // Frecuencia
            _buildFrequencySelector(),
            const SizedBox(height: 16),

            // Día específico según frecuencia
            if (_frequency == 'monthly') _buildDayOfMonthSelector(),
            if (_frequency == 'weekly') _buildDayOfWeekSelector(),
            if (_frequency == 'monthly' || _frequency == 'weekly')
              const SizedBox(height: 16),

            // Fecha de inicio
            _buildDateField('Fecha de inicio', _startDate, (date) {
              setState(() => _startDate = date);
            }),
            const SizedBox(height: 16),

            // Fecha de fin (opcional)
            _buildDateField(
              'Fecha de fin (opcional)',
              _endDate,
              (date) {
                setState(() => _endDate = date);
              },
              isOptional: true,
            ),
            const SizedBox(height: 16),

            // Descripción
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción (opcional)',
                prefixIcon: const Icon(Icons.description_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Vincular a finanzas
            _buildFinanceModuleSelector(service),
            if (_selectedFinanceModule == 'loan') ...[
              const SizedBox(height: 16),
              _buildLoanDropdown(service, isDebt: !_isIncome),
            ] else if (_selectedFinanceModule == 'savings') ...[
              const SizedBox(height: 16),
              _buildSavingsGoalDropdown(service),
            ],
            const SizedBox(height: 24),

            // Notificaciones
            _buildNotificationSection(),
            const SizedBox(height: 32),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _saveAutomatic(service),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(isEditing ? 'Guardar cambios' : 'Crear automático'),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _isIncome = true;
              _selectedSource = null;
              // Limpiar vinculación cuando cambia el tipo
              _selectedFinanceModule = null;
              _selectedLoanId = null;
              _selectedSavingsGoalId = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _isIncome
                    ? (isDark
                        ? Theme.of(context).colorScheme.surface
                        : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: _isIncome
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_downward_rounded,
                    color: _isIncome
                        ? Theme.of(context).colorScheme.income
                        : (isDark ? Colors.grey[400] : Colors.grey),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ingreso',
                    style: TextStyle(
                      color: _isIncome
                          ? Theme.of(context).colorScheme.income
                          : (isDark ? Colors.grey[400] : Colors.grey),
                      fontWeight:
                          _isIncome ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _isIncome = false;
              _selectedCategory = null;
              // Limpiar vinculación cuando cambia el tipo
              _selectedFinanceModule = null;
              _selectedLoanId = null;
              _selectedSavingsGoalId = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: !_isIncome
                    ? (isDark
                        ? Theme.of(context).colorScheme.surface
                        : Colors.white)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: !_isIncome
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_upward_rounded,
                    color: !_isIncome
                        ? Theme.of(context).colorScheme.expense
                        : (isDark ? Colors.grey[400] : Colors.grey),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Gasto',
                    style: TextStyle(
                      color: !_isIncome
                          ? Theme.of(context).colorScheme.expense
                          : (isDark ? Colors.grey[400] : Colors.grey),
                      fontWeight:
                          !_isIncome ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField(FinanceService service) {
    final color = _isIncome
        ? Theme.of(context).colorScheme.income
        : Theme.of(context).colorScheme.expense;

    String formattedAmount = '0';
    final rawText = _amountController.text.replaceAll(RegExp(r'[^\d.]'), '');
    if (rawText.isNotEmpty) {
      final amount = double.tryParse(rawText);
      if (amount != null) {
        formattedAmount = service.formatNumber(amount, decimals: 0);
        if (rawText.contains('.')) {
          final parts = rawText.split('.');
          final decimalPart = parts.length > 1 ? parts[1] : '';
          formattedAmount = service.userSettings.formatNumber(
            double.tryParse(parts[0]) ?? 0,
            decimals: 0,
          );
          if (decimalPart.isNotEmpty || rawText.endsWith('.')) {
            formattedAmount +=
                service.userSettings.decimalSeparator + decimalPart;
          }
        }
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_amountFocusNode);
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              _isIncome ? 'Ingreso' : 'Gasto',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final length = formattedAmount.length;
                double fontSize = 48;
                if (length > 10) fontSize = 36;
                if (length > 13) fontSize = 28;
                if (length > 16) fontSize = 22;

                return SizedBox(
                  width: constraints.maxWidth,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          service.userSettings.currencySymbol,
                          style: TextStyle(
                            fontSize: fontSize * 0.6,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          formattedAmount,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: _amountController.text.isEmpty
                                ? color.withOpacity(0.3)
                                : color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Input oculto (funcional pero invisible)
            SizedBox(
              height: 0,
              child: Opacity(
                opacity: 0,
                child: TextFormField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa el monto';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Monto inválido';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(FinanceService service) {
    final categories = service.allExpenseCategories;
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Categoría',
        prefixIcon: const Icon(Icons.category_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: categories.map((cat) {
        return DropdownMenuItem(
          value: cat,
          child: Text(cat),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (value) {
        if (value == null) {
          return 'Selecciona una categoría';
        }
        return null;
      },
    );
  }

  Widget _buildSourceDropdown(FinanceService service) {
    final sources = service.allIncomeSources;
    return DropdownButtonFormField<String>(
      value: _selectedSource,
      decoration: InputDecoration(
        labelText: 'Fuente de ingreso',
        prefixIcon: const Icon(Icons.account_balance_wallet_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: sources.map((source) {
        return DropdownMenuItem(
          value: source,
          child: Text(source),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedSource = value),
      validator: (value) {
        if (value == null) {
          return 'Selecciona una fuente de ingreso';
        }
        return null;
      },
    );
  }

  Widget _buildFrequencySelector() {
    final frequencies = [
      {'value': 'weekly', 'label': 'Semanal'},
      {'value': 'biweekly', 'label': 'Quincenal'},
      {'value': 'monthly', 'label': 'Mensual'},
      {'value': 'quarterly', 'label': 'Trimestral'},
      {'value': 'yearly', 'label': 'Anual'},
    ];

    return DropdownButtonFormField<String>(
      value: _frequency,
      decoration: InputDecoration(
        labelText: 'Frecuencia',
        prefixIcon: const Icon(Icons.repeat_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: frequencies.map((freq) {
        return DropdownMenuItem(
          value: freq['value'],
          child: Text(freq['label']!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _frequency = value!;
          if (_frequency == 'monthly' && _dayOfMonth == null) {
            _dayOfMonth = DateTime.now().day;
          }
          if (_frequency == 'weekly' && _dayOfWeek == null) {
            _dayOfWeek = DateTime.now().weekday;
          }
        });
      },
    );
  }

  Widget _buildDayOfMonthSelector() {
    return DropdownButtonFormField<int>(
      value: _dayOfMonth,
      decoration: InputDecoration(
        labelText: 'Día del mes',
        prefixIcon: const Icon(Icons.calendar_today_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: List.generate(28, (index) {
        final day = index + 1;
        return DropdownMenuItem(
          value: day,
          child: Text('Día $day'),
        );
      }),
      onChanged: (value) => setState(() => _dayOfMonth = value),
    );
  }

  Widget _buildDayOfWeekSelector() {
    final days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];

    return DropdownButtonFormField<int>(
      value: _dayOfWeek,
      decoration: InputDecoration(
        labelText: 'Día de la semana',
        prefixIcon: const Icon(Icons.calendar_view_week_rounded),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: List.generate(7, (index) {
        final day = index + 1;
        return DropdownMenuItem(
          value: day,
          child: Text(days[index]),
        );
      }),
      onChanged: (value) => setState(() => _dayOfWeek = value),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? date,
    Function(DateTime) onDateSelected, {
    bool isOptional = false,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          locale: const Locale('es', 'ES'),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          date != null
              ? DateFormat('EEEE, d MMMM yyyy', 'es').format(date)
              : 'Seleccionar fecha',
          style: TextStyle(
            color: date != null
                ? Theme.of(context).colorScheme.onSurface
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Notificaciones',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Activar notificaciones'),
            subtitle: Text(
              _notificationsEnabled
                  ? 'Recibirás recordatorios antes de cada transacción'
                  : 'No recibirás notificaciones',
            ),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            contentPadding: EdgeInsets.zero,
          ),
          if (_notificationsEnabled) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _notificationTime,
                );
                if (time != null) {
                  setState(() => _notificationTime = time);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Hora de notificación',
                  prefixIcon: const Icon(Icons.access_time_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _notificationTime.format(context),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinanceModuleSelector(FinanceService service) {
    // Verificar disponibilidad de módulos
    // Para gastos: puede vincular a deudas (préstamos recibidos) o ahorros
    // Para ingresos: solo puede vincular a préstamos dados (que me deben), NO ahorros
    final hasActiveLoans = _isIncome
        ? service.loansGiven.any((l) => l.status == LoanStatus.active)
        : service.loansReceived.any((l) => l.status == LoanStatus.active);
    // Solo mostrar ahorros para gastos, no para ingresos
    final hasActiveSavings = !_isIncome && service.activeSavingsGoals.isNotEmpty;
    
    // Si no hay ningún módulo disponible, no mostrar el selector
    if (!hasActiveLoans && !hasActiveSavings) {
      return const SizedBox.shrink();
    }
    
    // Si el módulo seleccionado ya no está disponible, limpiar la selección
    if (_selectedFinanceModule == 'loan' && !hasActiveLoans) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedFinanceModule = null;
            _selectedLoanId = null;
          });
        }
      });
    } else if (_selectedFinanceModule == 'savings' && !hasActiveSavings) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedFinanceModule = null;
            _selectedSavingsGoalId = null;
          });
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vincular a finanzas (opcional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedFinanceModule,
          decoration: InputDecoration(
            labelText: 'Módulo de finanzas',
            prefixIcon: const Icon(Icons.account_balance_rounded),
            helperText: 'Selecciona el módulo al que deseas vincular este movimiento',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Ninguno'),
            ),
            if (hasActiveLoans)
              DropdownMenuItem<String>(
                value: 'loan',
                child: Row(
                  children: [
                    Icon(
                      _isIncome ? Icons.account_balance_wallet_rounded : Icons.payment_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(_isIncome ? 'Préstamo' : 'Deuda'),
                  ],
                ),
              ),
            if (hasActiveSavings)
              const DropdownMenuItem<String>(
                value: 'savings',
                child: Row(
                  children: [
                    Icon(Icons.savings_rounded, size: 20),
                    SizedBox(width: 8),
                    Text('Meta de ahorro'),
                  ],
                ),
              ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedFinanceModule = value;
              // Limpiar selecciones cuando se cambia el módulo
              if (value != 'loan') {
                _selectedLoanId = null;
              }
              if (value != 'savings') {
                _selectedSavingsGoalId = null;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildLoanDropdown(FinanceService service, {required bool isDebt}) {
    // Si es deuda (gasto), mostrar préstamos recibidos (que debo)
    // Si es ingreso, mostrar préstamos dados (que me deben)
    final loans = isDebt 
        ? service.loansReceived.where((l) => l.status == LoanStatus.active).toList()
        : service.loansGiven.where((l) => l.status == LoanStatus.active).toList();

    if (loans.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonFormField<String>(
      value: _selectedLoanId,
      decoration: InputDecoration(
        labelText: isDebt ? 'Abonar a deuda (opcional)' : 'Recibir pago de préstamo (opcional)',
        prefixIcon: Icon(isDebt ? Icons.payment_rounded : Icons.account_balance_wallet_rounded),
        helperText: isDebt 
            ? 'Este gasto se registrará como abono a la deuda seleccionada'
            : 'Este ingreso se registrará como pago recibido del préstamo seleccionado',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Ninguno'),
        ),
        ...loans.map((loan) => DropdownMenuItem(
              value: loan.id,
              child: Text(loan.name),
            )),
      ],
      onChanged: (value) => setState(() => _selectedLoanId = value),
    );
  }

  Widget _buildSavingsGoalDropdown(FinanceService service) {
    final activeGoals = service.activeSavingsGoals;

    if (activeGoals.isEmpty) {
      return const SizedBox.shrink();
    }

    return DropdownButtonFormField<String>(
      value: _selectedSavingsGoalId,
      decoration: InputDecoration(
        labelText: 'Agregar a meta de ahorro (opcional)',
        prefixIcon: const Icon(Icons.savings_rounded),
        helperText: 'Este movimiento se agregará como contribución a la meta seleccionada',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Ninguno'),
        ),
        ...activeGoals.map((goal) => DropdownMenuItem(
              value: goal.id,
              child: Text(goal.name),
            )),
      ],
      onChanged: (value) => setState(() => _selectedSavingsGoalId = value),
    );
  }

  Future<void> _saveAutomatic(FinanceService service) async {
    if (!_formKey.currentState!.validate()) return;

    if (_isIncome && _selectedSource == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fuente de ingreso')),
      );
      return;
    }

    if (!_isIncome && _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una categoría')),
      );
      return;
    }

    if (_frequency == 'monthly' && _dayOfMonth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un día del mes')),
      );
      return;
    }

    if (_frequency == 'weekly' && _dayOfWeek == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un día de la semana')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final amount = double.tryParse(
        _amountController.text.replaceAll(RegExp(r'[^\d.]'), ''),
      );
      if (amount == null || amount <= 0) {
        throw Exception('Ingresa un monto válido');
      }

      final id = widget.automatic?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      await service.saveRecurringTransaction(
        id: id,
        title: _titleController.text.trim(),
        amount: amount,
        type: _isIncome ? 'income' : 'expense',
        category: _selectedCategory ?? '',
        source: _selectedSource,
        frequency: _frequency,
        dayOfMonth: _frequency == 'monthly' ? _dayOfMonth : null,
        dayOfWeek: _frequency == 'weekly' ? _dayOfWeek : null,
        startDate: _startDate,
        endDate: _endDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        notificationsEnabled: _notificationsEnabled,
        notificationHour: _notificationsEnabled ? _notificationTime.hour : null,
        notificationMinute:
            _notificationsEnabled ? _notificationTime.minute : null,
        linkedFinanceModule: _selectedFinanceModule,
        linkedLoanId: _selectedLoanId,
        linkedSavingsGoalId: _selectedSavingsGoalId,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.automatic != null
                  ? 'Automático actualizado'
                  : 'Automático creado',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteAutomatic(
    BuildContext context,
    FinanceService service,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar automático'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este ingreso/pago automático?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.automatic != null) {
      try {
        await service.deleteRecurringTransaction(widget.automatic!.id);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Automático eliminado')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: $e')),
          );
        }
      }
    }
  }
}

