#!/usr/bin/env sh
helm upgrade spacelift-worker spacelift/spacelift-worker --install --set "credentials.token=$TOKEN,credentials.privateKey=$KEY" --recreate-pods -f values.yaml
