# Rendering and uploading images

This guide is intended for users performing bulk uploads of large numbers Minerva Stories, begining with `*.story.json` specifications created either manually in Minerva Author or automatically with Auto-Minerva, e.g. [`story.py`](https://github.com/labsyspharm/mcmicro/blob/master/modules/ext/story.py). Once you have access to those stories locally, and access to the OME-TIFF images in "/n/scratch3" on O2, this guide will walk you through rendering and uploading `jpeg` pyramids and Minerva Story `exhibit.json` configurations to an AWS `s3` bucket.

### Login to O2 

This guide begins with copying several "story-files/SAMPLE/SAMPLE.story.json" for many samples from your local computer to O2 with the `scp` command on the command line. The files are copied under the current date in the "sources" folder in your O2 home directory.

```
DATE=$(date '+%Y-%m-%d')
mkdir $DATE
mv story-files "${DATE}/sources"
scp -r $DATE $USER@o2.hms.harvard.edu:~/$DATE
```

### O2 Environment 

Now, prepare to run the rendering and metadata pipeline by logging in to O2, and copying the source code for Minerva Author.

```
ssh $USER@o2.hms.harvard.edu
git clone https://github.com/labsyspharm/minerva-author.git
cd minerva-author
```

Install Minerva Author

Create and activate a conda environment. The conda environment must be activated to run `render.bash`.

```
conda env create -f requirements.yml
conda activate minerva-author
```

## The main pipeline

### Rendering

Store all images in your scratch directory, with the current date "/n/scratch3/users/\*/\*/DATE/\*.ome.tif". Likewise, ensure story.json files have been copied to "\~/DATE/sources". A "default.story.json" in that directory may be used to apply the same rendering settings across samples. Update `DATE`, `TITLE`, and `SAMPLES` in `render.bash`; the `SAMPLES` must match ome-tiff names in scratch3. By default, the `-t` parameter in `render.bash` is set to 30 minutes. Increase if needed, or consider generating many "subsample" `story.json` files with fewer channels. On a login node, to render images:

```
sbatch render.bash
```

### Transfering

Update `DATE`, `TITLE`, and `SAMPLES` in `transfer.bash`; the `SAMPLES` must match the sample names from the previous step. To transfer images to AWS, on a transfer node (after no jobs are shown in `squeue -u $USER`):

```
bash transfer.bash
```

To transfer metadata to AWS, on a transfer node (after no jobs in `squeue -u $USER`):

Fork `https://github.com/thejohnhoffer/minerva-metadata-template` and customize metadata sources and displayed fields.

```cd metadata
git clone https://github.com/thejohnhoffer/minerva-metadata-template
cd minerva-metadata-template
python meta.py | tee commands.sh
bash commands.sh```
