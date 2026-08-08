# FRINKELs Pre-Release Verification Checklist (`RELEASE_CHECKLIST.md`)

Use this mandatory production release verification checklist prior to submitting FRINKELs to Google Play Console and Apple App Store Connect.

---

## ✅ Pre-Release Compliance Checklist

### 1. Codebase & Quality Assurance
- [ ] `flutter analyze` returns zero errors and zero warnings.
- [ ] `flutter test` passes 100% of unit, mock, and integration test cases.
- [ ] App version incremented in `pubspec.yaml` (`version: 1.0.0+100`).
- [ ] Obsolete debug prints and logging calls removed (`avoid_print`).

### 2. Security & Secrets
- [ ] Supabase Service Role key is NOT present anywhere in client code.
- [ ] Row Level Security (RLS) is enabled and active across all 24 database tables.
- [ ] SSL pinning and HTTPS strict transport encryption configured.
- [ ] Biometric & token storage configured with `FlutterSecureStorage`.

### 3. Store Compliance & Privacy Policies
- [ ] Privacy Policy URL active and updated with GDPR / CCPA statements.
- [ ] Account Deletion URL active (required by Apple App Store Guideline 5.1.1(v)).
- [ ] Terms of Service & EULA available inside app settings.
- [ ] Google Maps API key restricted to package name and SHA-1 fingerprint.

### 4. Performance & Assets
- [ ] Cold app launch time verified under 1.2 seconds on physical test hardware.
- [ ] Image assets compressed; no uncompressed PNGs over 500KB.
- [ ] App Bundle size verified under 25 MB.
- [ ] Crashlytics and Analytics verified receiving telemetry events.
