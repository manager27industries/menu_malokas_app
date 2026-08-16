const { applyCors } = require('../server/cors');
const { isAuthed } = require('../server/auth');

function pathnameFor(lang) {
  return lang === 'en' ? 'pdfs/menu_en.pdf' : 'pdfs/menu_es.pdf';
}

async function readBody(req) {
  const chunks = [];
  for await (const chunk of req) chunks.push(chunk);
  return Buffer.concat(chunks);
}

async function handler(req, res) {
  if (applyCors(req, res)) return;

  const token = process.env.BLOB_READ_WRITE_TOKEN;
  if (!token) {
    res.status(500).json({
      error:
        'Falta BLOB_READ_WRITE_TOKEN. Añádela en Environment Variables y haz Redeploy.',
    });
    return;
  }

  let blob;
  try {
    blob = require('@vercel/blob');
  } catch (err) {
    res.status(500).json({ error: `No se pudo cargar Blob: ${err.message}` });
    return;
  }

  const lang = req.query.lang === 'en' ? 'en' : 'es';
  const pathname = pathnameFor(lang);

  try {
    if (req.method === 'GET') {
      const { blobs } = await blob.list({ prefix: pathname, token });
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
      const uploaded = await blob.put(pathname, bytes, {
        access: 'public',
        addRandomSuffix: false,
        allowOverwrite: true,
        contentType: 'application/pdf',
        token,
      });
      res.status(200).json({ url: uploaded.url });
      return;
    }

    res.status(405).json({ error: 'Método no permitido' });
  } catch (err) {
    res.status(500).json({ error: err.message || 'Error de Blob' });
  }
}

handler.config = {
  api: { bodyParser: false },
};

module.exports = handler;
