#!/bin/sh
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID="bd69bab4-aa92-445e-8213-c38ee7c5de49"
export ARM_CLIENT_ID="1182efbb-8eda-4822-a198-0b4de55f39b9"
export ARM_CLIENT_SECRET="c0c8ee81-a3e7-4fb8-a8a2-d725dc36900f"
export ARM_TENANT_ID="ccc4c630-6fc5-42ac-bc9f-6879b9d6d8f2"

# Not needed for public, required for usgovernment, german, china
export ARM_ENVIRONMENT=public