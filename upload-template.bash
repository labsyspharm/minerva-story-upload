#!/bin/bash
#SBATCH -c 1
#SBATCH -p transfer
#SBATCH --mem 1g
#SBATCH -t 12:00:00
INPUT_PROJECT="YOUR-PROJECT-NAME"
INPUT_NAME="YOUR-STORY-NAME"

OUTPUT_ROOT="/home/${USER}/data"

# Below here should not need change
BUCKET="www.cycif.org"
OUT_DIR="${OUTPUT_ROOT}/${INPUT_PROJECT}/${INPUT_NAME}"
OUT_URL="s3://${BUCKET}/${INPUT_PROJECT}/${INPUT_NAME}"
FLAGS="--recursive --acl public-read"

module load gcc python/3.7.4
CMD="aws s3 cp $FLAGS $OUT_DIR $OUT_URL"
echo $CMD
exec $CMD
