# JHU-GACD-ProgrammingAssignment
### Week 4 Final Peer Reviewed Programming Assignment

# Overview of the files in the project

- `.gitignore` - ignore the data directory discussed shortly along with R console files.

- `CodeBook.md` - Explains the source data, the resulting output files, and the transformation performed.

- `README.md` - This file which provide some added insight into the code structure and design choices made.

- `run_analysis.R` - The single script that runs the analysis and produces the tidy data files.

- `run_analysis_SampleConsoleLog.pdf` - sample console log produced by the `run_analysis.R` script.

# Data Directories

The <u>original source files</u> are located in the **`UCI HAR Dataset`** sub-directory and are described in **`CodeBook.md`** and in the comments at the top of the **`run_analysis.R`** script.

The <u>Tidy Data Files</u> are located in the **`tidy-data`** sub-directory and are described in **`CodeBook.md`** and in the comments at the top of the **`run_analysis.R`** script.

One of the design decisions was the keep the output separate from the input, so the original nature of the input was kept clear.

# About the **`run_analysis.R`** script

The processing that is does is documented at the top of the script. Please take a look at the  **`run_analysis.R`** script and read the comments at the top. 

The script is rather long, but it is very robust, checking both the input files and the output files produced.

The script process is logged to console with each step and some time intensive processes being time stamped.  You can see this in the `run_analysis_SampleConsoleLog.pdf` file. 

The resulting files are documented in the **`CodeBook.md`** file.

Since the specs stated to produce an independent tidy dataset for the last step, I decided to produce two files.  The first one is not summarized and the final one is.

