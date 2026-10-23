'use client';

import React, { useState, useMemo } from 'react';
import {
  Users,
  UserPlus,
  Shield,
  Store,
  Key,
  CheckCircle2,
  XCircle,
  Search,
  Filter,
  Download,
  MoreVertical,
  Edit2,
  Lock,
  Unlock,
  RotateCcw,
  Trash2,
  Mail,
  Phone,
  Clock,
  Sparkles,
  ShieldAlert,
  ChevronDown,
  Building2,
  Check,
  AlertTriangle,
} from 'lucide-react';
import Button from '../../components/ui/Button';
import Badge from '../../components/ui/Badge';

export interface StaffUser {
  id: string;
  name: string;
  email: string;
  phone: string;
  role: 'SUPER_ADMIN' | 'STORE_MANAGER' | 'DISPATCH_HEAD' | 'INVENTORY_LEAD' | 'SUPPORT_LEAD' | 'STORE_OPERATOR';
  storeId: string;
  storeName: string;
  status: 'ACTIVE' | 'SUSPENDED' | 'INVITED';
  twoFactorEnabled: boolean;
  twoFactorType: 'HARDWARE_KEY' | 'AUTHENTICATOR' | 'SMS' | 'NONE';
  lastActive: string;
  avatarBg: string;
}

const INITIAL_STAFF: StaffUser[] = [
  {
    id: 'DB-EMP-1001',
    name: 'Sachin Kumar',
    email: 'admin@dailybasket.com',
    phone: '+91 98450 12345',
    role: 'SUPER_ADMIN',
    storeId: 'BLR-KRM-01',
    storeName: 'Koramangala Mega Dark Store #01',
    status: 'ACTIVE',
    twoFactorEnabled: true,
    twoFactorType: 'HARDWARE_KEY',
    lastActive: 'Just now',
    avatarBg: 'bg-emerald-600',
  },
  {
    id: 'DB-EMP-1002',
    name: 'Kavitha Reddy',
    email: 'kavitha.reddy@dailybasket.com',
    phone: '+91 98450 54321',
    role: 'STORE_MANAGER',
    storeId: 'BLR-IND-04',
    storeName: 'Indiranagar Urban Hub #04',
    status: 'ACTIVE',
    twoFactorEnabled: true,
    twoFactorType: 'AUTHENTICATOR',
    lastActive: '5m ago',
    avatarBg: 'bg-blue-600',
  },
  {
    id: 'DB-EMP-1003',
    name: 'Vikram Joshi',
    email: 'vikram.joshi@dailybasket.com',
    phone: '+91 97410 88990',
    role: 'DISPATCH_HEAD',
    storeId: 'BLR-KRM-01',
    storeName: 'Koramangala Mega Dark Store #01',
    status: 'ACTIVE',
    twoFactorEnabled: true,
    twoFactorType: 'SMS',
    lastActive: '12m ago',
    avatarBg: 'bg-purple-600',
  },
  {
    id: 'DB-EMP-1004',
    name: 'Arjun Das',
    email: 'arjun.das@dailybasket.com',
    phone: '+91 99011 22334',
    role: 'INVENTORY_LEAD',
    storeId: 'BLR-WTF-08',
    storeName: 'Whitefield Tech Hub #08',
    status: 'ACTIVE',
    twoFactorEnabled: true,
    twoFactorType: 'AUTHENTICATOR',
    lastActive: '28m ago',
    avatarBg: 'bg-amber-600',
  },
  {
    id: 'DB-EMP-1005',
    name: 'Priya Sundaram',
    email: 'priya.s@dailybasket.com',
    phone: '+91 98860 33445',
    role: 'STORE_MANAGER',
    storeId: 'BLR-HSR-02',
    storeName: 'HSR Layout Sector 2 Hub',
    status: 'ACTIVE',
    twoFactorEnabled: true,
    twoFactorType: 'AUTHENTICATOR',
    lastActive: '1h ago',
    avatarBg: 'bg-teal-600',
  },
  {
    id: 'DB-EMP-1006',
    name: 'Ramesh Babu',
    email: 'ramesh.b@dailybasket.com',
    phone: '+91 98440 66778',
    role: 'DISPATCH_HEAD',
    storeId: 'BLR-IND-04',
    storeName: 'Indiranagar Urban Hub #04',
    status: 'ACTIVE',
    twoFactorEnabled: false,
    twoFactorType: 'NONE',
    lastActive: '2h ago',
    avatarBg: 'bg-indigo-600',
  },
  {
    id: 'DB-EMP-1007',
    name: 'Ananya Iyer',
    email: 'ananya.iyer@dailybasket.com',
    phone: '+91 99450 77889',
    role: 'INVENTORY_LEAD',
    storeId: 'BLR-HSR-02',
    storeName: 'HSR Layout Sector 2 Hub',
    status: 'ACTIVE',
    twoFactorEnabled: true,
    twoFactorType: 'AUTHENTICATOR',
    lastActive: '3h ago',
    avatarBg: 'bg-rose-600',
  },
  {
    id: 'DB-EMP-1008',
    name: 'Karthik Nair',
    email: 'karthik.nair@dailybasket.com',
    phone: '+91 97310 11223',
    role: 'SUPPORT_LEAD',
    storeId: 'BLR-KRM-01',
    storeName: 'Central Support HQ',
    status: 'ACTIVE',
    twoFactorEnabled: true,
    twoFactorType: 'HARDWARE_KEY',
    lastActive: '45m ago',
    avatarBg: 'bg-cyan-600',
  },
  {
    id: 'DB-EMP-1009',
    name: 'Sunil Gowda',
    email: 'sunil.gowda@dailybasket.com',
    phone: '+91 96110 99887',
    role: 'STORE_OPERATOR',
    storeId: 'BLR-KRM-01',
    storeName: 'Koramangala Mega Dark Store #01',
    status: 'SUSPENDED',
    twoFactorEnabled: false,
    twoFactorType: 'NONE',
    lastActive: '4 days ago',
    avatarBg: 'bg-zinc-500',
  },
  {
    id: 'DB-EMP-1010',
    name: 'Meera Nambiar',
    email: 'meera.nambiar@dailybasket.com',
    phone: '+91 98800 44556',
    role: 'STORE_OPERATOR',
    storeId: 'BLR-WTF-08',
    storeName: 'Whitefield Tech Hub #08',
    status: 'INVITED',
    twoFactorEnabled: false,
    twoFactorType: 'NONE',
    lastActive: 'Never',
    avatarBg: 'bg-orange-500',
  },
];

