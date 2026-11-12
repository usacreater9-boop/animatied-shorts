---
name: cartoon-3d-short
description: Make a ~55-70 s vertical cartoon story short in the "2D characters in a colourful 3D world" style (flat bean-head cartoon cards with ink outlines, painted 3D town/world with black ink lines, saturated sky, depth-of-field backgrounds, gliding cameras, voice narration, synthesized SFX + march-style music), rendered with three.js inside Remotion. Proven on "The Bridge That Fell for a Song" (2026-10-31). Use when the user asks for another video "like the bridge video", "like the soldiers/bridge short", "in that cartoon 3D style", a history/science story short with cartoon characters in 3D, or says "use the cartoon short skill".
---

# Cartoon 3D story short (three.js + Remotion)

Proven example: **The Bridge That Fell for a Song**. It is an original 67 s short about the 1831 Broughton bridge
and 74 soldiers marching in step.
- Code: `src/videos/bridge/` of your Remotion project (composition `BridgeShort`, **1080×1920**, 30 fps).
- Script, voice and sound: `~/bridge-short/`.
- Style research: `references/`.

The style reference is a channel studied privately (`references/`: STYLE_BIBLE.md, reports/*.md, frames/).
- Those videos are private study material. Never upload, publish or send them.
- Never copy their scripts, characters or shots. Story, characters and voice are always OUR OWN.
- Never say the channel's name in a voice-over or description.

User rules that apply:
- No captions or labels in the video.
- English only.
- Voice: one steady tone.
- Jokes are researched real facts.
- Standard mix: music +3 dB, SFX -6 dB, voice unchanged.
- **Final export 1080p vertical: 1080×1920, `--scale 1.0`.**
- Opus max verifies every check.
- Save after every step.
- "Just do it" once the script is approved.

---

## Setup (run once — no approval needed, fully automatic)

Before writing any code, run setup.sh to install every dependency automatically:

```bash
bash setup.sh /path/to/your/remotion-project
```

This installs without prompting:
- npm: remotion@4.0.290, @remotion/three, @remotion/renderer, @remotion/bundler, @remotion/cli, @react-three/fiber@9.1.2, @react-three/postprocessing@3.0.4, postprocessing@6.37.2, three@0.175.0, react@18.3.1, typescript@5.4.5
- Python: numpy, Pillow, scipy (via pip, no approval)
- ffmpeg: checks presence and prints install link if missing

**If any package is missing at render time, install it immediately without asking.** The correct command pattern is:
```bash
# npm (in the Remotion project folder)
npm install --save-exact --no-fund --no-audit <package>@<version>
# Python
pip install --quiet <package>
```

---

## THE GOLDEN RULE — read this before every step

> **Copy `templates/bridge/` to `src/videos/<n>/`. Change only the story. Never redesign the world, characters, or look.**

Every new short starts as an EXACT copy of the bridge template. The bridge short is the proven, verified, finished product — its world geometry, character drawing system, ink pass, lens blur, colour grade, camera grammar, and character proportions are all locked. You are replacing the story inside a finished shell, not designing a new animation from scratch.

**What you change per new short:**
- `story.ts` — shot list, timeline, camera positions, physics (all story-specific)
- `cast.ts` — character roles, outfits, crowd behaviour (use the existing `Pen`/`toon.ts` system)
- `build.ts` — layout of props and buildings (keep the same painting + Kenney kit system)
- `world.ts` — scene-specific set dressing (keep the same sky/fog/river/light system)
- Script, voice, audio

**What you NEVER change or replace:**
- `toon.ts` — the character drawing API (bean heads, Pen system, proportions). Do not rewrite it.
- `ink.ts` — the ink pass. Do not modify the shader or thresholds.
- `lensblur.ts` — the DOF system. Do not replace it.
- `grade.ts` — the colour grade. Do not change the values.
- `Bridge.tsx` — the composer chain (ink → lens → bloom → tone → grade). Do not reorder.
- `paint.ts` — the texture painting system. Do not replace textures with images.
- `lights.ts` — the light presets (day / golden). Do not invent new lighting modes.
- `shade.ts` — the two-tone shading. Do not remove or replace it.
- `cardshade.ts` — card lighting. Do not remove it.

**If you find yourself writing new shaders, new character drawing code, a new world architecture, or new post-processing — STOP. You are off-track. Delete what you wrote. Go back to copying the bridge template.**

---

---

## Analyzing your own reference videos (optional but recommended)

Drop 15-20 of your own reference videos into a folder and run one command. The script measures every video automatically — no approval needed — and writes a structured report you use when building the new short.

```bash
python scripts/analyze_refs.py /path/to/your/refs/ out/my_refs/
```

### What it measures per video

| Measurement | What it tells you | Maps to |
|---|---|---|
| **Luma mean / p2 / p98** | Overall brightness and contrast range | `grade.ts` — exposure, crush |
| **Saturation** | How vivid or muted the colour palette is | `grade.ts` — saturation multiplier |
| **Shot type** (ECU/CU, MS/MWS, Wide/EWS) | How close the camera sits to the subject | `story.ts` → `CAMS` fov + position |
| **Time of day** (day / golden / overcast) | Lighting mood across the video | `story.ts` → `SHOTS` light field, `lights.ts` palette |
| **Key light direction** (left-key / right-key) | Which side the main light hits from | `lights.ts` sun azimuth |
| **Dutch tilt** (level / dutch) | How often the camera rolls for drama | `story.ts` → `CAMS` roll values |
| **High-motion %** | How much of the video is action vs holds | `story.ts` — ratio of glide shots to static push-ins |
| **Static/held %** | How often the camera barely moves | `story.ts` — push-in speed during holds |
| **Dominant colours** (top 8 hex) | The palette of the whole short | `paint.ts` albedos, `lights.ts` LOOK sky/fog/shadow |

### Outputs

For each video the script writes:
- `<name>_sheet.jpg` — contact sheet, one thumbnail every 2 s, timestamp burned in
- `<name>_palette.jpg` — the 8 dominant colours as a colour strip

Plus one global `report.md` with a per-video table and aggregate stats across all videos.

### How to use the report when building a new short

After running the analysis, read `out/my_refs/report.md` before writing `story.ts` and `lights.ts`. Specifically:

1. **Luma mean** → set the exposure lift in `grade.ts` `GRADES.day` to match.
2. **Saturation** → adjust the saturation multiplier in `grade.ts` to match.
3. **Shot type distribution** → if 60 % of your refs are `MS/MWS`, use a tighter fov (40-50°) and closer camera positions in `CAMS`.
4. **Time-of-day split** → set the proportion of `light: 'day'` vs `light: 'golden'` shots in `SHOTS` to match your refs.
5. **Key light direction** → if your refs are mostly `left-key`, set `lights.ts` day azimuth to 75-105° (sun from camera-left).
6. **Dutch tilt %** → if > 20 % of your ref frames are dutch, add 4-8° roll keys on impact beats in `CAMS`.
7. **Top colours** → use the dominant hex values as the starting point for the LOOK palette in `lights.ts` (sky top, sky horizon, fog) and the albedo palette in `paint.ts`.
8. **High-motion %** → if > 40 %, add more glide keys and reduce hold lengths; if < 15 %, favour long slow push-ins.

### Dependencies (auto-installed by the script)

- ffmpeg + ffprobe in PATH (required — install from https://ffmpeg.org/download.html if missing)
- Python: numpy, Pillow — installed automatically on first run via pip, no approval needed

---

## Pipeline

1. **Topic and facts.** Pick one surprising true story with a physical cause and effect (it should be visual), plus a simple everyday analogy that explains it.
   - Write the facts with their source at the top of `SCRIPT.md`.
2. **Script** (~3.7 words/s, 55-70 s). Beat formula from the bridge short:
   - **Hook:** the absurd fact in one line ("Seventy-four soldiers knocked down an iron bridge just by walking across it.").
   - **Setting:** year, place, pride.
   - **Action:** escalation over three or four beats, each a little bigger.
   - **Snap:** the moment it breaks.
   - **Deadpan double line:** "Luckily ... / Unluckily ...".
   - **Explanation:** one physics idea through an everyday analogy (the kid on a swing).
   - **Consequence:** the rule it created.
   - **Callback twist:** the ending.
   - Never describe on screen what the viewer already sees.
3. **Voice.** Record or generate `voice.wav`, then make its word timings `words.json` (any speech-to-text with word times).
   - Put them in the project folder, e.g. `~/bridge-short/voice/`.
   - Hand-fix the word timings. Everything is timed to words.json.
4. **Copy the bridge template.**
   ```bash
   cp -r templates/bridge/ src/videos/<n>/
   ```
   Register a new composition next to `BridgeShort` in `src/Root.tsx` and rename it.
   Then edit only `story.ts`, `cast.ts`, `build.ts`, `world.ts` for your new story.
   **Do not touch any other file unless fixing a TypeScript error.**
5. **Shot plan** in `story.ts`: replace the bridge shot data with your story's shots.
   - `SHOTS`: id, a/b frames, light day/golden, crowd mode, `tau` story time.
   - `XFADE`: crossfades at place/time changes.
   - `FLASH_AT`: a white flash after the hook.
   - `CAMS`: per-shot keys `{f, dur?, cut?, s: f => {pos, look, fov, roll}}`.
   - `KICKS`: impact flip-shakes.
   - `DOF`/`dofAt`: lens blur per beat.
   - `FOREGROUND`: near framing props.
   - Every visual reaction lands 0-3 frames before its word.
6. **World.**
   - `lights.ts`: only change the LOOK palette if your story has a different sky colour mood; keep the same LIGHTS structure.
   - `shade.ts`: no changes unless your story has a night scene (use the same `untone()` system).
   - `build.ts`: replace town / bridge geometry with your story's set; keep the `boxGeo`, `lam`, Kenney CC0 kit and canvas texture system unchanged.
   - `paint.ts`: add new painted textures using the same Canvas2D `Pen` approach; never swap to image files.
   - `world.ts`: replace bridge/river geometry with your story's props; keep sky shader, fog, per-frame posing, sun system unchanged.
7. **Characters.**
   - `toon.ts`: **do not modify**. Use the existing `Pen` drawing API and bean-head/stick-limb system. Add new outfits using the existing `Outfit` type and drawing functions only if the existing ones do not cover your cast.
   - `cast.ts`: replace bridge-specific crowd logic with your cast; keep billboards, `Pool`, `Actor`, blinks, walk cycles exactly as-is.
   - `cardshade.ts`: **do not modify**.
8. **Post** (`Bridge.tsx` + `ink.ts` + `lensblur.ts` + `grade.ts`).
   - **Do not modify any of these files.** The composer order is locked: ink → lens pre → lens main → bloom → NEUTRAL tone map → grade (MSAA 4).
   - Every pixel parameter already scales with output height / 1920.
9. **Sound** (`~/bridge-short/audio/`: timeline.py, sfx_gen.py, sfx.py, music.py, instruments.py, dsp.py, mix.py).
   - Event table → synthesized SFX plus an original score ducked under the voice.
   - Output: mix.wav (48 kHz, exact length), stems and cues.md.
   - Lock the picture's time constants before the sound is made. Any later timing change means re-running the sound.
10. **Look checks.** Run `node scripts/bridge-stills.mjs out/<n>/x_ 100,400 0.5`.
    - Set `BRIDGE_ENTRY=src/sandboxes/<n>/index.tsx` to render a sandbox copy.
    - Make side-by-sides against reference frames with `python scripts/sbs_sheet.py out.jpg --ours ... --ref ...`.
    - Send them to an Opus max verifier: 1-3 images, a ≤200-word verdict.
11. **Final render — 1080p.**
    ```bash
    npx remotion render src/index.ts <Comp> out/<n>/video.mp4 --codec h264 --crf 16 --scale 1.0
    ```
    Mux audio with:
    ```bash
    ffmpeg -i out/<n>/video.mp4 -i mix.wav -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 192k out/<n>/final.mp4
    ```
    QA: `python scripts/short_qa.py final.mp4 out/<n>/qa shots.json` checks every frame for black, white, frozen and pop frames, plus loudness and sheets.
    Fix anything it finds, then run a deep Opus audit.
12. **Deliver.** SendUserFile the final mp4, update memory, write notes.

---

## Final look values (bridge after 4 verifier rounds; all in `templates/bridge/`)

Start every new short from `templates/bridge/` (copy to `src/videos/<n>/`): the look lives in these values, the
story lives in story.ts / build.ts layout / cast.ts roles. Opus max scores at the end: colour day 7, golden 5-6,
lighting 5-6, ink 6, textures 5-6, characters 7, depth 6-7, composition 6-7 (from 5/3/4/5/4/7/4/6 at the start).

- **Light presets** (`lights.ts`, sun camera-relative and frozen per shot):
  - day: az 75 / el 48, lit [1.58,1.5,1.33], shade [.30,.29,.36], lift [.05,.06,.11] (cool tint ONLY in shade), sky
    top #3e7fd2 → horizon #b8d0ec, fog = horizon, 25→300 m, uSat 1.08, ~15 % blue haze past 60 m.
  - golden: az 6 / el 7 (backlit low sun), key toward #FFB36B ×1.5, violet-blue shade (facade ≈ #444380), sky
    #ffc47c → #8a6f8a, peach fog only past 50 m, sun disc #ffcf9e + bloom, contact blobs + real card shadows.
- **Albedos** (`paint.ts`/`build.ts`): muted brick / cream / ochre / terracotta houses with plinth, cornice, sills,
  hoods, door step, chimney + pot, heights 7 / 8.4 / 9.8 m; warm grey/beige stone (saturation −35 % from "storybook");
  ochre wood deck C* ~51-58 with near-black seams; iron dark and desaturated. Never lemon, never lavender lit faces.
- **Ink** (`ink.ts`): #030303, 5.1 px near (6 m) → 3.3 px far (90 m) at 1080×1920, creases ×0.8 from 35°, depth
  jumps from 1 %, fog tint 0.3 only far; character cards on layer `NOINK` (they carry their own plum ink).
- **Lens** (`lensblur.ts` + `dofAt` in story.ts): cInf px at 1080: hook/river CU 15-16, close-ups 12-14, MS 10-12,
  park 7, golden sway 5, wides/aerials 0. Focus on the eyes of the front row.
- **Post** (`Bridge.tsx`): ink → lens pre → lens main → bloom (thr 1.0, int .5, 6 levels, radius .6) → NEUTRAL tone
  map → grade; MSAA 4. Film grain exists but is OFF (reference measures no grain; it quadruples the file size).
- **Characters** (`toon.ts`/`cast.ts`/`cardshade.ts`): bean heads h/w .94, plum ink #241726, eyes .26 W apart, no blush,
  14 expressions; adults 3.5 head-heights; walk bob 5 %, lean 1-7°, planted 0.8 m stride; blinks 0.5-2.3 s; tight
  contact shadow ~.5 under the feet + sun-direction tail by day; golden rim inner only (never an offset outer copy).
- **Camera** (`story.ts`): cuts on big jumps, smootherstep glides 18-40 f, every hold creeps (no static hold ≥4 f),
  flip kicks decaying over 7 f on impacts, 4-4.6° rolls, foreground props (`FOREGROUND`) in ~1/3 of shots.

---

## Look targets (measured from the reference; see references/reports/)

- **Ink:**
  - World lines: about 3 px at 1080 wide, near-black #0b0a0c, nearly constant with distance. Silhouettes, depth jumps and normal creases only. No line on wall/floor joins or the horizon. Character cards are never outlined by the world ink.
  - Character ink: dark plum #201628-#2f1d28, thicker on the bottom/shadow side.
- **Colour:**
  - Day median luma ~.57. Non-ink p5 ~.23 (no crushed blacks). Lit chroma C* p90 ~55. Day sky top ~#5e93d9, horizon 1.28x brighter.
  - Golden: peach horizon #ffd08a, violet-blue shadows (never brown), backlit sun.
- **Depth:**
  - DOF on about 1/3 of screen time (CU, MS, inserts), cInf 10-16 px at 1080, focus on the eyes. Establishing and wide shots stay sharp.
  - Fog = horizon colour, 25→420 m day, 20→360 m golden.
  - Bloom only on HDR emissives: threshold 1.0.
- **Camera:**
  - Hard cuts on big jumps. Everything else is a smootherstep glide of 18-40 f, peak ≤ 25 px/f at 720p.
  - Every hold pushes in 0.15-0.35 %/f, with 0.6 %/f on punch words.
  - Rolls of 4-5°.
  - No hand-held float. Impact shakes flip sign every frame and decay over 7 f.
- **Characters:**
  - About 3.5 head-heights tall, legs 1.4 HH.
  - Stick limbs about 0.055 of head width, ink-dot hands.
  - Bean head (h/w ~0.93, narrower chin, pointier crown).
  - No blush or eye highlights. Faces at brightness ~.93.
  - Walk bob 3-7 %, lean 1-7°, planted feet.
  - Blinks every 0.5-2.3 s, lasting 4 f.

---

## Look-match loop (how the bridge look was reached; reuse for any "make it look like X" pass)

1. **Measure the reference first.** One analysis agent per topic (motion, depth, textures, characters, lighting, outlines, grade), each writing numbers, not adjectives, to `references/reports/<topic>.md`. Shared brief: `compare/CONTEXT.md`. Reports are the source of truth for every agent after.
2. **Sandboxes, one owner per file.** Copy the project folder to `src/videos/<n>_{cam,world,mat,char,post}` with entries `src/sandboxes/<n>/index.tsx` (same `index.tsx` as main, only the import path changed). Ownership used for the bridge:
   - cam: story.ts (camera keys, cuts, kicks, DOF table, foreground props)
   - world: world.ts, lights.ts, shade.ts, grade.ts (sun, sky, fog, river, colour, grade)
   - mat: paint.ts, build.ts (painted textures, buildings, props)
   - char: toon.ts, cast.ts, cardshade.ts (character drawing, posing, card lighting, fx cards)
   - post: ink.ts, Bridge.tsx, lensblur.ts (outline pass, composer, lens blur, bloom)
   Agents only edit their own files in their own sandbox and render stills with `BRIDGE_ENTRY=src/sandboxes/<n>/index.tsx node scripts/bridge-stills.mjs out/<n>/<n>/x_ <frames> 0.5`
3. **Merge** with `python scripts/bridge_merge.py [cam,world,mat,char,post]` (backs main up to `backup/bridge_<time>/`, copies owned files only). Then `npx tsc --noEmit` (filter to the project folder), then **re-sync every sandbox from main** (`cp -f src/videos/<n>/* src/videos/<n>_<n>/`) before the next round.
4. **Verify** with a fresh Opus max agent: side-by-side sheets (`python scripts/sbs_sheet.py out.jpg --ours a b --ref r1 r2`), score each area out of 10 (colour day / golden, lighting, ink, textures, characters, depth, composition) plus a numbered fix list with frame numbers. Map each fix to the file owner and resume that owner's agent with SendMessage (keeps its context). Bridge scores: round 1 5/3/4/5/4/7/4/6 → round 2 5/4/5/6/4/7/6/6 → round 3 see notes.
5. Contracts between owners live in exported constants (e.g. `NOINK` layer from ink.ts, `dofAt`/`FOREGROUND` from story.ts, `LIGHTS`/`LOOK` from lights.ts). Changing a contract means telling every owner that reads it.

---

## Gotchas

- Kenney nature-kit materials are teal: recolour them by material name in build.ts.
- Cameras end up inside houses: the sight-line culler in build.ts/world.ts removes anything blocking any camera ray.
- Ink in the same merged effect pass as DOF gets overwritten. Ink must be its own pass before the blur.
- **Pixel-sized post parameters must scale with resolution: stills are at 0.5 (`--scale 0.5`), the final at 1.0 (`--scale 1.0`).**
- R3F clamps dpr to ≥ 1, so `--scale 0.5` stills still render a 1080×1920 buffer.
- **Disk:** every Remotion bundle copies `public/` (~1.3 GB) into the temp folder. Always render with
  `export REMOTION_TMP='<big drive>/remotion-tmp'` (bridge-stills.mjs sets it itself).
- In JS strings write `"<big drive>/remotion-tmp"`, never `"<big drive>\remotion-tmp"` (`\r` becomes a carriage return).
- Remotion writes a silent audio track: mux with `-map 0:v:0 -map 1:a:0`.
- Sub-agents can't write report files in this harness: ask them for a ≤150-word final message and save it yourself to `out/<n>/<n>/REPORT.md`.
- Scratch `.ts` files inside `out/` break `tsc`: name them `.txt`.
- **1080p renders run ~6-8 fps (≈3-4 min for 67 s).** Stills at 0.5 take 3-8 s each after a ~40 s bundle.
- Film grain at 2.5 % quadruples the file size; the reference has none. Keep it off.

---

## Readability traps the verifier caught (check every new prop/shot for these)

- **A swing drawn as one rope that disappears behind the kid reads as a HANGING.** Always two ropes to a wide plank with the kid between them (`swingKid` in toon.ts), and a frame whose legs clear the arc (A-frame at each end).
- Props or flotsam closer than ~2 m to a lens become huge cut-off blobs at the frame edge. When a camera moves, re-check every prop near its new position (the river cameras moved into the floating hats).
- A foreground bush cut by the frame edge reads as a "green ball"; a foreground prop must be recognisable or gone.
- Flags: red + yellow star/diamond reads as Vietnam's. Use a period-correct flag (St George's cross for England 1831).
- Painted signs lit by a side sun go grey-blue and unreadable: give the sign face an unlit material.
- Golden rim light done as an offset outer copy turns every hat into a picture frame: inner rim only, head/torso only.
- Balcony/railing rails at chest height through characters: put the lens ~2.5 m up so rails cross legs, not torsos.
- Flat holds read as freezes in QA (frozen span ≥12 f): every hold needs a creeping push-in.
