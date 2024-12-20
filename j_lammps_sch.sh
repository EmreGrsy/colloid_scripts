#!/bin/bash

input="$PWD/i-h_dock.data"

while IFS="-" read -r data_file res; do
cat > "calc_eng.lmp" << EOF
units           real
boundary	f f f
atom_style      full
bond_style      harmonic
angle_style     harmonic

pair_style      hybrid lj/cut/coul/cut 200.0 buck/coul/cut 200.0
neigh_modify    page 1000000 one 100000
special_bonds   lj 0.0 0.0 0.5 coul 0.0 0.0 0.8333

newton		off

read_data       i-h.docking_of_ion_$data_file.min-$res

change_box      all x final -1000.0 1000.0 &
                y final -1000.0 1000.0 &
                z final -1000.0 1000.0 &
                units box

include         ff_colloid_param

print           "docking_of_ion_$data_file.$res.min"

variable	potential_energy equal pe
variable	pairwise_energy equal epair

thermo_style	multi

run		0

print		"$data_file $res \${potential_energy} \${pairwise_energy}" append j_energy.dat

write_data      docking_of_ion_$data_file-$res.result

EOF
lmp_mpi -in calc_eng.lmp	
done <"$input"
