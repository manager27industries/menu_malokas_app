const { applyCors } = require('../server/cors');
const { isAuthed } = require('../server/auth');

module.exports = async function handler(req, res) {
  if (applyCors(req, res)) return;
  if (req.method !== 'GET') {
    res.status(405).json({ error: 'Método no permitido' });
    return;
  }
  if (!isAuthed(req)) {
    res.status(200).json({ ok: false });
    return;
  }
  res.status(200).json({ ok: true });
};
