#!/bin/bash
set -e

echo "🚀 Installing Flutter for Vercel build..."

# Flutter version to install
FLUTTER_VERSION="3.35.6"
FLUTTER_SDK_PATH="$HOME/flutter"

# Check if Flutter is already installed
if [ -d "$FLUTTER_SDK_PATH" ]; then
  echo "✓ Flutter already installed"
else
  echo "📦 Downloading Flutter SDK..."
  
  # Download Flutter SDK
  cd $HOME
  wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -O flutter.tar.xz
  
  echo "📦 Extracting Flutter SDK..."
  tar xf flutter.tar.xz
  
  # Clean up
  rm flutter.tar.xz
fi

# Add Flutter to PATH
export PATH="$FLUTTER_SDK_PATH/bin:$PATH"

# Verify Flutter installation
flutter --version

# Accept Flutter licenses
yes | flutter doctor --android-licenses || true

echo "✅ Flutter installation complete!"

