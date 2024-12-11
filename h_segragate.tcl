package require topotools
package require pbctools

set dataFile [open "dock_data.txt" r]

while {1} {

        set dock_file [gets $dataFile]

        if {[eof $dataFile]} {
                close $dataFile
                break
        }
	
        topo readlammpsdata g.$dock_file full
	topo guessatom lammps data
	
	set top_mol [molinfo top get id]
        puts "top molecule id : $top_mol"

	set structure [atomselect $top_mol all]
        set res_ids [lsort -unique [$structure get resid]]

	set dummy_mol [expr {$top_mol + 1}]
	puts "dummy molecule id: $dummy_mol"

	set write_resID 1

	foreach res_id $res_ids {

       		set current_mol [atomselect $top_mol "resid $res_id"]

        	::TopoTools::selections2mol $current_mol
        	topo guessatom lammps data

       	 	mol top $dummy_mol

        	topo writelammpsdata h.$dock_file-$write_resID full

		puts "top ($top_mol) - res ([molinfo top get id])"

		$current_mol delete

		mol delete $dummy_mol

      		incr dummy_mol
		incr write_resID
	}

	$structure delete
}
