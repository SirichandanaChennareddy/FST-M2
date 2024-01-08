-- Load input file from HDFS
inputDialogues4 = LOAD 'hdfs:///user/sirichandana/episodeIV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
inputDialogues5 = LOAD 'hdfs:///user/sirichandana/episodeV_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);
inputDialogues6 = LOAD 'hdfs:///user/sirichandana/episodeVI_dialogues.txt' USING PigStorage('\t') AS (name:chararray, line:chararray);

--Filter out the first 2 lines fom each file
ranked4 = RANK inputDialogues4;
OnlyDialogues4 = FILTER ranked4 BY (rank_inputDialogues4 > 2);
ranked5 = RANK inputDialogues5;
OnlyDialogues5 = FILTER ranked5 BY (rank_inputDialogues5 > 2);
ranked6 = RANK inputDialogues6;
OnlyDialogues6 = FILTER ranked6 BY (rank_inputDialogues6 > 2);

--Merge the three inputs
inputData = UNION OnlyDialogues4, OnlyDialogues5, OnlyDialogues6;

--Group by name
groupByName = Group inputData By name;

-- Count the occurence of lines by each character
names = FOREACH groupByName GENERATE $0 as name, COUNT($1) as no_of_lines;
namesOrdered = ORDER names BY no_of_lines DESC;

--Remove the output folder
rmf hdfs:///user/sirichandana/outputs;

-- Store the result in HDFS
STORE namesOrdered INTO 'hdfs:///user/sirichandana/results' USING PigStorage('\t');