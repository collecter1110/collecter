# **Collecter**

This repository contains a Flutter-based application and its related backend services.

&nbsp;

## **Project Overview**

A cross-platform application developed using Flutter, integrated with Supabase, AWS services, and other key technologies to deliver a scalable and robust solution.

&nbsp;

## **Key Features**
- Cross-platform support for iOS.
- Real-time database updates using Supabase.
- Efficient file storage and retrieval via AWS S3.
- Serverless architecture using AWS Lambda.
- Secure API integration for backend communication.

&nbsp;

## **Technologies Used**

### **Frontend**
- **Framework**: Flutter  
  - Cross-platform UI framework for building natively compiled apps.
- **State Management**: `Provider` / `get_it` 
- **UI Components**: Material Design / Custom Widgets.

### **Backend & Cloud**
- **Database**: PostgreSQL (managed by Supabase).
- **Cloud Services**:
  - Supabase for real-time database and authentication.
  - AWS S3 for storage and file management.
  - AWS Lambda for serverless middleware logic and environment variable management.
- **API Framework**: RESTful API.

### **Deployment**
- **Hosting**: AWS services and GitHub Actions for CI/CD.

### **Error Tracking**
- **Monitoring**: Sentry

&nbsp;

## **How to Clone and Run**

### **Clone the Repository**
```bash
git clone https://github.com/collecter1110/collecter.git
cd collecter
```

### **Install Dependencies**
```bash
flutter pub get
```

### **Run the Project**
```bash
flutter run
```

### **Build the App**
```bash
flutter build ios
```

&nbsp;

## **Project File structure**


```bash
.
├── assets
├── lib
│   ├── components        # Block Editor
│   │   ├── data          # Static assets
│   │   └── page             # Source code
│   │       ├── apis
│   │       ├── components
│   │       │   ├── common  # Common components that are used in multiple pages
│   │       │   ├── layouts # Layout components
│   │       │   └── parts   # Parts components that are used in a specific page
│   │       ├── fonts
│   │       ├── hooks
│   │       └── stores
│   ├── main.dart 
│   └── page_navigator.dart
│       
├── eslint-config
└── README.md
```

&nbsp;

## **Environment Variables**

### **Set up Environment Variables**

Copy the `.env.example` file to `assets/config/.env` and update the values:

```bash
cp .env.example assets/config/.env
```

### **Required variables:**

- `SUPABASE_TEST_URL`: Your Supabase test project URL.
- `SUPABASE_TEST_API_KEY`: Your Supabase test anonymous key.
- `AWS_API_KEY` : API key required when calling AWS Lambda function.

&nbsp;

## **Branching Strategy**

We use the Git Flow branching model with the following process:

- `main`: Contains production-ready code. This branch is updated only after app updates are completed.
- `dev`: The primary development branch where all feature branches are merged.
- `feature/feature-name`: Use the naming convention feature branch. These branches are created from the main branch and merged into the dev branch during development.

&nbsp;

## **Commit format**

### **Title**
[TYPE] : [Short description]

### **Types**

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semi-colons, etc.)
- `refactor`: Code refactoring without adding new features or fixing bugs
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### **Body**
[TASK-(TASK_ID)](Notion link)



