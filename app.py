import json
import re
import os
import datetime
from nltk.stem.snowball import SnowballStemmer
import zlib
from pathlib import Path
# dictionary of stopWords
stopWordsDic = {'i': True, 'me': True, 'my': True, 'myself': True, 'we': True, 'our': True, 'ours': True,
                'ourselves': True,
                'you': True, "you're": True, "you've": True, "you'll": True, "you'd": True, 'your': True, 'yours': True,
                'yourself': True, 'yourselves': True, 'he': True, 'him': True, 'his': True, 'himself': True,
                'she': True,
                "she's": True, 'her': True, 'hers': True, 'herself': True, 'it': True, "it's": True, 'its': True,
                'itself': True, 'they': True, 'them': True, 'their': True, 'theirs': True, 'themselves': True,
                'what': True, 'which': True, 'who': True, 'whom': True, 'this': True, 'that': True, "that'll": True,
                'these': True, 'those': True, 'am': True, 'is': True, 'are': True, 'was': True, 'were': True,
                'be': True,
                'been': True, 'being': True, 'have': True, 'has': True, 'had': True, 'having': True, 'do': True,
                'does': True, 'did': True, 'doing': True, 'a': True, 'an': True, 'the': True, 'and': True,
                'but': True, 'if': True, 'or': True, 'because': True, 'as': True, 'until': True, 'while': True,
                'of': True, 'at': True, 'by': True, 'for': True, 'with': True, 'about': True, 'against': True,
                'between': True, 'into': True, 'through': True, 'during': True, 'before': True, 'after': True,
                'above': True, 'below': True, 'to': True, 'from': True, 'up': True, 'down': True, 'in': True,
                'out': True, 'on': True, 'off': True, 'over': True, 'under': True, 'again': True, 'further': True,
                'then': True, 'once': True, 'here': True, 'there': True, 'when': True, 'where': True, 'why': True,
                'how': True, 'all': True, 'any': True, 'both': True, 'each': True, 'few': True, 'more': True,
                'most': True, 'other': True, 'some': True, 'such': True, 'no': True, 'nor': True, 'not': True,
                'only': True, 'own': True, 'same': True, 'so': True, 'than': True, 'too': True, 'very': True,
                's': True, 't': True, 'can': True, 'will': True, 'just': True, 'don': True, "don't": True,
                'should': True, "should've": True, 'now': True, 'd': True, 'll': True, 'm': True, 'o': True,
                're': True, 've': True, 'y': True, 'ain': True, 'aren': True, "aren't": True, 'couldn': True,
                "couldn't": True, 'didn': True, "didn't": True, 'doesn': True, "doesn't": True, 'hadn': True,
                "hadn't": True, 'hasn': True, "hasn't": True, 'haven': True, "haven't": True, 'isn': True,
                "isn't": True, 'ma': True, 'mightn': True, "mightn't": True, 'mustn': True, "mustn't": True,
                'needn': True, "needn't": True, 'shan': True, "shan't": True, 'shouldn': True, "shouldn't": True,
                'wasn': True, "wasn't": True, 'weren': True, "weren't": True, 'won': True, "won't": True,
                'wouldn': True, "wouldn't": True}

path = input("Enter absolute path to your dataset where your json files are present: ")

# Start of the timer
t0 = datetime.datetime.now()
# stemmer
snowStemmer = SnowballStemmer(language='english')
# Global Dictionary of Words
# changed the variable name from wordID to lexicon
lexicon = dict()
# Forward Index Dictionary
forwardIndex = dict()

# Storing the names of the files in the fileList
fileList = os.listdir(Path(path))

totalFiles = 0
totalDocs = 0

# for file in fileList:

for file in fileList:
    totalFiles += 1
    with open(os.path.join(Path(path), file)) as jsonFile:
        data = json.load(jsonFile)

        # Iterating over the json file for single articles
        for item in data:
            totalDocs += 1
            docID = totalDocs

            # Storing Words of a document.
            words = re.sub('[^a-zA-Z]', " ", item['content']).split()

            # creating a dictionary for creating forward index
            docDict = dict()

            # Setting the wordPosition to zero for every new document
            wordPosition = 0
            # All info about words of a forward index for a single document
            forwardIndexWords = list()

            for word in words:
                # iterator for storing position of a word in a document
                wordPosition += 1

                if word.lower() not in stopWordsDic:
                    # stemming the word
                    finalWord = snowStemmer.stem(word).lower()

                    # generating wordID using zlib function
                    byteWord = bytes(finalWord, 'UTF-8')
                    finalWordID = zlib.crc32(byteWord)

                    try:
                        # throws an exception if a key which is not present in the dict is accessed.
                        # benefit: we don't have to iterate through the dict, we can try to access the key directly
                        # At least that's what I think :?

                        var = docDict[finalWord]
                        var[1] += 1
                        var.append(wordPosition)

                    except KeyError:
                        # if an exception was thrown, that means the key was not present, and we tried to access it
                        # So we add the key to lexicon and docDict

                        # storing one words info in an array
                        # 0th element of this array stores word ID, 1st stores its no. of occurrences in the document,
                        # rest of the elements are its positions in the document
                        wordinfo = [0, 1]
                        wordinfo[0] = finalWordID

                        # append the first wordPosition
                        wordinfo.append(wordPosition)

                        # put the word in lexicon
                        lexicon[finalWord] = finalWordID

                        # put the word's info in docDict
                        docDict[finalWord] = wordinfo

                        # appends one's words info to the list of all word infos.
                        forwardIndexWords.append(wordinfo)

            # generating a docId for a document and storing words of that document in dict
            forwardIndex[docID] = forwardIndexWords


t1 = datetime.datetime.now()

print(f'\nLexicon:\n {lexicon}')
print(f'\n\n\nForward Index:\n {forwardIndex}')
print(f'\n\nNo of json files read: {totalFiles}')
print(f'No of articles: {totalDocs}')
print('Total words in the dictionary: ' + str(len(lexicon)))
print('Total number of Forward Index Documents: ' + str(len(forwardIndex)))

print(f'Time Elapsed: {t1 - t0}')
