// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

class PdfWebEmbedView extends StatefulWidget {
  const PdfWebEmbedView({super.key, required this.url});

  final String url;

  @override
  State<PdfWebEmbedView> createState() => _PdfWebEmbedViewState();
}

class _PdfWebEmbedViewState extends State<PdfWebEmbedView> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'pdf-iframe-${DateTime.now().microsecondsSinceEpoch}';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = widget.url
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
