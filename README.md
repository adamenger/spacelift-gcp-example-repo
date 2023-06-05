# Simplified GCP Organization Test Environment

This repository provides a sample layout for deploying Spacelift with the use of Service Account Impersonation.

## Why is this important?

The easy option is to give your Spacelift Service Account owner on all projects across your organization.

**But don't!:**

A better path exists: 

Limit Spacelift's worker access to its own dedicated project, and create a unique service account for each other project. Then we grant the ability for the Spacelift Worker to impersonate each project account. This approach helps to split permissions into smaller, more manageable parts, rather than granting full access to a single service account.

## Structure

### Organization Folder

This folder contains the settings for assigning permissions to Spacelift service accounts. Note that the "Spacelift Operator" service account doesn't have any permissions at the organization level. Only the "Spacelift Project Creator" has permission and is activated only when creating new projects.

### Projects Folder

This folder holds individual projects, each of which is a unique Spacelift stack.

#### Spacelift Project (ac-spacelift)

This project is where Spacelift gets deployed. We set up a GKE cluster and deploy the Spacelift Helm chart. 

#### Service Accounts

This project gets a number of service accounts which have specific uses that are detailed below.

##### k8s node
This is the minimally permissive service account that the kubernetes nodes will run as.

##### Spacelift Project Creator

##### Spacelift Worker
This service account is used to perform impersonation and is the service account that all Spacelift runs will execute as. The only permission this service account carries long term is the ability to Impersonate project Spacelift Operator accounts.


#### Test Project (ac-test-1)

This project is used for testing service account impersonation. We create a basic project, enable a few APIs, create a service account, and allow the Spacelift Service Account in the `ac-spacelift` project to impersonate the `spacelift-operator` service account in `ac-test-1`. 
