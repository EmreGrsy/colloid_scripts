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
package require pbctools

set dataFile [glob *.min.temp]

foreach d1 $dataFile {
	
	topo readlammpsdata $d1 full	

	pbc wrap

######################## (i) remove all water except of chemisorbed water (Fe-Ow < 2.6 Ang); keep the chemisorbed water intact #################

        #set allowed_water [atomselect top "same fragment as (type 1 and pbwithin 2.6 of type 3)"]
        set deleted_water [atomselect top "same fragment as (type 1 and not (same fragment as (type 1 and pbwithin 2.6 of type 3)))"]

        # define dummy atom type which would be used in the lammps script to be erased
        $deleted_water set type 7

        topo writelammpsdata $d1 full
}
################################################################################################################################################
