import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/savings_goal.dart';
import '../widgets/notification_config_dialog.dart';
import '../main.dart';

/// Formatter personalizado para formatear números con separadores mientras se escribe
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

    // Remover todos los separadores del texto nuevo
    String text = newValue.text
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.')
        .replaceAll(RegExp(r'[^\d.]'), '');

    // Separar parte entera y decimal
    List<String> parts = text.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Limitar decimales a 2
    if (decimalPart.length > 2) {
      decimalPart = decimalPart.substring(0, 2);
    }

    // Formatear parte entera con separadores de miles
    String formattedInteger = _formatWithSeparators(integerPart);

    // Construir el texto formateado
    String formattedText = formattedInteger;
    if (decimalPart.isNotEmpty) {
      formattedText += '$decimalSeparator$decimalPart';
    }

    // Calcular la nueva posición del cursor
    int selectionIndex = formattedText.length;
    if (newValue.selection.baseOffset < newValue.text.length) {
      // Intentar mantener la posición relativa del cursor
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

    // Revertir, agregar separadores cada 3 dígitos, y revertir de nuevo
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

  /// Remueve los separadores de un texto formateado para obtener el número puro
  static String removeFormatting(String formattedText,
      String thousandsSeparator, String decimalSeparator) {
    return formattedText
        .replaceAll(thousandsSeparator, '')
        .replaceAll(decimalSeparator, '.');
  }
}

/// Opciones de iconos para bolsillos de ahorro con sus colores asociados
class SavingsIconOption {
  final String id;
  final IconData icon;
  final Color color;
  final String label;

  const SavingsIconOption({
    required this.id,
    required this.icon,
    required this.color,
    required this.label,
  });
}

final List<SavingsIconOption> savingsIconOptions = [
  SavingsIconOption(
    id: 'savings',
    icon: Icons.savings_rounded,
    color: const Color(0xFF2E7D32),
    label: 'Ahorro',
  ),
  SavingsIconOption(
    id: 'vacation',
    icon: Icons.flight_takeoff_rounded,
    color: const Color(0xFF1976D2),
    label: 'Vacaciones',
  ),
  SavingsIconOption(
    id: 'home',
    icon: Icons.home_rounded,
    color: const Color(0xFF7B1FA2),
    label: 'Casa',
  ),
  SavingsIconOption(
    id: 'car',
    icon: Icons.directions_car_rounded,
    color: const Color(0xFFE65100),
    label: 'Auto',
  ),
  SavingsIconOption(
    id: 'education',
    icon: Icons.school_rounded,
    color: const Color(0xFF00838F),
    label: 'Educación',
  ),
  SavingsIconOption(
    id: 'health',
    icon: Icons.favorite_rounded,
    color: const Color(0xFFC62828),
    label: 'Salud',
  ),
  SavingsIconOption(
    id: 'gift',
    icon: Icons.card_giftcard_rounded,
    color: const Color(0xFFAD1457),
    label: 'Regalo',
  ),
  SavingsIconOption(
    id: 'shopping',
    icon: Icons.shopping_bag_rounded,
    color: const Color(0xFFFF6F00),
    label: 'Compras',
  ),
  SavingsIconOption(
    id: 'phone',
    icon: Icons.phone_android_rounded,
    color: const Color(0xFF37474F),
    label: 'Tecnología',
  ),
  SavingsIconOption(
    id: 'emergency',
    icon: Icons.emergency_rounded,
    color: const Color(0xFFD32F2F),
    label: 'Emergencia',
  ),
  SavingsIconOption(
    id: 'wedding',
    icon: Icons.celebration_rounded,
    color: const Color(0xFFEC407A),
    label: 'Celebración',
  ),
  SavingsIconOption(
    id: 'baby',
    icon: Icons.child_care_rounded,
    color: const Color(0xFF5C6BC0),
    label: 'Bebé',
  ),
  SavingsIconOption(
    id: 'fitness',
    icon: Icons.fitness_center_rounded,
    color: const Color(0xFF43A047),
    label: 'Fitness',
  ),
  SavingsIconOption(
    id: 'pet',
    icon: Icons.pets_rounded,
    color: const Color(0xFF795548),
    label: 'Mascota',
  ),
  SavingsIconOption(
    id: 'investment',
    icon: Icons.trending_up_rounded,
    color: const Color(0xFF00695C),
    label: 'Inversión',
  ),
  SavingsIconOption(
    id: 'food',
    icon: Icons.restaurant_rounded,
    color: const Color(0xFFEF6C00),
    label: 'Comida',
  ),
];

