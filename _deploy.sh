## clone the repository to the book-output directory
cd docs
cp -r ../swots/_book/* ./
git add --all *
git commit -m "update worksheets"
git push -q origin master
