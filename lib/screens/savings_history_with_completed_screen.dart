import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/savings_goal.dart';
import '../main.dart';

enum SavingsHistorySortType {
  recent,
  oldest,
  valueHigh,
  valueLow,
}

class SavingsHistoryWithCompletedScreen extends StatefulWidget {
  final List<SavingsGoal> completedGoals;
  final FinanceService service;

  const SavingsHistoryWithCompletedScreen({
    super.key,
    required this.completedGoals,
    required this.service,
  });

  @override
  State<SavingsHistoryWithCompletedScreen> createState() => _SavingsHistoryWithCompletedScreenState();
}

class _SavingsHistoryWithCompletedScreenState extends State<SavingsHistoryWithCompletedScreen> {
  SavingsHistorySortType _sortType = SavingsHistorySortType.recent;

  List<SavingsGoal> _getSortedGoals() {
    final sorted = List<SavingsGoal>.from(widget.completedGoals);
    switch (_sortType) {
      case SavingsHistorySortType.recent:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SavingsHistorySortType.oldest:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SavingsHistorySortType.valueHigh:
        sorted.sort((a, b) => b.currentAmount.compareTo(a.currentAmount));
        break;
      case SavingsHistorySortType.valueLow:
        sorted.sort((a, b) => a.currentAmount.compareTo(b.currentAmount));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final hasCompleted = widget.completedGoals.isNotEmpty;

    if (!hasCompleted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay historial',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Las metas completadas aparecerán aquí',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: widget.service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    // Calcular totales
    final totalSaved = widget.completedGoals.fold<double>(
      0,
      (sum, goal) => sum + goal.currentAmount,
    );
    final totalTarget = widget.completedGoals.fold<double>(
      0,
      (sum, goal) => sum + goal.targetAmount,
    );

    final sortedGoals = _getSortedGoals();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Resumen
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.savings,
                Theme.of(context).colorScheme.savings.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Metas completadas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${widget.completedGoals.length}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                          'Total ahorrado',
                          style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                        Text(
                          currencyFormat.format(totalSaved),
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
                          'Total objetivo',
                          style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                        Text(
                          currencyFormat.format(totalTarget),
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
        ),
        const SizedBox(height: 24),

        // Selector de ordenamiento
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Metas completadas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            PopupMenuButton<SavingsHistorySortType>(
              icon: const Icon(Icons.sort_rounded),
              onSelected: (value) {
                setState(() {
                  _sortType = value;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: SavingsHistorySortType.recent,
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Más recientes'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: SavingsHistorySortType.oldest,
                  child: Row(
                    children: [
                      Icon(Icons.history_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Más antiguos'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: SavingsHistorySortType.valueHigh,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Mayor valor'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: SavingsHistorySortType.valueLow,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Menor valor'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...sortedGoals.map((goal) => _buildGoalCard(context, goal, widget.service)),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildGoalCard(
    BuildContext context,
    SavingsGoal goal,
    FinanceService service,
  ) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    final color = Theme.of(context).colorScheme.primary;

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
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: color,
                size: 28,
              ),
            ),
            title: Text(
              goal.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      currencyFormat.format(goal.currentAmount),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' / ${currencyFormat.format(goal.targetAmount)}',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progressPercentage / 100,
                    minHeight: 6,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade700
                        : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${goal.progressPercentage.toStringAsFixed(1)}% completado',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'reactivate') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reactivar meta'),
                      content: const Text('¿Deseas reactivar esta meta?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Reactivar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && mounted) {
                    await widget.service.reactivateSavingsGoal(goal.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Meta reactivada')),
                      );
                    }
                  }
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar meta'),
                      content: const Text('¿Estás seguro de eliminar esta meta? Esta acción no se puede deshacer.'),
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
                    await widget.service.deleteSavingsGoal(goal.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Meta eliminada')),
                      );
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'reactivate',
                  child: Row(
                    children: [
                      Icon(Icons.refresh_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Reactivar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () => _showGoalDetails(context, goal, widget.service),
          ),
        ],
      ),
    );
  }

  void _showGoalDetails(BuildContext context, SavingsGoal goal, FinanceService service) {
    // Usar el mismo método de detalles que en SavingsScreen
    // Necesitamos acceder al método privado, así que mejor lo copiamos aquí o hacemos público
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(goal.name),
        content: Text('Meta completada'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

