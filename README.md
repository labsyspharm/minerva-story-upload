## For Authors

### Prerequesites 

- Ensure your images are on HiTS/LSP shared storage:
  - Fluorescence images as .ome.tiff 
  - segmentatation images as .ome.tiff or .tiff

- Ensure you have these files if not on HiTS/LSP shared storage:
  - channel name csv files
  - segmentation ID csv files
  - any csv files for infographics

- Create your story in Minerva Author
- **Save the story.json file**

### Bundling

Email the Uploader the following information:
  - The `story.json` file
  - Any HiTS/LSP image paths, if not using HiTS/LSP shared storage
  - Any CSV files used for names/segmentation, if not using HiTS/LSP shared storage

## For Uploaders

### Prerequesites 

- Know your O2 Login Username / Password
- Understand how to ssh from a command line
- Transfer any .story.json or .csv files to o2
  - use specific `final-story-files` folder name

```
scp -r final-story-files USER@o2.hms.harvard.edu:/home/USER/final-story-files 
```

### O2 Environment 

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
conda activate author
conda env update -f requirements.yml
```

### Story Creation

- Invent a "project name" and a "story name" for each story.
- Notice the names of your ome-tiff image files
- Ensure your json files are on o2
  - They should all be in `~/final-story-files`

Now Edit "copy-template.bash",

- set `INPUT_PROJECT="project name"`
- set `INPUT_PATH` to the path to your OME-TIFF on HiTS/LSP shared storage
- This will attempt to copy images to `scratch3`

Then schedule the transfer:

```
sbatch copy-template.bash
```

Move on once `squeue -u $USER` shows only one command with the NAME of "bash".


Now, Edit "render-template.bash"

- set `INPUT_PROJECT="project name"`
- set `INPUT_NAME="story name"`
- set `INPUT_IMAGE` to the name of the image in `scratch3`
- set `INPUT_JSON` to the name of the "story.json" file in `~/final-story-files`

You will also need to edit you "story.json" file. 

- Replace the `in_file` value with `/n/scratch3/users/U/USER/INPUT_PROJECT`
  - where and `INPUT_PROJECT` must match your template edits
  - were `USER` is your username and `U` is the first letter of your username

In Vim, the replacement command would look like:

```
%s@\("in_file": \)"[^"]*[\\/]\(.\{-}\.tif\)"@\1"/n/scratch3/users/U/USER/INPUT_PROJECT/\2"@gc
```

- Replace all paths to csv files to paths accessible to your user on o2

In Vim, the replacement command would look like:

```
%s@\("csv_file": \)"[^"]*[\\/]\(.\{-}\.csv\)@\1"/home/USER/final-story-files/markers.csv"@gc
```

Then schedule the render:

```
sbatch render-template.bash
```

Move on once `squeue -u $USER` shows only one command with the NAME of "bash".

Now, Edit "upload-template.bash"

- set `INPUT_PROJECT="project name"`
- set `INPUT_NAME="story name"`
