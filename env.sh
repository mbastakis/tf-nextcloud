export AWS_ACCESS_KEY_ID=$(cat ~/.aws/cli/cache/*.json | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/cli/cache/*.json | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(cat ~/.aws/cli/cache/*.json | jq -r .Credentials.SessionToken)
