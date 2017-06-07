#!/bin/bash

# Download list of repositories and store the list into "repoinfo".
curl -u ${1} https://api.bitbucket.org/2.0/repositories/${2}?pagelen=100 > repoinfo

# Clone/update repositories as needed.
for repo_name in `cat repoinfo | jq '.values[] | .full_name' | sed -e 's/"//g'`
do
	dir=`basename "$repo_name"`
	if [ -d "$dir" ]; then
		echo "updating " $repo_name
		cd $dir
		git pull origin master
		cd ..
	else
		echo "cloning " $repo_name
        	git clone https://${1}@bitbucket.org/$repo_name
	fi
done

# Remove temporary file.
rm -rf repoinfo
