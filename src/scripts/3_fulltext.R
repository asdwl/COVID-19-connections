id="20200423"
dois <- readLines('data/bigd/id/20200428.doi')
basedir <- sprintf("data/fulltext")
for (i in dois) {
  if (length(list.files(file.path(basedir, i), ".pdf")) == 0) {
    cat(i, sep = "\n")
    cat(i, sep = "\n", file="inprogress", append = T)
    cmd <- sprintf("bget doi %s -o data/fulltext -n --print-crossref --timeout 60 -r 1", i)
    system(cmd)
  }
}
