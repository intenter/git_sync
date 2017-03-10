# git_sync
Script for unidirectional sync of selective git branches.
Within certain workflows it is needed to sync some of the branches from one repo to another and some other branches back.
The typical scenario is syncing all feature branches from working repo to the main one and integration branches back.

## Usage

### Setup
Create working directory. Clone the repo into it and setup the remotes you want to work with.
Copy/clone the script. Edit it to have WRKDIR variable pointing to the working directory with the repos. Please use absolute path.
Edit script to add sync commands to the end of it.

### Fetching from remotes
It makes sense to fetch from the remotes once to avoid this step for every branch. To do this call `fetch_remote` function:

```
fetch_remote "repo" "remote1"
fetch_remote "repo" "remote2"
```
- `repo` is the name of the folder in the working directory you cloned your repo to
- `remote2` and `remote2` are the names of remotes configured in the repo

### Syncing single branches
To run sync for a single branch you need make the following call:
```
sync_branch "repo" "remote1" "remote2" "master"
```
In this example we're syncing `master` branch from `remote1` to `remote2`.

### Syncing multiple branches

There is also a way to sync multiple branches without need to specify all of them:
```
sync_branches "repo" "remote1" "remote2" "feature/*"
```
As the result all the feature branches will be synced. New branches that follow the pattern will be picked up automatically.

The script does not delete any branches currently. If the branch removed from the source remote it will not be synced from the local working copy.
