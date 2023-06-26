# merge_samplesheets

This program is a wrapper for Jeff Bailey's mipscripts_v0dev2.py sample sheet
merger program. If you have sequenced MIP samples multiple times (via
resequencing or recapturing) and your goal is to merge these datasets together
(collecting all the data associated with e.g. sample 2 in run 1 and sample 2 in
run 2 into a single sample 2 file), this program allows these types of mergers.
Input is a group of sample sheets (each containing a corresponding fastq
subfolders). Output is a single sample sheet that has a single merged fastq
subfolder.

## Installation:
 - Install mambaforge: https://github.com/conda-forge/miniforge#mambaforge
 - Create a mamba environment and install snakemake there:
```bash
mamba create -c conda-forge -c bioconda -n snakemake snakemake
```

### Setup your environment:
 - Change directory to a folder where you want to run the analysis
 - Download the merge_samplesheets.smk file into this folder
 - Download the merge_samplesheets.yaml file into the same folder

## Usage:
 - Edit the config.yaml file using the instructions in the comments. Use a text editor that outputs unix line endings (e.g. vscode, notepad++, gedit, micro, emacs, vim, vi, etc.)
 - If snakemake is not your active conda environment, activate snakemake with:
```bash
mamba activate snakemake
```
 - Run snakemake with:
```bash
snakemake -s merge_samplesheets.smk --cores [your_desired_core_count]
```

## Help:
For additional help on Jeff's merge script, try running this command (assuming
you have access to a computer that is part of the bailey lab group):
python3 /nfs/jbailey5/baileyweb/bailey_share/bin/mipscripts_v0dev2.py merge_sampleset -h
