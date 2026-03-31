#!/bin/bash
set -euo pipefail
REGION="${1:-us-east-1}"
PROJECT="${2:-pet-adoption}"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
for ENV in stage prod; do
  BUCKET="${PROJECT}-${ENV}-tf-state-${ACCOUNT_ID}"
  TABLE="${PROJECT}-${ENV}-terraform-lock"
  aws s3 rm "s3://${BUCKET}" --recursive 2>/dev/null || true
  aws s3api delete-bucket --bucket "$BUCKET" --region "$REGION" 2>/dev/null || true
  aws dynamodb delete-table --region "$REGION" --table-name "$TABLE" 2>/dev/null || true
  rm -f "environment/${ENV}/backend.auto.hcl"
done
