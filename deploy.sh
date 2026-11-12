#!/bin/bash

# PDF Editor Pro - Firebase Deployment Script

echo "🚀 PDF Editor Pro - Firebase Deployment"
echo "========================================"
echo "Project: pdfmanager-afd92"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found!"
    echo "Install it with: npm install -g firebase-tools"
    exit 1
fi

echo "📦 Step 1: Cleaning previous build..."
flutter clean

echo ""
echo "📥 Step 2: Getting dependencies..."
flutter pub get

echo ""
echo "🔨 Step 3: Building for web (release mode)..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "✅ Build successful!"
echo ""
echo "🌐 Step 4: Deploying to Firebase..."
firebase deploy --only hosting --project pdfmanager-afd92

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment successful!"
    echo ""
    echo "🎉 Your PDF Editor is now live!"
    echo "📍 URL: https://pdfmanager-afd92.web.app"
    echo "📍 Alt URL: https://pdfmanager-afd92.firebaseapp.com"
    echo ""
else
    echo ""
    echo "❌ Deployment failed!"
    echo "Check the error messages above"
    exit 1
fi
