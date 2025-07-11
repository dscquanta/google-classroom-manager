# Deploy Agora - Solução Rápida
Write-Host "🚀 Fazendo Deploy AGORA do Google Classroom App" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Vamos fazer o deploy sem credenciais primeiro para testar
Write-Host "📦 Verificando arquivos necessários..." -ForegroundColor Yellow

$requiredFiles = @("webapp.py", "requirements.txt", "Procfile", "templates")
$allFilesExist = $true

foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "✅ $file encontrado" -ForegroundColor Green
    } else {
        Write-Host "❌ $file não encontrado" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if ($allFilesExist) {
    Write-Host "✅ Todos os arquivos necessários estão presentes!" -ForegroundColor Green
} else {
    Write-Host "❌ Alguns arquivos estão faltando!" -ForegroundColor Red
    exit 1
}

# Criar um arquivo de credenciais temporário para testing
Write-Host "🔧 Criando credenciais temporárias para teste..." -ForegroundColor Yellow

$tempCredentials = @{
    "web" = @{
        "client_id" = "TEMP_CLIENT_ID"
        "project_id" = "temp-project"
        "auth_uri" = "https://accounts.google.com/o/oauth2/auth"
        "token_uri" = "https://oauth2.googleapis.com/token"
        "auth_provider_x509_cert_url" = "https://www.googleapis.com/oauth2/v1/certs"
        "client_secret" = "TEMP_CLIENT_SECRET"
        "redirect_uris" = @("https://academiapeople.galaxycloud.app/oauth2callback")
    }
} | ConvertTo-Json -Depth 3

Set-Content -Path "credentials.json" -Value $tempCredentials
Write-Host "✅ Credenciais temporárias criadas" -ForegroundColor Green

# Converter para base64
$credentialsBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($tempCredentials))
Set-Content -Path "credentials_base64.txt" -Value $credentialsBase64

Write-Host ""
Write-Host "🌐 DEPLOY NO GALAXY CLOUD:" -ForegroundColor Yellow
Write-Host "=========================" -ForegroundColor Yellow
Write-Host "1. Vá para: https://beta.galaxycloud.app/d/us-east-1" -ForegroundColor White
Write-Host "2. Clique em 'New App'" -ForegroundColor White
Write-Host "3. Escolha 'From GitHub'" -ForegroundColor White
Write-Host "4. Repository: dscquanta/google-classroom-manager" -ForegroundColor White
Write-Host "5. Branch: master" -ForegroundColor White
Write-Host "6. Nome do app: academiapeople" -ForegroundColor White

Write-Host ""
Write-Host "📋 VARIÁVEIS DE AMBIENTE (copie exatamente):" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "SECRET_KEY=MfR0745Ul7Fo96MA8btNzkYJ9wOtQD3W2Bdg89MyAtYvFUVQjhhxg4MvLpINhwqy" -ForegroundColor Cyan
Write-Host "FLASK_ENV=production" -ForegroundColor Cyan
Write-Host "PORT=8080" -ForegroundColor Cyan
Write-Host "REDIRECT_URI=https://academiapeople.galaxycloud.app/oauth2callback" -ForegroundColor Cyan
Write-Host "GOOGLE_CREDENTIALS_BASE64=$($credentialsBase64.Substring(0,50))..." -ForegroundColor Cyan

Write-Host ""
Write-Host "🎯 DEPLOY RÁPIDO:" -ForegroundColor Green
Write-Host "================" -ForegroundColor Green
Write-Host "1. Abrir Galaxy Cloud" -ForegroundColor White
Write-Host "2. Criar app com as configurações acima" -ForegroundColor White
Write-Host "3. Fazer deploy" -ForegroundColor White
Write-Host "4. Testar em: https://academiapeople.galaxycloud.app" -ForegroundColor Cyan

# Abrir links automaticamente
Write-Host ""
$openLinks = Read-Host "Abrir Galaxy Cloud agora? (s/n)"
if ($openLinks -eq "s" -or $openLinks -eq "S" -or $openLinks -eq "y" -or $openLinks -eq "Y") {
    Write-Host "🌐 Abrindo Galaxy Cloud..." -ForegroundColor Yellow
    Start-Process "https://beta.galaxycloud.app/d/us-east-1"
    Start-Process "https://github.com/dscquanta/google-classroom-manager"
}

Write-Host ""
Write-Host "🔗 Seu app estará em: https://academiapeople.galaxycloud.app" -ForegroundColor Green
Write-Host "📝 Para configurar Google depois: execute setup-google-credentials.ps1" -ForegroundColor Gray
