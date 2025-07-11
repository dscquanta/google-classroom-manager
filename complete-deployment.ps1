# Complete Galaxy Cloud Deployment Script
# Run this after downloading credentials.json from Google Cloud Console

Write-Host "🚀 Completing Galaxy Cloud Deployment" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# Check if credentials.json exists
if (Test-Path "credentials.json") {
    Write-Host "✅ credentials.json found" -ForegroundColor Green
    
    # Convert credentials to base64 for secure deployment
    Write-Host "🔄 Converting credentials to base64..." -ForegroundColor Yellow
    try {
        $credentialsJson = Get-Content "credentials.json" -Raw
        $credentialsBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credentialsJson))
        
        # Save base64 to a file for easy copying
        Set-Content -Path "credentials_base64.txt" -Value $credentialsBase64
        
        Write-Host "✅ Credentials converted to base64" -ForegroundColor Green
        Write-Host "📄 Saved to: credentials_base64.txt" -ForegroundColor Cyan
        
        # Show first 50 characters for verification
        $preview = $credentialsBase64.Substring(0, [Math]::Min(50, $credentialsBase64.Length))
        Write-Host "Preview: $preview..." -ForegroundColor Gray
        
    } catch {
        Write-Host "❌ Error converting credentials: $_" -ForegroundColor Red
    }
} else {
    Write-Host "❌ credentials.json not found!" -ForegroundColor Red
    Write-Host "Please download it from Google Cloud Console and place it in this directory." -ForegroundColor Yellow
    Write-Host "The Google Cloud Console should be open in your browser." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 Galaxy Cloud Environment Variables:" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow
Write-Host "SECRET_KEY=MfR0745Ul7Fo96MA8btNzkYJ9wOtQD3W2Bdg89MyAtYvFUVQjhhxg4MvLpINhwqy" -ForegroundColor White
Write-Host "FLASK_ENV=production" -ForegroundColor White
Write-Host "REDIRECT_URI=https://academiapeople.galaxycloud.app/oauth2callback" -ForegroundColor White
Write-Host "PORT=8080" -ForegroundColor White

if (Test-Path "credentials_base64.txt") {
    Write-Host "GOOGLE_CREDENTIALS_BASE64=" -NoNewline -ForegroundColor White
    Write-Host "(see credentials_base64.txt file)" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🔧 Google Cloud Console Setup:" -ForegroundColor Yellow
Write-Host "==============================" -ForegroundColor Yellow
Write-Host "1. Go to APIs & Services → Credentials" -ForegroundColor White
Write-Host "2. Edit your OAuth 2.0 Client ID" -ForegroundColor White
Write-Host "3. Add Authorized Redirect URI:" -ForegroundColor White
Write-Host "   https://academiapeople.galaxycloud.app/oauth2callback" -ForegroundColor Cyan

Write-Host ""
Write-Host "🌐 Galaxy Cloud Deployment:" -ForegroundColor Yellow
Write-Host "===========================" -ForegroundColor Yellow
Write-Host "1. Repository: dscquanta/google-classroom-manager" -ForegroundColor White
Write-Host "2. Branch: master" -ForegroundColor White
Write-Host "3. Add environment variables listed above" -ForegroundColor White
Write-Host "4. Upload credentials.json OR use GOOGLE_CREDENTIALS_BASE64" -ForegroundColor White

Write-Host ""
Write-Host "🎉 Your app will be live at:" -ForegroundColor Green
Write-Host "https://academiapeople.galaxycloud.app" -ForegroundColor Cyan

# Open necessary links
$openLinks = Read-Host "Open deployment links? (y/n)"
if ($openLinks -eq "y" -or $openLinks -eq "Y") {
    Write-Host "🌐 Opening deployment links..." -ForegroundColor Yellow
    Start-Process "https://beta.galaxycloud.app/d/us-east-1"
    Start-Process "https://console.cloud.google.com/apis/credentials"
    Start-Process "https://github.com/dscquanta/google-classroom-manager"
}

Write-Host ""
Write-Host "📖 For detailed instructions, see: DEPLOYMENT_CHECKLIST.md" -ForegroundColor Cyan
