#!/bin/bash
set -e
# Go to app directory
cd /app

# Clone app from git
if [ -n "$GIT_URL" ] && [ -n "$GIT_BRANCH" ]; then
  echo "Dowloading S3 Image"
  [ -d /app/.git ] || git clone --branch "$GIT_BRANCH" --depth 50 $GIT_URL /app
  [ -n "$GIT_COMMIT_ID" ] && git checkout -qf $GIT_COMMIT_ID
# Download app from S3
elif [ -n "$S3_URI" ]; then
  if [ -z "$S3_SECRET_ACCESS_KEY" ]; then
    opts="--no-sign-request"
  fi
  echo "Dowloading S3 Image"
  AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY AWS_DEFAULT_REGION=$S3_REGION aws s3 cp $opts $S3_URI ./
  echo "Unzipping ${S3_URI##*/}"
  archive_file=${S3_URI##*/}
  tar xf $archive_file
  rm -f $archive_file
fi
# Update ownership
chown -R www-data:www-data /app /var/log/app

# Run deploy hook
if [ -f /app/.deploy-hook ]; then
  [ "$NO_HOOK" == "true" ] || bash /app/.deploy-hook
fi

echo "End of docker-entrypoint.sh"
exec "$@"