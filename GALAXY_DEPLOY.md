# Galaxy Cloud Deployment Guide for Google Classroom Manager

## 🚀 Deploying to Galaxy Cloud

### 1. Prerequisites
- Galaxy Cloud account at https://beta.galaxycloud.app
- Google Cloud Console project with Classroom API enabled
- `credentials.json` file from Google Cloud Console

### 2. Prepare Your Application

Your Flask app is already configured for cloud deployment with:
- ✅ Dynamic PORT handling from environment variables
- ✅ Production-ready configuration
- ✅ Environment-based Google credentials support
- ✅ HTTPS-ready OAuth flow

### 3. Configuration Files

**Environment Variables (.env):**
```
SECRET_KEY=your-super-secret-key-change-this
FLASK_ENV=production
REDIRECT_URI=https://your-app-domain.galaxycloud.app/oauth2callback
PORT=8080
```

**Dependencies (requirements.txt):**
- Flask and Google API libraries included
- Gunicorn for production server

### 4. Deployment Steps

#### Step 1: Update Environment Variables
1. Edit `.env` file with your values:
   - Generate a strong `SECRET_KEY`
   - Set your Galaxy Cloud app domain in `REDIRECT_URI`

#### Step 2: Google Cloud Console Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to APIs & Services → Credentials
3. Edit your OAuth 2.0 Client ID
4. Add Authorized Redirect URI:
   ```
   https://your-app-domain.galaxycloud.app/oauth2callback
   ```

#### Step 3: Handle Google Credentials

**Option A: Environment Variable (Recommended)**
```bash
# Convert credentials.json to base64
cat credentials.json | base64 -w 0
# Copy the output and set as GOOGLE_CREDENTIALS_BASE64 environment variable
```

**Option B: Include credentials.json file**
- Upload `credentials.json` with your app files
- Ensure it's in the root directory

#### Step 4: Deploy to Galaxy Cloud
1. Log in to https://beta.galaxycloud.app/d/us-east-1
2. Create a new application
3. Upload your project files:
   - `webapp.py`
   - `requirements.txt`
   - `Procfile`
   - `runtime.txt`
   - `templates/` folder
   - `.env` file (or set environment variables in Galaxy Cloud dashboard)
   - `credentials.json` (if not using environment variable)

4. Configure environment variables in Galaxy Cloud dashboard
5. Deploy the application

### 5. Post-Deployment

1. **Test OAuth Flow:**
   - Visit your deployed app
   - Try Google OAuth login
   - Verify redirect URI works

2. **Update Google Console:**
   - Ensure redirect URI matches your deployed domain exactly
   - Test with a Google account that has Classroom access

3. **Monitor Logs:**
   - Check Galaxy Cloud logs for any errors
   - Monitor API quota usage in Google Cloud Console

### 6. Application Structure

```
googleclassroom/
├── webapp.py              # Main Flask application
├── requirements.txt       # Python dependencies
├── Procfile              # Process file for deployment
├── runtime.txt           # Python version specification
├── .env                  # Environment variables
├── credentials.json      # Google OAuth credentials
├── templates/            # HTML templates
│   ├── base.html
│   ├── login.html
│   ├── dashboard.html
│   ├── course_details.html
│   ├── assignment_details.html
│   └── error.html
└── README.md
```

### 7. Security Checklist

- ✅ Strong SECRET_KEY set
- ✅ FLASK_ENV=production
- ✅ HTTPS enforced (Galaxy Cloud handles this)
- ✅ Google credentials secured
- ✅ OAuth redirect URI matches exactly

### 8. Troubleshooting

**Common Issues:**

1. **OAuth Redirect Mismatch**
   - Check redirect URI in Google Console matches deployed URL exactly
   - Ensure HTTPS is used (not HTTP)

2. **Missing Credentials**
   - Verify `credentials.json` is accessible
   - Or check `GOOGLE_CREDENTIALS_BASE64` environment variable

3. **API Quota Exceeded**
   - Check Google Cloud Console for API usage
   - Increase quotas if needed

4. **App Won't Start**
   - Check Galaxy Cloud logs
   - Verify all environment variables are set
   - Ensure `requirements.txt` includes all dependencies

### 9. Useful Commands

**Local Testing:**
```bash
# Install dependencies
pip install -r requirements.txt

# Set environment variables
export SECRET_KEY="your-secret-key"
export FLASK_ENV="development"
export REDIRECT_URI="http://localhost:5000/oauth2callback"

# Run locally
python webapp.py
```

**Generate Secret Key:**
```python
import secrets
print(secrets.token_hex(32))
```

### 10. Features Available

Your deployed app will have:
- 🔐 Google OAuth authentication
- 📚 Course management and viewing
- 📋 Assignment tracking
- 👥 Student roster management
- 📱 Responsive web interface
- 🎨 Modern Bootstrap UI

---

Your app will be available at: `https://your-app-domain.galaxycloud.app`
