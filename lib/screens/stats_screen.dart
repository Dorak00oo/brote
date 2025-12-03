import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/finance_service.dart';
import '../services/export_service.dart';
import '../models/transaction.dart';
import '../main.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

enum PeriodType {
  all,
  year,
  sixMonths,
  month,
  week,
  custom,
}

class _StatsScreenState extends State<StatsScreen> {
  PeriodType _selectedPeriod = PeriodType.month;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: Consumer<FinanceService>(
        builder: (context, service, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Selector de período
              _buildPeriodSelector(),
              const SizedBox(height: 20),

              // Resumen
              _buildSummaryCards(context, service),
              const SizedBox(height: 24),

              // Gráfico de tendencia
              _buildTrendChart(context, service),
              const SizedBox(height: 24),

              // Gráficos de pastel - Ingresos y Gastos
              _buildPieChartsSection(context, service),
              const SizedBox(height: 24),

              // Gastos por categoría (detalle)
              _buildExpensesByCategory(context, service),
              const SizedBox(height: 24),

              // Ingresos por fuente (detalle)
              _buildIncomeBySource(context, service),
              const SizedBox(height: 24),

              // Patrimonio neto
              _buildNetWorthSection(context, service),
              const SizedBox(height: 24),

              // Botones de exportación
              _buildExportButtons(context, service),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }

  /// Obtiene el rango de fechas según el período seleccionado
  Map<String, DateTime?> _getDateRange() {
    final now = DateTime.now();
    DateTime? start;
    DateTime? end;

    switch (_selectedPeriod) {
      case PeriodType.all:
        start = null;
        end = null;
        break;
      case PeriodType.year:
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      case PeriodType.sixMonths:
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        start = DateTime(sixMonthsAgo.year, sixMonthsAgo.month, sixMonthsAgo.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case PeriodType.month:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case PeriodType.week:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(weekStart.year, weekStart.month, weekStart.day);
        end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;
      case PeriodType.custom:
        start = _customStartDate;
        end = _customEndDate;
        break;
    }

    return {'start': start, 'end': end};
  }

  /// Filtra transacciones por rango de fechas (comparando solo fechas, sin hora)
  List<Transaction> _filterTransactionsByDateRange(
    List<Transaction> transactions,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    return transactions.where((t) {
      final tYear = t.date.year;
      final tMonth = t.date.month;
      final tDay = t.date.day;
      
      if (startDate != null) {
        final startYear = startDate.year;
        final startMonth = startDate.month;
        final startDay = startDate.day;
        
        // Excluir si la fecha de la transacción es anterior al inicio
        if (tYear < startYear) return false;
        if (tYear == startYear && tMonth < startMonth) return false;
        if (tYear == startYear && tMonth == startMonth && tDay < startDay) return false;
      }
      
      if (endDate != null) {
        final endYear = endDate.year;
        final endMonth = endDate.month;
        final endDay = endDate.day;
        
        // Excluir si la fecha de la transacción es posterior al fin
        if (tYear > endYear) return false;
        if (tYear == endYear && tMonth > endMonth) return false;
        if (tYear == endYear && tMonth == endMonth && tDay > endDay) return false;
      }
      
      return true;
    }).toList();
  }

  Widget _buildPeriodSelector() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPeriodTab(PeriodType.all, 'Todo'),
                _buildPeriodTab(PeriodType.year, 'Este año'),
                _buildPeriodTab(PeriodType.sixMonths, '6 meses'),
                _buildPeriodTab(PeriodType.month, 'Mes'),
                _buildPeriodTab(PeriodType.week, 'Semana'),
                _buildPeriodTab(PeriodType.custom, 'Personalizado'),
              ],
            ),
          ),
        ),
        if (_selectedPeriod == PeriodType.custom && (_customStartDate != null || _customEndDate != null))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _getCustomRangeText(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
      ],
    );
  }

  String _getCustomRangeText() {
    if (_customStartDate == null && _customEndDate == null) {
      return 'Selecciona un rango de fechas';
    }
    final format = DateFormat('d MMM yyyy', 'es');
    if (_customStartDate != null && _customEndDate != null) {
      return '${format.format(_customStartDate!)} - ${format.format(_customEndDate!)}';
    } else if (_customStartDate != null) {
      return 'Desde: ${format.format(_customStartDate!)}';
    } else {
      return 'Hasta: ${format.format(_customEndDate!)}';
    }
  }

  Widget _buildPeriodTab(PeriodType period, String label) {
    final isSelected = _selectedPeriod == period;

    return GestureDetector(
      onTap: () async {
        if (period == PeriodType.custom) {
          await _showCustomDateRangePicker();
        } else {
          setState(() {
            _selectedPeriod = period;
            _customStartDate = null;
            _customEndDate = null;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Future<void> _showCustomDateRangePicker() async {
    DateTime? startDate = _customStartDate;
    DateTime? endDate = _customEndDate;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Seleccionar rango de fechas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Fecha de inicio'),
                subtitle: Text(
                  startDate != null
                      ? DateFormat('d MMMM yyyy', 'es').format(startDate!)
                      : 'Seleccionar',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setDialogState(() {
                      startDate = date;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Fecha de fin'),
                subtitle: Text(
                  endDate != null
                      ? DateFormat('d MMMM yyyy', 'es').format(endDate!)
                      : 'Seleccionar',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setDialogState(() {
                      endDate = date;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _customStartDate = null;
                  _customEndDate = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Limpiar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  // Permitir mismo día o rango válido
                  if (startDate!.isBefore(endDate!) || startDate!.isAtSameMomentAs(endDate!)) {
                    setState(() {
                      _customStartDate = startDate;
                      _customEndDate = endDate;
                      _selectedPeriod = PeriodType.custom;
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La fecha de inicio debe ser anterior o igual a la fecha de fin.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Selecciona ambas fechas.'),
                    ),
                  );
                }
              },
              child: const Text('Aplicar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, FinanceService service) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    final dateRange = _getDateRange();
    final startDate = dateRange['start'];
    final endDate = dateRange['end'];

    double income = 0;
    double expenses = 0;

    if (startDate == null && endDate == null) {
      // Todo
      income = service.totalIncome;
      expenses = service.totalExpenses;
    } else {
      // Filtrar por rango de fechas
      final filteredTransactions = _filterTransactionsByDateRange(
        service.transactions,
        startDate,
        endDate,
      );

      income = filteredTransactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);
      expenses = filteredTransactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);
    }

    final balance = income - expenses;
    final savingsRate = income > 0 ? ((income - expenses) / income) * 100 : 0.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Ingresos',
                currencyFormat.format(income),
                Icons.arrow_downward_rounded,
                Theme.of(context).colorScheme.income,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Gastos',
                currencyFormat.format(expenses),
                Icons.arrow_upward_rounded,
                Theme.of(context).colorScheme.expense,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Balance',
                currencyFormat.format(balance),
                Icons.account_balance_wallet_rounded,
                balance >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Tasa de ahorro',
                '${savingsRate.toStringAsFixed(1)}%',
                Icons.savings_rounded,
                Theme.of(context).colorScheme.savings,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  /// Obtiene datos de tendencia para el período seleccionado
  List<Map<String, dynamic>> _getTrendDataForPeriod(FinanceService service) {
    final dateRange = _getDateRange();
    final startDate = dateRange['start'];
    final endDate = dateRange['end'] ?? DateTime.now();
    
    final List<Map<String, dynamic>> trendData = [];
    final now = DateTime.now();

    // Determinar el número de meses a mostrar según el período
    int monthsToShow;
    
    switch (_selectedPeriod) {
      case PeriodType.all:
        // Mostrar los últimos 12 meses
        monthsToShow = 12;
        break;
      case PeriodType.year:
        monthsToShow = 12;
        break;
      case PeriodType.sixMonths:
        monthsToShow = 6;
        break;
      case PeriodType.month:
        // Para un mes, mostrar las semanas
        return _getWeeklyTrendData(service, startDate!, endDate);
      case PeriodType.week:
        // Para una semana, mostrar los días
        return _getDailyTrendData(service, startDate!, endDate);
      case PeriodType.custom:
        if (startDate == null) return [];
        // Calcular diferencia en días
        final days = endDate.difference(startDate).inDays;
        if (days <= 7) {
          return _getDailyTrendData(service, startDate, endDate);
        } else if (days <= 31) {
          return _getWeeklyTrendData(service, startDate, endDate);
        } else {
          monthsToShow = ((days / 30).ceil()).clamp(1, 12);
        }
        break;
    }

    // Generar datos mensuales
    // Si hay un rango de fechas específico, generar solo los meses dentro de ese rango
    if (startDate != null) {
      DateTime currentMonth = DateTime(startDate.year, startDate.month, 1);
      final endMonth = DateTime(endDate.year, endDate.month, 1);
      
      while (currentMonth.isBefore(endMonth) || currentMonth.isAtSameMomentAs(endMonth)) {
        final monthIncome = service.transactions
            .where((t) =>
                t.type == TransactionType.income &&
                t.date.year == currentMonth.year &&
                t.date.month == currentMonth.month)
            .fold(0.0, (sum, t) => sum + t.amount);

        final monthExpenses = service.transactions
            .where((t) =>
                t.type == TransactionType.expense &&
                t.date.year == currentMonth.year &&
                t.date.month == currentMonth.month)
            .fold(0.0, (sum, t) => sum + t.amount);

        trendData.add({
          'label': _getMonthName(currentMonth.month),
          'month': currentMonth.month,
          'year': currentMonth.year,
          'income': monthIncome,
          'expenses': monthExpenses,
        });
        
        // Avanzar al siguiente mes
        if (currentMonth.month == 12) {
          currentMonth = DateTime(currentMonth.year + 1, 1, 1);
        } else {
          currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
        }
      }
    } else {
      // Si no hay rango específico, usar los últimos N meses desde ahora
      for (int i = monthsToShow - 1; i >= 0; i--) {
        final date = DateTime(now.year, now.month - i, 1);
        
        final monthIncome = service.transactions
            .where((t) =>
                t.type == TransactionType.income &&
                t.date.year == date.year &&
                t.date.month == date.month)
            .fold(0.0, (sum, t) => sum + t.amount);

        final monthExpenses = service.transactions
            .where((t) =>
                t.type == TransactionType.expense &&
                t.date.year == date.year &&
                t.date.month == date.month)
            .fold(0.0, (sum, t) => sum + t.amount);

        trendData.add({
          'label': _getMonthName(date.month),
          'month': date.month,
          'year': date.year,
          'income': monthIncome,
          'expenses': monthExpenses,
        });
      }
    }

    return trendData;
  }

  List<Map<String, dynamic>> _getWeeklyTrendData(
      FinanceService service, DateTime start, DateTime end) {
    final List<Map<String, dynamic>> data = [];
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDateOnly = DateTime(end.year, end.month, end.day);
    int weekNum = 1;

    while (current.isBefore(endDateOnly) || current.isAtSameMomentAs(endDateOnly)) {
      final weekEnd = current.add(const Duration(days: 6));
      final actualEnd = weekEnd.isAfter(endDateOnly) ? endDateOnly : weekEnd;
      final actualEndDate = DateTime(actualEnd.year, actualEnd.month, actualEnd.day);

      final weekIncome = service.transactions
          .where((t) {
            final tDateOnly = DateTime(t.date.year, t.date.month, t.date.day);
            final currentDateOnly = DateTime(current.year, current.month, current.day);
            return t.type == TransactionType.income &&
                (tDateOnly.isAtSameMomentAs(currentDateOnly) || tDateOnly.isAfter(currentDateOnly)) &&
                (tDateOnly.isAtSameMomentAs(actualEndDate) || tDateOnly.isBefore(actualEndDate));
          })
          .fold(0.0, (sum, t) => sum + t.amount);

      final weekExpenses = service.transactions
          .where((t) {
            final tDateOnly = DateTime(t.date.year, t.date.month, t.date.day);
            final currentDateOnly = DateTime(current.year, current.month, current.day);
            return t.type == TransactionType.expense &&
                (tDateOnly.isAtSameMomentAs(currentDateOnly) || tDateOnly.isAfter(currentDateOnly)) &&
                (tDateOnly.isAtSameMomentAs(actualEndDate) || tDateOnly.isBefore(actualEndDate));
          })
          .fold(0.0, (sum, t) => sum + t.amount);

      data.add({
        'label': 'Sem $weekNum',
        'income': weekIncome,
        'expenses': weekExpenses,
      });

      current = current.add(const Duration(days: 7));
      weekNum++;
    }

    return data;
  }

  List<Map<String, dynamic>> _getDailyTrendData(
      FinanceService service, DateTime start, DateTime end) {
    final List<Map<String, dynamic>> data = [];
    final daysNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    DateTime current = start;

    while (!current.isAfter(end)) {
      final dayIncome = service.transactions
          .where((t) =>
              t.type == TransactionType.income &&
              t.date.year == current.year &&
              t.date.month == current.month &&
              t.date.day == current.day)
          .fold(0.0, (sum, t) => sum + t.amount);

      final dayExpenses = service.transactions
          .where((t) =>
              t.type == TransactionType.expense &&
              t.date.year == current.year &&
              t.date.month == current.month &&
              t.date.day == current.day)
          .fold(0.0, (sum, t) => sum + t.amount);

      data.add({
        'label': daysNames[current.weekday - 1],
        'day': current.day,
        'income': dayIncome,
        'expenses': dayExpenses,
      });

      current = current.add(const Duration(days: 1));
    }

    return data;
  }

  String _getPeriodTitle() {
    switch (_selectedPeriod) {
      case PeriodType.all:
        return 'Tendencia anual';
      case PeriodType.year:
        return 'Tendencia del año';
      case PeriodType.sixMonths:
        return 'Tendencia de 6 meses';
      case PeriodType.month:
        return 'Tendencia semanal';
      case PeriodType.week:
        return 'Tendencia diaria';
      case PeriodType.custom:
        return 'Tendencia del período';
    }
  }

  Widget _buildTrendChart(BuildContext context, FinanceService service) {
    final trendData = _getTrendDataForPeriod(service);
    if (trendData.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getPeriodTitle(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildLegendItem(
                'Ingresos',
                Theme.of(context).colorScheme.income,
              ),
              const SizedBox(width: 16),
              _buildLegendItem(
                'Gastos',
                Theme.of(context).colorScheme.expense,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxValue(trendData) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < trendData.length) {
                          final label = trendData[value.toInt()]['label'] as String;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              label,
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                barGroups: List.generate(trendData.length, (index) {
                  final data = trendData[index];
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (data['income'] as double),
                        color: Theme.of(context).colorScheme.income,
                        width: trendData.length > 7 ? 8 : 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                      BarChartRodData(
                        toY: (data['expenses'] as double),
                        color: Theme.of(context).colorScheme.expense,
                        width: trendData.length > 7 ? 8 : 12,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  double _getMaxValue(List<Map<String, dynamic>> data) {
    double max = 0;
    for (final d in data) {
      if ((d['income'] as double) > max) max = d['income'] as double;
      if ((d['expenses'] as double) > max) max = d['expenses'] as double;
    }
    return max;
  }

  String _getMonthName(int month) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return months[month - 1];
  }

  Widget _buildPieChartsSection(BuildContext context, FinanceService service) {
    final dateRange = _getDateRange();
    final startDate = dateRange['start'];
    final endDate = dateRange['end'];
    
    // Filtrar transacciones por período
    final filteredTransactions = _filterTransactionsByDateRange(
      service.transactions,
      startDate,
      endDate,
    );
    
    // Calcular ingresos por fuente
    final Map<String, double> incomeBySource = {};
    for (var t in filteredTransactions.where((t) => t.type == TransactionType.income)) {
      final source = t.source ?? 'Otros';
      incomeBySource[source] = (incomeBySource[source] ?? 0.0) + t.amount;
    }
    
    // Calcular gastos por categoría
    final Map<String, double> expensesByCategory = {};
    for (var t in filteredTransactions.where((t) => t.type == TransactionType.expense)) {
      expensesByCategory[t.category] = (expensesByCategory[t.category] ?? 0.0) + t.amount;
    }
    
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );
    
    final totalIncome = incomeBySource.values.fold(0.0, (a, b) => a + b);
    final totalExpenses = expensesByCategory.values.fold(0.0, (a, b) => a + b);

    return Column(
      children: [
        // Gráfico de Ingresos
        _buildSinglePieChart(
          context,
          'Ingresos',
          incomeBySource,
          totalIncome,
          currencyFormat,
          Theme.of(context).colorScheme.income,
          _incomeColors,
          _getIncomeColor,
        ),
        const SizedBox(height: 16),
        // Gráfico de Gastos
        _buildSinglePieChart(
          context,
          'Gastos',
          expensesByCategory,
          totalExpenses,
          currencyFormat,
          Theme.of(context).colorScheme.expense,
          _expenseColors,
          _getExpenseColor,
        ),
      ],
    );
  }

  // Colores específicos por fuente de ingreso
  static const Map<String, Color> _incomeSourceColors = {
    'Salario': Color(0xFF2E7D32),       // Verde esmeralda
    'Freelance': Color(0xFF1976D2),     // Azul
    'Inversiones': Color(0xFF7B1FA2),   // Púrpura
    'Bonos': Color(0xFFFF6F00),         // Naranja
    'Intereses': Color(0xFF00838F),     // Teal
    'Alquiler': Color(0xFFAD1457),      // Rosa fuerte
    'Otros': Color(0xFF5D4037),         // Marrón
  };

  // Colores específicos por categoría de gasto
  static const Map<String, Color> _expenseCategoryColors = {
    'Alimentación': Color(0xFFE53935),    // Rojo
    'Vivienda': Color(0xFFFF6F00),        // Naranja
    'Compras': Color(0xFFAD1457),         // Rosa fuerte
    'Transporte': Color(0xFF1976D2),      // Azul
    'Educación': Color(0xFF7B1FA2),       // Púrpura
    'Entretenimiento': Color(0xFFFFB300), // Amarillo/Dorado
    'Servicios': Color(0xFF00838F),       // Teal
    'Regalos': Color(0xFFEC407A),         // Rosa
    'Mascotas': Color(0xFF8D6E63),        // Marrón claro
    'Salud': Color(0xFF43A047),           // Verde
    'Otros': Color(0xFF607D8B),           // Gris azulado
  };

  // Obtener color para fuente de ingreso
  Color _getIncomeColor(String source) {
    return _incomeSourceColors[source] ?? const Color(0xFF9E9E9E);
  }

  // Obtener color para categoría de gasto
  Color _getExpenseColor(String category) {
    return _expenseCategoryColors[category] ?? const Color(0xFF9E9E9E);
  }

  // Lista de colores de respaldo para categorías personalizadas (ingresos)
  List<Color> get _incomeColors => [
    const Color(0xFF2E7D32), // Verde esmeralda
    const Color(0xFF1976D2), // Azul
    const Color(0xFF7B1FA2), // Púrpura
    const Color(0xFFFF6F00), // Naranja
    const Color(0xFF00838F), // Teal
    const Color(0xFFAD1457), // Rosa fuerte
    const Color(0xFF5D4037), // Marrón
    const Color(0xFF43A047), // Verde claro
    const Color(0xFF3949AB), // Índigo
    const Color(0xFFE65100), // Naranja oscuro
    const Color(0xFF00695C), // Verde azulado
    const Color(0xFF6A1B9A), // Púrpura oscuro
    const Color(0xFFC62828), // Rojo oscuro
    const Color(0xFF283593), // Azul oscuro
    const Color(0xFF558B2F), // Verde oliva
    Colors.grey.shade400,
  ];

  // Lista de colores de respaldo para categorías personalizadas (gastos)
  List<Color> get _expenseColors => [
    const Color(0xFFE53935), // Rojo
    const Color(0xFFFF6F00), // Naranja
    const Color(0xFFAD1457), // Rosa fuerte
    const Color(0xFF1976D2), // Azul
    const Color(0xFF7B1FA2), // Púrpura
    const Color(0xFFFFB300), // Amarillo/Dorado
    const Color(0xFF00838F), // Teal
    const Color(0xFFEC407A), // Rosa
    const Color(0xFF8D6E63), // Marrón claro
    const Color(0xFF43A047), // Verde
    const Color(0xFF607D8B), // Gris azulado
    const Color(0xFF5E35B1), // Violeta
    const Color(0xFF039BE5), // Azul claro
    const Color(0xFFD81B60), // Magenta
    const Color(0xFF00897B), // Verde mar
    Colors.grey.shade400,
  ];

  Widget _buildSinglePieChart(
    BuildContext context,
    String title,
    Map<String, double> data,
    double total,
    NumberFormat currencyFormat,
    Color accentColor,
    List<Color> fallbackColors,
    Color Function(String) getColorForCategory,
  ) {
    if (data.isEmpty || total == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sin datos en este período',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Crear mapa de colores para cada categoría
    Color getColor(String categoryName, int index) {
      final specificColor = getColorForCategory(categoryName);
      // Si no es el color gris por defecto, usar el específico
      if (specificColor != const Color(0xFF9E9E9E)) {
        return specificColor;
      }
      // Si no hay color específico, usar el de respaldo por índice
      return fallbackColors[index % fallbackColors.length];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título y total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                currencyFormat.format(total),
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Gráfico y leyenda lado a lado
          Row(
            children: [
              // Gráfico de pastel
              SizedBox(
                width: 120,
                height: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: List.generate(
                      sortedEntries.length > 6 ? 6 : sortedEntries.length,
                      (index) {
                        final entry = sortedEntries[index];
                        final percentage = (entry.value / total) * 100;
                        return PieChartSectionData(
                          value: entry.value,
                          color: getColor(entry.key, index),
                          radius: 30,
                          showTitle: percentage >= 15,
                          title: '${percentage.toStringAsFixed(0)}%',
                          titleStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Leyenda con todos los datos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...sortedEntries.asMap().entries.map((mapEntry) {
                      final index = mapEntry.key;
                      final entry = mapEntry.value;
                      final percentage = (entry.value / total) * 100;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: getColor(entry.key, index),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: getColor(entry.key, index),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesByCategory(
      BuildContext context, FinanceService service) {
    final dateRange = _getDateRange();
    final startDate = dateRange['start'];
    final endDate = dateRange['end'];
    
    // Filtrar transacciones por período
    var filteredTransactions = _filterTransactionsByDateRange(
      service.transactions,
      startDate,
      endDate,
    );
    
    // Calcular gastos por categoría
    final Map<String, double> expenses = {};
    for (var transaction in filteredTransactions
        .where((t) => t.type == TransactionType.expense)) {
      expenses[transaction.category] =
          (expenses[transaction.category] ?? 0.0) + transaction.amount;
    }
    if (expenses.isEmpty) return const SizedBox.shrink();

    final total = expenses.values.fold<double>(0, (a, b) => a + b);
    final sortedEntries = expenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    // Colores de respaldo para categorías personalizadas
    final fallbackColors = [
      const Color(0xFFE53935), // Rojo
      const Color(0xFFFF6F00), // Naranja
      const Color(0xFFAD1457), // Rosa fuerte
      const Color(0xFF1976D2), // Azul
      const Color(0xFF7B1FA2), // Púrpura
      const Color(0xFFFFB300), // Amarillo/Dorado
      const Color(0xFF00838F), // Teal
      const Color(0xFFEC407A), // Rosa
      const Color(0xFF8D6E63), // Marrón claro
      const Color(0xFF43A047), // Verde
      const Color(0xFF607D8B), // Gris azulado
      const Color(0xFF5E35B1), // Violeta
      const Color(0xFF039BE5), // Azul claro
      const Color(0xFFD81B60), // Magenta
      const Color(0xFF00897B), // Verde mar
      Colors.grey.shade400,
    ];

    // Función para obtener color específico por categoría
    Color getColor(String categoryName, int index) {
      final specificColor = _expenseCategoryColors[categoryName];
      if (specificColor != null) {
        return specificColor;
      }
      return fallbackColors[index % fallbackColors.length];
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gastos por categoría',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: List.generate(
                        sortedEntries.length > 6 ? 6 : sortedEntries.length,
                        (index) {
                          final entry = sortedEntries[index];
                          final percentage = (entry.value / total) * 100;
                          // Mostrar porcentaje solo en las 3 categorías más grandes
                          final showTitle = index < 3;
                          return PieChartSectionData(
                            value: entry.value,
                            color: getColor(entry.key, index),
                            radius: 35,
                            showTitle: showTitle,
                            title: '${percentage.toStringAsFixed(0)}%',
                            titleStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      sortedEntries.length > 5 ? 5 : sortedEntries.length,
                      (index) {
                        final entry = sortedEntries[index];
                        final percentage = (entry.value / total) * 100;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: getColor(entry.key, index),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          ...sortedEntries.take(5).map((entry) {
            final percentage = (entry.value / total) * 100;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(entry.key)),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.expense,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currencyFormat.format(entry.value),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildIncomeBySource(BuildContext context, FinanceService service) {
    final dateRange = _getDateRange();
    final startDate = dateRange['start'];
    final endDate = dateRange['end'];
    
    // Filtrar transacciones por período
    var filteredTransactions = _filterTransactionsByDateRange(
      service.transactions,
      startDate,
      endDate,
    );
    
    // Calcular ingresos por fuente
    final Map<String, double> income = {};
    for (var transaction in filteredTransactions
        .where((t) => t.type == TransactionType.income)) {
      final source = transaction.source ?? 'Otros';
      income[source] = (income[source] ?? 0.0) + transaction.amount;
    }
    if (income.isEmpty) return const SizedBox.shrink();

    final total = income.values.fold<double>(0, (a, b) => a + b);
    final sortedEntries = income.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingresos por fuente',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ...sortedEntries.map((entry) {
            final percentage = (entry.value / total) * 100;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(entry.key)),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.income,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    currencyFormat.format(entry.value),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNetWorthSection(BuildContext context, FinanceService service) {
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: service.userSettings.currencySymbol,
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patrimonio Neto',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(service.netWorth),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          _buildNetWorthRow(
            'Balance',
            currencyFormat.format(service.balance),
            Colors.white,
          ),
          _buildNetWorthRow(
            'Ahorros',
            '+${currencyFormat.format(service.totalSavings)}',
            Colors.white.withOpacity(0.9),
          ),
          _buildNetWorthRow(
            'Inversiones',
            '+${currencyFormat.format(service.totalInvestmentsValue)}',
            Colors.white.withOpacity(0.9),
          ),
          _buildNetWorthRow(
            'Por cobrar',
            '+${currencyFormat.format(service.totalReceivables)}',
            Colors.white.withOpacity(0.9),
          ),
          _buildNetWorthRow(
            'Deudas',
            '-${currencyFormat.format(service.totalDebt)}',
            Colors.white.withOpacity(0.9),
          ),
        ],
      ),
    );
  }

  Widget _buildNetWorthRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: color.withOpacity(0.8)),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButtons(BuildContext context, FinanceService service) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.download_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Exportar datos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Descarga un reporte de tus transacciones',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showExportDialog(context, service, 'excel'),
                  icon: const Icon(Icons.table_chart_rounded),
                  label: const Text('Excel'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.green.shade600),
                    foregroundColor: Colors.green.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showExportDialog(context, service, 'pdf'),
                  icon: const Icon(Icons.picture_as_pdf_rounded),
                  label: const Text('PDF'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.red.shade600),
                    foregroundColor: Colors.red.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showExportDialog(
      BuildContext context, FinanceService service, String exportType) async {
    PeriodType selectedPeriod = PeriodType.all;
    DateTime? customStartDate;
    DateTime? customEndDate;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          String getPeriodLabel(PeriodType period) {
            switch (period) {
              case PeriodType.all:
                return 'Todo';
              case PeriodType.year:
                return 'Este año';
              case PeriodType.sixMonths:
                return 'Últimos 6 meses';
              case PeriodType.month:
                return 'Este mes';
              case PeriodType.week:
                return 'Esta semana';
              case PeriodType.custom:
                return 'Rango personalizado';
            }
          }

          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  exportType == 'excel'
                      ? Icons.table_chart_rounded
                      : Icons.picture_as_pdf_rounded,
                  color: exportType == 'excel'
                      ? Colors.green.shade600
                      : Colors.red.shade600,
                ),
                const SizedBox(width: 8),
                Text('Exportar a ${exportType == 'excel' ? 'Excel' : 'PDF'}'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecciona el período a exportar:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Opciones de período
                  ...PeriodType.values.map((period) {
                    return RadioListTile<PeriodType>(
                      title: Text(getPeriodLabel(period)),
                      value: period,
                      groupValue: selectedPeriod,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                        setDialogState(() {
                          selectedPeriod = value!;
                          if (value != PeriodType.custom) {
                            customStartDate = null;
                            customEndDate = null;
                          }
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 16),
                  // Información de límites y total de transacciones
                  Builder(
                    builder: (context) {
                      // Calcular transacciones del período seleccionado
                      final dateRange = _getExportDateRange(selectedPeriod, customStartDate, customEndDate);
                      final startDate = dateRange['start'];
                      final endDate = dateRange['end'];
                      
                      final filteredTransactions = _filterTransactionsByDateRange(
                        service.transactions,
                        startDate,
                        endDate,
                      );
                      
                      final totalTransactions = filteredTransactions.length;
                      final excelLimit = 5000;
                      final pdfLimit = 2500;
                      final currentLimit = exportType == 'excel' ? excelLimit : pdfLimit;
                      final exceedsLimit = totalTransactions > currentLimit;
                      
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: exceedsLimit ? Colors.orange.shade50 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: exceedsLimit ? Colors.orange.shade200 : Colors.blue.shade200,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  exceedsLimit ? Icons.warning_amber_rounded : Icons.info_outline,
                                  color: exceedsLimit ? Colors.orange.shade700 : Colors.blue.shade700,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Información de exportación',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: exceedsLimit ? Colors.orange.shade900 : Colors.blue.shade900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              'Total de transacciones:',
                              '$totalTransactions',
                              Colors.grey.shade700,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    exportType == 'excel' 
                                        ? 'Límite Excel:' 
                                        : 'Límite PDF:',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    exportType == 'excel' 
                                        ? '$excelLimit transacciones' 
                                        : '$pdfLimit transacciones\n(100 páginas)',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            if (exceedsLimit) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                '⚠️ Se exportarán:',
                                '$currentLimit de $totalTransactions',
                                Colors.orange.shade700,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  // Selector de fechas personalizado
                  if (selectedPeriod == PeriodType.custom) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: customStartDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setDialogState(() {
                                  customStartDate = date;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  customStartDate != null
                                      ? 'Desde: ${DateFormat('d MMM yyyy', 'es').format(customStartDate!)}'
                                      : 'Fecha de inicio',
                                  style: TextStyle(
                                    color: customStartDate != null
                                        ? Colors.black87
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: customEndDate ?? customStartDate ?? DateTime.now(),
                                firstDate: customStartDate ?? DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setDialogState(() {
                                  customEndDate = date;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  customEndDate != null
                                      ? 'Hasta: ${DateFormat('d MMM yyyy', 'es').format(customEndDate!)}'
                                      : 'Fecha de fin',
                                  style: TextStyle(
                                    color: customEndDate != null
                                        ? Colors.black87
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  // Validar rango personalizado
                  if (selectedPeriod == PeriodType.custom) {
                    if (customStartDate == null || customEndDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona ambas fechas'),
                        ),
                      );
                      return;
                    }
                    if (customStartDate!.isAfter(customEndDate!)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('La fecha de inicio debe ser anterior a la de fin'),
                        ),
                      );
                      return;
                    }
                  }
                  
                  // Calcular cuántas transacciones hay en el período seleccionado
                  final dateRange = _getExportDateRange(selectedPeriod, customStartDate, customEndDate);
                  final startDate = dateRange['start'];
                  final endDate = dateRange['end'];
                  
                  final filteredTransactions = _filterTransactionsByDateRange(
                    service.transactions,
                    startDate,
                    endDate,
                  );
                  
                  final totalTransactions = filteredTransactions.length;
                  
                  // Límites de cada formato
                  final excelLimit = 5000;
                  final pdfLimit = 2500; // 100 páginas * 25 filas por página
                  
                  // Mostrar diálogo de confirmación con la información
                  final shouldExport = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Row(
                        children: [
                          Icon(
                            exportType == 'excel'
                                ? Icons.table_chart_rounded
                                : Icons.picture_as_pdf_rounded,
                            color: exportType == 'excel'
                                ? Colors.green.shade600
                                : Colors.red.shade600,
                          ),
                          const SizedBox(width: 8),
                          Text('Confirmar exportación'),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información de límites y total
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline, 
                                      color: Colors.blue.shade700, 
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Información de exportación',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade900,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  'Total de transacciones:',
                                  '$totalTransactions',
                                  Colors.grey.shade700,
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  exportType == 'excel' 
                                      ? 'Límite Excel:' 
                                      : 'Límite PDF:',
                                  exportType == 'excel' 
                                      ? '$excelLimit transacciones' 
                                      : '$pdfLimit transacciones (100 páginas)',
                                  Colors.grey.shade700,
                                ),
                                const SizedBox(height: 8),
                                if (exportType == 'excel' && totalTransactions > excelLimit)
                                  _buildInfoRow(
                                    '⚠️ Se exportarán:',
                                    '$excelLimit de $totalTransactions',
                                    Colors.orange.shade700,
                                  )
                                else if (exportType == 'pdf' && totalTransactions > pdfLimit)
                                  _buildInfoRow(
                                    '⚠️ Se exportarán:',
                                    '$pdfLimit de $totalTransactions',
                                    Colors.orange.shade700,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '¿Deseas continuar con la exportación?',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context, true),
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Exportar'),
                        ),
                      ],
                    ),
                  );
                  
                  if (shouldExport == true) {
                    Navigator.pop(context);
                    
                    // Ejecutar exportación
                    if (exportType == 'excel') {
                      _executeExport(
                        context, 
                        service, 
                        'excel', 
                        selectedPeriod, 
                        customStartDate, 
                        customEndDate,
                      );
                    } else {
                      _executeExport(
                        context, 
                        service, 
                        'pdf', 
                        selectedPeriod, 
                        customStartDate, 
                        customEndDate,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Exportar'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Helper para construir una fila de información
  Widget _buildInfoRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Map<String, DateTime?> _getExportDateRange(
      PeriodType period, DateTime? customStart, DateTime? customEnd) {
    final now = DateTime.now();
    DateTime? start;
    DateTime? end;

    switch (period) {
      case PeriodType.all:
        start = null;
        end = null;
        break;
      case PeriodType.year:
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      case PeriodType.sixMonths:
        final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
        start = DateTime(sixMonthsAgo.year, sixMonthsAgo.month, sixMonthsAgo.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case PeriodType.month:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;
      case PeriodType.week:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        start = DateTime(weekStart.year, weekStart.month, weekStart.day);
        end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
        break;
      case PeriodType.custom:
        start = customStart;
        end = customEnd != null 
            ? DateTime(customEnd.year, customEnd.month, customEnd.day, 23, 59, 59)
            : null;
        break;
    }

    return {'start': start, 'end': end};
  }

  Future<void> _executeExport(
    BuildContext context,
    FinanceService service,
    String exportType,
    PeriodType period,
    DateTime? customStart,
    DateTime? customEnd,
  ) async {
    // Obtener rango de fechas
    final dateRange = _getExportDateRange(period, customStart, customEnd);
    final startDate = dateRange['start'];
    final endDate = dateRange['end'];

    // Filtrar transacciones
    final filteredTransactions = _filterTransactionsByDateRange(
      service.transactions,
      startDate,
      endDate,
    );

    if (filteredTransactions.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay transacciones en el período seleccionado'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Guardar el contexto de la pantalla antes de iniciar
    final screenContext = context;
    if (!screenContext.mounted) return;
    
    // Mostrar diálogo de loading
    final loadingCompleter = Completer<void>();
    BuildContext? loadingDialogContext;
    
    showDialog(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        loadingDialogContext = dialogContext;
        // Completar después del primer frame para asegurar que el diálogo está visible
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!loadingCompleter.isCompleted) {
            loadingCompleter.complete();
          }
        });
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  exportType == 'excel' 
                      ? 'Generando archivo Excel...' 
                      : 'Generando archivo PDF...',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${filteredTransactions.length} transacciones',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Esto puede tomar unos segundos...',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
    
    // Esperar a que el diálogo esté visible antes de continuar
    await loadingCompleter.future;
    // Dar tiempo extra para que la UI se estabilice
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      print('Iniciando exportación de ${filteredTransactions.length} transacciones...');
      
      // Ejecutar exportación
      ExportResult result;
      
      if (exportType == 'excel') {
        print('Exportando a Excel...');
        result = await ExportService.exportToExcel(
          transactions: filteredTransactions,
        ).timeout(
          const Duration(minutes: 3),
          onTimeout: () {
            throw TimeoutException(
              'La exportación a Excel tardó más de 3 minutos. '
              'Esto puede deberse a muchas transacciones (${filteredTransactions.length}). '
              'Intenta exportar un rango de fechas más pequeño.',
              const Duration(minutes: 3),
            );
          },
        );
        print('Excel exportado exitosamente: ${result.filePath}');
      } else {
        print('Exportando a PDF...');
        result = await ExportService.exportToPDF(
          transactions: filteredTransactions,
        ).timeout(
          const Duration(minutes: 3),
          onTimeout: () {
            throw TimeoutException(
              'La exportación a PDF tardó más de 3 minutos. '
              'Esto puede deberse a muchas transacciones (${filteredTransactions.length}). '
              'Intenta exportar un rango de fechas más pequeño.',
              const Duration(minutes: 3),
            );
          },
        );
        print('PDF exportado exitosamente: ${result.filePath}');
      }
      
      // Cerrar el diálogo de carga y mostrar el de éxito
      print('Mostrando diálogo de éxito...');
      
      if (loadingDialogContext != null && loadingDialogContext!.mounted) {
        // Usar el StatefulBuilder para actualizar el contenido del diálogo
        // Necesitamos acceder al setState del StatefulBuilder
        // Como no tenemos acceso directo, usaremos un enfoque diferente:
        // Cerrar el diálogo de carga y mostrar el de éxito inmediatamente
        Navigator.of(loadingDialogContext!).pop();
        
        // Esperar un momento mínimo
        await Future.delayed(const Duration(milliseconds: 100));
        
        // Mostrar el diálogo de éxito usando Navigator raíz para mayor confiabilidad
        try {
          // Intentar con el contexto de la pantalla primero
          if (screenContext.mounted) {
            showDialog(
              context: screenContext,
              barrierDismissible: true,
              builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(
                    exportType == 'excel' 
                        ? Icons.table_chart_rounded 
                        : Icons.picture_as_pdf_rounded,
                    color: exportType == 'excel' 
                        ? Colors.green.shade600 
                        : Colors.red.shade600,
                  ),
                  const SizedBox(width: 8),
                  const Text('¡Exportación exitosa!'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'El archivo se ha exportado correctamente a la carpeta de Descargas.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            result.fileName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${filteredTransactions.length} transacciones exportadas',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final dialogContext = context;
                    Navigator.pop(dialogContext);
                    await Future.delayed(const Duration(milliseconds: 200));
                    if (screenContext.mounted) {
                      _showExportOptionsDialog(screenContext, result, filteredTransactions.length);
                    } else {
                      try {
                        await ExportService.shareFile(result);
                      } catch (e) {
                        print('Error al compartir: $e');
                      }
                    }
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('Compartir'),
                ),
              ],
            ),
          );
          } else {
            // Si el contexto no está montado, intentar usar el contexto del diálogo de carga
            print('Context de pantalla no montado, usando contexto del diálogo...');
            if (loadingDialogContext != null && loadingDialogContext!.mounted) {
              showDialog(
                context: loadingDialogContext!,
                barrierDismissible: true,
                builder: (context) => AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      exportType == 'excel' 
                          ? Icons.table_chart_rounded 
                          : Icons.picture_as_pdf_rounded,
                      color: exportType == 'excel' 
                          ? Colors.green.shade600 
                          : Colors.red.shade600,
                    ),
                    const SizedBox(width: 8),
                    const Text('¡Exportación exitosa!'),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'El archivo se ha exportado correctamente a la carpeta de Descargas.',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              result.fileName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${filteredTransactions.length} transacciones exportadas',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Aceptar'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 200));
                      try {
                        await ExportService.shareFile(result);
                      } catch (e) {
                        print('Error al compartir: $e');
                      }
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Compartir'),
                  ),
                ],
              ),
            );
            } else {
              // Último recurso: mostrar SnackBar
              print('No hay contexto disponible, mostrando SnackBar...');
              try {
                // Intentar obtener ScaffoldMessenger del contexto original
                final messenger = ScaffoldMessenger.maybeOf(screenContext);
                if (messenger != null) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Archivo exportado: ${result.fileName}'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Compartir',
                        textColor: Colors.white,
                        onPressed: () async {
                          try {
                            await ExportService.shareFile(result);
                          } catch (e) {
                            print('Error al compartir: $e');
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  print('No se encontró ScaffoldMessenger disponible');
                }
              } catch (e) {
                print('Error al mostrar SnackBar: $e');
              }
            }
          }
        } catch (e) {
          print('Error al mostrar diálogo de éxito: $e');
        }
      } else {
        // Si no hay loadingDialogContext, intentar mostrar directamente
        print('No hay loadingDialogContext disponible');
        if (screenContext.mounted) {
          showDialog(
            context: screenContext,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
              title: const Text('¡Exportación exitosa!'),
              content: Text('Archivo exportado: ${result.fileName}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      // Cerrar loading si aún está abierto
      if (loadingDialogContext != null) {
        Navigator.of(loadingDialogContext!).pop();
      }
      
      // Usar el contexto guardado
      final errorContext = screenContext.mounted ? screenContext : loadingDialogContext;
      if (errorContext != null && errorContext.mounted) {
        // Mostrar error detallado
        final errorMessage = e.toString();
        print('Error en exportación: $errorMessage');
        print('Stack trace: $stackTrace');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error al exportar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  errorMessage.length > 100 
                      ? '${errorMessage.substring(0, 100)}...' 
                      : errorMessage,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Ver detalles',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error de exportación'),
                    content: SingleChildScrollView(
                      child: Text('$errorMessage\n\n$stackTrace'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  /// Muestra el diálogo con opciones después de exportar
  void _showExportOptionsDialog(BuildContext context, ExportResult result, int transactionCount) {
    final isExcel = result.fileType == 'excel';
    final icon = isExcel ? Icons.table_chart_rounded : Icons.picture_as_pdf_rounded;
    final color = isExcel ? Colors.green : Colors.red;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                '¡Archivo creado!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$transactionCount transacciones exportadas',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '📁 ${result.fileName}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Qué deseas hacer?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          // Botón Compartir
          OutlinedButton.icon(
            onPressed: () async {
              // Guardar el contexto antes de cerrar el diálogo
              final dialogContext = context;
              Navigator.pop(dialogContext);
              
              // Esperar a que el diálogo se cierre
              await Future.delayed(const Duration(milliseconds: 100));
              
              try {
                await ExportService.shareFile(result);
              } catch (e) {
                // Intentar mostrar error usando el contexto de la pantalla
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('Error al compartir: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  print('Error al compartir: $e');
                }
              }
            },
            icon: const Icon(Icons.share_rounded, size: 18),
            label: const Text('Compartir'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Botón Abrir
          ElevatedButton.icon(
            onPressed: () async {
              // Guardar el contexto antes de cerrar el diálogo
              final dialogContext = context;
              Navigator.pop(dialogContext);
              
              // Esperar a que el diálogo se cierre
              await Future.delayed(const Duration(milliseconds: 100));
              
              try {
                await ExportService.openFile(result);
              } catch (e) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('Error al abrir: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  print('Error al abrir: $e');
                }
              }
            },
            icon: const Icon(Icons.open_in_new_rounded, size: 18),
            label: const Text('Abrir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
    
    // Mostrar también un mensaje informativo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.folder_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Guardado en: Documentos/Brote',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

}
