# Firebase Integration Guide

## Overview
This document outlines our implementation of Firebase services, including configuration, usage patterns, security rules, and best practices. Firebase provides backend services that enable us to build high-quality mobile and web applications without managing infrastructure.

## Services Used

### 1. Firebase Authentication
- **Purpose**: Secure user authentication and management
- **Features Implemented**:
  - Email/password authentication
  - Google Sign-In
  - Facebook Login
  - Phone number authentication (planned)
  - Anonymous authentication (for guest users)
  - Custom token authentication (for integrating with existing systems)
- **User Data Stored**:
  - UID (unique identifier)
  - Email (verified/unverified status)
  - Display name
  - Photo URL
  - Creation timestamp
  - Last sign-in timestamp
  - Provider data
  - Custom claims (for role-based access control)

### 2. Cloud Firestore
- **Purpose**: NoSQL document database for storing application data
- **Data Model**:
  - Collections: Users, Posts, Comments, Messages, Settings, etc.
  - Documents: Individual records within collections
  - Subcollections: For hierarchical data (e.g., user posts under user document)
  - Fields: Typed data within documents
- **Usage Patterns**:
  - Real-time updates for collaborative features
  - Offline synchronization for mobile apps
  - Queries with filtering, sorting, and pagination
  - Batched writes for atomic operations
  - Transactions for complex data modifications

### 3. Firebase Realtime Database (Optional/Legacy)
- **Purpose**: Real-time data synchronization for specific use cases
- **Current Usage**:
  - Presence indicators
  - Real-time game states (if applicable)
  - Simple chat applications
- **Note**: Prefer Firestore for new features due to better querying and scalability

### 4. Firebase Cloud Messaging (FCM)
- **Purpose**: Push notifications for mobile and web applications
- **Notification Types**:
  - Marketing/promotional messages
  - Transactional alerts (password reset, verification)
  - Activity notifications (comments, mentions, replies)
  - System updates and maintenance notices
- **Platforms Supported**:
  - Android (via Firebase SDK)
  - iOS (via APNs integration)
  - Web (via Push API)
- **Features**:
  - Topic-based messaging
  - Device group messaging
  - Analytics integration for delivery tracking
  - A/B testing for notification optimization

### 5. Firebase Cloud Functions
- **Purpose**: Serverless backend logic triggered by Firebase events
- **Common Triggers**:
  - Authentication events (user creation, deletion)
  - Firestore document changes (create, update, delete)
  - HTTP requests (for custom APIs)
  - Scheduled functions (cron-like operations)
  - Firebase Analytics events
- **Use Cases**:
  - Sending welcome emails after user registration
  - Generating thumbnails for uploaded images
  - Enforcing data validation and integrity
  - Integrating with third-party APIs
  - Processing payments (via Stripe webhook simulation)
  - Analytics event enrichment

### 6. Firebase Hosting
- **Purpose**: Fast and secure hosting for web application assets
- **Features**:
  - Global CDN for low-latency content delivery
  - SSL/TLS certificates (automatically provisioned and renewed)
  - Custom domain support
  - Version rollbacks
  - Preview channels for pull request testing
  - Integration with GitHub for continuous deployment
- **Hosted Content**:
  - Static HTML/CSS/JavaScript
  - Single-page application bundles
  - Image assets
  - Configuration files

### 7. Firebase Storage
- **Purpose**: Secure file uploads and storage for user-generated content
- **File Types Supported**:
  - Profile pictures and avatars
  - Document uploads (PDF, DOC, etc.)
  - Media files (images, videos, audio)
  - Attachments for messages/posts
- **Features**:
  - Client-side upload acceleration via signed URLs
  - Automatic scaling to handle any traffic level
  - Built-in retry logic for interrupted uploads
  - File metadata storage (content type, size, custom attributes)
  - Integration with Cloud Functions for image processing
  - Security rules for access control

### 8. Firebase Analytics
- **Purpose**: Understand user behavior and app performance
- **Events Tracked**:
  - User engagement (screen views, session duration)
  - Conversion events (sign-ups, purchases, feature usage)
  - Custom events for specific business metrics
  - Error events for monitoring stability
- **Features**:
  - Automatic collection of basic events
  - Custom event parameters for rich context
  - Audience building for segmentation
  - Funnel analysis for conversion optimization
  - Integration with Google Ads and BigQuery
- **User Properties**:
  - Demographics (age, gender, location - if permitted)
  - Device characteristics
  - Acquisition source
  - Behavioral segments (power user, new user, etc.)

