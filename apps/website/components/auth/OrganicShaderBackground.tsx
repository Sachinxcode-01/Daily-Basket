'use client';

import React, { useEffect, useRef } from 'react';

/**
 * OrganicShaderBackground — WebGL / Smooth Organic Canvas Shader Background
 * Creates a modern, subtle moving organic gradient with emerald green, fresh lime,
 * and soft mint tones, perfect for authentication cards.
 */
export default function OrganicShaderBackground() {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    let animationFrameId: number;
    let time = 0;

    const resize = () => {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    };

    window.addEventListener('resize', resize);
    resize();

    const render = () => {
      time += 0.004;
      const width = canvas.width;
      const height = canvas.height;

      // Base background: soft crisp off-white/light gray
      ctx.fillStyle = '#f8faf9';
      ctx.fillRect(0, 0, width, height);

      // Subtle moving organic blob 1 (Emerald gradient)
      const x1 = width * (0.5 + 0.3 * Math.sin(time * 0.8));
      const y1 = height * (0.3 + 0.2 * Math.cos(time * 0.6));
      const grad1 = ctx.createRadialGradient(x1, y1, 50, x1, y1, width * 0.55);
      grad1.addColorStop(0, 'rgba(140, 250, 147, 0.28)'); // #8CFA93
      grad1.addColorStop(0.5, 'rgba(7, 135, 48, 0.12)');  // #078730
      grad1.addColorStop(1, 'rgba(248, 250, 249, 0)');
      ctx.fillStyle = grad1;
      ctx.fillRect(0, 0, width, height);

      // Subtle moving organic blob 2 (Soft Mint/Lime gradient)
      const x2 = width * (0.3 + 0.35 * Math.cos(time * 0.7));
      const y2 = height * (0.7 + 0.25 * Math.sin(time * 0.9));
      const grad2 = ctx.createRadialGradient(x2, y2, 80, x2, y2, width * 0.6);
      grad2.addColorStop(0, 'rgba(232, 247, 236, 0.45)'); // #E8F7EC
      grad2.addColorStop(0.6, 'rgba(12, 166, 62, 0.08)');
      grad2.addColorStop(1, 'rgba(248, 250, 249, 0)');
      ctx.fillStyle = grad2;
      ctx.fillRect(0, 0, width, height);

      // Subtle moving organic blob 3 (Top right accent)
      const x3 = width * (0.8 + 0.2 * Math.sin(time * 0.5));
      const y3 = height * (0.2 + 0.2 * Math.cos(time * 0.8));
      const grad3 = ctx.createRadialGradient(x3, y3, 30, x3, y3, width * 0.4);
      grad3.addColorStop(0, 'rgba(140, 250, 147, 0.22)');
      grad3.addColorStop(1, 'rgba(248, 250, 249, 0)');
      ctx.fillStyle = grad3;
      ctx.fillRect(0, 0, width, height);

      animationFrameId = requestAnimationFrame(render);
    };

    render();

    return () => {
      window.removeEventListener('resize', resize);
      cancelAnimationFrame(animationFrameId);
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      className="fixed inset-0 w-full h-full pointer-events-none -z-10 transition-opacity duration-1000"
    />
  );
}
