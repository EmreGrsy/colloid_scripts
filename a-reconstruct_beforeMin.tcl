### Ow : type 1
### Hw : type 2
### Fe : type 3
### Oh : type 4
### Ho : type 5
### O3 : type 6
###
### Hw - Ow - Hw | bond type : 1 | angle type : 1 
### Ho - Oh | 



package require topotools

set dataFile [glob *.data]

set log [open "a-reconstruct.log" w]

foreach d1 $dataFile {
	
	topo readlammpsdata $d1 full	
	
	puts $log "$d1"

	set bondList [topo getbondlist]
	
	set bondList_length [llength $bondList]
	
	for {set i1 0} {$i1 < $bondList_length} {incr i1} {
		
		set first [atomselect top "index [lindex $bondList $i1 0]"]
		set second [atomselect top "index [lindex $bondList $i1 1]"]

		if {[$first get type] == 3} {
			#puts "[$first get index]([$first get type]) - [$second get index]([$second get type])"
			topo delbond [$first get index] [$second get index]
			}

		 if {[$second get type] == 3} {
                	#puts "[$first get index]([$first get type]) - [$second get index]([$second get type])"        
			topo delbond [$first get index] [$second get index]
			}

		$second delete
		$first delete
		
	}

	foreach i2 [atomselect list] { $i2 delete }
	topo writelammpsdata a_before_$d1 full

}
close $log
	
