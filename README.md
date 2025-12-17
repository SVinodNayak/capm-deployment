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
2. Add sample data and verify that it is exposing correctly when run locally.  

**Note:** Writing the required access roles in your `srv` file automatically adds them to `xs-security.json`.  

---

## Deployment Steps

### Step 1: Add HANA Database Configuration
```
cds add hana --production
This configures your project to connect with the HANA database in production mode.
```

### Step 2: Add XSUAA Security Configuration
```
cds add xsuaa
```
This creates the xs-security.json file with default scopes, attributes, and role templates.

Update the xs-security.json file with the following configuration:
```

  "xsappname": "YOUR_APP_NAME",
  "tenant-mode": "dedicated",
```
and
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

### Step 3: Add MTA Configuration
```
cds add mta
```
This will create the mta.yaml file required for deployment.

### Step 4: Build and Deploy the Project
Login to Cloud Foundry
```
cf login
```
Build MTA Project

Right-click the mta.yaml file and select Build MTA Project, OR
```
mbt build -p cf
```
Wait for the mta_archives folder to be created. Once the .mtar file is available:

Deploy the MTA
```
cf deploy mta_archives/*.mtar
```
Check Logs on Deployment Errors
```
cf logs SERVICE_NAME --recent
```
Replace SERVICE_NAME with the actual service name to check logs.

**Notes & Tips**
- Ensure that your db and srv layers are working locally before deploying.

- Always verify that the scopes and role templates in xs-security.json match your service access requirements.

- If deployment fails, check the logs using cf logs <SERVICE_NAME> --recent to identify the error.

- Use mbt clean before rebuilding if you encounter build issues.

### After Successful Deployment.
1. You will find two instances created under the instances section in your BTP account.
    ->  *-auth
    ->  *-db
2. Before you access the srv URL you must assign the roles to the user.
3. Go to role collection in your BTP platform. In here you will find the role collections that are generated automatically based on your "xs-security.json" file.
4. Assign that role to the user under the user section of you BTP account.
5. Open your spaces in BTP where you can find the URL of the srv.
6. Opening it will display your inital page (contains services, metadata...).
7. If the intial page is not shown, please refer the possible erros section.


