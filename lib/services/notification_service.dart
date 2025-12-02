import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Inicializar el servicio de notificaciones
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true, // Solicitar permisos automáticamente en iOS
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
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
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
        final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
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

    final id = notificationId ?? DateTime.now().millisecondsSinceEpoch % 2147483647;
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

    await _notifications.show(id, title, body, details, payload: 'loan_$loanName');
  }

  /// Enviar notificación de ahorro
  Future<void> showSavingsNotification({
    required String savingsName,
    int? notificationId,
  }) async {
    await initialize();

    final id = notificationId ?? DateTime.now().millisecondsSinceEpoch % 2147483647;
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

    await _notifications.show(id, title, body, details, payload: 'savings_$savingsName');
  }

  /// Enviar notificación de inversión
  Future<void> showInvestmentNotification({
    required String investmentName,
    int? notificationId,
  }) async {
    await initialize();

    final id = notificationId ?? DateTime.now().millisecondsSinceEpoch % 2147483647;
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

    await _notifications.show(id, title, body, details, payload: 'investment_$investmentName');
  }

  /// Cancelar todas las notificaciones
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Cancelar una notificación específica
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}

