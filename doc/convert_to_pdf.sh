#!/bin/bash

# Converts the paRt user guide in your development folder to a PDF within WSL.

# Path to the AsciiDoc file
BASE_PATH="./"
ADOC_FILE="part_documentation.adoc"
THEME_FILE="adoc_theme.yml"

# Run Asciidoctor PDF
asciidoctor-pdf -a pdf-theme="$BASE_PATH$THEME_FILE" "$BASE_PATH$ADOC_FILE"
