#!/bin/bash
function printline()
{
    printf "%-10s  %-30s  %-30s\n" "$1" "$2" "$3";
}

#Get command line argument
if [ -z $1 ];
then 
    echo 'Directory not provided. Searching in current directory'
    dir='.'
elif [ ! -d $1 ]
then 
    echo $1 'Directory does not exists'
    exit 1;
else 
    echo 'Input Directory is ' $1;
    dir=$1;
fi

#Declaration of readonly constants
declare -r NA="N/A";
declare -r NULL="null";
declare -r EMPTY="";
declare -r ZERO="0"; 


#Print the heading first
printline "RATING" "MOVIE" "TITLE";

for f in $dir/*
do
    #strip initial path value to get the movie name
    movie_name=${f##*/}

    #Replace any dot, underscore or space with '+'
    search=$(echo $movie_name | tr ._' ' +)
     
    #Curl the api to get the json data
    data=$(curl -s http://www.omdbapi.com/\?i\=\&t\=$search)
    rating=$(echo $data | jq -r '.imdbRating');
    title=$(echo $data | jq -r '.Title');
   
    #Check if Title is then put error message in title
    if [ "$title" == "$NULL" ]
    then
        title=$(echo $data | jq -r '.Error');
    fi


    #check if rating is null (if curl fails)
    if [ "$rating" == "$NULL" ] || [ "$rating" == "$EMPTY" ] || [ "$rating" == "$ZERO" ]
    then
        printline "$NA" "$movie_name" "$title"; 
    else 
        printline "$rating" "$movie_name" "$title"
    fi
done | sort -k1 -rn

exit 0;
