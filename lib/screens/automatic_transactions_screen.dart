import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../database/app_database.dart' as db;
import '../main.dart';
import 'add_automatic_transaction_screen.dart';

class AutomaticTransactionsScreen extends StatelessWidget {
  const AutomaticTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresos y pagos automáticos'),
      ),
      body: Consumer<FinanceService>(
        builder: (context, service, _) {
          return StreamBuilder<List<db.RecurringTransaction>>(
            stream: service.watchRecurringTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final automatics = snapshot.data ?? [];
              final incomes = automatics
                  .where((a) => a.type == 'income')
                  .toList();
              final expenses = automatics
                  .where((a) => a.type == 'expense')
                  .toList();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Sección de Ingresos
                  _buildSection(
                    context,
                    'Ingresos automáticos',
                    incomes,
                    service,
                    Icons.arrow_downward_rounded,
                    Theme.of(context).colorScheme.income,
                  ),
                  const SizedBox(height: 24),
                  // Sección de Gastos
                  _buildSection(
                    context,
                    'Pagos automáticos',
                    expenses,
                    service,
                    Icons.arrow_upward_rounded,
                    Theme.of(context).colorScheme.expense,
                  ),
                  const SizedBox(height: 100),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'automatic_transactions_fab',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddAutomaticTransactionScreen(),
          ),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Agregar automático'),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<db.RecurringTransaction> automatics,
    FinanceService service,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${automatics.length}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (automatics.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No hay ${title.toLowerCase()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Agrega uno nuevo para comenzar',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          ...automatics.map((automatic) => _buildAutomaticCard(
                context,
                automatic,
                service,
                color,
              )),
      ],
    );
  }

  Widget _buildAutomaticCard(
    BuildContext context,
    db.RecurringTransaction automatic,
    FinanceService service,
    Color color,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 2,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade700
              : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddAutomaticTransactionScreen(
              automatic: automatic,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
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
                child: Icon(
                  automatic.type == 'income'
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      automatic.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getFrequencyText(automatic.frequency, automatic),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                    ),
                    if (automatic.description != null &&
                        automatic.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        automatic.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[500]
                                  : Colors.grey[500],
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(automatic.amount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        automatic.notificationsEnabled
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_rounded,
                        size: 16,
                        color: automatic.notificationsEnabled
                            ? color
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: automatic.isActive
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          automatic.isActive ? 'Activo' : 'Inactivo',
                          style: TextStyle(
                            color: automatic.isActive
                                ? Colors.green
                                : Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[500]
                    : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFrequencyText(String frequency, db.RecurringTransaction automatic) {
    switch (frequency) {
      case 'weekly':
        if (automatic.dayOfWeek != null) {
          final days = [
            'Lunes',
            'Martes',
            'Miércoles',
            'Jueves',
            'Viernes',
            'Sábado',
            'Domingo'
          ];
          return 'Cada ${days[automatic.dayOfWeek! - 1]}';
        }
        return 'Semanal';
      case 'biweekly':
        return 'Quincenal';
      case 'monthly':
        if (automatic.dayOfMonth != null) {
          return 'Día ${automatic.dayOfMonth} de cada mes';
        }
        return 'Mensual';
      case 'quarterly':
        return 'Trimestral';
      case 'yearly':
        return 'Anual';
      default:
        return frequency;
    }
  }
}

