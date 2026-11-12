#!/usr/bin/env bash
# AUTO-INSTALL — runs without any approval prompt.
# Usage: bash setup.sh [/path/to/remotion-project]
# If a project path is given, also installs npm deps there.
set -e

echo "=== cartoon-3d-short: auto-install ==="

# ── 1. Node / npm check ───────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo "ERROR: Node.js not found. Install Node 18+ from https://nodejs.org and re-run."
  exit 1
fi
NODE_VER=$(node -e "process.stdout.write(process.versions.node)")
echo "Node $NODE_VER"

# ── 2. Python check ───────────────────────────────────────────────────
PYTHON=python3
if ! command -v python3 &>/dev/null; then
  PYTHON=python
fi
if ! command -v $PYTHON &>/dev/null; then
  echo "WARNING: Python 3 not found. Audio scripts will not work."
else
  PY_VER=$($PYTHON --version 2>&1)
  echo "$PY_VER"
  # Install Python deps silently
  $PYTHON -m pip install --quiet --upgrade numpy Pillow scipy 2>&1 | tail -3
  echo "Python deps: numpy, Pillow, scipy — OK"
fi

# ── 3. ffmpeg check ───────────────────────────────────────────────────
if ! command -v ffmpeg &>/dev/null; then
  echo "WARNING: ffmpeg not found. QA and mux steps will not work."
  echo "  Install: https://ffmpeg.org/download.html (add to PATH)"
else
  echo "ffmpeg: $(ffmpeg -version 2>&1 | head -1)"
fi

# ── 4. npm packages in the Remotion project ───────────────────────────
PROJECT=${1:-""}
if [ -n "$PROJECT" ] && [ -d "$PROJECT" ]; then
  echo "Installing npm packages in $PROJECT ..."
  cd "$PROJECT"
  # Core Remotion stack
  npm install --save-exact --no-fund --no-audit \
    remotion@4.0.290 \
    @remotion/three@4.0.290 \
    @remotion/renderer@4.0.290 \
    @remotion/bundler@4.0.290 \
    @remotion/cli@4.0.290 \
    @react-three/fiber@9.1.2 \
    @react-three/postprocessing@3.0.4 \
    postprocessing@6.37.2 \
    three@0.175.0 \
    react@18.3.1 \
    react-dom@18.3.1 \
    typescript@5.4.5 \
    2>&1 | tail -5
  echo "npm packages — OK"
  cd - > /dev/null
else
  echo ""
  echo "TIP: To also install npm packages, run:"
  echo "  bash setup.sh /path/to/your/remotion-project"
fi

# ── 5. REMOTION_TMP reminder ──────────────────────────────────────────
echo ""
echo "IMPORTANT: Set REMOTION_TMP to a folder on a large drive before rendering."
echo "  export REMOTION_TMP=/path/to/big/drive/remotion-tmp"
echo "  (Each bundle copies ~1.3 GB of public/ into the temp folder.)"
echo ""
echo "=== setup complete ==="
