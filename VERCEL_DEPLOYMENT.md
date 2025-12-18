# Deploy Flutter Web App to Vercel (Mobile-Accessible)

This guide will help you deploy your Flutter app as a web application on Vercel, which can be accessed from mobile browsers.

## 📱 Important Note

**Vercel deploys web applications, not native mobile apps.** However, your Flutter web app will be:
- ✅ Accessible from mobile browsers (iOS Safari, Android Chrome, etc.)
- ✅ Responsive and mobile-friendly
- ✅ Can be added to home screen (PWA-like experience)
- ✅ Works on all devices with a web browser

For native mobile apps, use:
- **Android**: Google Play Store (build APK/AAB)
- **iOS**: App Store (build IPA)

## 🚀 Quick Start

### Step 1: Enable Flutter Web

```bash
flutter config --enable-web
```

### Step 2: Test Web Build Locally

```bash
flutter build web --release --web-renderer canvaskit
```

This creates a `build/web` directory with your compiled web app.

### Step 3: Push to Git Repository

```bash
git add .
git commit -m "Prepare for Vercel deployment"
git push origin main
```

### Step 4: Deploy to Vercel

#### Option A: Via Vercel Dashboard (Recommended)

1. **Go to [vercel.com/new](https://vercel.com/new)**
2. **Import your Git repository**
3. **Configure Project:**
   - Framework Preset: **Other**
   - Root Directory: `./` (root)
   - Build Command: `npm run build:vercel`
   - Output Directory: `build/web`
   - Install Command: `npm install && flutter pub get`

4. **Add Environment Variables:**
   - Go to Project Settings → Environment Variables
   - Add these variables:
     ```
     SUPABASE_URL=your_supabase_url
     SUPABASE_ANON_KEY=your_anon_key
     SUPABASE_SERVICE_KEY=your_service_key
     SMTP_EMAIL=your_email (optional)
     SMTP_PASSWORD=your_password (optional)
     ```

5. **Deploy!**
   - Click "Deploy"
   - Wait for build to complete
   - Your app will be live at `your-project.vercel.app`

#### Option B: Via Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy
vercel

# Set environment variables
vercel env add SUPABASE_URL
vercel env add SUPABASE_ANON_KEY
vercel env add SUPABASE_SERVICE_KEY

# Deploy to production
vercel --prod
```

## 🔧 Configuration Files

The following files have been created for Vercel deployment:

### `vercel.json`
- Build configuration
- Routing rules (SPA support)
- Security headers
- Cache headers for assets

### `package.json`
- Build scripts
- Node.js version requirement

### `scripts/inject-env.js`
- Injects Vercel environment variables into `web/index.html`
- Runs automatically during build

### `web/index.html`
- Updated to read environment variables from `window.env`
- Mobile-friendly meta tags
- PWA-ready structure

## 📱 Mobile Optimization

### Viewport Configuration
The app includes mobile-optimized viewport settings:
- Responsive design
- Touch-friendly interface
- Mobile browser compatibility

### Add to Home Screen
Users can add your web app to their home screen:
- **iOS**: Safari → Share → Add to Home Screen
- **Android**: Chrome → Menu → Add to Home Screen

### PWA Features (Future Enhancement)
To make it a full PWA:
1. Add `web/manifest.json` with app details
2. Add service worker for offline support
3. Configure icons for different sizes

## 🔐 Environment Variables

### Required Variables:
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Supabase anonymous key
- `SUPABASE_SERVICE_KEY` - Supabase service role key

### Optional Variables:
- `SMTP_EMAIL` - Email for notifications
- `SMTP_PASSWORD` - Email password

### How They Work:
1. Set in Vercel Dashboard → Environment Variables
2. Injected into `web/index.html` during build
3. Read by Flutter app at runtime via `window.env`

## 🌐 Supabase CORS Configuration

After deployment, update Supabase CORS settings:

1. Go to Supabase Dashboard → Settings → API
2. Add to "Allowed CORS Origins":
   ```
   https://your-project.vercel.app
   https://*.vercel.app
   ```
3. If using custom domain, add that too

## 🎯 Custom Domain (Optional)

1. In Vercel Dashboard → Settings → Domains
2. Add your custom domain
3. Configure DNS as instructed
4. Update Supabase CORS with custom domain

## 🐛 Troubleshooting

### Build Fails: "Flutter not found"
**Solution**: Vercel doesn't have Flutter pre-installed. Use GitHub Actions (see below) or ensure Flutter is available in build environment.

### Build Timeout
**Solution**: Flutter builds can take 5-10 minutes. Consider:
- Using GitHub Actions to build
- Upgrading Vercel plan for longer build times

### Environment Variables Not Working
**Solution**:
1. Verify variables are set in Vercel Dashboard
2. Check variable names match exactly (case-sensitive)
3. Redeploy after adding variables

### CORS Errors
**Solution**:
1. Update Supabase CORS settings (see above)
2. Check browser console for specific errors
3. Verify Supabase URL is correct

### App Not Loading on Mobile
**Solution**:
1. Check mobile browser console
2. Verify HTTPS is enabled (Vercel provides automatically)
3. Test in different mobile browsers

## 🔄 Alternative: GitHub Actions + Vercel

If Vercel build fails, use GitHub Actions to build:

### Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.6'
          channel: 'stable'
      
      - name: Install dependencies
        run: |
          flutter pub get
          npm install
      
      - name: Build web app
        run: npm run build:vercel
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
          SUPABASE_SERVICE_KEY: ${{ secrets.SUPABASE_SERVICE_KEY }}
      
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          working-directory: ./
```

### Set GitHub Secrets:
- `VERCEL_TOKEN` - Get from Vercel Dashboard → Settings → Tokens
- `VERCEL_ORG_ID` - Get from Vercel API
- `VERCEL_PROJECT_ID` - Get from Vercel project settings
- `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_KEY` - Your Supabase credentials

## 📊 Performance Tips

1. **Enable Caching**: Already configured in `vercel.json`
2. **Code Splitting**: Flutter web handles this automatically
3. **CDN**: Vercel's global CDN serves your app
4. **Compression**: Vercel automatically compresses assets

## 🔄 Updating Your App

Every push to `main` branch automatically:
1. Triggers new build
2. Deploys new version
3. Creates preview URL for PRs

## 📱 Testing on Mobile

1. **Open on Mobile Browser**:
   - Visit `https://your-project.vercel.app`
   - Test all features
   - Check responsive design

2. **Test Different Devices**:
   - iOS Safari
   - Android Chrome
   - Mobile Firefox

3. **Test Features**:
   - Login/Signup
   - Complaint submission
   - File uploads
   - Navigation

## ✅ Deployment Checklist

- [ ] Flutter web enabled (`flutter config --enable-web`)
- [ ] Tested build locally (`flutter build web`)
- [ ] Code pushed to Git repository
- [ ] Vercel project created
- [ ] Environment variables set in Vercel
- [ ] Supabase CORS updated
- [ ] Build successful
- [ ] App accessible on mobile browser
- [ ] All features working

## 🎉 Success!

Your Flutter app is now deployed and accessible from:
- ✅ Desktop browsers
- ✅ Mobile browsers (iOS & Android)
- ✅ Tablets
- ✅ Any device with a web browser

**Note**: This is a web app, not a native mobile app. For native apps, build APK/IPA files separately.

---

**Need Help?**
- Check Vercel build logs
- Review browser console errors
- Verify environment variables
- Test locally first: `flutter run -d chrome`
