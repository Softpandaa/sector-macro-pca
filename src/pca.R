# Data, principal component analysis and principal component regression.

# Data ------------------------------------------------------------------------
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

# PCA -------------------------------------------------------------------------
# Principal component analysis on the correlation matrix.

pca <- function(x) prcomp(x, scale. = TRUE)

variance_table <- function(p) {
  v <- p$sdev^2
  data.frame(eigenvalue = v, proportion = v / sum(v),
             cumulative = cumsum(v) / sum(v))
}

# Shares of the off-diagonal correlations that are positive, strong among
# the positive ones, and strong overall.
corr_shares <- function(x) {
  C <- cor(x)
  r <- C[upper.tri(C)]
  c(positive = mean(r > 0),
    strong_of_positive = mean(r[r > 0] > STRONG_CORR),
    strong = mean(r > STRONG_CORR))
}

# PCR -------------------------------------------------------------------------
# Principal component regression of the S&P 500 return on the principal
# components of the eleven sector returns.

pcr_fit <- function(d = returns()) {
  y  <- d$r[d$train, "SP500"]
  X  <- d$r[d$train, -1]
  yt <- d$r[!d$train, "SP500"]
  p  <- pca(X)
  Z  <- as.data.frame(p$x)
  Zt <- as.data.frame(predict(p, d$r[!d$train, -1]))

  r2 <- sapply(seq_len(ncol(Z)), function(k)
    summary(lm(y ~ ., data = data.frame(y = y, Z[, 1:k, drop = FALSE])))$r.squared)

  models <- list(`Model 1` = lm(y ~ PC1, data = Z),
                 `Model 2` = lm(reformulate(paste0("PC", 1:N_PC), "y"), data = Z))
  pred   <- sapply(models, predict, newdata = Zt)

  set.seed(CV_SEED)
  cv <- pls::pcr(y ~ X, scale = TRUE, validation = "CV")

  list(pca = p, r2 = r2, models = models, rmsep = pls::RMSEP(cv)$val["CV", 1, ],
       test_date = d$date[!d$train], actual = yt, pred = pred,
       error = yt - pred)
}
