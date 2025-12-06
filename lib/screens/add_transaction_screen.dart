import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/transaction.dart';
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
  final _amountFocusNode = FocusNode();

  late bool _isIncome;
  String? _selectedCategory;
  String? _selectedSource;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

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
    } else {
      _isIncome = widget.initialIsIncome ?? true;
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
    return DropdownButtonFormField<String>(
      value: _selectedSource,
      decoration: const InputDecoration(
        labelText: 'Fuente de ingreso',
        prefixIcon: Icon(Icons.account_balance_wallet_rounded),
      ),
      items: service.allIncomeSources
          .map((source) => DropdownMenuItem(
                value: source,
                child: Text(source),
              ))
          .toList(),
      onChanged: (value) => setState(() => _selectedSource = value),
      validator: (value) {
        if (value == null) {
          return 'Selecciona una fuente';
        }
        return null;
      },
    );
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

  Future<void> _saveTransaction(
    BuildContext context,
    FinanceService service,
  ) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
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
      );

      if (widget.transaction != null) {
        await service.updateTransaction(transaction);
      } else {
        await service.addTransaction(transaction);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.transaction != null
                  ? 'Movimiento actualizado'
                  : 'Movimiento guardado',
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
