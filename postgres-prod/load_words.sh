

for file in $( gsutil ls gs://biotech_lee/postgres_tables/word_freq/ ); do
    if [ $file != "gs://biotech_lee/postgres_tables/word_freq/" ]
    then yes Y | gcloud sql import csv prod-mrc-db $file --database=postgres --table=prod.word_freq
    fi
    echo $file
done


for file in $( gsutil ls gs://biotech_lee/postgres_tables/abstracts/ ); do
    if [ $file != "gs://biotech_lee/postgres_tables/abstracts/" ]
    then yes Y | gcloud sql import csv prod-mrc-db $file --database=postgres --table=prod.abstracts
    fi
    echo $file
done

#This takes hours:
for file in $( gsutil ls gs://biotech_lee/postgres_tables/words_pmids/ ); do
    if [ $file != "gs://biotech_lee/postgres_tables/words_pmids/" ]
    then yes Y | gcloud sql import csv prod-mrc-db $file --database=postgres --table=prod.words_pmids
    fi
    echo $file
done

bq --location=EU extract \
--destination_format CSV \
--compression GZIP \
--field_delimiter , \
--print_header=false \
durable-catbird-204706:pubmed.mrc_data \
gs://biotech_lee/postgres_tables/mrc_data/*.gz

for file in $( gsutil ls gs://biotech_lee/postgres_tables/mrc_data/ ); do
    if [ $file != "gs://biotech_lee/postgres_tables/mrc_data/" ]
    then yes Y | gcloud sql import csv prod-mrc-db $file --database=postgres --table=prod.mrc_data
    fi
    echo $file
done

bq --location=EU extract \
--destination_format CSV \
--compression GZIP \
--field_delimiter , \
--print_header=false \
durable-catbird-204706:pubmed.mrc_keywords \
gs://biotech_lee/postgres_tables/mrc_keywords/*.gz

for file in $( gsutil ls gs://biotech_lee/postgres_tables/mrc_keywords/ ); do
    if [ $file != "gs://biotech_lee/postgres_tables/mrc_keywords/" ]
    then yes Y | gcloud sql import csv prod-mrc-db $file --database=postgres --table=prod.mrc_keywords
    fi
    echo $file
done
