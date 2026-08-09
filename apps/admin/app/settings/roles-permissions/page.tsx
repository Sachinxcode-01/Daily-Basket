'use client';

import React, { useState } from 'react';
import {
  Menu,
  Bell,
  BadgeCheck,
  Users,
  Key,
  Plus,
  Download,
  Shield,
  Store,
  Landmark,
  Package,
  Grid,
  CheckCircle2,
  XCircle,
  UserCheck,
  ShieldAlert,
  ChevronUp,
  ChevronDown,
  LayoutGrid,
  Smartphone,
  ShoppingBag,
  MoreHorizontal,
} from 'lucide-react';

// Google Stitch Source of Truth Specs
// Screen: Roles & Permissions - Daily Basket Admin
// Screen ID: 25b5d2e145f049b0b0656481e8e11725

export default function RolesPermissionsPage() {
  const [viewMode, setViewMode] = useState<'web' | 'mobile'>('web');
  const [isMatrixExpanded, setIsMatrixExpanded] = useState(true);
  const [activeModal, setActiveModal] = useState<string | null>(null);

  const rolesData = {
    totalRoles: 12,
    activeUsers: 452,
    customPolicies: 8,
    roles: [
      {
        id: 'role-1',
        title: 'Super Admin',
        subtitle: 'Full system access',
        userCount: 4,
        icon: Shield,
        iconBg: 'bg-rose-100 text-[#dc2626]',
      },
      {
        id: 'role-2',
        title: 'Store Manager',
        subtitle: 'Location specific access',
        userCount: 48,
        icon: Store,
        iconBg: 'bg-emerald-100 text-[#15803d]',
      },
      {
        id: 'role-3',
        title: 'Finance Manager',
        subtitle: 'Payments & billing',
        userCount: 12,
        icon: Landmark,
        iconBg: 'bg-indigo-100 text-[#2563eb]',
      },
      {
        id: 'role-4',
        title: 'Inventory Manager',
        subtitle: 'Stock & suppliers',
        userCount: 24,
        icon: Package,
        iconBg: 'bg-pink-100 text-[#db2777]',
      },
    ],
    matrix: [
      { module: 'Products', read: true, write: true },
      { module: 'Orders', read: true, write: true },
      { module: 'Inventory', read: true, write: true },
    ],
    activity: [
      {
        title: 'Permission Updated',
        time: '10m ago',
        actor: 'SuperAdmin',
        action: "added 'Delete' access to ",
        target: 'Inventory Manager.',
        icon: UserCheck,
        iconBg: 'bg-[#e2e8f0] text-[#475569]',
        isFailed: false,
      },
      {
        title: 'Failed Access Attempt',
        time: '2h ago',
        userBadge: 'US-8821',
        action: 'attempted to access ',
        target: 'Finance Module.',
        icon: ShieldAlert,
        iconBg: 'bg-rose-100 text-[#dc2626]',
        isFailed: true,
      },
    ],
  };

  return (
    <div className="space-y-6 max-w-6xl mx-auto font-sans">
      {/* Stitch Header Title & Navigation Controls */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 bg-white p-5 rounded-3xl border border-[#e2e8f0] shadow-sm">
        <div>
          <h1 className="text-2xl font-black text-[#006837] tracking-tight">Roles &amp; Permissions</h1>
          <p className="text-xs text-[#64748b] mt-0.5 font-medium">
            Google Stitch Screen ID: 25b5d2e145f049b0b0656481e8e11725
          </p>
        </div>

        {/* View Mode Toggle */}
        <div className="flex items-center gap-2 bg-[#f1f5f9] p-1.5 rounded-2xl border border-[#e2e8f0]">
          <button
            onClick={() => setViewMode('web')}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'web' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <LayoutGrid className="w-3.5 h-3.5" />
            <span>Web Dashboard</span>
          </button>
          <button
            onClick={() => setViewMode('mobile')}
            className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition ${
              viewMode === 'mobile' ? 'bg-[#006837] text-white shadow-sm' : 'text-[#64748b] hover:text-[#1e2923]'
            }`}
          >
            <Smartphone className="w-3.5 h-3.5" />
            <span>Mobile Stitch View</span>
          </button>
        </div>
      </div>

      {/* Main Content */}
      {viewMode === 'mobile' ? (
        <div className="flex justify-center py-6">
          <div className="w-[390px] h-[840px] bg-[#f8fafc] rounded-[48px] border-[12px] border-[#1e2923] shadow-2xl overflow-hidden flex flex-col relative">
            {/* Phone Top Notch */}
            <div className="w-36 h-5 bg-[#1e2923] rounded-b-2xl mx-auto flex items-center justify-center gap-2">
              <div className="w-3 h-3 rounded-full bg-[#006837]/40" />
            </div>

            {/* Mobile App Bar */}
            <div className="bg-white px-4 py-3 flex items-center justify-between border-b border-[#e2e8f0]">
              <Menu className="w-5 h-5 text-[#1e2923] cursor-pointer" />
              <div className="flex items-center gap-2">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100"
                  alt="Profile"
                  className="w-6 h-6 rounded-full object-cover"
                />
                <span className="font-extrabold text-base text-[#006837]">Daily Basket</span>
              </div>
              <div className="relative">
                <Bell className="w-5 h-5 text-[#1e2923] cursor-pointer" />
                <span className="absolute top-0 right-0 w-2 h-2 bg-red-600 rounded-full" />
              </div>
            </div>

            {/* Scrollable Body */}
            <div className="flex-1 overflow-y-auto p-4 space-y-4 relative">
              <div>
                <h2 className="text-xl font-black text-[#1e2923]">Roles &amp; Permissions</h2>
                <p className="text-xs text-[#64748b] mt-0.5">Manage access control and security policies.</p>
              </div>

              {/* Metrics Strip */}
              <div className="flex gap-2 overflow-x-auto pb-1 no-scrollbar text-xs">
                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1.5 text-[#15803d]">
                    <BadgeCheck className="w-4 h-4" />
                    <span className="font-bold text-[11px] text-[#64748b]">Total Roles</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{rolesData.totalRoles}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1.5 text-[#2563eb]">
                    <Users className="w-4 h-4" />
                    <span className="font-bold text-[11px] text-[#64748b]">Active Users</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{rolesData.activeUsers}</p>
                </div>

                <div className="min-w-[130px] bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm space-y-2">
                  <div className="flex items-center gap-1.5 text-[#db2777]">
                    <Key className="w-4 h-4" />
                    <span className="font-bold text-[11px] text-[#64748b]">Custom Policies</span>
                  </div>
                  <p className="text-2xl font-black text-[#1e2923]">{rolesData.customPolicies}</p>
                </div>
              </div>

              {/* Action Buttons Row */}
              <div className="flex gap-3">
                <button
                  onClick={() => setActiveModal('Create Role')}
                  className="flex-1 py-3 bg-[#006837] text-white text-xs font-bold rounded-2xl flex items-center justify-center gap-1.5 shadow-sm hover:bg-[#00522b]"
                >
                  <Plus className="w-4 h-4" /> Create Role
                </button>
                <button
                  onClick={() => setActiveModal('Export Audit')}
                  className="flex-1 py-3 bg-[#e2e8f0] text-[#1e2923] text-xs font-bold rounded-2xl flex items-center justify-center gap-1.5 hover:bg-[#cbd5e1]"
                >
                  <Download className="w-4 h-4" /> Export Audit
                </button>
              </div>

              {/* Built-in Roles */}
              <div className="space-y-3">
                <div className="flex justify-between items-center">
                  <h4 className="font-black text-sm text-[#1e2923]">Built-in Roles</h4>
                  <span className="text-xs font-bold text-[#006837] cursor-pointer">View All</span>
                </div>

                {rolesData.roles.map((role) => {
                  const IconComponent = role.icon;
                  return (
                    <div key={role.id} className="bg-white p-3.5 rounded-2xl border border-[#e2e8f0] shadow-sm flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className={`p-2.5 rounded-full ${role.iconBg}`}>
                          <IconComponent className="w-5 h-5" />
                        </div>
                        <div>
                          <h5 className="font-bold text-sm text-[#1e2923]">{role.title}</h5>
                          <p className="text-[11px] text-[#64748b]">{role.subtitle}</p>
                        </div>
                      </div>

                      <div className="text-right">
                        <p className="font-black text-base text-[#1e2923]">{role.userCount}</p>
                        <p className="text-[10px] text-[#64748b]">Users</p>
                      </div>
                    </div>
                  );
                })}
              </div>

              {/* Permission Matrix */}
              <div className="bg-white rounded-3xl border border-[#e2e8f0] shadow-sm overflow-hidden">
                <button
                  onClick={() => setIsMatrixExpanded(!isMatrixExpanded)}
                  className="w-full p-4 flex items-center justify-between text-left"
                >
                  <div className="flex items-center gap-2">
                    <Grid className="w-5 h-5 text-[#1e2923]" />
                    <h4 className="font-black text-sm text-[#1e2923]">Permission Matrix</h4>
                  </div>
                  {isMatrixExpanded ? (
                    <ChevronUp className="w-5 h-5 text-[#1e2923]" />
                  ) : (
                    <ChevronDown className="w-5 h-5 text-[#1e2923]" />
                  )}
                </button>

                {isMatrixExpanded && (
                  <div className="p-4 pt-0 border-t border-[#f1f5f9] space-y-3">
                    <div className="grid grid-cols-12 text-[11px] font-bold text-[#64748b] pb-1 border-b border-[#f1f5f9]">
                      <span className="col-span-6">Module</span>
                      <span className="col-span-3 text-center">Read</span>
                      <span className="col-span-3 text-center">Write</span>
                    </div>

                    {rolesData.matrix.map((row) => (
                      <div key={row.module} className="grid grid-cols-12 text-xs items-center py-1">
                        <span className="col-span-6 font-semibold text-[#1e2923]">{row.module}</span>
                        <div className="col-span-3 flex justify-center">
                          {row.read ? (
                            <CheckCircle2 className="w-4 h-4 text-[#15803d]" />
                          ) : (
                            <XCircle className="w-4 h-4 text-[#cbd5e1]" />
                          )}
                        </div>
                        <div className="col-span-3 flex justify-center">
                          {row.write ? (
                            <CheckCircle2 className="w-4 h-4 text-[#15803d]" />
                          ) : (
                            <XCircle className="w-4 h-4 text-[#cbd5e1]" />
                          )}
                        </div>
                      </div>
                    ))}

                    <p className="text-[11px] text-[#64748b] italic text-center pt-2">
                      Showing preview for &apos;Store Manager&apos; role.
                    </p>
                  </div>
                )}
              </div>

              {/* Recent Activity */}
              <div className="space-y-3">
                <h4 className="font-black text-sm text-[#1e2923]">Recent Activity</h4>

                {rolesData.activity.map((act, idx) => {
                  const IconComp = act.icon;
                  return (
                    <div
                      key={idx}
                      className={`bg-white p-3.5 rounded-2xl border ${
                        act.isFailed ? 'border-[#fecaca]' : 'border-[#e2e8f0]'
                      } shadow-sm flex items-start gap-3`}
                    >
                      <div className={`p-2 rounded-xl ${act.iconBg} shrink-0`}>
                        <IconComp className="w-4 h-4" />
                      </div>

                      <div className="flex-1 space-y-1">
                        <div className="flex justify-between items-center text-xs">
                          <h5 className={`font-bold ${act.isFailed ? 'text-[#dc2626]' : 'text-[#1e2923]'}`}>
                            {act.title}
                          </h5>
                          <span className="text-[10px] text-[#64748b]">{act.time}</span>
                        </div>

                        <p className="text-xs text-[#334155] leading-relaxed">
                          {act.actor && <span className="font-bold text-[#1e2923]">{act.actor} </span>}
                          {act.userBadge && (
                            <span className="px-1.5 py-0.5 bg-[#f1f5f9] text-[10px] font-mono font-bold text-[#1e2923] rounded">
                              {act.userBadge}
                            </span>
                          )}{' '}
                          {act.action}
                          <span className={`font-bold ${act.isFailed ? 'text-[#1e2923]' : 'text-[#15803d]'}`}>
                            {act.target}
                          </span>
                        </p>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Bottom Nav Bar */}
            <div className="bg-white border-t border-[#e2e8f0] px-4 py-2 flex justify-between items-center text-[10px] font-bold text-[#64748b]">
              <div className="flex flex-col items-center gap-0.5"><Grid className="w-4 h-4" /> Dashboard</div>
              <div className="flex flex-col items-center gap-0.5"><ShoppingBag className="w-4 h-4" /> Orders</div>
              <div className="flex flex-col items-center gap-0.5"><Package className="w-4 h-4" /> Inventory</div>
              <div className="flex flex-col items-center gap-0.5"><Store className="w-4 h-4" /> Suppliers</div>
              <div className="flex flex-col items-center gap-0.5 px-3 py-1 bg-[#006837] text-white rounded-2xl">
                <MoreHorizontal className="w-4 h-4" /> More
              </div>
            </div>
          </div>
        </div>
      ) : (
        /* Web Dashboard View */
        <div className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#64748b] font-bold uppercase">Total Roles</span>
              <p className="text-3xl font-black text-[#1e2923]">{rolesData.totalRoles}</p>
            </div>
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#2563eb] font-bold uppercase">Active Users</span>
              <p className="text-3xl font-black text-[#1e2923]">{rolesData.activeUsers}</p>
            </div>
            <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-2">
              <span className="text-xs text-[#db2777] font-bold uppercase">Custom Policies</span>
              <p className="text-3xl font-black text-[#1e2923]">{rolesData.customPolicies}</p>
            </div>
          </div>

          <div className="bg-white p-6 rounded-3xl border border-[#e2e8f0] shadow-sm space-y-4">
            <h3 className="font-black text-lg text-[#1e2923]">Built-in Roles</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {rolesData.roles.map((role) => (
                <div key={role.id} className="p-5 bg-[#f8fafc] rounded-2xl border border-[#e2e8f0] flex justify-between items-center">
                  <div>
                    <h4 className="font-bold text-base text-[#1e2923]">{role.title}</h4>
                    <p className="text-xs text-[#64748b]">{role.subtitle}</p>
                  </div>
                  <span className="font-black text-xl text-[#006837]">{role.userCount} Users</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Action Modals */}
      {activeModal && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl space-y-4 text-center">
            <h3 className="text-lg font-bold text-[#1e2923]">{activeModal}</h3>
            <p className="text-xs text-[#64748b]">Executing action &quot;{activeModal}&quot; for Security &amp; Access module.</p>
            <button
              onClick={() => setActiveModal(null)}
              className="w-full py-3 bg-[#006837] text-white font-bold text-xs rounded-2xl hover:bg-[#00522b]"
            >
              Close Modal
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
