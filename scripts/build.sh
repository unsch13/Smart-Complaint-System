#!/bin/bash
set -e

echo "🚀 Starting Flutter web build for Vercel..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
  echo "📦 Flutter not found, installing..."
  bash scripts/install-flutter.sh
fi

# Add Flutter to PATH
export PATH="$HOME/flutter/bin:$PATH"

# Verify Flutter
flutter --version

# Get Flutter dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Inject environment variables
echo "🔧 Injecting environment variables..."
node scripts/inject-env.js

# Build Flutter web app
echo "🔨 Building Flutter web app..."
flutter build web --release --web-renderer canvaskit

echo "✅ Build completed successfully!"
echo "📁 Output directory: build/web"

