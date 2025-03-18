#!/usr/bin/env sh

set -e

cat << EOF > /home/backup/.env
export BACKUP_NAME=${BACKUP_NAME}
export S3_BUCKET_URL=${S3_BUCKET_URL}
export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
EOF

printf "${CRON_SCHEDULE} su - backup -c /dobackup.sh\n" > /tmp/crontab
crontab - < /tmp/crontab
exec "$@"