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
    data = collect_data();
```

`data` is a big table where all data from sessions/blocks/trials are stacked together. 

  - `list_all_users()` - will list all unique user names found in the analytics directory
  - `delete_users()`   - will delete analytics files with a particular username (useful for deleting test or pilot runs)
  - `collect_validity_data()` - Same as `collect_data()` however looks for data in `data/validity-analytics`
