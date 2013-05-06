/* xxppptrp07.i - parameter file                                             */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */


/* TEMP-TABLE STORING QUANTITY, ITEM NO. AND LOCATION         */
/* FOR A SITE                                               */
define {1} shared temp-table t_trhist no-undo
   field t_trhist_domain             like tr_domain
   field t_trhist_part               like tr_part
   field t_trhist_effdate            like tr_effdate
   field t_trhist_site               like tr_site
   field t_trhist_loc                like tr_loc
   field t_trhist_trnbr              like tr_trnbr
   field t_trhist_ship_type          like tr_ship_type
   field t_trhist_nbr                like tr_nbr
   field t_trhist_type               like tr_type
   field t_trhist_program            like tr_program
   field t_trhist_price              like tr_price
   field t_trhist_qty_loc            like tr_qty_loc
   field t_trhist_begin_qoh          like tr_begin_qoh
   field t_trhist_status             like tr_status
   field t_trhist_rmks               like tr_rmks
   field t_trhist_rev                like tr_rev
   field t_trhist_qty_cn_adj         like tr_qty_loc
   field t_trhist_flag               like mfc_logical
   index t_trhist is primary unique
      t_trhist_domain t_trhist_part t_trhist_effdate t_trhist_site
      t_trhist_loc t_trhist_trnbr t_trhist_ship_type.

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