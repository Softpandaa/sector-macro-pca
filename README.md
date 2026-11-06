# Principal Components of US Sector Prices and Macroeconomic Data

This study asks how many principal components summarize 10 monthly US macroeconomic indicators and the prices of the 11 Select Sector SPDR ETFs, and what those components represent. It also regresses the daily S&P 500 log return on the components of the sector returns, from June 2018 to November 2023.

## Findings

Two components summarize each dataset, explaining 78.26% of the macroeconomic variance and 93.62% of the sector price variance. They describe inflation moving with consumption, wage growth set against production, a market-wide factor and an energy factor. Two components of the sector returns explain 97.14% of the in-sample S&P 500 return variance and beat one component in the testing sample.

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

R 4.3.3 with `pls` 2.8-3.

```
install.packages("pls")
Rscript src/run.R
```

This prints every number quoted in the report and draws its nine figures.
