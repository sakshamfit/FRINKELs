# FRINKELs Enterprise Deployment Guide (`DEPLOYMENT_GUIDE.md`)
**Prepared by**: Lead DevOps & Platform Reliability Engineer  
**Target Environments**: Android (AAB), iOS (IPA / TestFlight), Web (SPA), Supabase Cloud, Firebase

---

## 🚀 Environment Architecture & Setup

FRINKELs operates across three isolated environments:
1. **Development (`dev`)**: Local Flutter client connected to local Supabase CLI instance (`127.0.0.1:54321`).
2. **Staging (`staging`)**: Staging Flutter builds connected to Supabase Staging project (`staging-xyz.supabase.co`).
3. **Production (`prod`)**: Production Flutter builds connected to Supabase Production instance (`prod-xyz.supabase.co`) with Firebase Analytics & Crashlytics active.

---

## 🛠️ Step-by-Step Production Build Instructions

### 1. Android Production Build (`.aab`)
1. Ensure `android/key.properties` contains valid Keystore secrets:
   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=frinkels-key-alias
   storeFile=../frinkels-release.jks
   ```
2. Execute production bundle command:
   ```bash
   flutter build appbundle --release --build-name=1.0.0 --build-number=100 --flavor prod -t lib/main.dart
   ```
3. Output AAB path: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`.

---

### 2. iOS Production Build (`.ipa`)
1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select target `Runner`, configure Release Provisioning Profile & Distribution Signing Certificate under **Signing & Capabilities**.
3. Execute Flutter release build:
   ```bash
   flutter build ipa --release --build-name=1.0.0 --build-number=100 -t lib/main.dart
   ```
4. Upload generated IPA to Apple App Store Connect via Xcode Transporter / Fastlane.

---

### 3. Web SPA Build (Vercel / Cloudflare Pages)
1. Execute Flutter web production build:
   ```bash
   flutter build web --release --web-renderer canvaskit -t lib/main.dart
   ```
2. Deploy contents of `build/web/` to Vercel / Cloudflare Pages.

---

## 🔒 Secret Vaulting & Management

| Secret Key | Allowed Location | Usage |
|---|---|---|
| `SUPABASE_ANON_KEY` | `.env`, GitHub Secrets, App Binary | Client API Requests |
| `SUPABASE_SERVICE_ROLE_KEY` | GitHub Secrets, Supabase Dashboard ONLY | **NEVER in Client App** |
| `GOOGLE_MAPS_API_KEY_ANDROID` | `android/app/src/main/AndroidManifest.xml`, Secrets | Google Maps SDK |
| `GOOGLE_MAPS_API_KEY_IOS` | `ios/Runner/AppDelegate.swift`, Secrets | Google Maps iOS SDK |
| `ANDROID_KEYSTORE_BASE64` | GitHub Secrets | Automated AAB Signing |
