import pandas as pd
import sys

# Make sure that the command line args are present
pickleFilePath = '/home/nickshiell/storage/TestSet/TestPickle/Test.pkl'
if len(sys.argv) == 2:
    pickleFilePath = sys.argv[1]
else:
    print('WARNING: No file path given. Using default: ', pickleFilePath,'\n')

pdf = pd.read_pickle(pickleFilePath)

for iRow, row in pdf.iterrows():

    title = row['Title']
    tickers = row['Ticker(s)']
    companyNames = row['CompanyNames']
    index = row['TextIndex']
    article = row['Article']
    searchTerms = row['SearchTerms']

    listOfKeys = list(index.keys())
    listOfKeys.sort()

    print(article)    
    print(listOfKeys)
    print('Symbols: ', tickers)
    print('Companies Found: ', companyNames)
    print('Search Terms: ', searchTerms)

    if len(companyNames) > 0:
        input()