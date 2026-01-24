import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/transaction.dart';
import '../models/loan.dart';
import '../main.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;
  final bool? initialIsIncome;

  const AddTransactionScreen({
    super.key,
    this.transaction,
    this.initialIsIncome,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _installmentNumberController = TextEditingController();
  final _totalInstallmentsController = TextEditingController();
  final _amountFocusNode = FocusNode();

  late bool _isIncome;
  String? _selectedCategory;
  String? _selectedSource;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  
  // Opciones opcionales de vinculación
  String? _selectedFinanceModule; // 'loan' o 'savings'
  String? _selectedLoanId; // Para vincular a préstamo
  String? _selectedSavingsGoalId; // Para vincular a meta de ahorro
  
  // Tipo de pago (opcional)
  PaymentType? _selectedPaymentType;
  
  // Método de pago/cobro (opcional)
  PaymentMethod? _selectedPaymentMethod;
  String? _selectedSourceBank;
  String? _selectedDestinationAccount;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      _titleController.text = t.title;
      _amountController.text = t.amount.toString();
      _descriptionController.text = t.description ?? '';
      _isIncome = t.type == TransactionType.income;
      _selectedCategory = t.category;
      _selectedSource = t.source;
      _selectedDate = t.date;
      // Cargar tipo de pago si existe
      _selectedPaymentType = t.paymentType;
      if (t.installmentNumber != null) {
        _installmentNumberController.text = t.installmentNumber.toString();
      }
      if (t.totalInstallments != null) {
        _totalInstallmentsController.text = t.totalInstallments.toString();
      }
      // Cargar método de pago si existe
      _selectedPaymentMethod = t.paymentMethod;
      _selectedSourceBank = t.sourceBank;
      _selectedDestinationAccount = t.destinationAccount;
    } else {
      _isIncome = widget.initialIsIncome ?? true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _installmentNumberController.dispose();
    _totalInstallmentsController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = context.read<FinanceService>();
    final isEditing = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar movimiento' : 'Nuevo movimiento'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: () => _deleteTransaction(context, service),
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
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej: Salario, Supermercado...',
                prefixIcon: Icon(Icons.edit_rounded),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa un título';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Categoría o Fuente
            if (_isIncome) ...[
              _buildSourceDropdown(service),
            ] else ...[
              _buildCategoryDropdown(service),
            ],
            const SizedBox(height: 16),

            // Fecha
            _buildDatePicker(context),
            const SizedBox(height: 16),

            // Descripción
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                hintText: 'Agrega más detalles...',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            
            // Tipo de pago (opcional)
            _buildPaymentTypeSelector(),
            
            // Si es ingreso, mostrar método de pago
            if (_isIncome) ...[
              const SizedBox(height: 16),
              _buildPaymentMethodSelector(service),
            ],
            const SizedBox(height: 24),

            // Opciones opcionales de vinculación
            Text(
              'Vincular a finanzas (opcional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            
            // Selector de módulo de finanzas
            _buildFinanceModuleSelector(service),
            
            // Mostrar dropdown según el módulo seleccionado
            if (_selectedFinanceModule == 'loan') ...[
              const SizedBox(height: 16),
              _buildLoanDropdown(service, isDebt: !_isIncome),
            ] else if (_selectedFinanceModule == 'savings') ...[
              const SizedBox(height: 16),
              _buildSavingsGoalDropdown(service),
            ],
            
            const SizedBox(height: 32),

            // Botón guardar
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () => _saveTransaction(context, service),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(isEditing ? 'Actualizar' : 'Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _isIncome = true;
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
      ),
    );
  }

  Widget _buildAmountField(FinanceService service) {
    final color = _isIncome
        ? Theme.of(context).colorScheme.income
        : Theme.of(context).colorScheme.expense;

    // Formatear el monto para visualización
    String formattedAmount = '0';
    final rawText = _amountController.text.replaceAll(RegExp(r'[^\d.]'), '');
    if (rawText.isNotEmpty) {
      final amount = double.tryParse(rawText);
      if (amount != null) {
        formattedAmount = service.formatNumber(amount, decimals: 0);
        // Si tiene decimales, añadirlos
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
                return AnimatedBuilder(
                  animation: _amountFocusNode,
                  builder: (context, child) {
                    // Calcular tamaño de fuente basado en longitud
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
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            // Cursor parpadeante (solo cuando hay foco)
                            if (_amountFocusNode.hasFocus)
                              _BlinkingCursor(
                                  color: color, height: fontSize * 0.8),
                          ],
                        ),
                      ),
                    );
                  },
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
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Categoría',
        prefixIcon: Icon(Icons.category_rounded),
      ),
      items: service.allExpenseCategories
          .map((cat) => DropdownMenuItem(
                value: cat,
                child: Text(cat),
              ))
          .toList(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedSource,
          decoration: const InputDecoration(
            labelText: 'Fuente de ingreso',
            prefixIcon: Icon(Icons.account_balance_wallet_rounded),
          ),
          items: [
            ...service.allIncomeSources.map((source) => DropdownMenuItem(
                  value: source,
                  child: Text(source),
                )),
            // Opción para agregar nueva fuente
            const DropdownMenuItem<String>(
              value: '__add_new__',
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, size: 20, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Agregar nueva fuente...', 
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value == '__add_new__') {
              _showAddNewSourceDialog(service);
            } else {
              setState(() => _selectedSource = value);
            }
          },
          validator: (value) {
            if (value == null || value == '__add_new__') {
              return 'Selecciona una fuente';
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _showAddNewSourceDialog(FinanceService service) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva fuente de ingreso'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Nombre de la fuente',
            hintText: 'Ej: Ventas, Comisiones...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await service.addCustomIncomeSource(result);
      if (mounted) {
        setState(() => _selectedSource = result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fuente "$result" agregada'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fecha',
          prefixIcon: Icon(Icons.calendar_today_rounded),
        ),
        child: Text(
          DateFormat('EEEE, d MMMM yyyy', 'es').format(_selectedDate),
        ),
      ),
    );
  }

  Widget _buildPaymentTypeSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de pago (opcional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPaymentTypeChip(null, 'Sin especificar', Icons.remove_circle_outline),
            _buildPaymentTypeChip(PaymentType.full, 'Pago entero', Icons.check_circle_outline),
            _buildPaymentTypeChip(PaymentType.partial, 'Abono', Icons.pie_chart_outline),
            _buildPaymentTypeChip(PaymentType.installment, 'Cuota', Icons.format_list_numbered),
          ],
        ),
        // Si es cuota, mostrar campos adicionales
        if (_selectedPaymentType == PaymentType.installment) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _installmentNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Cuota #',
                    hintText: 'Ej: 3',
                    prefixIcon: Icon(Icons.tag),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text('de', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _totalInstallmentsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Total cuotas',
                    hintText: 'Ej: 12',
                    prefixIcon: Icon(Icons.grid_view),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentTypeChip(PaymentType? type, String label, IconData icon) {
    final isSelected = _selectedPaymentType == type;
    final color = Theme.of(context).colorScheme.primary;
    
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: color,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
      onSelected: (selected) {
        setState(() {
          _selectedPaymentType = selected ? type : null;
          if (!selected || type != PaymentType.installment) {
            _installmentNumberController.clear();
            _totalInstallmentsController.clear();
          }
        });
      },
    );
  }

  Widget _buildPaymentMethodSelector(FinanceService service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de cobro (opcional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPaymentMethodChip(null, 'Sin especificar', Icons.remove_circle_outline),
            _buildPaymentMethodChip(PaymentMethod.cash, 'Efectivo', Icons.payments_outlined),
            _buildPaymentMethodChip(PaymentMethod.transfer, 'Transferencia', Icons.swap_horiz),
          ],
        ),
        // Si es transferencia, mostrar campos adicionales
        if (_selectedPaymentMethod == PaymentMethod.transfer) ...[
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _selectedSourceBank,
            decoration: const InputDecoration(
              labelText: 'Banco de origen (quien envió)',
              hintText: 'Ej: Bancolombia, Nequi...',
              prefixIcon: Icon(Icons.account_balance),
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => _selectedSourceBank = value.isEmpty ? null : value,
          ),
          const SizedBox(height: 12),
          _buildDestinationAccountField(service),
        ],
      ],
    );
  }

  Widget _buildPaymentMethodChip(PaymentMethod? method, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == method;
    final color = Theme.of(context).colorScheme.secondary;
    
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: color,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
      onSelected: (selected) {
        setState(() {
          _selectedPaymentMethod = selected ? method : null;
          if (!selected || method != PaymentMethod.transfer) {
            _selectedSourceBank = null;
            _selectedDestinationAccount = null;
          }
        });
      },
    );
  }

  Widget _buildDestinationAccountField(FinanceService service) {
    // Opciones predefinidas de destino
    final destinationOptions = [
      'Cuenta bancaria',
      'Alcancía',
      'Bolsillo',
      'Efectivo',
      'Otro',
    ];
    
    // Determinar el valor actual del dropdown
    String? dropdownValue;
    String? customValue;
    String? bankName;
    
    if (_selectedDestinationAccount != null) {
      if (_selectedDestinationAccount!.startsWith('Cuenta bancaria:')) {
        dropdownValue = 'Cuenta bancaria';
        bankName = _selectedDestinationAccount!.replaceFirst('Cuenta bancaria: ', '');
      } else if (destinationOptions.contains(_selectedDestinationAccount)) {
        dropdownValue = _selectedDestinationAccount;
      } else {
        // Es un valor personalizado
        dropdownValue = 'Otro';
        customValue = _selectedDestinationAccount;
      }
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: dropdownValue,
          decoration: const InputDecoration(
            labelText: 'Destino del dinero',
            hintText: 'Selecciona dónde llegó',
            prefixIcon: Icon(Icons.account_balance_wallet),
          ),
          items: destinationOptions.map((dest) => DropdownMenuItem(
            value: dest,
            child: Row(
              children: [
                Icon(_getDestinationIcon(dest), size: 20),
                const SizedBox(width: 8),
                Text(dest),
              ],
            ),
          )).toList(),
          onChanged: (value) {
            if (value == 'Otro') {
              _showCustomDestinationDialog();
            } else {
              setState(() {
                _selectedDestinationAccount = value;
              });
            }
          },
        ),
        // Si seleccionó cuenta bancaria, pedir el nombre del banco
        if (dropdownValue == 'Cuenta bancaria') ...[
          const SizedBox(height: 12),
          TextFormField(
            initialValue: bankName,
            decoration: const InputDecoration(
              labelText: 'Nombre del banco',
              hintText: 'Ej: Bancolombia, BBVA...',
              prefixIcon: Icon(Icons.account_balance),
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              // Guardamos el nombre del banco en destinationAccount con prefijo
              if (value.isNotEmpty) {
                _selectedDestinationAccount = 'Cuenta bancaria: $value';
              } else {
                _selectedDestinationAccount = 'Cuenta bancaria';
              }
            },
          ),
        ],
        // Si seleccionó "Otro" y hay un valor personalizado, mostrarlo
        if (dropdownValue == 'Otro' && customValue != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.edit_note,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    customValue,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _showCustomDestinationDialog(initialValue: customValue),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  IconData _getDestinationIcon(String destination) {
    switch (destination) {
      case 'Cuenta bancaria':
        return Icons.account_balance;
      case 'Alcancía':
        return Icons.savings;
      case 'Bolsillo':
        return Icons.wallet;
      case 'Efectivo':
        return Icons.payments;
      default:
        return Icons.more_horiz;
    }
  }

  Future<void> _showCustomDestinationDialog({String? initialValue}) async {
    final controller = TextEditingController(text: initialValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(initialValue != null ? 'Editar destino' : 'Destino personalizado'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Nombre del destino',
            hintText: 'Ej: Caja fuerte, Inversión...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(initialValue != null ? 'Guardar' : 'Agregar'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _selectedDestinationAccount = result);
    }
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
      _selectedFinanceModule = null;
      _selectedLoanId = null;
    } else if (_selectedFinanceModule == 'savings' && !hasActiveSavings) {
      _selectedFinanceModule = null;
      _selectedSavingsGoalId = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedFinanceModule,
          decoration: InputDecoration(
            labelText: 'Módulo de finanzas',
            prefixIcon: const Icon(Icons.account_balance_rounded),
            helperText: 'Selecciona el módulo al que deseas vincular este movimiento',
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
      decoration: const InputDecoration(
        labelText: 'Agregar a meta de ahorro (opcional)',
        prefixIcon: Icon(Icons.savings_rounded),
        helperText: 'Este movimiento se agregará como contribución a la meta seleccionada',
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

  Future<void> _saveTransaction(
    BuildContext context,
    FinanceService service,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Parsear número de cuota si aplica
      int? installmentNumber;
      int? totalInstallments;
      if (_selectedPaymentType == PaymentType.installment) {
        installmentNumber = int.tryParse(_installmentNumberController.text);
        totalInstallments = int.tryParse(_totalInstallmentsController.text);
      }
      
      final transaction = Transaction(
        id: widget.transaction?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        type: _isIncome ? TransactionType.income : TransactionType.expense,
        category: _isIncome ? (_selectedSource ?? 'Otros') : _selectedCategory!,
        date: _selectedDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        source: _isIncome ? _selectedSource : null,
        // Nuevos campos opcionales
        paymentType: _selectedPaymentType,
        installmentNumber: installmentNumber,
        totalInstallments: totalInstallments,
        paymentMethod: _selectedPaymentMethod,
        sourceBank: _selectedSourceBank,
        destinationAccount: _selectedDestinationAccount,
      );

      if (widget.transaction != null) {
        await service.updateTransaction(transaction);
      } else {
        await service.addTransaction(transaction);
        
        // Vincular solo al módulo seleccionado
        if (_selectedFinanceModule == 'loan' && _selectedLoanId != null) {
          try {
            final allLoans = [...service.loansReceived, ...service.loansGiven];
            final loan = allLoans.firstWhere((l) => l.id == _selectedLoanId);
            await service.addLoanPayment(
              _selectedLoanId!,
              transaction.amount,
              loan.paidInstallments + 1,
              date: transaction.date,
              notes: 'Vinculado desde movimiento: ${transaction.title}',
              transactionId: transaction.id, // Vincular con la transacción
            );
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Movimiento guardado, pero error al vincular préstamo: $e'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        } else if (_selectedFinanceModule == 'savings' && _selectedSavingsGoalId != null) {
          try {
            await service.addSavingsContribution(
              _selectedSavingsGoalId!,
              transaction.amount,
              date: transaction.date,
              note: 'Vinculado desde movimiento: ${transaction.title}',
              transactionId: transaction.id, // Vincular con la transacción
            );
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Movimiento guardado, pero error al vincular ahorro: $e'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          }
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.transaction != null
                  ? 'Movimiento actualizado'
                  : 'Movimiento guardado${_selectedFinanceModule != null ? ' y vinculado' : ''}',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteTransaction(
    BuildContext context,
    FinanceService service,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar movimiento'),
        content: const Text('¿Estás seguro de eliminar este movimiento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await service.deleteTransaction(widget.transaction!.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movimiento eliminado')),
      );
    }
  }
}

/// Widget de cursor parpadeante
class _BlinkingCursor extends StatefulWidget {
  final Color color;
  final double height;

  const _BlinkingCursor({required this.color, this.height = 48});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 3,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      },
    );
  }
}
