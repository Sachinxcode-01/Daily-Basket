import React from 'react';

interface SkeletonProps {
  className?: string;
  width?: string;
  height?: string;
  borderRadius?: string;
}

export function SkeletonLoader({
  className = '',
  width = '100%',
  height = '1rem',
  borderRadius = '0.5rem',
}: SkeletonProps) {
  return (
    <div
      className={`animate-pulse bg-slate-800/80 border border-slate-700/30 ${className}`}
      style={{ width, height, borderRadius }}
    />
  );
}
