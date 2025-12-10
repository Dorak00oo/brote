import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../main.dart';

class SavingsHistoryScreen extends StatelessWidget {
  const SavingsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceService>(
        builder: (context, service, _) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getAllContributions(service),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final contributions = snapshot.data!;
              if (contributions.isEmpty) {
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
                        'No hay contribuciones registradas',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Las contribuciones aparecerán aquí',
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

              // Agrupar por meta
              final groupedByGoal = <String, List<Map<String, dynamic>>>{};
              for (final contribution in contributions) {
                final goalName = contribution['goalName'] as String;
                if (!groupedByGoal.containsKey(goalName)) {
                  groupedByGoal[goalName] = [];
                }
                groupedByGoal[goalName]!.add(contribution);
              }

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
                              'Total de contribuciones',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${contributions.length}',
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(
                            contributions.fold<double>(0, (sum, c) => sum + (c['amount'] as double)),
                          ),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Historial agrupado por meta
                  ...groupedByGoal.entries.map((entry) {
                    final goalName = entry.key;
                    final goalContributions = entry.value;
                    final totalForGoal = goalContributions.fold<double>(
                      0,
                      (sum, c) => sum + (c['amount'] as double),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.savings_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.savings,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                goalName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const Spacer(),
                              Text(
                                currencyFormat.format(totalForGoal),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.savings,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...goalContributions.map((contribution) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.savings.withOpacity(0.2),
                                child: Icon(
                                  Icons.add_rounded,
                                  color: Theme.of(context).colorScheme.savings,
                                ),
                              ),
                              title: Text(
                                currencyFormat.format(contribution['amount'] as double),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.savings,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('EEEE, d MMMM yyyy', 'es')
                                    .format(contribution['date'] as DateTime),
                              ),
                              trailing: Text(
                                DateFormat('HH:mm', 'es')
                                    .format(contribution['date'] as DateTime),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),
                ],
              );
            },
          );
        },
      );
  }

  Future<List<Map<String, dynamic>>> _getAllContributions(FinanceService service) async {
    final allContributions = <Map<String, dynamic>>[];
    for (final goal in service.savingsGoals) {
      final contributions = await service.getSavingsContributions(goal.id);
      for (final contribution in contributions) {
        allContributions.add({
          'goalName': goal.name,
          'amount': contribution.amount,
          'date': contribution.date,
        });
      }
    }
    // Ordenar por fecha descendente
    allContributions.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));
    return allContributions;
  }
}

