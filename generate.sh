#!/usr/bin/env sh
openssl req -new -newkey rsa:4096 -nodes -keyout spacelift.key -out spacelift.csr -subj '/CN=spacelift.test/O=Spacelift Test/C=US'
