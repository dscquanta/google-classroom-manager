# Deploy to Heroku - PowerShell Script
# Run this script to deploy your Google Classroom app to Heroku

Write-Host "🚀 Google Classroom Manager - Heroku Deployment" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Check if Heroku CLI is installed
try {
    heroku --version
    Write-Host "✅ Heroku CLI is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Heroku CLI not found. Please install it from: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor Red
    exit 1
}

# Get app name from user
$appName = Read-Host "Enter your Heroku app name (e.g., my-classroom-app)"

# Check if app exists, if not create it
Write-Host "Creating Heroku app: $appName" -ForegroundColor Yellow
heroku create $appName

if ($LASTEXITCODE -ne 0) {
    Write-Host "App might already exist or name is taken. Continuing..." -ForegroundColor Yellow
}

# Set environment variables
Write-Host "Setting environment variables..." -ForegroundColor Yellow

$secretKey = Read-Host "Enter a strong SECRET_KEY for your app"
heroku config:set SECRET_KEY="$secretKey" --app $appName

heroku config:set FLASK_ENV="production" --app $appName

$redirectUri = "https://$appName.herokuapp.com/oauth2callback"
heroku config:set REDIRECT_URI="$redirectUri" --app $appName

Write-Host "✅ Environment variables set!" -ForegroundColor Green
Write-Host "📋 Important: Add this redirect URI to Google Cloud Console:" -ForegroundColor Cyan
Write-Host "   $redirectUri" -ForegroundColor White

# Ask about credentials
Write-Host ""
$credentialsChoice = Read-Host "Do you want to upload credentials.json as environment variable? (y/n)"

if ($credentialsChoice -eq "y" -or $credentialsChoice -eq "Y") {
    if (Test-Path "credentials.json") {
        Write-Host "Converting credentials.json to base64..." -ForegroundColor Yellow
        $credentialsJson = Get-Content "credentials.json" -Raw
        $credentialsBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credentialsJson))
        heroku config:set GOOGLE_CREDENTIALS_BASE64="$credentialsBase64" --app $appName
        Write-Host "✅ Credentials uploaded as environment variable!" -ForegroundColor Green
    } else {
        Write-Host "❌ credentials.json not found. Make sure it's in the current directory." -ForegroundColor Red
        Write-Host "   You'll need to add it manually or set GOOGLE_CREDENTIALS_BASE64 later." -ForegroundColor Yellow
    }
}

# Initialize git if needed
if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Initial commit for Heroku deployment"
}

# Add Heroku remote
Write-Host "Adding Heroku remote..." -ForegroundColor Yellow
heroku git:remote -a $appName

# Deploy
Write-Host "Deploying to Heroku..." -ForegroundColor Yellow
git add .
git commit -m "Deploy to Heroku" --allow-empty
git push heroku main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "🎉 Deployment successful!" -ForegroundColor Green
    Write-Host "📱 Your app is available at: https://$appName.herokuapp.com" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Yellow
    Write-Host "1. Go to Google Cloud Console → APIs & Services → Credentials" -ForegroundColor White
    Write-Host "2. Edit your OAuth 2.0 Client ID" -ForegroundColor White
    Write-Host "3. Add this redirect URI: $redirectUri" -ForegroundColor White
    Write-Host "4. Test your app: https://$appName.herokuapp.com" -ForegroundColor White
    
    $openApp = Read-Host "Open app in browser? (y/n)"
    if ($openApp -eq "y" -or $openApp -eq "Y") {
        heroku open --app $appName
    }
} else {
    Write-Host "❌ Deployment failed. Check the logs with: heroku logs --tail --app $appName" -ForegroundColor Red
}
