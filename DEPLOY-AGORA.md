# 🚀 DEPLOY AGORA - PYTHON FLASK APP

## ✅ CONFIRMADO: Seu app Python está funcionando!
- ✅ Python 3.11.9 
- ✅ Flask 3.1.1
- ✅ Google APIs
- ✅ Todas as dependências instaladas
- ✅ webapp.py funcionando

## 🎯 DEPLOYMENT GALAXY CLOUD - PASSO A PASSO

### 1. Abrir Galaxy Cloud
**Link:** https://beta.galaxycloud.app/d/us-east-1

### 2. Criar Novo App
- Clique: **"New App"**
- Escolha: **"Deploy from GitHub"**

### 3. Configuração do Repositório
```
Repository: dscquanta/google-classroom-manager
Branch: master
App Name: academiapeople (ou qualquer nome)
```

### 4. Configuração de Build
```
Build Command: pip install -r requirements.txt
Start Command: gunicorn webapp:app --host=0.0.0.0 --port=$PORT
```

### 5. Variáveis de Ambiente
**Copie e cole EXATAMENTE estas variáveis:**

```
SECRET_KEY=MfR0745Ul7Fo96MA8btNzkYJ9wOtQD3W2Bdg89MyAtYvFUVQjhhxg4MvLpINhwqy
FLASK_ENV=production
PORT=8080
REDIRECT_URI=https://academiapeople.galaxycloud.app/oauth2callback
GOOGLE_CREDENTIALS_BASE64=ew0KICAid2ViIjogew0KICAgICJhdXRoX3Byb3ZpZGVyX3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vb2F1dGgyL3YxL2NlcnRzIiwNCiAgICAicHJvamVjdF9pZCI6ICJ0ZW1wLXByb2plY3QiLA0KICAgICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsDQogICAgImNsaWVudF9zZWNyZXQiOiAiVEVNUF9DTElFTlRfU0VDUkVUIiwNCiAgICAidG9rZW5fdXJpIjogImh0dHBzOi8vb2F1dGgyLmdvb2dsZWFwaXMuY29tL3Rva2VuIiwNCiAgICAiY2xpZW50X2lkIjogIlRFTVBfQ0xJRU5UX0lEIiwNCiAgICAicmVkaXJlY3RfdXJpcyI6IFsNCiAgICAgICJodHRwczovL2FjYWRlbWlhcGVvcGxlLmdhbGF4eWNsb3VkLmFwcC9vYXV0aDJjYWxsYmFjayINCiAgICBdDQogIH0NCn0=
```

### 6. Deploy
- Clique: **"Deploy"**
- Aguarde alguns minutos

## 🎉 RESULTADO
**Seu app Python estará rodando em:**
https://academiapeople.galaxycloud.app

## 🔧 Se der erro:
1. Verifique se todas as variáveis foram copiadas corretamente
2. Confirme que o repositório está correto: `dscquanta/google-classroom-manager`
3. Branch deve ser: `master`

## 📱 Como testar:
1. Acesse: https://academiapeople.galaxycloud.app
2. Você verá a página inicial do Google Classroom Manager
3. O app Python Flask estará funcionando!

---
**NOTA:** Este é um app Python Flask completo com interface web responsiva! 🐍✨
