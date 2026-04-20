import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService.instance.loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Transcriber',
          themeMode: ThemeService.instance.themeMode,
          
          // --- LIGHT THEME (Black Text) ---
          theme: _buildTheme(
            brightness: Brightness.light,
            background: const Color(0xFFF5F7FA), // Light Grey BG
            surface: Colors.white,               // White Cards
            text: const Color(0xFF1A1A1A),       // Pure Black Text
            subText: const Color(0xFF555555),    // Dark Grey Subtext
            shadow: Colors.blue.withValues(alpha: 0.08),
            iconColor: const Color(0xFF1A1A1A),
          ),

          // --- DARK THEME (White Text) ---
          darkTheme: _buildTheme(
            brightness: Brightness.dark,
            background: const Color(0xFF121212), // Dark BG
            surface: const Color(0xFF1E1E1E),    // Dark Cards
            text: const Color(0xFFFFFFFF),       // Pure White Text
            subText: const Color(0xFFCCCCCC),    // Light Grey Subtext
            shadow: Colors.black.withValues(alpha: 0.5),
            iconColor: Colors.white,
          ),

          home: const SplashScreen(),
        );
      },
    );
  }

  ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color text,
    required Color subText,
    required Color shadow,
    required Color iconColor,
  }) {
    final baseTheme = ThemeData(brightness: brightness);
    
    return baseTheme.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: const Color(0xFF448AFF),
      cardColor: surface,
      shadowColor: shadow,
      
      // Define Global Text Colors explicitly
      textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme).apply(
        bodyColor: text,
        displayColor: text,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
        titleTextStyle: GoogleFonts.poppins(
          color: text, 
          fontSize: 22, 
          fontWeight: FontWeight.w700
        ),
      ),
      
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shadowColor: shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      
      iconTheme: IconThemeData(color: iconColor),
    );
  }
}
