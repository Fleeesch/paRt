#!/bin/bash

# Setup adoc in WSL so you can convert adoc to pdf.

sudo apt update &&
sudo apt install ruby ruby-dev build-essential -y &&
sudo gem install asciidoctor-pdf