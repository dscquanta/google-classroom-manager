# 🚀 Simple Deployment Guide for Google Classroom App

## ✅ What's Already Done
- ✅ Flask app created and working
- ✅ GitHub repository set up: `dscquanta/google-classroom-manager`
- ✅ Code pushed to GitHub
- ✅ All deployment files ready

## 🔧 Step 1: Get Google Credentials (5 minutes)

### In Google Cloud Console (already open):
1. **Create a new project** OR select existing project
2. **Enable Google Classroom API**:
   - Go to "APIs & Services" → "Library"
   - Search for "Google Classroom API"
   - Click "Enable"

3. **Create OAuth 2.0 Credentials**:
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth 2.0 Client ID"
   - Application type: "Web application"
   - Name: "Google Classroom Manager"
   - Authorized redirect URIs: `https://academiapeople.galaxycloud.app/oauth2callback`
   - Click "Create"

4. **Download JSON**:
   - Click the download button (⬇️) next to your new OAuth client
   - Save as `credentials.json` in your project folder

## 🌐 Step 2: Deploy to Galaxy Cloud (3 minutes)

### In Galaxy Cloud (already open):
1. **Create New App**:
   - Click "New App"
   - Choose "From GitHub"
   - Repository: `dscquanta/google-classroom-manager`
   - Branch: `master`
   - App name: `academiapeople` (or any name you want)

2. **Add Environment Variables**:
   ```
   SECRET_KEY=MfR0745Ul7Fo96MA8btNzkYJ9wOtQD3W2Bdg89MyAtYvFUVQjhhxg4MvLpINhwqy
   FLASK_ENV=production
   PORT=8080
   REDIRECT_URI=https://academiapeople.galaxycloud.app/oauth2callback
   ```

3. **Upload credentials.json**:
   - In Galaxy Cloud dashboard, upload your `credentials.json` file
   - OR convert to base64 and add as `GOOGLE_CREDENTIALS_BASE64` environment variable

4. **Deploy**:
   - Click "Deploy"
   - Wait for deployment to complete

## 🎉 Step 3: Test Your App

1. Go to: `https://academiapeople.galaxycloud.app`
2. Click "Login with Google"
3. Grant permissions to access Google Classroom
4. Start managing your Google Classroom!

## 🆘 If Something Goes Wrong

Run this command to get help:
```powershell
.\complete-deployment.ps1
```

## 📞 Quick Help
- **App not loading?** Check Galaxy Cloud logs
- **OAuth error?** Verify redirect URI in Google Cloud Console
- **API error?** Make sure Google Classroom API is enabled

---
**Your app will be live at:** https://academiapeople.galaxycloud.app
