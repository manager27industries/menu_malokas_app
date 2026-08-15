const { applyCors } = require('../server/cors');
const { clearSessionCookie } = require('../server/auth');

module.exports = async function handler(req, res) {
  if (applyCors(req, res)) return;
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Método no permitido' });
    return;
  }
  clearSessionCookie(res);
  res.status(200).json({ ok: true });
};
