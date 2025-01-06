FROM rocker/r-ver:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libcairo2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install common R packages
RUN R -e "install.packages(c('languageserver', 'httpgd'))"

# Create non-root user
RUN useradd -m -s /bin/bash rstudio
USER rstudio

# Set working directory
WORKDIR /workspaces
