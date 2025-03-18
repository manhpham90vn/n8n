#!/usr/bin/env sh

set -e

source .env

FILE_NAME=/tmp/${BACKUP_NAME}-$(date "+%Y-%m-%d_%H-%M-%S").tar.gz

echo "Creating backup ${FILE_NAME}"
tar -zcvf "${FILE_NAME}" "/data"

echo "Uploading backup to S3"
aws s3 cp "${FILE_NAME}" "${S3_BUCKET_URL}"

echo "Backup done"