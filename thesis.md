# Title Page
**Title:** Conference Management System  
**Author:** [Your Name]  
**Institution:** [Your Institution]  
**Date:** December 11, 2024  

---

# Abstract
This thesis presents the design and implementation of a Conference Management System, which includes a web application for administrators and a mobile application for users. The system aims to streamline the management of conferences, providing features for registration, scheduling, and information dissemination. The findings indicate that the system enhances user experience and administrative efficiency.

---

# Introduction
The management of conferences involves numerous challenges, including participant registration, scheduling, and information sharing. This thesis explores the development of a Conference Management System that addresses these challenges through a dual-interface approach: a web application for administrators and a mobile application for users. The objectives of this thesis are to design, implement, and evaluate the system's effectiveness.

---

# Literature Review
Existing conference management systems often lack user-friendly interfaces and comprehensive features. This section reviews various systems, highlighting their strengths and weaknesses. The analysis reveals a gap in the market for a system that integrates both web and mobile functionalities, which this thesis aims to fill.

---

# System Requirements
## Functional Requirements
- **Web Application:**
  - Admin login and management dashboard
  - Conference creation and editing
  - User registration management
- **Mobile Application:**
  - User login and conference browsing
  - Notifications for updates and schedules

## Non-Functional Requirements
- Performance: The system should handle up to 1000 concurrent users.
- Security: User data must be encrypted and securely stored.
- Usability: The interface should be intuitive and accessible.

---

# System Design
The Conference Management System is designed with a client-server architecture. The web application is built using **React**, while the mobile application is developed using **Flutter**. This section includes architectural diagrams and descriptions of the components.

---

# Implementation
The implementation phase involved using **Flutter** for the mobile application and [Programming Languages] for the web application. This section details the development process, including challenges faced and solutions implemented.

## Mobile Application Overview

The mobile application for the Conference Management System is built using Flutter and integrates with Firebase for backend services. The app is designed to facilitate user authentication, manage conference details, and handle paper submissions effectively.

### Key Components of the Mobile App

1. **Main Application Structure**:
   - The application starts with the `main.dart` file, which initializes Firebase and sets up the main app widget (`MainApp`). This widget serves as the entry point for the application.

2. **User Authentication**:
   - The `AuthService` class handles user authentication using Firebase Authentication. It provides methods to manage user sessions and retrieve user data from Firestore.

3. **User Model**:
   - The `AppUser` class represents a user in the application, including properties such as `id`, `username`, and `favoritePapers`. It includes a factory method to create a user object from Firestore documents.

4. **Conference Management**:
   - The `Conference` class models a conference, with properties for `id`, `name`, `location`, `startDate`, `endDate`, and associated days. This structure allows the app to manage multiple conferences effectively.

5. **Paper Management**:
   - The `Paper` class represents research papers submitted to the conference. It includes properties like `id`, `title`, `abstract`, `authors`, and `keywords`, allowing users to view and manage submissions.

6. **Session Management**:
   - The `Session` class models individual sessions within a conference, including details such as `id`, `title`, `description`, `startTime`, `endTime`, and associated papers and chairpersons.

7. **Screens and Navigation**:
   - The app contains multiple screens organized in directories such as `authenticate`, `authors`, `conferences`, `days`, `favorite_papers`, `home`, `keywords`, `papers`, and `sessions`. Each screen is responsible for different functionalities, such as user authentication, displaying conference details, and managing papers.

---

# Testing
Various testing strategies were employed, including unit testing, integration testing, and user acceptance testing. The results indicate that the system meets the specified requirements and performs reliably under load.

---

# Conclusion
The Conference Management System successfully addresses the needs of both administrators and users. Future work includes expanding features and improving scalability. The findings contribute to the field of conference management by providing a comprehensive solution.

---

# References
[1] Author, A. (Year). Title of the source. Publisher.  
[2] Author, B. (Year). Title of the source. Publisher.  
[3] Author, C. (Year). Title of the source. Publisher.  