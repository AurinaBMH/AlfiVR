# AlfiVR
This repository contains scripts to process AlfiVR project data.


To run the scripts, first run `startup.m` function from the root directory to load all relevant paths.
All functions/scripts should be run from the root directory, relative paths are defined within.


`.analytics` files should be placed in `data/analytics` in the root directory.
`collect_data.m` will look for files only in this folder and otherwise will crash.

```matlab
    % add paths required for the project:
    startup()
    % run collect_data
    data = collect_data()
```
