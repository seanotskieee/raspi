#!/bin/bash

# Move to the directory of the script
cd "$(dirname "$0")"

echo "[🔄] Activating virtual environment..."

# Create venv if it does not exist
if [ ! -d "venv" ]; then
    echo "[🆕] Creating virtual environment..."
    python3 -m venv venv
fi

# Activate venv (Linux path)
source venv/bin/activate

echo "[📦] Checking required packages..."

# Install packages that are missing
while IFS= read -r pkg || [ -n "$pkg" ]; do
    if ! pip show "$pkg" >/dev/null 2>&1; then
        echo "[⬇️] Installing missing package: $pkg"
        pip install "$pkg"
    else
        echo "[✅] Already installed: $pkg"
    fi
done < requirements.txt

echo "[🚀] Launching TREON..."
python3 app.py
