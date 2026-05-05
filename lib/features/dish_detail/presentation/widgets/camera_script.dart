/// Script JS inyectado en model-viewer para la animación de cámara en espiral.
///
/// Ciclo:
///  1. Descenso suave desde cenital (phi 10°) a horizontal (phi 75°) — ~10 s
///  2. Rotación horizontal durante 20 s
///  3. Ascenso suave de vuelta a cenital — ~10 s
///  4. Pausa breve y repetición indefinida
///
/// Interacción: si el usuario toca el modelo, la animación se pausa.
/// Al soltar, se reanuda automáticamente tras 2 s.
const String modelViewerCameraScript = '''
<script>
(function() {
  var mv = document.querySelector('model-viewer');
  if (!mv) return;

  var STEP  = 0.65;
  var TICK  = 100;
  var TOP   = 10;
  var BOT   = 75;
  var HOLD  = 20000;

  var activeTimer = null;
  var resumeTimer = null;
  var paused      = false;

  function clearActive() {
    if (activeTimer !== null) { clearInterval(activeTimer); clearTimeout(activeTimer); activeTimer = null; }
    if (resumeTimer !== null) { clearTimeout(resumeTimer); resumeTimer = null; }
  }

  function descend(onDone) {
    var phi = TOP;
    mv.cameraOrbit = '0deg ' + phi + 'deg auto';
    activeTimer = setInterval(function() {
      phi = Math.min(phi + STEP, BOT);
      mv.cameraOrbit = '0deg ' + phi + 'deg auto';
      if (phi >= BOT) {
        clearInterval(activeTimer);
        activeTimer = setTimeout(onDone, HOLD);
      }
    }, TICK);
  }

  function ascend(onDone) {
    var phi = BOT;
    activeTimer = setInterval(function() {
      phi = Math.max(phi - STEP, TOP);
      mv.cameraOrbit = '0deg ' + phi + 'deg auto';
      if (phi <= TOP) {
        clearInterval(activeTimer);
        activeTimer = setTimeout(onDone, 800);
      }
    }, TICK);
  }

  function loop() { descend(function() { ascend(loop); }); }

  mv.addEventListener('load', function() {
    mv.cameraOrbit = '0deg ' + TOP + 'deg auto';
    activeTimer = setTimeout(loop, 1200);
  }, { once: true });

  // ── Pausa al tocar ──────────────────────────────────────────────────────
  mv.addEventListener('pointerdown', function() {
    if (paused) return;
    paused = true;
    clearActive();
  });

  // ── Reanuda 2 s después de soltar ──────────────────────────────────────
  function handleRelease() {
    if (!paused) return;
    clearActive();
    resumeTimer = setTimeout(function() {
      paused = false;
      loop();
    }, 2000);
  }

  mv.addEventListener('pointerup',     handleRelease);
  mv.addEventListener('pointercancel', handleRelease);
})();
</script>
''';
