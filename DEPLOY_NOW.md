# 🚀 Deploy to Vercel NOW - Step by Step

Your code is now on GitHub: **https://github.com/unsch13/Smart-Complaint-System**

## ✅ Step 1: Go to Vercel

1. **Open**: https://vercel.com/new
2. **Sign in** with your GitHub account (same account as your repo)

## ✅ Step 2: Import Your Repository

1. Click **"Import Git Repository"**
2. Find and select **`unsch13/Smart-Complaint-System`**
3. Click **"Import"**

## ✅ Step 3: Configure Project Settings

Vercel will auto-detect some settings, but verify/update these:

### Framework Preset
- Select **"Other"** or leave blank

### Root Directory
- Leave as **`./`** (default)

### Build Command
```
npm run build:vercel
```

### Output Directory
```
build/web
```

### Install Command
```
npm install && flutter pub get
```

## ✅ Step 4: Add Environment Variables

**IMPORTANT**: Click **"Environment Variables"** and add:

1. **SUPABASE_URL**
   - Value: Your Supabase project URL
   - Add for: Production, Preview, Development

2. **SUPABASE_ANON_KEY**
   - Value: Your Supabase anonymous key
   - Add for: Production, Preview, Development

3. **SUPABASE_SERVICE_KEY**
   - Value: Your Supabase service role key
   - Add for: Production, Preview, Development

4. **SMTP_EMAIL** (Optional)
   - Value: Your email for notifications
   - Add for: Production, Preview, Development

5. **SMTP_PASSWORD** (Optional)
   - Value: Your email password/app password
   - Add for: Production, Preview, Development

**⚠️ Make sure to add each variable for ALL environments (Production, Preview, Development)**

## ✅ Step 5: Deploy!

1. Click the big **"Deploy"** button
2. Wait 5-10 minutes for the build to complete
3. Your app will be live at: `smart-complaint-system.vercel.app` (or similar)

## ✅ Step 6: Update Supabase CORS

After deployment, update Supabase:

1. Go to **Supabase Dashboard** → Your Project
2. **Settings** → **API**
3. Under **"Allowed CORS Origins"**, add:
   ```
   https://smart-complaint-system.vercel.app
   https://*.vercel.app
   ```
4. Click **Save**

## 🎉 Done!

Your Flutter app is now live and accessible from:
- ✅ Desktop browsers
- ✅ Mobile browsers (iOS Safari, Android Chrome)
- ✅ Any device with a web browser

## 📱 Test Your App

1. **Desktop**: Visit your Vercel URL
2. **Mobile**: Open mobile browser and visit the same URL
3. **Add to Home Screen**: 
   - iOS: Safari → Share → Add to Home Screen
   - Android: Chrome → Menu → Add to Home Screen

## 🔄 Future Updates

Every time you push to GitHub:
- Vercel automatically builds and deploys
- New version goes live automatically
- Preview URLs created for pull requests

## 🐛 Troubleshooting

### Build Fails?
- Check build logs in Vercel Dashboard
- Verify environment variables are set
- Make sure Flutter web is enabled

### App Not Working?
- Check Supabase CORS settings
- Verify environment variables are correct
- Check browser console for errors

## 📞 Need Help?

- **Vercel Docs**: https://vercel.com/docs
- **Build Logs**: Check in Vercel Dashboard → Deployments
- **Environment Variables**: Vercel Dashboard → Settings → Environment Variables

---

**Your Repository**: https://github.com/unsch13/Smart-Complaint-System  
**Deploy Now**: https://vercel.com/new

