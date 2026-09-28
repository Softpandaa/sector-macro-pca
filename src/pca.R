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
  c <- cor(x)[upper.tri(diag(ncol(x)))]
  c(positive = mean(c > 0),
    strong_of_positive = mean(c[c > 0] > STRONG_CORR),
    strong = mean(c > STRONG_CORR))
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
