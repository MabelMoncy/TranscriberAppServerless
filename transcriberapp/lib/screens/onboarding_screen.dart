import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_key_manager.dart';
import 'audio_transcriber_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _keyController = TextEditingController();
  final ApiKeyManager _keyManager = ApiKeyManager();
  bool _isLoading = false;

  Future<void> _submitKey() async {
    final key = _keyController.text.trim();
    if (key.length < 10 || !key.startsWith("AIza")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Key. It must start with 'AIza'"), 
          backgroundColor: Colors.redAccent
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await _keyManager.saveApiKey(key);
    
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const AudioTranscriberPage()),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open link")),
        );
      }
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Header Logo ---
              const SizedBox(height: 20),
              Center(
                child: ClipOval(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.white, // Keep logo bg white or make transparent
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Welcome to Audio Transcriber",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your smart solution for WhatsApp Voice Transcription",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Get a free Gemini API Key to start.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, 
                  fontSize: 16
                ),
              ),

              const SizedBox(height: 20),

              // --- YouTube Tutorial Button ---
              OutlinedButton.icon(
                onPressed: () => _launchUrl("https://youtu.be/soB9zHm_o1s?si=fF5gVN97Vf0bZWaS"),
                icon: const Icon(Icons.play_circle_fill, color: Colors.red),
                label: Text("Watch Tutorial on YouTube", style: TextStyle(color: textColor)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 30),

              // --- Instructions ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Steps to Create API Key:", 
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 12),
                    _StepItem(text: "1. Go to Google AI Studio & Sign in"),
                    _StepItem(text: "2. Click 'Get API Key' (top-left)"),
                    _StepItem(text: "3. Click 'Create API Key'"),
                    _StepItem(text: "4. Create a new project if asked"),
                    _StepItem(text: "5. Keep Default project/Api key names"),
                    _StepItem(text: "6. Copy the key string"),
                    _StepItem(text: "7. Copy & Paste the API key below."),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Button: Open Google Studio ---
              ElevatedButton.icon(
                onPressed: () => _launchUrl('https://aistudio.google.com/app/apikey'),
                icon: const Icon(Icons.open_in_new, size: 18),
                label: const Text("Get Key from Google"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
              ),

              const SizedBox(height: 24),

              // --- Input Field ---
              TextField(
                controller: _keyController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: "Paste API Key Here",
                  hintText: "AIza...",
                  hintStyle: TextStyle(color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  prefixIcon: const Icon(Icons.vpn_key, color: Colors.blueAccent),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Submit Button ---
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitKey,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? Colors.white : Colors.black, 
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Save & Start App", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                  
               const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String text;
  const _StepItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text, 
              style: TextStyle(color: textColor, fontSize: 14, height: 1.4)
            )
          ),
        ],
      ),
    );
  }
}