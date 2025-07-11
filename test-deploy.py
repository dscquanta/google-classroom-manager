#!/usr/bin/env python3
"""
Simple deployment test for Google Classroom Manager
"""
import os
import sys

print("🐍 Testing Python Flask App Deployment")
print("======================================")

# Test imports
try:
    import flask
    print(f"✅ Flask {flask.__version__} - OK")
except ImportError:
    print("❌ Flask not installed")
    sys.exit(1)

try:
    import google.auth
    print("✅ Google Auth - OK")
except ImportError:
    print("❌ Google Auth not installed")

try:
    from googleapiclient.discovery import build
    print("✅ Google API Client - OK")
except ImportError:
    print("❌ Google API Client not installed")

# Test webapp.py
try:
    import webapp
    print("✅ webapp.py imports successfully")
except Exception as e:
    print(f"❌ webapp.py error: {e}")

print("\n🌐 Deployment Info:")
print("==================")
print("App Type: Python Flask Web Application")
print("Entry Point: webapp.py")
print("Server: Gunicorn (for production)")
print("Port: 8080 (Galaxy Cloud)")

print("\n📋 Galaxy Cloud Setup:")
print("======================")
print("Repository: dscquanta/google-classroom-manager")
print("Branch: master")
print("Build Command: pip install -r requirements.txt")
print("Start Command: gunicorn webapp:app --bind 0.0.0.0:$PORT")

print("\n🔗 App URL: https://academiapeople.galaxycloud.app")
print("📖 Ready for deployment!")
