#date=20190423
#size=5764
mkdir xml
bget api ncbi -r 100000 -m 100 -q '"COVID-19" or "Corona Virus Disease 2019" or "Novel coronavirus pneumonia" or "SARS-CoV-2"' --save-log -k 20190423.pubmed | awk '/<[?]xml version="1.0" [?]>/{close(f); f="xml/covid19.XML.tmp" ++c;next} {print>f;}' 

cd xml
xml=`ls covid19.XML.tmp*`
for i in ${xml}
do
bioctl cvrt --xml2json pubmed ${xml} > ${xml}.json
done

