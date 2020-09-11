## clone the repository to the book-output directory
git clone  \
  https://${GITHUB_PAT}@github.com/${TRAVIS_REPO_SLUG}.git \
  docs
cd docs
git rm -rf *
touch .nojekyll
cp -r ../swots/_book/* ./
git add --all *
git commit -m "update worksheets"
git push -q origin master
rm -r swots/_book/ swots/_bookdown_files/
