#!/bin/bash

input="$PWD/a-reconstruct.log"

while IFS= read -r line info; do 
echo "$line.temp"

cat > b-reconstruct.lmp << EOF
#################################
log 		b-reconstruct.log append
variable	i1 equal $line

atom_style      full
bond_style      harmonic
angle_style     harmonic
atom_style      full
bond_style      harmonic
angle_style     harmonic

read_data       $line.temp
print           "$line.temp"

bond_coeff      1 450 0.9572
bond_coeff      2 369.6 0.974
bond_coeff      3 450 2.0

angle_coeff     1 55 104.52

write_data     $line.temp
EOF
lmp_mpi -in b-reconstruct.lmp 	
done < "$input"