const STORE_HUBS = [
  { code: 'ALL', name: 'All Dark Stores' },
  { code: 'BLR-KRM-01', name: 'Koramangala Mega Dark Store #01' },
  { code: 'BLR-IND-04', name: 'Indiranagar Urban Hub #04' },
  { code: 'BLR-HSR-02', name: 'HSR Layout Sector 2 Hub' },
  { code: 'BLR-WTF-08', name: 'Whitefield Tech Hub #08' },
];

export default function UserManagementPage() {
  const [users, setUsers] = useState<StaffUser[]>(INITIAL_STAFF);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedRole, setSelectedRole] = useState<string>('ALL');
  const [selectedStore, setSelectedStore] = useState<string>('ALL');
  const [selectedStatus, setSelectedStatus] = useState<string>('ALL');
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Modals state
  const [isInviteModalOpen, setIsInviteModalOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<StaffUser | null>(null);
  const [deleteConfirmUser, setDeleteConfirmUser] = useState<StaffUser | null>(null);

  // New user form state
  const [newUserName, setNewUserName] = useState('');
  const [newUserEmail, setNewUserEmail] = useState('');
  const [newUserPhone, setNewUserPhone] = useState('');
  const [newUserRole, setNewUserRole] = useState<StaffUser['role']>('STORE_MANAGER');
  const [newUserStore, setNewUserStore] = useState(STORE_HUBS[1].code);

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  // Filtered staff list
  const filteredUsers = useMemo(() => {
    return users.filter((u) => {
      const matchesSearch =
        u.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        u.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
        u.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
        u.phone.includes(searchQuery);

      const matchesRole = selectedRole === 'ALL' || u.role === selectedRole;
      const matchesStore = selectedStore === 'ALL' || u.storeId === selectedStore;
      const matchesStatus = selectedStatus === 'ALL' || u.status === selectedStatus;

      return matchesSearch && matchesRole && matchesStore && matchesStatus;
    });
  }, [users, searchQuery, selectedRole, selectedStore, selectedStatus]);

  // Statistics
  const stats = useMemo(() => {
    const total = users.length;
    const active = users.filter((u) => u.status === 'ACTIVE').length;
    const twoFaCount = users.filter((u) => u.twoFactorEnabled).length;
    const managers = users.filter((u) => u.role === 'STORE_MANAGER').length;
    const compliance = Math.round((twoFaCount / total) * 100);
    return { total, active, managers, compliance };
  }, [users]);

  // Status toggle handler
  const handleToggleStatus = (userId: string) => {
    setUsers((prev) =>
      prev.map((u) => {
        if (u.id === userId) {
          const newStatus = u.status === 'ACTIVE' ? 'SUSPENDED' : 'ACTIVE';
          showToast(`${u.name} status updated to ${newStatus}`);
          return { ...u, status: newStatus };
        }
        return u;
      })
    );
  };

  // 2FA Reset handler
  const handleReset2FA = (user: StaffUser) => {
    setUsers((prev) =>
      prev.map((u) =>
        u.id === user.id
          ? { ...u, twoFactorEnabled: false, twoFactorType: 'NONE' }
          : u
      )
    );
    showToast(`2FA credentials reset for ${user.name}. User will be prompted to re-enroll.`);
  };

  // Create user handler
  const handleCreateUser = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newUserName.trim() || !newUserEmail.trim()) {
      showToast('Please provide both name and email.');
      return;
    }

    const assignedStore = STORE_HUBS.find((s) => s.code === newUserStore) || STORE_HUBS[1];
    const newUser: StaffUser = {
      id: `DB-EMP-${Math.floor(1011 + Math.random() * 800)}`,
      name: newUserName.trim(),
      email: newUserEmail.trim(),
      phone: newUserPhone.trim() || '+91 98000 00000',
      role: newUserRole,
      storeId: assignedStore.code,
      storeName: assignedStore.name,
      status: 'INVITED',
      twoFactorEnabled: false,
      twoFactorType: 'NONE',
      lastActive: 'Invited just now',
      avatarBg: 'bg-emerald-600',
    };

    setUsers((prev) => [newUser, ...prev]);
    setIsInviteModalOpen(false);
    setNewUserName('');
    setNewUserEmail('');
    setNewUserPhone('');
    showToast(`Invitation email dispatched to ${newUser.email}`);
  };

  // Save edit user
  const handleSaveEdit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingUser) return;

    setUsers((prev) =>
      prev.map((u) => (u.id === editingUser.id ? editingUser : u))
    );
    setEditingUser(null);
    showToast(`User settings updated for ${editingUser.name}`);
  };

  // Delete user
  const handleDeleteUser = () => {
    if (!deleteConfirmUser) return;
    setUsers((prev) => prev.filter((u) => u.id !== deleteConfirmUser.id));
    showToast(`Account ${deleteConfirmUser.name} removed from Daily Basket OS.`);
    setDeleteConfirmUser(null);
  };

  // Export CSV
  const handleExportCSV = () => {
    const headers = ['Employee ID,Name,Email,Phone,Role,Dark Store,Status,2FA Type,Last Active'];
    const rows = filteredUsers.map((u) =>
      `"${u.id}","${u.name}","${u.email}","${u.phone}","${u.role}","${u.storeName}","${u.status}","${u.twoFactorType}","${u.lastActive}"`
    );
    const csvContent = 'data:text/csv;charset=utf-8,' + [headers, ...rows].join('\n');
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `daily_basket_staff_users_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    showToast('Exported filtered staff roster as CSV.');
  };

  const getRoleBadge = (role: StaffUser['role']) => {
    switch (role) {
      case 'SUPER_ADMIN':
        return <span className="px-2 py-0.5 rounded-md text-[10px] font-bold bg-rose-100 text-rose-800 font-mono">SUPER ADMIN</span>;
      case 'STORE_MANAGER':
        return <span className="px-2 py-0.5 rounded-md text-[10px] font-bold bg-emerald-100 text-emerald-800 font-mono">STORE LEAD</span>;
      case 'DISPATCH_HEAD':
        return <span className="px-2 py-0.5 rounded-md text-[10px] font-bold bg-purple-100 text-purple-800 font-mono">DISPATCH HEAD</span>;
      case 'INVENTORY_LEAD':
        return <span className="px-2 py-0.5 rounded-md text-[10px] font-bold bg-amber-100 text-amber-800 font-mono">INVENTORY LEAD</span>;
      case 'SUPPORT_LEAD':
        return <span className="px-2 py-0.5 rounded-md text-[10px] font-bold bg-cyan-100 text-cyan-800 font-mono">SUPPORT LEAD</span>;
      default:
        return <span className="px-2 py-0.5 rounded-md text-[10px] font-bold bg-zinc-100 text-zinc-700 font-mono">OPERATOR</span>;
    }
  };

  return (
    <div className="space-y-6 font-sans">
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 bg-zinc-950 text-white px-4 py-3 rounded-2xl shadow-2xl flex items-center gap-3 border border-zinc-800 animate-in fade-in slide-in-from-bottom-3 duration-200">
          <CheckCircle2 className="w-5 h-5 text-[#2d9d43] shrink-0" />
          <span className="text-xs font-semibold">{toastMessage}</span>
        </div>
      )}

      {/* Top Header & Actions */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-zinc-200/90 shadow-xs">
        <div>
          <div className="flex items-center gap-2">
            <h1 className="text-2xl font-bold tracking-tight text-zinc-950">Team & User Management</h1>
            <Badge variant="brand">RBAC v2.4</Badge>
          </div>
          <p className="text-xs text-zinc-500 mt-1 font-medium">
            Manage dark store managers, dispatch coordinators, inventory leads, and staff RBAC access policies.
          </p>
        </div>

        <div className="flex items-center gap-2.5">
          <Button
            variant="outline"
            size="sm"
            onClick={handleExportCSV}
            leftIcon={<Download className="w-3.5 h-3.5" />}
          >
            Export Roster
          </Button>

          <Button
            variant="brand"
            size="sm"
            onClick={() => setIsInviteModalOpen(true)}
            leftIcon={<UserPlus className="w-4 h-4 text-white" />}
          >
            Invite Staff Member
          </Button>
        </div>
      </div>

      {/* Stat Cards */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">Total Staff</span>
            <div className="w-8 h-8 rounded-xl bg-zinc-100 flex items-center justify-center text-zinc-700">
              <Users className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-black text-zinc-950 mt-2">{stats.total}</div>
          <div className="text-[11px] text-emerald-600 font-bold mt-0.5 flex items-center gap-1">
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500" />
            {stats.active} Active across all hubs
          </div>
        </div>

        <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">Store Leads</span>
            <div className="w-8 h-8 rounded-xl bg-emerald-50 flex items-center justify-center text-[#2d9d43]">
              <Store className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-black text-zinc-950 mt-2">{stats.managers}</div>
          <div className="text-[11px] text-zinc-500 mt-0.5">Assigned to 4 micro-warehouses</div>
        </div>

        <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">2FA Compliance</span>
            <div className="w-8 h-8 rounded-xl bg-purple-50 flex items-center justify-center text-purple-700">
              <Shield className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-black text-zinc-950 mt-2">{stats.compliance}%</div>
          <div className="text-[11px] text-purple-700 font-semibold mt-0.5">High Security Standard</div>
        </div>

        <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs">
          <div className="flex items-center justify-between">
            <span className="text-xs font-semibold text-zinc-500 uppercase tracking-wider font-mono">Active Dark Stores</span>
            <div className="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center text-blue-700">
              <Building2 className="w-4 h-4" />
            </div>
          </div>
          <div className="text-2xl font-black text-zinc-950 mt-2">4 Hubs</div>
          <div className="text-[11px] text-blue-700 font-semibold mt-0.5">100% On-Premise Online</div>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-zinc-200/80 shadow-2xs space-y-3">
        <div className="flex flex-col md:flex-row gap-3">
          {/* Search Box */}
          <div className="relative flex-1">
            <Search className="w-4 h-4 text-zinc-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              placeholder="Search by name, email, employee ID, or phone..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-10 pr-4 py-2 bg-zinc-50/80 border border-zinc-200 rounded-xl text-xs text-zinc-900 focus:outline-hidden focus:ring-2 focus:ring-[#2d9d43] focus:bg-white transition"
            />
          </div>

          {/* Role Filter */}
          <select
            value={selectedRole}
            onChange={(e) => setSelectedRole(e.target.value)}
            className="px-3 py-2 bg-zinc-50/80 border border-zinc-200 rounded-xl text-xs text-zinc-700 font-medium focus:outline-hidden focus:ring-2 focus:ring-[#2d9d43]"
          >
            <option value="ALL">All Roles</option>
            <option value="SUPER_ADMIN">Super Admin</option>
            <option value="STORE_MANAGER">Store Manager</option>
            <option value="DISPATCH_HEAD">Dispatch Head</option>
            <option value="INVENTORY_LEAD">Inventory Lead</option>
            <option value="SUPPORT_LEAD">Support Lead</option>
            <option value="STORE_OPERATOR">Store Operator</option>
          </select>

          {/* Dark Store Filter */}
          <select
            value={selectedStore}
            onChange={(e) => setSelectedStore(e.target.value)}
            className="px-3 py-2 bg-zinc-50/80 border border-zinc-200 rounded-xl text-xs text-zinc-700 font-medium focus:outline-hidden focus:ring-2 focus:ring-[#2d9d43]"
          >
            {STORE_HUBS.map((h) => (
              <option key={h.code} value={h.code}>
                {h.name}
              </option>
            ))}
          </select>

          {/* Status Filter */}
          <select
            value={selectedStatus}
            onChange={(e) => setSelectedStatus(e.target.value)}
            className="px-3 py-2 bg-zinc-50/80 border border-zinc-200 rounded-xl text-xs text-zinc-700 font-medium focus:outline-hidden focus:ring-2 focus:ring-[#2d9d43]"
          >
            <option value="ALL">All Statuses</option>
            <option value="ACTIVE">Active</option>
            <option value="SUSPENDED">Suspended</option>
            <option value="INVITED">Pending Invite</option>
          </select>
        </div>
      </div>

      {/* Staff Users Table */}
      <div className="bg-white rounded-3xl border border-zinc-200/90 shadow-xs overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-zinc-50/90 border-b border-zinc-200/80 text-[11px] font-bold uppercase tracking-wider text-zinc-500 font-mono">
                <th className="py-3 px-4">Staff Member</th>
                <th className="py-3 px-4">Role & Privilege</th>
                <th className="py-3 px-4">Dark Store Hub</th>
                <th className="py-3 px-4">2FA Security</th>
                <th className="py-3 px-4">Status</th>
                <th className="py-3 px-4">Last Active</th>
                <th className="py-3 px-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-zinc-200/70 text-xs">
              {filteredUsers.length === 0 ? (
                <tr>
                  <td colSpan={7} className="py-12 text-center text-zinc-400">
                    <Users className="w-8 h-8 mx-auto mb-2 opacity-40" />
                    <p className="font-medium text-xs">No staff members match the selected criteria.</p>
                  </td>
                </tr>
              ) : (
                filteredUsers.map((user) => (
                  <tr key={user.id} className="hover:bg-zinc-50/60 transition group">
                    <td className="py-3.5 px-4">
                      <div className="flex items-center gap-3">
                        <div
                          className={`w-9 h-9 rounded-xl text-white font-bold text-xs flex items-center justify-center shrink-0 ${user.avatarBg} shadow-2xs`}
                        >
                          {user.name
                            .split(' ')
                            .map((n) => n[0])
                            .join('')
                            .slice(0, 2)}
                        </div>
                        <div>
                          <div className="font-bold text-zinc-950 flex items-center gap-1.5">
                            <span>{user.name}</span>
                            <span className="text-[10px] text-zinc-400 font-mono font-normal">({user.id})</span>
                          </div>
                          <div className="text-[11px] text-zinc-500 flex items-center gap-2 mt-0.5">
                            <span className="flex items-center gap-1">
                              <Mail className="w-3 h-3 text-zinc-400" />
                              {user.email}
                            </span>
                            <span>•</span>
                            <span className="flex items-center gap-1">
                              <Phone className="w-3 h-3 text-zinc-400" />
                              {user.phone}
                            </span>
                          </div>
                        </div>
                      </div>
                    </td>

                    <td className="py-3.5 px-4">{getRoleBadge(user.role)}</td>

                    <td className="py-3.5 px-4">
                      <div className="font-semibold text-zinc-800">{user.storeName}</div>
                      <span className="text-[10px] font-mono text-zinc-400">{user.storeId}</span>
                    </td>

                    <td className="py-3.5 px-4">
                      {user.twoFactorEnabled ? (
                        <div className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-md bg-emerald-50 text-emerald-800 text-[10px] font-mono font-bold">
                          <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                          <span>{user.twoFactorType.replace('_', ' ')}</span>
                        </div>
                      ) : (
                        <div className="inline-flex items-center gap-1.5 px-2 py-0.5 rounded-md bg-zinc-100 text-zinc-500 text-[10px] font-mono">
                          <AlertTriangle className="w-3 h-3 text-amber-500" />
                          <span>NOT ENROLLED</span>
                        </div>
                      )}
                    </td>

                    <td className="py-3.5 px-4">
                      {user.status === 'ACTIVE' && (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 text-[10px] font-bold">
                          <span className="w-1.5 h-1.5 rounded-full bg-emerald-600" />
                          Active
                        </span>
                      )}
                      {user.status === 'SUSPENDED' && (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-rose-100 text-rose-800 text-[10px] font-bold">
                          <span className="w-1.5 h-1.5 rounded-full bg-rose-600" />
                          Suspended
                        </span>
                      )}
                      {user.status === 'INVITED' && (
                        <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-amber-100 text-amber-800 text-[10px] font-bold">
                          <span className="w-1.5 h-1.5 rounded-full bg-amber-600" />
                          Pending
                        </span>
                      )}
                    </td>

                    <td className="py-3.5 px-4 text-zinc-500 text-[11px] font-mono">
                      <div className="flex items-center gap-1">
                        <Clock className="w-3 h-3 text-zinc-400" />
                        {user.lastActive}
                      </div>
                    </td>

                    <td className="py-3.5 px-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        <button
                          type="button"
                          onClick={() => setEditingUser(user)}
                          className="p-1.5 text-zinc-500 hover:text-zinc-950 hover:bg-zinc-100 rounded-lg transition"
                          title="Edit User & Permissions"
                        >
                          <Edit2 className="w-3.5 h-3.5" />
                        </button>

                        <button
                          type="button"
                          onClick={() => handleReset2FA(user)}
                          className="p-1.5 text-zinc-500 hover:text-purple-700 hover:bg-purple-50 rounded-lg transition"
                          title="Reset 2FA Authentication"
                        >
                          <RotateCcw className="w-3.5 h-3.5" />
                        </button>

                        <button
                          type="button"
                          onClick={() => handleToggleStatus(user.id)}
                          className={`p-1.5 rounded-lg transition ${
                            user.status === 'ACTIVE'
                              ? 'text-zinc-500 hover:text-amber-700 hover:bg-amber-50'
                              : 'text-zinc-500 hover:text-emerald-700 hover:bg-emerald-50'
                          }`}
                          title={user.status === 'ACTIVE' ? 'Suspend User Access' : 'Reactivate User'}
                        >
                          {user.status === 'ACTIVE' ? (
                            <Lock className="w-3.5 h-3.5" />
                          ) : (
                            <Unlock className="w-3.5 h-3.5" />
                          )}
                        </button>

                        <button
                          type="button"
                          onClick={() => setDeleteConfirmUser(user)}
                          className="p-1.5 text-zinc-400 hover:text-rose-600 hover:bg-rose-50 rounded-lg transition"
                          title="Delete Account"
                        >
                          <Trash2 className="w-3.5 h-3.5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Invite Member Modal */}
      {isInviteModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-xs animate-in fade-in">
          <div className="bg-white w-full max-w-lg rounded-3xl p-6 border border-zinc-200 shadow-2xl space-y-4">
            <div className="flex items-center justify-between pb-3 border-b border-zinc-100">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-xl bg-emerald-50 text-[#2d9d43] flex items-center justify-center">
                  <UserPlus className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="font-bold text-base text-zinc-950">Invite Staff Member</h3>
                  <p className="text-xs text-zinc-500">Add an operator or manager to Daily Basket Retail OS</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setIsInviteModalOpen(false)}
                className="text-zinc-400 hover:text-zinc-700 p-1"
              >
                <XCircle className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleCreateUser} className="space-y-4">
              <div>
                <label className="text-xs font-bold text-zinc-700 block mb-1">Full Name</label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Ramesh Chandra"
                  value={newUserName}
                  onChange={(e) => setNewUserName(e.target.value)}
                  className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs focus:ring-2 focus:ring-[#2d9d43] focus:bg-white"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-bold text-zinc-700 block mb-1">Official Email</label>
                  <input
                    type="email"
                    required
                    placeholder="r.chandra@dailybasket.com"
                    value={newUserEmail}
                    onChange={(e) => setNewUserEmail(e.target.value)}
                    className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs focus:ring-2 focus:ring-[#2d9d43] focus:bg-white"
                  />
                </div>
                <div>
                  <label className="text-xs font-bold text-zinc-700 block mb-1">Phone Number</label>
                  <input
                    type="tel"
                    placeholder="+91 98450 11223"
                    value={newUserPhone}
                    onChange={(e) => setNewUserPhone(e.target.value)}
                    className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs focus:ring-2 focus:ring-[#2d9d43] focus:bg-white"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-bold text-zinc-700 block mb-1">Security Role</label>
                  <select
                    value={newUserRole}
                    onChange={(e) => setNewUserRole(e.target.value as StaffUser['role'])}
                    className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs focus:ring-2 focus:ring-[#2d9d43]"
                  >
                    <option value="STORE_MANAGER">Store Manager</option>
                    <option value="DISPATCH_HEAD">Dispatch Head</option>
                    <option value="INVENTORY_LEAD">Inventory Lead</option>
                    <option value="SUPPORT_LEAD">Support Lead</option>
                    <option value="STORE_OPERATOR">Store Operator</option>
                    <option value="SUPER_ADMIN">Super Admin</option>
                  </select>
                </div>

                <div>
                  <label className="text-xs font-bold text-zinc-700 block mb-1">Assigned Dark Store</label>
                  <select
                    value={newUserStore}
                    onChange={(e) => setNewUserStore(e.target.value)}
                    className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs focus:ring-2 focus:ring-[#2d9d43]"
                  >
                    {STORE_HUBS.filter((s) => s.code !== 'ALL').map((s) => (
                      <option key={s.code} value={s.code}>
                        {s.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="p-3 bg-emerald-50/70 border border-emerald-200/60 rounded-xl text-[11px] text-[#078730] flex items-center gap-2">
                <Sparkles className="w-4 h-4 shrink-0 text-[#2d9d43]" />
                <span>An activation link and 2FA pairing QR code will be dispatched to the corporate email.</span>
              </div>

              <div className="flex items-center justify-end gap-2 pt-2">
                <Button variant="ghost" size="sm" type="button" onClick={() => setIsInviteModalOpen(false)}>
                  Cancel
                </Button>
                <Button variant="brand" size="sm" type="submit">
                  Dispatch Invitation
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Edit User Modal */}
      {editingUser && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-xs animate-in fade-in">
          <div className="bg-white w-full max-w-lg rounded-3xl p-6 border border-zinc-200 shadow-2xl space-y-4">
            <div className="flex items-center justify-between pb-3 border-b border-zinc-100">
              <div>
                <h3 className="font-bold text-base text-zinc-950">Edit Staff Privileges</h3>
                <p className="text-xs text-zinc-500">{editingUser.name} ({editingUser.id})</p>
              </div>
              <button
                type="button"
                onClick={() => setEditingUser(null)}
                className="text-zinc-400 hover:text-zinc-700 p-1"
              >
                <XCircle className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSaveEdit} className="space-y-4">
              <div>
                <label className="text-xs font-bold text-zinc-700 block mb-1">Full Name</label>
                <input
                  type="text"
                  value={editingUser.name}
                  onChange={(e) => setEditingUser({ ...editingUser, name: e.target.value })}
                  className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs"
                />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-bold text-zinc-700 block mb-1">Security Role</label>
                  <select
                    value={editingUser.role}
                    onChange={(e) =>
                      setEditingUser({ ...editingUser, role: e.target.value as StaffUser['role'] })
                    }
                    className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs"
                  >
                    <option value="SUPER_ADMIN">Super Admin</option>
                    <option value="STORE_MANAGER">Store Manager</option>
                    <option value="DISPATCH_HEAD">Dispatch Head</option>
                    <option value="INVENTORY_LEAD">Inventory Lead</option>
                    <option value="SUPPORT_LEAD">Support Lead</option>
                    <option value="STORE_OPERATOR">Store Operator</option>
                  </select>
                </div>

                <div>
                  <label className="text-xs font-bold text-zinc-700 block mb-1">Dark Store Hub</label>
                  <select
                    value={editingUser.storeId}
                    onChange={(e) => {
                      const found = STORE_HUBS.find((s) => s.code === e.target.value);
                      setEditingUser({
                        ...editingUser,
                        storeId: e.target.value,
                        storeName: found ? found.name : editingUser.storeName,
                      });
                    }}
                    className="w-full px-3 py-2 bg-zinc-50 border border-zinc-200 rounded-xl text-xs"
                  >
                    {STORE_HUBS.filter((s) => s.code !== 'ALL').map((s) => (
                      <option key={s.code} value={s.code}>
                        {s.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div>
                <label className="text-xs font-bold text-zinc-700 block mb-1">Account Status</label>
                <div className="flex items-center gap-3">
                  {(['ACTIVE', 'SUSPENDED'] as const).map((st) => (
                    <label key={st} className="flex items-center gap-2 cursor-pointer text-xs font-semibold">
                      <input
                        type="radio"
                        name="status"
                        checked={editingUser.status === st}
                        onChange={() => setEditingUser({ ...editingUser, status: st })}
                        className="text-[#2d9d43] focus:ring-[#2d9d43]"
                      />
                      <span>{st}</span>
                    </label>
                  ))}
                </div>
              </div>

              <div className="flex items-center justify-end gap-2 pt-2">
                <Button variant="ghost" size="sm" type="button" onClick={() => setEditingUser(null)}>
                  Cancel
                </Button>
                <Button variant="brand" size="sm" type="submit">
                  Save Changes
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {deleteConfirmUser && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-xs animate-in fade-in">
          <div className="bg-white w-full max-w-sm rounded-3xl p-6 border border-zinc-200 shadow-2xl space-y-4 text-center">
            <div className="w-12 h-12 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center mx-auto">
              <ShieldAlert className="w-6 h-6" />
            </div>
            <div>
              <h3 className="font-bold text-base text-zinc-950">Revoke Staff Account?</h3>
              <p className="text-xs text-zinc-500 mt-1">
                Are you sure you want to permanently revoke access for{' '}
                <strong className="text-zinc-900">{deleteConfirmUser.name}</strong>? All session tokens and keys will be invalidated.
              </p>
            </div>
            <div className="flex items-center justify-center gap-2 pt-2">
              <Button variant="ghost" size="sm" onClick={() => setDeleteConfirmUser(null)}>
                Cancel
              </Button>
              <Button variant="destructive" size="sm" onClick={handleDeleteUser}>
                Confirm Revocation
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
