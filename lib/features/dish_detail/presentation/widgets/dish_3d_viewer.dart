import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'camera_script.dart';
import 'dish_3d_error_fallback.dart';
import 'dish_3d_loading_overlay.dart';

/// Visor de modelos 3D (.GLB) para el detalle del plato.
///
/// Usa model_viewer_plus (Google's model-viewer web component):
/// - Android: WebView con servidor HTTP local
/// - Web: renderizado nativo del browser
///
/// Muestra un loading shimmer mientras el WebView arranca y
/// captura errores de canal de Pigeon para mostrar fallback elegante.
class Dish3DViewer extends StatefulWidget {
  const Dish3DViewer({
    super.key,
    required this.glbAssetPath,
    required this.dishName,
  });

  final String glbAssetPath;
  final String dishName;

  @override
  State<Dish3DViewer> createState() => _Dish3DViewerState();
}

class _Dish3DViewerState extends State<Dish3DViewer> {


  bool _hasError = false;
  bool _loading = true;
  void Function(FlutterErrorDetails)? _previousOnError;
  Timer? _loadingTimer;

  void _onFlutterError(FlutterErrorDetails details) {
    final exceptionStr = details.exception.toString();
    if (exceptionStr.contains('channel-error') ||
        exceptionStr.contains('webview_flutter_android') ||
        exceptionStr.contains('PlatformException')) {
      if (mounted) setState(() => _hasError = true);
      return;
    }
    _previousOnError?.call(details);
  }

  @override
  void initState() {
    super.initState();
    _previousOnError = FlutterError.onError;
    FlutterError.onError = _onFlutterError;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _loading) {
        _loadingTimer = Timer(const Duration(milliseconds: 800), () {
          if (mounted) setState(() => _loading = false);
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    if (FlutterError.onError == _onFlutterError) {
      FlutterError.onError = _previousOnError;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return Dish3DErrorFallback(dishName: widget.dishName);

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildViewer(),
        if (_loading) const Dish3DLoadingOverlay(),
      ],
    );
  }

  Widget _buildViewer() {
    try {
      return ModelViewer(
        src: widget.glbAssetPath,
        alt: '${widget.dishName} — modelo 3D interactivo',
        backgroundColor: const Color(0xFF1A1714),
        // Posición inicial cenital — el JS la toma y arranca el bucle espiral
        cameraOrbit: '0deg 10deg auto',
        // autoRotate gira el eje theta (azimut); el JS controla el descenso phi
        autoRotate: true,
        autoRotateDelay: 0,
        rotationPerSecond: '22deg',
        cameraControls: true,
        disableZoom: false,
        interactionPrompt: InteractionPrompt.none,
        shadowIntensity: 1.0,
        exposure: 1.1,
        // Script que anima la cámara desde cenital bajando en espiral
        innerModelViewerHtml: modelViewerCameraScript,
      );
    } on PlatformException {
      // Pigeon channel error en cold start extremo
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _hasError = true);
      });
      return Dish3DErrorFallback(dishName: widget.dishName);
    } catch (_) {
      return Dish3DErrorFallback(dishName: widget.dishName);
    }
  }
}

