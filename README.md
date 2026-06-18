# Research Data Tutorials

Hands-on notebooks for working with research data using DuckDB, Parquet, and
related tools — in both Python and R.

Developed as part of research data infrastructure work at a higher education
institution. Intended for researchers and data professionals who want practical
examples of modern, open, on-premises-friendly data tooling.

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

### First run

Both notebooks include a setup cell that converts the source CSVs to Parquet
and initialises the DuckDB file. Run this cell once — subsequent cells read
from Parquet/DuckDB directly.

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
