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

if (!file.exists("cor/abs_countries_cities.json")) {
  cmd = sprintf("bioextr --mode pubmed --call-cor --keywords-file /tmp/bioextr.kws -t 80 xml/*.json > cor/abs_countries_cities.json")
  system(cmd)
}

hgnc <- as.data.frame(fread("ref/hgnc-simple.txt"))
alias_name <- unlist(str_split(hgnc[,"alias_name"], fixed("|")))
alias_symbol <- unlist(str_split(hgnc[,"alias_symbol"], fixed("|")))
ccds_id <- unlist(str_split(hgnc[,"ccds_id"], fixed("|")))
uniprot_ids <- unlist(str_split(hgnc[,"uniprot_ids"], fixed("|")))
refseq_accession <- unlist(str_split(hgnc[,"refseq_accession"], fixed("|")))

kw <- paste0(c(hgnc$symbol, hgnc$name, hgnc$ensembl_gene_id, alias_name,
               hgnc$ucsc_id, alias_symbol, ccds_id, uniprot_ids, refseq_accession), "[^0-9a-zA-Z]")
cat(kw, file = "/tmp/bioextr.kws", sep = "\n")

if (!file.exists("cor/abs_genes.json")) {
  cmd = sprintf("bioextr --mode pubmed --call-cor --keywords-file /tmp/bioextr.kws -t 80 xml/*.json > cor/abs_genes.json")
  system(cmd)
}
