#!/bin/bash
# .devcontainer/setup.sh
# Installs Python and R dependencies for the Research Data Tutorials.
# Called by postCreateCommand in devcontainer.json.

set -e

echo "=== Installing Python packages ==="
pip install --quiet \
    duckdb \
    pandas \
    pyarrow \
    jupyterlab \
    altair \
    plotly \
    seaborn \
    matplotlib \
    nbstripout

echo "=== Installing R ==="
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    r-base \
    r-base-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev

echo "=== Installing R packages ==="
sudo R --quiet -e "
options(repos = c(CRAN = 'https://cloud.r-project.org'))
pkgs <- c('IRkernel', 'duckdb', 'dplyr', 'arrow', 'readr', 'DBI')
install.packages(pkgs, dependencies = TRUE)
missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
if (length(missing) > 0) stop(paste('Failed to install:', paste(missing, collapse=', ')))
cat('All R packages installed OK.\n')
"

echo "=== Registering R kernel with Jupyter ==="
R --quiet -e "IRkernel::installspec(user = TRUE)"

echo "=== Setting up nbstripout ==="
nbstripout --install || true   # non-fatal if not in a git repo

echo "=== Verifying kernels ==="
jupyter kernelspec list

echo "=== Setup complete ==="
