# Preview27 — wall direction pad

The pad previously passed screen X directly as wall-local u. On left wall increasing u moves left, so arrows were reversed. Added RoomView.move_selected_on_screen and routed pad signals through it. Left wall reverses horizontal u; right wall retains it; vertical arrows remain height changes. Floor/ceiling projection unchanged. No save migration.

Validation: test_direction27.gd emits actual pad signals, verifies projected anchor direction for both walls and all four arrows. Fixture wall height raised to 20 to allow tall curtain movement (initial test correctly refused out-of-bounds placement). Other 12 suites in work/test27final.py passed; direction rerun work/test27direction.py passed. Build work/build_preview27.py, runtime realm-room-preview27-wall-directions. Source work/realm-room-preview10-20260922/godot. Real iOS not tested.
