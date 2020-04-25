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

if (!file.exists("cor/abs_countries_cities.xlsx")) {
  ct <- paste0(c(countries, cities), "[^0-9a-zA-Z]")
  cat(ct, file = "/tmp/bioextr.kws", sep = "\n")
  cmd = sprintf("bioextr --mode pubmed --call-cor --keywords-file /tmp/bioextr.kws -t 20 xml/*.json > cor/abs_countries_cities.json")
  system(cmd)
}

if (!file.exists("cor/abs_genes.xlsx")) {
if (!file.exists("cor/abs_genes.json")) {
library(stringr)
hgnc <- as.data.frame(fread("ref/hgnc-simple.txt"))
alias_name <- unlist(str_split(hgnc[,"alias_name"], fixed("|")))
alias_name <- alias_name[alias_name != ""]
alias_symbol <- unlist(str_split(hgnc[,"alias_symbol"], fixed("|")))
alias_symbol <- alias_symbol[alias_symbol != ""]
ccds_id <- unlist(str_split(hgnc[,"ccds_id"], fixed("|")))
ccds_id <- ccds_id[ccds_id != ""]
uniprot_ids <- unlist(str_split(hgnc[,"uniprot_ids"], fixed("|")))
uniprot_ids <- uniprot_ids[uniprot_ids != ""]
refseq_accession <- unlist(str_split(hgnc[,"refseq_accession"], fixed("|")))
refseq_accession <- refseq_accession[refseq_accession != ""]

print(head(hgnc))

#kw <- paste0(c(hgnc$symbol, hgnc$name, hgnc$ensembl_gene_id, alias_name,
#               hgnc$ucsc_id, alias_symbol, ccds_id, uniprot_ids, refseq_accession), "[^0-9a-zA-Z]")
kw <- paste0("[^0-9a-zA-Z]", c(hgnc$symbol, alias_symbol), "[^0-9a-zA-Z]")
cat(kw, file = "/tmp/bioextr.kws", sep = "\n")
cmd = sprintf("bioextr --mode pubmed --call-cor --keywords-file /tmp/bioextr.kws -t 20 xml/*.json > cor/abs_genes.json && json2csv -i cor/abs_genes.json -o cor/abs_genes.csv -q '`' ")
system(cmd)
}

library(openxlsx)
library(data.table)
dat <- as.data.frame(fread("cor/abs_genes.csv"))
dat <- dat[,c("Pmid", "Doi", "Keywords", "Correlation")]
write.xlsx(dat, "cor/abs_genes.xlsx")
}
