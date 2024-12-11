#!/bin/bash

input="$PWD/i_minData"

while IFS= read -r line; do
cat > "seg_docking.tcl" << EOF
package require topotools
package require pbctools

topo readlammpsdata $line full
topo guessatom lammps data

set move_res [atomselect top all]

set com [measure center \$move_res]
puts "\$com"
set shift [vecsub {50.0 50.0 50.0} \$com]
puts "\$shift"

\$move_res moveby \$shift

pbc wrap

topo writelammpsdata i-$line full
exit
EOF
echo "file ready"
vmd -dispdev text -eofexit <seg_docking.tcl> i_output.log
echo "fle runed"
echo $line
done < "$input"
