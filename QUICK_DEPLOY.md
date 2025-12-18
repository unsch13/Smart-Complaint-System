# Quick Vercel Deployment Guide

## 🚀 Deploy in 5 Minutes

### Step 1: Enable Flutter Web
```bash
flutter config --enable-web
```

### Step 2: Push to GitHub
```bash
git add .
git commit -m "Ready for Vercel"
git push
```

### Step 3: Deploy on Vercel

1. Go to [vercel.com/new](https://vercel.com/new)
2. Import your GitHub repository
3. Configure:
   - **Framework Preset**: Other
   - **Build Command**: `npm run build:vercel`
   - **Output Directory**: `build/web`
   - **Install Command**: `npm install && flutter pub get`

4. Add Environment Variables:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_KEY`

5. Click **Deploy**

### Step 4: Update Supabase CORS
Add your Vercel URL to Supabase CORS settings:
- `https://your-project.vercel.app`

## ✅ Done!

Your app is now live and accessible from mobile browsers!

**Note**: This deploys the web version. For native mobile apps, build APK/IPA separately.

