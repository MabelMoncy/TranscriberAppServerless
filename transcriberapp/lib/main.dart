import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Make status bar transparent so our gradients shine through
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark, 
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transcriber',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA), // Soft Blue-Grey Background from image
        primaryColor: const Color(0xFF448AFF), // Electric Blue
        
        // --- TEXT THEME (Poppins) ---
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xFF2D3436), // Dark Grey Text
            displayColor: const Color(0xFF2D3436),
          ),
        ),

        // --- CARD THEME ---
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 8,
          shadowColor: const Color(0xFF448AFF).withOpacity(0.15), // Colored Shadow
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),

        // --- APP BAR THEME ---
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Transparent to show background
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF2D3436)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2D3436), 
            fontSize: 22, 
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins' // Force font on AppBar
          ),
        ),
        
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}