#!/bin/bash
set -eu

source lib/helpers.sh
readonly DEPS=(xorriso unix2dos)
check_deps DEPS

readonly HTML_DOCS_DIR='build/html_docs'
readonly TXT_DOCS_DIR='src/iso/DOCS'

rm -r "${HTML_DOCS_DIR:?HTML output dir wasn\'t set!}" 2> /dev/null || true
mkdir -p "$HTML_DOCS_DIR"

rm -r "${TXT_DOCS_DIR:?TXT output dir wasn\'t set!}" 2> /dev/null || true
mkdir -p "$TXT_DOCS_DIR"

echo "Writing HTML docs to $HTML_DOCS_DIR"
echo "Writing TXT docs to $TXT_DOCS_DIR, which will be included in the ISO next time it's built"
for doc in src/docs/*.md
do
	pandoc -f markdown -t html5 --template lib/GitHub.html5 -o "$HTML_DOCS_DIR/$(basename ${doc/%.md/.html})" -s --lua-filter lib/links-to-html.lua "$doc" 
	pandoc -f markdown-smart -t rst --columns 79 --ascii -o "$TXT_DOCS_DIR/$(basename ${doc/%.md/.txt})" -s --lua-filter lib/links-to-txt.lua "$doc" 
done
unix2dos "$TXT_DOCS_DIR"/*.txt
