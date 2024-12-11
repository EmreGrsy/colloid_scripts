### These scipt is not fucntional yet, if defines bonds between fe and other oxygens then combines them and then erases them
### Results are messy. Use this as a reference point

package require topotools
package require pbctools


set dataFile [glob *.min.temp]


foreach d1 $dataFile {
	
	mol delete top
	
	topo readlammpsdata $d1 full

##############----------define bonds between fe-(Ow,Oh,O) atoms-----------################################################
	
	set fe [atomselect top "type 3"]

	foreach fe_center [$fe get index] {
		
		set bonding_oxygen [atomselect top "type 1 4 6 and pbwithin 2.6 of index $fe_center"]

		foreach oxygen [$bonding_oxygen get index] {

#			puts "bonds : $fe_center ([[atomselect top "index $fe_center"] get type]) - $oxygen ([[atomselect top "index $oxygen"] get type])"
			topo addbond $fe_center $oxygen  -bondtype 3  -bondorder 1
		}	
	}
	
#	topo writelammpsdata $d1.b full

##########################################################################################################################

	foreach i3 [atomselect list] { $i3 delete }
	

	pbc join connected
	
##########----------delete all of the fe-(Ow,Oh,O) bonds-----------------################################################
	
	set bondList [topo getbondlist type]

        set bondList_length [llength $bondList]

        for {set i1 0} {$i1 < $bondList_length} {incr i1} {

                set first [atomselect top "index [lindex $bondList $i1 0]"]
                set second [atomselect top "index [lindex $bondList $i1 1]"]
		set bondType [atomselect top "index [lindex $bondList $i1 2]"]


                if {[$first get type] == 3} {
 #                       puts "bond_type([$bondType get index]) : [$first get index]([$first get type]) - [$second get index]([$second get type])"
                        topo delbond [$first get index] [$second get index]
                        }

                 if {[$second get type] == 3} {
 #                       puts "bond_type([$bondType get index]) : [$first get index]([$first get type]) - [$second get index]([$second get type])"        
                        topo delbond [$first get index] [$second get index]
                        }

                $second delete
                $first delete
		$bondType delete

       	}

	topo writelammpsdata $d1.c full

}

