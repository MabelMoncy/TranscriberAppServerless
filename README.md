# 🎤 Transcriber App - Solution for WhatsApps's unavailable regional Language Transcription
<div align="center">

![Project Banner](https://img.shields.io/badge/Made%20with-❤️-red)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)
![Gemini](https://img.shields.io/badge/Google-Gemini%202.5-orange?logo=google)

**A powerful, intelligent audio transcription application built with love for accessibility** 💙

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Deployment](#-deployment) • [License](#-license)

</div>

---

## 💝 A Personal Story

This project holds a special place in my heart. It was created for my father, who is hearing impaired, to help him convert audio messages, voice notes, and recordings into readable text. Watching him struggle to understand audio content inspired me to build something that could make his daily life easier.

**This is not just another project in my portfolio—it's one of my most cherished creations throughout my entire development journey.** Every line of code was written with purpose, every feature designed with empathy, and every bug fixed with determination. 

This app represents more than technology; it represents the power of using our skills to make a meaningful difference in the lives of those we love.

---

## 🌟 Features

### ⚡ Core Functionality
- 🎙️ **Real-time Audio Recording** - Record directly from your device
- 📁 **File Upload Support** - Import existing audio files from whatsapp (.opus)
- 🤖 **AI-Powered Transcription** - Powered by Google Gemini 2.5 with triple-fallback system
- 💾 **History Management** - Save, view, and manage all your transcriptions
- 🗑️ **Smart Garbage Detection** - Automatically filters out accidental or empty recordings
- 🔒 **Secure API** - Protected endpoints with secret-based authentication

### 🛡️ Advanced Features
- **Triple Safety Net Architecture**:
  - Primary: Gemini 2.5 Pro (High Intelligence)
  - Secondary: Gemini 2.5 Flash (High Speed)
  - Tertiary: Gemini 2.5 Flash Lite (Lightweight Backup)
- **Intelligent Error Handling** - Network timeouts, connectivity checks, and graceful failures
- **Cross-Platform** - Built with Flutter for Android (iOS support possible)
- **Offline Storage** - Local database for transcription history
- **Material Design 3** - Modern, beautiful UI with accessibility in mind

---

## 📸 Demo
![TranscriberAppImage](https://github.com/user-attachments/assets/5ac4be04-35dc-4119-91d4-92fd7b92d3ea)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         Flutter Mobile App              │
│  (Audio Recording + UI + History) 
│        Client Side Api call
└─────────────┬───────────────────────────┘
              │ Serverless
              ▼
┌─────────────────────────────────────────┐
│     Google Gemini 2.5 API               │
│  (Audio → Text Transcription)           │
└─────────────────────────────────────────┘
```

---

## 🚀 Installation

### Prerequisites

- **Flutter SDK**: 3.0 or higher
- **Google Gemini API Key**: Get it from [Google AI Studio](https://aistudio.google.com/app/apikey)
- **Git**: For cloning the repository

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/MabelMoncy/TranscriberAppServerless.git
cd TranscriberAppServerless
```

## 📱 Flutter App Setup

### Step 1: Navigate to App Directory

```bash
cd transcriberapp
```

### Step 2: Install Flutter Dependencies

```bash
flutter pub get
```

### Step 4: Run the App

```bash
# Check connected devices
flutter devices

# Run on connected device
flutter run

# Or build APK
flutter build apk --release
```
### Flutter App Deployment (Play Store)

1. **Generate Release Keystore**
2. **Configure Signing**
3. **Update Environment Variables** with production backend URL
4. **Build Release APK/AAB**
5. **Upload to Google Play Console**

📖 **Detailed Checklist**: See [transcriberapp/DEPLOYMENT_CHECKLIST.md](transcriberapp/DEPLOYMENT_CHECKLIST.md)

---

## 🎯 Usage

### Recording Audio

1. Open the app
2. Tap the **microphone button** to start recording
3. Speak clearly
4. Tap the **stop button** when finished
5. Wait for transcription (usually takes time since server is hosted for free)
6. View your transcribed text!

### Uploading Audio Files

1. Open WhatsApp and choose the voice message you want to transcribe
2. Long press and share to the app
3. Click the Start Transcription button
4. View the transcribed result and you can copy or share it.

### Managing History

1. Tap the **history button** (clock icon)
2. View all past transcriptions
3. Tap any entry to view details. You can View and also hear by taping the play button
4. For deleting tap the delete button

---

## 🛠️ Tech Stack

### Frontend (Mobile App)
- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **record** - Audio recording package
- **http** - API communication
- **sqflite** - Local database
- **flutter_dotenv** - Environment configuration

### AI & Cloud
- **Google Gemini 2.5** - Audio transcription
- **SQlite**

## 🔐 Security Features

- ✅ API Key Encryption
- ✅ Input validation and sanitization
- ✅ Garbage audio detection to prevent wasted API calls
---

## 🤝 Contributing

While this is a personal project, I welcome contributions! If you'd like to help improve it:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 Roadmap

- [ ] iOS support
- [ ] Multi-language transcription
- [ ] Speaker identification
- [ ] Export transcriptions (PDF, TXT)
- [ ] Real-time streaming transcription
- [ ] Voice-to-voice translation
- [ ] Cloud sync for history
- [ ] Dark mode improvements

---

## 🙏 Acknowledgments

- **My Father** - The inspiration behind this project
- **Google Gemini Team** - For the powerful AI API
- **Flutter Community** - For amazing packages and support
- **FastAPI Team** - For the excellent framework
- **Everyone** who believes in using technology for accessibility

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 About the Developer

**Mabel Moncy**

This project represents countless hours of learning, debugging, and determination. It taught me that the best code we write isn't for grades or portfolios—it's for the people we love.

If this project helps you or inspires you, please ⭐ star it on GitHub!

---

## 💬 Contact & Support

- **GitHub**: [@MabelMoncy](https://github.com/MabelMoncy)
- **Issues**: [Report a Bug](https://github.com/MabelMoncy/TranscriberAppRepo/issues)
- **Discussions**: [Ask Questions](https://github.com/MabelMoncy/TranscriberAppRepo/discussions)

---

<div align="center">

### Made with ❤️ for accessibility and inclusion

**"Technology should empower everyone, regardless of ability."**

If this project made a difference in your life or someone you know, I'd love to hear about it!

</div>

