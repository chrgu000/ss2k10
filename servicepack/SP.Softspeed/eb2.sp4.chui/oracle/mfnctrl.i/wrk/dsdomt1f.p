/* dsdomt1f.p - INTER-SITE DEMAND BACKORDER/SPLIT                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3       LAST EDIT: 02/24/94      MODIFIED BY: emb *GI98**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn          */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00   BY: *N0MX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller      */


/* ********** Begin Translatable Strings Definitions ********* */

/*N0MX* &SCOPED-DEFINE dsdomt1f_p_1 "Intersite Demand" */
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     {mfdeclre.i}
     {gplabel.i} /* EXTERNAL LABEL INCLUDE */

     define shared variable ds_recno as recid.
     define shared variable ds_db like dc_name.
     define shared variable undo-all like mfc_logical.

     define variable req_nbr like dsr_req_nbr.
     define new shared variable cmtindx like dsr_cmtindx.
     define variable open_qty like mrp_qty.

     define stream hs_dsdet.
     define variable err-flag as integer.

     undo-all = yes.

     form ds_det with frame hf_ds_det.

     find ds_det no-lock where recid(ds_det) = ds_recno no-error.

     if not available ds_det then leave.

     /* Write the demand record to a hidden frame */
     do with frame hf_ds_det on error undo, retry:
        {mfoutnul.i &stream_name="hs_dsdet"}
        display stream hs_dsdet ds_det with frame hf_ds_det.
     end.

     find first drp_ctrl no-lock no-error.
     if available drp_ctrl then do:
        {mfnctrl.i drp_ctrl drp_req_nbr ds_det ds_req_nbr req_nbr}
     end.
     if req_nbr = "" then leave.

     display stream hs_dsdet req_nbr @ ds_req_nbr with frame hf_ds_det.

     find ds_det exclusive-lock
     where ds_det.ds_req_nbr = input ds_req_nbr
     and ds_det.ds_site = input ds_site
     and ds_det.ds_shipsite = input ds_shipsite
     no-error.

     if not available ds_det then create ds_det.

     assign ds_det.

     assign ds_nbr = ""
        ds_qty_all = 0
        ds_qty_ord = max(ds_qty_ord - ds_qty_chg - ds_qty_ship,0)
        ds_qty_chg = 0
        ds_qty_conf = ds_qty_ord
        ds_qty_pick = 0
        ds_qty_ship = 0
        ds_residual = 0.

     if index("PF",ds_status) > 0 then ds_status = "E".

     if ds_qty_ord >= 0 then
        open_qty = max(ds_qty_conf - max(ds_qty_ship,0),0).
     else
        open_qty = min(ds_qty_conf - min(ds_qty_ship,0),0).

     if ds_status = "C" then open_qty = 0.

/*N0TN*/ /* Changed pre-processor to Term */
        {mfmrw.i "ds_det" ds_part ds_req_nbr ds_shipsite
        ds_site ? ds_shipdate open_qty "DEMAND"
        INTERSITE_DEMAND ds_shipsite}

     output stream hs_dsdet close.

     /* UPDATE dsd_det RECORD FOR REQUESTING SITE */
     assign ds_recno = recid(ds_det)
           ds_db = global_db
        undo-all = true.

     {gprun.i ""dsdmmtv1.p""}

     if undo-all then do:
        find ds_det exclusive-lock where recid(ds_det) = ds_recno.
        delete ds_det.
        leave.
     end.

     undo-all = no.
