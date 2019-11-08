#!/bin/bash

# only proceed script when started not by pull request (PR)
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

# build site with jekyll, by default to `_site' folder
bundle exec jekyll build

# debug-- output all bib items
grep '<li>' _site/index.html

# cleanup
rm -rf ../gh-pages

#clone `gh-pages' branch of the repository using encrypted GH_TOKEN for authentification
git clone https://${GH_TOKEN}@github.com/th-nuernberg/publications.git \
	--branch gh-pages --single-branch ../gh-pages

# copy generated HTML site to `master' branch
echo "Updating static _site content..."
rm -r ../gh-pages/*
cp -R _site/* ../gh-pages/

# commit and push generated content to `master' branch
# since repository was cloned in write mode with token auth - we can push there
cd ../gh-pages

echo "Committing changes to gh-pages..."
git config --global user.email "korbinianr@gmail.com"
git config --global user.name "Korbinian Riedhammer"
git add -A .
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push origin gh-pages # > /dev/null 2>&1

exit 0
