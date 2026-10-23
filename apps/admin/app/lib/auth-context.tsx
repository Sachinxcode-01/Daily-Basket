'use client';

import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import { AdminRole, AdminUser, LoginResponse } from './auth-types';
import { ADMIN_PRESETS } from './auth-constants';

interface AuthContextValue {
  user: AdminUser | null;
  role: AdminRole;
  isAuthenticated: boolean;
  isCheckingAuth: boolean;
  requiresTwoFactor: boolean;
  pendingEmail: string;
  csrfToken: string;
  login: (
    email: string,
    password?: string,
    roleHint?: AdminRole,
    bypassTwoFactor?: boolean
  ) => Promise<LoginResponse>;
  verifyTwoFactor: (code: string) => Promise<boolean>;
  logout: () => Promise<void>;
  switchRole: (role: AdminRole) => void;
}

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();

  const [user, setUser] = useState<AdminUser | null>(null);
  const [role, setRole] = useState<AdminRole>('STORE_MANAGER');
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(false);
  const [isCheckingAuth, setIsCheckingAuth] = useState<boolean>(true);
  const [requiresTwoFactor, setRequiresTwoFactor] = useState<boolean>(false);
  const [pendingEmail, setPendingEmail] = useState<string>('');
  const [tempToken, setTempToken] = useState<string>('');
  const [csrfToken, setCsrfToken] = useState<string>('');

  // Hydrate auth status from /api/auth/me
  useEffect(() => {
    let isMounted = true;
    async function checkSession() {
      try {
        const res = await fetch('/api/auth/me');
        if (res.ok) {
          const data = await res.json();
          if (isMounted) {
            if (data.authenticated && data.user) {
              setUser(data.user);
              setRole(data.user.role);
              setIsAuthenticated(true);
            } else {
              setUser(null);
              setIsAuthenticated(false);
            }
          }
        } else {
          if (isMounted) {
            setUser(null);
            setIsAuthenticated(false);
          }
        }
      } catch {
        if (isMounted) {
          setUser(null);
          setIsAuthenticated(false);
        }
      } finally {
        if (isMounted) setIsCheckingAuth(false);
      }
    }
    checkSession();
    return () => {
      isMounted = false;
    };
  }, []);

  const login = useCallback(
    async (
      email: string,
      password?: string,
      roleHint?: AdminRole,
      bypassTwoFactor = false
    ): Promise<LoginResponse> => {
      try {
        const res = await fetch('/api/auth/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email, password, roleHint, bypassTwoFactor }),
        });

        const data: LoginResponse = await res.json();

        if (res.ok && data.success) {
          if (data.requiresTwoFactor) {
            setRequiresTwoFactor(true);
            setPendingEmail(email);
            if (data.tempToken) setTempToken(data.tempToken);
            return data;
          }

          if (data.user) {
            setUser(data.user);
            setRole(data.user.role);
            setIsAuthenticated(true);
            setRequiresTwoFactor(false);
            if (data.csrfToken) setCsrfToken(data.csrfToken);
            router.push('/');
          }
          return data;
        } else {
          return {
            success: false,
            message: data.message || 'Authentication failed. Check credentials.',
          };
        }
      } catch (err: any) {
        return {
          success: false,
          message: err.message || 'Network error during login request.',
        };
      }
    },
    [router]
  );

  const verifyTwoFactor = useCallback(
    async (code: string): Promise<boolean> => {
      try {
        const res = await fetch('/api/auth/verify-2fa', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email: pendingEmail, code, tempToken }),
        });

        const data = await res.json();
        if (res.ok && data.success && data.user) {
          setUser(data.user);
          setRole(data.user.role);
          setIsAuthenticated(true);
          setRequiresTwoFactor(false);
          router.push('/');
          return true;
        }
        return false;
      } catch {
        return false;
      }
    },
    [pendingEmail, tempToken, router]
  );

  const logout = useCallback(async () => {
    try {
      await fetch('/api/auth/logout', { method: 'POST' });
    } catch {
      /* ignore */
    } finally {
      setUser(null);
      setIsAuthenticated(false);
      setRequiresTwoFactor(false);
      router.push('/login');
    }
  }, [router]);

  const switchRole = useCallback((newRole: AdminRole) => {
    const preset = ADMIN_PRESETS[newRole];
    if (preset) {
      setUser(preset.user);
      setRole(preset.user.role);
      setIsAuthenticated(true);
    }
  }, []);

  return (
    <AuthContext.Provider
      value={{
        user,
        role,
        isAuthenticated,
        isCheckingAuth,
        requiresTwoFactor,
        pendingEmail,
        csrfToken,
        login,
        verifyTwoFactor,
        logout,
        switchRole,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAdminAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAdminAuth must be used within an AuthProvider');
  }
  return context;
}
