#!/bin/bash
# .devcontainer/setup.sh
# Installs Python and R dependencies for the Research Data Tutorials.
# Called by postCreateCommand in devcontainer.json.

set -e   # exit on any error

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
sudo apt-get install -y -qq r-base r-base-dev

echo "=== Installing R packages ==="
# Install to user library so no sudo needed at runtime
R --quiet -e "
options(repos = c(CRAN = 'https://cloud.r-project.org'))
install.packages(c('IRkernel', 'duckdb', 'dplyr', 'arrow', 'readr', 'DBI'))
IRkernel::installspec()
cat('R setup complete.\n')
"

echo "=== Setting up nbstripout ==="
nbstripout --install

echo "=== Setup complete ==="
echo "Python packages: duckdb, pandas, pyarrow, jupyterlab, altair, plotly, seaborn, matplotlib"
echo "R packages: IRkernel, duckdb, dplyr, arrow, readr, DBI"
echo "JupyterLab will start automatically — look for the forwarded port 8888."
