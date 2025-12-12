import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _timezoneInitialized = false;

  /// Inicializar el servicio de notificaciones
  Future<void> initialize() async {
    if (_initialized) return;

    // Inicializar timezone si no está inicializado
    if (!_timezoneInitialized) {
      tz_data.initializeTimeZones();
      _timezoneInitialized = true;
    }

    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission:
            true, // Solicitar permisos automáticamente en iOS
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final initialized = await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized != true) {
        debugPrint('Error: No se pudo inicializar las notificaciones');
        return;
      }

      _initialized = true;
    } catch (e) {
      debugPrint('Error al inicializar notificaciones: $e');
      // No lanzar excepción, solo loguear el error
    }
  }

  /// Solicitar permisos de notificaciones
  Future<bool> requestPermissions() async {
    await initialize();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidPlugin =
            _notifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidPlugin?.requestNotificationsPermission();
        return granted ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // En iOS, los permisos se solicitan automáticamente al inicializar
        // con requestAlertPermission: true. Simplemente retornamos true
        // ya que la solicitud se hace en initialize()
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error al solicitar permisos: $e');
      return false;
    }
  }

  /// Verificar si se tienen permisos de notificaciones
  Future<bool> checkPermissions() async {
    await initialize();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidPlugin =
            _notifications.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidPlugin?.areNotificationsEnabled();
        return granted ?? false;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // En iOS, asumimos que si se inicializó correctamente, los permisos están
        return _initialized;
      }
      return false;
    } catch (e) {
      debugPrint('Error al verificar permisos: $e');
      return false;
    }
  }

  /// Manejar cuando se toca una notificación
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notificación tocada: ${response.payload}');
  }

  /// Enviar notificación de préstamo
  Future<void> showLoanNotification({
    required String loanName,
    required bool isPayment, // true = pago, false = cobro
    int? notificationId,
  }) async {
    await initialize();

    final id =
        notificationId ?? DateTime.now().millisecondsSinceEpoch % 2147483647;
    final title = isPayment ? 'Recordatorio de pago' : 'Recordatorio de cobro';
    final body = isPayment
        ? 'No olvides realizar el pago de: $loanName'
        : 'Recuerda cobrar: $loanName';

    const androidDetails = AndroidNotificationDetails(
      'loans_channel',
      'Préstamos',
      channelDescription: 'Notificaciones de préstamos',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details,
        payload: 'loan_$loanName');
  }

  /// Enviar notificación de ahorro
  Future<void> showSavingsNotification({
    required String savingsName,
    int? notificationId,
  }) async {
    await initialize();

    final id =
        notificationId ?? DateTime.now().millisecondsSinceEpoch % 2147483647;
    const title = 'Recordatorio de ahorro';
    final body = 'Es un buen día para aportar a: $savingsName';

    const androidDetails = AndroidNotificationDetails(
      'savings_channel',
      'Ahorros',
      channelDescription: 'Notificaciones de ahorros',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details,
        payload: 'savings_$savingsName');
  }

  /// Enviar notificación de inversión
  Future<void> showInvestmentNotification({
    required String investmentName,
    int? notificationId,
  }) async {
    await initialize();

    final id =
        notificationId ?? DateTime.now().millisecondsSinceEpoch % 2147483647;
    const title = 'Recordatorio de inversión';
    final body = 'Revisa el estado de: $investmentName';

    const androidDetails = AndroidNotificationDetails(
      'investments_channel',
      'Inversiones',
      channelDescription: 'Notificaciones de inversiones',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details,
        payload: 'investment_$investmentName');
  }

  /// Cancelar todas las notificaciones
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Cancelar una notificación específica
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// Programar notificación para transacción automática
  Future<void> scheduleAutomaticTransactionNotification({
    required String automaticId,
    required String title,
    required double amount,
    required bool isIncome,
    required String frequency,
    int? dayOfMonth,
    int? dayOfWeek,
    required DateTime startDate,
    DateTime? endDate,
    required int notificationHour,
    required int notificationMinute,
  }) async {
    await initialize();

    // Generar ID único basado en el ID del automático
    final notificationId = automaticId.hashCode.abs() % 2147483647;

    final notificationTitle = isIncome ? 'Recordatorio de ingreso' : 'Recordatorio de pago';
    final notificationBody = isIncome
        ? 'Hoy recibirás: $title - ${_formatAmount(amount)}'
        : 'Hoy debes pagar: $title - ${_formatAmount(amount)}';

    const androidDetails = AndroidNotificationDetails(
      'automatic_transactions_channel',
      'Transacciones Automáticas',
      channelDescription: 'Notificaciones de ingresos y pagos automáticos',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Calcular la próxima fecha según la frecuencia
    final nextDate = _calculateNextNotificationDate(
      frequency: frequency,
      dayOfMonth: dayOfMonth,
      dayOfWeek: dayOfWeek,
      startDate: startDate,
      endDate: endDate,
      notificationHour: notificationHour,
      notificationMinute: notificationMinute,
    );

    if (nextDate == null) {
      debugPrint('No se puede programar notificación: fecha inválida');
      return;
    }

    try {
      final tzDateTime = tz.TZDateTime.from(nextDate, tz.local);
      final matchComponents = _getDateTimeComponents(frequency, dayOfWeek);
      
      if (matchComponents != null) {
        // Usar matchDateTimeComponents para notificaciones recurrentes
        await _notifications.zonedSchedule(
          notificationId,
          notificationTitle,
          notificationBody,
          tzDateTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'automatic_$automaticId',
          matchDateTimeComponents: matchComponents,
        );
      } else {
        // Para frecuencias sin soporte de matchDateTimeComponents, programar una sola vez
        await _notifications.zonedSchedule(
          notificationId,
          notificationTitle,
          notificationBody,
          tzDateTime,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: 'automatic_$automaticId',
        );
      }
      debugPrint('Notificación programada para $nextDate (frecuencia: $frequency)');
    } catch (e) {
      debugPrint('Error al programar notificación: $e');
    }
  }

  /// Cancelar notificación de transacción automática
  Future<void> cancelAutomaticTransactionNotification(String automaticId) async {
    final notificationId = automaticId.hashCode.abs() % 2147483647;
    await cancel(notificationId);
  }

  /// Calcular la próxima fecha de notificación
  DateTime? _calculateNextNotificationDate({
    required String frequency,
    int? dayOfMonth,
    int? dayOfWeek,
    required DateTime startDate,
    DateTime? endDate,
    required int notificationHour,
    required int notificationMinute,
  }) {
    final now = DateTime.now();
    
    // Si hay fecha de fin y ya pasó, no programar
    if (endDate != null && endDate.isBefore(now)) {
      return null;
    }

    // Si la fecha de inicio es en el futuro, usar esa
    if (startDate.isAfter(now)) {
      return DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        notificationHour,
        notificationMinute,
      );
    }

    DateTime nextDate;

    switch (frequency) {
      case 'weekly':
        if (dayOfWeek == null) return null;
        // Calcular próximo día de la semana
        final daysUntilNext = (dayOfWeek - now.weekday + 7) % 7;
        nextDate = daysUntilNext == 0
            ? now.add(const Duration(days: 7))
            : now.add(Duration(days: daysUntilNext));
        break;

      case 'biweekly':
        // Cada 14 días desde la fecha de inicio
        final daysSinceStart = now.difference(startDate).inDays;
        final periodsPassed = daysSinceStart ~/ 14;
        nextDate = startDate.add(Duration(days: (periodsPassed + 1) * 14));
        break;

      case 'monthly':
        if (dayOfMonth == null) return null;
        // Próximo mes con el día especificado
        nextDate = DateTime(now.year, now.month, dayOfMonth, notificationHour, notificationMinute);
        if (nextDate.isBefore(now) || (nextDate.day != dayOfMonth)) {
          // Si ya pasó este mes o el día no existe, ir al siguiente mes
          nextDate = DateTime(now.year, now.month + 1, dayOfMonth, notificationHour, notificationMinute);
        }
        break;

      case 'quarterly':
        // Cada 3 meses desde la fecha de inicio
        final monthsSinceStart = (now.year - startDate.year) * 12 + now.month - startDate.month;
        final quartersPassed = monthsSinceStart ~/ 3;
        nextDate = DateTime(
          startDate.year,
          startDate.month + (quartersPassed + 1) * 3,
          startDate.day,
          notificationHour,
          notificationMinute,
        );
        break;

      case 'yearly':
        // Cada año desde la fecha de inicio
        nextDate = DateTime(
          now.year + 1,
          startDate.month,
          startDate.day,
          notificationHour,
          notificationMinute,
        );
        break;

      default:
        return null;
    }

    // Asegurar que la hora y minuto sean correctos
    nextDate = DateTime(
      nextDate.year,
      nextDate.month,
      nextDate.day,
      notificationHour,
      notificationMinute,
    );

    // Si hay fecha de fin y la próxima fecha la excede, no programar
    if (endDate != null && nextDate.isAfter(endDate)) {
      return null;
    }

    return nextDate;
  }

  /// Obtener componentes de fecha/hora para notificaciones recurrentes
  DateTimeComponents? _getDateTimeComponents(String frequency, int? dayOfWeek) {
    switch (frequency) {
      case 'weekly':
        if (dayOfWeek == null) return null;
        // Mapear día de la semana (1=lunes, 7=domingo) a DateTimeComponents
        switch (dayOfWeek) {
          case 1:
            return DateTimeComponents.dayOfWeekAndTime;
          case 2:
            return DateTimeComponents.dayOfWeekAndTime;
          case 3:
            return DateTimeComponents.dayOfWeekAndTime;
          case 4:
            return DateTimeComponents.dayOfWeekAndTime;
          case 5:
            return DateTimeComponents.dayOfWeekAndTime;
          case 6:
            return DateTimeComponents.dayOfWeekAndTime;
          case 7:
            return DateTimeComponents.dayOfWeekAndTime;
          default:
            return null;
        }
      case 'monthly':
        return DateTimeComponents.dayOfMonthAndTime;
      case 'yearly':
        return DateTimeComponents.dateAndTime;
      default:
        return null;
    }
  }

  /// Formatear monto para notificación
  String _formatAmount(double amount) {
    // Formato simple, se puede mejorar usando NumberFormat
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return '\$${amount.toStringAsFixed(0)}';
    }
  }
}
