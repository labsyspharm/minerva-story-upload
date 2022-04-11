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
- Understand how to ssh form a command line

Transfer any .story.json or .csv files to o2:

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
