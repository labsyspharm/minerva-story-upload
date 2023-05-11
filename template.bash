#!/bin/bash

# Edit these 3 lines

IMAGE_PATH="/path/to/image"
JSON_PATH="/path/to/story.json"
PROJECT="a-project-directory"

# Don't edit below here

BUCKET="www.cycif.org"
S3_URL="s3://${BUCKET}/upload-script/${PROJECT}"
URL="https://s3.amazonaws.com/${BUCKET}/upload-script/${PROJECT}"

echo "Rendering..."

python save_exhibit_pyramid.py "$IMAGE_PATH" "$JSON_PATH" "$PROJECT" --url "$URL"

echo "Uploading..."

FLAGS="--recursive --acl public-read"
aws s3 cp "$FLAGS" "$PROJECT" "$S3_URL"
