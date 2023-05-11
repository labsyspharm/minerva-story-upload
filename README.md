The three steps can each be done by different people at different times.

1. [Writing the Story][A]
  * Does not require command line
  * Requires Minerva Author

2. [Rendering and Uploading Images][B]
  * Requires command line usage
  * Run on your laptop or on O2

3. [Uploading the Story to GitHub][C]
  * Does not require command line
  * Requires a GitHub account

[A]: https://github.com/labsyspharm/minerva-story-upload/#writing-the-story
[B]: https://github.com/labsyspharm/minerva-story-upload/#render-and-upload-images
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

- [Create your story in Minerva Author](https://github.com/labsyspharm/minerva-story/wiki/How-to-make-a-Minerva-Story%3F)
- **Save the story.json file**

### Bundling

Send the following info to the person responsible for the next step:
  - The `story.json` file
  - Any HiTS/LSP image paths, if not using HiTS/LSP shared storage
  - Any CSV files used for names/segmentation, if not using HiTS/LSP shared storage

# Render and Upload Images

This describes local uses, [find specific O2 instructions here](https://github.com/labsyspharm/minerva-story-upload/tree/main/o2).

### Prepare for AWS

set up the AWS CLI:

1. [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

2. [Configure your AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config)

### Ready
Edit and run `template.bash` in your local shell.

- `IMAGE_PATH` should be the local file path of the `ome.tif`
- `JSON_PATH` should be the local file path of saved `story.json`
- `PROJECT` should be a custom name of your minerva story project

Now you can use the resulting `index.html` and `exhibit.json` in your project folder.

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
 - `_data/` (underscore in front)
 - your project/paper name without spaces
 - `-2022/` (or the current year)
 - your story/figure name without spaces
 - `.json`

The UI should now look like this:

<img width="552" alt="exhibit config name" src="https://user-images.githubusercontent.com/9781588/163011253-4f68377f-b758-4ffb-9e3d-1da5a8b3698c.png">

* Now copy and paste the contents of your `exhibit.json` file into the body of the new file.
  - The contents of this file should start with a `{` and end with a `}`

- While in the "\_data/config-PROJECT-NAME-YEAR/" directory
    - add a new file based on this template, called `index.yml`:

```
publication:
  title: PAPER TITLE
  authors: AUTHORS
  journal: JOURNAL
  links:
    - Publisher Page: ARTILCLE-LINK

PROJCET TITLE:
  - title: PROJCET TITLE
    description: PROJECT DESCRIPTION
    thumbnail file name: PROJECT-NAME-YEAR.jpg
    links:
      - PAGE TITLE: osd-STORY-NAME
```

- The `PAPER TITLE` should be the title of the associated paper
- The `AUTHORS` should be comma-separated list of authors of the paper
- The `JOURNAL` should be the name of the journal that published your paper, if any
- The `PROJECT TITLE` can be anything related to the project
- The `PAGE TITLE` can be anything related to the story

- The year eg. `2022`, must match the year used when adding your `exhibit.json` 
- The `PROJECT-NAME` must match the `project-name` used when adding your `exhibit.json`
- The `STORY-NAME` must match the `story-name` used when adding your `exhibit.json`

* Now click the `<> Code` icon on the left to return to the root of your fork.

### Uploading page markup

Click "Add File" and "Create New File"... then begin typing or pasting:

In the "Name of file..." input, type:
 - `data/`(no underscore)
 - `config-`
 - your project/paper name without spaces
 - `-2022/` (or the current year)
 - `osd-` 
 - your story/figure name without spaces
 - `.md` (Markdown)

The UI should now look like this:

<img width="503" alt="markdown file name" src="https://user-images.githubusercontent.com/9781588/163010180-007ecd19-5dee-48ae-98b6-087aa7ff4f4a.png">

* Now modify, copy and paste this template into the body of the new file:

```md
---
title: PAGE TITLE
layout: osd-exhibit
paper: config-PROJECT-NAME-2022
figure: STORY-NAME
---
```

- The `PAGE TITLE` can be anything
- The text `osd-exhibit` must not be changed
- The year eg. `2022`, must match the year used in uploading your `exhibit.json` 
- The `PROJECT-NAME` must match the `project-name` used in uploading your `exhibit.json`
- The `STORY-NAME` must match the `story-name` used in uploading your `exhibit.json`

## Add index.html

- While in the "data/PROJECT-NAME-YEAR/" directory
    - add a new file based on this template, called `index.html`:

```
---
layout: default
title: PROJECT TITLE
---
{% assign sectionId = page.url | split: '/' | last %}
{% assign config = sectionId | prepend: 'config-' %}

{% for yml_hash in site.data[config] %}
    {% if yml_hash[0] == 'index' %}
        {% assign pubData=yml_hash[1] %}
    {% endif %}
{% endfor %}

{% include data-index-default.html
    sectionId = sectionId
    pubData=pubData
    thumbnailDir=sectionId %}
```

- Set the PROJECT TITLE to a descriptive title of your project/paper.
- Now click the `<> Code` icon on the left to return to the root of your fork.

## Addding images

Click "Add File" and "Create New File"... then begin typing or pasting:

In the "Name of file..." input, type:
 - `assets/img/`
 - your project/paper name without spaces
 - `-2022/` (or the year used for the story on cycif.org)
 - your story/figure name without spaces
 - `.jpg`

The UI should now look like this:

<img width="552" alt="jpg pathname" src="https://user-images.githubusercontent.com/9781588/163036133-d8150903-183e-4f19-8cb7-8353e9f82435.png">

GitHub's Website only allows us to create new folders for text files 
  - Create the empty "STORY-NAME.jpg" anyway
  - Then rename your screenshot on your computer to match your `STORY-NAME.jpg` file
  - Upload to overwrite the empty `STORY-NAME.jpg` file

WIthin the `cycif.org/assets/img/project-name/` directory, click "add file" and "upload files":
  - Navigate to your `STORY-NAME.jpg` and upload the image.


## Modifying Tissue Atlas

Go to the [Tissue Atlas repository](https://github.com/labsyspharm/harvardtissueatlas).

<img width="293" alt="fork the repository" src="https://user-images.githubusercontent.com/9781588/163002843-e064bc7f-13ce-4915-b7e3-e76e8ca3948d.png">

Click the "Fork" icon to make your own copy of the repository.

Ensure that you have transferred to your own fork on GitHub. The URL should be:

```
https://github.com/YOUR-USERNAME/harvardtissueatlas
```

### Uploading page markup

Click "Add File" and "Create New File"... then begin typing or pasting:

In the "Name of file..." input, type:
 - `_data-cards/`
 - your project/paper name without spaces
 - `-2022/` (or the year used for the story on cycif.org)
 - `osd-` 
 - your story/figure name without spaces
 - `.md` (Markdown)

The UI should now look like this:

<img width="607" alt="markdown file name" src="https://user-images.githubusercontent.com/9781588/163029418-794f21eb-83a8-47c4-84f4-9fe067340f88.png">

* Now modify, copy and paste this template into the body of the new file:

```md
---
title: TITLE
date: '2022-04-12'
image: https://www.cycif.org/assets/img/PROJECT-NAME-YEAR.jpg
minerva_link: https://www.cycif.org/data/PROJECT-NAME-YEAR/osd-STORY-NAME.html
info_link: https://www.cycif.org/data/PROJECT-NAME-YEAR/index.html
show_page_link: false
---
```

- The `PAGE TITLE` can be anything
- The date should be in 'YYYY-MM-DD' format. The quotes are needed.
- THE `YEAR` must match the `YEAR` used for the story on cycif.org
- The `PROJECT-NAME` must match the `project-name` used on cycif.org
- The `STORY-NAME` must match the `story-name` used on cycif.org

Additionally, add the following line below the date if the project belongs to an atlas:

```
atlas: ATLAS
```

- Replace the word "ATLAS" with the name of the atlas including the images you're publishing.

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
