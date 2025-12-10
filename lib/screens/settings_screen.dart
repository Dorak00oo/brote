import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/finance_service.dart';
import '../models/user_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: Consumer<FinanceService>(
        builder: (context, service, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Configuración del período
              _buildSection(
                context,
                'Período Financiero',
                [
                  _buildMonthStartDaySetting(context, service),
                ],
              ),
              const SizedBox(height: 24),

              // Configuración del balance
              _buildSection(
                context,
                'Balance Total',
                [
                  _buildBalanceResetPeriodSetting(context, service),
                ],
              ),
              const SizedBox(height: 24),

              // Moneda
              _buildSection(
                context,
                'Moneda',
                [
                  _buildCurrencySetting(context, service),
                ],
              ),
              const SizedBox(height: 24),

              // Formato de números
              _buildSection(
                context,
                'Formato de números',
                [
                  _buildNumberFormatSetting(context, service),
                ],
              ),
              const SizedBox(height: 24),

              // Notificaciones
              _buildSection(
                context,
                'Notificaciones',
                [
                  _buildSwitchTile(
                    context,
                    'Notificaciones',
                    'Recibir notificaciones de la app',
                    service.userSettings.notificationsEnabled,
                    (value) => service.updateNotificationSettings(
                      notificationsEnabled: value,
                    ),
                  ),
                  _buildSwitchTile(
                    context,
                    'Alertas de presupuesto',
                    'Aviso cuando excedas tus límites',
                    service.userSettings.budgetAlertsEnabled,
                    (value) => service.updateNotificationSettings(
                      budgetAlertsEnabled: value,
                    ),
                  ),
                  _buildSwitchTile(
                    context,
                    'Recordatorios de préstamos',
                    'Aviso de pagos pendientes',
                    service.userSettings.loanRemindersEnabled,
                    (value) => service.updateNotificationSettings(
                      loanRemindersEnabled: value,
                    ),
                  ),
                  _buildSwitchTile(
                    context,
                    'Recordatorios de ahorro',
                    'Motivación para tus metas',
                    service.userSettings.savingsRemindersEnabled,
                    (value) => service.updateNotificationSettings(
                      savingsRemindersEnabled: value,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Categorías personalizadas
              _buildSection(
                context,
                'Categorías',
                [
                  _buildCategoriesSetting(context, service),
                ],
              ),
              const SizedBox(height: 24),

              // Información
              _buildSection(
                context,
                'Información',
                [
                  _buildVersionTile(context),
                ],
              ),
              const SizedBox(height: 100),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVersionTile(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      key: const ValueKey('version_tile'),
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Versión'),
            subtitle: Text('Cargando...'),
          );
        }
        if (snapshot.hasError) {
          return const ListTile(
            title: Text('Versión'),
            subtitle: Text('Error al cargar'),
          );
        }
        final version = snapshot.data?.version ?? 'Desconocida';
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: const Text('Versión'),
          subtitle: Text(version),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
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
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthStartDaySetting(
    BuildContext context,
    FinanceService service,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.calendar_month_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: const Text('Día de inicio del mes'),
      subtitle: Text(
        'Tu mes financiero inicia el día ${service.userSettings.monthStartDay}',
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${service.userSettings.monthStartDay}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      onTap: () => _showMonthStartDayPicker(context, service),
    );
  }

  void _showMonthStartDayPicker(BuildContext context, FinanceService service) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int selectedDay = service.userSettings.monthStartDay;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Día de inicio del mes',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecciona qué día del mes consideras como inicio de tu período financiero',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 28,
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final isSelected = day == selectedDay;

                        return GestureDetector(
                          onTap: () => setState(() => selectedDay = day),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '$day',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        await service.setMonthStartDay(selectedDay);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Tu mes ahora inicia el día $selectedDay',
                            ),
                          ),
                        );
                      },
                      child: const Text('Guardar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBalanceResetPeriodSetting(
    BuildContext context,
    FinanceService service,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.refresh_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: const Text('Período de reinicio del balance'),
      subtitle: Text(
        'El balance se reinicia: ${service.userSettings.balanceResetPeriod.displayName}',
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _showBalanceResetPeriodPicker(context, service),
    );
  }

  void _showBalanceResetPeriodPicker(
    BuildContext context,
    FinanceService service,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        var selectedPeriod = service.userSettings.balanceResetPeriod;
        var selectedDayOfMonth =
            service.userSettings.balanceResetDayOfMonth ?? 1;
        var selectedDayOfWeek = service.userSettings.balanceResetDayOfWeek ?? 1;

        return StatefulBuilder(
          builder: (context, setState) {
            String getPeriodDescription(BalanceResetPeriod period) {
              switch (period) {
                case BalanceResetPeriod.total:
                  return 'Muestra el balance acumulado desde el inicio';
                case BalanceResetPeriod.daily:
                  return 'Se reinicia cada día';
                case BalanceResetPeriod.weekly:
                  final weekDays = [
                    'Lunes',
                    'Martes',
                    'Miércoles',
                    'Jueves',
                    'Viernes',
                    'Sábado',
                    'Domingo'
                  ];
                  return 'Se reinicia cada ${weekDays[selectedDayOfWeek - 1]}';
                case BalanceResetPeriod.monthly:
                  return 'Se reinicia el día $selectedDayOfMonth de cada mes';
              }
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Período de reinicio del balance',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Selecciona cada cuánto tiempo se reinicia el balance en el home. El balance total acumulado siempre estará disponible en Estadísticas.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 24),
                        ...BalanceResetPeriod.values.map((period) {
                          final isSelected = period == selectedPeriod;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: () =>
                                  setState(() => selectedPeriod = period),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1)
                                      : (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked_rounded
                                          : Icons
                                              .radio_button_unchecked_rounded,
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            period.displayName,
                                            style: TextStyle(
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            getPeriodDescription(period),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                              .brightness ==
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
                              ),
                            ),
                          );
                        }),
                        // Selector de día del mes para período mensual
                        if (selectedPeriod == BalanceResetPeriod.monthly) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Día del mes',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: 28,
                              itemBuilder: (context, index) {
                                final day = index + 1;
                                final isSelected = day == selectedDayOfMonth;

                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedDayOfMonth = day),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : (Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey.shade800
                                              : Colors.grey.shade100),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$day',
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        // Selector de día de la semana para período semanal
                        if (selectedPeriod == BalanceResetPeriod.weekly) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Día de la semana',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              'Lunes',
                              'Martes',
                              'Miércoles',
                              'Jueves',
                              'Viernes',
                              'Sábado',
                              'Domingo',
                            ].asMap().entries.map((entry) {
                              final index = entry.key + 1;
                              final dayName = entry.value;
                              final isSelected = index == selectedDayOfWeek;

                              return ChoiceChip(
                                label: Text(dayName),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() => selectedDayOfWeek = index);
                                  }
                                },
                                selectedColor:
                                    Theme.of(context).colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () async {
                              await service.updateBalanceResetPeriod(
                                selectedPeriod,
                                dayOfMonth:
                                    selectedPeriod == BalanceResetPeriod.monthly
                                        ? selectedDayOfMonth
                                        : null,
                                dayOfWeek:
                                    selectedPeriod == BalanceResetPeriod.weekly
                                        ? selectedDayOfWeek
                                        : null,
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'El balance ahora se reinicia: ${selectedPeriod.displayName}',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Guardar'),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCurrencySetting(BuildContext context, FinanceService service) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.attach_money_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      title: const Text('Moneda'),
      subtitle: Text(
          '${service.userSettings.currency} (${service.userSettings.currencySymbol})'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _showCurrencyPicker(context, service),
    );
  }

  void _showCurrencyPicker(BuildContext context, FinanceService service) {
    final currencies = [
      {'code': 'COP', 'symbol': '\$', 'name': 'Peso Colombiano'},
      {'code': 'MXN', 'symbol': '\$', 'name': 'Peso Mexicano'},
      {'code': 'USD', 'symbol': '\$', 'name': 'Dólar Estadounidense'},
      {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
      {'code': 'ARS', 'symbol': '\$', 'name': 'Peso Argentino'},
      {'code': 'CLP', 'symbol': '\$', 'name': 'Peso Chileno'},
      {'code': 'PEN', 'symbol': 'S/', 'name': 'Sol Peruano'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.7,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecciona tu moneda',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: currencies.map((currency) {
                        final isSelected =
                            currency['code'] == service.userSettings.currency;
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                currency['symbol']!,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(currency['name']!),
                          subtitle: Text(currency['code']!),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                          onTap: () async {
                            await service.updateCurrency(
                              currency['code']!,
                              currency['symbol']!,
                            );
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNumberFormatSetting(
      BuildContext context, FinanceService service) {
    final example = service.formatCurrency(1234567.89);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.numbers_rounded,
          color: Colors.orange,
        ),
      ),
      title: const Text('Separador de miles'),
      subtitle: Text('Ejemplo: $example'),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => _showNumberFormatPicker(context, service),
    );
  }

  void _showNumberFormatPicker(BuildContext context, FinanceService service) {
    final formats = [
      {
        'name': 'Coma para miles, punto decimal',
        'thousands': ',',
        'decimal': '.',
        'example': '1,234,567.89',
      },
      {
        'name': 'Punto para miles, coma decimal',
        'thousands': '.',
        'decimal': ',',
        'example': '1.234.567,89',
      },
      {
        'name': 'Espacio para miles, coma decimal',
        'thousands': ' ',
        'decimal': ',',
        'example': '1 234 567,89',
      },
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Formato de números',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Elige cómo mostrar los números grandes',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              ...formats.map((format) {
                final isSelected = format['thousands'] ==
                        service.userSettings.thousandsSeparator &&
                    format['decimal'] == service.userSettings.decimalSeparator;
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade800
                              : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.numbers_rounded,
                      color: isSelected
                          ? Colors.white
                          : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600]),
                      size: 20,
                    ),
                  ),
                  title: Text(format['name']!),
                  subtitle: Text(
                    '\$${format['example']}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () async {
                    await service.updateNumberFormat(
                      thousandsSeparator: format['thousands']!,
                      decimalSeparator: format['decimal']!,
                    );
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildCategoriesSetting(BuildContext context, FinanceService service) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.category_rounded,
              color: Colors.red,
            ),
          ),
          title: const Text('Categorías de gastos'),
          subtitle: Text('${service.customCategories.length} personalizadas'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _showCategoriesManager(context, service),
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.attach_money_rounded,
              color: Colors.green,
            ),
          ),
          title: const Text('Fuentes de ingresos'),
          subtitle:
              Text('${service.customIncomeSources.length} personalizadas'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _showIncomeSourcesManager(context, service),
        ),
      ],
    );
  }

  void _showCategoriesManager(BuildContext context, FinanceService service) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Usar allExpenseCategories que ya filtra las ocultas
            final allCategories = service.allExpenseCategories;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Padding(
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
                      const Icon(Icons.category_rounded, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Categorías de gastos',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Nueva categoría',
                            prefixIcon: Icon(Icons.add_rounded),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (controller.text.isNotEmpty) {
                            await service
                                .addCustomCategory(controller.text.trim());
                            controller.clear();
                            setState(() {});
                          }
                        },
                        child: const Text('Agregar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tus categorías',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toca ✕ para eliminar una categoría',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (allCategories.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No hay categorías. Agrega una nueva o restaura las predefinidas.',
                          style: TextStyle(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allCategories.map((cat) {
                        final isDefault = FinanceService
                            .defaultExpenseCategories
                            .contains(cat);
                        return Chip(
                          label: Text(
                            cat,
                            style: TextStyle(
                              color: isDark
                                  ? (isDefault
                                      ? Colors.grey[300]
                                      : Theme.of(context).colorScheme.error)
                                  : (isDefault ? Colors.black87 : Colors.red[900]),
                            ),
                          ),
                          backgroundColor: isDefault
                              ? (isDark ? Colors.grey.shade800 : Colors.grey[100])
                              : (isDark
                                  ? Theme.of(context)
                                      .colorScheme
                                      .error
                                      .withOpacity(0.1)
                                  : Colors.red[50]),
                          deleteIcon: Icon(
                            Icons.close,
                            size: 18,
                            color: isDark
                                ? (isDefault
                                    ? Colors.grey[400]
                                    : Theme.of(context).colorScheme.error)
                                : (isDefault ? Colors.black54 : Colors.red[700]),
                          ),
                          onDeleted: () async {
                            if (isDefault) {
                              // Ocultar la categoría predefinida
                              await service.hideDefaultCategory(cat);
                            } else {
                              // Eliminar la categoría personalizada
                              await service.deleteCustomCategory(cat);
                            }
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  // Botón para restaurar predefinidas
                  TextButton.icon(
                    onPressed: () async {
                      await service.restoreAllDefaultCategories();
                      setState(() {});
                    },
                    icon: const Icon(Icons.restore_rounded, size: 18),
                    label: const Text('Restaurar predefinidas'),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showIncomeSourcesManager(BuildContext context, FinanceService service) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Usar allIncomeSources que ya filtra las ocultas
            final allSources = service.allIncomeSources;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Padding(
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
                      const Icon(Icons.attach_money_rounded,
                          color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Fuentes de ingresos',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Nueva fuente de ingreso',
                            prefixIcon: Icon(Icons.add_rounded),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () async {
                          if (controller.text.isNotEmpty) {
                            await service
                                .addCustomIncomeSource(controller.text.trim());
                            controller.clear();
                            setState(() {});
                          }
                        },
                        child: const Text('Agregar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Tus fuentes de ingreso',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toca ✕ para eliminar una fuente',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (allSources.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No hay fuentes. Agrega una nueva o restaura las predefinidas.',
                          style: TextStyle(color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allSources.map((source) {
                        final isDefault = FinanceService.defaultIncomeSources
                            .contains(source);
                        return Chip(
                          label: Text(
                            source,
                            style: TextStyle(
                              color: isDark
                                  ? (isDefault
                                      ? Colors.grey[300]
                                      : Theme.of(context).colorScheme.primary)
                                  : (isDefault ? Colors.black87 : Colors.green[900]),
                            ),
                          ),
                          backgroundColor: isDefault
                              ? (isDark ? Colors.grey.shade800 : Colors.grey[100])
                              : (isDark
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1)
                                  : Colors.green[50]),
                          deleteIcon: Icon(
                            Icons.close,
                            size: 18,
                            color: isDark
                                ? (isDefault
                                    ? Colors.grey[400]
                                    : Theme.of(context).colorScheme.primary)
                                : (isDefault ? Colors.black54 : Colors.green[700]),
                          ),
                          onDeleted: () async {
                            if (isDefault) {
                              // Ocultar la fuente predefinida
                              await service.hideDefaultIncomeSource(source);
                            } else {
                              // Eliminar la fuente personalizada
                              await service.deleteCustomIncomeSource(source);
                            }
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  // Botón para restaurar predefinidas
                  TextButton.icon(
                    onPressed: () async {
                      await service.restoreAllDefaultIncomeSources();
                      setState(() {});
                    },
                    icon: const Icon(Icons.restore_rounded, size: 18),
                    label: const Text('Restaurar predefinidas'),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
