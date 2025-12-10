import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/loan.dart';
import 'loans_history_screen.dart';
import '../main.dart';

/// Formateador de números con separadores de miles
class NumberFormatInputFormatter extends TextInputFormatter {
  final String thousandsSeparator;
  final String decimalSeparator;

  NumberFormatInputFormatter({
    required this.thousandsSeparator,
    required this.decimalSeparator,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.')
        .replaceAll(RegExp(r'[^\d.]'), '');

    List<String> parts = text.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    String formattedInteger = _formatWithSeparators(integerPart);

    String formattedText = formattedInteger;
    if (decimalPart.isNotEmpty) {
      formattedText += '$decimalSeparator$decimalPart';
    }

    int selectionIndex = formattedText.length;
    if (newValue.selection.baseOffset < newValue.text.length) {
      int oldLength = oldValue.text.length;
      int newLength = formattedText.length;
      double ratio = oldLength > 0 ? newLength / oldLength : 1.0;
      selectionIndex = (newValue.selection.baseOffset * ratio).round();
      selectionIndex = selectionIndex.clamp(0, formattedText.length);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _formatWithSeparators(String number) {
    if (number.isEmpty) return '';
    
    String reversed = number.split('').reversed.join();
    StringBuffer buffer = StringBuffer();
    
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(thousandsSeparator);
      }
      buffer.write(reversed[i]);
    }
    
    return buffer.toString().split('').reversed.join();
  }

  static String removeFormatting(String formattedText, String thousandsSeparator, String decimalSeparator) {
    return formattedText
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.');
  }
}

/// Opciones de iconos para préstamos con sus colores asociados
class LoanIconOption {
  final String id;
  final IconData icon;
  final Color color;
  final String label;

