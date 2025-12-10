import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/investment.dart';
import '../widgets/notification_config_dialog.dart';
import 'investments_history_with_completed_screen.dart';
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

  static String removeFormatting(String formattedText,
      String thousandsSeparator, String decimalSeparator) {
    return formattedText
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.');
  }
}

/// Opciones de iconos para inversiones con sus colores asociados
class InvestmentIconOption {
  final String id;
  final IconData icon;
  final Color color;
  final String label;

  const InvestmentIconOption({
    required this.id,
    required this.icon,
    required this.color,
    required this.label,
  });
}

final List<InvestmentIconOption> investmentIconOptions = [
  InvestmentIconOption(
    id: 'stocks',
    icon: Icons.show_chart_rounded,
    color: const Color(0xFF1E88E5),
    label: 'Acciones',
  ),
  InvestmentIconOption(
    id: 'crypto',
    icon: Icons.currency_bitcoin_rounded,
    color: const Color(0xFFF7931A),
    label: 'Crypto',
  ),
  InvestmentIconOption(
    id: 'bonds',
    icon: Icons.account_balance_rounded,
    color: const Color(0xFF5C6BC0),
    label: 'Bonos',
  ),
  InvestmentIconOption(
    id: 'realEstate',
    icon: Icons.home_work_rounded,
    color: const Color(0xFF43A047),
    label: 'Inmuebles',
  ),
  InvestmentIconOption(
    id: 'funds',
    icon: Icons.pie_chart_rounded,
    color: const Color(0xFF8E24AA),
    label: 'Fondos',
  ),
  InvestmentIconOption(
    id: 'etf',
    icon: Icons.analytics_rounded,
    color: const Color(0xFF00ACC1),
    label: 'ETFs',
  ),
  InvestmentIconOption(
    id: 'forex',
    icon: Icons.currency_exchange_rounded,
    color: const Color(0xFF00897B),
    label: 'Divisas',
  ),
  InvestmentIconOption(
    id: 'commodities',
    icon: Icons.diamond_rounded,
    color: const Color(0xFFFFB300),
    label: 'Oro/Mat.',
  ),
  InvestmentIconOption(
    id: 'savings',
    icon: Icons.savings_rounded,
    color: const Color(0xFF2E7D32),
    label: 'Ahorro',
  ),
  InvestmentIconOption(
    id: 'business',
    icon: Icons.storefront_rounded,
    color: const Color(0xFFD84315),
    label: 'Negocio',
  ),
];

InvestmentIconOption getInvestmentIconById(String? id) {
  return investmentIconOptions.firstWhere(
    (icon) => icon.id == id,
    orElse: () => investmentIconOptions.first,
  );
}

class InvestmentsScreen extends StatefulWidget {
  const InvestmentsScreen({super.key});

