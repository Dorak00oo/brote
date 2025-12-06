import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/main_navigation.dart';
import 'services/finance_service.dart';
import 'database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar datos de localización para español
  await initializeDateFormatting('es', null);

  // Se configurará dinámicamente según el tema
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final database = AppDatabase();

    return ChangeNotifierProvider(
      create: (_) => FinanceService(database),
      child: Consumer<FinanceService>(
        builder: (context, financeService, _) {
          final themeValue = financeService.userSettings.theme;
          // Si el tema es null o 'light', usar modo claro; si es 'dark', usar modo oscuro
          final isDarkMode = themeValue == 'dark';

          // Actualizar SystemChrome según el tema inmediatamente
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  isDarkMode ? Brightness.light : Brightness.dark,
            ),
          );

          return MaterialApp(
            key: ValueKey('app_${isDarkMode ? 'dark' : 'light'}'),
            title: 'Brote - Finanzas',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainNavigation(),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    // Colores principales inspirados en naturaleza/crecimiento
    const primaryColor = Color(0xFF2D6A4F);
    const secondaryColor = Color(0xFF40916C);
    const tertiaryColor = Color(0xFF74C69D);
    const backgroundColor = Color(0xFFF8FAF9);
    const surfaceColor = Colors.white;
    const errorColor = Color(0xFFE63946);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1B1B1F),
        outline: const Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1B1B1F),
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1B1B1F),
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1B1B1F),
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1B1B1F),
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1B1B1F),
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1B1B1F),
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF1B1B1F),
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF49454F),
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1B1B1F),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: const Color(0xFF1B1B1F),
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1B1B1F),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: primaryColor),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFF9E9E9E),
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    // Colores principales para modo oscuro - verde más mate
    const primaryColor = Color(0xFF3D8B5F); // Verde más mate para modo oscuro
    const secondaryColor = Color(0xFF2E6B4A); // Verde secundario más mate
    const tertiaryColor = Color(0xFF2D6A4F);
    const backgroundColor = Color(0xFF121212);
    const surfaceColor = Color(0xFF1E1E1E);
    const errorColor = Color(0xFFEF5350);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        outline: const Color(0xFF3A3A3A),
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme:
          GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme)
              .copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey[300],
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: primaryColor),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A3A3A),
        thickness: 1,
      ),
    );
  }
}

// Extensión para colores personalizados
extension CustomColors on ColorScheme {
  Color get income => const Color(0xFF40916C);
  Color get expense => const Color(0xFFE63946);
  Color get investment => const Color(0xFF4361EE);
  Color get savings => const Color(0xFFF4A261);
  Color get loan => const Color(0xFF9D4EDD);
}
