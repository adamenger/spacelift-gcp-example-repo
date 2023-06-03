# GCP Organization Test Environment
This is a quick example repo of how you could deploy Spacelift to utilize Service Account Impersonation.

# Why does this matter?
At the time of writing spacelift docs suggest creating an org wide service account that has owner permissions on all projects. I suspect organizations have followed this pattern and I would like to offer an alternative. The TLDR of my suggestion is that we should isolate spacelift resources in its own project. Then, we should create an operator service account which only has permissions to impersonate other project service accounts. Next, we create a spacelift service account that is only used during project creation. Finally, we create a service account in each project which can manage the project but do nothing outside of it. This helps us break down the permission structure into more managable chunks as opposed to giving a single service account org wide permissions. 

# Layout

## organization/
This is where I store org settings to give permissions to the Spacelift service accounts. You'll notice that "Spacelift Operator" service account gets no permissions on the org. Only the "Spacelift Project Creator" which is only toggled on to create projects and then swapped out once we're done.

## projects/
This folder contains projects which are their own stacks in Spacelift.

### ac-spacelift
This is the project where spacelift is deployed to. We set up a gke cluster and then deploy the Spacelift helm chart. 

Then we create two service accounts. "Spacelift Operator" and "Spacelift Project Creator". The operator service account is the one that performs the impersonation and is the account that is attached to the k8s pods using Workload Identity. The "Spacelift Project Creator" service account is only used during project creation since it requires org access to create the project, create the projects spacelift operator service account and do some IAM policy setting. 

Once the project is created, we update the provider settings to use the operator service account. The reason we do this is because the "Project Creator" wields org wide permissions to create and modify service accounts and their associated IAM policies. Nothing should carry these permissions long term. When we swap the `impersonated_service_account` in the `provider.tf` to use the projects Operator account, we avoid potential abuse of these extraneous permissions.

### ac-test-1
This is where we test out service account impersonation. We create a blank project with a few enabled API's, create a service account and then allow the Spacelift Service Account which lives in `ac-spacelift` permission to impersonate the `spacelift-operator` service account which lives in `ac-test-1`.
