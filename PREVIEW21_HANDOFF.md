# Preview21 — camera, lighting editing, physical layer controls

Source: work/realm-room-preview10-20260922/godot. Build with work/build_preview21.py; deploy patches use the existing GitHub workflow. Runtime realm-room-preview21-editor.

- Opening/closing console workbench and function panels preserves camera position and zoom. Explicit panorama still resets it. Room replacement still configures a fresh camera.
- Light dock adds large −/+ camera buttons; mouse wheel/pinch also work. Blank pointer pans without changing selection or dismissing light editing. Handles still edit the light; only explicit finish/cancel ends editing.
- World-space light buffers no longer invalidate for camera transforms. Light candidate culling uses the room bounds, preventing zoom from changing which lights remain active. Existing budgets retained.
- Cache used alpha bounds for perspective wall/floor images by texture identity; clear on room configure. Avoid repeated GPU image readback/alpha scans during redraw. Cache preview toolbar theme until light/dark mode changes. Do not skip all console updates: initial deferred polishing requires refresh.
- Decoration selected-item row adds 遮挡层. Instance render_layer overrides asset default with -1,0,1,2. Same-mount surfaces use this order, wall/floor categories and rug exclusions remain. No physical/collision coordinates change. Default archive curtain is front layer; builtin definitions revision4. Current-room preview/cancel and snapshots preserve the setting.
- tests/test_editor_camera_layers.gd verifies retained zoom/center, layer override+normalization, persistent light dock and camera-only lighting cache. Existing lighting, projection and 20-route function-page tests pass. Browser capture_editor21.cjs checks phone layout; two independent contexts via verify_preview21.cjs. Real mobile performance/pinch still requires device validation; do not promise a measured FPS improvement.

User instructions: select curtain → 装修 → 遮挡层 → 前层; wall trim 自动 or 下层. Layer controls affect same-mount visual ordering, not floor collision. Complex image interleaving still requires splitting artwork.
