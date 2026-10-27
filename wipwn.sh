#!/data/data/com.termux/files/usr/bin/bash
# Run wipwn from Termux. Uses su because Termux does not ship sudo by default.
set -u
cd "$(dirname "$0")" || exit 1

PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
TERMUX_HOME="${HOME:-/data/data/com.termux/files/home}"
if [ "$TERMUX_HOME" = "/" ] || [ ! -d "$TERMUX_HOME" ]; then
    TERMUX_HOME="/data/data/com.termux/files/home"
fi
TMPDIR="$PREFIX/tmp"
mkdir -p "$TMPDIR" 2>/dev/null || true

PY="$PREFIX/bin/python"
if [ ! -x "$PY" ]; then
    PY="$(command -v python3 || command -v python)"
fi

if [ -z "${PY:-}" ]; then
    echo "python not found. Run: pkg install python -y"
    exit 1
fi

export HOME="$TERMUX_HOME"
export TMPDIR
export PATH="$PREFIX/bin:$PATH"

if [ "$(id -u)" = "0" ]; then
    exec "$PY" main_clean.py -i wlan0 -K
fi

# su starts a fresh environment; pass Termux's HOME, TMPDIR and PATH explicitly.
exec su -c "export HOME='$TERMUX_HOME'; export TMPDIR='$TMPDIR'; export PATH='$PREFIX/bin:\$PATH'; cd '$PWD' && '$PY' main_clean.py -i wlan0 -K"
