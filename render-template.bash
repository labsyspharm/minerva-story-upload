#!/bin/bash
#SBATCH -c 1
#SBATCH -p short 
#SBATCH --mem 8g
#SBATCH -t 1:00:00
INPUT_IMAGE="YOUR-IMAGE.ome.tif"
INPUT_JSON="YOUR-STORY.story.json"
INPUT_PROJECT="YOUR-PROJECT-NAME"
INPUT_NAME="YOUR-STORY-NAME"

OUTPUT_ROOT="/home/${USER}/data"

# Below here should not need change
BUCKET="www.cycif.org"
SCRATCH="/n/scratch3/users/${USER:0:1}/${USER}"
IMG_DIR="${SCRATCH}/${INPUT_PROJECT}"
STORY_JSON="/home/${USER}/final-story-files/${INPUT_JSON}"
SCRIPT="/home/${USER}/minerva-author/src/save_exhibit_pyramid.py"
OUT_URL="https://s3.amazonaws.com/${BUCKET}/${INPUT_PROJECT}/${INPUT_NAME}"
OUT_DIR="${OUTPUT_ROOT}/${INPUT_PROJECT}/${INPUT_NAME}"

CMD="python $SCRIPT $IMG_DIR/$INPUT_IMAGE $STORY_JSON $OUT_DIR --url $OUT_URL"
source activate author

echo $CMD
exec $CMD
