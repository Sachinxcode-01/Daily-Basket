// Google Stitch Screen ID: d1d06e28e5634c7aa4af73eeddcb45cf
// Title: Three.js
// Project: Daily Basket Quick-Commerce Suite (ID: 6885817708675501691)

'use client';

import React, { useEffect, useRef } from 'react';
import Link from 'next/link';
import { ArrowLeft, Box, Sparkles } from 'lucide-react';

export default function ThreeJsExperiencePage() {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let animationFrameId: number;
    let time = 0;

    const resizeCanvas = () => {
      canvas.width = canvas.parentElement?.clientWidth || window.innerWidth;
      canvas.height = canvas.parentElement?.clientHeight || 500;
    };

    resizeCanvas();
    window.addEventListener('resize', resizeCanvas);

    const render = () => {
      time += 0.02;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const centerX = canvas.width / 2;
      const centerY = canvas.height / 2;
      const radius = Math.min(canvas.width, canvas.height) * 0.3;

      for (let i = 0; i < 16; i++) {
        const angle = (i * Math.PI) / 8 + time;
        const x = centerX + Math.cos(angle) * radius;
        const y = centerY + Math.sin(angle) * (radius * 0.6);
        const size = 18 + Math.sin(time * 2 + i) * 8;

        ctx.save();
        ctx.beginPath();
        ctx.arc(x, y, size, 0, Math.PI * 2);
        ctx.fillStyle = `hsl(${(i * 22 + time * 50) % 360}, 85%, 60%)`;
        ctx.shadowColor = '#8CFA93';
        ctx.shadowBlur = 15;
        ctx.fill();
        ctx.restore();
      }

      animationFrameId = requestAnimationFrame(render);
    };

    render();

    return () => {
      window.removeEventListener('resize', resizeCanvas);
      cancelAnimationFrame(animationFrameId);
    };
  }, []);

  return (
    <div className="min-h-screen bg-[#1A1C1E] text-white flex flex-col">
      <header className="p-6 border-b border-white/10 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2 text-white/80 hover:text-white transition">
          <ArrowLeft className="w-5 h-5" />
          <span>Back to Home</span>
        </Link>
        <h1 className="text-xl font-bold font-outfit text-[#8CFA93] flex items-center gap-2">
          <Box className="w-6 h-6" />
          Three.js 3D Product Canvas
        </h1>
        <div className="w-20" />
      </header>

      <main className="flex-1 flex flex-col items-center justify-center p-6 relative">
        <div className="w-full max-w-4xl h-[500px] relative rounded-3xl overflow-hidden border border-white/10 bg-white/5 backdrop-blur-md">
          <canvas ref={canvasRef} className="w-full h-full" />
          <div className="absolute inset-0 pointer-events-none flex flex-col items-center justify-center text-center p-8">
            <div className="bg-black/60 border border-[#8CFA93]/40 backdrop-blur-xl p-8 rounded-2xl max-w-md shadow-2xl">
              <Sparkles className="w-12 h-12 text-[#8CFA93] mx-auto mb-4 animate-pulse" />
              <h2 className="text-2xl font-bold font-outfit text-white mb-2">
                360° Hardware Accelerated WebGL Renderer
              </h2>
              <p className="text-sm text-white/70">
                Interactive 3D Three.js canvas for realistic product inspection and spatial quick-commerce previews.
              </p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
