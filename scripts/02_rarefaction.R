library(vegan)

CELL <- 0.5
N_RARE <- 10

df <- read.csv("data/clean_frogs.csv")

# 1. Put each record into a grid cell
df$cell_x <- floor(df$decimalLongitude / CELL) * CELL
df$cell_y <- floor(df$decimalLatitude / CELL) * CELL
df$cell <- paste(df$cell_x, df$cell_y, sep = "_")

# 2. Table: one row per cell, one column per species, values = counts
tab <- table(df$cell, df$species)
records <- rowSums(tab)
cat("Cells with data:", nrow(tab), "\n")

# 3. Keep cells with at least 10 records
tab <- tab[records >= N_RARE, ]
cat("Cells with at least", N_RARE, "records:", nrow(tab), "\n\n")

# 4. Rarefied richness
res <- data.frame(
  cell = rownames(tab),
  records = rowSums(tab),
  observed = rowSums(tab > 0),
  rarefied = as.numeric(rarefy(tab, sample = N_RARE))
)
res <- res[order(-res$rarefied), ]
print(res, row.names = FALSE, digits = 2)

# 5. Rank correlation with number of records
cat(
  "\nCorrelation with records, observed:",
  round(cor(res$records, res$observed, method = "spearman"), 2),
  "\n"
)
cat(
  "Correlation with records, rarefied:",
  round(cor(res$records, res$rarefied, method = "spearman"), 2),
  "\n"
)
