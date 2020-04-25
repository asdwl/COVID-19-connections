options(stringsAsFactors = FALSE)
library(data.table)
# analysis region data
countries <- readLines("ref/world-countries.csv")
countries <- countries[4:length(countries)]
cities <- as.data.frame(fread("ref/world-cities.csv", encoding = "UTF-8"))[,1]

print(head(countries))
print(head(cities))

if (!file.exists("cor/raw.json")) {
  cmd = sprintf("bioextr --mode pubmed -t 60 xml/*.json > cor/raw.json")
  system(cmd)
}

ct <- paste0(c(countries, cities), "[^0-9a-zA-Z]")
cat(ct, file = "/tmp/bioextr.kws", sep = "\n")

#if (!file.exists("cor/abs_countries_cities.json")) {
  cmd = sprintf("bioextr --mode pubmed --call-cor --keywords-file /tmp/bioextr.kws -t 80 xml/*.json > cor/abs_countries_cities.json")
  system(cmd)
#}
#writeLines(as.character(dat[dat[,1] != "",1]), "id/20200423.pmid")
#writeLines(as.character(dat[dat[,2] != "",2]), "id/20200423.doi")
