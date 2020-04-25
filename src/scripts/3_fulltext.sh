id="20200423"
#for i in `sort -R id/${id}.doi`
for i in `cat dois`
do
echo ${i}
bget doi ${i} -o data/fulltext -n --print-crossref --timeout 60 -g simplego -r 1
done
