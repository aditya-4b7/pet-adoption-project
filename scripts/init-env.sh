#!/bin/bash
set -euo pipefail
ENV_NAME="${1:?usage: $0 <stage|prod>}"
if [ ! -f "environment/${ENV_NAME}/backend.auto.hcl" ]; then
  echo "backend.auto.hcl not found for ${ENV_NAME}. Run ./scripts/create-backend.sh first."
  exit 1
fi
cd "environment/${ENV_NAME}"
terraform init -reconfigure -backend-config=backend.auto.hcl