  @override
  State<InvestmentsScreen> createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Inversiones'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Activas'),
            Tab(text: 'Historial'),
          ],
        ),
      ),
      body: Consumer<FinanceService>(
        builder: (context, service, _) {
          if (service.investments.isEmpty) {
            return _buildEmptyState(context);
          }

          final activeInvestments = service.investments
              .where((inv) => inv.status == InvestmentStatus.active)
              .toList();
          final completedInvestments = service.investments
              .where((inv) => inv.status == InvestmentStatus.sold || 
                             inv.status == InvestmentStatus.cancelled)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab Activas
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummaryCard(context, service),
                  const SizedBox(height: 24),
                  _buildInvestmentsByType(context, service),
                  const SizedBox(height: 24),
                  if (activeInvestments.isNotEmpty) ...[
                    Text(
                      'Inversiones activas',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...activeInvestments
                        .map((inv) => _buildInvestmentCard(context, inv, service)),
                  ] else ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(
                              Icons.trending_up_rounded,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay inversiones activas',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
              // Tab Historial (incluye completadas)
              InvestmentsHistoryWithCompletedScreen(
                completedInvestments: completedInvestments,
                service: service,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'investments_fab',
        onPressed: () => _showAddInvestmentDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva inversión'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.investment.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.trending_up_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.investment,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes inversiones',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Registra tus inversiones para\ndar seguimiento a tu portafolio',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddInvestmentDialog(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Agregar inversión'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, FinanceService service) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    final returnAmount = service.totalInvestmentReturn;
    final returnPercentage = service.totalInvestedAmount > 0
        ? (returnAmount / service.totalInvestedAmount) * 100
        : 0.0;
    final isPositive = returnAmount >= 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.investment,
            Theme.of(context).colorScheme.investment.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Portafolio',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currencyFormat.format(service.totalInvestmentsValue),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPositive ? '+' : ''}${currencyFormat.format(returnAmount)} (${returnPercentage.toStringAsFixed(1)}%)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invertido',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    Text(
                      currencyFormat.format(service.totalInvestedAmount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activas',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    Text(
                      '${service.activeInvestments.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentsByType(BuildContext context, FinanceService service) {
    final byType = service.getInvestmentsByType();
    if (byType.isEmpty) return const SizedBox.shrink();

    final total = byType.values.fold<double>(0, (a, b) => a + b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por tipo',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: byType.entries.map((entry) {
                  final percentage = (entry.value / total) * 100;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(entry.key),
                        ),
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              minHeight: 8,
                              backgroundColor: isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.investment,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInvestmentCard(
    BuildContext context,
    Investment investment,
    FinanceService service,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 2,
    );

    final isActive = investment.status == InvestmentStatus.active;
    final isProfit = investment.isProfit;
    final returnColor = isProfit ? Colors.green : Colors.red;

    // Obtener el icono y color personalizado o usar el predeterminado
    final iconOption = getInvestmentIconById(investment.iconName);
    final cardColor = investment.color != null
        ? Color(
            int.parse(investment.color!.substring(1), radix: 16) + 0xFF000000)
        : iconOption.color;

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
      child: ListTile(
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
          investment.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(_getInvestmentTypeName(investment.type)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  currencyFormat.format(investment.currentValue),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: returnColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${isProfit ? '+' : ''}${investment.percentageReturn.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: returnColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: isActive
            ? PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    _showEditInvestmentDialog(context, investment, service);
                  } else if (value == 'update') {
                    _showUpdateValueDialog(context, investment, service);
                  } else if (value == 'sell') {
                    _showSellDialog(context, investment, service);
                  } else if (value == 'notification') {
                    _showNotificationDialog(context, investment, service);
                  } else if (value == 'delete') {
                    await service.deleteInvestment(investment.id);
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
                    value: 'update',
                    child: Text('Actualizar valor'),
                  ),
                  const PopupMenuItem(
                    value: 'sell',
                    child: Text('Vender'),
                  ),
                  const PopupMenuItem(
                    value: 'notification',
                    child: Row(
                      children: [
                        Icon(Icons.notifications_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Notificaciones'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child:
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              )
            : Builder(
                builder: (context) {
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Vendida'),
                  );
                },
              ),
      ),
    );
  }

  String _getInvestmentTypeName(InvestmentType type) {
    switch (type) {
      case InvestmentType.stocks:
        return 'Acciones';
      case InvestmentType.bonds:
        return 'Bonos';
      case InvestmentType.crypto:
        return 'Criptomonedas';
      case InvestmentType.realEstate:
        return 'Bienes Raíces';
      case InvestmentType.mutualFunds:
        return 'Fondos Mutuos';
      case InvestmentType.etf:
        return 'ETFs';
      case InvestmentType.forex:
        return 'Divisas';
      case InvestmentType.commodities:
        return 'Materias Primas';
      case InvestmentType.savings:
        return 'Cuenta de Ahorro';
      default:
        return 'Otros';
    }
  }

  void _showAddInvestmentDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final amountController = TextEditingController();
    final returnRateController = TextEditingController(text: '10');
    InvestmentType selectedType = InvestmentType.stocks;
    InvestmentIconOption selectedIcon = investmentIconOptions.first;
    InterestRatePeriod ratePeriod =
        InterestRatePeriod.yearly; // Anual por defecto
    DateTime purchaseDate = DateTime.now();
    Set<int> notificationDays = {};
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
                      'Nueva inversión',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),

                    // Selector de icono
                    Text(
                      'Elige un icono',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: investmentIconOptions.length,
                        itemBuilder: (context, index) {
                          final iconOption = investmentIconOptions[index];
                          final isSelected = selectedIcon.id == iconOption.id;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedIcon = iconOption),
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? iconOption.color.withOpacity(0.15)
                                    : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: iconOption.color, width: 2)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    iconOption.icon,
                                    color: isSelected
                                        ? iconOption.color
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    iconOption.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? iconOption.color
                                          : (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[400]
                                              : Colors.grey[600]),
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

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        hintText: 'Ej: Acciones Apple, Bitcoin...',
                        prefixIcon: Icon(Icons.edit_rounded),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<InvestmentType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo',
                        prefixIcon: Icon(Icons.category_rounded),
                      ),
                      items: InvestmentType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getInvestmentTypeName(type)),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedType = v!),
                    ),
                    const SizedBox(height: 16),
                    Consumer<FinanceService>(
                      builder: (context, service, _) {
                        final settings = service.userSettings;
                        return TextFormField(
                          controller: amountController,
                          decoration: const InputDecoration(
                            labelText: 'Monto invertido',
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            NumberFormatInputFormatter(
                              thousandsSeparator: settings.thousandsSeparator,
                              decimalSeparator: settings.decimalSeparator,
                            ),
                          ],
                          validator: (v) =>
                              v?.isEmpty ?? true ? 'Requerido' : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Rentabilidad esperada con selector de periodicidad
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: returnRateController,
                            decoration: const InputDecoration(
                              labelText: 'Rentabilidad (%)',
                              prefixIcon: Icon(Icons.percent_rounded),
                              suffixText: '%',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
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

                    // Fecha de compra/inversión
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: purchaseDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => purchaseDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de compra/inversión',
                          prefixIcon: Icon(Icons.calendar_today_rounded),
                        ),
                        child: Text(
                          DateFormat('d MMMM yyyy', 'es').format(purchaseDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de notificación
                    InkWell(
                      onTap: () async {
                        final result = await NotificationConfigDialog.show(
                          context: context,
                          title: 'Configurar recordatorio',
                          currentSelection: notificationDays,
                          currentTime: notificationTime,
                          helpText:
                              'Selecciona los días del mes para recibir recordatorios de inversión',
                        );
                        if (result != null) {
                          setState(() {
                            notificationDays = result.selection;
                            notificationTime = result.time;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Recordatorio de inversión (opcional)',
                          prefixIcon: Icon(Icons.notifications_rounded,
                              color: selectedIcon.color),
                          helperText:
                              'Selecciona días del mes y hora para recordatorio',
                        ),
                        child: Text(
                          notificationDays.isNotEmpty
                              ? NotificationConfigDialog.formatMonthDaysDisplay(
                                  notificationDays, notificationTime)
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
                            final cleanAmount =
                                NumberFormatInputFormatter.removeFormatting(
                              amountController.text,
                              settings.thousandsSeparator,
                              settings.decimalSeparator,
                            );
                            final amount = double.parse(cleanAmount);
                            final investment = Investment(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              name: nameController.text.trim(),
                              type: selectedType,
                              initialAmount: amount,
                              currentValue: amount,
                              expectedReturnRate:
                                  double.tryParse(returnRateController.text) ??
                                      10,
                              returnRatePeriod: ratePeriod,
                              purchaseDate: purchaseDate,
                              iconName: selectedIcon.id,
                              color:
                                  '#${selectedIcon.color.value.toRadixString(16).substring(2)}',
                              notificationDays: notificationDays.isNotEmpty
                                  ? (notificationDays.toList()..sort())
                                      .join(',')
                                  : null,
                              notificationTime: notificationTime,
                            );
                            await service.addInvestment(investment);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Inversión agregada')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedIcon.color,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Agregar inversión'),
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

  void _showEditInvestmentDialog(
    BuildContext context,
    Investment investment,
    FinanceService service,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: investment.name);
    final settings = service.userSettings;
    final formattedAmount =
        settings.formatNumber(investment.initialAmount, decimals: 0);
    final amountController = TextEditingController(text: formattedAmount);
    final returnRateController = TextEditingController(
        text: investment.expectedReturnRate.toStringAsFixed(2));
    InvestmentType selectedType = investment.type;
    InvestmentIconOption selectedIcon =
        getInvestmentIconById(investment.iconName);
    InterestRatePeriod ratePeriod = investment.returnRatePeriod;
    DateTime purchaseDate = investment.purchaseDate;
    Set<int> notificationDays = investment.notificationDaysList.toSet();
    String? notificationTime = investment.notificationTime;

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
                      'Editar inversión',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),

                    // Selector de icono
                    Text(
                      'Elige un icono',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: investmentIconOptions.length,
                        itemBuilder: (context, index) {
                          final iconOption = investmentIconOptions[index];
                          final isSelected = selectedIcon.id == iconOption.id;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedIcon = iconOption),
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? iconOption.color.withOpacity(0.15)
                                    : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: iconOption.color, width: 2)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    iconOption.icon,
                                    color: isSelected
                                        ? iconOption.color
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    iconOption.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? iconOption.color
                                          : (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[400]
                                              : Colors.grey[600]),
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

                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: Icon(Icons.edit_rounded),
                      ),
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<InvestmentType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo',
                        prefixIcon: Icon(Icons.category_rounded),
                      ),
                      items: InvestmentType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getInvestmentTypeName(type)),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => selectedType = v!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountController,
                      decoration: const InputDecoration(
                        labelText: 'Monto invertido',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        NumberFormatInputFormatter(
                          thousandsSeparator: settings.thousandsSeparator,
                          decimalSeparator: settings.decimalSeparator,
                        ),
                      ],
                      validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
                    ),
                    const SizedBox(height: 16),

                    // Rentabilidad esperada con selector de periodicidad
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: returnRateController,
                            decoration: const InputDecoration(
                              labelText: 'Rentabilidad (%)',
                              prefixIcon: Icon(Icons.percent_rounded),
                              suffixText: '%',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
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

                    // Fecha de compra/inversión
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: purchaseDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => purchaseDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de compra/inversión',
                          prefixIcon: Icon(Icons.calendar_today_rounded),
                        ),
                        child: Text(
                          DateFormat('d MMMM yyyy', 'es').format(purchaseDate),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo de notificación
                    InkWell(
                      onTap: () async {
                        final result = await NotificationConfigDialog.show(
                          context: context,
                          title: 'Configurar recordatorio',
                          currentSelection: notificationDays,
                          currentTime: notificationTime,
                          helpText:
                              'Selecciona los días del mes para recibir recordatorios de inversión',
                        );
                        if (result != null) {
                          setState(() {
                            notificationDays = result.selection;
                            notificationTime = result.time;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Recordatorio de inversión (opcional)',
                          prefixIcon: Icon(Icons.notifications_rounded,
                              color: selectedIcon.color),
                          helperText:
                              'Selecciona días del mes y hora para recordatorio',
                        ),
                        child: Text(
                          notificationDays.isNotEmpty
                              ? NotificationConfigDialog.formatMonthDaysDisplay(
                                  notificationDays, notificationTime)
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
                            final cleanAmount =
                                NumberFormatInputFormatter.removeFormatting(
                              amountController.text,
                              settings.thousandsSeparator,
                              settings.decimalSeparator,
                            );
                            final amount = double.parse(cleanAmount);
                            final updatedInvestment = investment.copyWith(
                              name: nameController.text.trim(),
                              type: selectedType,
                              initialAmount: amount,
                              expectedReturnRate:
                                  double.tryParse(returnRateController.text) ??
                                      investment.expectedReturnRate,
                              returnRatePeriod: ratePeriod,
                              purchaseDate: purchaseDate,
                              iconName: selectedIcon.id,
                              color:
                                  '#${selectedIcon.color.value.toRadixString(16).substring(2)}',
                              notificationDays: notificationDays.isNotEmpty
                                  ? (notificationDays.toList()..sort())
                                      .join(',')
                                  : null,
                              notificationTime: notificationTime,
                            );
                            await service.updateInvestment(updatedInvestment);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Inversión actualizada')),
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

  void _showUpdateValueDialog(
    BuildContext context,
    Investment investment,
    FinanceService service,
  ) {
    final settings = service.userSettings;
    final formattedValue =
        settings.formatNumber(investment.currentValue, decimals: 0);
    final controller = TextEditingController(text: formattedValue);

    // Obtener icono y color de la inversión
    final iconOption = getInvestmentIconById(investment.iconName);
    final investmentColor = investment.color != null
        ? Color(
            int.parse(investment.color!.substring(1), radix: 16) + 0xFF000000)
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
                    color: investmentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(iconOption.icon, color: investmentColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actualizar valor',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        investment.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Valor actual',
                prefixIcon:
                    Icon(Icons.attach_money_rounded, color: investmentColor),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                  final formattedAmount =
                      settings.formatNumber(amount.toDouble(), decimals: 0);
                  return ActionChip(
                    label: Text('${settings.currencySymbol}$formattedAmount'),
                    backgroundColor: investmentColor.withOpacity(0.1),
                    onPressed: () {
                      controller.text = formattedAmount;
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
                  backgroundColor: investmentColor.withOpacity(0.1),
                  onPressed: () {
                    // El campo ya está disponible para escribir
                    controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.text.length,
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
                  backgroundColor: investmentColor,
                ),
                onPressed: () async {
                  final cleanValue =
                      NumberFormatInputFormatter.removeFormatting(
                    controller.text,
                    settings.thousandsSeparator,
                    settings.decimalSeparator,
                  );
                  final value = double.tryParse(cleanValue);
                  if (value != null) {
                    await service.updateInvestmentValue(investment.id, value);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Valor actualizado')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ingresa un valor válido'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Actualizar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellDialog(
    BuildContext context,
    Investment investment,
    FinanceService service,
  ) {
    final settings = service.userSettings;
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: settings.currencySymbol,
      decimalDigits: 2,
    );
    final formattedValue =
        settings.formatNumber(investment.currentValue, decimals: 0);
    final controller = TextEditingController(text: formattedValue);

    // Obtener icono y color de la inversión
    final iconOption = getInvestmentIconById(investment.iconName);
    final investmentColor = investment.color != null
        ? Color(
            int.parse(investment.color!.substring(1), radix: 16) + 0xFF000000)
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
                    color: investmentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(iconOption.icon, color: investmentColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vender inversión',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        investment.name,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
              'Valor actual: ${currencyFormat.format(investment.currentValue)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Monto de venta',
                prefixIcon:
                    Icon(Icons.attach_money_rounded, color: investmentColor),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                  final formattedAmount =
                      settings.formatNumber(amount.toDouble(), decimals: 0);
                  return ActionChip(
                    label: Text('${settings.currencySymbol}$formattedAmount'),
                    backgroundColor: investmentColor.withOpacity(0.1),
                    onPressed: () {
                      controller.text = formattedAmount;
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
                  backgroundColor: investmentColor.withOpacity(0.1),
                  onPressed: () {
                    // El campo ya está disponible para escribir
                    controller.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller.text.length,
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
                  backgroundColor: investmentColor,
                ),
                onPressed: () async {
                  final cleanValue =
                      NumberFormatInputFormatter.removeFormatting(
                    controller.text,
                    settings.thousandsSeparator,
                    settings.decimalSeparator,
                  );
                  final value = double.tryParse(cleanValue);
                  if (value != null && value > 0) {
                    await service.sellInvestment(investment.id, value);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inversión vendida')),
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
                child: const Text('Vender'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDialog(
    BuildContext context,
    Investment investment,
    FinanceService service,
  ) {
    Set<int> currentNotificationDays = investment.notificationDaysList.toSet();
    String? currentNotificationTime = investment.notificationTime;
    bool isNotificationEnabled = currentNotificationDays.isNotEmpty;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Notificaciones de inversión'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Activar notificaciones'),
                    Switch(
                      value: isNotificationEnabled,
                      onChanged: (value) async {
                        if (value) {
                          // Si se activa, mostrar el diálogo de configuración
                          final result = await NotificationConfigDialog.show(
                            context: context,
                            title: 'Configurar recordatorio',
                            currentSelection: currentNotificationDays,
                            currentTime: currentNotificationTime,
                            helpText:
                                'Selecciona los días del mes para recibir recordatorios de inversión',
                          );
                          if (result != null && result.isNotEmpty) {
                            final updatedInvestment = investment.copyWith(
                              notificationDays:
                                  (result.selection.toList()..sort()).join(','),
                              notificationTime: result.time,
                            );
                            await service.updateInvestment(updatedInvestment);
                            setState(() {
                              currentNotificationDays = result.selection;
                              currentNotificationTime = result.time;
                              isNotificationEnabled = true;
                            });
                          }
                        } else {
                          // Si se desactiva, limpiar notificaciones
                          final updatedInvestment = investment.copyWith(
                            notificationDays: null,
                            notificationTime: null,
                          );
                          await service.updateInvestment(updatedInvestment);
                          setState(() {
                            currentNotificationDays = {};
                            currentNotificationTime = null;
                            isNotificationEnabled = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
                if (isNotificationEnabled) ...[
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final result = await NotificationConfigDialog.show(
                        context: context,
                        title: 'Editar recordatorio',
                        currentSelection: currentNotificationDays,
                        currentTime: currentNotificationTime,
                        helpText:
                            'Selecciona los días del mes para recibir recordatorios de inversión',
                      );
                      if (result != null) {
                        final updatedInvestment = investment.copyWith(
                          notificationDays: result.isNotEmpty
                              ? (result.selection.toList()..sort()).join(',')
                              : null,
                          notificationTime: result.time,
                        );
                        await service.updateInvestment(updatedInvestment);
                        setState(() {
                          currentNotificationDays = result.selection;
                          currentNotificationTime = result.time;
                          isNotificationEnabled = result.isNotEmpty;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              NotificationConfigDialog.formatMonthDaysDisplay(
                                currentNotificationDays,
                                currentNotificationTime,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Icon(Icons.edit_rounded,
                              size: 18, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Text(
                    'Activa las notificaciones para recibir recordatorios',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      ),
    );
  }

}
