# Native Authentication Setup Guide

This guide explains how to set up native Google Sign-In and deep linking for email verification in the Nashik Darshan app.

## Features Implemented

1. **Native Google Sign-In**: Uses `google_sign_in` package for in-app Google authentication
2. **Deep Linking**: Handles email verification and password reset links within the app
3. **Access Token Handling**: Properly manages access tokens after successful authentication

## Important: Understanding OAuth Client Configuration for Supabase

**This app uses Supabase (NOT Firebase)**, so you don't need Firebase configuration files.

When you create an OAuth client ID in Google Cloud Console, you might see options to download:

- **Client Secret JSON** (e.g., `client_secret_xxx.json`) - This is for **server-side** OAuth flows, **NOT needed** for this Flutter app
- **google-services.json** - This is only needed if you're using **Firebase**, which this app does **NOT** use (we use Supabase instead)

**What you actually need for Supabase:**

1. Create OAuth client IDs in Google Cloud Console (one for Android, one for iOS)
2. Copy the **OAuth Client ID** values (the strings that look like `xxx.apps.googleusercontent.com`)
3. Add those Client IDs to Supabase under Authentication → Providers → Google
4. The `google_sign_in` package automatically uses the OAuth client ID from Google Cloud Console
5. **No JSON files need to be downloaded or added to your project**

**How the flow works:**

1. User signs in with Google using `google_sign_in` package (native sign-in)
2. App receives Google ID token and access token
3. App sends tokens to Supabase using `signInWithIdToken()`
4. Supabase verifies tokens and creates/updates user session
5. User is authenticated in your app via Supabase

After creating the OAuth client ID, you'll see it listed in the Credentials page. Copy the **Client ID** (not the client secret) and add it to Supabase.

## Setup Instructions

### 1. Google Sign-In Configuration

#### Android Setup

1. **Get SHA-1 Certificate Fingerprint**:

   ```bash
   # Debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

   # Release keystore (if you have one)
   keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
   ```

2. **Configure OAuth Client in Google Cloud Console**:

   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select existing one
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth client ID"
   - If prompted, configure the OAuth consent screen first
   - Select "Android" application type
   - Enter your package name: `com.caygnus.nashikdarshan`
   - Enter the SHA-1 fingerprint from step 1
   - Click "Create"
   - **Note**: You don't need to download any JSON file. The OAuth client ID is automatically used by the `google_sign_in` package.

3. **Important Notes**:
   - The `google_sign_in` package automatically uses the OAuth client ID from Google Cloud Console
   - You don't need `google-services.json` (that's only for Firebase)
   - The client_secret JSON file you might see is for server-side OAuth flows, not needed for Flutter app
   - Make sure to create separate OAuth client IDs for both debug and release keystores if you're using different SHA-1 fingerprints

#### iOS Setup

1. **Get Bundle ID**:

   - Check your bundle ID in Xcode (should be `com.caygnus.nashikdarshan`)

2. **Configure OAuth Client in Google Cloud Console**:

   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth client ID"
   - Select "iOS" application type
   - Enter your Bundle ID: `com.caygnus.nashikdarshan`
   - Click "Create"
   - **Note**: You don't need to download `GoogleService-Info.plist` (that's only for Firebase). The OAuth client ID is automatically used by the `google_sign_in` package.

3. **Update Info.plist**:
   - URL scheme is already configured in `ios/Runner/Info.plist`:
     ```xml
     <key>CFBundleURLTypes</key>
     <array>
         <dict>
             <key>CFBundleTypeRole</key>
             <string>Editor</string>
             <key>CFBundleURLName</key>
             <string>com.caygnus.nashikdarshan</string>
             <key>CFBundleURLSchemes</key>
             <array>
                 <string>com.caygnus.nashikdarshan</string>
             </array>
         </dict>
     </array>
     ```

### 2. Supabase Configuration

Since you're using Supabase for authentication, configure the following in your Supabase Dashboard:

1. **Configure Redirect URLs in Supabase Dashboard**:

   - Go to your Supabase project → Authentication → URL Configuration
   - Under "Redirect URLs", add these deep link URLs:
     - `com.caygnus.nashikdarshan://login-callback/`
     - `com.caygnus.nashikdarshan://reset-password/`
     - `com.caygnus.nashikdarshan://verify-email/`
   - Click "Save" to apply changes

