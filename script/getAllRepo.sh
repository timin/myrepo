#!/bin/bash

# Brief: A script to checkout(clone) all repositories of GitHub organisation
# Usage: ./getAllRepo.sh <github_username> <number_of_repos_in_org>

GH_USER=""
REPO_COUNT=0

# SCOPE: "users" to download all user's repositories or "orgs" to download all orgs's repositories
SCOPE="orgs"
# CONTEXT: "user_name" to download all user's repositories or "org_name" to download all org's repositories
CONTEXT="chef-base-plans"
PAGE=1
COUNT=0

if [ -z "$1" ]; then
	echo "usage: ./getAllRepo.sh <github_username> <number_of_repos_in_org>"
	exit 1
else
	GH_USER=$1
	REPO_COUNT=$2
fi

echo "User:$GH_USER"
echo "Count:$REPO_COUNT"

while [ $COUNT -le $REPO_COUNT ]
do
	echo "Downloading repos from $COUNT to $((COUNT+100))"

	curl -su $GH_USER "https://api.github.com/$SCOPE/$CONTEXT/repos?type=all&sort=full_name&per_page=100&page=$PAGE" | jq '.[] | "\(.ssh_url)"' | xargs -L1 git clone -q

	COUNT=$((PAGE*100))
	PAGE=$((PAGE+1))
done

echo "Downloaded repo count $REPO_COUNT"

exit 0
