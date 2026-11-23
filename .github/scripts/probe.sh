#!/bin/bash
# Calls the REST API with GH_TOKEN and prints, per endpoint, the HTTP status and the
# X-Accepted-GitHub-Permissions header. Used by probe-permissions.yml.
api() {
  curl -sS -D hdr.txt -o body.json \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/repos/$REPO$1"
  status=$(head -1 hdr.txt | tr -d '\r')
  perm=$(grep -i '^x-accepted-github-permissions:' hdr.txt | cut -d' ' -f2- | tr -d '\r')
  msg=$(jq -r 'if type=="object" then (.message // "") else "" end' body.json 2>/dev/null)
  echo "PROBE set=$SET | $1 | $status | accepted=[$perm] | message=[$msg]"
}
dep=$(curl -sS -H "Authorization: Bearer $GH_TOKEN" "https://api.github.com/repos/$REPO/deployments?environment=github-pages" | jq -r 'if type=="array" then (.[0].id // "none") else "none" end')
api /pages
api /pages/builds
api /pages/builds/latest
api "/deployments?environment=github-pages"
api "/deployments/$dep"
api "/deployments/$dep/statuses"
api /actions/variables
api /actions/variables/API_URL
api /contents/.github/workflows
api /contents/.github/workflows/deploy.yml
api /environments
api /environments/github-pages
api /environments/github-pages/deployment-branch-policies
api /actions/runs
api /actions/workflows
api ""
