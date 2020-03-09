#!/bin/bash
sed '/^$/d' with_empty_strings.txt > without_empty_strings.txt
cat without_empty_strings.txt | tr ‘a-z’ ‘A-Z’ > without_empty_strings.txt