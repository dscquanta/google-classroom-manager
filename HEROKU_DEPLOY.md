# Heroku Deployment Guide for Google Classroom Manager

## 🚀 Quick Heroku Deployment Steps

### 1. Prerequisites
- Heroku account
- Heroku CLI installed
- Google Cloud Console project with Classroom API enabled

### 2. Prepare Your App

**Install Heroku CLI:**
```bash
# Download from: https://devcenter.heroku.com/articles/heroku-cli
```

**Login to Heroku:**
```powershell
heroku login
```

### 3. Create Heroku App
```powershell
# In your project directory
heroku create your-classroom-app-name
```

### 4. Set Environment Variables
```powershell
# Set your secret key (generate a strong one)
heroku config:set SECRET_KEY="your-super-secret-key-here"

# Set production environment
heroku config:set FLASK_ENV="production"

# Set your Google OAuth redirect URI (replace with your Heroku app URL)
heroku config:set REDIRECT_URI="https://your-classroom-app-name.herokuapp.com/oauth2callback"
```

### 5. Google Cloud Console Setup

1. **Go to Google Cloud Console** → APIs & Services → Credentials
2. **Edit your OAuth 2.0 Client ID**
3. **Add Authorized Redirect URIs:**
   - `https://your-classroom-app-name.herokuapp.com/oauth2callback`
4. **Download the updated credentials.json file**

### 6. Handle Google Credentials

Since `credentials.json` contains sensitive data, you have two options:

**Option A: Environment Variables (Recommended)**
```powershell
# Convert your credentials.json to a base64 string
$credentialsJson = Get-Content "credentials.json" -Raw
$credentialsBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credentialsJson))
heroku config:set GOOGLE_CREDENTIALS_BASE64="$credentialsBase64"
```

**Option B: Commit credentials.json (Less Secure)**
- Add `credentials.json` to your repository
- Remove it from `.gitignore`

### 7. Deploy to Heroku
```powershell
# Initialize git (if not already done)
git init
git add .
git commit -m "Initial commit for Heroku deployment"

# Add Heroku remote
heroku git:remote -a your-classroom-app-name

# Deploy
git push heroku main
```

### 8. Open Your App
```powershell
heroku open
```

## 📋 Environment Variables Checklist

Set these in Heroku Dashboard or CLI:

- ✅ `SECRET_KEY` - Strong secret key for Flask sessions
- ✅ `FLASK_ENV` - Set to "production"
- ✅ `REDIRECT_URI` - Your Heroku app OAuth callback URL
- ✅ `GOOGLE_CREDENTIALS_BASE64` - (Optional) Base64 encoded credentials

## 🔧 Troubleshooting

### Common Issues:

1. **OAuth Redirect Mismatch**
   - Make sure redirect URI in Google Console matches Heroku app URL exactly
   - Check for http vs https

2. **Missing Credentials**
   - Ensure `credentials.json` is in the root directory
   - Or set `GOOGLE_CREDENTIALS_BASE64` environment variable

3. **App Won't Start**
   - Check Heroku logs: `heroku logs --tail`
   - Verify all environment variables are set

4. **OAuth Errors in Production**
   - Remove `OAUTHLIB_INSECURE_TRANSPORT` (only for development)
   - Ensure using HTTPS in production

### Useful Heroku Commands:

```powershell
# View logs
heroku logs --tail

# Check config vars
heroku config

# Restart app
heroku restart

# Open app in browser
heroku open

# Check app status
heroku ps
```

## 🔐 Security Best Practices

1. **Never commit `credentials.json` to public repositories**
2. **Use strong, unique SECRET_KEY**
3. **Regularly rotate OAuth credentials**
4. **Monitor app logs for unauthorized access**
5. **Use HTTPS only in production**

## 📊 Monitoring Your App

- **Heroku Dashboard**: Monitor dynos, metrics, and logs
- **Google Cloud Console**: Monitor API usage and quotas
- **Error Tracking**: Consider adding Sentry or similar service

Your app will be available at: `https://your-classroom-app-name.herokuapp.com`
