# Session Management System Documentation

## Overview
The EduMunch app now includes a robust session management system for Student and Teacher authentication with persistent sessions and automatic session restoration.

## Features

### 1. **Persistent Sessions**
- Sessions are stored locally using `shared_preferences`
- Sessions persist across app restarts
- Automatic session restoration on app launch

### 2. **Session Timeout**
- Default timeout: 24 hours
- Configurable in `AuthController._sessionTimeoutHours`
- Expired sessions are automatically cleared

### 3. **Supabase Integration**
- Primary authentication through Supabase
- JWT token management
- Secure sign-in/sign-out

### 4. **Role-Based Access**
- Student role
- Teacher role
- Parent view (PIN-protected, linked to student account)

### 5. **Route Protection**
- Middleware guards protected routes
- Automatic redirection based on authentication state
- Role-based route access control

## Architecture

### AuthController
Location: `lib/auth_controller.dart`

**Key Methods:**
```dart
// Initialize and restore session
await authController._initializeSession()

// Set new session
await authController.setSession(email: email, role: role)

// Clear session and logout
await authController.clearSession()

// Validate current session
bool isValid = await authController.validateSession()

// Refresh session timestamp
await authController.refreshSession()

// Get session duration in hours
int hours = await authController.getSessionDuration()
```

**Observable Properties:**
```dart
authController.email          // Current user email
authController.role           // Current user role
authController.isLoggedIn     // Login state
authController.isLoading      // Loading state

// Reactive streams for UI
authController.emailStream
authController.roleStream
```

### Middleware
Location: `lib/middleware/auth_middleware.dart`

**AuthMiddleware:**
- Protects routes from unauthenticated access
- Redirects to login if not authenticated

**RoleMiddleware:**
- Ensures user has correct role for route
- Redirects to appropriate dashboard

### Session Storage
**Keys:**
- `auth_email` - User email
- `auth_role` - User role (Student/Teacher/Parent)
- `session_timestamp` - Session creation time

**Storage Location:**
- Android: SharedPreferences
- iOS: NSUserDefaults
- Windows: Registry
- Web: LocalStorage

## Implementation Details

### App Initialization Flow
```
1. App starts
2. AuthController.onInit() called
3. _initializeSession() runs:
   a. Check Supabase session
   b. If exists → load from Supabase
   c. If not → try local storage
   d. Validate session timestamp
4. Navigate to appropriate screen
```

### Login Flow
```
1. User enters credentials
2. Supabase authentication
3. AuthController.setSession() called
4. Session saved to:
   - Memory (reactive properties)
   - Local storage (persistent)
5. Navigate to dashboard
```

### Logout Flow
```
1. User clicks logout
2. AuthController.clearSession() called
3. Supabase sign-out
4. Clear local storage
5. Clear memory state
6. Navigate to login
```

### Session Restoration Flow
```
1. App launches → Splash screen
2. AuthController validates session:
   - Check Supabase session
   - Check local storage
   - Verify timestamp (< 24 hours)
3. If valid → Navigate to dashboard
4. If invalid → Navigate to login
```

## Usage Examples

### Check Authentication in Widgets
```dart
final authController = Get.find<AuthController>();

if (authController.isLoggedIn) {
  // User is authenticated
  print('Logged in as: ${authController.email}');
  print('Role: ${authController.role}');
}
```

### Reactive UI Updates
```dart
Obx(() {
  if (authController.isLoggedIn) {
    return Text('Welcome ${authController.email}');
  }
  return Text('Please login');
})
```

### Manual Session Refresh
```dart
ElevatedButton(
  onPressed: () async {
    await authController.refreshSession();
  },
  child: Text('Extend Session'),
)
```

### Show Session Info
```dart
// Use pre-built widgets
SessionStatusWidget()        // Shows current session
RefreshSessionButton()        // Button to refresh
SessionDetailsDialog()        // Full session details dialog
```

## Configuration

### Change Session Timeout
Edit `lib/auth_controller.dart`:
```dart
static const int _sessionTimeoutHours = 24; // Change to desired hours
```

### Customize Storage Keys
Edit `lib/auth_controller.dart`:
```dart
static const String _keyEmail = 'auth_email';
static const String _keyRole = 'auth_role';
static const String _keySessionTimestamp = 'session_timestamp';
```

## Security Considerations

1. **PIN Protection for Parent View**
   - 4 or 6 digit PIN (default: 1234, 123456)
   - Local validation only
   - Should be replaced with backend validation in production

2. **Session Tokens**
   - Supabase JWT tokens are automatically managed
   - Tokens are stored securely by Supabase SDK
   - Local storage only stores email, role, and timestamp

3. **Session Expiration**
   - 24-hour timeout prevents indefinite access
   - Manual logout clears all session data
   - Expired sessions automatically redirect to login

## Backend Integration

### Student-Parent Linking
Your backend should:

1. Link parent access to student accounts
2. Allow student tokens to access parent endpoints
3. Return student and parent data based on same token

**Example API Structure:**
```
Student token: "xyz123"

Accessible endpoints:
✓ GET /api/student/profile
✓ GET /api/student/attendance
✓ GET /api/parent/grievances  (linked to student)
✓ GET /api/parent/ptm         (linked to student)
```

### Role Detection
Currently based on email prefix:
- `student@*` → Student role
- `teacher@*` → Teacher role

**To customize:** Edit `AuthController._loadFromSupabase()`

## Testing

### Test Session Persistence
1. Login as student
2. Close app completely
3. Reopen app
4. Should automatically redirect to student dashboard

### Test Session Timeout
1. Login
2. Manually change timestamp in storage (24+ hours ago)
3. Reopen app
4. Should redirect to login

### Test Role Switching
1. Login as student
2. Open drawer → Switch to Parent
3. Enter PIN (1234)
4. Should show parent dashboard
5. Logout → should return to login

## Troubleshooting

### Session not persisting
- Check SharedPreferences permission
- Verify `flutter pub get` installed shared_preferences
- Check device storage permissions

### Auto-login not working
- Verify Supabase session is active
- Check session timestamp hasn't expired
- Ensure AuthController is initialized in main()

### Role detection failing
- Verify email format (student@..., teacher@...)
- Check `_loadFromSupabase()` logic
- Ensure role is set during login

## Files Modified/Created

### New Files:
- `lib/middleware/auth_middleware.dart` - Route protection
- `lib/widgets/session_status_widget.dart` - Session UI widgets
- `lib/widgets/parent_pin_dialog.dart` - PIN authentication

### Modified Files:
- `lib/auth_controller.dart` - Enhanced session management
- `lib/main.dart` - Added middleware to routes
- `lib/splash_screen.dart` - Session validation on startup
- `lib/login_screen.dart` - Removed parent login
- `lib/student/app_drawer.dart` - Added parent switch
- `lib/Parent/parent_app_drawer.dart` - Removed child switching
- `pubspec.yaml` - Added shared_preferences dependency

## Future Enhancements

1. **Backend PIN Validation**
   - Store PIN in database
   - Validate against backend

2. **Multi-Device Sessions**
   - Session management across devices
   - Logout from all devices

3. **Session Activity Tracking**
   - Log session activities
   - Show last login time/device

4. **Biometric Authentication**
   - Fingerprint/Face ID for quick login
   - Store encrypted credentials locally

5. **Remember Me Feature**
   - Optional longer session duration
   - Quick re-authentication
