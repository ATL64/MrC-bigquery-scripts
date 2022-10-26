drop table if exists pubmed.fact_abstracts;

create table pubmed.fact_abstracts as
select distinct pmid,
        medent.abstract as abstract,
        cast(medent.em_std.year as string) || '-' || case when
                length(cast(medent.em_std.month as string))=1
                then '0' || cast(medent.em_std.month as string)
                else cast(medent.em_std.month as string)
                end || '-' || case when
                length(cast(medent.em_std.day as string))=1
                then '0' || cast(medent.em_std.day as string)
                else cast(medent.em_std.day as string)
                end as article_date,
        medent.status as status,
        medent.cit.from_journal.title.name as journal,
        medent.cit.title.name as article_title
from pubmed.pubmed_raw
where medent.abstract is not null
;
                            
-- There are three entries that need to be corrected (there's an error in the table)
UPDATE pubmed.fact_abstracts
SET article_date = '2006-03-01'
WHERE STARTS_WITH(article_date, '1-');

-- Create authors table
DROP TABLE IF EXISTS pubmed.fact_authors;
CREATE TABLE pubmed.fact_authors AS
SELECT 
    pmid AS pmid,
    STRING_AGG(author_names,',') AS authors
FROM pubmed.pubmed_raw,
    UNNEST(medent.cit.authors.names_ml) author_names
GROUP BY pmid
UNION ALL
SELECT 
    pmid AS pmid,
    STRING_AGG(author_names.nameml,',') AS authors
FROM `pubmed.pubmed_raw`,
    UNNEST(medent.cit.authors.names_std) AS author_names
GROUP BY pmid
;

-- Create main table with authors
DROP TABLE IF EXISTS pubmed.mrc_data;
CREATE TABLE pubmed.mrc_data AS
    SELECT
        fact_abstracts.pmid,
        fact_abstracts.abstract,
        fact_abstracts.article_title,
        CAST(fact_abstracts.article_date AS DATE) AS article_date,
        fact_abstracts.journal,
        fact_authors.authors
    FROM pubmed.fact_abstracts
    FULL OUTER JOIN pubmed.fact_authors ON fact_abstracts.pmid=fact_authors.pmid;

                            
-- Create table words_pmids
drop table if exists pubmed.words_pmids;

create table pubmed.words_pmids as
select string_field_0 as word, int64_field_1 as pmid
from pubmed.words_raw
;

delete from pubmed.words_pmids
where length(word)>58
;

delete from pubmed.words_pmids
where word is null
;

delete from pubmed.words_pmids
where pmid is null
;

drop table if exists pubmed.word_freq;

create table pubmed.word_freq as
select word, count(distinct pmid) as pmids, count(distinct pmid)/200000 as freq
from pubmed.words_pmids
group by 1 order by 2 desc
;


-- After running the english_word_freq.py file and saving to GCS (processed_english_words in biotech_lee bucket)
-- create the table manually in bigquery.  Make it pubmed.words_eng_raw.
-- We see the sum of all word occurrences is 396159249417
-- It has an indexing column to be removed:

create table pubmed.words_english
as select word, count, (count/396159249417)*100 as freq
from pubmed.words_eng_raw
;

drop table pubmed.words_eng_raw
;
