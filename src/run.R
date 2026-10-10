# Single entry point. Run from the repository root: Rscript src/run.R
suppressPackageStartupMessages(library(pls))
for (script in c("config.R", "data.R", "pca.R", "pcr.R", "plots.R"))
  source(file.path("src", script))

pct <- function(x) round(100 * x, 2)

mp <- pca(macro_data())
sp <- pca(sector_price_data())
f  <- pcr_fit()

cat("Correlation shares (%)\n")
print(c(pct(corr_shares(macro_data())[c("positive", "strong_of_positive")]),
        sector_strong = pct(corr_shares(sector_price_data())[["strong"]])))

pcas <- list(`Macro PCA` = mp, `Sector price PCA (training)` = sp)
for (nm in names(pcas)) {
  cat("\n", nm, "\n", sep = "")
  v <- variance_table(pcas[[nm]])
  print(data.frame(eigenvalue = round(v$eigenvalue, 2), proportion = pct(v$proportion),
                   cumulative = pct(v$cumulative))[1:3, ])
  print(round(pcas[[nm]]$rotation[, 1:N_PC], 4))
}

cat("\nTable 3, cumulative proportion (%)\n")
print(rbind(PCs = pct(variance_table(f$pca)$cumulative), `S&P` = pct(f$r2)))

cat("\nCross-validated RMSEP, 0 to 11 components\n")
print(signif(f$rmsep, 3))
cat("\nResidual standard deviation\n")
print(signif(sapply(f$models, function(m) sd(resid(m))), 3))
cat("\nTesting sample", format(range(f$test_date)), "n =", length(f$actual), "\n")
print(rbind(RMSE = signif(sqrt(colMeans(f$error^2)), 3),
            `min (%)` = pct(apply(f$error, 2, min)), `max (%)` = pct(apply(f$error, 2, max)),
            `within band (%)` = round(100 * colMeans(abs(f$error) < ERROR_BAND), 1)))

write_figures(mp, sp, f)
