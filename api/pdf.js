const { list, put } = require('@vercel/blob');
const { applyCors } = require('../server/cors');
const { isAuthed } = require('../server/auth');

module.exports.config = {
  api: { bodyParser: false },
};

function pathnameFor(lang) {
  return lang === 'en' ? 'pdfs/menu_en.pdf' : 'pdfs/menu_es.pdf';
}

async function readBody(req) {
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  return Buffer.concat(chunks);
}

module.exports = async function handler(req, res) {
  if (applyCors(req, res)) return;

  const lang = req.query.lang === 'en' ? 'en' : 'es';
  const pathname = pathnameFor(lang);

  if (req.method === 'GET') {
    const { blobs } = await list({ prefix: pathname });
    const file = blobs.find((b) => b.pathname === pathname);
    if (!file) {
      res.status(404).json({ error: 'not_found' });
      return;
    }
    res.status(200).json({ url: file.url });
    return;
  }

  if (req.method === 'PUT') {
    if (!isAuthed(req)) {
      res.status(401).json({ error: 'unauthorized' });
      return;
    }
    const bytes = await readBody(req);
    if (!bytes.length) {
      res.status(400).json({ error: 'Archivo vacío' });
      return;
    }
    const blob = await put(pathname, bytes, {
      access: 'public',
      addRandomSuffix: false,
      allowOverwrite: true,
      contentType: 'application/pdf',
    });
    res.status(200).json({ url: blob.url });
    return;
  }

  res.status(405).json({ error: 'Método no permitido' });
};
