import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { User } from '@daily-basket/shared-types';
import { apiClient } from '@daily-basket/api-client';

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  setAuth: (user: User, token: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
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
    }),
    {
      name: 'daily-basket-auth',
      storage: createJSONStorage(() => localStorage),
      partialize: (state) => ({
        user: state.user,
        token: state.token,
        isAuthenticated: state.isAuthenticated,
      }),
      // Re-attach the persisted token to the API client after the store rehydrates on reload.
      onRehydrateStorage: () => (state) => {
        if (state?.token) {
          apiClient.setAuthToken(state.token);
        }
      },
    },
  ),
);
