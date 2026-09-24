'use client';

import React, { useEffect, useRef, useState } from 'react';
import { X, Camera, Loader2, ScanLine } from 'lucide-react';

interface BarcodeScannerProps {
  onDetected: (code: string) => void;
  onClose: () => void;
}

/**
 * Live-camera barcode / QR scanner.
 * Uses getUserMedia for the camera feed and the native BarcodeDetector API
 * (Chromium) to decode frames. Falls back to manual entry when the browser
 * lacks BarcodeDetector or camera access is denied.
 */
export function BarcodeScanner({ onDetected, onClose }: BarcodeScannerProps) {
  const videoRef = useRef<HTMLVideoElement>(null);
  const streamRef = useRef<MediaStream | null>(null);
  const detectedRef = useRef(false);
  const onDetectedRef = useRef(onDetected);
  onDetectedRef.current = onDetected;

  const [error, setError] = useState<string | null>(null);
  const [scanningSupported, setScanningSupported] = useState(true);
  const [ready, setReady] = useState(false);
  const [manual, setManual] = useState('');

  useEffect(() => {
    let interval: any;
    let cancelled = false;

    const stopStream = () => {
      if (interval) clearInterval(interval);
      streamRef.current?.getTracks().forEach((t) => t.stop());
      streamRef.current = null;
    };

    const start = async () => {
      const BD = typeof window !== 'undefined' ? (window as any).BarcodeDetector : undefined;
      let detector: any = null;
      if (BD) {
        try {
          detector = new BD({ formats: ['ean_13', 'ean_8', 'upc_a', 'upc_e', 'code_128', 'code_39', 'qr_code'] });
        } catch {
          try { detector = new BD(); } catch { detector = null; }
        }
      }
      if (!detector) setScanningSupported(false);

      if (!navigator.mediaDevices?.getUserMedia) {
        setError('Camera is not available in this browser. Enter a code manually below.');
        return;
      }

      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          video: { facingMode: { ideal: 'environment' } },
          audio: false,
        });
        if (cancelled) { stream.getTracks().forEach((t) => t.stop()); return; }
        streamRef.current = stream;
        if (videoRef.current) {
          videoRef.current.srcObject = stream;
          await videoRef.current.play().catch(() => {});
          setReady(true);
        }

        if (detector) {
          interval = setInterval(async () => {
            if (!videoRef.current || detectedRef.current) return;
            try {
              const codes = await detector.detect(videoRef.current);
              if (codes && codes.length > 0 && codes[0].rawValue) {
                detectedRef.current = true;
                const value = String(codes[0].rawValue).trim();
                stopStream();
                onDetectedRef.current(value);
              }
            } catch {
              /* transient detect errors are ignored */
            }
          }, 500);
        }
      } catch {
        setError('Camera access was denied. Allow camera permission, or enter a code manually below.');
      }
    };

    start();
    return () => { cancelled = true; stopStream(); };
  }, []);

  const submitManual = (e: React.FormEvent) => {
    e.preventDefault();
    const v = manual.trim();
    if (v) { detectedRef.current = true; onDetected(v); }
  };

  return (
    <div className="fixed inset-0 z-50 bg-slate-950/90 backdrop-blur-md flex items-center justify-center p-4">
      <div className="bg-slate-800 border border-slate-700 rounded-3xl max-w-md w-full p-5 relative shadow-2xl">
        <button onClick={onClose} className="absolute top-3 right-3 text-slate-400 hover:text-white p-2 rounded-full z-10" aria-label="Close">
          <X className="w-5 h-5" />
        </button>

        <div className="flex items-center gap-2 mb-3">
          <Camera className="w-5 h-5 text-teal-400" />
          <h3 className="text-lg font-bold text-white" style={{ fontFamily: 'Outfit' }}>Scan Barcode</h3>
        </div>

        {/* Camera preview */}
        <div className="relative w-full aspect-square bg-black rounded-2xl overflow-hidden">
          <video ref={videoRef} playsInline muted className="w-full h-full object-cover" />
          {!ready && !error && (
            <div className="absolute inset-0 flex flex-col items-center justify-center gap-2 text-slate-300">
              <Loader2 className="w-7 h-7 animate-spin text-teal-400" />
              <span className="text-xs">Starting camera…</span>
            </div>
          )}
          {ready && (
            <>
              <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                <div className="w-3/4 h-1/3 border-2 border-teal-400/80 rounded-xl" />
              </div>
              <ScanLine className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 w-1/2 h-1/2 text-teal-400/30 animate-pulse pointer-events-none" />
            </>
          )}
        </div>

        {error ? (
          <p className="text-xs text-amber-400 mt-3">{error}</p>
        ) : (
          <p className="text-xs text-slate-300 mt-3">
            {scanningSupported
              ? 'Point the camera at a product barcode or QR code.'
              : 'Live decoding is not supported in this browser — enter the barcode number manually.'}
          </p>
        )}

        {/* Manual fallback */}
        <form onSubmit={submitManual} className="flex gap-2 mt-3">
          <input
            value={manual}
            onChange={(e) => setManual(e.target.value)}
            inputMode="numeric"
            placeholder="Enter barcode number…"
            className="flex-1 bg-slate-900 border border-slate-700 rounded-xl px-3 py-2 text-sm text-white placeholder:text-slate-500 focus:outline-none focus:border-teal-500"
          />
          <button type="submit" disabled={!manual.trim()} className="px-4 py-2 bg-teal-500 disabled:opacity-50 text-slate-950 font-bold text-sm rounded-xl hover:bg-teal-400 transition">
            Go
          </button>
        </form>
      </div>
    </div>
  );
}
