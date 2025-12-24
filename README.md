# PromptPad

A 3×3 mechanical macropad built around a Pro Micro (ATmega32u4) running QMK. This repo includes a QMK keymap, a `keyboard.json` definition, a single-file browser configurator that generates `keymap.c`, and a Windows batch script to auto-apply + compile new keymaps.

## Video Demonstration

Links: 
https://youtube.com/shorts/4B8f0nyeBfY?feature=share
https://youtu.be/FJb8W2D7UVc


![Enclosure CAD render](./assets/enclosure-render.png)
![PCB routing view](./assets/pcb-routing.png)
![3D PCB render](./assets/pcb-3d.png)
![Matrix + diode schematic](./assets/schematic.png)

## What’s in this repo

- **Firmware macros (QMK):** [`keymap.c`](./keymap.c)  
  Implements 9 custom macro keycodes and handles them in `process_record_user()`.
- **Keyboard definition (QMK JSON):** [`keyboard.json`](./keyboard.json)  
  Defines the 3×3 matrix, diode direction, Pro Micro pin mapping, and layout coordinates.
- **Offline configurator (single HTML file):** [`macropad-config-tool.html`](./macropad-config-tool.html)  
  Click keys, choose a macro type, then export a ready-to-compile `keymap.c`.
- **Automation script (Windows):** [`update-keymap.bat`](./update-keymap.bat)  
  Watches your Downloads folder for `keymap.c`, backs up the existing one, copies the new file into your QMK keymap folder, and runs `qmk compile`.

## Default key behavior

The current [`keymap.c`](./keymap.c) ships with a few common macros wired in:

- Key 1: **Ctrl+C**
- Key 2: **Ctrl+V**
- Key 3: **Alt+Tab**
- Key 4: **Ctrl+Shift+Esc**
- Key 5: **Ctrl+A**
- Key 6: **Win+L**
- Keys 7–9: empty placeholders

There’s also a timestamped backup file included: [`keymap_backup_20250829_215935.c`](./keymap_backup_20250829_215935.c).

## Interesting implementation details

### In the browser configurator ([`macropad-config-tool.html`](./macropad-config-tool.html))

- Uses **event delegation + DOM events** via [`addEventListener`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener) to manage key selection and inputs.
- Exports files client-side using [`Blob`](https://developer.mozilla.org/en-US/docs/Web/API/Blob) + [`URL.createObjectURL`](https://developer.mozilla.org/en-US/docs/Web/API/URL/createObjectURL) (no server needed).
- Imports saved configs with [`FileReader`](https://developer.mozilla.org/en-US/docs/Web/API/FileReader) to reload a JSON profile.
- Generates C output with **template literals** (clean string assembly) and escapes quotes safely.
- UI layout is done with **CSS Grid** ([`display: grid`](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout)) and square keys via [`aspect-ratio`](https://developer.mozilla.org/en-US/docs/Web/CSS/aspect-ratio).

### In the QMK keymap ([`keymap.c`](./keymap.c))

- Defines macros as **custom keycodes** starting at [`SAFE_RANGE`](https://docs.qmk.fm/#/custom_quantum_functions?id=safe-range) to avoid collisions with built-in keycodes.
- Implements all macro behavior in [`process_record_user`](https://docs.qmk.fm/#/custom_quantum_functions?id=example-process_record_user) so key handling stays centralized.
- Uses QMK’s string/macro helpers like [`SEND_STRING`](https://docs.qmk.fm/#/feature_macros?id=send_string) and `SS_*` sequences for modifiers and taps.

### In the Windows script ([`update-keymap.bat`](./update-keymap.bat))

- Polls for a downloaded `keymap.c`, then creates a **timestamped backup** before overwriting.
- Runs QMK CLI compilation (`qmk compile`) after copying the new keymap.
- Uses conservative defaults: auto-flash is present but commented out.

## Tech stack and dependencies

- **QMK Firmware + QMK CLI** (required for building): https://qmk.fm/  
  The batch script assumes you have `qmk` on PATH and a local `qmk_firmware` checkout.
- **Browser-only UI** (no build tools, no dependencies): plain HTML/CSS/JS.  
  Fonts are a system stack (`Segoe UI`, `Tahoma`, etc.) — no external web fonts used.

## Project structure

```text
.
├── assets/
├── keymap.c
├── keymap_backup_20250829_215935.c
├── keyboard.json
├── macropad-config-tool.html
└── update-keymap.bat
