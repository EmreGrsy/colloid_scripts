package require topotools
package require pbctools

topo readlammpsdata h.docking_of_ion_169.min-6 full
topo guessatom lammps data

set move_res [atomselect top all]

set com [measure center $move_res]
puts "$com"
set shift [vecsub {50.0 50.0 50.0} $com]
puts "$shift"

$move_res moveby $shift

pbc wrap

topo writelammpsdata i-h.docking_of_ion_169.min-6 full
exit
