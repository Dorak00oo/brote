import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'transactions_screen.dart';
import 'finance_hub_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import '../services/finance_service.dart';
import '../services/notification_service.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _hasCheckedPermissions = false;

  final List<Widget> _screens = const [
    HomeScreen(),
    TransactionsScreen(),
    FinanceHubScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    if (_hasCheckedPermissions) return;

    // Esperar a que el widget esté montado y el contexto esté disponible
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final service = Provider.of<FinanceService>(context, listen: false);
    final settings = service.userSettings;

    // Si ya se pidieron permisos, no hacer nada
    if (settings.notificationPermissionAsked) {
      if (mounted) {
        setState(() => _hasCheckedPermissions = true);
      }
      return;
    }

    // Verificar si los permisos ya están concedidos a nivel del sistema
    final notificationService = NotificationService();
    await notificationService.initialize();
    final alreadyGranted = await notificationService.checkPermissions();

    // Si ya están concedidos, marcar como preguntado y no mostrar diálogo
    if (alreadyGranted) {
      await service.markNotificationPermissionAsked();
      if (mounted) {
        setState(() => _hasCheckedPermissions = true);
      }
      return;
    }

    // Mostrar diálogo para pedir permisos
    final shouldRequest = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildPermissionDialog(context),
    );

    if (shouldRequest == true) {
      final permissionGranted = await notificationService.requestPermissions();

      if (permissionGranted) {
        await service.markNotificationPermissionAsked();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permisos de notificaciones concedidos'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Permisos de notificaciones denegados. Puedes activarlos desde Configuración'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }

    // Marcar como preguntado siempre, independientemente de la respuesta
    await service.markNotificationPermissionAsked();

    if (mounted) {
      setState(() => _hasCheckedPermissions = true);
    }
  }

  Widget _buildPermissionDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Permisos de notificaciones'),
          ),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Brote necesita permisos para enviarte recordatorios importantes:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          _PermissionItem(
            icon: Icons.account_balance_rounded,
            text: 'Recordatorios de pagos y cobros de préstamos',
          ),
          SizedBox(height: 12),
          _PermissionItem(
            icon: Icons.savings_rounded,
            text: 'Recordatorios para tus metas de ahorro',
          ),
          SizedBox(height: 12),
          _PermissionItem(
            icon: Icons.trending_up_rounded,
            text: 'Recordatorios sobre tus inversiones',
          ),
          SizedBox(height: 16),
          Text(
            'Puedes activar o desactivar las notificaciones en cualquier momento desde la configuración.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Ahora no'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Permitir'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildNavItem(0, Icons.home_rounded, 'Inicio')),
                Expanded(
                    child:
                        _buildNavItem(1, Icons.swap_horiz_rounded, 'Movim.')),
                Expanded(
                    child: _buildNavItem(
                        2, Icons.account_balance_wallet_rounded, 'Finanzas')),
                Expanded(
                    child: _buildNavItem(3, Icons.pie_chart_rounded, 'Stats')),
                Expanded(
                    child: _buildNavItem(4, Icons.settings_rounded, 'Ajustes')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : (isDarkMode ? Colors.grey[400] : const Color(0xFF9E9E9E));

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PermissionItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
