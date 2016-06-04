#!/bin/bash
#Scan input directory from terminal


if [ -z $1 ];
then 
    echo 'Directory not provided. Searching in current directory'
    dir='.'
else 
    echo 'Directory is' $1
    dir=$1
fi

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

#Print the heading first
printf "%-10s  %-20s  %-20s\n" "RATING" "MOVIE" "TITLE"

for f in $path/*
  do
     #strip initial path value to get the movie name
     movie_name=${f##*/}

     #Replace any dot, underscore or space with '+'
     search=$(echo $movie_name | tr ._' ' +)
     
     #Curl the api to get the json data
     rating=$(curl -s http://www.omdbapi.com/\?i\=\&t\=$search | jq -r '.imdbRating');
     title=$(curl -s http://www.omdbapi.com/\?i\=\&t\=$search | jq -r '.Title');

     #check if rating is null (if curl fails)
     if [ "$rating" == "$NULL" ] || [ "$rating" == "$EMPTY" ] || [ "$rating" == "$ZERO" ]
     then 
	printf "%-10s  %-20s  %-20s\n" "$NA" "$movie_name" "$title" >> $OUT;
     else 
	printf "%-10s  %-20s  %-20s\n" "$rating" "$movie_name" "$title" >> $OUT;
     fi
  done

#Sort the output according to first column 
sort -k1 -rn $OUT;

#Delete the unwanted file
rm $OUT
exit 0;
