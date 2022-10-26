### Load words in postgres

This is a process to load words data into postgres.  It's messy and we should give a try with Dataflow next time.

1. First export the table from BQ to GCS:

 - Go to the pubmed.words_pmids table and Export -> GCS
 - gcs location: biotech_lee/postgres_words
 - filename: words*.csv (the * is so that it splits into files, it will be too big for one file for postgres)
 - no compression
 
    Important: you have to configure cloudsql service's account 
    to have read access to the gcs directory at this point

1. Create and index the table with SQL in the load_words.sql file

1. Run the bash script

1. Run the delete statement in postgres.

#### Executing SQLs in postgres

To do the above, you can set a connection to postgres with a local
 SQL client like DBeaver or DbVisualizer.  You need to whitelist 
 your home IP address.

Set 
 - host: 34.xx.xx.xx
 - port: 5432
 - database: postgres
 - user: postgres
 - password: xxx