const { applyCors } = require('../server/cors');
const { credentialsMatch, setSessionCookie } = require('../server/auth');

module.exports = async function handler(req, res) {
  if (applyCors(req, res)) return;
  if (req.method !== 'POST') {
    res.status(405).json({ error: 'Método no permitido' });
    return;
  }

  const { email, password } = req.body ?? {};
  if (!credentialsMatch(email, password)) {
    res.status(401).json({ error: 'Email o contraseña incorrectos.' });
    return;
  }

  setSessionCookie(res);
  res.status(200).json({ ok: true });
};
