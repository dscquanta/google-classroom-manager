# GitHub to Galaxy Cloud Deployment Guide

## 🚀 Deploy Google Classroom Manager via GitHub

### 1. Prerequisites
- GitHub account
- Galaxy Cloud account (https://beta.galaxycloud.app)
- Google Cloud Console project with Classroom API enabled

### 2. GitHub Repository Setup

#### Step 1: Create GitHub Repository
1. Go to [GitHub](https://github.com) and create a new repository
2. Name it something like `google-classroom-manager`
3. Make it **public** or **private** (your choice)
4. **Don't** initialize with README (we'll push our existing code)

#### Step 2: Prepare Your Local Repository
Run these commands in your project directory:

```powershell
# Initialize git repository
git init

# Add all files
git add .

# Make initial commit
git commit -m "Initial commit: Google Classroom Manager"

# Add your GitHub repository as remote (replace with your repo URL)
git remote add origin https://github.com/yourusername/google-classroom-manager.git

# Push to GitHub
git push -u origin main
```

### 3. Galaxy Cloud Configuration

#### Step 1: Connect GitHub to Galaxy Cloud
1. Go to https://beta.galaxycloud.app/d/us-east-1
2. Create a new application
3. Choose **"Deploy from Git"** or **"GitHub Integration"**
4. Connect your GitHub account
5. Select your `google-classroom-manager` repository
6. Choose the `main` branch

#### Step 2: Configure Environment Variables in Galaxy Cloud
Set these environment variables in the Galaxy Cloud dashboard:

```
SECRET_KEY=MfR0745Ul7Fo96MA8btNzkYJ9wOtQD3W2Bdg89MyAtYvFUVQjhhxg4MvLpINhwqy
FLASK_ENV=production
REDIRECT_URI=https://your-app-domain.galaxycloud.app/oauth2callback
PORT=8080
```

**Important:** Update `REDIRECT_URI` with your actual Galaxy Cloud app domain!

#### Step 3: Upload Google Credentials
**Option A: Environment Variable (Recommended)**
1. Convert `credentials.json` to base64:
   ```powershell
   $credentialsJson = Get-Content "credentials.json" -Raw
   $credentialsBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credentialsJson))
   Write-Output $credentialsBase64
   ```
2. Add as environment variable in Galaxy Cloud:
   ```
   GOOGLE_CREDENTIALS_BASE64=your-base64-string-here
   ```

**Option B: Include in Repository**
- Add `credentials.json` to your repository (less secure)
- Make sure your repository is private if you choose this option

### 4. Google Cloud Console Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services → Credentials**
3. Edit your **OAuth 2.0 Client ID**
4. Add **Authorized Redirect URI**:
   ```
   https://your-app-domain.galaxycloud.app/oauth2callback
   ```

### 5. Deployment Process

#### Automatic Deployment
- Every push to the `main` branch will trigger automatic deployment
- Galaxy Cloud will pull the latest code and redeploy

#### Manual Deployment
- Use Galaxy Cloud dashboard to manually trigger deployment
- Monitor deployment logs for any issues

### 6. Files in Repository

Your repository should contain:
```
google-classroom-manager/
├── webapp.py              # Main Flask application
├── requirements.txt       # Python dependencies
├── Procfile              # Process configuration
├── runtime.txt           # Python version
├── .env.example          # Environment variables template
├── .gitignore            # Git ignore file
├── templates/            # HTML templates
│   ├── base.html
│   ├── login.html
│   ├── dashboard.html
│   ├── course_details.html
│   ├── assignment_details.html
│   └── error.html
├── README.md             # Project documentation
├── GALAXY_DEPLOY.md      # Deployment guide
└── credentials.json      # Google OAuth (optional, use env var instead)
```

### 7. Security Best Practices

- ✅ Use environment variables for sensitive data
- ✅ Add `credentials.json` to `.gitignore` if using env vars
- ✅ Use strong `SECRET_KEY`
- ✅ Set `FLASK_ENV=production`
- ✅ Keep repository private if including credentials

### 8. Continuous Deployment Workflow

1. **Make changes** to your code locally
2. **Commit changes**:
   ```powershell
   git add .
   git commit -m "Description of changes"
   ```
3. **Push to GitHub**:
   ```powershell
   git push origin main
   ```
4. **Galaxy Cloud automatically deploys** the new version

### 9. Monitoring & Troubleshooting

#### Check Deployment Status
- Monitor Galaxy Cloud dashboard for deployment progress
- Check deployment logs for errors

#### Common Issues
1. **Environment variables not set**
   - Verify all required env vars in Galaxy Cloud dashboard
2. **OAuth redirect mismatch**
   - Ensure redirect URI matches exactly in Google Console
3. **Missing dependencies**
   - Check `requirements.txt` includes all packages
4. **Port configuration**
   - Ensure `PORT=8080` is set

### 10. App Features

Your deployed app will have:
- 🔐 Google OAuth authentication
- 📚 Course management and viewing
- 📋 Assignment tracking and submissions
- 👥 Student roster management
- 📱 Responsive web interface
- 🎨 Modern Bootstrap UI

---

**Your app will be available at:** `https://your-app-domain.galaxycloud.app`

### Quick Commands Summary:
```powershell
# Setup
git init
git add .
git commit -m "Initial commit: Google Classroom Manager"
git remote add origin https://github.com/yourusername/repo-name.git
git push -u origin main

# Updates
git add .
git commit -m "Update description"
git push origin main
```
