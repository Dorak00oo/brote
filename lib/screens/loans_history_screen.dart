import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/loan.dart';
import '../main.dart';

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

enum LoansHistorySortType {
  recent,
  oldest,
  valueHigh,
  valueLow,
}

class LoansHistoryScreen extends StatefulWidget {
  final LoanType? loanType;

  const LoansHistoryScreen({super.key, this.loanType});

  @override
  State<LoansHistoryScreen> createState() => _LoansHistoryScreenState();
}

class _LoansHistoryScreenState extends State<LoansHistoryScreen> {
  LoansHistorySortType _sortType = LoansHistorySortType.recent;

  List<Loan> _getSortedLoans(List<Loan> loans) {
    final sorted = List<Loan>.from(loans);
    switch (_sortType) {
      case LoansHistorySortType.recent:
        sorted.sort((a, b) {
          final aDate = a.endDate ?? a.startDate;
          final bDate = b.endDate ?? b.startDate;
          return bDate.compareTo(aDate);
        });
        break;
      case LoansHistorySortType.oldest:
        sorted.sort((a, b) {
          final aDate = a.endDate ?? a.startDate;
          final bDate = b.endDate ?? b.startDate;
          return aDate.compareTo(bDate);
        });
        break;
      case LoansHistorySortType.valueHigh:
        sorted.sort((a, b) => b.principalAmount.compareTo(a.principalAmount));
        break;
      case LoansHistorySortType.valueLow:
        sorted.sort((a, b) => a.principalAmount.compareTo(b.principalAmount));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FinanceService>(
      builder: (context, service, _) {
        final loans = widget.loanType == null
            ? service.loans
            : widget.loanType == LoanType.received
                ? service.loansReceived
                : service.loansGiven;

        final completedLoans = loans.where((l) => l.status == LoanStatus.paidOff).toList();

        if (completedLoans.isEmpty) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  'No tienes préstamos completados',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Cuando termines de pagar o cobrar un préstamo, aparecerá aquí en tu historial',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
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
        final totalPaid = completedLoans.fold<double>(
          0,
          (sum, loan) => sum + loan.principalAmount,
        );

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Resumen
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.loan,
                    Theme.of(context).colorScheme.loan.withOpacity(0.8),
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
                        'Préstamos completados',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${completedLoans.length}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(totalPaid),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
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
                  'Préstamos completados',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                PopupMenuButton<LoansHistorySortType>(
                  icon: const Icon(Icons.sort_rounded),
                  onSelected: (value) {
                    setState(() {
                      _sortType = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: LoansHistorySortType.recent,
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Más recientes'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: LoansHistorySortType.oldest,
                      child: Row(
                        children: [
                          Icon(Icons.history_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Más antiguos'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: LoansHistorySortType.valueHigh,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_downward_rounded, size: 18),
                          SizedBox(width: 8),
                          Text('Mayor valor'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: LoansHistorySortType.valueLow,
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
            ..._getSortedLoans(completedLoans).map((loan) => _buildLoanCard(context, loan, service)),

            const SizedBox(height: 80),
          ],
        );
      },
    );
  }

  Widget _buildLoanCard(BuildContext context, Loan loan, FinanceService service) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    final iconOption = getLoanIconById(loan.iconName);
    final cardColor = loan.color != null
        ? Color(int.parse(loan.color!.substring(1), radix: 16) + 0xFF000000)
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
            Icons.check_circle_rounded,
            color: cardColor,
            size: 28,
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
            if (loan.borrowerOrLender != null) ...[
              Text(
                loan.type == LoanType.received
                    ? 'Prestado por: ${loan.borrowerOrLender}'
                    : 'Prestado a: ${loan.borrowerOrLender}',
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Monto total: ${currencyFormat.format(loan.principalAmount)}',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${loan.totalInstallments} cuotas pagadas',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
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
                  title: const Text('Reactivar préstamo'),
                  content: const Text('¿Deseas reactivar este préstamo?'),
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
                final service = context.read<FinanceService>();
                await service.reactivateLoan(loan.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Préstamo reactivado')),
                  );
                }
              }
            } else if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar préstamo'),
                  content: const Text('¿Estás seguro de eliminar este préstamo? Esta acción no se puede deshacer.'),
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
                final service = context.read<FinanceService>();
                await service.deleteLoan(loan.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Préstamo eliminado')),
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
      ),
    );
  }
}

