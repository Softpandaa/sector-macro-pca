# Every parameter of the project, declared once.

# Paths -----------------------------------------------------------------------
DATA_DIR    <- "data"
FIG_DIR     <- file.path("latex", "figures")
SECTOR_FILE <- file.path(DATA_DIR, "Sector_price.csv")
MACRO_FILE  <- file.path(DATA_DIR, "macro_monthly_data.csv")
SP500_FILE  <- file.path(DATA_DIR, "sp500.csv")

# Sample ----------------------------------------------------------------------
SP500_END  <- as.Date("2023-11-02")  # last day of the testing sample
TEST_START <- as.Date("2023-01-01")

# PCA and regression ----------------------------------------------------------
N_PC        <- 2      # PCs retained for macro data, sector prices and Model 2
KAISER      <- 1      # eigenvalue cut-off on the scree plot
PARETO      <- 0.75   # minimum cumulative share of variance
STRONG_CORR <- 0.5
ERROR_BAND  <- 0.002  # |testing error| below this counts as near zero
CV_SEED     <- 1      # random cross-validation segments
