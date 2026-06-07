# Play Store Deployment Guide

This guide outlines the steps to prepare and deploy **PDF Reader Pro** to the Google Play Store.

## 1. Preparation

### Versioning
Ensure the version in `pubspec.yaml` is updated:
```yaml
version: 1.0.0+1
```

### Android Configuration
Verify `android/app/build.gradle.kts`:
- `compileSdk = 36`
- `minSdk = 24`
- `targetSdk = 36`
- `applicationId = "com.anasgara.pdfreader"`

## 2. Signing the App

### Create a Keystore
If you don't have one, generate a upload keystore:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Configure key.properties
Create `android/key.properties` with the following:
```properties
storePassword=<your-password>
keyPassword=<your-password>
keyAlias=upload
storeFile=<path-to-keystore-file>
```

## 3. Build the App Bundle

Run the following command to generate the release App Bundle:
```bash
flutter build appbundle --release
```
The output will be located at:
`build/app/outputs/bundle/release/app-release.aab`

## 4. Google Play Console

1.  **Create App**: Go to [Google Play Console](https://play.google.com/console/) and create a new app.
2.  **App Setup**: Complete all tasks in the "Set up your app" section (Privacy Policy, Data Safety, etc.).
3.  **Production Release**:
    - Go to "Production" > "Create new release".
    - Upload the `.aab` file generated in Step 3.
    - Add release notes.
4.  **Review and Rollout**: Submit the release for review.

## 5. ProGuard Configuration
The app is configured to use ProGuard for code shrinking and obfuscation. Rules are located in `android/app/proguard-rules.pro`.

## 6. Data Safety Requirements
When filling out the Data Safety form in the Play Console:
- **Data Collection**: Select "No" (The app does not collect user data).
- **Security Practices**: Mention that data is encrypted in transit (if applicable) and users can request data deletion (though no data is stored on servers).
