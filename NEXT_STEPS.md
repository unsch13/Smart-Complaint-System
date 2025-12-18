# 🚀 Next Steps to Deploy on Vercel

## ✅ Step 1: Test Web Build Locally (Optional but Recommended)

Test that your Flutter web app builds correctly:

```bash
flutter build web --release --web-renderer canvaskit
```

This will create a `build/web` folder. If this works, you're ready to deploy!

---

## 📦 Step 2: Prepare Your Code for Git

Make sure all files are committed and pushed to GitHub:

```bash
# Check git status
git status

# Add all files
git add .

# Commit
git commit -m "Add Vercel deployment configuration"

# Push to GitHub
git push origin main
```

**Important**: Make sure your `.env` file is NOT committed (it should be in `.gitignore`)

---

## 🌐 Step 3: Deploy on Vercel

### Option A: Via Vercel Dashboard (Easiest)

1. **Go to Vercel**: https://vercel.com/new
2. **Sign up/Login** with GitHub
3. **Import your repository**:
   - Click "Import Git Repository"
   - Select your `smart_complaint_system` repository
   - Click "Import"

4. **Configure Project Settings**:
   - **Framework Preset**: Select "Other" or leave blank
   - **Root Directory**: `./` (leave as default)
   - **Build Command**: `npm run build:vercel`
   - **Output Directory**: `build/web`
   - **Install Command**: `npm install && flutter pub get`

5. **Add Environment Variables**:
   - Click "Environment Variables"
   - Add each variable:
     ```
     SUPABASE_URL = your_supabase_url_here
     SUPABASE_ANON_KEY = your_anon_key_here
     SUPABASE_SERVICE_KEY = your_service_key_here
     SMTP_EMAIL = your_email (optional)
     SMTP_PASSWORD = your_password (optional)
     ```
   - Make sure to add them for **Production**, **Preview**, and **Development**

6. **Deploy**:
   - Click "Deploy" button
   - Wait for build to complete (5-10 minutes)
   - Your app will be live at `your-project.vercel.app`

### Option B: Via Vercel CLI

```bash
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Deploy (first time - will ask questions)
vercel

# Set environment variables
vercel env add SUPABASE_URL
vercel env add SUPABASE_ANON_KEY
vercel env add SUPABASE_SERVICE_KEY

# Deploy to production
vercel --prod
```

---

## 🔐 Step 4: Update Supabase CORS Settings

After deployment, update your Supabase project:

1. Go to **Supabase Dashboard** → Your Project
2. Navigate to **Settings** → **API**
3. Under **"Allowed CORS Origins"**, add:
   ```
   https://your-project.vercel.app
   https://*.vercel.app
   ```
4. Click **Save**

---

## 📱 Step 5: Test Your Deployed App

1. **Open on Desktop**: Visit `https://your-project.vercel.app`
2. **Open on Mobile**: 
   - Open mobile browser (Safari/Chrome)
   - Visit the same URL
   - Test all features
   - You can add to home screen for app-like experience

---

## 🐛 Troubleshooting

### Build Fails?

**Error: "Flutter not found"**
- Vercel doesn't have Flutter pre-installed
- **Solution**: The build script should handle this, but if it fails, you may need to use GitHub Actions (see VERCEL_DEPLOYMENT.md)

**Error: "Build timeout"**
- Flutter builds take 5-10 minutes
- **Solution**: Wait longer, or upgrade Vercel plan

**Error: "Environment variables not found"**
- Make sure all variables are set in Vercel Dashboard
- Check variable names match exactly (case-sensitive)
- Redeploy after adding variables

### App Not Working?

**CORS Errors**:
- Update Supabase CORS settings (Step 4)
- Check browser console for specific errors

**Supabase Connection Failed**:
- Verify environment variables are correct
- Check Supabase project is active
- Verify CORS settings

---

## ✅ Checklist

Before deploying, make sure:

- [ ] Flutter web is enabled (`flutter config --enable-web`)
- [ ] Code is pushed to GitHub
- [ ] `.env` file is NOT committed (in `.gitignore`)
- [ ] All environment variables are ready
- [ ] Supabase project is set up
- [ ] You have a Vercel account

After deploying:

- [ ] Build completed successfully
- [ ] App is accessible at Vercel URL
- [ ] Supabase CORS updated
- [ ] Tested on desktop browser
- [ ] Tested on mobile browser
- [ ] All features working

---

## 🎉 Success!

Once deployed, your Flutter app will be:
- ✅ Accessible from any device with a web browser
- ✅ Mobile-friendly and responsive
- ✅ Automatically deployed on every push to main branch
- ✅ Available at a custom Vercel URL

**Your app URL will be**: `https://your-project.vercel.app`

---

## 📚 Need More Help?

- **Detailed Guide**: See `VERCEL_DEPLOYMENT.md`
- **Quick Reference**: See `QUICK_DEPLOY.md`
- **Vercel Docs**: https://vercel.com/docs
- **Flutter Web**: https://docs.flutter.dev/platform-integration/web

