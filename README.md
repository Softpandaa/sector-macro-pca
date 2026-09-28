# Principal Components of US Sector Prices and Macroeconomic Data

This study applies principal component analysis (PCA) to ten monthly US macroeconomic indicators and eleven Select Sector SPDR ETFs, and regresses the daily S&P 500 log return on the principal components of the sector returns from June 2018 to November 2023.

## Findings

Two components summarize each dataset, explaining 78.26% of the macroeconomic variance and 93.62% of the sector price variance. The macroeconomic components describe inflation moving with consumption, and wages set against production. The sector components describe a market-wide factor and an energy factor. A regression on the first two sector components explains 97.14% of the variance of the same-day S&P 500 return and beats the one-component regression in the testing sample.

## Layout

```
data/     committed input data
src/      analysis modules, every parameter declared once in config.R
report.pdf
```

The report is distributed as a compiled PDF. Its typesetting source is not included.

## Data

`data/Sector_price.csv` is the daily adjusted close of the eleven Select Sector SPDR ETFs. `data/sp500.csv` is the daily close of the S&P 500 index from Yahoo Finance. `data/macro_monthly_data.csv` holds the ten monthly indicators.

## Reproducing

R 4.3.3 with the `pls` package.

```
install.packages("pls")
Rscript src/run.R
```

Run from the repository root. This prints every number quoted in the report and writes the nine figure files it uses to `latex/figures/`, which is created on the first run and is not tracked.
