# Preview26 — touch lifecycle and daylight glass

2026-09-24. Source: work/realm-room-preview10-20260922/godot.

Root main._input forwards touch releases to room_view.finish_touch deferred, including releases over controls outside SubViewport. Idempotent cleanup retains multi-touch suppression until all contacts lifted. Focus loss/paused cancels room gesture. Ignore compatibility mouse events while real touches active and native magnify while touch pinch processing active.

window_pane glass strength now 0.22 - 0.07 * night + 0.02 * lamps. Shader lifts original reflection RGB 45% toward white, still masks exclusively by original alpha. No new full-pane bloom.

Validation: work/test26clean.py, 12 suites all pass in fresh isolated runtime. test_touch26.gd covers actual furniture coordinate change with unchanged zoom, blank pan, release outside room through main, pinch, remaining finger suppression, focus cancellation. Browser material25 on local Preview26 passes JPG upload + CDP pinch + apply + backup inspection (scale 1.421), no errors. Re-running test_material_controls on reused saves can fail due to leftover decoration draft; clean isolated run passed. Physical iOS not tested. Browser screenshots in work/preview26-release.

Build work/build_preview26.py; 110 patch files; changed main.gdc, room_view.gdc, window_pane.gdc, window_glass.gdshader. Preserves Preview25 features and user data. Runtime realm-room-preview26-touch-glass.