2. **Enable Google Provider in Supabase**:

   - Go to Authentication → Providers
   - Find "Google" in the list of providers
   - Toggle it to **Enabled**
   - You'll see fields for OAuth client IDs:
     - **Client ID (for Android)**: Paste your Android OAuth Client ID here
     - **Client ID (for iOS)**: Paste your iOS OAuth Client ID here
   - **How to find your OAuth Client ID from Google Cloud Console**:
     1. Go to [Google Cloud Console](https://console.cloud.google.com/)
     2. Select your project
     3. Go to "APIs & Services" → "Credentials"
     4. Find your OAuth 2.0 Client IDs in the list
     5. Click on the client ID you created (Android or iOS)
     6. Copy the **Client ID** value (looks like `xxx.apps.googleusercontent.com`)
     7. Paste this into the corresponding field in Supabase
   - **Important**:
     - Use the **Client ID** (not the client secret) for Supabase configuration
     - You need separate OAuth client IDs for Android and iOS
     - Leave the "Client Secret" field empty in Supabase (not needed for native sign-in)
   - Click "Save" to apply changes

### 3. Deep Linking Configuration

#### Android

Deep linking is already configured in `android/app/src/main/AndroidManifest.xml`:

- `com.caygnus.nashikdarshan://login-callback/`
- `com.caygnus.nashikdarshan://reset-password/`
- `com.caygnus.nashikdarshan://verify-email/`

#### iOS

Deep linking is already configured in `ios/Runner/Info.plist` with URL scheme: `com.caygnus.nashikdarshan`

### 4. Email Verification Setup

1. **Configure Email Templates in Supabase**:

   - Go to Authentication → Email Templates
   - Update confirmation email template to use deep link:
     ```
     {{ .ConfirmationURL }}?token={{ .Token }}&type=email&email={{ .Email }}
     ```
   - Update password reset email template:
     ```
     {{ .ConfirmationURL }}?token={{ .Token }}&type=recovery&email={{ .Email }}
     ```

2. **Set Site URL in Supabase**:
   - Go to Authentication → URL Configuration
   - Set Site URL to: `com.caygnus.nashikdarshan://`

## How It Works

### Google Sign-In Flow (with Supabase)

1. User taps "Sign in with Google" in your app
2. Native Google Sign-In dialog appears (no browser redirect) - handled by `google_sign_in` package
3. User selects Google account
4. App receives Google access token and ID token from Google
5. App calls `SupabaseConfig.client.auth.signInWithIdToken()` with the tokens
6. Supabase verifies the tokens with Google and creates/updates user session
7. App receives Supabase session (access token, refresh token, user data)
8. User is authenticated in your app via Supabase
9. User is redirected to the main app screen

**Key Point**: The authentication is handled by Supabase, but the initial Google sign-in is native (no web browser).

### Email Verification Flow

1. User signs up with email
2. Supabase sends verification email with deep link
3. User clicks link in email
4. Deep link opens app: `com.caygnus.nashikdarshan://verify-email/?token=xxx&type=email&email=xxx`
5. `DeepLinkService` handles the link
6. App verifies email using token
7. User is authenticated automatically

### Password Reset Flow

1. User requests password reset
2. Supabase sends reset email with deep link
3. User clicks link in email
4. Deep link opens app: `com.caygnus.nashikdarshan://reset-password/?token=xxx&type=recovery&email=xxx`
5. App navigates to password reset screen
6. User enters new password
7. Password is reset using token

## Testing

### Test Google Sign-In

1. Run the app
2. Tap "Sign in with Google"
3. Select a Google account
4. Verify you're signed in

### Test Email Verification

1. Sign up with a new email
2. Check email for verification link
3. Click the link (should open app)
4. Verify email is confirmed

### Test Deep Links

You can test deep links using ADB (Android) or Xcode (iOS):

**Android**:

```bash
adb shell am start -W -a android.intent.action.VIEW -d "com.caygnus.nashikdarshan://verify-email/?token=test&type=email&email=test@example.com" com.caygnus.nashikdarshan
```

**iOS**:

```bash
xcrun simctl openurl booted "com.caygnus.nashikdarshan://verify-email/?token=test&type=email&email=test@example.com"
```

## Troubleshooting

### Google Sign-In Issues

- **"Sign in failed"**:
  - Check SHA-1 fingerprint matches Google Cloud Console
  - Verify package name matches exactly: `com.caygnus.nashikdarshan`
  - Make sure you created an Android OAuth client ID (not Web application)
- **"Developer error"**:
  - Verify OAuth client ID is correctly configured in Google Cloud Console
  - Check that the OAuth consent screen is configured
  - Ensure the OAuth client ID is added to Supabase Google provider settings
- **No accounts shown**:
  - Check Google Play Services is installed (Android)
  - Verify you're using the correct OAuth client ID for your build type (debug vs release)
- **"Can't find google-services.json"**:
  - This file is NOT needed for `google_sign_in` package. Only configure OAuth client IDs in Google Cloud Console.

### Deep Link Issues

- **Links not opening app**: Verify URL scheme in AndroidManifest.xml and Info.plist
- **Email verification not working**: Check Supabase email template configuration
- **Token expired**: Email verification links expire after 24 hours by default

## Security Notes

1. **Access Tokens**: Stored securely by Supabase SDK
2. **Deep Links**: Validate tokens server-side before processing
3. **OAuth**: Use PKCE flow for enhanced security (already configured)
4. **Email Links**: Tokens are single-use and time-limited

## Additional Resources

- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Deep Linking Guide](https://docs.flutter.dev/development/ui/navigation/deep-linking)
