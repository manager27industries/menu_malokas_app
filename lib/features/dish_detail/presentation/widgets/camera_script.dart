/// Script JS inyectado en <model-viewer> para la animación de cámara en espiral.
///
/// Ciclo:
///  1. Descenso suave desde cenital (phi 10°) a horizontal (phi 75°) — ~10 s
///  2. Rotación horizontal durante 20 s
///  3. Ascenso suave de vuelta a cenital — ~10 s
///  4. Pausa breve y repetición indefinida
const String modelViewerCameraScript = '''
<script>
(function() {
  var mv = document.querySelector('model-viewer');
  if (!mv) return;

  var STEP   = 0.65;    // grados por tick (suavidad del descenso/ascenso)
  var TICK   = 100;     // ms entre ticks
  var TOP    = 10;      // phi cenital (desde arriba)
  var BOT    = 75;      // phi horizontal (vista lateral)
  var HOLD   = 20000;   // 20 segundos de rotación horizontal

  function descend(onDone) {
    var phi = TOP;
    mv.cameraOrbit = '0deg ' + phi + 'deg auto';
    var t = setInterval(function() {
      phi = Math.min(phi + STEP, BOT);
      mv.cameraOrbit = '0deg ' + phi + 'deg auto';
      if (phi >= BOT) { clearInterval(t); setTimeout(onDone, HOLD); }
    }, TICK);
  }

  function ascend(onDone) {
    var phi = BOT;
    var t = setInterval(function() {
      phi = Math.max(phi - STEP, TOP);
      mv.cameraOrbit = '0deg ' + phi + 'deg auto';
      if (phi <= TOP) { clearInterval(t); setTimeout(onDone, 800); }
    }, TICK);
  }

  function loop() { descend(function() { ascend(loop); }); }

  mv.addEventListener('load', function() {
    mv.cameraOrbit = '0deg ' + TOP + 'deg auto';
    setTimeout(loop, 1200);
  }, { once: true });
})();
</script>
''';
