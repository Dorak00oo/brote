import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/investment.dart';
import '../main.dart';

enum InvestmentsHistorySortType {
  recent,
  oldest,
  valueHigh,
  valueLow,
  profitHigh,
  profitLow,
}

class InvestmentsHistoryWithCompletedScreen extends StatefulWidget {
  final List<Investment> completedInvestments;
  final FinanceService service;

  const InvestmentsHistoryWithCompletedScreen({
    super.key,
    required this.completedInvestments,
    required this.service,
  });

  @override
  State<InvestmentsHistoryWithCompletedScreen> createState() => _InvestmentsHistoryWithCompletedScreenState();
}

class _InvestmentsHistoryWithCompletedScreenState extends State<InvestmentsHistoryWithCompletedScreen> {
  InvestmentsHistorySortType _sortType = InvestmentsHistorySortType.recent;

  List<Investment> _getSortedInvestments() {
    final sorted = List<Investment>.from(widget.completedInvestments);
    switch (_sortType) {
      case InvestmentsHistorySortType.recent:
        sorted.sort((a, b) {
          final aDate = a.soldDate ?? a.purchaseDate;
          final bDate = b.soldDate ?? b.purchaseDate;
          return bDate.compareTo(aDate);
        });
        break;
      case InvestmentsHistorySortType.oldest:
        sorted.sort((a, b) {
          final aDate = a.soldDate ?? a.purchaseDate;
          final bDate = b.soldDate ?? b.purchaseDate;
          return aDate.compareTo(bDate);
        });
        break;
      case InvestmentsHistorySortType.valueHigh:
        sorted.sort((a, b) {
          final aValue = a.soldAmount ?? a.currentValue;
          final bValue = b.soldAmount ?? b.currentValue;
          return bValue.compareTo(aValue);
        });
        break;
      case InvestmentsHistorySortType.valueLow:
        sorted.sort((a, b) {
          final aValue = a.soldAmount ?? a.currentValue;
          final bValue = b.soldAmount ?? b.currentValue;
          return aValue.compareTo(bValue);
        });
        break;
      case InvestmentsHistorySortType.profitHigh:
        sorted.sort((a, b) {
          final aProfit = (a.soldAmount ?? a.currentValue) - a.initialAmount;
          final bProfit = (b.soldAmount ?? b.currentValue) - b.initialAmount;
          return bProfit.compareTo(aProfit);
        });
        break;
      case InvestmentsHistorySortType.profitLow:
        sorted.sort((a, b) {
          final aProfit = (a.soldAmount ?? a.currentValue) - a.initialAmount;
          final bProfit = (b.soldAmount ?? b.currentValue) - b.initialAmount;
          return aProfit.compareTo(bProfit);
        });
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final hasCompleted = widget.completedInvestments.isNotEmpty;

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
              'Las inversiones completadas aparecerán aquí',
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
    final totalInvested = widget.completedInvestments.fold<double>(
      0,
      (sum, inv) => sum + inv.initialAmount,
    );
    final totalReturned = widget.completedInvestments.fold<double>(
      0,
      (sum, inv) => sum + (inv.soldAmount ?? inv.currentValue),
    );
    final totalProfit = totalReturned - totalInvested;
    final totalProfitPercentage =
        totalInvested > 0 ? (totalProfit / totalInvested) * 100 : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Resumen
        Container(
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
                  const Icon(Icons.history_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Inversiones completadas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${widget.completedInvestments.length}',
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
                          'Total invertido',
                          style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                        Text(
                          currencyFormat.format(totalInvested),
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
                          'Total recuperado',
                          style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                        Text(
                          currencyFormat.format(totalReturned),
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
              const SizedBox(height: 12),
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
                      totalProfit >= 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${totalProfit >= 0 ? '+' : ''}${currencyFormat.format(totalProfit)} (${totalProfitPercentage.toStringAsFixed(1)}%)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
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
              'Inversiones completadas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            PopupMenuButton<InvestmentsHistorySortType>(
              icon: const Icon(Icons.sort_rounded),
              onSelected: (value) {
                setState(() {
                  _sortType = value;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: InvestmentsHistorySortType.recent,
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Más recientes'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: InvestmentsHistorySortType.oldest,
                  child: Row(
                    children: [
                      Icon(Icons.history_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Más antiguos'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: InvestmentsHistorySortType.valueHigh,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_downward_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Mayor valor'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: InvestmentsHistorySortType.valueLow,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_upward_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Menor valor'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: InvestmentsHistorySortType.profitHigh,
                  child: Row(
                    children: [
                      Icon(Icons.trending_up_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Mayor ganancia'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: InvestmentsHistorySortType.profitLow,
                  child: Row(
                    children: [
                      Icon(Icons.trending_down_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Menor ganancia'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._getSortedInvestments().map((investment) {
          return _buildInvestmentCard(context, investment, widget.service);
        }),

        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildInvestmentCard(
    BuildContext context,
    Investment investment,
    FinanceService service,
  ) {
    // Usar el mismo método de InvestmentsScreen
    // Necesitamos acceder al método, así que mejor lo copiamos aquí
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    final profit = (investment.soldAmount ?? investment.currentValue) -
        investment.initialAmount;
    final profitPercentage = investment.initialAmount > 0
        ? (profit / investment.initialAmount) * 100
        : 0.0;
    final isProfit = profit >= 0;
    final statusText = investment.status == InvestmentStatus.sold
        ? 'Vendida'
        : 'Cancelada';

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
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isProfit
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          radius: 28,
          child: Icon(
            isProfit ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            color: isProfit ? Colors.green : Colors.red,
            size: 28,
          ),
        ),
        title: Text(
          investment.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Estado: $statusText'),
            if (investment.soldDate != null)
              Text(
                'Fecha: ${DateFormat('d MMMM yyyy', 'es').format(investment.soldDate!)}',
              ),
            Text(
              'Invertido: ${currencyFormat.format(investment.initialAmount)}',
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(investment.soldAmount ?? investment.currentValue),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${isProfit ? '+' : ''}${currencyFormat.format(profit)}',
                  style: TextStyle(
                    color: isProfit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${profitPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isProfit ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'reactivate') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reactivar inversión'),
                      content: const Text('¿Deseas reactivar esta inversión?'),
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
                    await widget.service.reactivateInvestment(investment.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inversión reactivada')),
                      );
                    }
                  }
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar inversión'),
                      content: const Text('¿Estás seguro de eliminar esta inversión? Esta acción no se puede deshacer.'),
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
                    await widget.service.deleteInvestment(investment.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inversión eliminada')),
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
          ],
        ),
      ),
    );
  }
}

