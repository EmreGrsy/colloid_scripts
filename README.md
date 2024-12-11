## Overiew

This repo includes scripts I wrote for Lucio to be used in his colloidal structures.

## Objectives

1. Remove all water except chemisorbed water (Fe-Ow < 2.6 Å); keep the chemisorbed water intact.
2. Remove (OH)⁻ but keep track of how much has been removed.
3. Remove ALL Fe-O (dummy bonds), including those to OH and O.
4. Separate the clusters.
5. Keep separate clusters intact at the periodic boundaries.

## Solution

1. Fe-O and Fe-(OH) bonds were assigned using TopoTools (`a-reconstruct_beforeMin.tcl`).
2. After using TopoTools—which erases bond and angle coefficients—the coefficients were reassigned (`b-reconstruct_beforeMin.sh`).
3. TopoTools reallocates bonds and angles. Due to the reallocation procedure, some bond types were changed from type 3 to type 2. These were corrected using different `ff_param` files.
4. After obtaining the minimized geometry, dummy bonds (bond type 3) were converted back to bond type 2 (`a1-fix_bondError.tcl` or `search_and_replace.txt`).
5. All water except the chemisorbed water (Fe-Ow < 2.6 Å) was assigned to atom type 7 for removal (`a2-reconstruct.tcl`).
6. Type 7 atoms were deleted (`b-reconstruct.lmp`).
7. Bonds and angles were analyzed to check for issues (`c-analyze_topology.tcl`).
8. For the results, different atom types were written out to the `.log` file. Wandering (OH)⁻ and (H)⁺ atoms were assigned as atom type 7 for deletion (`d-colloid_data.tcl`).
9. Free (OH) molecules were assigned to atom type 7 for deletion. The `.log` file also includes details requested by Robert (`d-colloid_data.tcl`).
10. Type 7 atoms were deleted (`e-reconstruct.lmp`).
11. Minimization results were read (`*min.log`), and potential energy (E_Pot) was scraped from the log files and added to the result data (`read_energy.sh`).
12. Bonds between Fe and O atoms were defined using TopoTools. Bonds stretching over the periodic boundaries were connected. After obtaining the final connected structure, bonds were erased (`f-combine.tcl`).
13. Clusters were assigned (`g-cluster.tcl`).

### Additional Steps

1. Fe-O and Fe-(OH) bonds were assigned and subsequently deleted using TopoTools (`delbonds`) (`a-reconstruct_beforeMin.tcl`).
2. TopoTools reallocates bonds and angles. This reallocation was verified for correctness (`c-analyze_topology.tcl`).
3. Dummy bonds (bond type 3) were converted back to bond type 2 after minimization (`search_and_replace.txt`).
4. All water except chemisorbed water (Fe-Ow < 2.6 Å) was assigned to atom type 7 for removal (`a2-reconstruct.tcl`).
5. Type 7 atoms were deleted (`b-reconstruct.lmp`).
6. Molecular topology was verified (`c1-analyze_topology.tcl`).
7. Wandering (OH)⁻ and (H)⁺ atoms were identified and assigned to atom type 7 for deletion (`d-colloid_data.tcl`).
8. Type 7 atoms were deleted (`yes-delete.lmp` and `no-delete.lmp`).
9. Residual entries of "7 atom types" and "Masses....7 1" were deleted (`search_and_replace.txt`).
10. Individual clusters were assigned (`g-cluster.lmp`).
11. For each cluster, a new data file was constructed (`h_segregate.tcl`).
12. Molecules stretching across periodic boundaries were centered in the periodic box (`i_merge.sh`).
13. Modifications were summarized (`modify.txt`).
