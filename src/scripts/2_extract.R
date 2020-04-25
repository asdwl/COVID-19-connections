options(stringsAsFactors = FALSE)
library(openxlsx)
library(stringr)
library(data.table)
# analysis region data
countries <- readLines("data/ref/world-countries.csv")
countries <- countries[4:length(countries)]
cities <- as.data.frame(fread("data/ref/world-cities.csv", encoding = "UTF-8"))[,1]

json2simptb <- function(infile, kwfile, outprefix) {
  cmd = sprintf("bioextr --mode pubmed --call-cor --keywords-file %s -t 30 %s > %s.json && json2csv -i %s.json -o %s.csv",
                 kwfile, infile, outprefix, outprefix, outprefix)
  system(cmd)
  dat <- as.data.frame(fread(sprintf("%s.csv", outprefix)))
  dat <- dat[,c("Pmid", "Doi", "Keywords", "Correlation")]
  for (i in 3:4) {
    dat[,i] <- str_replace_all(dat[,i], '""', '"')
  }
  write.xlsx(dat, sprintf("%s.xlsx", outprefix))
  file.remove(paste0(outprefix, c(".csv", ".json")))
}

if (!file.exists("result/cor/raw.json")) {
  cmd = sprintf("bioextr --mode pubmed -t 60 data/pubmed/xml/*.json > cor/raw.json")
  system(cmd)
}

if (!file.exists("result/cor/abs_countries_cities.xlsx")) {
  kw <- paste0("[^0-9a-zA-Z]", c(countries, cities), "[^0-9a-zA-Z]")
  ct <- paste0(c(countries, cities), "[^0-9a-zA-Z]")
  cat(ct, file = "/tmp/bioextr.kws", sep = "\n")
  json2simptb("data/pubmed/xml/*.json", "/tmp/bioextr.kws", "result/cor/abs_countries_cities")
}

if (!file.exists("result/cor/abs_genes.xlsx")) {
  if (!file.exists("result/cor/abs_genes.json")) {
    hgnc <- as.data.frame(fread("data/ref/hgnc-simple.txt"))
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
    kw <- paste0("[^0-9a-zA-Z]", c(hgnc$symbol, alias_symbol), "[^0-9a-zA-Z]")
    cat(kw, file = "/tmp/bioextr.kws", sep = "\n")
    json2simptb("data/pubmed/xml/*.json", "/tmp/bioextr.kws", "result/cor/abs_genes")
  }
}
