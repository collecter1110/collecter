# **Flutter Project**

This repository contains a Flutter-based application and its related backend services.

---

## **Project Overview**

A cross-platform application developed using Flutter, integrated with Supabase, AWS services, and other key technologies to deliver a scalable and robust solution.

---

## **Key Features**
- Cross-platform support for iOS.
- Real-time database updates using Supabase.
- Efficient file storage and retrieval via AWS S3.
- Serverless architecture using AWS Lambda.
- Secure API integration for backend communication.

---

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

---

## **How to Clone and Run**

### **Clone the Repository**
```bash
git clone git@github.com:your-repo/your-flutter-project.git
cd your-flutter-project
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
---

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

---

## **Environment Variables**

### **Set up Environment Variables**

Copy the `.env.example` file to `.env` and update the values:

```bash
cp .env.example .env
```

### **Required variables:**

- `SUPABASE_TEST_URL`: Your Supabase test project URL.
- `SUPABASE_TEST_API_KEY`: Your Supabase test anonymous key.
- `AWS_API_KEY` : API key required when calling AWS Lambda function.

---


## **Branching Strategy**

We use the **Git Flow** branching model:

- `main`: Production-ready code.
- `develop`: Latest development changes.
- Feature branches: `feature/feature-name`.

---

## **Commit Message Guidelines**

Use the following template for consistent commit messages:

$ git config --local commit.template .gitmessage.txt


### **Commit format:**

[TYPE]: [Short description]

[Body: Optional detailed explanation]


### **Types:**

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semi-colons, etc.)
- `refactor`: Code refactoring without adding new features or fixing bugs
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
