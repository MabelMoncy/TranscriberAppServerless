import 'package:flutter/material.dart';
import '../services/api_key_manager.dart';
import 'onboarding_screen.dart';
import 'audio_transcriber_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiKeyManager _keyManager = ApiKeyManager();

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    // 1. Branding delay
    await Future.delayed(const Duration(seconds: 2));

    // 2. Check for key
    final apiKey = await _keyManager.getApiKey();

    if (!mounted) return;

    // 3. Navigate
    if (apiKey != null && apiKey.isNotEmpty) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const AudioTranscriberPage()),
      );
    } else {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dynamic Background
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- YOUR LOGO ---
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: const DecorationImage(
                  image: AssetImage('assets/icon/app_icon.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // --- App Name ---
            Text(
              "Audio Transcriber",
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                // Dynamic Text Color
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: 1.5
              ),
            ),
            
            const SizedBox(height: 50),
            
            // --- Loader ---
            const CircularProgressIndicator(color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}