#!/bin/bash
: "
This script copies over just the config files located in the git repo into your vault.
"

vault_path="/c/Users/Ryan/Documents/master_v1"

git clean -fdx
cp -a . $vault_path/.

