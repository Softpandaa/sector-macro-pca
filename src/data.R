# Reads the three committed data files.

read_sector <- function() {
  x <- read.csv(SECTOR_FILE, check.names = FALSE)
  names(x)[1] <- "Date"
  x$Date <- as.Date(x$Date, format = "%d/%m/%Y")
  x
}

read_macro <- function() {
  x <- read.csv(MACRO_FILE, fileEncoding = "UTF-8-BOM", check.names = FALSE)
  names(x)[1] <- "Date"
  x$Date <- as.Date(x$Date, format = "%m/%d/%Y")
  x
}

read_sp500 <- function() {
  x <- read.csv(SP500_FILE)
  x$Date <- as.Date(x$Date)
  x[x$Date <= SP500_END, ]
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
