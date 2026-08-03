import { create } from 'zustand';
import { User } from '@daily-basket/shared-types';
import { apiClient } from '@daily-basket/api-client';

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  setAuth: (user: User, token: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  token: null,
  isAuthenticated: false,
  setAuth: (user, token) => {
    apiClient.setAuthToken(token);
    set({ user, token, isAuthenticated: true });
  },
  logout: () => {
    apiClient.setAuthToken(null);
    set({ user: null, token: null, isAuthenticated: false });
  },
}));
