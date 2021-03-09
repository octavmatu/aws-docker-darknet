#!/bin/bash
set -e

if [ ! -d "backup" ]; then
    mkdir backup
fi

if [ FLAG_S3_DOWNLOAD -gt 0 ]; then
    echo "Getting data from S3"
    aws s3 sync s3://${S3_BUCKET_NAME}/cfg cfg/
    aws s3 sync s3://${S3_BUCKET_NAME}/data data/
    aws s3 sync s3://${S3_BUCKET_NAME}/pretrained pretrained/
fi

if [ -f "cfg/${NETWORK_FILENAME}" ]; then
    export NETWORK_CONFIG="cfg/${NETWORK_FILENAME}"
fi

if [ -f "data/${DATA_FILENAME}" ]; then
    export DATA_FILE="data/${DATA_FILENAME}"
fi

if [ -f "pretrained/${PRETRAINED_WEIGHTS_FILENAME}" ]; then
    export PRETRAINED_WEIGHTS="pretrained/${PRETRAINED_WEIGHTS_FILENAME}"
fi

echo "Start training at $(date +"%D %T")"
./darknet/darknet detector train ${DATA_FILE} ${NETWORK_CONFIG} ${PRETRAINED_WEIGHTS}

echo "Finished training at $(date +"%D %T")"

source save_weights.sh
