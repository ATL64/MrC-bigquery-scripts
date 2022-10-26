# To run this script, you need to download the csv file from  https://www.kaggle.com/rtatman/english-word-frequency/data#
# The goal of this script is to process this CSV so we remove stop words and do lemmatization, etc.
# Data is small (5Mb), so should be no problem to run this locally

import nltk
nltk.download('stopwords')
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
from nltk.tokenize import RegexpTokenizer
nltk.download('wordnet')
from nltk.stem.wordnet import WordNetLemmatizer
import re
import pandas as pd

#replace the following variable with your path to the file

file_path = '/home/xxxx/unigram_freq.csv'
words_df = pd.read_csv(file_path)


##Creating a list of stop words and adding custom stopwords
stop_words = set(stopwords.words("english"))
##Creating a list of custom stopwords
new_words = ["using", "show", "result", "large", "also", "iv", "one", "two", "new", "previously", "shown"]
stop_words = stop_words.union(new_words)

words_df = words_df[~words_df.word.isin(stop_words)]
words_df = words_df[words_df['word'].apply(lambda x: str(x)!='nan')]


# Takes a minute or two
for i, row in words_df.iterrows():
    # Remove punctuations
    text = re.sub('[^a-zA-Z]', ' ', row['word'])
    # Convert to lowercase
    text = text.lower()
    # remove tags
    text = re.sub("&lt;/?.*?&gt;", " &lt;&gt; ", text)
    # remove special characters and digits
    text = re.sub("(\\d|\\W)+", " ", text)
    ##Convert to list from string
    #text = text.split()
    ##Stemming
    ps = PorterStemmer()
    # Lemmatisation
    lem = WordNetLemmatizer()
    text = lem.lemmatize(text)
    #text = [lem.lemmatize(word) for word in text if not word in stop_words]
    #text = " ".join(text)
    #corpus.append(text)
    words_df.at[i,'word']=text

words_df.to_csv('processed_words.csv')
