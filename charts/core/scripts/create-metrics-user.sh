#!/usr/bin/env sh
set -exo pipefail

if [ -z "$SERVICE_URL" ] || [ -z "$ADMIN_USERNAME" ] || [ -z "$ADMIN_PASSWORD" ] || [ -z "$METRICS_USERNAME" ] || [ -z "$METRICS_PASSWORD" ]; then
  echo "Error: Required environment variables are not set. Please set SERVICE_URL, ADMIN_USERNAME, ADMIN_PASSWORD, METRICS_USERNAME, METRICS_PASSWORD."
  exit 1
fi

echo "Waiting for DHIS2 service to be ready... $SERVICE_URL"
curl --fail --silent --show-error --output /dev/null --retry 100 --retry-delay 6 --retry-connrefused "$SERVICE_URL"
echo "DHIS2 service is ready."

# Check if user already exists
existing_user=$(curl --fail --silent --show-error --location \
  --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
  "$SERVICE_URL/api/users?fields=id&filter=username:eq:$METRICS_USERNAME")

user_id=$(echo "$existing_user" | jq -r '.users[0].id')

if [ -n "$user_id" ] && [ "$user_id" != "null" ]; then
  echo "Metrics user '$METRICS_USERNAME' already exists (id: $user_id). Skipping creation."
  exit 0
fi

echo "Creating metrics user '$METRICS_USERNAME'..."

# Fetch Superuser role ID (has ALL authority)
echo "Fetching Superuser role..."
superuser_role=$(curl --fail --silent --show-error --location \
  --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
  "$SERVICE_URL/api/userRoles?filter=name:eq:Superuser&fields=id&pageSize=1")
superuser_role_id=$(echo "$superuser_role" | jq -r '.userRoles[0].id')

if [ -z "$superuser_role_id" ] || [ "$superuser_role_id" = "null" ]; then
  echo "Error: Could not find 'Superuser' role. Available roles:"
  curl --fail --silent --show-error --location \
    --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
    "$SERVICE_URL/api/userRoles?fields=id,name" | jq '.userRoles[] | {id, name}'
  exit 1
fi
echo "Found Superuser role: $superuser_role_id"
user_roles=$(jq -n --arg id "$superuser_role_id" '[{"id": $id}]')

# Fetch first available organisation unit
echo "Fetching organisation unit..."
org_response=$(curl --fail --silent --show-error --location \
  --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
  "$SERVICE_URL/api/organisationUnits?fields=id,name&pageSize=1")
org_id=$(echo "$org_response" | jq -r '.organisationUnits[0].id')

if [ -z "$org_id" ] || [ "$org_id" = "null" ]; then
  echo "No organisation units found. Creating a default root (blsq) org unit..."
  create_org_response=$(curl --fail --silent --show-error --location \
    --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
    --request POST "$SERVICE_URL/api/organisationUnits" \
    --header "Content-Type: application/json" \
    --data '{"name": "blsq", "shortName": "blsq", "openingDate": "1970-01-01"}')
  org_id=$(echo "$create_org_response" | jq -r '.response.uid')
  if [ -z "$org_id" ] || [ "$org_id" = "null" ]; then
    echo "Error: Failed to create default org unit."
    echo "Response: $create_org_response"
    exit 1
  fi
  echo "Created default org unit: $org_id"
  org_units=$(jq -n --arg id "$org_id" '[{"id": $id}]')
else
  echo "Using org unit: $org_id"
  org_units=$(jq -n --arg id "$org_id" '[{"id": $id}]')
fi

payload=$(jq -n \
  --arg firstName "${METRICS_FIRST_NAME:-Metrics}" \
  --arg surname "${METRICS_SURNAME:-User}" \
  --arg username "$METRICS_USERNAME" \
  --arg password "$METRICS_PASSWORD" \
  --argjson userRoles "$user_roles" \
  --argjson organisationUnits "$org_units" \
  '{
    firstName: $firstName,
    surname: $surname,
    username: $username,
    password: $password,
    userRoles: $userRoles,
    organisationUnits: $organisationUnits
  }')

response=$(curl --silent --show-error --location \
  --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
  --request POST "$SERVICE_URL/api/users" \
  --header "Content-Type: application/json" \
  --write-out "\n%{http_code}" \
  --data "$payload")

http_code=$(echo "$response" | tail -1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
  echo "Error: Failed to create metrics user (HTTP $http_code)."
  echo "Response: $body"
  exit 1
fi

echo "Metrics user '$METRICS_USERNAME' created successfully."
echo "Response: $response"