  const LoanIconOption({
    required this.id,
    required this.icon,
    required this.color,
    required this.label,
  });
}

final List<LoanIconOption> loanIconOptions = [
  LoanIconOption(
    id: 'personal',
    icon: Icons.person_rounded,
    color: const Color(0xFF5C6BC0),
    label: 'Personal',
  ),
  LoanIconOption(
    id: 'family',
    icon: Icons.family_restroom_rounded,
    color: const Color(0xFFE91E63),
    label: 'Familia',
  ),
  LoanIconOption(
    id: 'friend',
    icon: Icons.people_rounded,
    color: const Color(0xFF00BCD4),
    label: 'Amigo',
  ),
  LoanIconOption(
    id: 'bank',
    icon: Icons.account_balance_rounded,
    color: const Color(0xFF1565C0),
    label: 'Banco',
  ),
  LoanIconOption(
    id: 'car',
    icon: Icons.directions_car_rounded,
    color: const Color(0xFFE65100),
    label: 'Auto',
  ),
  LoanIconOption(
    id: 'home',
    icon: Icons.home_rounded,
    color: const Color(0xFF7B1FA2),
    label: 'Casa',
  ),
  LoanIconOption(
    id: 'education',
    icon: Icons.school_rounded,
    color: const Color(0xFF00838F),
    label: 'Estudios',
  ),
  LoanIconOption(
    id: 'business',
    icon: Icons.store_rounded,
    color: const Color(0xFFFF6F00),
    label: 'Negocio',
  ),
  LoanIconOption(
    id: 'credit',
    icon: Icons.credit_card_rounded,
    color: const Color(0xFFD32F2F),
    label: 'Crédito',
  ),
  LoanIconOption(
    id: 'emergency',
    icon: Icons.emergency_rounded,
    color: const Color(0xFFC62828),
    label: 'Emergencia',
  ),
];

LoanIconOption getLoanIconById(String? id) {
  return loanIconOptions.firstWhere(
    (icon) => icon.id == id,
    orElse: () => loanIconOptions.first,
  );
}

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préstamos'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Debo'),
            Tab(text: 'Me deben'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: Consumer<FinanceService>(
        builder: (context, service, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildLoansList(context, service, LoanType.received),
              _buildLoansList(context, service, LoanType.given),
              LoansHistoryScreen(loanType: null), // Historial de todos los préstamos
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'loans_fab',
        onPressed: () => _showAddLoanDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo préstamo'),
      ),
    );
  }

  Widget _buildLoansList(
    BuildContext context,
    FinanceService service,
    LoanType type,
  ) {
    final loans = type == LoanType.received
        ? service.loansReceived
        : service.loansGiven;

    if (loans.isEmpty) {
      return _buildEmptyState(context, type);
    }

    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    final activeLoans = loans.where((l) => l.status == LoanStatus.active).toList();

    final totalActive = activeLoans.fold<double>(0, (sum, l) => sum + l.remainingAmount);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Resumen
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: type == LoanType.received
                  ? [Colors.red.shade400, Colors.red.shade600]
                  : [Colors.green.shade400, Colors.green.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type == LoanType.received ? 'Total que debo' : 'Total que me deben',
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(totalActive),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${activeLoans.length} préstamos activos',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Préstamos activos
        if (activeLoans.isNotEmpty) ...[
          Text('Activos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...activeLoans.map((loan) => _buildLoanCard(context, loan, service)),
          const SizedBox(height: 24),
        ],

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, LoanType type) {
    final isDebt = type == LoanType.received;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.loan.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.loan,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isDebt ? 'No tienes deudas' : 'No te deben nada',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            isDebt
                ? '¡Excelente! No debes nada'
                : 'Registra préstamos que hayas dado',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCard(
    BuildContext context,
    Loan loan,
    FinanceService service,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 2,
    );

    final isActive = loan.status == LoanStatus.active;
    
    // Obtener el icono y color personalizado o usar el predeterminado
    final iconOption = getLoanIconById(loan.iconName);
    final cardColor = loan.color != null
        ? Color(int.parse(loan.color!.substring(1), radix: 16) + 0xFF000000)
        : iconOption.color;
    
    // Color de indicador según tipo (deuda o por cobrar)
    final typeColor = loan.type == LoanType.received
        ? Theme.of(context).colorScheme.expense
        : Theme.of(context).colorScheme.income;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconOption.icon,
                color: cardColor,
              ),
            ),
            title: Text(
              loan.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (loan.borrowerOrLender != null)
                  Text(
                    loan.type == LoanType.received
                        ? 'Prestado por: ${loan.borrowerOrLender}'
                        : 'Prestado a: ${loan.borrowerOrLender}',
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Restante: ${currencyFormat.format(loan.remainingAmount)}',
                      style: TextStyle(
                        color: typeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: loan.paidPercentage / 100,
                    minHeight: 6,
                    backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(cardColor),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${loan.paidInstallments}/${loan.totalInstallments} cuotas',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${loan.paidPercentage.toStringAsFixed(0)}% pagado',
                      style: TextStyle(
                        color: cardColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: isActive
                ? IconButton(
                    icon: Icon(Icons.payment_rounded, color: cardColor),
                    onPressed: () => _showPaymentDialog(context, loan, service),
                  )
                : const Icon(Icons.check_circle_rounded, color: Colors.green),
            onTap: () => _showLoanDetails(context, loan, service),
          ),
        ],
      ),
    );
  }

  void _showAddLoanDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final personController = TextEditingController();
    final amountController = TextEditingController();
    final interestController = TextEditingController(text: '0');
    final installmentsController = TextEditingController(text: '1');
    LoanType loanType = LoanType.received;
    PaymentFrequency frequency = PaymentFrequency.monthly;
    InterestRatePeriod ratePeriod = InterestRatePeriod.monthly; // Más común: mensual
    LoanIconOption selectedIcon = loanIconOptions.first;
    DateTime startDate = DateTime.now();
    Set<int> notificationDays = {};
    int? notificationDayOfMonth;
    String? notificationTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nuevo préstamo',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    
                    // Selector de icono
                    Text(
                      'Elige un icono',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: loanIconOptions.length,
                        itemBuilder: (context, index) {
                          final iconOption = loanIconOptions[index];
                          final isSelected = selectedIcon.id == iconOption.id;
                          return GestureDetector(
                            onTap: () => setState(() => selectedIcon = iconOption),
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? iconOption.color.withOpacity(0.15)
                                    : (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: iconOption.color, width: 2)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    iconOption.icon,
                                    color: isSelected ? iconOption.color : Colors.grey[600],
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    iconOption.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? iconOption.color : Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Tipo de préstamo
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Me prestaron'),
                            selected: loanType == LoanType.received,
                            onSelected: (_) => setState(() => loanType = LoanType.received),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Yo presté'),
                            selected: loanType == LoanType.given,
                            onSelected: (_) => setState(() => loanType = LoanType.given),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre/Descripción',
                        prefixIcon: Icon(Icons.edit_rounded),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: personController,
                      decoration: InputDecoration(
                        labelText: loanType == LoanType.received
                            ? '¿Quién te prestó?'
                            : '¿A quién le prestaste?',
                        prefixIcon: const Icon(Icons.person_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Consumer<FinanceService>(
                      builder: (context, service, _) {
                        final settings = service.userSettings;
                        return TextFormField(
                          controller: amountController,
                          decoration: const InputDecoration(
                            labelText: 'Monto total',
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            NumberFormatInputFormatter(
                              thousandsSeparator: settings.thousandsSeparator,
                              decimalSeparator: settings.decimalSeparator,
                            ),
                          ],
                          validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Tasa de interés con selector de periodicidad
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: interestController,
                            decoration: const InputDecoration(
                              labelText: 'Interés (%)',
                              suffixText: '%',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<InterestRatePeriod>(
                            value: ratePeriod,
                            decoration: const InputDecoration(
                              labelText: 'Periodicidad',
                            ),
                            items: InterestRatePeriod.values.map((period) {
                              return DropdownMenuItem(
                                value: period,
                                child: Text(period.displayName),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => ratePeriod = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Cuotas
                    TextFormField(
                      controller: installmentsController,
                      decoration: const InputDecoration(
                        labelText: 'Número de cuotas',
                        prefixIcon: Icon(Icons.format_list_numbered_rounded),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    DropdownButtonFormField<PaymentFrequency>(
                      value: frequency,
                      decoration: const InputDecoration(
                        labelText: 'Frecuencia de pago',
                        prefixIcon: Icon(Icons.schedule_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: PaymentFrequency.weekly, child: Text('Semanal')),
                        DropdownMenuItem(value: PaymentFrequency.biweekly, child: Text('Quincenal')),
                        DropdownMenuItem(value: PaymentFrequency.monthly, child: Text('Mensual')),
                        DropdownMenuItem(value: PaymentFrequency.quarterly, child: Text('Trimestral')),
                        DropdownMenuItem(value: PaymentFrequency.yearly, child: Text('Anual')),
                      ],
                      onChanged: (v) => setState(() => frequency = v!),
                    ),
                    const SizedBox(height: 16),
                    
                    // Fecha de inicio
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => startDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de inicio del préstamo',
                          prefixIcon: Icon(Icons.calendar_today_rounded),
                        ),
                        child: Text(
                          DateFormat('d MMMM yyyy', 'es').format(startDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de notificación - dinámico según frecuencia
                    InkWell(
                      onTap: () async {
                        final result = await _showNotificationConfigDialog(
                          context: context,
                          frequency: frequency,
                          currentSelection: notificationDays,
                          isPayment: loanType == LoanType.received,
                          currentDayOfMonth: notificationDayOfMonth,
                          currentTime: notificationTime,
                        );
                        if (result != null) {
                          setState(() {
                            notificationDays = result.selection;
                            notificationDayOfMonth = result.dayOfMonth;
                            notificationTime = result.time;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: loanType == LoanType.received
                              ? 'Recordatorio de pago (opcional)'
                              : 'Recordatorio de cobro (opcional)',
                          prefixIcon: Icon(Icons.notifications_rounded, color: selectedIcon.color),
                          helperText: _getNotificationHelperText(frequency, loanType == LoanType.received),
                        ),
                        child: Text(
                          notificationDays.isNotEmpty
                              ? _formatNotificationDisplay(
                                  notificationDays, 
                                  frequency,
                                  dayOfMonth: notificationDayOfMonth,
                                  time: notificationTime,
                                )
                              : 'Sin notificación',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final service = context.read<FinanceService>();
                            final settings = service.userSettings;
                            final cleanAmount = NumberFormatInputFormatter.removeFormatting(
                              amountController.text,
                              settings.thousandsSeparator,
                              settings.decimalSeparator,
                            );
                            final principal = double.parse(cleanAmount);
                            final interest = double.tryParse(interestController.text) ?? 0;
                            final installments = int.parse(installmentsController.text);
                            
                            final installmentAmount = Loan.calculateInstallment(
                              principal: principal,
                              interestRate: interest,
                              ratePeriod: ratePeriod,
                              totalInstallments: installments,
                              frequency: frequency,
                            );
                            
                            final loan = Loan(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: nameController.text.trim(),
                              borrowerOrLender: personController.text.trim().isEmpty
                                  ? null
                                  : personController.text.trim(),
                              type: loanType,
                              principalAmount: principal,
                              interestRate: interest,
                              interestRatePeriod: ratePeriod,
                              totalInstallments: installments,
                              installmentAmount: installmentAmount,
                              startDate: startDate,
                              paymentFrequency: frequency,
                              iconName: selectedIcon.id,
                              color: '#${selectedIcon.color.value.toRadixString(16).substring(2)}',
                              notificationDays: notificationDays.isNotEmpty 
                                  ? (notificationDays.toList()..sort()).join(',')
                                  : null,
                              notificationDayOfMonth: notificationDayOfMonth,
                              notificationTime: notificationTime,
                            );
                            
                            await service.addLoan(loan);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Préstamo agregado')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedIcon.color,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Agregar préstamo'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditLoanDialog(
    BuildContext context,
    Loan loan,
    FinanceService service,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: loan.name);
    final personController = TextEditingController(text: loan.borrowerOrLender ?? '');
    final settings = service.userSettings;
    final formattedAmount = settings.formatNumber(loan.principalAmount, decimals: 0);
    final amountController = TextEditingController(text: formattedAmount);
    final interestController = TextEditingController(text: loan.interestRate.toStringAsFixed(2));
    final installmentsController = TextEditingController(text: loan.totalInstallments.toString());
    LoanType loanType = loan.type;
    PaymentFrequency frequency = loan.paymentFrequency;
    InterestRatePeriod ratePeriod = loan.interestRatePeriod;
    LoanIconOption selectedIcon = getLoanIconById(loan.iconName);
    DateTime startDate = loan.startDate;
    Set<int> notificationDays = loan.notificationDaysList.toSet();
    int? notificationDayOfMonth = loan.notificationDayOfMonth;
    String? notificationTime = loan.notificationTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Editar préstamo',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    
                    // Selector de icono
                    Text(
                      'Elige un icono',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: loanIconOptions.length,
                        itemBuilder: (context, index) {
                          final iconOption = loanIconOptions[index];
                          final isSelected = selectedIcon.id == iconOption.id;
                          return GestureDetector(
                            onTap: () => setState(() => selectedIcon = iconOption),
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? iconOption.color.withOpacity(0.15)
                                    : (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: iconOption.color, width: 2)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    iconOption.icon,
                                    color: isSelected ? iconOption.color : Colors.grey[600],
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    iconOption.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? iconOption.color : Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Tipo de préstamo
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Me prestaron'),
                            selected: loanType == LoanType.received,
                            onSelected: (_) => setState(() => loanType = LoanType.received),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Yo presté'),
                            selected: loanType == LoanType.given,
                            onSelected: (_) => setState(() => loanType = LoanType.given),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre/Descripción',
                        prefixIcon: Icon(Icons.edit_rounded),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: personController,
                      decoration: InputDecoration(
                        labelText: loanType == LoanType.received
                            ? '¿Quién te prestó?'
                            : '¿A quién le prestaste?',
                        prefixIcon: const Icon(Icons.person_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Monto total',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        NumberFormatInputFormatter(
                          thousandsSeparator: settings.thousandsSeparator,
                          decimalSeparator: settings.decimalSeparator,
                        ),
                      ],
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Tasa de interés con selector de periodicidad
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: interestController,
                            decoration: const InputDecoration(
                              labelText: 'Interés (%)',
                              suffixText: '%',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<InterestRatePeriod>(
                            value: ratePeriod,
                            decoration: const InputDecoration(
                              labelText: 'Periodicidad',
                            ),
                            items: InterestRatePeriod.values.map((period) {
                              return DropdownMenuItem(
                                value: period,
                                child: Text(period.displayName),
                              );
                            }).toList(),
                            onChanged: (v) => setState(() => ratePeriod = v!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Cuotas
                    TextFormField(
                      controller: installmentsController,
                      decoration: const InputDecoration(
                        labelText: 'Número de cuotas',
                        prefixIcon: Icon(Icons.format_list_numbered_rounded),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    DropdownButtonFormField<PaymentFrequency>(
                      value: frequency,
                      decoration: const InputDecoration(
                        labelText: 'Frecuencia de pago',
                        prefixIcon: Icon(Icons.schedule_rounded),
                      ),
                      items: const [
                        DropdownMenuItem(value: PaymentFrequency.weekly, child: Text('Semanal')),
                        DropdownMenuItem(value: PaymentFrequency.biweekly, child: Text('Quincenal')),
                        DropdownMenuItem(value: PaymentFrequency.monthly, child: Text('Mensual')),
                        DropdownMenuItem(value: PaymentFrequency.quarterly, child: Text('Trimestral')),
                        DropdownMenuItem(value: PaymentFrequency.yearly, child: Text('Anual')),
                      ],
                      onChanged: (v) => setState(() => frequency = v!),
                    ),
                    const SizedBox(height: 16),
                    
                    // Fecha de inicio
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => startDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de inicio del préstamo',
                          prefixIcon: Icon(Icons.calendar_today_rounded),
                        ),
                        child: Text(
                          DateFormat('d MMMM yyyy', 'es').format(startDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de notificación - dinámico según frecuencia
                    InkWell(
                      onTap: () async {
                        final result = await _showNotificationConfigDialog(
                          context: context,
                          frequency: frequency,
                          currentSelection: notificationDays,
                          isPayment: loanType == LoanType.received,
                          currentDayOfMonth: notificationDayOfMonth,
                          currentTime: notificationTime,
                        );
                        if (result != null) {
                          setState(() {
                            notificationDays = result.selection;
                            notificationDayOfMonth = result.dayOfMonth;
                            notificationTime = result.time;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: loanType == LoanType.received
                              ? 'Recordatorio de pago (opcional)'
                              : 'Recordatorio de cobro (opcional)',
                          prefixIcon: Icon(Icons.notifications_rounded, color: selectedIcon.color),
                          helperText: _getNotificationHelperText(frequency, loanType == LoanType.received),
                        ),
                        child: Text(
                          notificationDays.isNotEmpty
                              ? _formatNotificationDisplay(
                                  notificationDays, 
                                  frequency,
                                  dayOfMonth: notificationDayOfMonth,
                                  time: notificationTime,
                                )
                              : 'Sin notificación',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final cleanAmount = NumberFormatInputFormatter.removeFormatting(
                              amountController.text,
                              settings.thousandsSeparator,
                              settings.decimalSeparator,
                            );
                            final principal = double.parse(cleanAmount);
                            final interest = double.tryParse(interestController.text) ?? loan.interestRate;
                            final installments = int.parse(installmentsController.text);
                            
                            final installmentAmount = Loan.calculateInstallment(
                              principal: principal,
                              interestRate: interest,
                              ratePeriod: ratePeriod,
                              totalInstallments: installments,
                              frequency: frequency,
                            );
                            
                            final updatedLoan = loan.copyWith(
                              name: nameController.text.trim(),
                              borrowerOrLender: personController.text.trim().isEmpty
                                  ? null
                                  : personController.text.trim(),
                              type: loanType,
                              principalAmount: principal,
                              interestRate: interest,
                              interestRatePeriod: ratePeriod,
                              totalInstallments: installments,
                              installmentAmount: installmentAmount,
                              startDate: startDate,
                              paymentFrequency: frequency,
                              iconName: selectedIcon.id,
                              color: '#${selectedIcon.color.value.toRadixString(16).substring(2)}',
                              notificationDays: notificationDays.isNotEmpty 
                                  ? (notificationDays.toList()..sort()).join(',')
                                  : null,
                              notificationDayOfMonth: notificationDayOfMonth,
                              notificationTime: notificationTime,
                            );
                            
                            await service.updateLoan(updatedLoan);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Préstamo actualizado')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedIcon.color,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Guardar cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPaymentDialog(
    BuildContext context,
    Loan loan,
    FinanceService service,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 2,
    );
    final settings = service.userSettings;
    final formattedAmount = settings.formatNumber(loan.installmentAmount, decimals: 0);
    final amountController = TextEditingController(text: formattedAmount);
    
    // Obtener icono y color del préstamo
    final iconOption = getLoanIconById(loan.iconName);
    final loanColor = loan.color != null
        ? Color(int.parse(loan.color!.substring(1), radix: 16) + 0xFF000000)
        : iconOption.color;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: loanColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(iconOption.icon, color: loanColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registrar pago',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Cuota #${loan.paidInstallments + 1} de ${loan.totalInstallments}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Monto sugerido: ${currencyFormat.format(loan.installmentAmount)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: amountController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Monto a pagar',
                prefixIcon: Icon(Icons.attach_money_rounded, color: loanColor),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                NumberFormatInputFormatter(
                  thousandsSeparator: settings.thousandsSeparator,
                  decimalSeparator: settings.decimalSeparator,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botones rápidos
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...([5000, 10000, 20000, 50000, 100000].map((amount) {
                  // Formatear el monto con separadores
                  final formattedAmount = settings.formatNumber(amount.toDouble(), decimals: 0);
                  return ActionChip(
                    label: Text('${settings.currencySymbol}$formattedAmount'),
                    backgroundColor: loanColor.withOpacity(0.1),
                    onPressed: () {
                      amountController.text = formattedAmount;
                    },
                  );
                }).toList()),
                ActionChip(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_rounded, size: 16),
                      SizedBox(width: 4),
                      Text('Personalizado'),
                    ],
                  ),
                  backgroundColor: loanColor.withOpacity(0.1),
                  onPressed: () {
                    // El campo ya está disponible para escribir
                    amountController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: amountController.text.length,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: loanColor,
                ),
                onPressed: () async {
                  // Remover separadores antes de parsear
                  final cleanValue = NumberFormatInputFormatter.removeFormatting(
                    amountController.text,
                    settings.thousandsSeparator,
                    settings.decimalSeparator,
                  );
                  final amount = double.tryParse(cleanValue);
                  if (amount != null && amount > 0) {
                    await service.addLoanPayment(
                      loan.id,
                      amount,
                      loan.paidInstallments + 1,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pago de ${currencyFormat.format(amount)} registrado',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa un monto válido'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Confirmar pago'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoanDetails(
    BuildContext context,
    Loan loan,
    FinanceService service,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 2,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final amortization = loan.generateAmortizationTable();
        
        // Variables de estado declaradas fuera del builder para persistir
        Set<int> currentNotificationDays = loan.notificationDaysList.toSet();
        int? currentNotificationDayOfMonth = loan.notificationDayOfMonth;
        String? currentNotificationTime = loan.notificationTime;
        bool isNotificationEnabled = currentNotificationDays.isNotEmpty;

        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.3,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              loan.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              Navigator.pop(context);
                              if (value == 'edit') {
                                _showEditLoanDialog(context, loan, service);
                              } else if (value == 'delete') {
                                await service.deleteLoan(loan.id);
                              }
                            },
                            itemBuilder: (_) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Resumen
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailCard(
                              context,
                              'Principal',
                              currencyFormat.format(loan.principalAmount),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDetailCard(
                              context,
                              'Intereses',
                              currencyFormat.format(loan.totalInterest),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailCard(
                              context,
                              'Cuota',
                              currencyFormat.format(loan.installmentAmount),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildDetailCard(
                              context,
                              'Tasa',
                              '${loan.interestRate}% ${loan.interestRatePeriod.shortName}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Sección de notificación
                      Builder(
                        builder: (context) {
                          final isDark = Theme.of(context).brightness == Brightness.dark;
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                              ),
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.notifications_rounded,
                                      color: isNotificationEnabled
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      loan.type == LoanType.received
                                          ? 'Notificación de pago'
                                          : 'Notificación de cobro',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: isNotificationEnabled,
                                  onChanged: (value) async {
                                    Set<int> newDays = {};
                                    if (value) {
                                      // Si se activa, pedir los días
                                      final result = await showDialog<Set<int>>(
                                        context: context,
                                        builder: (dialogContext) {
                                          Set<int> tempDays = Set.from(currentNotificationDays);
                                          return StatefulBuilder(
                                            builder: (context, setDialogState) {
                                              return AlertDialog(
                                                title: Text(loan.type == LoanType.received
                                                    ? 'Días de pago'
                                                    : 'Días de cobro'),
                                                content: SizedBox(
                                                  width: double.maxFinite,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(loan.type == LoanType.received
                                                            ? 'Selecciona los días del mes para recordarte el pago:'
                                                            : 'Selecciona los días del mes para recordarte el cobro:'),
                                                        const SizedBox(height: 16),
                                                        Wrap(
                                                          spacing: 8,
                                                          runSpacing: 8,
                                                          children: List.generate(31, (index) {
                                                            final day = index + 1;
                                                            final isSelected = tempDays.contains(day);
                                                            return FilterChip(
                                                              label: Text('$day'),
                                                              selected: isSelected,
                                                              onSelected: (selected) {
                                                                setDialogState(() {
                                                                  if (selected) {
                                                                    tempDays.add(day);
                                                                  } else {
                                                                    tempDays.remove(day);
                                                                  }
                                                                });
                                                              },
                                                            );
                                                          }),
                                                        ),
                                                        const SizedBox(height: 16),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () => Navigator.pop(dialogContext, null),
                                                              child: const Text('Cancelar'),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            ElevatedButton(
                                                              onPressed: () => Navigator.pop(dialogContext, tempDays),
                                                              child: const Text('Aceptar'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                      if (result != null && result.isNotEmpty) {
                                        newDays = result;
                                      } else {
                                        return; // Si canceló o no seleccionó nada, no activar
                                      }
                                    }
                                    
                                    // Actualizar el préstamo
                                    final updatedLoan = loan.copyWith(
                                      notificationDays: newDays.isNotEmpty 
                                          ? (newDays.toList()..sort()).join(',')
                                          : null,
                                    );
                                    await service.updateLoan(updatedLoan);
                                    
                                    setState(() {
                                      currentNotificationDays = newDays;
                                      isNotificationEnabled = newDays.isNotEmpty;
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (isNotificationEnabled) ...[
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () async {
                                  final result = await _showNotificationConfigDialog(
                                    context: context,
                                    frequency: loan.paymentFrequency,
                                    currentSelection: currentNotificationDays,
                                    isPayment: loan.type == LoanType.received,
                                    currentDayOfMonth: currentNotificationDayOfMonth,
                                    currentTime: currentNotificationTime,
                                  );
                                  if (result != null) {
                                    final updatedLoan = loan.copyWith(
                                      notificationDays: result.selection.isNotEmpty 
                                          ? (result.selection.toList()..sort()).join(',')
                                          : null,
                                      notificationDayOfMonth: result.dayOfMonth,
                                      notificationTime: result.time,
                                    );
                                    await service.updateLoan(updatedLoan);
                                    setState(() {
                                      currentNotificationDays = result.selection;
                                      currentNotificationDayOfMonth = result.dayOfMonth;
                                      currentNotificationTime = result.time;
                                      isNotificationEnabled = result.selection.isNotEmpty;
                                    });
                                  }
                                },
                                child: Builder(
                                  builder: (context) {
                                    final isDark = Theme.of(context).brightness == Brightness.dark;
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                                        ),
                                      ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _formatNotificationDisplay(
                                            currentNotificationDays, 
                                            loan.paymentFrequency,
                                            dayOfMonth: currentNotificationDayOfMonth,
                                            time: currentNotificationTime,
                                          ),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit_rounded,
                                        size: 18,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                );
                                  },
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 8),
                              Builder(
                                builder: (context) {
                                  final isDark = Theme.of(context).brightness == Brightness.dark;
                                  return Text(
                                    'Activa las notificaciones para recibir recordatorios',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      );
                        },
                      ),
                      const SizedBox(height: 20),
                  
                      Text(
                        'Tabla de amortización',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: amortization.length,
                          itemBuilder: (context, index) {
                            final entry = amortization[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: entry.isPaid
                                    ? Colors.green.withOpacity(0.1)
                                    : (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: entry.isPaid
                                    ? Border.all(color: Colors.green.shade200)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: entry.isPaid
                                        ? Colors.green
                                        : Colors.grey.shade300,
                                    child: entry.isPaid
                                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                                        : Text(
                                            '${entry.installmentNumber}',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('d MMM yyyy', 'es').format(entry.date),
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Capital: ${currencyFormat.format(entry.principalPortion)} | '
                                          'Interés: ${currencyFormat.format(entry.interestPortion)}',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(entry.installmentAmount),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDetailCard(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ========== HELPERS PARA NOTIFICACIONES DINÁMICAS ==========
  
  /// Nombres de días de la semana
  static const List<String> _weekDayNames = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];

  /// Nombres de meses
  static const List<String> _monthNames = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  /// Obtiene el texto de ayuda según la frecuencia
  String _getNotificationHelperText(PaymentFrequency frequency, bool isPayment) {
    final action = isPayment ? 'pago' : 'cobro';
    switch (frequency) {
      case PaymentFrequency.weekly:
      case PaymentFrequency.biweekly:
        return 'Selecciona días de la semana y hora para recordatorio de $action';
      case PaymentFrequency.monthly:
        return 'Selecciona días del mes y hora para recordatorio de $action';
      case PaymentFrequency.quarterly:
      case PaymentFrequency.yearly:
        return 'Selecciona mes, día y hora para recordatorio de $action';
      case PaymentFrequency.custom:
        return 'Configura tus recordatorios de $action';
    }
  }

  /// Formatea la visualización de las notificaciones según la frecuencia
  String _formatNotificationDisplay(Set<int> selection, PaymentFrequency frequency, {int? dayOfMonth, String? time}) {
    if (selection.isEmpty) return 'Sin notificación';
    
    final sorted = selection.toList()..sort();
    String result = '';
    
    switch (frequency) {
      case PaymentFrequency.weekly:
      case PaymentFrequency.biweekly:
        final dayNames = sorted.map((d) => d >= 1 && d <= 7 ? _weekDayNames[d - 1] : '$d').toList();
        result = dayNames.join(', ');
        break;
      case PaymentFrequency.quarterly:
      case PaymentFrequency.yearly:
        final monthNames = sorted.map((m) => m >= 1 && m <= 12 ? _monthNames[m - 1].substring(0, 3) : '$m').toList();
        result = monthNames.join(', ');
        if (dayOfMonth != null) {
          result += ' (día $dayOfMonth)';
        }
        break;
      case PaymentFrequency.monthly:
      case PaymentFrequency.custom:
        result = 'Días: ${sorted.join(", ")}';
    }
    
    if (time != null && time.isNotEmpty) {
      result += ' a las $time';
    }
    
    return result;
  }

  /// Diálogo completo de configuración de notificaciones
  Future<NotificationConfig?> _showNotificationConfigDialog({
    required BuildContext context,
    required PaymentFrequency frequency,
    required Set<int> currentSelection,
    required bool isPayment,
    int? currentDayOfMonth,
    String? currentTime,
  }) async {
    return showDialog<NotificationConfig>(
      context: context,
      builder: (dialogContext) {
        Set<int> tempSelection = Set.from(currentSelection);
        int? tempDayOfMonth = currentDayOfMonth;
        TimeOfDay tempTime = currentTime != null && currentTime.isNotEmpty
            ? TimeOfDay(
                hour: int.tryParse(currentTime.split(':')[0]) ?? 9,
                minute: int.tryParse(currentTime.split(':')[1]) ?? 0,
              )
            : const TimeOfDay(hour: 9, minute: 0);
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String title;
            String primaryLabel;
            bool needsDayOfMonth = frequency == PaymentFrequency.quarterly || 
                                   frequency == PaymentFrequency.yearly;
            
            switch (frequency) {
              case PaymentFrequency.weekly:
              case PaymentFrequency.biweekly:
                title = isPayment ? 'Configurar recordatorio de pago' : 'Configurar recordatorio de cobro';
                primaryLabel = 'Días de la semana:';
                break;
              case PaymentFrequency.quarterly:
              case PaymentFrequency.yearly:
                title = isPayment ? 'Configurar recordatorio de pago' : 'Configurar recordatorio de cobro';
                primaryLabel = frequency == PaymentFrequency.quarterly 
                    ? 'Meses del trimestre:' 
                    : 'Meses del año:';
                break;
              case PaymentFrequency.monthly:
              case PaymentFrequency.custom:
                title = isPayment ? 'Configurar recordatorio de pago' : 'Configurar recordatorio de cobro';
                primaryLabel = 'Días del mes:';
            }
            
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selector primario
                      Text(primaryLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildPrimarySelector(frequency, tempSelection, setDialogState),
                      
                      // Selector de día del mes (solo para trimestral/anual)
                      if (needsDayOfMonth && tempSelection.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text('Día del mes:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        _buildDayOfMonthDropdown(tempDayOfMonth, (value) {
                          setDialogState(() => tempDayOfMonth = value);
                        }),
                      ],
                      
                      // Selector de hora (siempre visible cuando hay selección)
                      if (tempSelection.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text('Hora de notificación:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: tempTime,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    alwaysUse24HourFormat: true,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setDialogState(() => tempTime = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Icon(Icons.access_time_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setDialogState(() {
                                tempSelection.clear();
                                tempDayOfMonth = null;
                              });
                            },
                            child: const Text('Limpiar'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final timeStr = '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}';
                              Navigator.pop(dialogContext, NotificationConfig(
                                selection: tempSelection,
                                dayOfMonth: tempDayOfMonth,
                                time: timeStr,
                              ));
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Construye el selector primario según la frecuencia
  Widget _buildPrimarySelector(PaymentFrequency frequency, Set<int> selection, StateSetter setState) {
    switch (frequency) {
      case PaymentFrequency.weekly:
      case PaymentFrequency.biweekly:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(7, (index) {
            final day = index + 1;
            final isSelected = selection.contains(day);
            return FilterChip(
              label: Text(_weekDayNames[index]),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selection.add(day);
                  } else {
                    selection.remove(day);
                  }
                });
              },
            );
          }),
        );
      case PaymentFrequency.quarterly:
      case PaymentFrequency.yearly:
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(12, (index) {
            final month = index + 1;
            final isSelected = selection.contains(month);
            return FilterChip(
              label: Text(_monthNames[index].substring(0, 3)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selection.add(month);
                  } else {
                    selection.remove(month);
                  }
                });
              },
            );
          }),
        );
      case PaymentFrequency.monthly:
      case PaymentFrequency.custom:
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(31, (index) {
            final day = index + 1;
            final isSelected = selection.contains(day);
            return FilterChip(
              label: Text('$day'),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selection.add(day);
                  } else {
                    selection.remove(day);
                  }
                });
              },
            );
          }),
        );
    }
  }

  /// Dropdown para seleccionar día del mes
  Widget _buildDayOfMonthDropdown(int? currentValue, ValueChanged<int?> onChanged) {
    return DropdownButtonFormField<int>(
      value: currentValue,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        hintText: 'Selecciona el día',
      ),
      items: List.generate(28, (index) {
        final day = index + 1;
        return DropdownMenuItem(
          value: day,
          child: Text('Día $day'),
        );
      }),
      onChanged: onChanged,
    );
  }
}

/// Clase para almacenar la configuración de notificación
class NotificationConfig {
  final Set<int> selection;
  final int? dayOfMonth;
  final String? time;

  NotificationConfig({
    required this.selection,
    this.dayOfMonth,
    this.time,
  });
}

