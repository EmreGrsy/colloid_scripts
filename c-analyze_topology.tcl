### Ow : type 1
### Hw : type 2
### Fe : type 3
### Oh : type 4
### Ho : type 5
### O3 : type 6
###
### Hw - Ow - Hw | bond type : 1 | angle type : 1 
### Ho - Oh | bond type 2 3 



package require topotools

set log [open "c-analyze_topology.log" w]

puts $log "####### Water molecule Hw-Ow-Hw (bond type 1) should be constructed from Ow (atom type 1) and Hw (atom type 2) "
puts $log "####### Hydroxide molecule Ho-Oh (bond type 2) should be constructed from Oh (atom type 4) and Ho (atom type 5) "
puts $log "####### Water molecule Hw-Ow-Ow (angle type 1) should be constructed from Ow (atom type 1) and Hw (atom type 2) "

set dataFile [glob *.min.temp]

foreach line $dataFile {

        topo readlammpsdata $line full

#####################################--------------check bond topology----------------#################################################

	set bondList [topo getbondlist both]
	set bondList_length [llength $bondList]

	for {set i1 0} {$i1 < $bondList_length} {incr i1} {
		
		set first [atomselect top "index [lindex $bondList $i1 0]"]
		set second [atomselect top "index [lindex $bondList $i1 1]"]
		set bond_type [lindex $bondList $i1 2]			

		if {($bond_type == 1) && ((([$first get type] != 1) && ([$first get type] != 2)) || (([$second get type] != 1) && ([$second get type] != 2))) } {
			puts $log "$line | bond_type($bond_type) - [$first get index]([$first get type]) - [$second get index]([$second get type])"
		}
	
		if {($bond_type == 2) && ((([$first get type] != 4) && ([$first get type] != 5)) || (([$second get type] != 4) && ([$second get type] != 5))) } {
                        puts $log "$line | bond_type($bond_type) - [$first get index]([$first get type]) - [$second get index]([$second get type])"
                }


		if {($bond_type == 3) && ((([$first get type] != 4) && ([$first get type] != 5)) || (([$second get type] != 4) && ([$second get type] != 5))) } {
                        puts $log "$line | bond_type($bond_type) - [$first get index]([$first get type]) - [$second get index]([$second get type])"
                }


       	$second delete
       	$first delete
       	
        }

##########################################-------------check angle topology---------------################################################
	
	set angleList [topo getanglelist]
	set angleList_length [llength $angleList]

	for {set i2 0} { $i2 < $angleList_length } {incr i2} {
			
		set angle_type [lindex $angleList $i2 0]
		set first [atomselect top "index [lindex $angleList $i2 1]"]
                set second [atomselect top "index [lindex $angleList $i2 2]"]
		set third [atomselect top "index [lindex $angleList $i2 3]"]
		
		if {($angle_type == 1) && ((([$first get type] != 1) && ([$first get type] != 2)) || (([$second get type] != 1) && ([$second get type] != 2))\
|| (([$third get type] != 1) && ([$third get type] != 2))) } {
			puts $log "$line | angle_type (1) - [$first get index]([$first get type]) - [$second get index]([$second get type]) - [$third get index]([$third get type])"
		}

		$first delete
		$second delete
		$third delete
	}


	foreach i3 [atomselect list] { $i3 delete }
}

close $log
###########################################################################################################################################
