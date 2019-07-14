#!/bin/bash
for i in {1..1000}
do
mktemp /test/XXXXXX.txt
done
