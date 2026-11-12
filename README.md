# Claude Animated Shorts

The free Claude skill from the video **"How to Make Viral Animated Shorts Using Claude (Full Workflow)"**.

It makes 55-70 s vertical animated story shorts: 2D characters in a colourful 3D world, with ink outlines, a painted town, lens blur, gliding cameras, a march score and sound effects. Everything is rendered with three.js inside Remotion on your own PC, with no AI video generator.

Proven on **The Bridge That Fell for a Song**, a 67 s short about the 1831 Broughton bridge.

## Quick start

```bash
# 1. Install all dependencies automatically (no approval needed)
bash setup.sh /path/to/your/remotion-project

# 2. Copy this skill folder to Claude Code's skills directory
cp -r . ~/.claude/skills/cartoon-3d-short/

# 3. In Claude Code, say:
#    "Use the cartoon short skill and make a short about …"
```

## What's inside

| Path | What it is |
|---|---|
| `SKILL.md` | The skill: full pipeline, every rule, the golden rule (copy the template!), and the final look values |
| `setup.sh` | Auto-installs all npm + Python deps without asking for approval |
| `templates/bridge/` | The full source of the bridge short: world, characters, ink, lens blur, grade, story/camera |
| `templates/audio/` | The synthesized sound: SFX, march music, the mix with ducking and loudness |
| `templates/scripts/` | Stills, side-by-side sheets, shot merge and frame-by-frame QA helpers |
| `references/STYLE_BIBLE.md` | The script and visual formula measured from 20 reference shorts |
| `references/reports/` | Seven measured reports: motion, depth, textures, characters, lighting, outlines, grade |
| `references/frames/` | 38 full-size reference frames (540x960) to compare your frames against |
| `references/sheets/` | 20 contact sheets, one per reference short, 60 frames each (1,200 frames) |

## Output resolution

**1080p vertical: 1080×1920** (`--scale 1.0`). This is the correct setting — do not use `--scale 1.3333`.

## The golden rule (for Claude / Muse / Tab)

> Copy `templates/bridge/` to `src/videos/<n>/`. Change only the story. Never redesign the world, characters, or look.

The bridge template is the finished, verified visual product. Only `story.ts`, `cast.ts`, `build.ts`, and `world.ts` change per new short. Every other file (`toon.ts`, `ink.ts`, `lensblur.ts`, `grade.ts`, `Bridge.tsx`, `paint.ts`, `lights.ts`, `shade.ts`, `cardshade.ts`) stays exactly as-is.

## Notes

- Set `REMOTION_TMP` to a folder on a big drive. Every Remotion bundle copies `public/` (~1.3 GB) into the temp folder.
- Story, characters and voice should always be your own. Use the references for the look, not the content.

## License

The code and docs are MIT (see `LICENSE`). The reference frames are included for style study only.
