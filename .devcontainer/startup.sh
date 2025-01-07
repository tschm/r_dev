#!/bin/bash
apt update
#apt install software-properties-common apt-transport-https ca-certificates curl

#add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
#curl -fsSL https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc
#gpg --dearmor -o /usr/share/keyrings/r-archive-keyring.gpg

wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2023.09.1-524-amd64.deb
apt install ./rstudio-2023.09.1-524-amd64.deb

rstudio