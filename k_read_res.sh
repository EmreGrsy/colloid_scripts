#!/bin/bash

input="$PWD/j_energy.dat"

for i in {1..180}
do
	file_total_energy=0

	while IFS=" " read -r mol_id res_id pot_total pot_pairWise 
	do

		if [ "$i" = "$mol_id" ]
		then
			file_total_energy=$( echo "$file_total_energy + $pot_pairWise" | bc )
			#echo "$mol_id $pot_pairWise"

		fi
		
	done < "$input"

	echo "$i $file_total_energy" >> pairWise_energy.dat

done 
