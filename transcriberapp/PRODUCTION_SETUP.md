# Production Setup Guide - Audio Transcriber

## 🚀 Pre-Production Checklist

### 1. Environment Configuration

#### Create .env file
Copy `.env.example` to `.env` and configure:
```bash
SERVER_URL=https://your-production-server.com
API_SECRET=your-secure-secret-key-here
```

**Important:**
- Never commit `.env` to version control
- Use a strong, randomly generated API secret
- Ensure your backend server is publicly accessible via HTTPS

### 2. Release Signing Configuration

#### Generate Release Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

#### Create key.properties
Create `android/key.properties`:
```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the key store file, e.g. /Users/<user name>/upload-keystore.jks>
```

#### Update build.gradle.kts
Add signing configuration to `android/app/build.gradle.kts`:
```kotlin
// Before android block
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            // Enable R8 code shrinking
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 3. Backend Server Requirements

Your Python backend must be:
- Hosted on a public server (not localhost/192.168.x.x)
- Using HTTPS (SSL certificate required)
- Configured with CORS for mobile app
- API secret validation enabled

### 4. Privacy Policy & Legal

**REQUIRED for Play Store:**
1. Create a privacy policy document
2. Host it publicly (GitHub Pages, your website, etc.)
3. Include in Play Console listing

**Must include:**
- What audio data you collect
- How it's processed/stored
- Third-party services used (Gemini AI)
- User rights (data deletion, access)
- Contact information

### 5. Play Store Assets

Prepare:
- App icon (512x512px PNG)
- Feature graphic (1024x500px)
- Screenshots (at least 2, max 8)
- App description
- Privacy policy URL

### 6. Build Release APK/AAB

```bash
# Clean build
flutter clean
flutter pub get

# Build release bundle (recommended for Play Store)
flutter build appbundle --release

# Or build APK
flutter build apk --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 7. Testing Checklist

Test on real devices:
- [ ] Share audio file from WhatsApp/Telegram
- [ ] Record live audio
- [ ] Play audio from history
- [ ] Delete recordings
- [ ] App works with no internet (shows proper error)
- [ ] Garbage audio detection works
- [ ] All buttons and navigation work
- [ ] No crashes on app kill during recording
- [ ] Permission requests work correctly

### 8. Play Store Submission

1. Create Google Play Console account ($25 one-time fee)
2. Complete store listing
3. Upload AAB file
4. Complete content rating questionnaire
5. Set pricing (Free/Paid)
6. Add privacy policy URL
7. Submit for review

**Review time:** 1-7 days

---

## 🔒 Security Best Practices

1. **Never hardcode secrets** in source code
2. **Use HTTPS** for all network communications
3. **Implement certificate pinning** for extra security (advanced)
4. **Enable ProGuard/R8** to obfuscate code
5. **Validate all user inputs** on backend
6. **Rate limit API** to prevent abuse
7. **Monitor backend logs** for suspicious activity

---

## 📊 Post-Launch Recommendations

### Analytics & Monitoring
- Firebase Crashlytics for crash reporting
- Firebase Analytics for user behavior
- Backend monitoring (Sentry, New Relic)

### User Feedback
- In-app rating prompt (after successful transcriptions)
- Feedback form in settings
- Monitor Play Store reviews

### Future Enhancements
- Offline mode with queue
- Multiple language support
- Cloud backup of transcriptions
- Share transcription to other apps
- Audio file format converter

---

## 🐛 Known Limitations

1. Maximum audio file size depends on backend timeout (currently 3 minutes)
2. Requires active internet connection
3. Audio quality affects transcription accuracy
4. Backend costs scale with usage

---

## 📞 Support

For issues:
1. Check backend server logs
2. Review device logs: `flutter logs`
3. Test with smaller audio files
4. Verify .env configuration

---

## ⚠️ Important Notes

- **Do NOT use debug signing** for production
- **Test on multiple Android versions** (Android 8-14)
- **Backup your keystore file** - if lost, you cannot update your app
- **Keep API secrets secure** - rotate if compromised
- **Monitor backend costs** - transcription API usage can be expensive

---

Good luck with your launch! 🚀
