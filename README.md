Here's an outline of this process:

1. [Writing the Story][A]

2. [Rendering and Uploading Images][B]
  * This step requires O2 and AWS access
  * This step requires use of the command line

3. [Uploading the Story to GitHub][C]


[A]: https://github.com/labsyspharm/minerva-story-upload/#writing-the-story
[B]: https://github.com/labsyspharm/minerva-story-upload/#rendering-and-uploading-images
[C]: https://github.com/labsyspharm/minerva-story-upload/#uploading-the-story-to-github

# Writing the story

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

Send the following info to the person responsible for rendering:
  - The `story.json` file
  - Any HiTS/LSP image paths, if not using HiTS/LSP shared storage
  - Any CSV files used for names/segmentation, if not using HiTS/LSP shared storage

# Rendering and uploading images

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

`mkdir ~/data`

Now, Edit "render-template.bash"

- set `INPUT_PROJECT="project name"`
- set `INPUT_NAME="story name"`
- set `INPUT_IMAGE` to the name of the image in `scratch3`
- set `INPUT_JSON` to the name of the "story.json" file in `~/final-story-files`

You will also need to edit you "story.json" file. 

- The `in_file` key will be ignored in favor of `/n/scratch3/users/U/USER/INPUT_PROJECT`
- But you must replace all paths to csv files to paths accessible to your user on o2

In Vim, the replacement command would look like:

```
%s@\("csv_file": \)"[^"]*[\\/]\(.\{-}\.csv\)@\1"/home/USER/final-story-files/markers.csv"@gc
```

Optionally, to underline markers in color, surround the markers in backticks

- The text "CD4" becomes "\`CD4\`" in order to enable marker underlines
- In Vim, you could run``%s@\([^"`]\)\<\(CD4\)\>\([^"`]\)@\1`\2`\3@gc``

To replace multiple markers, separte each marker with `\|`:

```
%s@\([^"`]\)\<\(DNA1\|DNA2\|DNA3\)\>\([^"`]\)@\1`\2`\3@gc
```

Then schedule the render:

```
sbatch render-template.bash
```

Move on once `squeue -u $USER` shows only one command with the NAME of "bash".

Now, Edit "upload-template.bash"

- set `INPUT_PROJECT="project name"`
- set `INPUT_NAME="story name"`

Then schedule the upload:
```
sbatch upload-template.bash
```

Now, the `story.json` files in `~/data` should be able to render Minerva Stories, with images loaded from S3

# Uploading the story to GitHub

There are three steps to publishing to "tissue-atlas.org"
- Modify a copy of `cycif.org` to include your `exibit.json`
- Modify a copy of `tissue-atlas.org` to include a link to `cyif.org`
- Submit both modifications for approval.

### Modifying CyCIF.org

Go to the [CyCIF.org repository](https://github.com/labsyspharm/cycif.org).

<img width="293" alt="fork the repository" src="https://user-images.githubusercontent.com/9781588/163002843-e064bc7f-13ce-4915-b7e3-e76e8ca3948d.png">

Click the "Fork" icon to make your own copy of the repository.

### Modifying Tissue Atlas

Go to the [Tissue Atlas repository](https://github.com/labsyspharm/harvardtissueatlas).

<img width="293" alt="fork the repository" src="https://user-images.githubusercontent.com/9781588/163002843-e064bc7f-13ce-4915-b7e3-e76e8ca3948d.png">

Click the "Fork" icon to make your own copy of the repository.

### Submitting your changes for approval