### 9. Firebase Performance Monitoring
- **Purpose**: Monitor app performance and identify bottlenecks
- **Traces Collected**:
  - App start time
  - Network request performance
  - Screen rendering times
  - Custom traces for specific user flows
- **Metrics**:
  - Load time
  - Response time
  - Frame rate (for UI smoothness)
  - Success/error rates
- **Features**:
  - Automatic performance data collection
  - Custom trace instrumentation
  - Attribute filtering for segmentation
  - Alerting for performance regressions

### 10. Firebase Crashlytics
- **Purpose**: Real-time crash reporting and analysis
- **Features**:
  - Automatic crash detection and reporting
  - Breadcrumbs for understanding app state before crash
  - Custom keys and logs for additional context
  - Velocity alerts for sudden crash increases
  - Integration with Slack/Jira for ticket creation
  - Deobfuscation for readable stack traces
- **Platforms Supported**:
  - Android (Native and React Native)
  - iOS (Native and React Native)
  - Unity (if applicable)

## Configuration

### Firebase Project Setup
```
Project ID: [your-project-id]
Project Number: [your-project-number]
Display Name: [Your App Name]
```

### Web Configuration
```javascript
// firebaseConfig.js
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';
import { getMessaging } from 'firebase/messaging';
import { getFunctions } from 'firebase/functions';
import { getAnalytics } from 'firebase/analytics';

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID",
  measurementId: "YOUR_MEASUREMENT_ID"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize services
export const auth = getAuth(app);
export const db = getFirestore(app);
export const storage = getStorage(app);
export const messaging = getMessaging(app);
export const functions = getFunctions(app);
export const analytics = getAnalytics(app);

// Export for use in components
export default app;
```

### Environment Variables
Store Firebase configuration securely using environment variables:
```
# .env.local (never commit to version control)
REACT_APP_FIREBASE_API_KEY=your_api_key
REACT_APP_FIREBASE_AUTH_DOMAIN=your_project_id.firebaseapp.com
REACT_APP_FIREBASE_PROJECT_ID=your_project_id
REACT_APP_FIREBASE_STORAGE_BUCKET=your_project_id.appspot.com
REACT_APP_FIREBASE_MESSAGING_SENDER_ID=your_sender_id
REACT_APP_FIREBASE_APP_ID=your_app_id
REACT_APP_FIREBASE_MEASUREMENT_ID=your_measurement_id
```

### Initialization Best Practices
1. **Lazy Initialization**: Initialize Firebase only when needed to reduce initial load time
2. **Singleton Pattern**: Ensure Firebase is initialized only once per application lifecycle
3. **Error Handling**: Catch and handle initialization errors gracefully
4. **Environment Separation**: Use different Firebase projects for development, staging, and production
5. **Security**: Never expose service account keys in client-side code

## Authentication Implementation

### User Registration
```javascript
import { createUserWithEmailAndPassword } from 'firebase/auth';
import { doc, setDoc } from 'firebase/firestore';
import { auth, db } from './firebase';

export const registerUser = async (email, password, displayName) => {
  try {
    // Create user in Firebase Auth
    const userCredential = await createUserWithEmailAndPassword(
      auth, 
      email, 
      password
    );
    
    const user = userCredential.user;
    
    // Update profile with display name
    await updateProfile(user, { displayName });
    
    // Create user document in Firestore
    await setDoc(doc(db, 'users', user.uid), {
      uid: user.uid,
      email: user.email,
      displayName: displayName || email.split('@')[0],
      photoURL: user.photoURL || `https://ui-avatars.com/api/?name=${encodeURIComponent(displayName)}`,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      preferences: {
        theme: 'system',
        notifications: {
          email: true,
          push: true,
          inApp: true
        }
      },
      // Additional profile fields as needed
    });
    
    return { success: true, user };
  } catch (error) {
    console.error('Registration error:', error);
    throw error;
  }
};
```

### User Login
```javascript
import { signInWithEmailAndPassword } from 'firebase/auth';
import { updateDoc, doc } from 'firebase/firestore';
import { auth, db } from './firebase';

export const loginUser = async (email, password) => {
  try {
    const userCredential = await signInWithEmailAndPassword(
      auth, 
      email, 
      password
    );
    
    const user = userCredential.user;
    
    // Update last sign-in time
    await updateDoc(doc(db, 'users', user.uid), {
      lastSignIn: new Date().toISOString()
    });
    
    return { success: true, user };
  } catch (error) {
    console.error('Login error:', error);
    throw error;
  }
};
```

### Password Reset
```javascript
import { sendPasswordResetEmail } from 'firebase/auth';
import { auth } from './firebase';

