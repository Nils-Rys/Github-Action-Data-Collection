from nltk.classify import NaiveBayesClassifier
from nltk.corpus import stopwords
from nltk.corpus import subjectivity
from nltk.sentiment import SentimentAnalyzer
from nltk.sentiment.vader import SentimentIntensityAnalyzer
from nltk.tokenize import word_tokenize
from nltk.sentiment.util import *
from nltk.tokenize import sent_tokenize 
from nltk.util import ngrams
from nltk.corpus import wordnet as wn
from nltk.stem.wordnet import WordNetLemmatizer
from nltk import FreqDist

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.decomposition import LatentDirichletAllocation

import pandas as pd
import numpy as np
import string

N = 2 
stopwords = set(list(stopwords.words("english")) + ["travis"] )



def wordContent(section):


    section_text = {}
    
    section_text["q2"] = "".join([ sent + " " for text in list(section["q2"]) for sent in sent_tokenize(text) ]).lower()
    section_text["q3"] = "".join([ sent + " " for text in list(section["q3"]) for sent in sent_tokenize(text) ]).lower()
    section_text["q4"] = "".join([ sent + " " for text in list(section["q4"]) for sent in sent_tokenize(text) ]).lower()
     
    #section_text = section_text.translate(str.maketrans("", "", string.punctuation))
    #section_words = [word for word in word_tokenize(section_text) if word not in stop_words ]
    #section_fq = FreqDist(ngrams(section_words, N))
    
def likertResults(section_1, section_2, section_3):

    responses  = set(list(section_1["q1"]) + list(section_2["q1"]) + list(section_3["q1"]))

    s1_results = {response:list(section_1["q1"]).count(response) for response in responses} 
    s2_results = {response:list(section_2["q1"]).count(response) for response in responses} 
    s3_results = {response:list(section_3["q1"]).count(response) for response in responses} 
    
    print("section 1: ", s1_results) 
    print("section 2: ", s2_results)
    print("section 3: ", s3_results)

def lemma(word):
   # l = wn.morphy(word)
   # return l if l is not None else word
   word =  WordNetLemmatizer().lemmatize(word)
   return word
    

def topicModeling(section):
    
    count_vect = CountVectorizer(max_df=0.8, min_df=2, stop_words="english")
    LDA = LatentDirichletAllocation(n_components=5, random_state=10)
    section_text = {}
    section_text["q2"] = "".join([ sent + " " for text in list(section["q2"]) for sent in sent_tokenize(text)])
    section_text["q3"] = "".join([ sent + " " for text in list(section["q3"]) for sent in sent_tokenize(text)])
    section_text["q4"] = "".join([ sent + " " for text in list(section["q4"]) for sent in sent_tokenize(text)])
    
    for key, text in section_text.items():
        print(key)
        print(text)
        print("-----------------------------------------------------------")
    '''
    section_text["q2"] = "".join([ lemma(word)+ " " for text in list(section["q2"]) for sent in sent_tokenize(text) for word in word_tokenize(sent) if word not in stopwords and len(word) > 4]).lower()
    section_text["q3"] = "".join([ lemma(word) + " " for text in list(section["q3"]) for sent in sent_tokenize(text) for word in word_tokenize(sent) if word not in stopwords and len(word) > 4]).lower()
    section_text["q4"] = "".join([ lemma(word) + " " for text in list(section["q4"]) for sent in sent_tokenize(text) for word in word_tokenize(sent) if word not in stopwords and len(word) > 4]).lower()

    term_matricies = { key:count_vect.fit_transform(section[key].values.astype("U")) for key in ["q2", "q3", "q4"]}

    for matrix in term_matricies.values():
        LDA.fit(matrix)

    for matrix in term_matricies.values():

        print("###################################################")
        topic_values = LDA.transform()
        print("###################################################")
   ''' 

def vaderAnalysis(response_list):

    sid = SentimentIntensityAnalyzer()
    reviews = {"positive": 0, "negative": 0, "neutral": 0}

    for response in response_list:

        response_lines = sent_tokenize(response)
        compound_sum = 0

        for line in response_lines:
            sentiment_score = sid.polarity_scores(line)
            compound_sum += sentiment_score["compound"]

        compound_avg = compound_sum / len(response_lines)

        if compound_avg > 0.25:
            reviews["positive"] += 1
        elif compound_avg < -0.25:
            reviews["negative"] += 1
        else:
            reviews["neutral"] += 1

    return reviews 
            
def sentimentAnalysis(section_1, section_2, section_3):

    # Analysis of question 2
    print("######################QUESTION 2##########################")
    print("section 1: ", vaderAnalysis(list(section_1["q2"])))
    print("section 2: ", vaderAnalysis(list(section_2["q2"])))
    print("section 3: ", vaderAnalysis(list(section_3["q2"])))
    print()
    
    # Analysis of question 3
    print("######################QUESTION 3##########################")
    print("section 1: ", vaderAnalysis(list(section_1["q3"])))
    print("section 2: ", vaderAnalysis(list(section_2["q3"])))
    print("section 3: ", vaderAnalysis(list(section_3["q3"])))
    print()
    
    # Analysis of question 4
    print("######################QUESTION 4##########################")
    print("section 1: ", vaderAnalysis(list(section_1["q4"])))
    print("section 2: ", vaderAnalysis(list(section_2["q4"])))
    print("section 3: ", vaderAnalysis(list(section_3["q4"])))
    print()


def preprocess(df):
   
    df.columns = ["id_hash","section", "q1", "q2", "q3", "q4"]
    
    # Remove all unwanted characters
    df["q1"] = df["q1"].apply(lambda x: x.strip())
    df["q2"] = df["q2"].apply(lambda x: x.strip())
    df["q3"] = df["q3"].apply(lambda x: x.strip()) 
    df["q4"] = df["q4"].apply(lambda x: x.strip()) 

    #separate dataframe by section
    section_1 = df[df["section"] == 11713]
    section_2 = df[df["section"] == 11714]
    section_3 = df[df["section"] == 11715]
    
    return section_1, section_2, section_3 

def __main__():

    section_1, section_2, section_3  = preprocess(pd.read_csv("./feedback_hash.csv"))
    
    sentimentAnalysis(section_1, section_2, section_3)
    likertResults(section_1, section_2, section_3)

    #wordContent(section_1)
    #wordContent(section_2)
    #wordContent(section_3)
    print("Section 1")
    section_1 = topicModeling(section_1)
    print("Section 2")
    section_2 = topicModeling(section_2)
    print("Section 3")
    section_3 = topicModeling(section_3)


##############################################################################
__main__()
