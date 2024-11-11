#!/bin/bash

SECRET_NAME="ip_whitelist"
KEY_NAME=$1

CURRENT_SECRET=$(aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --query 'SecretString' --output text --region us-west-2)


NEW_VALUE=$(curl -s https://checkip.amazonaws.com/)/32
 

UPDATED_SECRET=$(echo "$CURRENT_SECRET" | jq --arg key "$KEY_NAME" --arg value "$NEW_VALUE" '.[$key] = $value')

aws secretsmanager update-secret --secret-id "$SECRET_NAME" --secret-string "$UPDATED_SECRET" --region us-west-2

if [ "$?" -eq 0 ]; then
    echo "Successfully updated the secret $SECRET_NAME with the new value for key $KEY_NAME."
else
    echo "Failed to update the secret $SECRET_NAME."
    exit 1
fi
