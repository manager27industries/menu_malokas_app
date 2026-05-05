// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// IDs ya registrados para evitar registrar el mismo viewFactory dos veces.
final _registeredViews = <String>{};

void registerPdfView(String viewId, String url) {
  if (_registeredViews.contains(viewId)) return;
  _registeredViews.add(viewId);
  ui_web.platformViewRegistry.registerViewFactory(viewId, (_) {
    return html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
  });
}

Widget buildPdfView(String viewId) => HtmlElementView(viewType: viewId);
