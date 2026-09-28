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

  list(pca = p, r2 = r2, models = models, cv = cv,
       test_date = d$date[!d$train], actual = yt, pred = pred,
       error = yt - pred)
}
