import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

import '../../../core/constants/app_colors.dart';

class PdfWebEmbedView extends StatefulWidget {
  const PdfWebEmbedView({super.key, required this.url});

  final String url;

  @override
  State<PdfWebEmbedView> createState() => _PdfWebEmbedViewState();
}

class _PdfWebEmbedViewState extends State<PdfWebEmbedView> {
  String? _blobUrl;
  String? _viewType;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePdfRenderer();
  }

  /// Detecta cuando la URL del PDF cambia (ej: usuario cambió idioma en Supabase)
  /// y recarga el PDF automáticamente.
  @override
  void didUpdateWidget(covariant PdfWebEmbedView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      // URL cambió → recargar PDF
      _cleanupOldRenderer();
      _initializePdfRenderer();
    }
  }

  /// Limpia el visor anterior (blob URL y viewType)
  void _cleanupOldRenderer() {
    if (_blobUrl != null) {
      web.URL.revokeObjectURL(_blobUrl!);
      _blobUrl = null;
      _viewType = null;
      _error = null;
    }
  }

  Future<void> _initializePdfRenderer() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // Agregar timestamp para evitar caché del navegador.
      final urlWithCache = widget.url.contains('?')
          ? '${widget.url}&t=${DateTime.now().millisecondsSinceEpoch}'
          : '${widget.url}?t=${DateTime.now().millisecondsSinceEpoch}';

      // Descargar el PDF desde la URL
      final response = await http.get(Uri.parse(urlWithCache));
      if (response.statusCode >= 400) {
        throw Exception('Error HTTP ${response.statusCode}');
      }

      // Crear blob URL del PDF
      final blob = web.Blob(
        <web.BlobPart>[response.bodyBytes.toJS].toJS,
        web.BlobPropertyBag(type: 'application/pdf'),
      );
      final blobUrl = web.URL.createObjectURL(blob);

      // Generar ID único para este visor
      final viewType = 'pdfjs-viewer-${DateTime.now().microsecondsSinceEpoch}';

      // Registrar el factory que crea el visor con PDF.js
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        return _createPdfJsViewer(blobUrl, viewId);
      });

      if (mounted) {
        setState(() {
          _blobUrl = blobUrl;
          _viewType = viewType;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  /// Crea el visor PDF.js con efecto page flip 3D
  web.HTMLElement _createPdfJsViewer(String blobUrl, int viewId) {
    final container = web.document.createElement('div') as web.HTMLDivElement;
    container.id = 'pdf-container-$viewId';
    container.style.width = '100%';
    container.style.height = '100%';
    container.style.display = 'flex';
    container.style.flexDirection = 'column';
    container.style.backgroundColor = '#f5f5f5';

    // HTML del visor PDF.js - Estilo libro con efecto page flip 3D
    container.innerHTML = '''
      <style>
        #viewer-content-$viewId {
          flex: 1;
          display: flex;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          padding: 16px;
          background: linear-gradient(135deg, #f0f0f0 0%, #e8e8e8 100%);
          position: relative;
          touch-action: none;
          user-select: none;
          perspective: 1200px;
          overflow: hidden;
        }
        .pdf-page-$viewId {
          max-width: 90vw;
          max-height: 70vh;
          width: auto;
          height: auto;
          box-shadow: 0 10px 40px rgba(0,0,0,0.3);
          border: 1px solid #ddd;
          background: white;
          animation: pageFlip-$viewId 0.7s cubic-bezier(0.68, -0.55, 0.265, 1.55) forwards;
          transform-origin: center center;
          will-change: transform;
        }
        @keyframes pageFlip-$viewId {
          0% {
            opacity: 0;
            transform: rotateY(90deg) rotateX(5deg) scale(0.8);
            filter: brightness(0.8);
          }
          50% {
            transform: rotateY(45deg) rotateX(2deg) scale(0.95);
            filter: brightness(0.95);
          }
          100% {
            opacity: 1;
            transform: rotateY(0deg) rotateX(0deg) scale(1);
            filter: brightness(1);
          }
        }
        #viewer-footer-$viewId {
          width: 100%;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 14px 8px;
          background: linear-gradient(135deg, #2d6a4f 0%, #1f4536 100%);
          box-shadow: 0 -2px 8px rgba(0,0,0,0.1);
          overflow: hidden;
        }
        .footer-content-$viewId {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 12px;
          flex-wrap: wrap;
          max-width: 100%;
          padding: 0 4px;
        }
        .nav-btn-$viewId {
          padding: 8px 12px;
          background: rgba(255,255,255,0.9);
          color: #2d6a4f;
          border: none;
          border-radius: 6px;
          cursor: pointer;
          font-size: 12px;
          font-family: system-ui, -apple-system, sans-serif;
          font-weight: 600;
          transition: all 0.2s ease;
          white-space: nowrap;
          flex-shrink: 0;
        }
        .nav-btn-$viewId:hover:not(:disabled) {
          background: white;
          transform: translateY(-1px);
          box-shadow: 0 2px 8px rgba(0,0,0,0.15);
        }
        .nav-btn-$viewId:active:not(:disabled) {
          transform: translateY(0);
        }
        .nav-btn-$viewId:disabled {
          background: rgba(255,255,255,0.4);
          color: #999;
          cursor: not-allowed;
          opacity: 0.6;
        }
        .page-info-$viewId {
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 2px;
          flex-shrink: 0;
          padding: 0 8px;
        }
        .page-indicator-$viewId {
          color: white;
          font-size: 11px;
          font-family: system-ui, -apple-system, sans-serif;
          font-weight: 600;
          letter-spacing: 0.4px;
        }
        .swipe-hint-$viewId {
          color: rgba(255,255,255,0.65);
          font-size: 9px;
          font-family: system-ui, -apple-system, sans-serif;
        }
      </style>

      <div id="viewer-content-$viewId"></div>
      <div id="viewer-footer-$viewId">
        <div class="footer-content-$viewId">
          <button class="nav-btn-$viewId" id="prev-btn-$viewId" title="Página anterior">← Anterior</button>
          <div class="page-info-$viewId">
            <div class="page-indicator-$viewId">
              Página <span id="page-num-$viewId">1</span>/<span id="page-count-$viewId">-</span>
            </div>
            <div class="swipe-hint-$viewId">Desliza para cambiar</div>
          </div>
          <button class="nav-btn-$viewId" id="next-btn-$viewId" title="Página siguiente">Siguiente →</button>
        </div>
      </div>
    '''.toJS as JSAny;

    // Inyectar PDF.js después de que el DOM esté listo
    _injectPdfJs(container, blobUrl, viewId);

    return container;
  }

  /// Inyecta y configura PDF.js
  void _injectPdfJs(web.HTMLElement container, String blobUrl, int viewId) {
    // Crear script tag para cargar PDF.js desde CDN
    final script = web.document.createElement('script') as web.HTMLScriptElement;
    script.src =
        'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js';

    // Usar addEventListener en lugar de .onload para evitar problemas de interop
    script.addEventListener('load', ((web.Event _) {
      // Una vez cargado PDF.js, inicializar el visor
      _setupPdfJsWorker().then((_) {
        _renderPdfWithPdfJs(blobUrl, viewId);
      });
    }).toJS);

    script.addEventListener('error', ((web.Event _) {
      _showError('No se pudo cargar la librería PDF.js');
    }).toJS);

    web.document.head?.appendChild(script);
  }

  /// Configurar el worker de PDF.js
  Future<void> _setupPdfJsWorker() async {
    final workerScript =
        web.document.createElement('script') as web.HTMLScriptElement;
    workerScript.innerHTML = '''
      if (typeof window !== 'undefined' && 'Worker' in window) {
        pdfjsWorker.GlobalWorkerOptions.workerSrc = 
          'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
      }
    '''.toJS as JSAny;
    web.document.head?.appendChild(workerScript);
  }

  /// Renderizar PDF con PDF.js - Estilo libro (una página a la vez) con swipe
  void _renderPdfWithPdfJs(String blobUrl, int viewId) {
    final renderScript =
        web.document.createElement('script') as web.HTMLScriptElement;
    renderScript.innerHTML = '''
      (async () => {
        try {
          const pdfjsLib = window['pdfjs-dist/build/pdf'];
          pdfjsLib.GlobalWorkerOptions.workerSrc = 
            'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
          
          const pdf = await pdfjsLib.getDocument('$blobUrl').promise;
          const container = document.getElementById('viewer-content-$viewId');
          let currentPage = 1;
          let touchStartX = 0;
          let touchEndX = 0;

          document.getElementById('page-count-$viewId').textContent = pdf.numPages;

          const renderPage = async (pageNum) => {
            const page = await pdf.getPage(pageNum);
            const viewport = page.getViewport({ scale: 1 });
            
            const canvas = document.createElement('canvas');
            canvas.className = 'pdf-page-$viewId';
            canvas.width = viewport.width;
            canvas.height = viewport.height;
            
            const context = canvas.getContext('2d');
            await page.render({ canvasContext: context, viewport }).promise;
            
            container.innerHTML = '';
            container.appendChild(canvas);
            document.getElementById('page-num-$viewId').textContent = pageNum;
            
            // Actualizar estado de botones
            document.getElementById('prev-btn-$viewId').disabled = pageNum === 1;
            document.getElementById('next-btn-$viewId').disabled = pageNum === pdf.numPages;
          };

          // Renderizar página inicial
          await renderPage(1);

          // Botones de navegación
          document.getElementById('prev-btn-$viewId').onclick = () => {
            if (currentPage > 1) {
              currentPage--;
              renderPage(currentPage);
            }
          };
          document.getElementById('next-btn-$viewId').onclick = () => {
            if (currentPage < pdf.numPages) {
              currentPage++;
              renderPage(currentPage);
            }
          };

          // Soporte para swipe/deslizar con el dedo
          container.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
          }, false);

          container.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe();
          }, false);

          const handleSwipe = () => {
            const diff = touchStartX - touchEndX;
            const threshold = 50;
            
            // Deslizar hacia la derecha = página anterior
            if (diff < -threshold && currentPage > 1) {
              currentPage--;
              renderPage(currentPage);
            }
            // Deslizar hacia la izquierda = página siguiente
            else if (diff > threshold && currentPage < pdf.numPages) {
              currentPage++;
              renderPage(currentPage);
            }
          };

        } catch (error) {
          console.error('Error renderizando PDF:', error);
          document.getElementById('viewer-content-$viewId').innerHTML = 
            '<div style="padding:20px;color:#d32f2f;font-family:system-ui;text-align:center;">Error al renderizar el PDF</div>';
        }
      })();
    '''.toJS as JSAny;
    web.document.body?.appendChild(renderScript);
  }

  void _showError(String message) {
    if (mounted) {
      setState(() {
        _error = message;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _cleanupOldRenderer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.darkGreen),
            SizedBox(height: 16),
            Text(
              'Cargando menú PDF…',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_error != null || _viewType == null) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf_rounded,
                  size: 48, color: AppColors.earth),
              const SizedBox(height: 12),
              Text(
                _error ?? 'No se pudo cargar el PDF.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                ),
                onPressed: () => web.window.open(widget.url, '_blank'),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('Descargar PDF'),
              ),
            ],
          ),
        ),
      );
    }

    return HtmlElementView(viewType: _viewType!);
  }
}
