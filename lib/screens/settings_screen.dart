import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../services/finance_service.dart';
import '../models/user_settings.dart';
import 'automatic_transactions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _versionTapCount = 0;
  DateTime? _lastTapTime;

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

              // Ingresos y pagos automáticos
              _buildSection(
                context,
                'Automatización',
                [
                  _buildAutomaticTransactionsSetting(context, service),
                ],
              ),
              const SizedBox(height: 24),

              // Apariencia
              _buildSection(
                context,
                'Apariencia',
                [
                  _buildAppearanceSettings(context, service),
                ],
              ),
              const SizedBox(height: 24),

              // Configuración de gráficos
              _buildSection(
                context,
                'Gráficos',
                [
                  _buildChartSettings(context, service),
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

              // Copia de seguridad
              _buildSection(
                context,
                'Copia de seguridad',
                [
                  _buildBackupOptions(context, service),
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
          onTap: () => _handleVersionTap(context),
        );
      },
    );
  }

  void _handleVersionTap(BuildContext context) {
    final now = DateTime.now();
    
    // Si pasó más de 2 segundos desde el último toque, reiniciar contador
    if (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds > 2) {
      _versionTapCount = 0;
    }
    
    _lastTapTime = now;
    _versionTapCount++;
    
    if (_versionTapCount >= 3) {
      _versionTapCount = 0;
      _showDeveloperMenu(context);
    }
  }

  Widget _buildBackupOptions(BuildContext context, FinanceService service) {
    return Column(
      children: [
        // Exportar datos
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.upload_rounded,
              color: Colors.green,
            ),
          ),
          title: const Text('Exportar todos los datos'),
          subtitle: const Text('Crear copia de seguridad completa'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _exportAllData(context, service),
        ),
        
        const Divider(indent: 72),
        
        // Importar datos
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.download_rounded,
              color: Colors.blue,
            ),
          ),
          title: const Text('Importar datos'),
          subtitle: const Text('Restaurar copia de seguridad'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _importData(context, service),
        ),
      ],
    );
  }

  void _showDeveloperMenu(BuildContext context) {
    final codeController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.developer_mode_rounded,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Menú Avanzado',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Campo de código
              Text(
                'Código de activación',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        hintText: 'Ingresa un código',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final code = codeController.text.trim();
                      if (code.isNotEmpty) {
                        Navigator.pop(context);
                        _processCode(context, code);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    child: const Text('Activar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportAllData(BuildContext context, FinanceService service) async {
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      // Exportar datos
      final data = await service.exportAllData();
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'brote_backup_$timestamp.json';
      
      // Guardar en carpeta de Descargas
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      
      final file = File('${downloadsDir.path}/$fileName');
      await file.writeAsString(jsonString);
      
      // Cerrar indicador de carga
      if (context.mounted) Navigator.pop(context);
      
      // Mostrar diálogo de éxito
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 48,
              ),
            ),
            title: const Text('¡Guardado!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'La copia de seguridad se guardó en:',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder_rounded, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Descargas/$fileName',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Share.shareXFiles(
                    [XFile(file.path)],
                    subject: 'Brote - Copia de seguridad',
                    text: 'Copia de seguridad de Brote',
                  );
                },
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text('Compartir'),
              ),
            ],
          ),
        );
      }
      
    } catch (e) {
      if (context.mounted) {
        // Intentar cerrar indicador si hay error
        try {
          Navigator.pop(context);
        } catch (_) {}
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, FinanceService service) async {
    // Capturar referencias antes de la operación asíncrona
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    FilePickerResult? result;
    
    try {
      // Seleccionar archivo
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error al seleccionar archivo: $e'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (result == null || result.files.isEmpty) return;
    
    // Verificar que sea un archivo JSON
    final fileName = result.files.single.name.toLowerCase();
    if (!fileName.endsWith('.json')) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Por favor selecciona un archivo .json'), backgroundColor: Colors.orange),
      );
      return;
    }
    
    try {
      debugPrint('=== IMPORTACIÓN: Iniciando lectura del archivo ===');
      final fileBytes = result.files.single.bytes;
      final filePath = result.files.single.path;
      debugPrint('Bytes: ${fileBytes?.length ?? 0}, Path: $filePath');
      
      String jsonString;
      
      if (fileBytes != null && fileBytes.isNotEmpty) {
        debugPrint('Leyendo desde bytes...');
        jsonString = utf8.decode(fileBytes);
        debugPrint('JSON leído: ${jsonString.length} caracteres');
      } else if (filePath != null) {
        debugPrint('Leyendo desde path: $filePath');
        final file = File(filePath);
        if (await file.exists()) {
          jsonString = await file.readAsString();
          debugPrint('JSON leído desde archivo: ${jsonString.length} caracteres');
        } else {
          throw Exception('El archivo no existe en: $filePath');
        }
      } else {
        throw Exception('No hay bytes ni path disponible');
      }
      
      if (jsonString.isEmpty) {
        throw Exception('El archivo está vacío');
      }
      
      debugPrint('Parseando JSON...');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      debugPrint('JSON parseado correctamente. Keys: ${data.keys.toList()}');
      
      // Verificar que tenga la estructura esperada
      if (!data.containsKey('version') && !data.containsKey('transactions')) {
        throw Exception('El archivo no parece ser una copia de seguridad válida de Brote');
      }
      
      // Mostrar información del backup
      final exportDate = data['exportDate'] as String?;
      final transactionCount = (data['transactions'] as List?)?.length ?? 0;
      final savingsCount = (data['savingsGoals'] as List?)?.length ?? 0;
      final loansCount = (data['loans'] as List?)?.length ?? 0;
      final investmentsCount = (data['investments'] as List?)?.length ?? 0;
      
      debugPrint('Datos encontrados: $transactionCount transacciones, $savingsCount ahorros, $loansCount préstamos, $investmentsCount inversiones');
      
      // Mostrar confirmación con detalles usando el contexto del navigator
      if (!mounted) {
        debugPrint('Widget no está montado, abortando');
        return;
      }
      
      debugPrint('Mostrando diálogo de confirmación...');
      final confirm = await showDialog<bool>(
        context: navigator.context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('¿Importar datos?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Esta acción reemplazará TODOS los datos existentes.\n',
              ),
              if (exportDate != null)
                Text('📅 Fecha del backup: ${exportDate.substring(0, 10)}'),
              const SizedBox(height: 8),
              Text('📊 Movimientos: $transactionCount'),
              Text('🐷 Metas de ahorro: $savingsCount'),
              Text('📈 Inversiones: $investmentsCount'),
              Text('💳 Préstamos: $loansCount'),
              const SizedBox(height: 12),
              const Text(
                '¿Deseas continuar?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Importar'),
            ),
          ],
        ),
      );
      
      debugPrint('Usuario confirmó: $confirm');
      if (confirm != true) {
        debugPrint('Usuario canceló la importación');
        return;
      }
      
      debugPrint('Mostrando indicador de carga...');
      // Mostrar indicador de carga
      if (mounted) {
        showDialog(
          context: navigator.context,
          barrierDismissible: false,
          builder: (ctx) => const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Importando datos...'),
              ],
            ),
          ),
        );
      }
      
      debugPrint('Limpiando datos actuales...');
      // Limpiar datos actuales
      await service.clearAllData();
      debugPrint('Datos limpiados');
      
      debugPrint('Importando nuevos datos...');
      // Importar nuevos datos
      await service.importAllData(data);
      debugPrint('Datos importados correctamente');
      
      // Cerrar indicador y mostrar éxito
      if (mounted) {
        debugPrint('Mostrando diálogo de éxito...');
        navigator.pop(); // Cerrar indicador de carga
        showDialog(
          context: navigator.context,
          builder: (dialogContext) => AlertDialog(
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 48,
              ),
            ),
            title: const Text('¡Importación exitosa!'),
            content: Text(
              'Se importaron:\n'
              '• $transactionCount movimientos\n'
              '• $savingsCount metas de ahorro\n'
              '• $investmentsCount inversiones\n'
              '• $loansCount préstamos',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      }
      
    } catch (e, stackTrace) {
      debugPrint('Error importing: $e');
      debugPrint('Stack: $stackTrace');
      
      if (mounted) {
        // Intentar cerrar el diálogo si está abierto
        try {
          navigator.pop();
        } catch (_) {}
        
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Error al importar: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _processCode(BuildContext context, String code) {
    // Aquí puedes agregar lógica para procesar códigos especiales
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código "$code" procesado'),
      ),
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
        // Usar Consumer para escuchar cambios del servicio
        return Consumer<FinanceService>(
          builder: (context, service, _) {
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
                            // El Consumer se encarga de actualizar la UI
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
                            // El Consumer se encarga de actualizar la UI
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  // Botón para restaurar predefinidas
                  TextButton.icon(
                    onPressed: () async {
                      await service.restoreAllDefaultCategories();
                      // El Consumer se encarga de actualizar la UI
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
        // Usar Consumer para escuchar cambios del servicio
        return Consumer<FinanceService>(
          builder: (context, service, _) {
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
                            // El Consumer se encarga de actualizar la UI
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
                            // El Consumer se encarga de actualizar la UI
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  // Botón para restaurar predefinidas
                  TextButton.icon(
                    onPressed: () async {
                      await service.restoreAllDefaultIncomeSources();
                      // El Consumer se encarga de actualizar la UI
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

  Widget _buildAutomaticTransactionsSetting(
    BuildContext context,
    FinanceService service,
  ) {
    return StreamBuilder(
      stream: service.watchRecurringTransactions(),
      builder: (context, snapshot) {
        final count = snapshot.data?.length ?? 0;
        return ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.autorenew_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: const Text('Ingresos y pagos automáticos'),
          subtitle: Text(
            count == 0
                ? 'Gestiona tus transacciones automáticas'
                : '$count automático${count == 1 ? '' : 's'} configurado${count == 1 ? '' : 's'}',
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AutomaticTransactionsScreen(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppearanceSettings(BuildContext context, FinanceService service) {
    final isDark = service.userSettings.theme == 'dark';
    final currentPalette = service.userSettings.colorPalette;
    
    return Column(
      children: [
        // Modo oscuro
        SwitchListTile(
          secondary: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: const Text('Modo Oscuro'),
          subtitle: Text(isDark ? 'Activado' : 'Desactivado'),
          value: isDark,
          onChanged: (value) {
            service.updateTheme(value ? 'dark' : 'light');
          },
        ),
        const Divider(indent: 72),
        // Paleta de colores
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.palette_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: const Text('Paleta de Colores'),
          subtitle: Text(currentPalette.displayName),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _showColorPaletteDialog(context, service),
        ),
      ],
    );
  }

  void _showColorPaletteDialog(BuildContext context, FinanceService service) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currentPalette = service.userSettings.colorPalette;
            final darkMode = service.userSettings.theme == 'dark';
            
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paleta de Colores',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Switch de modo oscuro
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dark_mode_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            const Text('Modo Oscuro'),
                          ],
                        ),
                        Switch(
                          value: darkMode,
                          onChanged: (value) {
                            service.updateTheme(value ? 'dark' : 'light');
                            setModalState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Opciones de paleta
                  _buildPaletteOption(
                    context,
                    service,
                    ColorPalette.green,
                    currentPalette,
                    setModalState,
                  ),
                  const SizedBox(height: 8),
                  _buildPaletteOption(
                    context,
                    service,
                    ColorPalette.blue,
                    currentPalette,
                    setModalState,
                  ),
                  const SizedBox(height: 8),
                  _buildPaletteOption(
                    context,
                    service,
                    ColorPalette.purple,
                    currentPalette,
                    setModalState,
                  ),
                  const SizedBox(height: 8),
                  _buildPaletteOption(
                    context,
                    service,
                    ColorPalette.pink,
                    currentPalette,
                    setModalState,
                  ),
                  const SizedBox(height: 16),
                  // Botón cerrar
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
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

  Widget _buildPaletteOption(
    BuildContext context,
    FinanceService service,
    ColorPalette palette,
    ColorPalette currentPalette,
    StateSetter setModalState,
  ) {
    final isSelected = palette == currentPalette;
    final colors = _getPaletteColors(palette);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        service.updateColorPalette(palette);
        setModalState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? colors['primary']! 
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icono de color
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors['primary'],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    palette.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1B1B1F),
                    ),
                  ),
                  Text(
                    palette.colorName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Muestra de colores
            Row(
              children: [
                _buildColorDot(colors['primary']!, isSelected),
                const SizedBox(width: 4),
                _buildColorDot(colors['secondary']!, isSelected),
                const SizedBox(width: 4),
                _buildColorDot(colors['tertiary']!, isSelected),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black12,
          width: 1,
        ),
      ),
    );
  }

  Map<String, Color> _getPaletteColors(ColorPalette palette) {
    switch (palette) {
      case ColorPalette.green:
        return {
          'primary': const Color(0xFF2D6A4F),
          'secondary': const Color(0xFF40916C),
          'tertiary': const Color(0xFF74C69D),
        };
      case ColorPalette.purple:
        return {
          'primary': const Color(0xFF6B21A8),
          'secondary': const Color(0xFF7C3AED),
          'tertiary': const Color(0xFFA78BFA),
        };
      case ColorPalette.pink:
        return {
          'primary': const Color(0xFFBE185D),
          'secondary': const Color(0xFFDB2777),
          'tertiary': const Color(0xFFF472B6),
        };
      case ColorPalette.blue:
        return {
          'primary': const Color(0xFF1D4ED8),
          'secondary': const Color(0xFF2563EB),
          'tertiary': const Color(0xFF60A5FA),
        };
    }
  }

  Widget _buildChartSettings(BuildContext context, FinanceService service) {
    return Column(
      children: [
        // Gráfico de tendencia
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.trending_up, color: Colors.blue),
          ),
          title: const Text('Gráfico de tendencia'),
          subtitle: Text(_getTrendChartTypeName(service.userSettings.trendChartType)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _showTrendChartTypeDialog(context, service),
        ),
        const Divider(height: 1),
        // Gráfico de ingresos
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.pie_chart, color: Colors.green),
          ),
          title: const Text('Gráfico de ingresos y gastos'),
          subtitle: Text(_getPieChartTypeName(service.userSettings.incomeChartType)),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _showPieChartTypeDialog(context, service, 'income'),
        ),
      ],
    );
  }

  String _getTrendChartTypeName(String type) {
    switch (type) {
      case 'line':
        return 'Líneas';
      case 'area':
        return 'Área';
      case 'candlestick':
        return 'Velas';
      default:
        return 'Barras';
    }
  }

  String _getPieChartTypeName(String type) {
    switch (type) {
      case 'donut':
        return 'Dona';
      case 'bar':
        return 'Barras';
      default:
        return 'Pastel';
    }
  }

  void _showTrendChartTypeDialog(BuildContext context, FinanceService service) {
    String selectedType = service.userSettings.trendChartType;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tipo de gráfico de tendencia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Barras'),
                value: 'bars',
                groupValue: selectedType,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    await service.updateChartSettings(trendChartType: value);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Líneas'),
                value: 'line',
                groupValue: selectedType,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    await service.updateChartSettings(trendChartType: value);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Área'),
                value: 'area',
                groupValue: selectedType,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    await service.updateChartSettings(trendChartType: value);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Velas'),
                value: 'candlestick',
                groupValue: selectedType,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    await service.updateChartSettings(trendChartType: value);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPieChartTypeDialog(
    BuildContext context,
    FinanceService service,
    String chartType,
  ) {
    // Usar el mismo tipo para ambos gráficos (enlazados)
    String selectedType = service.userSettings.incomeChartType;
    final title = 'Tipo de gráfico de ingresos y gastos';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Pastel'),
                value: 'pie',
                groupValue: selectedType,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    // Actualizar ambos gráficos con el mismo tipo
                    await service.updateChartSettings(
                      incomeChartType: value,
                      expenseChartType: value,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Dona'),
                value: 'donut',
                groupValue: selectedType,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    // Actualizar ambos gráficos con el mismo tipo
                    await service.updateChartSettings(
                      incomeChartType: value,
                      expenseChartType: value,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Barras'),
                value: 'bar',
                groupValue: selectedType,
                onChanged: (value) async {
                  if (value != null) {
                    setState(() {
                      selectedType = value;
                    });
                    // Actualizar ambos gráficos con el mismo tipo
                    await service.updateChartSettings(
                      incomeChartType: value,
                      expenseChartType: value,
                    );
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
