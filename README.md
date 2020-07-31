# AlfiVR
This repository contains scripts to process AlfiVR project data;
To run the scripts, first run `startup.m` function from the root directory to load all relevant paths. All functions/scripts should be run from the root directory, relative paths are defined within.


Data should be placed within the root directory in folder named  `data`;
  .analytics files should be placed in a subfolder `data/analytics`;
`collect_data.m` will look for files in this folder. If you run the script from somewhere else

```matlab
    % add paths required for the project:
    startup()
    % run collect_data
    collect_data()
```
geneExpression.mat`
