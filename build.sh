#!/bin/bash
set -e

echo "🚀 Starting Flutter web build for Vercel..."

# Install Flutter dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

# Build Flutter web app
echo "🔨 Building Flutter web app..."
flutter build web --release --web-renderer canvaskit

echo "✅ Build completed successfully!"
echo "📁 Output directory: build/web"

