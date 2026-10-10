# Reads the three committed data files and builds the analysis samples.

read_dated <- function(path, format, ...) {
  x <- read.csv(path, check.names = FALSE, ...)
  names(x)[1] <- "Date"
  x$Date <- as.Date(x$Date, format = format)
  x
}

read_sector <- function() read_dated(SECTOR_FILE, "%d/%m/%Y")
read_macro  <- function() read_dated(MACRO_FILE, "%m/%d/%Y", fileEncoding = "UTF-8-BOM")

read_sp500 <- function() {
  x <- read_dated(SP500_FILE, "%Y-%m-%d")
  x[x$Date <= SP500_END, ]
}

# Macroeconomic indicators, labeled as in Table 1 of the report.
macro_data <- function() {
  x <- read_macro()[, -1]
  names(x) <- sub("Order$", "Orders", gsub("_", " ", names(x)))
  x
}

# Sector prices over the training sample.
sector_price_data <- function() {
  s <- read_sector()
  s[s$Date < TEST_START, -1]
}

# Daily log returns of the S&P 500 and the eleven sectors on their common
# trading days, split into training and testing samples.
returns <- function() {
  p <- merge(read_sp500(), read_sector(), by = "Date")
  r <- diff(log(as.matrix(p[, -1])))
  date <- p$Date[-1]
  train <- date < TEST_START
  list(date = date, train = train, r = r)
}
