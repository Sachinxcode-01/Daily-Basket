// Google Stitch Screen ID: voice-search-modal-web
// Title: Real-Time AI Voice Shopping Modal
// Project: Daily Basket Quick-Commerce Suite

'use client';

import React, { useState, useEffect, useRef, useCallback } from 'react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';
import {
  Mic,
  MicOff,
  X,
  Search,
  Plus,
  Minus,
  Check,
  AlertCircle,
  Sparkles,
  ArrowRight,
  RefreshCw,
  Volume2,
} from 'lucide-react';
import { apiClient } from '@daily-basket/api-client';
import { useCart } from '../store/useCart';
import { normalizeImagePath } from '../lib/catalog';

interface VoiceSearchModalProps {
  isOpen: boolean;
  onClose: () => void;
  onProductSelect?: (productId: string) => void;
}

type VoiceState =
  | 'idle'
  | 'requestingPermission'
  | 'recording'
  | 'processing'
  | 'results'
  | 'error';

interface VoiceResultProduct {
  id: string;
  variantId: string;
  name: string;
  brand: string;
  unitName: string;
  price: number;
  mrp: number;
  discount: number;
  inStock: boolean;
  image: string;
}

export function VoiceSearchModal({ isOpen, onClose, onProductSelect }: VoiceSearchModalProps) {
  const router = useRouter();
  const { activeItems, addItem, updateItem } = useCart();

  const [state, setState] = useState<VoiceState>('idle');
  const [selectedLanguage, setSelectedLanguage] = useState<'en-IN' | 'kn-IN' | 'hi-IN'>('en-IN');
  const [transcription, setTranscription] = useState('');
  const [editedQuery, setEditedQuery] = useState('');
  const [extractedQty, setExtractedQty] = useState<string | null>(null);
  const [extractedPrice, setExtractedPrice] = useState<number | null>(null);
  const [products, setProducts] = useState<VoiceResultProduct[]>([]);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [recordingSeconds, setRecordingSeconds] = useState(0);

  // References for Web Speech API and MediaRecorder
  const recognitionRef = useRef<any>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const audioChunksRef = useRef<Blob[]>([]);
  const timerRef = useRef<NodeJS.Timeout | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const languages = [
    { code: 'en-IN' as const, label: 'English', subLabel: 'en-IN' },
    { code: 'kn-IN' as const, label: 'ಕನ್ನಡ', subLabel: 'Kannada' },
    { code: 'hi-IN' as const, label: 'हिंदी', subLabel: 'Hindi' },
  ];

  // Reset modal state when closed
  useEffect(() => {
    if (!isOpen) {
      stopRecording();
      setState('idle');
      setTranscription('');
      setEditedQuery('');
      setProducts([]);
      setErrorMessage(null);
      setRecordingSeconds(0);
    } else {
      // Auto-start recording on open
      startRecording();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isOpen]);

  // Clean up timer on unmount
  useEffect(() => {
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
      if (recognitionRef.current) {
        try {
          recognitionRef.current.abort();
        } catch {}
      }
    };
  }, []);

  // Map raw backend product to modal product card format
  const mapBackendProduct = (p: any): VoiceResultProduct => {
    const variant =
      (Array.isArray(p?.variants) && (p.variants.find((v: any) => v?.isAvailable) ?? p.variants[0])) || null;
    const rawImage = (Array.isArray(p?.images) && p.images[0]) || p.image || null;
    const price = Number(variant?.price ?? p?.price ?? 0);
    const mrp = Number(variant?.mrp ?? p?.mrp ?? price);
    const discount = mrp > price ? Math.round(((mrp - price) / mrp) * 100) : 0;

    return {
      id: p?.id || `prod_${Math.random()}`,
      variantId: variant?.id ?? p?.variantId ?? '',
      name: p?.name ?? '',
      brand: p?.brand ?? 'Daily Basket Select',
      unitName: variant?.unitName ?? p?.unitName ?? '1 pc',
      price,
      mrp,
      discount,
      inStock: p?.inStock !== false && (variant ? (variant.stock ?? 1) > 0 : true),
      image: normalizeImagePath(rawImage),
    };
  };

  // Perform backend search with recognized text or audio
  const executeSearch = useCallback(
    async (queryText: string, audioBlob?: Blob) => {
      if (!queryText.trim() && !audioBlob) return;

      setState('processing');
      setErrorMessage(null);

      try {
        const langCode = selectedLanguage.split('-')[0] || 'en';
        let res: any;

        if (audioBlob) {
          res = await apiClient.voiceSearch({
            audio: audioBlob,
            language: langCode,
          });
        } else {
          res = await apiClient.voiceSearch({
            transcription: queryText.trim(),
            language: langCode,
          });
        }

        const recognizedText = res?.transcription || queryText;
        setTranscription(recognizedText);
        setEditedQuery(recognizedText);
        setExtractedQty(res?.extractedQuantity || null);
        setExtractedPrice(res?.extractedPriceConstraint || null);

        const rawList = Array.isArray(res?.results) ? res.results : [];
        const mapped = rawList.map(mapBackendProduct);
        setProducts(mapped);
        setState('results');
      } catch (err: any) {
        console.error('Voice search failed:', err);
        setErrorMessage(
          err?.message || 'Could not complete voice search. Please check your connection and try again.'
        );
        setState('error');
      }
    },
    [selectedLanguage]
  );

  // Start recording using Web Speech API with MediaRecorder fallback
  const startRecording = async () => {
    setErrorMessage(null);
    setProducts([]);
    setTranscription('');
    setEditedQuery('');
    setRecordingSeconds(0);
    setState('requestingPermission');

    // Timer tick
    if (timerRef.current) clearInterval(timerRef.current);
    timerRef.current = setInterval(() => {
      setRecordingSeconds((prev) => {
        if (prev >= 20) {
          stopRecording();
          return 20;
        }
        return prev + 1;
      });
    }, 1000);

    // 1. Try Web Speech API for instantaneous dictation
    const SpeechRecognition =
      (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;

    if (SpeechRecognition) {
      try {
        const recognition = new SpeechRecognition();
        recognition.lang = selectedLanguage;
        recognition.continuous = false;
        recognition.interimResults = true;
        recognition.maxAlternatives = 1;

        recognition.onstart = () => {
          setState('recording');
        };

        recognition.onresult = (event: any) => {
          let currentTranscript = '';
          for (let i = event.resultIndex; i < event.results.length; ++i) {
            currentTranscript += event.results[i][0].transcript;
          }
          if (currentTranscript) {
            setTranscription(currentTranscript);
            setEditedQuery(currentTranscript);
          }
        };

        recognition.onerror = (event: any) => {
          console.warn('SpeechRecognition error:', event.error);
          if (event.error === 'not-allowed') {
            setState('error');
            setErrorMessage('Microphone access was denied. Please grant microphone permission in your browser.');
            stopRecording();
          } else if (event.error === 'no-speech') {
            setState('error');
            setErrorMessage('No speech was detected. Please tap the microphone and try again.');
            stopRecording();
          }
        };

        recognition.onend = () => {
          if (state === 'recording' || state === 'requestingPermission') {
            // Completed capture
            if (timerRef.current) clearInterval(timerRef.current);
            const finalText = transcription || editedQuery;
            if (finalText.trim()) {
              executeSearch(finalText);
            } else {
              setState('error');
              setErrorMessage('No grocery item was heard. Tap the mic to try speaking again.');
            }
          }
        };

        recognitionRef.current = recognition;
        recognition.start();
        return;
      } catch (err) {
        console.warn('Web Speech API start error, falling back to MediaRecorder:', err);
      }
    }

    // 2. Fallback: Direct MediaRecorder (capturing raw audio blob for backend)
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      setState('recording');

      const mimeType = MediaRecorder.isTypeSupported('audio/webm')
        ? 'audio/webm'
        : MediaRecorder.isTypeSupported('audio/ogg')
        ? 'audio/ogg'
        : 'audio/wav';

      const mediaRecorder = new MediaRecorder(stream, { mimeType });
      audioChunksRef.current = [];

      mediaRecorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          audioChunksRef.current.push(event.data);
        }
      };

      mediaRecorder.onstop = () => {
        stream.getTracks().forEach((track) => track.stop());
        const audioBlob = new Blob(audioChunksRef.current, { type: mimeType });
        executeSearch('', audioBlob);
      };

      mediaRecorderRef.current = mediaRecorder;
      mediaRecorder.start();
    } catch (err: any) {
      console.error('Microphone permission error:', err);
      setState('error');
      setErrorMessage(
        err.name === 'NotAllowedError'
          ? 'Microphone permission was denied. Please allow microphone access in your browser settings.'
          : 'Could not access microphone hardware. Please check your device settings.'
      );
      if (timerRef.current) clearInterval(timerRef.current);
    }
  };

  // Stop recording manually
  const stopRecording = () => {
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }

    if (recognitionRef.current) {
      try {
        recognitionRef.current.stop();
      } catch {}
    }

    if (mediaRecorderRef.current && mediaRecorderRef.current.state === 'recording') {
      try {
        mediaRecorderRef.current.stop();
      } catch {}
    }
  };

  // Add item to cart with immediate optimistic update
  const handleAddToCart = (product: VoiceResultProduct) => {
    if (!product.variantId) return;
    const existing = activeItems.find((i) => i.variantId === product.variantId);
    if (existing) {
      updateItem.mutate({ itemId: existing.id, quantity: existing.quantity + 1 });
    } else {
      addItem.mutate({
        variantId: product.variantId,
        productName: product.name,
        unitName: product.unitName,
        price: product.price,
        quantity: 1,
      });
    }
  };

  const getQty = (variantId: string) => {
    return activeItems.find((i) => i.variantId === variantId)?.quantity ?? 0;
  };

  if (!isOpen) return null;

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="voice-modal-title"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-md animate-in fade-in duration-200"
    >
      <div className="relative w-full max-w-2xl bg-slate-900 border border-slate-700/80 rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
        {/* Top Header Bar */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-800 bg-slate-800/50">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-[#006b23]/20 border border-[#006b23]/40 flex items-center justify-center text-[#2d9d43]">
              <Volume2 className="w-5 h-5 animate-pulse" />
            </div>
            <div>
              <h2 id="voice-modal-title" className="text-base font-bold text-white tracking-tight" style={{ fontFamily: 'Outfit' }}>
                AI Voice Shopping
              </h2>
              <p className="text-xs text-slate-400">
                Speak naturally — e.g. &ldquo;Find one litre of milk&rdquo;
              </p>
            </div>
          </div>

          <button
            onClick={onClose}
            aria-label="Close voice search modal"
            className="p-2 rounded-xl text-slate-400 hover:text-white hover:bg-slate-800 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Language Selection Chips */}
        <div className="px-6 py-2.5 bg-slate-800/30 border-b border-slate-800 flex items-center justify-between gap-2 overflow-x-auto">
          <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider shrink-0">
            Language:
          </span>
          <div className="flex items-center gap-2">
            {languages.map((lang) => {
              const isSelected = selectedLanguage === lang.code;
              return (
                <button
                  key={lang.code}
                  onClick={() => {
                    setSelectedLanguage(lang.code);
                    if (state === 'recording') {
                      stopRecording();
                    }
                  }}
                  className={`px-3 py-1 rounded-full text-xs font-bold transition-all ${
                    isSelected
                      ? 'bg-[#2d9d43] text-white shadow-sm shadow-[#2d9d43]/40'
                      : 'bg-slate-800 text-slate-300 hover:bg-slate-700 border border-slate-700'
                  }`}
                >
                  {lang.label}
                </button>
              );
            })}
          </div>
        </div>

        {/* Main Content Body */}
        <div className="flex-1 overflow-y-auto p-6 flex flex-col items-center">
          {/* ─── State 1: Recording / Listening ────────────────────────────── */}
          {state === 'recording' && (
            <div className="flex flex-col items-center text-center my-6">
              {/* Pulsing Microphone Button */}
              <div className="relative mb-6">
                <span className="animate-ping absolute inset-0 rounded-full bg-[#2d9d43] opacity-40" />
                <span className="animate-pulse absolute -inset-3 rounded-full bg-[#2d9d43]/20" />
                <button
                  onClick={stopRecording}
                  title="Tap to stop listening"
                  className="relative w-24 h-24 rounded-full bg-[#2d9d43] hover:bg-[#258538] text-white flex items-center justify-center shadow-lg shadow-[#2d9d43]/50 transition-transform active:scale-95"
                >
                  <Mic className="w-10 h-10" />
                </button>
              </div>

              <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-xs font-semibold mb-3">
                <span className="w-2 h-2 rounded-full bg-emerald-400 animate-ping" />
                Listening... ({recordingSeconds}s / 20s)
              </div>

              <p className="text-sm font-medium text-slate-300 min-h-[28px] max-w-md px-4">
                {transcription ? (
                  <span className="text-white font-semibold italic">&ldquo;{transcription}&rdquo;</span>
                ) : (
                  'Speak your grocery item clearly...'
                )}
              </p>

              <button
                onClick={stopRecording}
                className="mt-6 px-5 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-bold transition-all border border-slate-700"
              >
                Done Speaking
              </button>
            </div>
          )}

          {/* ─── State 2: Requesting Permission / Idle ─────────────────────── */}
          {(state === 'requestingPermission' || state === 'idle') && (
            <div className="flex flex-col items-center text-center my-8">
              <button
                onClick={startRecording}
                className="w-20 h-20 rounded-full bg-slate-800 hover:bg-slate-700 border-2 border-[#2d9d43] text-[#2d9d43] flex items-center justify-center shadow-md transition-all active:scale-95 mb-4"
              >
                <Mic className="w-8 h-8" />
              </button>
              <h3 className="text-sm font-bold text-white mb-1">Tap Microphone to Speak</h3>
              <p className="text-xs text-slate-400 max-w-xs">
                Requesting microphone access. Click allow if prompted by your browser.
              </p>
            </div>
          )}

          {/* ─── State 3: Processing Search ───────────────────────────────── */}
          {state === 'processing' && (
            <div className="flex flex-col items-center text-center my-10">
              <RefreshCw className="w-10 h-10 text-[#2d9d43] animate-spin mb-4" />
              <h3 className="text-sm font-bold text-white mb-1">Searching Daily Basket Catalogue...</h3>
              <p className="text-xs text-slate-400 italic">
                &ldquo;{editedQuery || transcription}&rdquo;
              </p>
            </div>
          )}

          {/* ─── State 4: Error State ─────────────────────────────────────── */}
          {state === 'error' && (
            <div className="flex flex-col items-center text-center my-6 max-w-md">
              <div className="w-14 h-14 rounded-2xl bg-rose-500/10 border border-rose-500/20 text-rose-400 flex items-center justify-center mb-4">
                <AlertCircle className="w-7 h-7" />
              </div>
              <h3 className="text-sm font-bold text-white mb-2">Voice Recognition Notice</h3>
              <p className="text-xs text-slate-300 mb-6 leading-relaxed bg-slate-800/80 p-3.5 rounded-xl border border-slate-700">
                {errorMessage}
              </p>

              <div className="flex items-center gap-3">
                <button
                  onClick={startRecording}
                  className="px-5 py-2.5 rounded-xl bg-[#2d9d43] hover:bg-[#258538] text-white text-xs font-bold flex items-center gap-2 shadow-sm transition"
                >
                  <RefreshCw className="w-4 h-4" /> Try Again
                </button>
                <button
                  onClick={() => {
                    onClose();
                    router.push('/search');
                  }}
                  className="px-5 py-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-bold border border-slate-700 transition"
                >
                  Use Text Search
                </button>
              </div>
            </div>
          )}

          {/* ─── State 5: Results Display ─────────────────────────────────── */}
          {state === 'results' && (
            <div className="w-full">
              {/* Editable Transcription Query Bar */}
              <div className="mb-5 bg-slate-800/80 border border-slate-700 rounded-2xl p-3 flex items-center gap-2.5">
                <Search className="w-4 h-4 text-[#2d9d43] shrink-0" />
                <input
                  ref={inputRef}
                  type="text"
                  value={editedQuery}
                  onChange={(e) => setEditedQuery(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') executeSearch(editedQuery);
                  }}
                  placeholder="Refine search query..."
                  className="flex-1 bg-transparent text-sm font-semibold text-white focus:outline-none placeholder-slate-400"
                />
                <button
                  onClick={() => executeSearch(editedQuery)}
                  className="px-3 py-1.5 rounded-lg bg-[#2d9d43] hover:bg-[#258538] text-white text-xs font-bold transition shrink-0"
                >
                  Search
                </button>
                <button
                  onClick={startRecording}
                  title="Speak again"
                  className="p-1.5 rounded-lg bg-slate-700 hover:bg-slate-600 text-slate-200 transition shrink-0"
                >
                  <Mic className="w-4 h-4" />
                </button>
              </div>

              {/* Extracted Grocery Tags */}
              {(extractedQty || extractedPrice) && (
                <div className="flex items-center gap-2 mb-4 flex-wrap">
                  <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                    Extracted Filters:
                  </span>
                  {extractedQty && (
                    <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-emerald-500/20 text-emerald-300 text-xs font-bold border border-emerald-500/30">
                      <Sparkles className="w-3 h-3" /> Qty: {extractedQty}
                    </span>
                  )}
                  {extractedPrice && (
                    <span className="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full bg-teal-500/20 text-teal-300 text-xs font-bold border border-teal-500/30">
                      Max: ₹{extractedPrice}
                    </span>
                  )}
                </div>
              )}

              {/* Products List */}
              {products.length > 0 ? (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 max-h-[50vh] overflow-y-auto pr-1">
                  {products.map((product) => {
                    const qty = getQty(product.variantId);
                    return (
                      <div
                        key={product.id}
                        className="bg-slate-800/90 border border-slate-700/80 hover:border-[#2d9d43]/50 rounded-2xl p-3 flex gap-3 transition group"
                      >
                        {/* Product Image */}
                        <div
                          onClick={() => {
                            if (onProductSelect) onProductSelect(product.id);
                            onClose();
                            router.push(`/product/${product.id}`);
                          }}
                          className="w-20 h-20 rounded-xl bg-slate-900 border border-slate-700 p-1 shrink-0 relative overflow-hidden cursor-pointer"
                        >
                          <Image
                            src={product.image}
                            alt={product.name}
                            fill
                            className="object-contain p-1 group-hover:scale-105 transition-transform"
                            sizes="80px"
                          />
                          {product.discount > 0 && (
                            <span className="absolute top-1 left-1 bg-amber-500 text-slate-950 font-extrabold text-[9px] px-1 py-0.5 rounded">
                              {product.discount}% OFF
                            </span>
                          )}
                        </div>

                        {/* Product Details */}
                        <div className="flex-1 flex flex-col justify-between min-w-0">
                          <div>
                            <span className="text-[10px] font-semibold text-slate-400 block truncate">
                              {product.brand}
                            </span>
                            <h4
                              onClick={() => {
                                if (onProductSelect) onProductSelect(product.id);
                                onClose();
                                router.push(`/product/${product.id}`);
                              }}
                              className="text-xs font-bold text-white hover:text-emerald-400 transition cursor-pointer truncate"
                              title={product.name}
                            >
                              {product.name}
                            </h4>
                            <span className="text-[11px] text-slate-400 block mt-0.5">
                              {product.unitName}
                            </span>
                          </div>

                          {/* Price & Add to Cart Controls */}
                          <div className="flex items-center justify-between mt-2 pt-2 border-t border-slate-700/60">
                            <div className="flex items-baseline gap-1.5">
                              <span className="text-sm font-extrabold text-white">
                                ₹{product.price}
                              </span>
                              {product.mrp > product.price && (
                                <span className="text-[11px] text-slate-500 line-through">
                                  ₹{product.mrp}
                                </span>
                              )}
                            </div>

                            {qty === 0 ? (
                              <button
                                onClick={() => handleAddToCart(product)}
                                className="px-3 py-1 rounded-lg bg-[#2d9d43] hover:bg-[#258538] text-white font-extrabold text-xs transition active:scale-95 shadow-sm"
                              >
                                ADD
                              </button>
                            ) : (
                              <div className="flex items-center gap-1.5 bg-[#006b23] text-white rounded-lg px-1.5 py-0.5">
                                <button
                                  onClick={() => {
                                    const item = activeItems.find((i) => i.variantId === product.variantId);
                                    if (item) updateItem.mutate({ itemId: item.id, quantity: qty - 1 });
                                  }}
                                  className="p-1 hover:bg-black/20 rounded"
                                  title="Decrease quantity"
                                >
                                  <Minus className="w-3 h-3" />
                                </button>
                                <span className="text-xs font-bold px-1">{qty}</span>
                                <button
                                  onClick={() => {
                                    const item = activeItems.find((i) => i.variantId === product.variantId);
                                    if (item) updateItem.mutate({ itemId: item.id, quantity: qty + 1 });
                                  }}
                                  className="p-1 hover:bg-black/20 rounded"
                                  title="Increase quantity"
                                >
                                  <Plus className="w-3 h-3" />
                                </button>
                              </div>
                            )}
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <div className="text-center py-8">
                  <p className="text-sm text-slate-400 mb-4">
                    No products matched &ldquo;{editedQuery}&rdquo; in our current store inventory.
                  </p>
                  <button
                    onClick={startRecording}
                    className="px-4 py-2 rounded-xl bg-slate-800 hover:bg-slate-700 text-slate-200 text-xs font-bold border border-slate-700 transition"
                  >
                    Try Another Voice Query
                  </button>
                </div>
              )}

              {/* View Full Catalog Search Link */}
              <div className="mt-5 pt-4 border-t border-slate-800 flex items-center justify-between">
                <span className="text-xs text-slate-400">
                  Found {products.length} matching items
                </span>
                <button
                  onClick={() => {
                    onClose();
                    router.push(`/search?q=${encodeURIComponent(editedQuery)}`);
                  }}
                  className="text-xs font-bold text-[#2d9d43] hover:text-emerald-300 flex items-center gap-1 transition"
                >
                  View in Full Catalog <ArrowRight className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Bottom Footer Tip */}
        <div className="px-6 py-2.5 bg-slate-950/60 border-t border-slate-800/80 flex items-center justify-between text-[11px] text-slate-500">
          <span>Powered by Daily Basket Voice Engine</span>
          <span>Press ESC to exit</span>
        </div>
      </div>
    </div>
  );
}
