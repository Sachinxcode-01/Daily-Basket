export type AdminRole =
  | 'SUPER_ADMIN'
  | 'STORE_MANAGER'
  | 'DISPATCH_HEAD'
  | 'INVENTORY_LEAD';

export interface AdminUser {
  id: string;
  name: string;
  email: string;
  role: AdminRole;
  storeId: string;
  storeName: string;
  avatar?: string;
  permissions: string[];
  twoFactorEnabled: boolean;
  lastLoginAt?: string;
  pin?: string;
}

export interface AuthSession {
  user: AdminUser;
  token: string;
  csrfToken: string;
  expiresAt: number;
}

export interface LoginResponse {
  success: boolean;
  user?: AdminUser;
  requiresTwoFactor?: boolean;
  tempToken?: string;
  message?: string;
  csrfToken?: string;
}

export interface AuditLogEntry {
  id: string;
  timestamp: string;
  action: string;
  actor: string;
  role: string;
  ip: string;
  status: 'SUCCESS' | 'FAILED' | 'WARNING';
  details: string;
}
