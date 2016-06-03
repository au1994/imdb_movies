#!/bin/bash
echo 'please input the movie name'
read name
echo $name
var=$(curl -s http://www.omdbapi.com/\?i\=\&t\=$name | jq -r '.imdbRating')
echo $var
