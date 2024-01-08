-- Load the input data from HDFS
inputFile = LOAD 'hdfs:///user/sirichandana/input.txt' AS (line:chararray);
-- Tokenize the lines
words = FOREACH inputFile GENERATE FLATTEN(TOKENIZE(line)) as word;
-- Group words by word [MAP]
grpd = GROUP words BY word;
-- Counts the number of words [REDUCE]
totalCount = FOREACH grpd GENERATE $0, COUNT($1);

-- Delete the output folder
rmf hdfs:///user/sirichandana/PigOutput
-- Store the output in HDFS
STORE totalCount INTO 'hdfs:///user/sirichandana/PigOutput';

