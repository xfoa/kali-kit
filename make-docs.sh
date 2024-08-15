#!/bin/bash
set -eu

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
	pandoc -f markdown -t html --template=lib/bootstrap_menu.html -o "$HTML_DOCS_DIR/$(basename ${doc/%.md/.html})" -s --lua-filter lib/links-to-html.lua "$doc" 
	pandoc -f markdown -t rst --columns 80 -o "$TXT_DOCS_DIR/$(basename ${doc/%.md/.txt})" -s --lua-filter lib/links-to-txt.lua "$doc" 
done
unix2dos "$TXT_DOCS_DIR"/*.txt
