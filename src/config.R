# Every parameter of the project, declared once.

DATA_DIR <- "data"
FIG_DIR  <- file.path("latex", "figures")

SECTOR_FILE <- file.path(DATA_DIR, "Sector_price.csv")
MACRO_FILE  <- file.path(DATA_DIR, "macro_monthly_data.csv")
SP500_FILE  <- file.path(DATA_DIR, "sp500.csv")

SP500_END  <- as.Date("2023-11-02")  # last S&P 500 close used
TEST_START <- as.Date("2023-01-01")  # first date of the testing sample

N_PC          <- 2    # components retained in every PCA and in Model 2
KAISER        <- 1    # eigenvalue threshold of the Kaiser rule
PARETO        <- 0.75 # cumulative variance benchmark of the Pareto plot
STRONG_CORR   <- 0.5  # threshold of a strong correlation
ERROR_BAND    <- 0.002 # testing error band reported around zero
CV_SEED       <- 1    # seed of the random cross-validation segments
