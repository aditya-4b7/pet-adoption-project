#!/bin/bash

for ENV in stage prod; do
  BUCKET=devops-$ENV-tf-state-12345
  TABLE=terraform-lock-$ENV

  aws s3 rm s3://$BUCKET --recursive
  aws s3api delete-bucket --bucket $BUCKET
  aws dynamodb delete-table --table-name $TABLE
done