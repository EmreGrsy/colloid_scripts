# nFe nO nOH nH nOW nHW nH2OH nHOH2 nfreeH nOH- E_pot ASA


package require topotools
set log [open "d-colloid_data.log" w]
set dataFile [glob *.min.temp]

puts $log "# nFe nO nOH nH nOW nHW nH2OH nHOH2 nfreeH nOH- E_pot ASA "

foreach line $dataFile {

        topo readlammpsdata $line full
	
	set nFe [atomselect top "type 3"]
	set nO [atomselect top "type 6"]
	set nOh [atomselect top "type 4 and not (same fragment as (type 4 and not pbwithin 2.6 of type 3))"]
	set nHo [atomselect top "type 5 and not (same fragment as (type 4 and not pbwithin 2.6 of type 3))"]
	set nOw [atomselect top "type 1"]
	set nHw [atomselect top "type 2"]

	# nH2OH water molecules which are basically not "converted" from surface hydroxyls to TIP3P
	# nHOH2 are surface hydrogens with two oxygens (should always be zero)
	# By running c-analyze_topology.tcl script we check if there is any issues related to the bonds and angles. From the result we see that there isnt any -unwanted- structures.
	# Check c-analyze_topology.log for the unwanted results- if there is any.
	set nH2OH 0  
	set nHOH2 0

	# free H+ atoms flying around
	set nH_free [atomselect top "type 2 5 and not pbwithin 3 of type 1 3 4 6"]

	# fee OH- molecules flying around
	set nOH_free [atomselect top "same fragment as (type 4 and not pbwithin 2.6 of type 3)"]
	
	puts $log "$line [$nFe num] [$nO num] [$nOh num] [$nHo num] [$nOw num] [$nHw num] $nH2OH $nHOH2 [$nH_free num] [expr {[$nOH_free num] / 2}]"

##################---------------(ii) remove (OH)⁻ but keep track on how much you have removed-----------###############

	$nOH_free set type 7
	$nH_free set type 7
	
	topo writelammpsdata $line full

########################################################################################################################

	$nFe delete
	$nO delete
	$nOh delete
	$nHo delete
	$nOw delete
	$nHw delete
	$nH_free delete
	$nOH_free delete

}
close $log