export const resetPassword = async (email) => {
  try {
    await sendPasswordResetEmail(auth, email);
    return { success: true };
  } catch (error) {
    console.error('Password reset error:', error);
    throw error;
  }
};
```

### Email Verification
```javascript
import { sendEmailVerification } from 'firebase/auth';
import { auth } from './firebase';

export const sendVerificationEmail = async () => {
  try {
    await sendEmailVerification(auth.currentUser);
    return { success: true };
  } catch (error) {
    console.error('Email verification error:', error);
    throw error;
  }
};
```

## Firestore Data Modeling

### Collection Structure
```
/users/{userId}
  - email: string
  - displayName: string
  - photoURL: string
  - createdAt: timestamp
  - lastSignIn: timestamp
  - preferences: map
  - role: string (user, admin, moderator)
  - isActive: boolean

/posts/{postId}
  - authorId: string (reference to /users/{userId})
  - title: string
  - content: string
  - createdAt: timestamp
  - updatedAt: timestamp
  - likes: number
  - commentsCount: number
  - tags: array
  - visibility: string (public, private, friends)

/comments/{commentId}
  - postId: string (reference to /posts/{postId})
  - authorId: string (reference to /users/{userId})
  - content: string
  - createdAt: timestamp
  - likes: number

/notifications/{notificationId}
  - recipientId: string (reference to /users/{userId})
  - senderId: string (reference to /users/{userId}, optional)
  - type: string (like, comment, follow, mention, system)
  - entityId: string (reference to related entity)
  - entityType: string (post, comment, user, etc.)
  - isRead: boolean
  - createdAt: timestamp

/settings/{userId}
  - theme: string (light, dark, system)
  - notifications: map
  - privacy: map
  - language: string
  - timezone: string
```

### Indexing Strategy
Create composite indexes for common query patterns:
1. **Posts by author with pagination**
   - Collection: posts
   - Fields: authorId (ascending), createdAt (descending)

2. **Comments by post with sorting**
   - Collection: comments
   - Fields: postId (ascending), createdAt (ascending)

3. **User notifications with filtering**
   - Collection: notifications
   - Fields: recipientId (ascending), isRead (ascending), createdAt (descending)

4. **Search by tags with date filtering**
   - Collection: posts
   - Tags: array-contains
   - CreatedAt: range

### Security Rules Foundation
```
// Firestore Rules - firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isUser(userId) {
      return request.auth.uid == userId;
    }
    
    function isAdmin() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isAuthenticated() && 
                    (request.auth.uid == userId || isAdmin());
      allow delete: if isFalse(); // Prevent deletion, use soft delete instead
      
      // Subcollections
      match /posts/{postId} {
        allow read: if true; // Public posts readable by everyone
        allow create: if isAuthenticated() && request.auth.uid == userId;
        allow update: if isAuthenticated() && 
                      request.auth.uid == userId &&
                      resource.data.authorId == request.auth.uid;
        allow delete: if isFalse(); // Soft delete instead
      }
    }
    
    // Posts collection
    match /posts/{postId} {
      allow read: if true; // Adjust based on privacy settings
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && 
                    request.resource.data.authorId == request.auth.uid;
      allow delete: if isFalse(); // Soft delete
      
      // Subcollections
      match /comments/{commentId} {
        allow read: if true;
        allow create: if isAuthenticated();
        allow update: if isAuthenticated() && 
                      request.resource.data.authorId == request.auth.uid;
        allow delete: if isFalse();
      }
      
      // Likes subcollection
      match /likes/{userId} {
        allow read: if true;
        allow create: if isAuthenticated() && 
                      request.auth.uid == userId;
        allow delete: if isAuthenticated() && 
                      request.auth.uid == userId;
      }
    }
    
    // Notifications
    match /notifications/{notificationId} {
      allow read: if isAuthenticated() && 
                  request.auth.uid == resource.data.recipientId;
      allow update: if isAuthenticated() && 
                    request.auth.uid == resource.data.recipientId;
      allow delete: if isFalse(); // Retain for history
    }
    
    // Settings
    match /settings/{userId} {
      allow read: if isAuthenticated() && request.auth.uid == userId;
      allow write: if isAuthenticated() && request.auth.uid == userId;
    }
  }
}
```

### Storage Rules
```
// Storage Rules - storage.rules
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    
    // User profile images
    match /profile-pictures/{userId}/{fileName} {
      allow read: if true; // Publicly readable
      allow write: if request.auth != null && 
                   request.auth.uid == userId &&
                   request.resource.size < 5 * 1024 * 1024 && // 5MB limit
                   request.resource.contentType.matches('image/(png|jpe?g|gif|webp)');
    }
    
    // Document uploads
    match /documents/{userId}/{fileName} {
      allow read: if request.auth != null && 
                  request.auth.uid == userId;
      allow write: if request.auth != null && 
                   request.auth.uid == userId &&
                   request.resource.size < 20 * 1024 * 1024 && // 20MB limit
                   request.resource.contentType.matches({
                     'application/pdf',
                     'application/msword',
                     'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                     'text/plain'
                   });
    }
    
    // General uploads (if needed)
    match /uploads/{userId}/{filePath=**} {
      allow read: if request.auth != null && 
                  request.auth.uid == userId;
      allow write: if request.auth != null && 
                   request.auth.uid == userId;
    }
  }
}
```

## Cloud Functions Implementation

### User Welcome Email
```javascript
// functions/src/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');

