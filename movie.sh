#!/bin/bash
#Scan input directory from terminal

echo 'enter the directory in which movies are residing'
read dir

#Get absolute path from the input directory
path=$(find ~/ -name $dir)

#Make a new file in tmp folder
touch /tmp/sorted.txt || { echo "Failed to create temp file"; exit 1; }

#Empty the sorted folder
> /tmp/sorted.txt

#Declaration of variables
OUT="/tmp/sorted.txt"
SPACE="   ";
NA="NA";
NULL="null";
EMPTY="";
ZERO="0"; 


for f in $path/*
  do
     #strip initial path value to get the movie name
     movie_name=${f##*/}

     #Replace any dot, underscore or space with '+'
     search=$(echo $movie_name | tr ._' ' +)
     
     #Curl the api to get the json data
     rating=$(curl -s http://www.omdbapi.com/\?i\=\&t\=$search | jq -r '.imdbRating');
     
     #check if rating is null (if curl fails)
     if [ "$rating" == "$NULL" ] || [ "$rating" == "$EMPTY" ] || [ "$rating" == "$ZERO" ]
     then 
	echo $NA $SPACE $movie_name >> $OUT;
     else 
	echo $rating $SPACE $movie_name >> $OUT;
     fi
  done

#Sort the output according to first column 
sort -k1 -n $OUT;

#Delete the unwanted file
rm $OUT
exit 0;
