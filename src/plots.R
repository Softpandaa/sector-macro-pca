# Figures of the report, written to FIG_DIR.

OKABE_ITO <- c(blue = "#0072B2", vermillion = "#D55E00")
CORR_COLORS <- colorRampPalette(c(OKABE_ITO["blue"], "white", OKABE_ITO["vermillion"]))(101)

figure <- function(name, draw, width = 6.5, height = 3, mfrow = c(1, 1)) {
  png(file.path(FIG_DIR, name), width = width, height = height,
      units = "in", res = 300, family = "serif", type = "cairo")
  par(mfrow = mfrow, mar = c(4, 4, 2, 1), las = 1)
  draw()
  invisible(dev.off())
}

# Lower triangle of a correlation matrix, diagonal excluded.
corr_triangle <- function(x, main) {
  C <- cor(x); n <- ncol(C)
  z <- t(C[n:2, 1:(n - 1)])
  z[col(z) > n - row(z)] <- NA
  image(1:(n - 1), 1:(n - 1), z, zlim = c(-1, 1), col = CORR_COLORS,
        axes = FALSE, xlab = "", ylab = "", main = main)
  axis(1, 1:(n - 1), colnames(C)[1:(n - 1)], las = 2, tick = FALSE)
  axis(2, 1:(n - 1), colnames(C)[n:2], las = 1, tick = FALSE)
  ok <- which(!is.na(z), arr.ind = TRUE)
  text(ok[, 1], ok[, 2], sprintf("%.2f", round(z[ok], 2) + 0), cex = 0.5)
}

corr_scale <- function() {
  par(mar = c(9, 0.2, 2.5, 1.8))
  s <- seq(-1, 1, length.out = 101)
  image(1, s, matrix(s, 1), col = CORR_COLORS, axes = FALSE, xlab = "", ylab = "")
  axis(4, seq(-1, 1, 0.5), cex.axis = 0.6, mgp = c(3, 0.4, 0))
  box()
}

corr_figure <- function(sector, macro) {
  layout(matrix(1:3, 1), widths = c(1, 1.15, 0.2))
  par(mar = c(9, 7, 2.5, 0.5), cex.axis = 0.7)
  corr_triangle(sector, "Sector prices")
  par(mar = c(9, 9, 2.5, 0.5))
  corr_triangle(macro, "Macroeconomic data")
  corr_scale()
}

scree_panel <- function(p) {
  v <- p$sdev^2
  plot(seq_along(v), v, type = "b", pch = 19, xlab = "Principal component",
       ylab = "Eigenvalue", xaxt = "n")
  axis(1, seq_along(v), cex.axis = 0.8, gap.axis = 0)
  abline(h = KAISER, lty = 2, col = OKABE_ITO["vermillion"])
}

pareto_panel <- function(p) {
  cum <- variance_table(p)$cumulative
  plot(seq_along(cum), cum, type = "b", pch = 19, ylim = c(0, 1),
       xlab = "Principal component", ylab = "Cumulative share of variance", xaxt = "n")
  axis(1, seq_along(cum), cex.axis = 0.8, gap.axis = 0)
  abline(h = PARETO, lty = 2, col = OKABE_ITO["vermillion"])
}

loading_panels <- function(p) for (i in 1:N_PC) {
  l <- sort(p$rotation[, i])
  dotchart(l, main = paste0("PC", i), xlab = "Loading", pch = 19,
           col = OKABE_ITO["blue"], xlim = range(c(0, l)))
  abline(v = 0, lty = 2)
}

cv_panel <- function(cv) {
  e <- RMSEP(cv)$val[1, 1, ]
  k <- seq_along(e) - 1
  plot(k, e, type = "b", pch = 19, log = "y", xaxt = "n",
       xlab = "Number of components", ylab = "RMSEP (log scale)")
  axis(1, k, cex.axis = 0.8, gap.axis = 0)
}

residual_panels <- function(models) for (nm in names(models)) {
  m <- models[[nm]]
  plot(fitted(m), resid(m), pch = 1, cex = 0.5, main = nm,
       xlab = "Fitted value", ylab = "Residual")
  abline(h = 0, lty = 2)
  lines(lowess(fitted(m), resid(m)), col = OKABE_ITO["vermillion"], lwd = 1.5)
}

test_fit_panels <- function(f) {
  lim <- range(c(f$actual, f$pred))
  for (nm in colnames(f$pred)) {
    plot(f$actual, f$pred[, nm], pch = 1, cex = 0.5, main = nm, xlim = lim, ylim = lim,
         xlab = "Actual return", ylab = "Predicted return", asp = 1)
    abline(0, 1, lty = 2, col = OKABE_ITO["vermillion"])
  }
}

error_panels <- function(f) {
  br <- pretty(range(f$error), 10)
  top <- max(sapply(colnames(f$error), function(nm) max(hist(f$error[, nm], br, plot = FALSE)$counts)))
  for (nm in colnames(f$error))
    hist(f$error[, nm], breaks = br, ylim = c(0, top), main = nm,
         xlab = "Actual less predicted return", col = "grey85", border = "grey30")
}

write_figures <- function(mp, sp, f) {
  dir.create(FIG_DIR, showWarnings = FALSE, recursive = TRUE)
  figure("corr.png", function() corr_figure(sector_price_data(), macro_data()), height = 3.9)
  figure("variance_macro.png", function() { scree_panel(mp); pareto_panel(mp) }, mfrow = c(1, 2))
  figure("variance_sector.png", function() { scree_panel(sp); pareto_panel(sp) }, mfrow = c(1, 2))
  figure("loadings_macro.png", function() loading_panels(mp), height = 3.2, mfrow = c(1, N_PC))
  figure("loadings_sector.png", function() loading_panels(sp), height = 3.2, mfrow = c(1, N_PC))
  figure("cv.png", function() cv_panel(f$cv), width = 4.5)
  figure("residuals.png", function() residual_panels(f$models), mfrow = c(1, 2))
  figure("errors.png", function() error_panels(f), mfrow = c(1, 2))
  figure("test_fit.png", function() test_fit_panels(f), height = 3.4, mfrow = c(1, 2))
}
