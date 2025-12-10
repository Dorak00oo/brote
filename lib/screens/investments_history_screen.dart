import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/investment.dart';
import '../main.dart';

class InvestmentsHistoryScreen extends StatelessWidget {
  const InvestmentsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceService>(
        builder: (context, service, _) {
          final completedInvestments = service.investments
              .where((inv) => inv.status == InvestmentStatus.sold ||
                             inv.status == InvestmentStatus.cancelled)
              .toList();

          if (completedInvestments.isEmpty) {
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
                    'No hay inversiones completadas',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Las inversiones vendidas aparecerán aquí',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          final currencyFormat = NumberFormat.currency(
            locale: 'es_MX',
            symbol: service.userSettings.currencySymbol,
            decimalDigits: 0,
          );

          // Calcular totales
          final totalInvested = completedInvestments.fold<double>(
            0,
            (sum, inv) => sum + inv.initialAmount,
          );
          final totalReturned = completedInvestments.fold<double>(
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
                      '${completedInvestments.length}',
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

              // Lista de inversiones completadas
              ...completedInvestments.map((investment) {
                final profit = (investment.soldAmount ?? investment.currentValue) -
                    investment.initialAmount;
                final profitPercentage = investment.initialAmount > 0
                    ? (profit / investment.initialAmount) * 100
                    : 0.0;
                final isProfit = profit >= 0;
                final statusText = investment.status == InvestmentStatus.sold
                    ? 'Vendida'
                    : 'Cancelada';

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
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
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(
                              investment.soldAmount ?? investment.currentValue),
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
                  ),
                );
              }),
            ],
          );
        },
      );
  }
}

