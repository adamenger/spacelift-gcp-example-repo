# A sample GCP environment w/ Spacelift

This repository provides a sample layout for deploying Spacelift with the use of Service Account Impersonation.

## Why is this important?

The easy option is to give your Spacelift Service Account owner on all projects across your organization. **But don't!**

A better path exists and we hope this repo helps you see how it can be done.

The idea: Limit Spacelift's worker access to its own dedicated project and create a unique service account for every other Spacelift managed project. Then we grant the ability for the Spacelift Worker to impersonate each project account. This approach helps to split permissions into smaller, more manageable parts, rather than granting full access to a single service account.

## Structure

### Modules

In this repo we've published a module under `modules/spacelift-operator`. This module reduces the boilerplate to add the Spacelift Operator account to each project.

You can use it like so:

```
module "spacelift-operator" {
  source = "modules/spacelift-operator"
  project = google_project.project.id
  spacelift_worker_service_account = "spacelift@ac-spacelift.iam.gserviceaccount.com"
  operator_roles = [
    "pubsub.admin",
  ]
}
```

* `spacelift_worker_service_account` - this is set to the email address of the "Spacelift Worker" service account. 
* `operator_roles` - this is the list of roles that we grant to the projects Spacelift Operator account. e.g: if you need to create pubsub topics, use `pubsub.admin` 

See a full list of available roles [here](https://cloud.google.com/iam/docs/understanding-roles) and remember to choose the least permissive role!

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
