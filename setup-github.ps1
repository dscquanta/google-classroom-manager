# Quick GitHub Setup Script
# PowerShell script to initialize and push to GitHub

Write-Host "🚀 Google Classroom Manager - GitHub Setup" -ForegroundColor Green
Write-Host "===========================================" -ForegroundColor Green

# Check if git is installed
try {
    git --version | Out-Null
    Write-Host "✅ Git is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Git not found. Please install Git from: https://git-scm.com/" -ForegroundColor Red
    exit 1
}

# Get GitHub repository URL
Write-Host ""
$repoUrl = Read-Host "Enter your GitHub repository URL (e.g., https://github.com/username/repo-name.git)"

if ([string]::IsNullOrWhiteSpace($repoUrl)) {
    Write-Host "❌ Repository URL is required!" -ForegroundColor Red
    exit 1
}

# Check if this is already a git repository
if (Test-Path ".git") {
    Write-Host "📁 Git repository already exists" -ForegroundColor Yellow
    $reinit = Read-Host "Reinitialize repository? This will remove git history (y/n)"
    if ($reinit -eq "y" -or $reinit -eq "Y") {
        Remove-Item -Recurse -Force ".git"
        Write-Host "🗑️ Removed existing git history" -ForegroundColor Yellow
    } else {
        Write-Host "Continuing with existing repository..." -ForegroundColor Yellow
    }
}

# Initialize git repository if needed
if (-not (Test-Path ".git")) {
    Write-Host "📁 Initializing git repository..." -ForegroundColor Yellow
    git init
}

# Configure git if needed
$gitUser = git config user.name
$gitEmail = git config user.email

if ([string]::IsNullOrWhiteSpace($gitUser) -or [string]::IsNullOrWhiteSpace($gitEmail)) {
    Write-Host "🔧 Git user not configured. Let's set it up:" -ForegroundColor Yellow
    $userName = Read-Host "Enter your Git username"
    $userEmail = Read-Host "Enter your Git email"
    
    git config user.name "$userName"
    git config user.email "$userEmail"
    Write-Host "✅ Git user configured" -ForegroundColor Green
}

# Create .env from example if it doesn't exist
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creating .env file from template..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "⚠️  Please edit .env file with your actual values before deploying!" -ForegroundColor Yellow
}

# Check if credentials.json exists
if (-not (Test-Path "credentials.json")) {
    Write-Host "⚠️  credentials.json not found!" -ForegroundColor Yellow
    Write-Host "   You'll need to:" -ForegroundColor White
    Write-Host "   1. Download it from Google Cloud Console" -ForegroundColor White
    Write-Host "   2. Place it in this directory, OR" -ForegroundColor White
    Write-Host "   3. Use GOOGLE_CREDENTIALS_BASE64 environment variable" -ForegroundColor White
}

# Add files to git
Write-Host "📦 Adding files to git..." -ForegroundColor Yellow
git add .

# Create initial commit
Write-Host "💾 Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: Google Classroom Manager for Galaxy Cloud deployment"

# Add remote origin
Write-Host "🔗 Adding GitHub remote..." -ForegroundColor Yellow
git remote remove origin 2>$null  # Remove if exists
git remote add origin $repoUrl

# Push to GitHub
Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Yellow
try {
    git push -u origin main
    Write-Host ""
    Write-Host "🎉 Successfully pushed to GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Yellow
    Write-Host "1. Go to https://beta.galaxycloud.app/d/us-east-1" -ForegroundColor White
    Write-Host "2. Create new application and connect to your GitHub repo" -ForegroundColor White
    Write-Host "3. Set environment variables in Galaxy Cloud dashboard" -ForegroundColor White
    Write-Host "4. Add OAuth redirect URI to Google Cloud Console" -ForegroundColor White
    Write-Host ""
    Write-Host "🔗 Your repository: $repoUrl" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Failed to push to GitHub" -ForegroundColor Red
    Write-Host "   Make sure the repository exists and you have access" -ForegroundColor Yellow
    Write-Host "   You may need to authenticate with GitHub" -ForegroundColor Yellow
}

# Show current status
Write-Host ""
Write-Host "📊 Repository Status:" -ForegroundColor Yellow
git status --short

Write-Host ""
Write-Host "📖 For detailed deployment instructions, see: GITHUB_DEPLOY.md" -ForegroundColor Cyan

$openDocs = Read-Host "Open deployment guide? (y/n)"
if ($openDocs -eq "y" -or $openDocs -eq "Y") {
    if (Test-Path "GITHUB_DEPLOY.md") {
        Start-Process "GITHUB_DEPLOY.md"
    }
}
