# Negative Selection On Esperanto

### Summary
Esperanto is a constructed language intended to be "the international language". In this study we comprare Esperanto 
to 6 quite similar and 2 less similar languages: English (en), German (de), French (fr), Polish (pl), Russian (ru) and Latin (la) and Hindi (hi) and Greek (el).
Also we compare to 3 more distant languages: Chinese (zh), Swahili (sw) and Arabic (ar). The aim is to 
evaluate how similar those languages are to Esperanto, as well as assessing whether they are more similar 
orthographically or phonetically.

### Content Description
* **fetch.sh**: Retrieves the data files for the relevant languages from the OSCAR-2109 dataset.
* **dataprep.ipynb:** Pre-processes the raw data files. 
* **negsel.ipynb**: Performs negative selection on the pre-processed files.
* **auc.R**: Computes the Area Under the (ROC) Curve.
* **alphabets**: Contains the alphabet per language.
* **data**: Contains the raw data, the transliterated version, and the corresponding train/test split.
* **results**: Contains the output from the negative selection algorithm.

### Setup
1. Clone the current repository to the directory of your choice.
   
   `git clone git@github.com:teunpe/nacoproject.git`
   
2. Enter the cloned repository (`nacoproject`) and retrieve the relevant files from the OSCAR-2109 dataset.

    `sh fetch.sh`

3. From the terminal, open the file '**dataprep.ipynb**' with the preferred interactive development environment for notebooks e.g. jupyter notebook. And run all the cells.
   
    `jupyter notebook`
   
4. Once the data is put into correct format, the '**negsel.ipynb**' notebook can be ran to perform Negative Selection.
5. Now that the experiments have been performed, the results can inspected by opening the file '**auc.R**' with the desired code editor. And run all the chunks of code. A collection of the results can be seen on the `./results` folder under the name `resD_R.txt` where D is the current day, and R the run number e.g. `res22_1.txt`.

### Example
