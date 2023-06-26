# Negative Selection On Esperanto

### Summary
Esperanto is a constructed language intended to be "the international language". In this study we comprare Esperanto 
to 7 relatively similar languages: English (en), German (de), Polish (pl), Russian (ru), Greek (el), Latin (la) and 
French (fr). And to 4 more distant languages: Chinese (zh), Swahili (sw), Arabic (ar) and Hindi (hi). The aim is to 
evaluate how similar are those languages to Esperanto, as well as  assessing whether they are more similar 
orthographically or phonetically.

### Content Description
* **fetch.sh**: Retrieves the data files for the relevant languages from the OSCAR-2109 dataset.
* **dataprep.ipynb:** Pre-processes the raw data files. 
* **negsel.ipynb**: Performs negative selection with r-contiguous algorithm on the pre-processed files.
* **negsel_chunk.ipynb**: Performs negative selection with r-chunk algorithm on the pre-processed files.
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

Files in the results folder are generally named like this:

{lan}_{r}_{language_set}_{alphabet}_{trainfile_repeat}-{repeat}_{algorithm}.txt

langugage_set, alphabet and algorithm are left blank for the default values which are
orthographic, global alphabet and r-contiguous respectively.

Files in the data folder are generally named like this:
{lan}_{language_set}_{repeat}.test

For the train language esperanto there also exist .train files


For the phonetic data we had to distinguish between languages that could be processed with epitran and languages that had to be transliterated to IPA externally.
For the external languages there exist subset files which are just subsets of the original data comparable to _subset files in the translit folder.
The results of the external translators / epitran can be found in the _raw_ files.
For some languages there exist different epitran objects to convert the language into IPA as well as the option to use non-standard IPA ligatures.
These variants are marked with the number of the epitran variant and an l flag if the ligature option was set to true.
So, e.g. sw_raw_2_ipa_0l.test is the ipa result for the second swahili testset using the first variant "swa-Latn" with the ligature option set to true. The variant names can be found in the dataprep.ipynb file, further explanation regarding the variants can be found on the epitran website.