#!/bin/bash
#SBATCH -c 1
#SBATCH --mem 1g
#SBATCH -t 1:00:00
#SBATCH -p transfer
INPUT_PATH="/n/files/HITS/YOUR/FILE/PATH"
INPUT_PROJECT="YOUR-PROJECT-NAME"

# Below here should not need change
SCRATCH="/n/scratch3/users/${USER:0:1}/${USER}"
IMG_DIR="${SCRATCH}/${INPUT_PROJECT}"

mkdir -p $SCRATCH

CMD="cp $INPUT_PATH $IMG_DIR/"
echo $CMD
exec $CMD
