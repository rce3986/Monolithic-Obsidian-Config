#!/bin/bash
: "
Modifications to obsidian config are made in the app in the master vault.
This script copies over the entire vault to get an updated config before adding to source control.

Make sure you avoid adding any non-config files to source control after copying vault contents.
"

vault_path="/c/Users/Ryan/Documents/master_v1"

cp -a $vault_path/. .

