# Research Data Tutorials

Hands-on notebooks for working with research data using DuckDB, Parquet, and
related tools — in both Python and R.

Developed as part of research data infrastructure work at a higher education
institution. Intended for researchers and data professionals who want practical
examples of modern, open, on-premises-friendly data tooling.

---

## Quickest start — run in the browser (no install needed)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/IREI-UI/research-data-tutorials-jupyter)

Click the button above to open the tutorials in a full JupyterLab environment
that runs entirely in your browser. No installation required — works on
Windows, Mac, and Linux.

**You will need a free GitHub account.** First launch takes 2–3 minutes while
the environment builds (R packages are the slow part); subsequent launches are
much faster as the image is cached.

Free tier: GitHub provides 120 core-hours/month at no cost — more than enough
for working through these tutorials.

---

## Running locally on Windows

If you prefer to work locally, or need to work offline, the following steps
set up a full local environment on Windows. **No administrator rights required.**

### Step 1 — Install uv

Open PowerShell and run:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Close and reopen PowerShell after installation so `uv` is available on your PATH.

### Step 2 — Clone the repository

```powershell
git clone https://github.com/IREI-UI/research-data-tutorials-jupyter.git
cd research-data-tutorials-jupyter
```

If you don't have Git installed, download it from
[git-scm.com/download/win](https://git-scm.com/download/win) — the installer
does not require admin rights if you choose the portable option.

### Step 3 — Install dependencies and launch JupyterLab

```powershell
uv sync
uv run jupyter lab
```

`uv sync` downloads Python 3.13 and all required packages automatically —
you do not need to install Python separately. JupyterLab will open in your
default browser.

### Step 4 — R support (optional)

If you want to run the R notebooks, install R from
[cran.r-project.org](https://cran.r-project.org/bin/windows/base/) — this
does require a one-time install. Then from an R console:

```r
install.packages(c("IRkernel", "duckdb", "dplyr", "arrow", "readr", "DBI"))
```

Register the R kernel so JupyterLab can find it. Open PowerShell in the
project folder and run:

```powershell
$env:PATH = ".\.venv\Scripts;" + $env:PATH
R -e "IRkernel::installspec()"
```

The PATH prefix ensures R can find the Jupyter installation inside the
project's virtual environment. This is a one-time step.

---

## What's here

| Notebook | Language | Covers |
|---|---|---|
| `notebooks/python/01_intro_duckdb_parquet.ipynb` | Python | Loading CSV/Parquet, creating DuckDB databases, basic queries |
| `notebooks/r/01_intro_duckdb_parquet.ipynb` | R | Same ground covered in R with DBI/dplyr |

More notebooks to follow.

---

## Fake dataset

All notebooks use a small synthetic health research dataset in `data/`.
**No real patient data is used anywhere in this repository.**

The dataset contains three tables:

| File | Rows | Description |
|---|---|---|
| `data/raw_csv/patients.csv` | 200 | Patient demographics and primary diagnosis |
| `data/raw_csv/visits.csv` | ~880 | Clinical visits per patient |
| `data/raw_csv/medications.csv` | ~434 | Medication records per patient |

On first run, notebooks convert these CSVs to Parquet under `data/parquet/`
and create a local `data/tutorial.duckdb`. Both are gitignored.

---

## Setup

### Python

Requires Python 3.10+ and [uv](https://docs.astral.sh/uv/):

```bash
uv sync
uv run jupyter lab
```

### R

Requires R 4.2+ with the IRkernel registered:

```r
install.packages("IRkernel")
IRkernel::installspec()
```

Restore R package dependencies:

```r
install.packages("renv")
renv::restore()
```

Then launch JupyterLab as above and select the R kernel when opening an R notebook.

**macOS gotcha — IRkernel can't find Jupyter**

If `IRkernel::installspec()` fails because it can't find `jupyter` (the install
tries to run `jupyter kernelspec --version` internally), it means Jupyter is
installed inside the project's `uv` virtual environment but is not on the PATH
that R sees.

Fix: launch R from the terminal with the `.venv/bin` directory prepended to PATH:

```bash
PATH=$PATH:./.venv/bin R
```

Then run `IRkernel::installspec()` again from that R session. This is a one-time
step — once the kernel is registered it will be available in JupyterLab regardless.

#

### First run

Both notebooks include a setup cell that converts the source CSVs to Parquet
and initialises the DuckDB file. Run this cell once — subsequent cells read
from Parquet/DuckDB directly.

---

## Notebook outputs and Git

Jupyter saves output cells (DataFrames, printed results, etc.) into the
`.ipynb` file. This is convenient locally but creates noisy Git diffs and
risks accidentally committing data snippets if notebooks are ever run against
real data.

The recommended fix is `nbstripout`, which strips outputs automatically at
`git commit` time via a Git hook:

```bash
uv add --dev nbstripout
nbstripout --install   # run once per clone — installs the Git hook
```

After this, outputs are cleared on every commit. You still see them while
working locally; they just don't go into Git.

---


## Data sovereignty note

All tooling used here (DuckDB, Apache Parquet, Apache Arrow) is open source,
runs fully locally, and requires no cloud services or external API calls.
Suitable for sensitive research data subject to GDPR or institutional
data governance requirements.

---

## Related

The migration toolkit (migrating legacy Excel/Access files to Parquet/DuckDB)
lives in a separate repository. If you want to migrate legacy data before
working through these tutorials, start there.

---

## .gitignore note

`data/parquet/`, `data/*.duckdb`, `logs/`, and `.env` are gitignored.
Never commit real data or API tokens to this repository.
