/* xxppptrp07.i - parameter file                                             */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */

define {1} shared temp-table tmpld03
     fields t03_part like pt_mstr.pt_part
     fields t03_site like pt_mstr.pt_site
     fields t03_um   like pt_mstr.pt_um
     fields t03_qty  like ld_det.ld_qty_oh
     fields t03_cst  like sct_det.sct_cst_tot
     index t03_part_site is primary t03_part t03_site.

define {1} shared temp-table tmploc01
     fields t01_site like loc_site
     fields t01_lock like loc_loc.