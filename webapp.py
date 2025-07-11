from flask import Flask, render_template, request, redirect, url_for, session, jsonify
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import Flow
from googleapiclient.discovery import build
import os
import json
import base64
import sys

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'your-secret-key-here')

# Add debug info for deployment
print(f"Flask app starting...")
print(f"Python version: {sys.version}")
print(f"PORT: {os.environ.get('PORT', 'Not set')}")
print(f"FLASK_ENV: {os.environ.get('FLASK_ENV', 'Not set')}")
print(f"REDIRECT_URI: {os.environ.get('REDIRECT_URI', 'Not set')}")
print(f"SECRET_KEY: {'Set' if os.environ.get('SECRET_KEY') else 'Not set'}")
print(f"GOOGLE_CREDENTIALS_BASE64: {'Set' if os.environ.get('GOOGLE_CREDENTIALS_BASE64') else 'Not set'}")

# --- Google API Setup ---
SCOPES = [
    'https://www.googleapis.com/auth/classroom.courses.readonly',
    'https://www.googleapis.com/auth/classroom.rosters.readonly',
    'https://www.googleapis.com/auth/classroom.coursework.students.readonly',
    'https://www.googleapis.com/auth/classroom.profile.emails'
]

CLIENT_SECRETS_FILE = 'credentials.json'
REDIRECT_URI = os.environ.get('REDIRECT_URI', 'http://localhost:5000/callback')

# Handle Google credentials from environment variable for Heroku
def get_google_credentials_file():
    """Get Google credentials file path or create from environment variable."""
    if os.path.exists(CLIENT_SECRETS_FILE):
        return CLIENT_SECRETS_FILE
    
    # Try to get credentials from environment variable (for Heroku)
    credentials_base64 = os.environ.get('GOOGLE_CREDENTIALS_BASE64')
    if credentials_base64:
        try:
            credentials_json = base64.b64decode(credentials_base64).decode('utf-8')
            with open(CLIENT_SECRETS_FILE, 'w') as f:
                f.write(credentials_json)
            return CLIENT_SECRETS_FILE
        except Exception as e:
            print(f"Error decoding credentials from environment: {e}")
    
    return CLIENT_SECRETS_FILE  # Return default path anyway

@app.route('/health')
def health():
    """Health check endpoint for debugging"""
    return jsonify({
        'status': 'healthy',
        'python_version': sys.version,
        'port': os.environ.get('PORT', 'Not set'),
        'flask_env': os.environ.get('FLASK_ENV', 'Not set'),
        'redirect_uri': os.environ.get('REDIRECT_URI', 'Not set'),
        'secret_key_set': bool(os.environ.get('SECRET_KEY')),
        'google_credentials_set': bool(os.environ.get('GOOGLE_CREDENTIALS_BASE64')),
        'credentials_file_exists': os.path.exists(CLIENT_SECRETS_FILE)
    })

@app.route('/')
def index():
    """Home page"""
    if 'credentials' not in session:
        return render_template('login.html')
    
    try:
        credentials = Credentials(**session['credentials'])
        service = build('classroom', 'v1', credentials=credentials)
        
        # Get courses
        results = service.courses().list(pageSize=10).execute()
        courses = results.get('courses', [])
        
        return render_template('dashboard.html', courses=courses)
    except Exception as e:
        return render_template('error.html', error=str(e))

@app.route('/login')
def login():
    """Initiate Google OAuth flow"""
    credentials_file = get_google_credentials_file()
    flow = Flow.from_client_secrets_file(
        credentials_file,
        scopes=SCOPES,
        redirect_uri=url_for('oauth2callback', _external=True)
    )
    
    authorization_url, state = flow.authorization_url(
        access_type='offline',
        include_granted_scopes='true'
    )
    
    session['state'] = state
    return redirect(authorization_url)

@app.route('/oauth2callback')
def oauth2callback():
    """Callback route that Google redirects to after authentication."""
    state = session['state']
    credentials_file = get_google_credentials_file()
    flow = Flow.from_client_secrets_file(
        credentials_file,
        scopes=SCOPES,
        state=state,
        redirect_uri=url_for('oauth2callback', _external=True)
    )
    
    flow.fetch_token(authorization_response=request.url)
    
    credentials = flow.credentials
    session['credentials'] = {
        'token': credentials.token,
        'refresh_token': credentials.refresh_token,
        'token_uri': credentials.token_uri,
        'client_id': credentials.client_id,
        'client_secret': credentials.client_secret,
        'scopes': credentials.scopes
    }
    
    return redirect(url_for('index'))

@app.route('/course/<course_id>')
def course_details(course_id):
    """Show course details and assignments"""
    if 'credentials' not in session:
        return redirect(url_for('login'))
    
    try:
        credentials = Credentials(**session['credentials'])
        service = build('classroom', 'v1', credentials=credentials)
        
        # Get course info
        course = service.courses().get(id=course_id).execute()
        
        # Get course work
        coursework = service.courses().courseWork().list(courseId=course_id).execute()
        assignments = coursework.get('courseWork', [])
        
        # Get students
        students = service.courses().students().list(courseId=course_id).execute()
        student_list = students.get('students', [])
        
        return render_template('course_details.html', 
                             course=course, 
                             assignments=assignments,
                             students=student_list)
    except Exception as e:
        return render_template('error.html', error=str(e))

@app.route('/assignment/<course_id>/<assignment_id>')
def assignment_details(course_id, assignment_id):
    """Show assignment submissions"""
    if 'credentials' not in session:
        return redirect(url_for('login'))
    
    try:
        credentials = Credentials(**session['credentials'])
        service = build('classroom', 'v1', credentials=credentials)
        
        # Get assignment info
        assignment = service.courses().courseWork().get(
            courseId=course_id, 
            id=assignment_id
        ).execute()
        
        # Get submissions
        submissions = service.courses().courseWork().studentSubmissions().list(
            courseId=course_id,
            courseWorkId=assignment_id
        ).execute()
        
        submission_list = submissions.get('studentSubmissions', [])
        
        return render_template('assignment_details.html',
                             assignment=assignment,
                             submissions=submission_list,
                             course_id=course_id)
    except Exception as e:
        return render_template('error.html', error=str(e))

@app.route('/logout')
def logout():
    """Logout and clear session"""
    session.clear()
    return redirect(url_for('index'))

@app.route('/api/courses')
def api_courses():
    """API endpoint to get courses"""
    if 'credentials' not in session:
        return jsonify({'error': 'Not authenticated'}), 401
    
    try:
        credentials = Credentials(**session['credentials'])
        service = build('classroom', 'v1', credentials=credentials)
        
        results = service.courses().list().execute()
        courses = results.get('courses', [])
        
        return jsonify({'courses': courses})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Production configuration - runs when imported by Gunicorn
def configure_app():
    """Configure app for production deployment"""
    # Only set insecure transport for local development
    if os.environ.get('FLASK_ENV') == 'development':
        os.environ['OAUTHLIB_INSECURE_TRANSPORT'] = '1'

# Configure the app when module is imported
configure_app()

if __name__ == '__main__':
    # For local development only
    port = int(os.environ.get('PORT', 5000))
    os.environ['OAUTHLIB_INSECURE_TRANSPORT'] = '1'  # Allow HTTP for local dev
    
    app.run(
        debug=True, 
        host='0.0.0.0', 
        port=port
    )
