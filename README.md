# Realm Room Web

Play: https://karukichiyo.github.io/-realm-room-web-preview/

Current build: preview9 (2026-09-20). GitHub Actions verifies release.json checksums, preserves the Web archive in a GitHub Release, and deploys to Pages. Re-run the workflow to redeploy the preserved release.

Accounts and multiplayer connect to the API origin recorded in release.json. That temporary backend requires the host computer and tunnel to remain online. No account database or user saves are included in this repository or release.

Future updates: build and test the Godot Web export, prepare a versioned Web archive with REALM_ROOM_API_ORIGIN configured, and update release.json. The old repository_dispatch publishing path is retired to prevent stale builds overwriting this release.
