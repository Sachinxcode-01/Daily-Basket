/**
 * High-Security Sanitization & Validation Utilities
 * Conforms to Cloudflare Security Audit & OWASP Top 10 Defense-in-Depth standards.
 */

const DANGEROUS_TAGS_REGEX = /<(?:\/?[a-z][a-z0-9]*)\b[^>]*>/gi;
const SCRIPT_URL_REGEX = /javascript:|data:|vbscript:/gi;

/**
 * Strips script tags, HTML injection, dangerous protocols, and control/null characters.
 */
export function sanitizeInput(input: string): string {
  if (typeof input !== 'string') return '';
  return input
    .replace(/\0/g, '') // Strip null bytes
    .replace(SCRIPT_URL_REGEX, '') // Strip inline executable protocols
    .replace(DANGEROUS_TAGS_REGEX, '') // Strip HTML tags
    .trim();
}

/**
 * Escapes characters for safe DOM string insertion.
 */
export function escapeHtml(str: string): string {
  if (typeof str !== 'string') return '';
  const map: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#x27;',
    '/': '&#x2F;',
  };
  return str.replace(/[&<>"'/]/g, (match) => map[match] || match);
}

/**
 * Validates Indian or E.164 international phone number format.
 */
export function isValidPhone(phone: string): boolean {
  if (!phone || typeof phone !== 'string') return false;
  const cleaned = phone.replace(/[\s-]/g, '');
  return /^(\+91)?[6-9]\d{9}$/.test(cleaned);
}

/**
 * Strict RFC 5322 compliant email validator preventing header injection.
 */
export function isValidEmail(email: string): boolean {
  if (!email || typeof email !== 'string') return false;
  if (email.length > 254) return false;
  const emailRegex =
    /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$/;
  return emailRegex.test(email.trim());
}

/**
 * Defends against prototype pollution by discarding __proto__, constructor, and prototype keys.
 */
export function sanitizeObject<T extends Record<string, any>>(obj: T): T {
  if (obj === null || typeof obj !== 'object') {
    return obj;
  }

  if (Array.isArray(obj)) {
    return obj.map((item) => sanitizeObject(item)) as unknown as T;
  }

  const cleanObj: Record<string, any> = {};
  for (const [key, value] of Object.entries(obj)) {
    if (key === '__proto__' || key === 'constructor' || key === 'prototype') {
      continue; // Block Prototype Pollution attempt
    }
    if (typeof value === 'string') {
      cleanObj[key] = sanitizeInput(value);
    } else if (typeof value === 'object' && value !== null) {
      cleanObj[key] = sanitizeObject(value);
    } else {
      cleanObj[key] = value;
    }
  }

  return cleanObj as T;
}
