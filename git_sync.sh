#!/bin/bash

#Preparation
# 1. create a working directory. It's going to have repos folders inside.
# Set WORKDIR in script to poing to it. Use absolute path
# 2. clone repo into the working directory
# 3. setup remotes (at least 2) try to fetch from them to make sure connectivity is working

#Configuration
WRKDIR=/Volumes/MacHD/Users/intmac/projects/git_sync_wrk

# $1 - repo, $2 - remote from, $3 remote to, $4 - branch
sync_branches() {
	REPO=$1
	FROM=$2
	TO=$3
	BRANCH=$4
	cd "$WRKDIR/$REPO"
	for oneBranch in $(git branch --list --remote "$FROM/$BRANCH" | cut -c "$((4+${#FROM}))"-)
	do
		sync_branch "$REPO" "$FROM" "$TO" "$oneBranch"
	done
}

# $1 - repo, $2 - remote from, $3 remote to, $4 - branch
sync_branch() {
	REPO=$1
	FROM=$2
	TO=$3
	BRANCH=$4
	echo "------------------------------------------------------------"
	echo "Running sync on $REPO: $FROM/$BRANCH => $TO/$BRANCH"
	cd "$WRKDIR/$REPO"
	#check repo status here and reset if needed
	git fetch "$FROM"
	#check if local branch exists
	git rev-parse --verify --quiet "$BRANCH"
	if [[ $? != 0 ]]; then
		#create local branch matching remote
		echo "No local branch found. Creating"
		git branch --track "$BRANCH" "$FROM/$BRANCH"
  fi
	git checkout "$BRANCH"
	git pull --ff-only "$FROM" "$BRANCH"
	if [[ $? != 0 ]]; then
		echo "ERROR: Couldn't pull changes from source. Expected to be fast forward pull. Check for local changes."
	else
		git push "$TO" "$BRANCH"
		if [[ $? != 0 ]]; then
			echo "ERROR: Couldn't push branch $BRANCH to $TO"
		fi
	fi
}

sync_branch "test_repo1" "origin" "repo2" "master"
sync_branches "test_repo1" "repo2" "origin" "test*"
