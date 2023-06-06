#!/usr/bin/env sh
KEY=$(cat spacelift.key | base64 -w 0)
TOKEN=$(cat spacelift.token)
gcloud container clusters get-credentials spacelift-test --project ac-spacelift --location us-central1
helm upgrade spacelift-worker spacelift/spacelift-worker --install --set "credentials.token=$TOKEN,credentials.privateKey=$KEY" --recreate-pods -f values.yml
