# Quick Deploy Script - Run after getting credentials.json
param(
    [switch]$OpenLinks,
    [switch]$CheckCredentials
)

Write-Host "🚀 Google Classroom App - Quick Deploy" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Check if credentials exist
if (Test-Path "credentials.json") {
    Write-Host "✅ credentials.json found!" -ForegroundColor Green
    
    # Convert to base64 for Galaxy Cloud
    try {
        $credentialsJson = Get-Content "credentials.json" -Raw
        $credentialsBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credentialsJson))
        
        # Save for easy copying
        Set-Content -Path "credentials_base64.txt" -Value $credentialsBase64
        
        Write-Host "✅ Credentials converted to base64!" -ForegroundColor Green
        Write-Host "📄 Saved to: credentials_base64.txt" -ForegroundColor Cyan
        
        # Show environment variables
        Write-Host ""
        Write-Host "📋 Copy these to Galaxy Cloud:" -ForegroundColor Yellow
        Write-Host "=============================" -ForegroundColor Yellow
        Write-Host "SECRET_KEY=MfR0745Ul7Fo96MA8btNzkYJ9wOtQD3W2Bdg89MyAtYvFUVQjhhxg4MvLpINhwqy"
        Write-Host "FLASK_ENV=production"
        Write-Host "PORT=8080" 
        Write-Host "REDIRECT_URI=https://academiapeople.galaxycloud.app/oauth2callback"
        Write-Host ""
        Write-Host "GOOGLE_CREDENTIALS_BASE64=" -NoNewline
        Write-Host $credentialsBase64.Substring(0, 50) -NoNewline -ForegroundColor Cyan
        Write-Host "..." -ForegroundColor Cyan
        Write-Host "(Full value is in credentials_base64.txt)" -ForegroundColor Gray
        
    } catch {
        Write-Host "❌ Error processing credentials: $_" -ForegroundColor Red
    }
} else {
    Write-Host "❌ credentials.json not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 Please download credentials.json from Google Cloud Console:" -ForegroundColor Yellow
    Write-Host "1. Go to APIs & Services → Credentials" -ForegroundColor White
    Write-Host "2. Create OAuth 2.0 Client ID (if not done)" -ForegroundColor White
    Write-Host "3. Download JSON file and save as 'credentials.json'" -ForegroundColor White
    Write-Host "4. Run this script again" -ForegroundColor White
}

Write-Host ""
Write-Host "🌐 Deployment Info:" -ForegroundColor Yellow
Write-Host "===================" -ForegroundColor Yellow
Write-Host "GitHub Repo: dscquanta/google-classroom-manager" -ForegroundColor White
Write-Host "Branch: master" -ForegroundColor White
Write-Host "Galaxy Cloud URL: https://beta.galaxycloud.app/d/us-east-1" -ForegroundColor White
Write-Host "App URL: https://academiapeople.galaxycloud.app" -ForegroundColor Cyan

if ($OpenLinks) {
    Write-Host ""
    Write-Host "🌐 Opening deployment links..." -ForegroundColor Yellow
    Start-Process "https://beta.galaxycloud.app/d/us-east-1"
    Start-Process "https://console.cloud.google.com/apis/credentials"
}

Write-Host ""
Write-Host "📖 For detailed guide: see SIMPLE_DEPLOY.md" -ForegroundColor Cyan
Write-Host "🔧 Need help? Run: Get-Help .\quick-deploy.ps1 -Full" -ForegroundColor Gray