/// Obtiene la opción de icono por su ID
SavingsIconOption getSavingsIconById(String? iconId) {
  return savingsIconOptions.firstWhere(
    (option) => option.id == iconId,
    orElse: () => savingsIconOptions.first,
  );
}

/// Obtiene el color a partir del string hexadecimal
Color getColorFromHex(String? hexColor) {
  if (hexColor == null) return savingsIconOptions.first.color;
  try {
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  } catch (e) {
    return savingsIconOptions.first.color;
  }
}

/// Convierte un color a string hexadecimal
String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bolsillos de Ahorro'),
      ),
      body: Consumer<FinanceService>(
        builder: (context, service, _) {
          final activeGoals = service.activeSavingsGoals;
          final completedGoals = service.savingsGoals
              .where((g) => g.status == SavingsGoalStatus.completed)
              .toList();

          if (service.savingsGoals.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Resumen
              _buildSummaryCard(context, service),
              const SizedBox(height: 24),

              // Metas activas
              if (activeGoals.isNotEmpty) ...[
                Text(
                  'Metas activas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...activeGoals
                    .map((goal) => _buildGoalCard(context, goal, service)),
                const SizedBox(height: 24),
              ],

              // Metas completadas
              if (completedGoals.isNotEmpty) ...[
                Text(
                  'Completadas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...completedGoals
                    .map((goal) => _buildGoalCard(context, goal, service)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'savings_fab',
        onPressed: () => _showAddGoalDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva meta'),
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
              color: Theme.of(context).colorScheme.savings.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.savings_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.savings,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No tienes metas de ahorro',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer bolsillo de ahorro\npara alcanzar tus objetivos',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddGoalDialog(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Crear meta'),
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

    final totalTarget = service.activeSavingsGoals
        .fold<double>(0, (sum, g) => sum + g.targetAmount);
    final totalSaved = service.totalSavings;
    final progress = totalTarget > 0 ? (totalSaved / totalTarget) * 100 : 0.0;

    return Container(
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
              const Icon(Icons.savings_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'Total Ahorrado',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currencyFormat.format(totalSaved),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${progress.toStringAsFixed(1)}% de ${currencyFormat.format(totalTarget)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
        ],
      ),
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

    final isCompleted = goal.status == SavingsGoalStatus.completed;

    // Obtener icono y color del bolsillo
    final iconOption = getSavingsIconById(goal.iconName);
    final goalColor =
        goal.color != null ? getColorFromHex(goal.color) : iconOption.color;
    final color =
        isCompleted ? Theme.of(context).colorScheme.primary : goalColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
                isCompleted ? Icons.check_circle_rounded : iconOption.icon,
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
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progressPercentage / 100,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${goal.progressPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    if (goal.targetDate != null && !isCompleted)
                      Text(
                        'Faltan ${goal.daysRemaining} días',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                      ),
                  ],
                ),
              ],
            ),
            trailing: !isCompleted
                ? IconButton(
                    icon: Icon(Icons.add_circle_rounded, color: color),
                    onPressed: () =>
                        _showAddContributionDialog(context, goal, service),
                  )
                : null,
            onTap: () => _showGoalDetails(context, goal, service),
          ),
        ],
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    DateTime? targetDate;
    SavingsIconOption selectedIcon = savingsIconOptions.first;
    ContributionFrequency frequency = ContributionFrequency.monthly;
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
                      'Nueva meta de ahorro',
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
                                    : Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: savingsIconOptions.length,
                        itemBuilder: (context, index) {
                          final option = savingsIconOptions[index];
                          final isSelected = selectedIcon.id == option.id;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedIcon = option);
                            },
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? option.color.withOpacity(0.15)
                                    : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? option.color
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    option.icon,
                                    color: isSelected
                                        ? option.color
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? option.color
                                          : Colors.grey[600],
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
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
                      decoration: InputDecoration(
                        labelText: 'Nombre de la meta',
                        hintText: 'Ej: ${selectedIcon.label}...',
                        prefixIcon:
                            Icon(Icons.flag_rounded, color: selectedIcon.color),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) =>
                          v?.isEmpty ?? true ? 'Ingresa un nombre' : null,
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        final service = context.read<FinanceService>();
                        final settings = service.userSettings;
                        return TextFormField(
                          controller: targetController,
                          decoration: InputDecoration(
                            labelText: 'Monto objetivo',
                            prefixIcon: Icon(Icons.attach_money_rounded,
                                color: selectedIcon.color),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            NumberFormatInputFormatter(
                              thousandsSeparator: settings.thousandsSeparator,
                              decimalSeparator: settings.decimalSeparator,
                            ),
                          ],
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Ingresa el monto';
                            // Remover separadores antes de parsear
                            final cleanValue =
                                NumberFormatInputFormatter.removeFormatting(
                              v!,
                              settings.thousandsSeparator,
                              settings.decimalSeparator,
                            );
                            final parsed = double.tryParse(cleanValue);
                            if (parsed == null || parsed <= 0)
                              return 'Monto inválido';
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setState(() => targetDate = date);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha límite (opcional)',
                          prefixIcon: Icon(Icons.calendar_today_rounded,
                              color: selectedIcon.color),
                        ),
                        child: Text(
                          targetDate != null
                              ? DateFormat('d MMMM yyyy', 'es')
                                  .format(targetDate!)
                              : 'Sin fecha límite',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Frecuencia de aportes
                    DropdownButtonFormField<ContributionFrequency>(
                      value: frequency,
                      decoration: InputDecoration(
                        labelText: 'Frecuencia de aportes',
                        prefixIcon: Icon(Icons.repeat_rounded,
                            color: selectedIcon.color),
                      ),
                      items: ContributionFrequency.values.map((f) {
                        return DropdownMenuItem(
                          value: f,
                          child: Text(f.displayName),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          frequency = v!;
                          // Limpiar notificaciones cuando cambia la frecuencia
                          notificationDays = {};
                          notificationTime = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Campo de notificación - dinámico según frecuencia
                    InkWell(
                      onTap: () async {
                        NotificationConfig? result;
                        if (frequency == ContributionFrequency.weekly) {
                          result = await NotificationConfigDialog.showWeekly(
                            context: context,
                            title: 'Configurar recordatorio',
                            currentSelection: notificationDays,
                            currentTime: notificationTime,
                            helpText:
                                'Selecciona los días de la semana para recibir recordatorios',
                          );
                        } else {
                          String helpText;
                          if (frequency == ContributionFrequency.daily) {
                            helpText =
                                'Selecciona los días del mes para recordatorio diario';
                          } else if (frequency ==
                              ContributionFrequency.biweekly) {
                            helpText =
                                'Selecciona los días del mes para recordatorios quincenales (ej: día 1 y 15)';
                          } else {
                            helpText =
                                'Selecciona los días del mes para recibir recordatorios';
                          }
                          result = await NotificationConfigDialog.show(
                            context: context,
                            title: 'Configurar recordatorio',
                            currentSelection: notificationDays,
                            currentTime: notificationTime,
                            helpText: helpText,
                          );
                        }
                        if (result != null) {
                          setState(() {
                            notificationDays = result!.selection;
                            notificationTime = result.time;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Recordatorio de ahorro (opcional)',
                          prefixIcon: Icon(Icons.notifications_rounded,
                              color: selectedIcon.color),
                          helperText: _getNotificationHelperText(frequency),
                        ),
                        child: Text(
                          notificationDays.isNotEmpty
                              ? _formatNotificationDisplay(
                                  notificationDays, frequency, notificationTime)
                              : 'Sin notificación',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedIcon.color,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final service = context.read<FinanceService>();
                            final settings = service.userSettings;
                            // Remover separadores antes de parsear
                            final cleanValue =
                                NumberFormatInputFormatter.removeFormatting(
                              targetController.text,
                              settings.thousandsSeparator,
                              settings.decimalSeparator,
                            );
                            final goal = SavingsGoal(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              name: nameController.text.trim(),
                              targetAmount: double.parse(cleanValue),
                              createdAt: DateTime.now(),
                              targetDate: targetDate,
                              iconName: selectedIcon.id,
                              color: colorToHex(selectedIcon.color),
                              contributionFrequency: frequency,
                              notificationDays: notificationDays.isNotEmpty
                                  ? (notificationDays.toList()..sort())
                                      .join(',')
                                  : null,
                              notificationTime: notificationTime,
                            );
                            await service.addSavingsGoal(goal);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Meta creada')),
                            );
                          }
                        },
                        child: const Text('Crear meta'),
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

  void _showEditGoalDialog(
    BuildContext context,
    SavingsGoal goal,
    FinanceService service,
  ) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: goal.name);
    final settings = service.userSettings;
    final formattedTarget =
        settings.formatNumber(goal.targetAmount, decimals: 0);
    final targetController = TextEditingController(text: formattedTarget);
    DateTime? targetDate = goal.targetDate;
    SavingsIconOption selectedIcon = getSavingsIconById(goal.iconName);
    ContributionFrequency frequency = goal.contributionFrequency;
    Set<int> notificationDays = goal.notificationDaysList.toSet();
    String? notificationTime = goal.notificationTime;

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
                      'Editar meta de ahorro',
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
                                    : Colors.grey[700],
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: savingsIconOptions.length,
                        itemBuilder: (context, index) {
                          final option = savingsIconOptions[index];
                          final isSelected = selectedIcon.id == option.id;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedIcon = option);
                            },
                            child: Container(
                              width: 70,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? option.color.withOpacity(0.15)
                                    : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade100),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? option.color
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    option.icon,
                                    color: isSelected
                                        ? option.color
                                        : (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    option.label,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? option.color
                                          : Colors.grey[600],
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
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
                      decoration: InputDecoration(
                        labelText: 'Nombre de la meta',
                        prefixIcon:
                            Icon(Icons.flag_rounded, color: selectedIcon.color),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) =>
                          v?.isEmpty ?? true ? 'Ingresa un nombre' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: targetController,
                      decoration: InputDecoration(
                        labelText: 'Monto objetivo',
                        prefixIcon: Icon(Icons.attach_money_rounded,
                            color: selectedIcon.color),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        NumberFormatInputFormatter(
                          thousandsSeparator: settings.thousandsSeparator,
                          decimalSeparator: settings.decimalSeparator,
                        ),
                      ],
                      validator: (v) {
                        if (v?.isEmpty ?? true) return 'Ingresa el monto';
                        final cleanValue =
                            NumberFormatInputFormatter.removeFormatting(
                          v!,
                          settings.thousandsSeparator,
                          settings.decimalSeparator,
                        );
                        final parsed = double.tryParse(cleanValue);
                        if (parsed == null || parsed <= 0)
                          return 'Monto inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: targetDate ??
                              DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() => targetDate = date);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha límite (opcional)',
                          prefixIcon: Icon(Icons.calendar_today_rounded,
                              color: selectedIcon.color),
                        ),
                        child: Text(
                          targetDate != null
                              ? DateFormat('d MMMM yyyy', 'es')
                                  .format(targetDate!)
                              : 'Sin fecha límite',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Frecuencia de aportes
                    DropdownButtonFormField<ContributionFrequency>(
                      value: frequency,
                      decoration: InputDecoration(
                        labelText: 'Frecuencia de aportes',
                        prefixIcon: Icon(Icons.repeat_rounded,
                            color: selectedIcon.color),
                      ),
                      items: ContributionFrequency.values.map((f) {
                        return DropdownMenuItem(
                          value: f,
                          child: Text(f.displayName),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          frequency = v!;
                          // Limpiar notificaciones cuando cambia la frecuencia
                          notificationDays = {};
                          notificationTime = null;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Campo de notificación - dinámico según frecuencia
                    InkWell(
                      onTap: () async {
                        NotificationConfig? result;
                        if (frequency == ContributionFrequency.weekly) {
                          result = await NotificationConfigDialog.showWeekly(
                            context: context,
                            title: 'Configurar recordatorio',
                            currentSelection: notificationDays,
                            currentTime: notificationTime,
                            helpText:
                                'Selecciona los días de la semana para recibir recordatorios',
                          );
                        } else {
                          String helpText;
                          if (frequency == ContributionFrequency.daily) {
                            helpText =
                                'Selecciona los días del mes para recordatorio diario';
                          } else if (frequency ==
                              ContributionFrequency.biweekly) {
                            helpText =
                                'Selecciona los días del mes para recordatorios quincenales (ej: día 1 y 15)';
                          } else {
                            helpText =
                                'Selecciona los días del mes para recibir recordatorios';
                          }
                          result = await NotificationConfigDialog.show(
                            context: context,
                            title: 'Configurar recordatorio',
                            currentSelection: notificationDays,
                            currentTime: notificationTime,
                            helpText: helpText,
                          );
                        }
                        if (result != null) {
                          setState(() {
                            notificationDays = result!.selection;
                            notificationTime = result.time;
                          });
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Recordatorio de ahorro (opcional)',
                          prefixIcon: Icon(Icons.notifications_rounded,
                              color: selectedIcon.color),
                          helperText: _getNotificationHelperText(frequency),
                        ),
                        child: Text(
                          notificationDays.isNotEmpty
                              ? _formatNotificationDisplay(
                                  notificationDays, frequency, notificationTime)
                              : 'Sin notificación',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedIcon.color,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final cleanValue =
                                NumberFormatInputFormatter.removeFormatting(
                              targetController.text,
                              settings.thousandsSeparator,
                              settings.decimalSeparator,
                            );
                            final updatedGoal = goal.copyWith(
                              name: nameController.text.trim(),
                              targetAmount: double.parse(cleanValue),
                              targetDate: targetDate,
                              iconName: selectedIcon.id,
                              color: colorToHex(selectedIcon.color),
                              contributionFrequency: frequency,
                              notificationDays: notificationDays.isNotEmpty
                                  ? (notificationDays.toList()..sort())
                                      .join(',')
                                  : null,
                              notificationTime: notificationTime,
                            );
                            await service.updateSavingsGoal(updatedGoal);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Meta actualizada')),
                            );
                          }
                        },
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

  void _showAddContributionDialog(
    BuildContext context,
    SavingsGoal goal,
    FinanceService service,
  ) {
    final amountController = TextEditingController();
    final settings = service.userSettings;
    final currencyFormat = NumberFormat.currency(
      locale: 'es_MX',
      symbol: settings.currencySymbol,
      decimalDigits: 0,
    );

    // Obtener icono y color del bolsillo
    final iconOption = getSavingsIconById(goal.iconName);
    final goalColor =
        goal.color != null ? getColorFromHex(goal.color) : iconOption.color;

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
                    color: goalColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(iconOption.icon, color: goalColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agregar a "${goal.name}"',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Te faltan ${currencyFormat.format(goal.remainingAmount)}',
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
              controller: amountController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Monto a agregar',
                prefixIcon: Icon(Icons.attach_money_rounded, color: goalColor),
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
                    backgroundColor: goalColor.withOpacity(0.1),
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
                  backgroundColor: goalColor.withOpacity(0.1),
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
                  backgroundColor: goalColor,
                ),
                onPressed: () async {
                  // Remover separadores antes de parsear
                  final cleanValue =
                      NumberFormatInputFormatter.removeFormatting(
                    amountController.text,
                    settings.thousandsSeparator,
                    settings.decimalSeparator,
                  );
                  final amount = double.tryParse(cleanValue);
                  if (amount != null && amount > 0) {
                    await service.addSavingsContribution(goal.id, amount);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Agregaste ${currencyFormat.format(amount)} a ${goal.name}',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Agregar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDetails(
    BuildContext context,
    SavingsGoal goal,
    FinanceService service,
  ) {
    // Obtener icono y color del bolsillo
    final iconOption = getSavingsIconById(goal.iconName);
    final goalColor =
        goal.color != null ? getColorFromHex(goal.color) : iconOption.color;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final currencyFormat = NumberFormat.currency(
          locale: 'es_MX',
          symbol: service.userSettings.currencySymbol,
          decimalDigits: 2,
        );

        // Variables de estado declaradas fuera del builder para persistir
        ContributionFrequency currentFrequency = goal.contributionFrequency;
        Set<int> currentNotificationDays = goal.notificationDaysList.toSet();
        String? currentNotificationTime = goal.notificationTime;
        bool isNotificationEnabled = currentNotificationDays.isNotEmpty;

        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: goalColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(iconOption.icon,
                                color: goalColor, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              goal.name,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              Navigator.pop(context);
                              if (value == 'edit') {
                                _showEditGoalDialog(context, goal, service);
                              } else if (value == 'complete') {
                                await service.completeSavingsGoal(goal.id);
                              } else if (value == 'delete') {
                                await service.deleteSavingsGoal(goal.id);
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
                              if (goal.status == SavingsGoalStatus.active)
                                const PopupMenuItem(
                                  value: 'complete',
                                  child: Text('Marcar como completada'),
                                ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Eliminar',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow(
                        context,
                        'Progreso',
                        '${goal.progressPercentage.toStringAsFixed(1)}%',
                      ),
                      _buildDetailRow(
                        context,
                        'Ahorrado',
                        currencyFormat.format(goal.currentAmount),
                      ),
                      _buildDetailRow(
                        context,
                        'Objetivo',
                        currencyFormat.format(goal.targetAmount),
                      ),
                      _buildDetailRow(
                        context,
                        'Faltante',
                        currencyFormat.format(goal.remainingAmount),
                      ),
                      if (goal.targetDate != null) ...[
                        _buildDetailRow(
                          context,
                          'Fecha límite',
                          DateFormat('d MMMM yyyy', 'es')
                              .format(goal.targetDate!),
                        ),
                        if (goal.dailySavingsRequired != null)
                          _buildDetailRow(
                            context,
                            'Ahorro diario sugerido',
                            currencyFormat.format(goal.dailySavingsRequired!),
                          ),
                      ],
                      _buildDetailRow(
                        context,
                        'Frecuencia de aportes',
                        currentFrequency.displayName,
                      ),
                      const SizedBox(height: 20),

                      // Sección de notificación
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade900
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
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
                                          ? goalColor
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Recordatorio',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: isNotificationEnabled,
                                  onChanged: (value) async {
                                    if (value) {
                                      // Mostrar diálogo según frecuencia
                                      NotificationConfig? result;
                                      if (currentFrequency ==
                                          ContributionFrequency.weekly) {
                                        result = await NotificationConfigDialog
                                            .showWeekly(
                                          context: context,
                                          title: 'Configurar recordatorio',
                                          currentSelection:
                                              currentNotificationDays,
                                          currentTime: currentNotificationTime,
                                          helpText:
                                              'Selecciona los días de la semana para recordatorio',
                                        );
                                      } else {
                                        String helpText;
                                        if (currentFrequency ==
                                            ContributionFrequency.daily) {
                                          helpText =
                                              'Selecciona los días del mes para recordatorio diario';
                                        } else if (currentFrequency ==
                                            ContributionFrequency.biweekly) {
                                          helpText =
                                              'Selecciona los días del mes para recordatorios quincenales (ej: día 1 y 15)';
                                        } else {
                                          helpText =
                                              'Selecciona los días del mes para recordatorio';
                                        }
                                        result =
                                            await NotificationConfigDialog.show(
                                          context: context,
                                          title: 'Configurar recordatorio',
                                          currentSelection:
                                              currentNotificationDays,
                                          currentTime: currentNotificationTime,
                                          helpText: helpText,
                                        );
                                      }
                                      if (result != null && result.isNotEmpty) {
                                        final updatedGoal = goal.copyWith(
                                          notificationDays:
                                              (result.selection.toList()
                                                    ..sort())
                                                  .join(','),
                                          notificationTime: result.time,
                                        );
                                        await service
                                            .updateSavingsGoal(updatedGoal);
                                        setState(() {
                                          currentNotificationDays =
                                              result!.selection;
                                          currentNotificationTime = result.time;
                                          isNotificationEnabled = true;
                                        });
                                      }
                                    } else {
                                      // Si se desactiva, limpiar notificaciones
                                      final updatedGoal = goal.copyWith(
                                        notificationDays: null,
                                        notificationTime: null,
                                      );
                                      await service
                                          .updateSavingsGoal(updatedGoal);
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
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () async {
                                  NotificationConfig? result;
                                  if (currentFrequency ==
                                      ContributionFrequency.weekly) {
                                    result = await NotificationConfigDialog
                                        .showWeekly(
                                      context: context,
                                      title: 'Editar recordatorio',
                                      currentSelection: currentNotificationDays,
                                      currentTime: currentNotificationTime,
                                      helpText:
                                          'Selecciona los días de la semana para recordatorio',
                                    );
                                  } else {
                                    String helpText;
                                    if (currentFrequency ==
                                        ContributionFrequency.daily) {
                                      helpText =
                                          'Selecciona los días del mes para recordatorio diario';
                                    } else if (currentFrequency ==
                                        ContributionFrequency.biweekly) {
                                      helpText =
                                          'Selecciona los días del mes para recordatorios quincenales (ej: día 1 y 15)';
                                    } else {
                                      helpText =
                                          'Selecciona los días del mes para recordatorio';
                                    }
                                    result =
                                        await NotificationConfigDialog.show(
                                      context: context,
                                      title: 'Editar recordatorio',
                                      currentSelection: currentNotificationDays,
                                      currentTime: currentNotificationTime,
                                      helpText: helpText,
                                    );
                                  }
                                  if (result != null) {
                                    final updatedGoal = goal.copyWith(
                                      notificationDays: result.isNotEmpty
                                          ? (result.selection.toList()..sort())
                                              .join(',')
                                          : null,
                                      notificationTime: result.time,
                                    );
                                    await service
                                        .updateSavingsGoal(updatedGoal);
                                    setState(() {
                                      currentNotificationDays =
                                          result!.selection;
                                      currentNotificationTime = result.time;
                                      isNotificationEnabled = result.isNotEmpty;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _formatNotificationDisplay(
                                            currentNotificationDays,
                                            currentFrequency,
                                            currentNotificationTime,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit_rounded,
                                        size: 18,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 8),
                              Text(
                                'Activa las notificaciones para recibir recordatorios',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Historial de aportaciones',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<List<SavingsContribution>>(
                        future: service.getSavingsContributions(goal.id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'Sin aportaciones aún',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: snapshot.data!.map((contribution) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const CircleAvatar(
                                  child: Icon(Icons.add_rounded),
                                ),
                                title: Text(
                                  '+${currencyFormat.format(contribution.amount)}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('d MMM yyyy', 'es')
                                      .format(contribution.date),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 20), // Espacio al final
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

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
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

  /// Obtiene el texto de ayuda según la frecuencia
  String _getNotificationHelperText(ContributionFrequency frequency) {
    switch (frequency) {
      case ContributionFrequency.daily:
        return 'Selecciona días del mes para recordatorio';
      case ContributionFrequency.weekly:
        return 'Selecciona días de la semana y hora';
      case ContributionFrequency.biweekly:
        return 'Selecciona días del mes para recordatorios quincenales (ej: día 1 y 15)';
      case ContributionFrequency.monthly:
        return 'Selecciona días del mes y hora';
      case ContributionFrequency.custom:
        return 'Configura recordatorios personalizados';
    }
  }

  /// Formatea la visualización de las notificaciones según la frecuencia
  String _formatNotificationDisplay(
      Set<int> selection, ContributionFrequency frequency, String? time) {
    if (selection.isEmpty) return 'Sin notificación';

    switch (frequency) {
      case ContributionFrequency.weekly:
        return NotificationConfigDialog.formatWeekDaysDisplay(selection, time);
      case ContributionFrequency.biweekly:
      case ContributionFrequency.daily:
      case ContributionFrequency.monthly:
      case ContributionFrequency.custom:
        return NotificationConfigDialog.formatMonthDaysDisplay(selection, time);
    }
  }
}
