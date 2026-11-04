# Activity 3 Progress Report — Draft

**Project:** Batumbakal Gym Membership Management System  
**Group:** 99  
**Members:** Louis Andrei de Guzman; Mark Timothy Casilan  
**Reporting date:** November 4, 2026

## 1. Project overview

The project is a gym membership management system built with Java Spring Boot, PostgreSQL, and a browser interface using HTML, CSS, and JavaScript.

## 2. Implementation progress

The following components have been implemented:

- PostgreSQL database with eight tables and sample records.
- Spring Boot backend with model, repository, service, and controller layers for all eight modules.
- REST endpoints for members, trainers, membership plans, memberships, payments, classes, class enrollments, and attendance.
- Browser interface served from the Spring Boot static resources folder.
- Frontend integration with the eight REST API endpoints.

## 3. Testing performed

Based on the development test session:

- CRUD operations were exercised for all eight backend modules.
- The attendance endpoint was tested with GET, POST, PUT, and DELETE.
- The frontend was opened in a browser and all eight module sections were checked for loading records.

**Evidence to insert:** Add actual screenshots of the running dashboard, each module, representative Postman requests/responses, and PostgreSQL table contents. Do not leave this report as a final submission without evidence required by the instructor.

## 4. Issues encountered and resolutions

- Antivirus protection initially blocked Git/Maven file operations. The project was able to proceed after the blocking issue was resolved.
- The frontend initially returned a 404 because the static files were not in the expected `src/main/resources/static` folder. Moving them to the correct location resolved the issue.
- The application uses environment variables for database credentials in this prepared version. Keep the real password outside the repository.

## 5. Remaining work before final submission

- Capture and insert actual screenshots and relevant test logs.
- Confirm database setup from a clean database using the documented scripts.
- Complete cross-group testing and record the other group's feedback.
- Create/publish the Git repository, invite the required collaborator, and record the actual repository URL.
- Add the actual tracker entry and attach the final PDF report as required.

## 6. AI assistance declaration

AI assistance was used during development for code scaffolding, troubleshooting, and documentation preparation. The project members should review, understand, run, and verify all submitted code and documentation, and should disclose the assistance in the format required by the instructor.

## 7. Cross-group testing record

**Status:** Not yet recorded in this draft.  
**Other group / tester:** [Fill in after testing]  
**Date:** [Fill in]  
**Tested features:** [Fill in]  
**Issues found:** [Fill in]  
**Resolutions / feedback:** [Fill in]

---
This is a progress-report draft, not proof that the remaining activities have been completed. Replace placeholders with actual screenshots, logs, repository details, tracker information, and cross-group test results before submission.
