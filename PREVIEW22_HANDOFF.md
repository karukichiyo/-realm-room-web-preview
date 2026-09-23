# Preview22: compound sofa contact and light targeting

Source: work/realm-room-preview10-20260922/godot
Build: work/build_preview22.py
Runtime: realm-room-preview22-occlusion
Date: 2026-09-24

## Root cause
Previous collision rectangles were used for navigation and placement, but actor occlusion and furniture sorting still used the whole sprite-derived footprint. Previous sofa contact rectangles also did not align with the long seat, chaise and attached footstool. The blanket is artwork, not a solid obstacle.

## Changes
room_view uses compound contact rectangles for projected front-edge tests and pairwise furniture ordering. Clear physical separation takes priority over manual visual layers for floor furniture. Wall layers still support curtains in front of trim. Floor boundary checks use actual contact rectangles, including negative offsets relative to legacy anchors.

The calibrated sofa uses world contact regions (2.5,4,6.9,2.1), (5.9,6.1,3.5,1.05), (9.4,4.05,2.5,2.35) in the original 16x18 showcase. These are stored relative to original origin (5.027027,4.297297). Audit: work/sofa-contact-audit22.png. room_data.normalize_asset contact_revision 2 migrates the exact archive sofa source and its resized copies based on display width. Artwork, anchors and instance positions remain unchanged.

Light menu includes a searchable two-column furniture picker with cropped thumbnails, instance numbers and light counts. All placed furniture can be chosen, even if obscured or currently without lights. Choosing a target preserves camera zoom. The light dock switch-target control saves edits before opening the picker; failed saves retain the editor. console_home light flow indices were corrected to keep the budget label alive.

## Validation
test_compound_occlusion checks three actor positions in front and one behind, complete scene painter order, the original side table, manual layer precedence, all authored placements, legacy resized migration, search and light target switching. Also passed projection_registration, rug_navigation_ui, editor_camera_layers and lighting tests. Mobile-size browser checks cover target search and opening the selected table editor.

## Limits
A composite sprite cannot support every possible interleaving of its internal parts. Arbitrary complex furniture still needs authored contact metadata; deeper per-part interleaving needs layered artwork or depth masks. Do not infer physical geometry solely from transparent image bounds.

## Release
The public repository stores compiled incremental patches over the Preview9 base. Upload changed deploy/gdc files, update release.json, then verify the published PCK against all 94 local patch files with work/verify_release22.py. Keep the local source and tests for subsequent work.
