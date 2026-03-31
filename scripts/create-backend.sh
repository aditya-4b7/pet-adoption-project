#!/bin/bash
set -euo pipefail

REGION="${1:-us-east-1}"
PROJECT="${2:-pet-adoption}"

ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

for ENV in stage prod; do
  BUCKET="${PROJECT}-${ENV}-tf-state-${ACCOUNT_ID}"

  if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket \
      --bucket "$BUCKET" \
      --region "$REGION" 2>/dev/null || true
  else
    aws s3api create-bucket \
      --bucket "$BUCKET" \
      --region "$REGION" \
      --create-bucket-configuration LocationConstraint="$REGION" 2>/dev/null || true
  fi

  aws s3api put-bucket-versioning \
    --bucket "$BUCKET" \
    --versioning-configuration Status=Enabled

  aws s3api put-bucket-encryption \
    --bucket "$BUCKET" \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

  aws s3api put-public-access-block \
    --bucket "$BUCKET" \
    --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

  mkdir -p "environment/${ENV}"

  cat > "environment/${ENV}/backend.auto.hcl" <<EOH
bucket       = "${BUCKET}"
key          = "${ENV}/terraform.tfstate"
region       = "${REGION}"
encrypt      = true
use_lockfile = true
EOH

  echo "Prepared backend config at environment/${ENV}/backend.auto.hcl"
done