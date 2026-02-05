# 📋 Pre-Release Checklist - Audio Transcriber

## ✅ Configuration

- [ ] Created `.env` file with production SERVER_URL (HTTPS)
- [ ] Generated new secure API_SECRET
- [ ] Verified backend server is publicly accessible
- [ ] Backend has HTTPS/SSL certificate
- [ ] Tested API secret validation on backend
- [ ] Updated `android/app/build.gradle.kts` with release signing
- [ ] Created and stored keystore file securely
- [ ] Created `android/key.properties` file
- [ ] Added `key.properties` to `.gitignore`

## ✅ Code Quality

- [ ] Removed all debug print statements
- [ ] Fixed all lint warnings/errors
- [ ] No hardcoded URLs or secrets in code
- [ ] All TODOs resolved or documented
- [ ] Code formatted (`flutter format .`)
- [ ] Analyzed code (`flutter analyze`)

## ✅ Testing - Functional

- [ ] Share audio from WhatsApp works
- [ ] Share audio from Telegram works
- [ ] Share audio from Files app works
- [ ] Live recording works
- [ ] Audio playback in history works
- [ ] Delete recording works with confirmation
- [ ] Garbage audio detection works (shows orange error)
- [ ] Copy to clipboard works
- [ ] Share transcription works
- [ ] Navigation to history page works
- [ ] Back button from history works

## ✅ Testing - Edge Cases

- [ ] No internet connection shows proper error
- [ ] Very long audio files (10+ minutes)
- [ ] Very short audio files (< 1 second)
- [ ] Silent audio files
- [ ] Corrupted audio files
- [ ] App handles background/foreground transitions
- [ ] App handles incoming calls during recording
- [ ] App handles low storage warnings
- [ ] Delete works on files that don't exist
- [ ] Playback fails gracefully if file deleted externally

## ✅ Testing - Performance

- [ ] App launches within 3 seconds
- [ ] History loads quickly with 50+ recordings
- [ ] No memory leaks (checked with Flutter DevTools)
- [ ] No UI freezing during operations
- [ ] Smooth scrolling in history list
- [ ] Audio playback is smooth

## ✅ Permissions

- [ ] RECORD_AUDIO permission works
- [ ] Permission denial shows proper message
- [ ] READ_EXTERNAL_STORAGE works (for file sharing)
- [ ] All permissions explained in UI

## ✅ Security

- [ ] API secret not in source code
- [ ] HTTPS enforced (usesCleartextTraffic=false)
- [ ] No sensitive data logged
- [ ] Backend validates API secret
- [ ] Rate limiting enabled on backend
- [ ] Input validation on backend

## ✅ Privacy & Legal

- [ ] Privacy policy created
- [ ] Privacy policy hosted online
- [ ] Privacy policy URL ready for Play Store
- [ ] Data deletion mechanism works
- [ ] GDPR compliance checked (if targeting EU)
- [ ] Terms of service created (optional)

## ✅ Play Store Assets

- [ ] App icon (512x512px, PNG)
- [ ] Feature graphic (1024x500px, JPG/PNG)
- [ ] Screenshots (at least 2, various screen sizes)
  - [ ] Main screen
  - [ ] Recording screen
  - [ ] Success screen
  - [ ] History screen
- [ ] Short description (80 chars max)
- [ ] Full description (4000 chars max)
- [ ] App title finalized
- [ ] Category selected
- [ ] Content rating questionnaire completed

## ✅ Build Configuration

- [ ] App version incremented in pubspec.yaml
- [ ] Version code incremented
- [ ] Release signing configured
- [ ] ProGuard/R8 enabled
- [ ] Unused resources removed
- [ ] App size optimized (< 50MB recommended)

## ✅ Backend Preparation

- [ ] Server scaled for expected load
- [ ] Monitoring/alerting configured
- [ ] Error tracking setup (Sentry, etc.)
- [ ] Backup strategy in place
- [ ] Database backups automated
- [ ] API rate limits configured
- [ ] Cost estimation done for Gemini API usage

## ✅ Final Build

- [ ] Run `flutter clean`
- [ ] Run `flutter pub get`
- [ ] Run `flutter build appbundle --release`
- [ ] Verify AAB file created successfully
- [ ] AAB file size is reasonable (< 50MB)
- [ ] Test install AAB on real device

## ✅ Play Console Setup

- [ ] Google Play Console account created ($25 fee paid)
- [ ] App created in console
- [ ] Store listing completed
- [ ] Privacy policy URL added
- [ ] Content rating completed
- [ ] Pricing set (Free/Paid)
- [ ] Countries/regions selected
- [ ] AAB uploaded to production track
- [ ] Release notes written

## ✅ Post-Submission

- [ ] Submitted for review
- [ ] Monitoring email for review status
- [ ] Test version URL shared with beta testers (optional)
- [ ] Social media announcement prepared
- [ ] Support email/contact method setup
- [ ] Documentation updated

## ✅ Post-Launch Monitoring

- [ ] Check crash reports daily (first week)
- [ ] Monitor user reviews
- [ ] Track active users
- [ ] Monitor backend costs
- [ ] Check server load and response times
- [ ] Respond to user feedback

---

## 🚨 Critical: Do NOT Release Without

1. ✅ Release signing (not debug keys)
2. ✅ Privacy policy URL
3. ✅ Production backend URL (not localhost/192.168.x.x)
4. ✅ HTTPS enabled
5. ✅ All critical bugs fixed
6. ✅ Tested on real devices (not just emulator)
7. ✅ Content rating completed

---

## 📊 Success Metrics to Track

- Daily active users
- Transcription success rate
- Average transcription time
- User retention (Day 1, Day 7, Day 30)
- Crash-free sessions %
- Star rating average
- Backend API costs
- User feedback themes

---

## 🎯 Launch Day Checklist

- [ ] Final smoke test on production
- [ ] Backend scaled up
- [ ] Monitoring dashboards open
- [ ] Support channel ready
- [ ] Social media posts scheduled
- [ ] App approved and live on Play Store
- [ ] Celebrate! 🎉

---

**Last Updated:** {{ date }}
**App Version:** Check pubspec.yaml
**Reviewer:** _________________
