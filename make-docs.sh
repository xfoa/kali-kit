#!/bin/bash
set -eu

readonly DOCS_DIR='html_docs'

rm -r "build/${DOCS_DIR:?Output dir wasn\'t set!}" 2> /dev/null || true
mkdir -p "build/$DOCS_DIR"

for doc in src/docs/*.md
do
	pandoc -f markdown -t html --template=lib/bootstrap_menu.html -o "build/$DOCS_DIR/$(basename ${doc/%.md/.html})" -s --lua-filter lib/links-to-html.lua "$doc" 
done
