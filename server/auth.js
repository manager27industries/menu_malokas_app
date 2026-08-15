const { createHmac, timingSafeEqual } = require('node:crypto');

const COOKIE = 'admin_session';
const MAX_AGE_SEC = 60 * 60 * 24 * 7;

function secret() {
  const value = process.env.ADMIN_SECRET;
  if (!value) throw new Error('Falta ADMIN_SECRET');
  return value;
}

function signSession(exp) {
  const payload = String(exp);
  const sig = createHmac('sha256', secret()).update(payload).digest('hex');
  return `${payload}.${sig}`;
}

function parseCookies(req) {
  const header = req.headers.cookie ?? '';
  const out = {};
  for (const part of header.split(';')) {
    const idx = part.indexOf('=');
    if (idx === -1) continue;
    const key = part.slice(0, idx).trim();
    out[key] = decodeURIComponent(part.slice(idx + 1).trim());
  }
  return out;
}

function isAuthed(req) {
  const token = parseCookies(req)[COOKIE];
  if (!token || !token.includes('.')) return false;
  const [expRaw, sig] = token.split('.');
  const exp = Number(expRaw);
  if (!Number.isFinite(exp) || Date.now() > exp) return false;
  const expected = createHmac('sha256', secret()).update(expRaw).digest('hex');
  const a = Buffer.from(sig);
  const b = Buffer.from(expected);
  if (a.length !== b.length) return false;
  return timingSafeEqual(a, b);
}

function setSessionCookie(res) {
  const exp = Date.now() + MAX_AGE_SEC * 1000;
  const token = signSession(exp);
  const secure = process.env.VERCEL ? '; Secure' : '';
  res.setHeader(
    'Set-Cookie',
    `${COOKIE}=${encodeURIComponent(token)}; HttpOnly; Path=/; Max-Age=${MAX_AGE_SEC}; SameSite=Lax${secure}`,
  );
}

function clearSessionCookie(res) {
  const secure = process.env.VERCEL ? '; Secure' : '';
  res.setHeader(
    'Set-Cookie',
    `${COOKIE}=; HttpOnly; Path=/; Max-Age=0; SameSite=Lax${secure}`,
  );
}

function credentialsMatch(email, password) {
  const expectedEmail = process.env.ADMIN_EMAIL ?? '';
  const expectedPassword = process.env.ADMIN_PASSWORD ?? '';
  if (!expectedEmail || !expectedPassword) return false;
  try {
    const e1 = Buffer.from(String(email).trim().toLowerCase());
    const e2 = Buffer.from(expectedEmail.trim().toLowerCase());
    const p1 = Buffer.from(String(password));
    const p2 = Buffer.from(expectedPassword);
    if (e1.length !== e2.length || p1.length !== p2.length) return false;
    return timingSafeEqual(e1, e2) && timingSafeEqual(p1, p2);
  } catch {
    return false;
  }
}

module.exports = {
  isAuthed,
  setSessionCookie,
  clearSessionCookie,
  credentialsMatch,
};
