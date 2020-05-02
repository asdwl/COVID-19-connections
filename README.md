# COVID-19 Connections

Recently, a volume of publications related to coronavirus disease 2019 (COVID-19) has been published. This poses a great challenge to efficiently conclude the knowledge and notion connections from these literatures. This project aims to establish a simple database of COVID-19 based on text mining of the public resource (e.g. PubMed and full-text).

As of 2020-04-23, we collected a total of 5,758 publications records from PubMed API and more than 2,000 full-text files from the journal websites.

Todo:

- [ ] collect all avaliable APIs related to COVID-19
- [ ] label the gene pathway
- [ ] label the drug and treatment
- [ ] web interface and API

In progress:

- [ ] fetch preprint resource
- [ ] fetch the open access and subscribed fulltext 
- [ ] label the countries and cities (abstract and fulltext)
- [ ] label the gene symbol (abstract and fulltext)

Done:

- [x] fetch PubMed XML

## Requirements

- R
- [bget](https://github.com/openanno/bget)
- [bioextr](https://github.com/openanno/bioextr)
- [bioctl](https://github.com/openanno/bioctl)

## LICENSE

MIT
