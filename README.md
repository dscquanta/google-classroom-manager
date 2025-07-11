# Google Classroom Manager

A Flask web application for managing Google Classroom courses, assignments, and students.

## Features

- **OAuth 2.0 Authentication** with Google
- **Course Management** - View all your Google Classroom courses
- **Assignment Tracking** - Monitor assignments and submissions
- **Student Management** - View student rosters and progress
- **Responsive Design** - Works on desktop and mobile devices

## Setup Instructions

### 1. Prerequisites

- Python 3.8 or higher
- Google Cloud Console account
- Google Classroom API enabled

### 2. Google Cloud Console Setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Classroom API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Classroom API"
   - Click "Enable"

4. Create OAuth 2.0 credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth 2.0 Client IDs"
   - Configure the consent screen if prompted
   - Choose "Web application"
   - Add authorized redirect URIs:
     - `http://localhost:5000/callback` (for local development)
     - `https://yourdomain.com/callback` (for production)

5. Download the credentials JSON file and save it as `credentials.json` in the project root

### 3. Installation

1. Clone or download this project
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Set environment variables:
   ```bash
   # Windows (PowerShell)
   $env:SECRET_KEY="your-secret-key-here"
   $env:REDIRECT_URI="http://localhost:5000/callback"
   
   # Linux/Mac
   export SECRET_KEY="your-secret-key-here"
   export REDIRECT_URI="http://localhost:5000/callback"
   ```

### 4. Running the Application

**Development:**
```bash
python webapp.py
```

**Production (using Gunicorn):**
```bash
gunicorn webapp:app
```

The application will be available at `http://localhost:5000`

## File Structure

```
googleclassroom/
├── webapp.py              # Main Flask application
├── requirements.txt       # Python dependencies
├── Procfile              # Heroku deployment file
├── credentials.json      # Google OAuth credentials (not included)
├── templates/            # HTML templates
│   ├── base.html
│   ├── login.html
│   ├── dashboard.html
│   ├── course_details.html
│   ├── assignment_details.html
│   └── error.html
└── README.md
```

## API Endpoints

- `GET /` - Home page/Dashboard
- `GET /login` - Initiate Google OAuth flow
- `GET /callback` - OAuth callback handler
- `GET /course/<course_id>` - Course details and assignments
- `GET /assignment/<course_id>/<assignment_id>` - Assignment submissions
- `GET /logout` - Logout and clear session
- `GET /api/courses` - JSON API for courses

## Deployment

### Heroku

1. Create a Heroku app
2. Set environment variables in Heroku dashboard
3. Add your Heroku app URL to Google OAuth redirect URIs
4. Deploy using Git or GitHub integration

### Other Platforms

The app uses standard Flask deployment practices and can be deployed to:
- Azure App Service
- AWS Elastic Beanstalk
- Google App Engine
- DigitalOcean App Platform

## Security Notes

- Keep your `credentials.json` file secure and never commit it to version control
- Use strong secret keys in production
- Configure HTTPS for production deployments
- Review Google API quotas and limits

## Troubleshooting

1. **Import errors**: Make sure all dependencies are installed with `pip install -r requirements.txt`
2. **OAuth errors**: Check that your redirect URI matches exactly in Google Console
3. **API errors**: Ensure Google Classroom API is enabled and you have proper permissions
4. **Session issues**: Check that SECRET_KEY is set and consistent

## License

This project is provided as-is for educational purposes.
