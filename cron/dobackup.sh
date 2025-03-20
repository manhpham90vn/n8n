#!/usr/bin/env sh

set -e

. .env

FILE_NAME=/tmp/${BACKUP_NAME}-$(date "+%Y-%m-%d_%H-%M-%S").tar.gz

echo "Creating backup ${FILE_NAME}"
tar -zcvf "${FILE_NAME}" "/data"

echo "Uploading backup to S3"
aws s3 cp "${FILE_NAME}" "${S3_BUCKET_URL}"

echo "Delete local file ${FILE_NAME}"
rm -rf "$FILE_NAME"

echo "Delete old backups from S3 more than 3 days"
aws s3 ls "${S3_BUCKET_URL}" | grep -v PRE | while read -r line;
do
    createDate=$(echo "$line" | awk '{print $1" "$2}')
    createDate=$(date -d "$createDate" +%s)
    olderThan=$(date -d "3 days ago" +%s)

    if [ "$createDate" -lt "$olderThan" ]; then
        fileName=$(echo "$line" | awk '{print $4}')
        if [ -n "$fileName" ]; then
            echo "Deleting ${fileName}"
            aws s3 rm "${S3_BUCKET_URL}/${fileName}"
        fi
    fi
done

echo "Backup done"
