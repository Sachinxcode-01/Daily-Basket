import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';
import { initializeApp, getApps, cert, App } from 'firebase-admin/app';
import { getAuth, Auth, DecodedIdToken } from 'firebase-admin/auth';

export interface VerifiedGoogleUser {
  uid: string;
  email: string;
  name: string;
  picture: string;
  emailVerified: boolean;
  provider: string;
}

@Injectable()
export class FirebaseAuthService implements OnModuleInit {
  private readonly logger = new Logger(FirebaseAuthService.name);
  private firebaseApp: App | null = null;
  private firebaseAuth: Auth | null = null;
  private isConfigured = false;
  private projectId = '';
  private clientEmail = '';

  onModuleInit() {
    this.initializeFirebase();
  }

  private initializeFirebase() {
    try {
      if (getApps().length > 0) {
        this.firebaseApp = getApps()[0];
        this.firebaseAuth = getAuth(this.firebaseApp);
        this.isConfigured = true;
        this.logger.log('Reusing existing Firebase Admin App instance');
        return;
      }

      const serviceAccountPath =
        process.env.FIREBASE_SERVICE_ACCOUNT_PATH ||
        path.join(process.cwd(), 'firebase-service-account.json');

      if (fs.existsSync(serviceAccountPath)) {
        const fileContent = fs.readFileSync(serviceAccountPath, 'utf8');
        const serviceAccount = JSON.parse(fileContent);

        this.projectId = serviceAccount.project_id || process.env.FIREBASE_PROJECT_ID || 'daily-basket-8b266';
        this.clientEmail =
          serviceAccount.client_email ||
          process.env.FIREBASE_CLIENT_EMAIL ||
          'firebase-adminsdk-fbsvc@daily-basket-8b266.iam.gserviceaccount.com';

        this.firebaseApp = initializeApp({
          credential: cert(serviceAccount),
          projectId: this.projectId,
        });
        this.firebaseAuth = getAuth(this.firebaseApp);
        this.isConfigured = true;
        this.logger.log(`Firebase Admin SDK successfully initialized for project: ${this.projectId}`);
      } else if (process.env.FIREBASE_PROJECT_ID && process.env.FIREBASE_CLIENT_EMAIL) {
        this.projectId = process.env.FIREBASE_PROJECT_ID;
        this.clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
        this.isConfigured = true;
        this.logger.log(`Firebase Admin configured via environment credentials for project: ${this.projectId}`);
      } else {
        // Development only — should never happen in production with zero defaults
        this.isConfigured = false;
        this.logger.error('Firebase not configured: no service account file or env vars present');
      }
    } catch (err: any) {
      this.isConfigured = false;
      this.logger.error(`Failed to initialize Firebase Admin: ${err?.message}`);
    }
  }

  getStatus() {
    const isDev = process.env.NODE_ENV !== 'production';
    return {
      configured: isDev ? false : this.isConfigured,
      projectId: this.projectId,
      clientEmail: this.clientEmail,
      serviceAccountPresent: this.isConfigured,
      authProvider: this.isConfigured ? 'FIREBASE_GOOGLE_USER' : 'NOT_CONFIGURED',
      status: this.isConfigured ? 'READY' : 'NOT_CONFIGURED',
      devOnlyBypass: isDev,
      timestamp: new Date().toISOString(),
    };
  }

  async verifyIdToken(idToken: string): Promise<VerifiedGoogleUser> {
    // Reject mock/development tokens outright — no fallback
    if (!this.firebaseAuth || !idToken || idToken.startsWith('mock_') || idToken.startsWith('test_')) {
      throw new Error('Authentication token verification unavailable or not configured');
    }

    try {
      const decoded: DecodedIdToken = await this.firebaseAuth.verifyIdToken(idToken);
      return {
        uid: decoded.uid,
        email: decoded.email || `${decoded.uid}@gmail.com`,
        name: decoded.name || (decoded.email ? decoded.email.split('@')[0] : 'Daily Basket User'),
        picture: decoded.picture || 'https://lh3.googleusercontent.com/a/default-user',
        emailVerified: !!decoded.email_verified,
        provider: 'FIREBASE_GOOGLE_USER',
      };
    } catch (tokenErr: any) {
      this.logger.error(`Firebase token verification failed for token of length ${idToken.length}: ${tokenErr?.message}`);
      throw new Error('Token verification failed');
    }
  }
}
