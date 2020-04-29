dois <- readLines("data/pubmed/id/20200423.doi")
for(i in dois) {
  basedir <- sprintf("data/fulltext/%s", i)
  if (file.exists(basedir)) {
    if (length(list.files(basedir, ".pdf")) == 0) {
      cat(i, sep = "\n")
    }
  }
}
