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
git clone https://github.com/labsyspharm/minerva-author.git
cd minerva-author
```

Install Minerva Author

```
conda env create -f requirements.yml
conda activate minerva-author
```

## The main pipeline

### Rendering

Store all images in your scratch directory, with the curretn DATE "/n/scratch3/users/\*/\*/DATE/\*.ome.tif". Likewise, copy story.json files to "\~/DATE/sources/\*.story.json", or "\~/DATE/sources/default.story.json" if you are using the same rendering settings across samples. Update `DATE`, `TITLE`, and `SAMPLES` in `render.bash`; the `SAMPLES` must match ome-tiff names in scratch3. On login node, to render images:

```
sbatch render.bash
```

### Transfering

Update `DATE`, `TITLE`, and `SAMPLES` in `transfer.bash`; the `SAMPLES` must match the sample names from the previous step. To transfer images to AWS, on transfer node (after no jobs are shown in `squeue -u $USER`):

```
bash transfer.bash
```

To transfer metadata to AWS, on transfer node (after no jobs in `squeue -u $USER`):

Fork `https://github.com/thejohnhoffer/minerva-metadata-template` and customize metadata sources and display.

```cd metadata
git clone https://github.com/thejohnhoffer/minerva-metadata-template
cd minerva-metadata-template
python meta.py | tee commands.sh
bash commands.sh```
