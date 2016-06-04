#!/bin/bash
#Get command line argument
if [ -z $1 ];
then 
    echo 'Directory not provided. Searching in current directory'
    dir='.'
else 
    echo 'Input Directory is' $1
    dir=$1
fi

#Get absolute path from the input directory
path=$(find ~/ -name $dir)


#Declaration of readonly constants
declare -r NA="N/A";
declare -r NULL="null";
declare -r EMPTY="";
declare -r ZERO="0"; 


#Print the heading first
printf "%-10s  %-30s  %-30s\n" "RATING" "MOVIE" "TITLE"

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
	printf "%-10s  %-30s  %-30s\n" "$NA" "$movie_name" "$title";
     else 
	printf "%-10s  %-30s  %-30s\n" "$rating" "$movie_name" "$title";
     fi
  done | sort -k1 -rn


exit 0;
