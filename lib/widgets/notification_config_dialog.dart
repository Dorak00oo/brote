import 'package:flutter/material.dart';

/// Clase para almacenar la configuración de notificación
class NotificationConfig {
  final Set<int> selection;
  final String? time;

  NotificationConfig({
    required this.selection,
    this.time,
  });

  bool get isEmpty => selection.isEmpty;
  bool get isNotEmpty => selection.isNotEmpty;
}

/// Tipo de frecuencia para notificaciones
enum NotificationFrequencyType {
  daysOfMonth,  // Días del mes (1-31)
  daysOfWeek,   // Días de la semana (1-7)
}

/// Widget de diálogo para configurar notificaciones
class NotificationConfigDialog {
  static const List<String> weekDayNames = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
  ];

  static const List<String> monthNames = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  /// Formatea la visualización de las notificaciones
  static String formatDisplay(
    Set<int> selection,
    NotificationFrequencyType type, {
    String? time,
  }) {
    if (selection.isEmpty) return 'Sin notificación';
    
    final sorted = selection.toList()..sort();
    String result = '';
    
    switch (type) {
      case NotificationFrequencyType.daysOfWeek:
        final dayNames = sorted.map((d) => 
          d >= 1 && d <= 7 ? weekDayNames[d - 1] : '$d'
        ).toList();
        result = dayNames.join(', ');
        break;
      case NotificationFrequencyType.daysOfMonth:
        result = 'Días: ${sorted.join(", ")}';
        break;
    }
    
    if (time != null && time.isNotEmpty) {
      result += ' a las $time';
    }
    
    return result;
  }

  /// Formatea un conjunto de días del mes para mostrar con hora
  static String formatMonthDaysDisplay(Set<int> selection, String? time) {
    if (selection.isEmpty) return 'Sin notificación';
    
    final sorted = selection.toList()..sort();
    String result = 'Días: ${sorted.join(", ")}';
    
    if (time != null && time.isNotEmpty) {
      result += ' a las $time';
    }
    
    return result;
  }

  /// Muestra el diálogo de configuración de notificaciones (días del mes + hora)
  static Future<NotificationConfig?> show({
    required BuildContext context,
    required String title,
    required Set<int> currentSelection,
    String? currentTime,
    String helpText = 'Selecciona los días del mes para recibir recordatorios',
  }) async {
    return showDialog<NotificationConfig>(
      context: context,
      builder: (dialogContext) {
        Set<int> tempSelection = Set.from(currentSelection);
        TimeOfDay tempTime = currentTime != null && currentTime.isNotEmpty
            ? TimeOfDay(
                hour: int.tryParse(currentTime.split(':')[0]) ?? 9,
                minute: int.tryParse(currentTime.split(':')[1]) ?? 0,
              )
            : const TimeOfDay(hour: 9, minute: 0);
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(helpText),
                      const SizedBox(height: 16),
                      
                      // Selector de días del mes
                      const Text('Días del mes:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: List.generate(31, (index) {
                          final day = index + 1;
                          final isSelected = tempSelection.contains(day);
                          return FilterChip(
                            label: Text('$day'),
                            selected: isSelected,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  tempSelection.add(day);
                                } else {
                                  tempSelection.remove(day);
                                }
                              });
                            },
                          );
                        }),
                      ),
                      
                      // Selector de hora (siempre visible cuando hay selección)
                      if (tempSelection.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text('Hora de notificación:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: tempTime,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    alwaysUse24HourFormat: true,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setDialogState(() => tempTime = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Icon(Icons.access_time_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() => tempSelection.clear());
                  },
                  child: const Text('Limpiar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final timeStr = tempSelection.isNotEmpty
                        ? '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}'
                        : null;
                    Navigator.pop(dialogContext, NotificationConfig(
                      selection: tempSelection,
                      time: timeStr,
                    ));
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Muestra el diálogo para frecuencia semanal (días de la semana)
  static Future<NotificationConfig?> showWeekly({
    required BuildContext context,
    required String title,
    required Set<int> currentSelection,
    String? currentTime,
    String helpText = 'Selecciona los días de la semana para recibir recordatorios',
  }) async {
    return showDialog<NotificationConfig>(
      context: context,
      builder: (dialogContext) {
        Set<int> tempSelection = Set.from(currentSelection);
        TimeOfDay tempTime = currentTime != null && currentTime.isNotEmpty
            ? TimeOfDay(
                hour: int.tryParse(currentTime.split(':')[0]) ?? 9,
                minute: int.tryParse(currentTime.split(':')[1]) ?? 0,
              )
            : const TimeOfDay(hour: 9, minute: 0);
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(helpText),
                      const SizedBox(height: 16),
                      
                      // Selector de días de la semana
                      const Text('Días de la semana:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(7, (index) {
                          final day = index + 1;
                          final isSelected = tempSelection.contains(day);
                          return FilterChip(
                            label: Text(weekDayNames[index]),
                            selected: isSelected,
                            onSelected: (selected) {
                              setDialogState(() {
                                if (selected) {
                                  tempSelection.add(day);
                                } else {
                                  tempSelection.remove(day);
                                }
                              });
                            },
                          );
                        }),
                      ),
                      
                      // Selector de hora
                      if (tempSelection.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text('Hora de notificación:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: tempTime,
                              builder: (context, child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    alwaysUse24HourFormat: true,
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setDialogState(() => tempTime = picked);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Icon(Icons.access_time_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() => tempSelection.clear());
                  },
                  child: const Text('Limpiar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final timeStr = tempSelection.isNotEmpty
                        ? '${tempTime.hour.toString().padLeft(2, '0')}:${tempTime.minute.toString().padLeft(2, '0')}'
                        : null;
                    Navigator.pop(dialogContext, NotificationConfig(
                      selection: tempSelection,
                      time: timeStr,
                    ));
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Formatea los días de la semana para mostrar
  static String formatWeekDaysDisplay(Set<int> selection, String? time) {
    if (selection.isEmpty) return 'Sin notificación';
    
    final sorted = selection.toList()..sort();
    final dayNames = sorted.map((d) => 
      d >= 1 && d <= 7 ? weekDayNames[d - 1] : '$d'
    ).toList();
    String result = dayNames.join(', ');
    
    if (time != null && time.isNotEmpty) {
      result += ' a las $time';
    }
    
    return result;
  }
}
