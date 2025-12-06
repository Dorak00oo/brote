import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/loan.dart';
import '../main.dart';
import 'savings_screen.dart';
import 'investments_screen.dart' show InvestmentsScreen, getInvestmentIconById;
import 'loans_screen.dart' show LoansScreen, getLoanIconById;

class FinanceHubScreen extends StatelessWidget {
  const FinanceHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Finanzas'),
      ),
      body: Consumer<FinanceService>(
        builder: (context, service, _) {
          final currencyFormat = NumberFormat.currency(
            locale: 'es_MX',
            symbol: service.userSettings.currencySymbol,
            decimalDigits: 0,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Resumen general
              _buildOverallSummary(context, service, currencyFormat),
              const SizedBox(height: 24),

              // Sección de Bolsillos
              _buildSectionCard(
                context,
                title: 'Bolsillos de Ahorro',
                icon: Icons.savings_rounded,
                color: Theme.of(context).colorScheme.savings,
                amount: service.totalSavings,
                subtitle: '${service.activeSavingsGoals.length} metas activas',
                currencyFormat: currencyFormat,
                onTap: () => _navigateToScreen(context, const SavingsScreen()),
                onAdd: () => _showAddOptions(context, 'savings'),
                items: _buildSavingsPreview(context, service, currencyFormat),
              ),
              const SizedBox(height: 16),

              // Sección de Inversiones
              _buildSectionCard(
                context,
                title: 'Inversiones',
                icon: Icons.trending_up_rounded,
                color: Theme.of(context).colorScheme.investment,
                amount: service.totalInvestmentsValue,
                subtitle:
                    '${service.activeInvestments.length} inversiones activas',
                currencyFormat: currencyFormat,
                onTap: () =>
                    _navigateToScreen(context, const InvestmentsScreen()),
                onAdd: () => _showAddOptions(context, 'investments'),
                items:
                    _buildInvestmentsPreview(context, service, currencyFormat),
                returnAmount: service.totalInvestmentReturn,
              ),
              const SizedBox(height: 16),

              // Sección de Préstamos
              _buildSectionCard(
                context,
                title: 'Préstamos',
                icon: Icons.account_balance_rounded,
                color: const Color(0xFF7E57C2),
                amount: service.totalReceivables - service.totalDebt,
                subtitle: _getLoansSubtitle(service),
                currencyFormat: currencyFormat,
                onTap: () => _navigateToScreen(context, const LoansScreen()),
                onAdd: () => _showAddOptions(context, 'loans'),
                items: _buildLoansPreview(context, service, currencyFormat),
                showNetIndicator: true,
              ),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'finance_hub_fab',
        onPressed: () => _showQuickAddMenu(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Agregar'),
      ),
    );
  }

  Widget _buildOverallSummary(
    BuildContext context,
    FinanceService service,
    NumberFormat currencyFormat,
  ) {
    final totalAssets = service.totalSavings +
        service.totalInvestmentsValue +
        service.totalReceivables;
    final totalLiabilities = service.totalDebt;
    final netWorth = totalAssets - totalLiabilities;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Patrimonio Total',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            currencyFormat.format(netWorth),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Activos',
                  currencyFormat.format(totalAssets),
                  Icons.arrow_upward_rounded,
                  Colors.white,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Deudas',
                  currencyFormat.format(totalLiabilities),
                  Icons.arrow_downward_rounded,
                  Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required double amount,
    required String subtitle,
    required NumberFormat currencyFormat,
    required VoidCallback onTap,
    required VoidCallback onAdd,
    required List<Widget> items,
    double? returnAmount,
    bool showNetIndicator = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onTap,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          if (showNetIndicator && amount != 0)
                            Icon(
                              amount >= 0
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              color: amount >= 0 ? Colors.green : Colors.red,
                              size: 16,
                            ),
                          Text(
                            currencyFormat.format(amount.abs()),
                            style: TextStyle(
                              color: showNetIndicator
                                  ? (amount >= 0 ? Colors.green : Colors.red)
                                  : color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      if (returnAmount != null)
                        Text(
                          '${returnAmount >= 0 ? '+' : ''}${currencyFormat.format(returnAmount)}',
                          style: TextStyle(
                            color:
                                returnAmount >= 0 ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
          // Items preview
          if (items.isNotEmpty) ...[
            Divider(
              height: 1,
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(children: items),
            ),
          ],
          // Add button
          Divider(
            height: 1,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
          ),
          InkWell(
            onTap: onAdd,
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_rounded, color: color, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    'Agregar',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSavingsPreview(
    BuildContext context,
    FinanceService service,
    NumberFormat currencyFormat,
  ) {
    final goals = service.activeSavingsGoals.take(3).toList();
    if (goals.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'No hay metas de ahorro activas',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[500],
              fontSize: 13,
            ),
          ),
        ),
      ];
    }

    return goals.map((goal) {
      final iconOption = getSavingsIconById(goal.iconName);
      final goalColor =
          goal.color != null ? getColorFromHex(goal.color) : iconOption.color;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: goalColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(iconOption.icon, color: goalColor, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: goal.progressPercentage / 100,
                      minHeight: 3,
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(goalColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${goal.progressPercentage.toStringAsFixed(0)}%',
              style: TextStyle(
                color: goalColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildInvestmentsPreview(
    BuildContext context,
    FinanceService service,
    NumberFormat currencyFormat,
  ) {
    final investments = service.activeInvestments.take(3).toList();
    if (investments.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'No hay inversiones activas',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[500],
              fontSize: 13,
            ),
          ),
        ),
      ];
    }

    return investments.map((inv) {
      final returnValue = inv.currentValue - inv.initialAmount;
      final returnPercent =
          inv.initialAmount > 0 ? (returnValue / inv.initialAmount) * 100 : 0.0;

      // Obtener icono y color personalizado
      final iconOption = getInvestmentIconById(inv.iconName);
      final invColor = inv.color != null
          ? Color(int.parse(inv.color!.substring(1), radix: 16) + 0xFF000000)
          : iconOption.color;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: invColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                iconOption.icon,
                color: invColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                inv.name,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${returnPercent >= 0 ? '+' : ''}${returnPercent.toStringAsFixed(1)}%',
              style: TextStyle(
                color: returnPercent >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildLoansPreview(
    BuildContext context,
    FinanceService service,
    NumberFormat currencyFormat,
  ) {
    // Por cobrar (yo presté dinero) - máximo 2
    final receivables = service.loans
        .where((l) => l.type == LoanType.given && l.status == LoanStatus.active)
        .take(2)
        .toList();
    // Por pagar (yo recibí dinero) - máximo 2
    final debts = service.loans
        .where(
            (l) => l.type == LoanType.received && l.status == LoanStatus.active)
        .take(2)
        .toList();

    if (receivables.isEmpty && debts.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'No hay préstamos activos',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[500],
              fontSize: 13,
            ),
          ),
        ),
      ];
    }

    final items = <Widget>[];

    for (final loan in receivables) {
      // Obtener icono y color personalizado
      final iconOption = getLoanIconById(loan.iconName);
      final loanColor = loan.color != null
          ? Color(int.parse(loan.color!.substring(1), radix: 16) + 0xFF000000)
          : iconOption.color;

      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: loanColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(iconOption.icon, color: loanColor, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.borrowerOrLender ?? loan.name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Por cobrar',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Text(
                currencyFormat.format(loan.remainingAmount),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    for (final loan in debts) {
      // Obtener icono y color personalizado
      final iconOption = getLoanIconById(loan.iconName);
      final loanColor = loan.color != null
          ? Color(int.parse(loan.color!.substring(1), radix: 16) + 0xFF000000)
          : iconOption.color;

      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: loanColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(iconOption.icon, color: loanColor, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.borrowerOrLender ?? loan.name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Por pagar',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Text(
                currencyFormat.format(loan.remainingAmount),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return items;
  }

  String _getLoansSubtitle(FinanceService service) {
    final receivablesCount = service.loans
        .where((l) => l.type == LoanType.given && l.status == LoanStatus.active)
        .length;
    final debtsCount = service.loans
        .where(
            (l) => l.type == LoanType.received && l.status == LoanStatus.active)
        .length;

    if (receivablesCount == 0 && debtsCount == 0) {
      return 'Sin préstamos activos';
    }

    final parts = <String>[];
    if (receivablesCount > 0) parts.add('$receivablesCount por cobrar');
    if (debtsCount > 0) parts.add('$debtsCount por pagar');
    return parts.join(' · ');
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showAddOptions(BuildContext context, String type) {
    switch (type) {
      case 'savings':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavingsScreen()),
        ).then((_) {
          // La pantalla de savings tiene su propio FAB para agregar
        });
        break;
      case 'investments':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InvestmentsScreen()),
        );
        break;
      case 'loans':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoansScreen()),
        );
        break;
    }
  }

  void _showQuickAddMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Qué deseas agregar?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _buildQuickAddOption(
              context,
              icon: Icons.savings_rounded,
              label: 'Nueva meta de ahorro',
              subtitle: 'Crea un bolsillo para ahorrar',
              color: Theme.of(context).colorScheme.savings,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SavingsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildQuickAddOption(
              context,
              icon: Icons.trending_up_rounded,
              label: 'Nueva inversión',
              subtitle: 'Registra una inversión',
              color: Theme.of(context).colorScheme.investment,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InvestmentsScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildQuickAddOption(
              context,
              icon: Icons.handshake_rounded,
              label: 'Nuevo préstamo',
              subtitle: 'Registra dinero prestado o por cobrar',
              color: const Color(0xFF5C6BC0),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoansScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAddOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: color),
          ],
        ),
      ),
    );
  }
}
