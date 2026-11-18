library(vegan)

df <- read.csv("data/clean_frogs.csv")

print(nrow(df))
print(length(unique(df$species)))
print(head(df[, c("species", "decimalLatitude", "decimalLongitude", "year")]))
