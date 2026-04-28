#!/usr/bin/env sh
set -eo pipefail

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

# Build userRoles array from comma-separated USER_ROLE_IDS
user_roles="[]"
if [ -n "$USER_ROLE_IDS" ]; then
  user_roles=$(echo "$USER_ROLE_IDS" | tr ',' '\n' | jq -R '{"id": .}' | jq -s '.')
fi

# Build organisationUnits array from comma-separated ORG_UNIT_IDS
org_units="[]"
if [ -n "$ORG_UNIT_IDS" ]; then
  org_units=$(echo "$ORG_UNIT_IDS" | tr ',' '\n' | jq -R '{"id": .}' | jq -s '.')
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
    userCredentials: {
      username: $username,
      password: $password,
      userRoles: $userRoles
    },
    organisationUnits: $organisationUnits
  }')

response=$(curl --fail --silent --show-error --location \
  --user "$ADMIN_USERNAME:$ADMIN_PASSWORD" \
  --request POST "$SERVICE_URL/api/users" \
  --header "Content-Type: application/json" \
  --data "$payload")

if [ $? -ne 0 ]; then
  echo "Error: Failed to create metrics user."
  echo "Response: $response"
  exit 1
fi

echo "Metrics user '$METRICS_USERNAME' created successfully."
echo "Response: $response"
