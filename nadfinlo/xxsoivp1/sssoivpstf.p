/* soivpstf.p - SALES ORDER HEADER INVOICE POST                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.2      LAST MODIFIED: 11/14/94   BY: rxm *FT54*          */
/* REVISION: 7.2      LAST MODIFIED: 03/13/95   BY: jxz *F0M3*          */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/29/98   BY: *N004* Steve Nugent */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb          */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0W8* Mudit Mehta  */

     {mfdeclre.i}
/*N0W8*/ {cxcustom.i "SOIVPSTF.P"}
    /* ss - 130320.1 -b */
     DEFINE INPUT PARAMETER xxabsnbr  as character no-undo. 
    /* ss - 130320.1 -e */
     define shared variable sonbr like so_nbr.
     define shared variable soline like sod_line.
     define shared variable soinv like so_inv_nbr.
     define shared variable eff_date like ar_date.
/*F0M3*/ define shared variable undo_all like mfc_logic no-undo.

/*N004*/ define shared variable using_seq_schedules like mfc_logical no-undo.
/*N004*/ define shared temp-table so_shipper_info no-undo
/*N004*/        field tt_ship_id like tr_ship_id
/*N004*/        field tt_nbr like so_nbr
/*N004*/        field tt_line like sod_line
/*N004*/        field tt_inv_nbr like so_inv_nbr
/*N004*/        index tt_ship_id tt_nbr tt_line tt_inv_nbr.


/*F0M3*/ do transaction on error undo, leave:

/*N0W8*/ {&SOIVPSTF-P-TAG1}
        for each tr_hist where tr_nbr = sonbr
                 and tr_line = soline
                 and tr_type = "ISS-SO"
                 /* ss - 130320.1 -b
                 and tr_rmks = ""
                 ss - 130320.1 -e */
    /* ss - 130320.1 -b */
       and can-find (first xxabs_mstr no-lock where

                xxabs_nbr = xxabsnbr and
             xxabs_order = tr_nbr and
             integer(xxabs_line) = tr_line
                and xxabs_par_id = "s" + tr_ship_id
		/*
		and xxabs_loc = tr_loc
		and xxabs_lot = tr_serial
		and xxabs_ref = tr_ref 
		*/
       use-index xxabs_shipto
         )
    /* ss - 130320.1 -e */
/*N0W8*/ {&SOIVPSTF-P-TAG2}
                 use-index tr_nbr_eff:
           tr_rmks    = soinv.
           tr_gl_date = eff_date.

/*N004*/   if using_seq_schedules then do:
/*N004*/      create so_shipper_info.

/*N004*/          assign
/*N004*/             tt_ship_id = "s" + tr_ship_id
/*N004*/             tt_nbr = tr_nbr
/*N004*/             tt_line = tr_line
/*N004*/             tt_inv_nbr = soinv.

/*N004*/      if recid(so_shipper_info) = -1 then .
/*N004*/   end.

        end.

/*F0M3*/    return.
/*F0M3*/ end. /* do transaction */

/*F0M3*/ undo_all = yes.