admin.initializeApp();

// Configure email transporter (use environment variables for credentials)
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.GMAIL_USER,
    pass: process.env.GMAIL_PASS
  }
});

exports.sendWelcomeEmail = functions.auth.user().onCreate(async (user) => {
  const mailOptions = {
    from: '"Your App" <'+process.env.GMAIL_USER+'>',
    to: user.email,
    subject: 'Welcome to Our App!',
    html: `
      <h1>Welcome, ${user.displayName || 'User'}!</h1>
      <p>Thank you for joining our community. We're excited to have you here.</p>
      <p>To get started, <a href="${process.env.FRONTEND_URL}/getting-started">click here</a> for our getting started guide.</p>
      <p>If you have any questions, feel free to reply to this email.</p>
      <hr>
      <p>Best regards,<br>The Team</p>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log('Welcome email sent to:', user.email);
  } catch (error) {
    console.error('Error sending welcome email:', error);
    throw new Error(`Failed to send welcome email: ${error.message}`);
  }
});

// Profile picture thumbnail generation
exports.generateThumbnail = functions.storage.object().onFinalize(async (object) => {
  const fileBucket = object.bucket; // The Storage bucket that contains the file.
  const filePath = object.name; // File path in the bucket.
  const contentType = object.contentType; // File content type.
  
  // Exit if this is triggered on a file that is not an image.
  if (!contentType.startsWith('image/')) {
    return null;
  }
  
  // Exit if the image is already a thumbnail.
  if (filePath.startsWith('thumbs/')) {
    return null;
  }
  
  const bucket = admin.storage().bucket(fileBucket);
  const tempFile = `/tmp/${filePath.split('/').pop()}`;
  
  try {
    // Download file from bucket.
    await bucket.file(filePath).download({destination: tempFile});
    
    // Generate a thumbnail using ImageMagick or sharp
    // For this example, we'll use a placeholder
    
    // Upload thumbnail back to bucket.
    const thumbFilePath = `thumbs/${filePath}`;
    await bucket.upload(tempFile, {
      destination: thumbFilePath,
      metadata: {
        contentType: contentType
      }
    });
    
    // Delete temporary file
    const fs = require('fs');
    fs.unlinkSync(tempFile);
    
    console.log('Thumbnail created at:', thumbFilePath);
    return null;
  } catch (error) {
    console.error('Error generating thumbnail:', error);
    throw error;
  }
});

// Scheduled cleanup of temporary files
exports.cleanupTempFiles = functions.pubsub.schedule('every 6 hours').onRun((context) => {
  const tmpDir = '/tmp';
  const fs = require('fs');
  
  try {
    const files = fs.readdirSync(tmpDir);
    const now = Date.now();
    
    for (const file of files) {
      const filePath = `${tmpDir}/${file}`;
      const stats = fs.statSync(filePath);
      
      // Delete files older than 24 hours
      if (now - stats.mtimeMs > 24 * 60 * 60 * 1000) {
        fs.unlinkSync(filePath);
        console.log(`Deleted temp file: ${filePath}`);
      }
    }
    
    return null;
  } catch (error) {
    console.error('Error cleaning temp files:', error);
    return null;
  }
});
```

## Security Best Practices

### Authentication Security
1. **Enable 2FA**: Encourage or require two-factor authentication for sensitive accounts
2. **Password Policies**: Enforce strong passwords (min 12 chars, mix of character types)
3. **Rate Limiting**: Implement rate limits on authentication endpoints to prevent brute force
4. **Session Management**: Use short-lived access tokens with refresh token rotation
5. **Account Lockout**: Temporarily lock accounts after too many failed login attempts
6. **Login Attempts Logging**: Log all authentication attempts for anomaly detection

### Firestore Security
1. **Principle of Least Privilege**: Users should only have access to data they need
2. **Validate Input**: Use `request.resource.data` to validate incoming data matches expected schema
3. **Field-Level Security**: Protect sensitive fields (email, role, etc.) from unauthorized modification
4. **Avoid Wildcards**: Be specific with path matching rather than using `{document=**}`
5. **Test Thoroughly**: Use the Firebase Emulator Suite to test rules before deploying
6. **Regular Audits**: Periodically review and update security rules as features evolve

### Storage Security
1. **File Type Validation**: Restrict uploads to safe MIME types
2. **Size Limits**: Implement reasonable file size limits to prevent DoS
3. **Path Traversal Prevention**: Ensure user IDs can't be manipulated to access other users' files
4. **Virus Scanning**: Consider integrating virus scanning for file uploads (via Cloud Functions)
5. **Public Access Control**: Be extremely careful with public read permissions

### Cloud Functions Security
1. **Input Validation**: Validate all inputs to prevent injection attacks
2. **Third-Party API Security**: Securely store and use API keys (never in client code)
3. **Rate Limiting**: Implement rate limiting for functions exposed via HTTP triggers
4. **Error Handling**: Don't expose stack traces or sensitive information in error responses
5. **Least Privilege**: Functions should run with minimum required permissions
6. **Dependency Scanning**: Regularly check for vulnerabilities in function dependencies

## Testing Strategy

### Unit Testing
```javascript
// Example: Testing authentication functions
describe('Authentication Service', () => {
  beforeEach(() => {
    // Reset Firebase emulator state
  });
  
  it('should create a new user with valid credentials', async () => {
    const result = await authService.registerUser(
      'test@example.com',
      'SecurePass123!',
      'Test User'
    );
    
    expect(result.success).toBe(true);
    expect(result.user.uid).toBeDefined();
  });
  
  it('should reject weak passwords', async () => {
    try {
      await authService.registerUser(
        'test@example.com',
        'weak', // Too short
        'Test User'
      );
      fail('Should have thrown an error');
    } catch (error) {
      expect(error.message).toContain('weak password');
    }
  });
});
```

### Integration Testing (Using Firebase Emulator Suite)
```javascript
// Initialize emulators in test setup
beforeAll(async () => {
  // Connect to emulators
  connectAuthEmulator(auth, 'http://localhost:9099');
  connectFirestoreEmulator(db, 'localhost', 8080);
  connectStorageEmulator(storage, 'localhost', 9199);
  // ... other emulators
});

// Test authentication flow
test('complete user registration flow', async () => {
  // 1. Register user
  const userCred = await createUserWithEmailAndPassword(
    auth, 
    'test@example.com', 
    'SecurePass123!'
  );
  
  // 2. Verify user document created in Firestore
  const userDoc = await getDoc(doc(db, 'users', userCred.user.uid));
  expect(userDoc.exists()).toBe(true);
  expect(userDoc.data().email).toBe('test@example.com');
  
  // 3. Verify email verification sent
  // (This would require mocking email service or checking logs)
});
```

### Security Rules Testing
```javascript
// Using @firebase/rules-unit-testing
import { initializeTestApp, assertFails, assertSucceeds } from '@firebase/rules-unit-testing';

describe('Firestore Security Rules', () => {
  let alice, bob, admin;
  
  beforeEach(async () => {
    // Create test users
    alice = await initializeTestApp({ projectId: 'test-project', auth: { uid: 'alice', email: 'alice@test.com' }}).firestore();
    bob = await initializeTestApp({ projectId: 'test-project', auth: { uid: 'bob', email: 'bob@test.com' }}).firestore();
    admin = await initializeTestApp({ projectId: 'test-project', auth: { uid: 'admin', email: 'admin@test.com', role: 'admin' }}).firestore();
    
    // Clear database between tests
    await clearFirestoreData({ projectId: 'test-project' });
  });
  
  it('allows users to read their own profile', async () => {
    await assertSucceeds(alice.doc('users/alice').get());
  });
  
  it('prevents users from reading others\' profiles', async () => {
    await assertFails(alice.doc('users/bob').get());
  });
  
  it('allows admins to read any user profile', async () => {
    await assertSucceeds(admin.doc('users/alice').get());
  });
});
```

## Monitoring and Analytics

### Custom Analytics Events
```javascript
import { logEvent } from 'firebase/analytics';
import { analytics } from './firebase';

// Track feature usage
export const trackFeatureUsage = (featureName, properties = {}) => {
  logEvent(analytics, 'feature_used', {
    feature: feature_name,
    ...properties
  });
};

// Track user engagement
export const trackScreenView = (screenName, parameters = {}) => {
  logEvent(analytics, 'screen_view', {
    screen_name: screen_name,
    screen_class: screen_name.replace(/\s+/g, '') + 'Screen',
    ...parameters
  });
};

// Track errors
export const trackError = (errorMessage, errorCode, context = {}) => {
  logEvent(analytics, 'app_error', {
    error_message: error_message,
    error_code: error_code,
    timestamp: new Date().toISOString(),
    ...context
  });
};

// Track conversion funnel
export const trackSignupStep = (stepName, stepNumber) => {
  logEvent(analytics, 'sign_up_progress', {
    step_name: step_name,
    step_number: step_number,
    timestamp: new Date().toISOString()
  });
};
```

### Performance Monitoring Custom Traces
```javascript
import { trace } from 'firebase/performance';
import { getPerformance } from 'firebase/performance';

const performance = getPerformance();

// Trace a complex calculation
export const calculateAnalytics = (data) => {
  const traceRef = trace(performance, 'calculate_analytics');
  
  try {
    traceRef.start();
    // ... complex calculation logic
    return result;
  } finally {
    traceRef.stop();
  }
};

// Trace API calls
export const fetchUserData = async (userId) => {
  const traceRef = trace(performance, 'fetch_user_data');
  
  try {
    traceRef.start();
    const response = await fetch(`/api/users/${userId}`);
    return await response.json();
  } finally {
    traceRef.stop();
  }
};
```

## Deployment and CI/CD

### Firebase CLI Setup
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize project in your directory
firebase init

# Select features to setup:
# - Firestore: Security rules and indexes
# - Functions: Configure and deploy Cloud Functions
# - Hosting: Configure public directory and setup
# - Storage: Security rules
# - Emulators: Set up local development suite
```

### Deployment Scripts
```json
// package.json
{
  "scripts": {
    "deploy": "firebase deploy",
    "deploy:hosting": "firebase deploy --only hosting",
    "deploy:functions": "firebase deploy --only functions",
    "deploy:firestore": "firebase deploy --only firestore:rules,firestore:indexes",
    "deploy:storage": "firebase deploy --only storage:rules",
    "emulators:start": "firebase emulators:start",
    "test": "jest",
    "test:rules": "jest --testPathPattern=rules.test.js"
  }
}
```

### GitHub Actions Workflow
```yaml
# .github/workflows/firebase-deploy.yml
name: Deploy to Firebase

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        
    - name: Install dependencies
      run: npm ci
      
    - name: Run tests
      run: npm test
      
    - name: Setup Firebase
      uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
        channelId: live
        projectId: YOUR_PROJECT_ID
```

## Troubleshooting & Debugging

### Common Authentication Issues
1. **Auth/email-already-in-use**: User already exists with different provider
   - Solution: Use `fetchSignInMethodsForEmail` to check existing providers
   
2. **Auth/invalid-email**: Email format incorrect
   - Solution: Validate email format before attempting authentication
   
3. **Auth/weak-password**: Password doesn't meet strength requirements
   - Solution: Enforce password strength on client-side before sending to Firebase
   
4. **Auth/too-many-requests**: Rate limit exceeded
   - Solution: Implement exponential backoff and user-friendly throttling messages

### Firestore Performance Issues
1. **Slow Queries**: Missing indexes
   - Solution: Check Firebase console for index creation suggestions
   
2. **High Read Costs**: Over-fetching data
   - Solution: Implement pagination, limit fields, use projections
   
3. **Transaction Failures**: Contention on documents
   - Solution: Reduce transaction scope, use alternative patterns like fan-out
   
4. **Offline Synchronization Issues**: Cache corruption
   - Solution: Clear cache and re-sync (in extreme cases)

### Cloud Functions Issues
1. **Cold Starts**: High latency on first invocation
   - Solution: Keep functions warm with periodic pings (for critical functions)
   
2. **Timeouts**: Function exceeds maximum execution time
   - Solution: Optimize code, increase timeout (up to 540s), or use Cloud Run
   
3. **Memory Exceeded**: Function uses more memory than allocated
   - Solution: Optimize memory usage, increase allocated memory (cost increases)
   
4. **Dependency Issues**: Missing or incompatible packages
   - Solution: Use `package.json` lock files, test in local emulator first

### Storage Problems
1. **Upload Failures**: Network interruptions
   - Solution: Implement retry logic with exponential backoff
   
2. **File Type Rejection**: Incorrect MIME type detection
   - Solution: Validate file types both client-side and server-side
   
3. **Permission Errors**: Security rules blocking access
   - Solution: Test rules thoroughly with emulator suite
   
4. **Storage Costs**: Unexpectedly high storage usage
   - Solution: Implement lifecycle rules to delete old files, monitor usage

### Analytics Discrepancies
1. **Missing Events**: Events not appearing in dashboard
   - Solution: Check console for initialization errors, verify event naming
   
2. **Delayed Data**: Real-time vs. batch processing delay
   - Solution: Understand that some reports have up to 24-hour latency
   
3. **Incorrect Attribution**: Misattributed user actions
   - Solution: Review user property implementation and timing
   
4. **Sampling Issues**: High-volume data sampling
   - Solution: Use BigQuery export for unsampled analysis

## Best Practices and Recommendations

### Development Practices
1. **Environment Separation**: 
   - Use separate Firebase projects for dev, staging, prod
   - Never test against production data with development code
   
2. **Error Handling**:
   - Catch and log Firebase-specific errors
   - Provide user-friendly error messages
   - Implement retry logic for transient failures
   
3. **Performance Optimization**:
   - Use Firestore indexes for query performance
   - Implement pagination for large datasets
   - Leverage caching where appropriate
   - Minimize document size (avoid large arrays or nested objects)
   
4. **Code Organization**:
   - Abstract Firebase services behind service layers
   - Use dependency injection for testability
   - Keep Firebase initialization in a central location
   - Create reusable hooks/components for common Firebase operations

### Security Practices
1. **Client-Side Validation**:
   - Validate inputs before sending to Firebase
   - Implement rate limiting on client-side to prevent abuse
   - sanitize user-generated content to prevent XSS
   
2. **Server-Side Protection**:
   - Never trust client-side validation alone
   - Implement additional validation in Cloud Functions
   - Use Firebase App Check to prevent abusive traffic
   
3. **Data Protection**:
   - Encrypt sensitive data before storing in Firestore
   - Use Firebase's built-in encryption for data at rest
   - Implement field-level encryption for PII if required
   
4. **Access Control**:
   - Regularly audit custom claims and role assignments
   - Implement just-in-time privilege escalation where needed
   - Use Firebase Security Rules as primary defense line

### Cost Management
1. **Monitor Usage**:
   - Set up budget alerts in Firebase console
   - Regularly review usage reports
   - Monitor specific cost drivers (reads/writes, function invocations, storage)
   
2. **Optimize Database Usage**:
   - Denormalize wisely to reduce read operations
   - Use composite indexes to avoid collection scans
   - Implement caching for frequently accessed data
   - Consider data archiving strategies for old records
   
3. **Function Optimization**:
   - Keep functions small and focused
   - Use appropriate memory allocations
   - Minimize cold start impact for user-facing functions
   - Batch operations where possible
   
4. **Storage Efficiency**:
   - Implement image/video compression before upload
   - Use appropriate storage classes (nearline, coldline) for infrequently accessed data
   - Set up lifecycle rules to automatically delete or archive old data
   - Use Firebase Storage's built-in metadata for efficient querying

### Testing Strategies
1. **Local Development**:
   - Use Firebase Emulator Suite for full-stack testing
   - Test security rules thoroughly with unit and integration tests
   - Mock external dependencies where appropriate
   
2. **Continuous Integration**:
   - Automate testing on pull requests
   - Deploy to preview channels for preview/testing
   - Run security scans on dependencies
   - Performance test critical user flows
   
3. **Production Monitoring**:
   - Set up alerts for error rates and performance degradation
   - Monitor user-facing metrics (latency, crash rates)
   - Implement feature flags for safe rollouts
   - Conduct regular chaos engineering experiments

## Migration Guide (If applicable)

### From Custom Backend to Firebase
1. **Phase 1: Parallel Run**
   - Keep existing backend operational
   - Begin writing new data to both systems
   - Migrate read paths gradually
   
2. **Phase 2: Data Migration**
   - Export existing data from legacy system
   - Transform data to Firestore-friendly format
   - Import data using batched writes or Cloud Functions
   - Verify data integrity post-migration
   
3. **Phase 3: Cutover**
   - Switch all writes to Firebase
   - Keep reads from both systems for validation period
   - Decompose legacy components as confidence increases
   
4. **Phase 3: Optimization**
   - Optimize data model for Firebase strengths
   - Implement Firebase-specific features (real-time updates, offline)
   - Decommission legacy infrastructure

### Version Updates
1. **Firebase SDK Updates**:
   - Follow semantic versioning guidance in release notes
   - Test breaking changes in staging environment
   - Update dependencies gradually to avoid conflicts
   
2. **Security Rules Evolution**:
   - Backward-compatible rule changes when possible
   - Test rule changes extensively with emulator suite
   - Implement gradual rollout using rules versioning if needed
   
3. **API Versioning**:
   - Maintain backward compatibility for public APIs
   - Deprecate old versions with adequate notice
   - Provide migration guides for breaking changes

## Resources and References

### Official Documentation
- [Firebase Documentation](https://firebase.google.com/docs)
- [Firebase Pricing](https://firebase.google.com/pricing)
- [Firebase Release Notes](https://firebase.google.com/support/release-notes)
- [Firebase Blog](https://firebase.google.com/blog)

### SDK References
- [Web (JavaScript/TypeScript)](https://firebase.google.com/docs/web/setup)
- [Android (Java/Kotlin)](https://firebase.google.com/docs/android/setup)
- [iOS (Swift/Objective-C)](https://firebase.google.com/docs/ios/setup)
- [Unity](https://firebase.google.com/docs/unity/setup)
- [C++](https://firebase.google.com/docs/cpp/setup)
- [Unity](https://firebase.google.com/docs/unity/setup)
- [Admin SDK (Node.js, Java, Python, Go, C#)](https://firebase.google.com/docs/admin/setup)

### Learning Resources
- [Firebase YouTube Channel](https://www.youtube.com/c/Firebase)
- [Firebase Tutorials (Google Codelabs)](https://codelabs.developers.google.com/?cat=Firebase)
- [Firebase Summit Recordings](https://firebase.google.com/events/summit)
- [Firebase Discord Community](https://firebase.google.com/support/community/)

### Tools and Utilities
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite/connect_and_prototype)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Extensions](https://firebase.google.com/products/extensions)
- [Firebase Performance Monitoring](https://firebase.google.com/docs/perf-mon/get-started)
- [Firebase Test Lab](https://firebase.google.com/test-lab)

### Community and Support
- [Stack Overflow (firebase tag)](https://stackoverflow.com/questions/tagged/firebase)
- [Firebase Google Group](https://groups.google.com/g/firebase-talk)
- [Firebase GitHub Repos](https://github.com/firebase)
- [Firebase Experts Program](https://firebase.google.com/support/experts)

## Glossary

**Authentication**: The process of verifying who a user is  
**Authorization**: The process of determining what a user is allowed to do  
**Cloud Firestore**: Firebase's NoSQL document database  
**Cloud Functions**: Serverless functions that run in response to events  
**Firebase Hosting**: Fast and secure hosting for web app content  
**Firebase Storage**: Secure file storage and serving and scalable object storage  
**Firebase Analytics**: Free app measurement solution  
**Firebase Performance Monitoring**: Performance monitoring for web, iOS, and Android  
**Firebase Crashlytics**: Real-time crash reporting  
**Firebase Cloud Messaging (FCM)**: Cross-platform messaging solution  
**Firebase Realtime Database**: Original real-time database (JSON tree)  
**Firestore Indexes**: Composite indexes required for compound queries  
**Security Rules**: Rules that define who has read/write access to data  
**Custom Claims**: Additional claims attached to Firebase ID tokens  
**Emulator Suite**: Local development environment for Firebase services  
**App Check**: Helps protect backend resources from abuse  
**Extensions**: Pre-packaged solutions that extend Firebase functionality  
**Blaze Plan**: Firebase's pay-as-you-go pricing tier  
**Spark Plan**: Firebase's free tier with usage limits