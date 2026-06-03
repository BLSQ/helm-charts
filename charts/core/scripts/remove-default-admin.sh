#!/usr/bin/env sh
set -exo pipefail

if [ -z "$SERVICE_URL" ] || [ -z "$ADMIN_USERNAME" ] || [ -z "$ADMIN_PASSWORD" ] || [ -z "$TARGET_USERNAME" ]; then
  echo "Error: Required environment variables are not set. Please set SERVICE_URL, ADMIN_USERNAME, ADMIN_PASSWORD, TARGET_USERNAME."
  exit 1
fi

echo "Waiting for DHIS2 service to be ready... $SERVICE_URL"
curl --fail --silent --show-error --output /dev/null --retry 100 --retry-delay 6 --retry-connrefused "$SERVICE_URL"
echo "DHIS2 service is ready."

# Lookup target user
existing_user=$(curl --fail --silent --show-error --location \
  --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
  "$SERVICE_URL/api/users?fields=id,disabled&filter=username:eq:$TARGET_USERNAME")

user_id=$(echo "$existing_user" | jq -r '.users[0].id')

if [ -z "$user_id" ] || [ "$user_id" = "null" ]; then
  echo "User '$TARGET_USERNAME' not found. Nothing to do."
  exit 0
fi

already_disabled=$(echo "$existing_user" | jq -r '.users[0].disabled')

if [ "$already_disabled" = "true" ]; then
  echo "User '$TARGET_USERNAME' (id: $user_id) already disabled. Skipping."
  exit 0
fi

echo "Disabling user '$TARGET_USERNAME' (id: $user_id)..."

response=$(curl --silent --show-error --location \
  --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
  --request PATCH "$SERVICE_URL/api/users/$user_id" \
  --header "Content-Type: application/json-patch+json" \
  --write-out "\n%{http_code}" \
  --data '[{"op": "replace", "path": "/disabled", "value": true}]')

http_code=$(echo "$response" | tail -1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
  echo "Error: Failed to disable user '$TARGET_USERNAME' (HTTP $http_code)."
  echo "Response: $body"
  exit 1
fi

echo "User '$TARGET_USERNAME' disabled successfully."
