DATE="2023-10-11"
TITLE="author-20XX"
BUCKET="www.cycif.org"
SCRATCH="/n/scratch3/users/${USER:0:1}/${USER}"
SAMPLES=(
"Sample1"
"Sample2"
"Sample3"
"Sample4"
"Sample5"
"Sample6"
"Sample7"
"Sample8"
"Sample9"
"Sample10"
"Sample11"
"Sample12"
"Sample13"
"Sample14"
"Sample15"
)

transfer_story () {
  sample="$1"
  STORY_PATH="${SCRATCH}/${DATE}/${sample}"
  STORY_URL="s3://${BUCKET}/${TITLE}/${sample}"
  CMD="s3 cp --recursive --acl public-read $STORY_PATH $STORY_URL"

  echo "aws $CMD"
  aws $CMD
}

for SAMPLE in ${SAMPLES[*]}
  do
    transfer_story $SAMPLE
    echo "Done!"
  done

