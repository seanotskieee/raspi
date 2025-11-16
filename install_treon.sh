#!/bin/bash

set -e

echo "=== 🛠 Updating system ==="
sudo apt update

echo "=== 📦 Installing build dependencies for Python ==="
sudo apt install -y \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev \
  git \
  curl

echo "=== 📷 Installing OpenCV for ARM ==="
sudo apt install -y python3-opencv

echo "=== 📥 Installing pyenv ==="
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
else
    echo "pyenv already installed."
fi

# Add pyenv to PATH for this script
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

echo "=== 🐍 Installing Python 3.11 via pyenv ==="
if ! pyenv versions | grep -q "3.11"; then
    pyenv install 3.11.9
else
    echo "Python 3.11 already installed in pyenv."
fi

echo "=== 🎁 Creating virtual environment ==="
if ! pyenv versions | grep -q "treon-env"; then
    pyenv virtualenv 3.11.9 treon-env
else
    echo "treon-env already exists."
fi

echo "=== 🚀 Activating environment ==="
pyenv activate treon-env

echo "=== 📦 Installing Python dependencies ==="

cat > requirements_fixed.txt <<EOF
flask
numpy
mediapipe==0.10.20
firebase-admin
protobuf==4.25.3
grpcio-status<1.60.0
pytz==2024.1
torch
torchvision
pillow
huggingface-hub
requests
EOF

pip install --upgrade pip
pip install -r requirements_fixed.txt

echo "=== 📝 Creating run.sh ==="

cat > run.sh << 'EOF'
#!/bin/bash
cd "$(dirname "$0")"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv activate treon-env

python app.py
EOF

chmod +x run.sh

echo "=== ✅ Installation complete! ==="
echo "Run your app with:"
echo "   ./run.sh"
