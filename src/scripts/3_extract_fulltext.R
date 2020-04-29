options(stringsAsFactors = FALSE)
library(openxlsx)
library(stringr)
library(data.table)
library(jsonlite)
# analysis region data
countries <- readLines("data/ref/world-countries.csv")
countries <- countries[4:length(countries)]
cities <- as.data.frame(fread("data/ref/world-cities.csv", encoding = "UTF-8"))[,1]

genesKw <- function () {
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
  genes <- c(hgnc$symbol, alias_symbol)
  gnees <- genes[!genes %in% c("B", "mol")]
  kw <- paste0("[^0-9a-zA-Z]", genes, "[^0-9a-zA-Z]")
  return (kw)
}
json2simptb <- function(infile, kwfile, outprefix) {
  cmd = sprintf("bioextr --mode plain --call-cor --keywords-file %s -t 20 -l %s > %s.json && json2csv -i %s.json -o %s.csv",
                 kwfile, infile, outprefix, outprefix, outprefix)
  system(cmd)
  dat <- as.data.frame(fread(sprintf("%s.csv", outprefix)))
  #dat <- dat[,c("Pmid", "Doi", "Keywords", "Correlation")]
  for (i in 1:ncol(dat)) {
    dat[,i] <- str_replace_all(dat[,i], '""', '"')
    dat[,i] <- str_replace_all(dat[,i], '\n\n', '\n')
    dat[,i] <- str_replace_all(dat[,i], '\n', ' ')
  }
  write.xlsx(dat, sprintf("%s.xlsx", outprefix))
  file.remove(paste0(outprefix, c(".csv", ".json")))
}

files <- readLines("data/fulltext/plain_list")

if (!file.exists("result/cor/fulltext_countries_cities.xlsx")) {
  kw <- paste0("[^0-9a-zA-Z]", c(countries, cities), "[^0-9a-zA-Z]")
  ct <- paste0(c(countries, cities))
  cat(ct, file = "/tmp/bioextr.fulltext.kws", sep = "\n")
  json2simptb("data/fulltext/plain_list", "/tmp/bioextr.fulltext.kws", "result/cor/fulltext_countries_cities")
}

if (!file.exists("result/cor/fulltext_genes.xlsx")) {
  kw <- genesKw()
  cat(kw, file = "/tmp/bioextr.fulltext.kws", sep = "\n")
  json2simptb("data/fulltext/plain_list", "/tmp/bioextr.fulltext.kws", "result/cor/fulltext_genes")
}

if (!file.exists("result/cor/fulltext_treatment.xlsx")) {
  items <- "COVID-19, SARS, patient, death, die, dying, dyspnea, complication, symptom, relapse, remission, life-support, machine, drug, medicine, agent, treatment, therapy, therapeutics, intervention"
  kw <- paste0("[^0-9a-zA-Z]", unlist(str_split(items, ", ")), "[^0-9a-zA-Z]")
  cat(kw, file = "/tmp/bioextr.fulltext.kws", sep = "\n")
  json2simptb("data/fulltext/plain_list", "/tmp/bioextr.fulltext.kws", "result/cor/fulltext_treatment")
}

for (j in c("fulltext_treatment_clean.xlsx", "fulltext_genes_clean.xlsx", "fulltext_countries_cities_clean.xlsx")) {
if (!file.exists(sprintf("result/cor/%s", j))) {
  infile <- str_replace(j, "_clean", "")
  dat <- read.xlsx(sprintf("result/cor/%s", infile))
  black_pat <- "Oxford University Press|Published online|^Accessed|Corresponding Author|Funding/Support|Author Affiliations|University|All rights reserved|How to cite this article|^Received.*Accepted|orcid.org|[oO][Rr][cC][iI][dD]|Accepted Article|[[][0-9]*[]] |Inc[.] | March "
  for (i in 1:ncol(dat)) {
    dat[,i] <- str_replace_all(dat[,i], '""', '"')
    dat[,i] <- str_replace_all(dat[,i], '\n\n', '\n')
    dat[,i] <- str_replace_all(dat[,i], '\\n\\n', '\n')
    dat[,i] <- str_replace_all(dat[,i], '\\\\n', '\n')
    dat[,i] <- str_replace_all(dat[,i], '\n', ' ')
  }
  doi <- str_split(dat[,1], "/")
  doi <- sapply(doi, function(x){
    dirname(paste(x[3:length(x)], collapse = "/"))
  })
  dat <- cbind(doi, dat)
  write.xlsx(dat, sprintf("result/cor/%s", j))
}
}
