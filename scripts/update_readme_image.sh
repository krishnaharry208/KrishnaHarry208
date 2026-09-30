#!/usr/bin/env bash
# Update the generated GitHub metrics image URL with a cache-busting commit SHA.
set -euo pipefail
REPO_USER="krishnaharry208"
REPO_NAME="KrishnaHarry208"
BRANCH="main"
FILE="github-metrics.svg"
README="README.md"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repository. Run this script from the repo root."
  exit 1
fi
SHA=$(git rev-parse --short HEAD)
RAW_URL="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/${FILE}?v=${SHA}"
TEMP_README=$(mktemp "${README}.XXXXXX")
trap 'rm -f "$TEMP_README"' EXIT

RAW_URL="$RAW_URL" perl -0777 -pe '
  s{(<img\b[^>]*\bsrc=")[^\"]*github-metrics\.svg(?:\?[^\"]*)?(\")}
   {$1 . $ENV{RAW_URL} . $2}e or die "No github-metrics.svg image found in README\n";
' "$README" > "$TEMP_README"
chmod --reference="$README" "$TEMP_README"
mv "$TEMP_README" "$README"
trap - EXIT

echo "Updated $README to use $RAW_URL"

echo "Done. Review changes and commit if desired:"
echo "  git add $README && git commit -m 'cache-bust GitHub metrics in README'"
