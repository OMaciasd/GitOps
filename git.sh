#!/bin/bash

# ADD AZURE DEVOPS REPOS - ENVs.
NAME=""
ORGANIZATION=""
PROJECT="%20"
REPO_NAME="-$NAME"
REPO_FUNCTIONS="$REPO_NAME-"
PAT=""
PROJECT_ID=$(curl -H "Authorization: Basic $(echo -n ":$PAT" | base64)" "https://dev.azure.com/$ORGANIZATION/_apis/projects?api-version=6.0")

curl -u ":$PAT" -X POST -H "Content-Type: application/json" -d "{\"name\":\"$REPO_NAME\"}" https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories?api-version=6.0
REPO_ID=$(curl -u :$PAT https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories/$REPO_NAME?api-version=6.0 | jq -r '.id')

# ADD FUNCTIONS REPOS.
curl -u ":$PAT" -X POST -H "Content-Type: application/json" -d "{\"name\":\"$REPO_FUNCTIONS\"}" https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories?api-version=6.0
REPO_ID=$(curl -u :$PAT https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories/$REPO_FUNCTIONS?api-version=6.0 | jq -r '.id')
GROUP_DESCRIPTOR=$(curl -u :$PAT -X POST -H "Content-Type: application/json" --data '{"principalName":"developers", "origin": "vsts"}' https://vsaex.dev.azure.com/$ORGANIZATION/_apis/GroupEntitlements?api-version=5.1-preview.1 | jq -r '.descriptor')

# Define el token de seguridad para el repositorio (formato general)
SECURITY_NAMESPACE="repoV2"
TOKEN="repoV2/$PROJECT/$REPO_ID"

# Asigna permisos para "Contribute to pull requests". 
PERMISSION_ID="b7e84409-6553-48a0-a36d-26d01f1f46e8" # Asume "Contribute to pull requests"
ALLOW_BIT=4

curl -s -u :$PAT -X POST -H "Content-Type: application/json" \
-d '[
      {
        "accessControlEntries": [
          {
            "descriptor": "'$GROUP_DESCRIPTOR'",
            "allow": '$ALLOW_BIT',
            "deny": 0,
            "extendedInfo": {
              "effectiveAllow": '$ALLOW_BIT',
              "effectiveDeny": 0,
              "inheritedAllow": '$ALLOW_BIT',
              "inheritedDeny": 0
            }
          }
        ],
        "token": "'$TOKEN'",
        "tokenDisplayName": "'$REPO_FUNCTIONS'"
      }
    ]' \
"https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/accesscontrolentries/$SECURITY_NAMESPACE?api-version=6.0"

curl -s -u :$PAT -X POST -H "Content-Type: application/json" \
"https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories/$REPO_ID/permissions?api-version=6.0" \
-d '{
    "permissions": [
        {
            "identityDescriptor": "'$GROUP_DESCRIPTOR'",
            "allowContribute": true,
            "allowContributeToPullRequest": true
        }
    ]
}'

# TROUBLESHOOTING.
REPO_INFO=$(curl -s -u :$PAT "https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/git/repositories/$REPO_FUNCTIONS?api-version=6.0")

# Extraer el ID del repositorio del resultado
REPO_ID=$(echo $REPO_INFO | jq -r '.id')
echo "ID del Repositorio: $REPO_ID"

curl -u :$PAT "https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/teams?api-version=6.0"

curl -H "Authorization: Basic "$PAT_64" https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/teams?api-version=6.0

curl -H "Authorization: Basic $(echo -n ":$PAT" | base64)" "https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/pipelines/45?revision=2"

curl -H "Authorization: Basic $(echo -n ":$PAT" | base64)" "https://dev.azure.com/$ORGANIZATION/$PROJECT_ID/_apis/projects/$PROJECT_ID/teams?api-version=6.0"
