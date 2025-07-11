#!/usr/bin/env python3
"""
Entry point for the Google Classroom Manager Flask app
Works with both Gunicorn (Linux) and Waitress (Windows)
"""
import os
import sys
from webapp import app

if __name__ == '__main__':
    # Get port from environment
    port = int(os.environ.get('PORT', 8080))
    
    # Production server selection based on platform
    if sys.platform == 'win32':
        # Use Waitress for Windows (Galaxy Cloud might use Windows containers)
        from waitress import serve
        print(f"Starting Waitress server on port {port}")
        serve(app, host='0.0.0.0', port=port)
    else:
        # Use Gunicorn for Linux
        print(f"Starting app on port {port}")
        app.run(host='0.0.0.0', port=port, debug=False)
