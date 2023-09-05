#!/bin/bash

# Write MFA_ARN which is getting from IAM console under user security. (ex: "arn:aws:iam::1234567890:mfa/YOUR-IAM-MFA-ARN")
MFA_ARN="<YOUR_MFA_ARN_FROM_IAM_USER>"
PROFILE="default"
AWS_STS_PROFILE="sts"
AWS_STS_REGION="ap-northeast-2"

arg1=$1
if [ ! -z "$arg1" ]
then
  PROFILE="$arg1"
fi

echo "Usage: \n  mfa.sh \n  Or \n  mfa.sh <profile> # if not default profile"
echo "\n\n"

read -p 'Enter the MFA code : ' MFA_TOKEN

CRED_DATA=$(aws sts get-session-token --duration-seconds 36000 --serial-number ${MFA_ARN} --token-code ${MFA_TOKEN} --profile ${PROFILE})

AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' <<< "${CRED_DATA}")
AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' <<< "${CRED_DATA}")
AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' <<< "${CRED_DATA}")

aws configure set region ${AWS_STS_REGION} --profile ${AWS_STS_PROFILE}
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID} --profile ${AWS_STS_PROFILE}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY} --profile ${AWS_STS_PROFILE}
aws configure set aws_session_token ${AWS_SESSION_TOKEN} --profile ${AWS_STS_PROFILE}

echo "### Check access to AWS with 'sts' profile"
echo "aws sts get-caller-identity --profile sts"
