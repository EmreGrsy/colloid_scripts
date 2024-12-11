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

set dataFile [glob *.min]

set log1 [open "a1-fix_bondError.log" w]

foreach d1 $dataFile {
	
	topo readlammpsdata $d1 full	

######################################--------------set bond type 3 -> bond type 2----------------#################################################

        set bondList [topo getbondlist both]
        set bondList_length [llength $bondList]

        for {set i1 0} {$i1 < $bondList_length} {incr i1} {

                set first [atomselect top "index [lindex $bondList $i1 0]"]
                set second [atomselect top "index [lindex $bondList $i1 1]"]
                set bond_type [lindex $bondList $i1 2]

                if {($bond_type == 3) } {
                        topo delbond [$first get index] [$second get index]
                        topo addbond [$first get index] [$second get index] -bondtype 2 -bondorder 1
			puts $log1 "$d1 | bond_type (2) - [$first get index]([$first get type]) - [$second get index]([$second get type])"

                }

		if {($bond_type == 4) } {
                        topo delbond [$first get index] [$second get index]
                        topo addbond [$first get index] [$second get index] -bondtype 1 -bondorder 1
                        puts $log1 "$d1 | bond_type (1) - [$first get index]([$first get type]) - [$second get index]([$second get type])"

                }


        	$second delete
        	$first delete
        }

	topo writelammpsdata $d1.temp full
	foreach i2 [atomselect list] { $i2 delete }
}

close $log1
	
#########################################################################################################################################i
