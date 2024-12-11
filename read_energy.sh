#!/bin/bash

input="$PWD/d-colloid_data.log"

while IFS=" " read -r data_file nFe nO nOH nH nOw nHw nH2OH nHOH2 nfree_H nfree_OH 
do
	IFS=. read file_name min temp <<< "$data_file"
	E_pot="$(awk 'c&&!--c;/Energy initial, next-to-last, final =/{c=1}' $file_name.min.log | tr -s [:blank:] | cut -d' ' -f 4)"
	echo "$data_file $nFe $nO $nOH $nH $nOw $nHw $nH2OH $nHOH2 $nfree_H $nfree_OH $E_pot" >> analysis_result.log

done < "$input"
