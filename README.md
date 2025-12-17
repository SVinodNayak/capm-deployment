# CAPM Project Deployment Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Deployment Steps](#deployment-steps)
   - [Step 1: Add HANA Database Configuration](#step-1-add-hana-database-configuration)
   - [Step 2: Add XSUAA Security Configuration](#step-2-add-xsuaa-security-configuration)
   - [Step 3: Add MTA Configuration](#step-3-add-mta-configuration)
   - [Step 4: Build and Deploy the Project](#step-4-build-and-deploy-the-project)
3. [Notes & Tips](#notes--tips)

---

## Prerequisites
1. Create a CAPM project with the following structure:
   - `db` (schema)
   - `srv` (service)
   - Add sample data and verify that it is exposing correctly when run locally.  

**Note:** Writing the required access roles in your `srv` file automatically adds them to `xs-security.json`.  

---

## Deployment Steps

### Step 1: Add HANA Database Configuration
```bash
cds add hana --production
Step 2: Add XSUAA Security Configuration
cds add xsuaa


This creates the xs-security.json file with default scopes, attributes, and role templates.

Update the xs-security.json file with the following configurations:
```{
  "xsappname": "YOUR_APP_NAME",
  "tenant-mode": "dedicated",```
```
  "authorities": [
    "$ACCEPT_GRANTED_AUTHORITIES"
  ],
  "oauth2-configuration": {
    "token-validity": 9000,
    "redirect-uris": [
      "https://*.cfapps.us10-001.hana.ondemand.com/login/callback"
    ]
  },
  "xsenableasyncservice": "true"
```

Replace YOUR_APP_NAME with the actual name of your application.

Step 3: Add MTA Configuration
cds add mta


This will create the mta.yaml file required for deployment.

Step 4: Build and Deploy the Project

Login to Cloud Foundry

cf login


Build MTA Project

Right-click the mta.yaml file and select Build MTA Project, OR

mbt build -p cf


Wait for the mta_archives folder to be created. Once the .mtar file is available:

Deploy the MTA

cf deploy mta_archives/*.mtar


Check Logs on Deployment Errors

cf logs SERVICE_NAME --recent


Replace SERVICE_NAME with the actual service name to check logs.

Notes & Tips

Ensure that your db and srv layers are working locally before deploying.

Always verify that the scopes and role templates in xs-security.json match your service access requirements.

If deployment fails, check the logs using cf logs <SERVICE_NAME> --recent to identify the error.

Use mbt clean before rebuilding if you encounter build issues.

For multi-environment deployment, consider creating separate XSUAA instances and HANA configurations.
