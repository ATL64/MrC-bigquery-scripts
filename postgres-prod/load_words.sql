drop schema if exists prod cascade;

CREATE SCHEMA prod;


create table prod.word_freq (word varchar(200), pmid varchar(200) ,
                                freq varchar(100))

--> Load data with the bash script, only after load is finished should we create indexes (faster)
                                             
CREATE INDEX freq_index
ON prod.word_freq (word);

delete from prod.word_freq
where pmid='pmids' and word='word'
;
                                             
------------------------------------
------------------------------------
                                             
drop table if exists prod.abstracts;

CREATE TABLE prod.abstracts (pmid varchar(200), abstract varchar(25000) ,
                                article_date varchar(200), status varchar(100),
                                journal varchar(300), article_title varchar(2500))

--> Load data with the bash script, only after load is finished should we create indexes (faster)
                                                                            
CREATE INDEX abstract_index
ON prod.abstracts (pmid);

delete from prod.abstracts
where pmid='pmid' and abstract='abstract'
;
                                                                           

------------------------------------
------------------------------------
                                                                            
create table prod.words_pmids (word varchar(60), pmid varchar(17))
;

-- Make two indexes (we'll filter by word and join with pmids)
                    
CREATE INDEX words_index
ON prod.words_pmids(word, pmid);


delete from prod.words_pmids
where pmid='pmid' and word='word'
;

                                                              
-- New tables with new keywords and authors
DROP TABLE IF EXISTS prod.word_freq;
CREATE TABLE prod.mrc_keyword_frequency (keyword varchar(255), n int);
-- Upload biotech_lee/postgres_tables/mrc_keyword_frequency to DB
CREATE UNIQUE INDEX keyword_index ON prod.mrc_keyword_frequency (keyword);
                                                              
DROP TABLE IF EXISTS prod.words_pmids;
CREATE TABLE prod.mrc_keywords (pmid varchar(15), keyword varchar(255), year int);
-- Upload biotech_lee/postgres_tables/mrc_keywords to DB
CREATE INDEX keyword_pmid_index ON prod.mrc_keywords(keyword, pmid);
                                           
-- Query to get maximum length of item in a column: SELECT MAX(CHAR_LENGTH(journal)) FROM pubmed.mrc_data;                                                              

DROP TABLE IF EXISTS prod.abstracts;
DROP TABLE IF EXISTS prod.mrc_data;
CREATE TABLE prod.mrc_data (pmid varchar(15), abstract varchar(25000), article_title varchar(2500), article_date varchar(200), journal varchar(500), authors varchar(64000));
-- Upload biotech_lee/postgres_tables/mrc_data to DB
CREATE INDEX pmid_index ON prod.mrc_data (pmid);
