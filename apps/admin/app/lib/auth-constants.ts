import { AdminUser } from './auth-types';

export const ADMIN_PRESETS: Record<string, { user: AdminUser; pin: string; pass: string }> = {
  SUPER_ADMIN: {
    user: {
      id: 'adm_super_01',
      name: 'Sachin Kumar',
      email: 'admin@dailybasket.com',
      role: 'SUPER_ADMIN',
      storeId: 'hub_koramangala_01',
      storeName: 'Koramangala Mega Dark Store #01',
      permissions: ['ALL', 'SYSTEM_SETTINGS', 'FINANCE', 'CATALOG_WRITE', 'DISPATCH_CONTROL'],
      twoFactorEnabled: true,
      lastLoginAt: new Date().toISOString(),
    },
    pin: '984210',
    pass: 'Admin@Secure2026!',
  },
  STORE_MANAGER: {
    user: {
      id: 'adm_mgr_02',
      name: 'Kavitha Reddy',
      email: 'manager@dailybasket.com',
      role: 'STORE_MANAGER',
      storeId: 'hub_indiranagar_02',
      storeName: 'Indiranagar Quick Hub #02',
      permissions: ['STORE_OPERATIONS', 'DAILY_PRICING', 'INVENTORY_WRITE', 'DISPATCH_CONTROL'],
      twoFactorEnabled: true,
      lastLoginAt: new Date().toISOString(),
    },
    pin: '772190',
    pass: 'Manager@Secure2026!',
  },
  DISPATCH_HEAD: {
    user: {
      id: 'adm_disp_03',
      name: 'Vikram Joshi',
      email: 'dispatch@dailybasket.com',
      role: 'DISPATCH_HEAD',
      storeId: 'hub_koramangala_01',
      storeName: 'Koramangala Mega Dark Store #01',
      permissions: ['DISPATCH_CONTROL', 'FLEET_TRACKING', 'RIDER_ASSIGN'],
      twoFactorEnabled: false,
      lastLoginAt: new Date().toISOString(),
    },
    pin: '445201',
    pass: 'Dispatch@Secure2026!',
  },
  INVENTORY_LEAD: {
    user: {
      id: 'adm_inv_04',
      name: 'Arjun Das',
      email: 'inventory@dailybasket.com',
      role: 'INVENTORY_LEAD',
      storeId: 'hub_whitefield_03',
      storeName: 'Whitefield Regional Hub #03',
      permissions: ['INVENTORY_WRITE', 'GRN_APPROVAL', 'SUPPLIERS_READ'],
      twoFactorEnabled: false,
      lastLoginAt: new Date().toISOString(),
    },
    pin: '119430',
    pass: 'Inventory@Secure2026!',
  },
};

export const AUTH_COOKIE_NAME = 'db_admin_session';
export const CSRF_HEADER_NAME = 'x-csrf-token';
