### BigQuery Scripts

This repo contains scripts for postprocessing data in bigQuery.

#### Load pubmed data into BigQuery

In BigQuery, under  project -> pubmed -> Create Table:

- Create table from cloud storage with JSONL format. We can load files with prefixes using asterisks like
``biotech_lee/pubmed_json/2019* ``

- Choose project and table name

- Schema -> Edit as text -> paste the content of the pubmed_data.json file in this repo

- Advanced options -> Tick the "Ignore unknown values" checkbox

- Create

#### Load words into BigQuery

Same as before but

- Create table from cloud storage with CSV format. We can load files with prefixes using asterisks like
``biotech_lee/pubmed_word/* ``

- Autodetect schema

- Choose maxerrors = 3000 (there were some encoding issues and some 1 column files)

- Create