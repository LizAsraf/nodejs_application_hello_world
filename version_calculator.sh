#! bin/bash
L_TAG=$1
z=$( echo ${L_TAG} | cut -d "." -f3)
x=$( echo ${L_TAG} | cut -d "." -f1,2)
cal="$x.$(($z+1))"
echo "$cal"