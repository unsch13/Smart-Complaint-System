# 🔧 Vercel Build Fix - Two Options

## Problem
Vercel doesn't have Flutter pre-installed, causing build failures.

## Solution Options

### Option 1: Use GitHub Actions (Recommended) ⭐

This is the **best solution** because:
- ✅ Faster builds (Flutter is cached)
- ✅ More reliable
- ✅ No build time limits
- ✅ Automatic deployment

#### Setup Steps:

1. **Get Vercel Credentials**:
   - Go to Vercel Dashboard → Settings → Tokens
   - Create a new token → Copy it
   - Go to Project Settings → General → Copy:
     - **Org ID**
     - **Project ID**

2. **Add GitHub Secrets**:
   - Go to your GitHub repo: https://github.com/unsch13/Smart-Complaint-System
   - Settings → Secrets and variables → Actions
   - Add these secrets:
     ```
     VERCEL_TOKEN = your_vercel_token
     VERCEL_ORG_ID = your_org_id
     VERCEL_PROJECT_ID = your_project_id
     SUPABASE_URL = your_supabase_url
     SUPABASE_ANON_KEY = your_anon_key
     SUPABASE_SERVICE_KEY = your_service_key
     SMTP_EMAIL = your_email (optional)
     SMTP_PASSWORD = your_password (optional)
     ```

3. **Push the workflow file**:
   ```bash
   git add .github/workflows/deploy-vercel.yml
   git commit -m "Add GitHub Actions workflow"
   git push
   ```

4. **Deploy**:
   - The workflow will run automatically on push
   - Or trigger manually: Actions → Build and Deploy → Run workflow

### Option 2: Direct Vercel Build (Alternative)

If you prefer to build directly on Vercel:

1. **Update Vercel Settings**:
   - Build Command: `bash scripts/build.sh`
   - Install Command: `npm install`
   - Output Directory: `build/web`

2. **Note**: This may take longer (10-15 minutes) as Flutter needs to be downloaded each time.

## Current Status

✅ **Files Created**:
- `scripts/build.sh` - Build script with Flutter installation
- `scripts/install-flutter.sh` - Flutter installation script
- `.github/workflows/deploy-vercel.yml` - GitHub Actions workflow

## Recommendation

**Use Option 1 (GitHub Actions)** - It's faster, more reliable, and free!

The workflow file is already created. Just add the secrets to GitHub and push!

