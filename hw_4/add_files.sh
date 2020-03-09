#!/bin/bash
mkdir -p {2010..2017}/{1..12} 
for i in {001..002}
   do echo "Файл ${i}">{2010..2017}/{1..12}/${i}.txt
done
