#!/data/data/com.termux/files/usr/bin/bash
# Run wipwn from Termux. Uses su because Termux does not ship sudo by default.
set -u
cd "$(dirname "$0")" || exit 1

PY="${PREFIX:-/data/data/com.termux/files/usr}/bin/python"
if [ ! -x "$PY" ]; then
    PY="$(command -v python3 || command -v python)"
fi

if [ -z "${PY:-}" ]; then
    echo "python not found. Run: pkg install python -y"
    exit 1
fi

if [ "$(id -u)" = "0" ]; then
    export PATH="${PREFIX:-/data/data/com.termux/files/usr}/bin:$PATH"
    exec "$PY" main_clean.py -i wlan0 -K
fi

# su starts a fresh environment; pass Termux's bin directory explicitly.
exec su -c "export PATH='${PREFIX:-/data/data/com.termux/files/usr}/bin:\$PATH'; cd '$PWD' && '$PY' main_clean.py -i wlan0 -K"
