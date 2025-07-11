# Quick Deploy Script for Galaxy Cloud
# PowerShell script to prepare your app for Galaxy Cloud deployment

Write-Host "🚀 Google Classroom Manager - Galaxy Cloud Preparation" -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green

# Check if credentials.json exists
if (Test-Path "credentials.json") {
    Write-Host "✅ credentials.json found" -ForegroundColor Green
} else {
    Write-Host "❌ credentials.json not found!" -ForegroundColor Red
    Write-Host "Please download it from Google Cloud Console and place it in this directory." -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit
    }
}

# Generate a strong secret key
Write-Host "🔑 Generating secret key..." -ForegroundColor Yellow
$secretKey = -join ((1..64) | ForEach {[char]((65..90) + (97..122) + (48..57) | Get-Random)})

# Get app domain from user
$appDomain = Read-Host "Enter your Galaxy Cloud app domain (e.g., my-classroom-app.galaxycloud.app)"

# Update .env file
Write-Host "📝 Updating .env file..." -ForegroundColor Yellow
$envContent = @"
# Galaxy Cloud Deployment Configuration
SECRET_KEY=$secretKey
FLASK_ENV=production
REDIRECT_URI=https://$appDomain/oauth2callback
PORT=8080
"@

Set-Content -Path ".env" -Value $envContent

# Optionally convert credentials to base64
if (Test-Path "credentials.json") {
    $useBase64 = Read-Host "Convert credentials.json to base64 environment variable? (y/n)"
    if ($useBase64 -eq "y" -or $useBase64 -eq "Y") {
        $credentialsJson = Get-Content "credentials.json" -Raw
        $credentialsBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credentialsJson))
        Add-Content -Path ".env" -Value "GOOGLE_CREDENTIALS_BASE64=$credentialsBase64"
        Write-Host "✅ Credentials added to .env as base64" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "✅ Your app is ready for Galaxy Cloud deployment!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to https://beta.galaxycloud.app/d/us-east-1" -ForegroundColor White
Write-Host "2. Create a new application" -ForegroundColor White
Write-Host "3. Upload all files in this directory" -ForegroundColor White
Write-Host "4. Add this redirect URI to Google Cloud Console:" -ForegroundColor White
Write-Host "   https://$appDomain/oauth2callback" -ForegroundColor Cyan
Write-Host "5. Deploy your application!" -ForegroundColor White
Write-Host ""
Write-Host "📁 Files to upload:" -ForegroundColor Yellow
Write-Host "   • webapp.py" -ForegroundColor White
Write-Host "   • requirements.txt" -ForegroundColor White
Write-Host "   • Procfile" -ForegroundColor White
Write-Host "   • runtime.txt" -ForegroundColor White
Write-Host "   • .env" -ForegroundColor White
Write-Host "   • templates/ folder" -ForegroundColor White
Write-Host "   • credentials.json (if not using base64)" -ForegroundColor White

Write-Host ""
Write-Host "🔗 Your app will be available at: https://$appDomain" -ForegroundColor Cyan

$openDocs = Read-Host "Open deployment guide? (y/n)"
if ($openDocs -eq "y" -or $openDocs -eq "Y") {
    if (Test-Path "GALAXY_DEPLOY.md") {
        Start-Process "GALAXY_DEPLOY.md"
    }
}
