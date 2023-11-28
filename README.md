The three steps can each be done by different people at different times.

1. [Writing the Story][A]
  * Does not require command line
  * Requires Minerva Author

2. [Prepare Dependencies][P]
  * Minerva Author
  * AWS S3

2. [Rendering and Uploading Images][B]
  * Requires command line usage
  * Run on your laptop or on O2

3. [Uploading the Story to GitHub][C]
  * Does not require command line
  * Requires a GitHub account

[A]: https://github.com/labsyspharm/minerva-story-upload/#writing-the-story
[P]: https://github.com/labsyspharm/minerva-story-upload/#dependencies
[B]: https://github.com/labsyspharm/minerva-story-upload/#render-and-upload-images
[C]: https://github.com/labsyspharm/minerva-story-upload/#upload-to-github

# Writing the story

### Prerequesites 

- Ensure your images are on HiTS/LSP shared storage:
  - Fluorescence images as .ome.tiff 
  - segmentatation images as .ome.tiff or .tiff

- Ensure you have these files if not on HiTS/LSP shared storage:
  - channel name csv files
  - segmentation ID csv files
  - any csv files for infographics

- [Create your story in Minerva Author](https://github.com/labsyspharm/minerva-story/wiki/How-to-make-a-Minerva-Story%3F)
- **Save the story.json file**

### Bundling

Send the following info to the person responsible for the next step:
  - The `story.json` file
  - Any HiTS/LSP image paths, if not using HiTS/LSP shared storage
  - Any CSV files used for names/segmentation, if not using HiTS/LSP shared storage

# Dependencies

### Prepare for Minerva Author

All commands should be run in "Terminal" on MacOS and "Anaconda Prompt" on Windows.

First, download this repository through the git command line:

```
git clone https://github.com/labsyspharm/minerva-author.git
```


 * [Microsoft C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)
 * Install [Anaconda](https://docs.anaconda.com/anaconda/install/windows/)
 * Move [openslide](https://openslide.org/download/#windows-binaries) "bin" directory to "minerva-author/src"
 * Run `conda install -c anaconda git`

Then run the following commands to set up the development environment:

```
cd minerva-author
conda env create -f requirements.yml
conda activate minerva-author
```

### MacOS

 * install [homebrew](https://brew.sh/) and run `brew install openslide`.
 * Install [Anaconda](https://docs.anaconda.com/anaconda/install/mac-os/)

Then run the following commands to set up the development environment:

```
cd minerva-author
conda env create -f requirements.yml
conda activate minerva-author
```

### Prepare for AWS

set up the AWS CLI:

1. [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

2. [Configure your AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config)

# Render and Upload Images

Edit and run `template.bash` in your local shell. Alternate [O2 instructions here](https://github.com/labsyspharm/minerva-story-upload/tree/main/o2).

- `IMAGE_PATH` should be the local file path of the `ome.tif`
- `JSON_PATH` should be the local file path of saved `story.json`
- `PROJECT` should be a custom name of your minerva story project

Now you can use the resulting `index.html` and `exhibit.json` in your project folder. You must also upload the subdirectories of "images/out" to the `www.cycif.org` AWS S3 bucket with an arbitrary prefix referred to in this document as "your project/paper name without spaces". The `template.bash` script will run the AWS S3 upload, but the upload process may also be performed in the AWS console.

# Upload to Github

There are three steps to publishing to "tissue-atlas.org"
- [Modify a copy of `cycif.org`][C1] to include your `exhibit.json`
- [Modify a copy of `tissue-atlas.org`][C2] to include a link to `cyif.org`
- [Submit both][C3] modifications for approval.

[C1]: https://github.com/labsyspharm/minerva-story-upload/#modifying-cyciforg
[C2]: https://github.com/labsyspharm/minerva-story-upload/#modifying-tissue-atlas
[C3]: https://github.com/labsyspharm/minerva-story-upload/#submitting-changes-for-approval

## Modifying CyCIF.org

Go to the [CyCIF.org repository](https://github.com/labsyspharm/cycif.org).

<img width="293" alt="fork the repository" src="https://user-images.githubusercontent.com/9781588/163002843-e064bc7f-13ce-4915-b7e3-e76e8ca3948d.png">

Click the "Fork" icon to make your own copy of the repository.

Ensure that you have transferred to your own fork on GitHub. The URL should be:

```
https://github.com/YOUR-USERNAME/cycif.org
```

### Uploading exhibit.json

Click "Add File" and "Create New File"... then begin typing or pasting:

In the "Name of file..." input, type:
 - `_data/` (notice the underscore)
 - `config-`
 - your project/paper name without spaces
 - `/exhibit.json`

* Now copy and paste the contents of your `exhibit.json` file into the body of the new file.
  - The contents of this file should start with a `{` and end with a `}`

* Now click the `<> Code` icon on the left to return to the root of your fork.

### Uploading page markup

Click "Add File" and "Create New File"... then begin typing or pasting:

In the "Name of file..." input, type:
 - `data/`
 - your project/paper name without spaces
 - `/index.md` (Markdown)

* Now modify, copy and paste this template into the body of the new file:

```md
---
title: [your project/paper name without spaces]
layout: minerva-1-5
exhibit: config-[your project/paper name without spaces]
redirect_from: /[your project/paper name without spaces]
---
```

- Now click the `<> Code` icon on the left to return to the root of your fork.

## Modifying Tissue Atlas

Go to the [Tissue Atlas repository](https://github.com/labsyspharm/harvardtissueatlas).

<img width="293" alt="fork the repository" src="https://user-images.githubusercontent.com/9781588/163002843-e064bc7f-13ce-4915-b7e3-e76e8ca3948d.png">

Click the "Fork" icon to make your own copy of the repository.

Ensure that you have transferred to your own fork on GitHub. The URL should be:

```
https://github.com/YOUR-USERNAME/harvardtissueatlas
```

### Uploading data card

Click "Add File" and "Create New File"... then begin typing or pasting:

In the "Name of file..." input, type:
 - `_data-cards/`
 - your project/paper name without spaces
 - `index.md` (Markdown)

* Now modify, copy and paste this template into the body of the new file:

```md
---
title: [your project/paper name without spaces]
image: https://s3.amazonaws.com/www.cycif.org/[your project/paper name without spaces]/thumbnail--default.jpg
minerva_link: https://www.cycif.org/data/[your project/paper name without spaces]
date: 'YYYY-MM-DD'
show_page_link: false
info_link: null
tags: []
---
```

### Uploading redirect

Click "Add File" and "Create New File"... then begin typing or pasting:

In the "Name of file..." input, type:
 - `_redirects/`
 - `[your project/paper name without spaces].md` (Markdown)

* Now modify, copy and paste this template into the body of the new file:

```md
---
redirect_to: https://www.cycif.org/data/[your project/paper name without spaces]
---
```

## Submitting changes for approval

### Submitting changes to CyCIF.org

Go to the [CyCIF.org repository](https://github.com/labsyspharm/cycif.org).

<img width="762" alt="Click Pull Requests" src="https://user-images.githubusercontent.com/9781588/163026733-8993b14b-cb5c-4bde-8036-c9766b9aca5a.png">

- Click the "Pull Requests" Icon
- Click "New Pull Request" in green
- Click the "compare across forks" link

<img width="827" alt="Screen Shot 2022-04-12 at 2 13 38 PM" src="https://user-images.githubusercontent.com/9781588/163026954-bf5dcb9f-7f35-4132-8e90-ea2c52f13b04.png">

- Open the "Head repository" dropdown
- Select your copy (fork) of cycif.org
- Click "Create Pull Request" in green

### Submitting changes to the Tissue Atlas

- Go to the [Tissue Atlas repository](https://github.com/labsyspharm/harvardtissueatlas).
- Repeat the steps documented for submitting changes to CyCIF.org
