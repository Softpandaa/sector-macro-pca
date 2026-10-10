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
