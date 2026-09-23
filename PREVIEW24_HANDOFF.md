# Preview24: explicit furniture order and glass highlights

Source: work/realm-room-preview10-20260922/godot
Runtime: realm-room-preview24-layers

Root cause: wall-vs-floor ordering returned before manual render_layer was checked, and unambiguous physical ground relations also overrode manually chosen floor layers. The old graph resolved cycles by picking a default item, silently discarding intended ordering. Glass previously received both the dark exterior exposure and low opacity, suppressing authored highlight marks.

Occlusion changes:
- occlusion_rules.gd contains explicit pair relations (draw_before / draw_after), cycle validation and clearing.
- Instance render_layer now takes precedence over automatic furniture placement, including cross-mount curtain/column pairs. Asset defaults remain automatic tie hints.
- Specific pair rules outrank broad layer choices. Internal sprite layer order is highest priority. Constraints are inserted strongest first; weaker automatic edges that create a cycle are omitted.
- Grounds/rugs remain below furniture and actors. Windows remain on their dedicated wall surface and cannot be manually moved into the furniture group; the UI explains their fixed scene/weather/glass/frame order.
- UI offers automatic/back/front/foremost and a searchable thumbnail target picker. It displays the actual named relation and highlights the selected action. Automatic clears relations involving the selected item. Explicit contradictory cycles are rejected without mutation.
- Decoration preview still requires Confirm Decoration to persist; cancel and undo retain their existing semantics.
- window_surface reuses the parent frame painter list to avoid a second graph sort.

Glass:
- window_glass.gdshader uses restrained additive highlights only where the uploaded glass artwork has alpha.
- Reflectance is independent of exterior exposure. Strength ranges 0.09 to 0.19 with night and artificial master brightness, retaining the original reflection shapes and subtly mixing cool/warm tint.
- No full-pane bloom, blur, synthetic mirror reflection or asset replacement.

Validation:
test_occlusion_glass24, test_compound_occlusion, test_editor_camera_layers, test_rug_navigation_ui, test_window_atmosphere passed. New tests check the actual final painter order across wall/floor mounts, legacy layer values, explicit pair rules, cycle rejection, clearing, normalization persistence, and UI active state.
Native GPU captures compare day and night with/without glass. Mobile 450x800 WebGL UI tested via real clicks: decoration > room furniture search 13 (curtain) > occlusion > target search 06 (gray column) > in front. Screenshot shows the named relationship, real reordered curtain edge, and unchanged camera.
Native 15-object showcase painter benchmark approximately 2ms on local GPU machine CPU; this is not a mobile performance measurement.

Build: work/build_preview24.py
Local preview: work/prepare_local24.py, HTTP port 8784
Verify browser: work/verify_layers24.cjs URL
Verify public PCK: work/verify_release24.py (104 patch files)
