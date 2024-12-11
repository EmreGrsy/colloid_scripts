#!/bin/bash

input="$PWD/l_sasa.log"

for i in {1..200}
do
	file_total_sasa=0

	while IFS=" " read -r mol_id res_id res_sasa
	do

		if [ "$i" = "$mol_id" ]
		then
			file_total_sasa=$( echo "$file_total_sasa + $res_sasa" | bc )

		fi
		
	done < "$input"

	echo "$i $file_total_sasa" >> total_sasa.dat

done 
