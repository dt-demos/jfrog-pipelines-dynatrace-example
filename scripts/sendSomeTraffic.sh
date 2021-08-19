#!/bin/bash

URL=$1
echo "Calling $URL..."
for i in {1..500}; 
  do
    echo "loop $i"
    curl -s -I -X GET "$URL/" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$URL/api/echo?text=Hello-World" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$URL/api/invoke?url=http://www.dynatrace.com" | head -n 1 | cut -d$' ' -f2;
    curl -s -I -X GET "$URL/api/invoke?url=http://blog.dynatrace.com" | head -n 1 | cut -d$' ' -f2;
done 
