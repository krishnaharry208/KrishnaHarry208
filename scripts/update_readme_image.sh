#!/usr/bin/env bash
# Update README image URL for asdf.png with cache-busting commit SHA
set -euo pipefail
REPO_USER="krishnaharry208"
REPO_NAME="KrishnaHarry208"
BRANCH="main"
FILE="asdf.png"
README="README.md"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository. Run this script from the repo root."
  exit 1
fi
SHA=$(git rev-parse --short HEAD)
RAW_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/${FILE}?v=${SHA}"

# Use perl to replace existing asdf.png src occurrences
perl -0777 -pe "s{(<img[^>]+src=")[^\"]*asdf\.png(\"[^>]*>)}{
\1${RAW_URL}\2}gs" -i "$README"

echo "Updated $README to use $RAW_URL"

echo "Done. Review changes and commit if desired:"
echo "  git add $README && git commit -m 'cache-bust asdf.png in README'"
