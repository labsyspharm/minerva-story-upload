# Rendering and uploading images

### Login to O2 

- Know your O2 Login Username / Password
- Understand how to ssh from a command line
- Transfer any .story.json or .csv files to o2
  - use specific `final-story-files` folder name

```
scp -r final-story-files USER@o2.hms.harvard.edu:/home/USER/final-story-files 
```

### O2 Environment 

Login To O2

```
ssh USERNAME@o2.hms.harvard.edu
srun -p interactive -t 0-12:00 --mem 5G --pty /bin/bash
git clone git@github.com:labsyspharm/minerva-author.git
cd minerva-author
git checkout o2
```

Install Minerva Author

```
git submodule update --init --recursive
conda config --add channels conda-forge
conda create --name author python=3.8 nomkl
conda activate minerva-author
conda env update -f requirements.yml
```

### Final Story Files

- Invent a "project-name" and a "story-name" for each story.
- Notice the names of your ome-tiff image files
- Ensure your json files are on o2
  - They should all be in `~/final-story-files`

### Copy to scratch3

Now Edit "copy-template.bash",

- set `INPUT_PROJECT="project-name"`
- set `INPUT_PATH` to the path to your OME-TIFF on HiTS/LSP shared storage
- This will attempt to copy images to `scratch3`

Then schedule the transfer:

```
sbatch copy-template.bash
```

Move on once `squeue -u $USER` shows only one command with the NAME of "bash".

`mkdir ~/data`

<!---
### Specify CSV paths

You will also need to edit you "story.json" file. 

- The `in_file` key will be ignored in favor of `/n/scratch3/users/U/USER/INPUT_PROJECT`
- But you must replace all paths to csv files to paths accessible to your user on o2

In Vim, the replacement command would look like:

```
%s@\("csv_file": \)"[^"]*[\\/]\(.\{-}\.csv\)@\1"/home/USER/final-story-files/markers.csv"@gc
```

### Underline markers

Optionally, to underline markers in color, surround the markers in backticks

- The text "CD4" becomes "\`CD4\`" in order to enable marker underlines
- In Vim, you could run``%s@\([^"`]\)\<\(CD4\)\>\([^"`]\)@\1`\2`\3@gc``

To replace multiple markers, separte each marker with `\|`:

```
%s@\([^"`]\)\<\(DNA1\|DNA2\|DNA3\)\>\([^"`]\)@\1`\2`\3@gc
```
--->
### Render Images

Now, Edit "render-template.bash"

- set `INPUT_PROJECT="project-name"`
- set `INPUT_NAME="story-name"`
- set `INPUT_IMAGE` to the name of the image in `scratch3`
- set `INPUT_JSON` to the name of the "story.json" file in `~/final-story-files`

Then schedule the render:

```
sbatch render-template.bash
```

Move on once `squeue -u $USER` shows only one command with the NAME of "bash".

### Upload Images

Now, Edit "upload-template.bash"

- set `INPUT_PROJECT="project-name"`
- set `INPUT_NAME="story-name"`

Then schedule the upload:
```
sbatch upload-template.bash
```

Now, the `story.json` files in `~/data` should be able to render Minerva Stories, with images loaded from S3

### Copy the exhibit.json

Copy the `exhibit.json` from `~/data/INPUT_PROJECT/INPUT_NAME` to your own device:
```
scp USER@o2.hms.harvard.edu:/home/USER/data/INPUT_PROJECT/INPUT_NAME/exhibit.json .
```

Then, you may host the `exhibit.json` alongside the Minerva Story `index.html`
