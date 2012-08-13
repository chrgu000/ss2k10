/* GUI CONVERTED from soivtr1.p (converter v1.76) Mon Jun 30 07:59:49 2003 */
/* soivtr1.p - INVOICE SHIPMENT TRANSACTION CALL TO MFIVTR.I WITH FRAME BI   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.1.3.1 $    */
/*                                                                           */
/* Revision: 1.1      BY: Patrick Rowan   DATE: 03/24/02  ECO: *P00G*  */
/* $Revision: 1.1.3.1 $     BY: Santosh Rao     DATE: 06/25/03  ECO: *N2HN*  */

/*V8:ConvertMode=Maintenance                                                 */
/*****************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVTR.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter p_site_change as logical no-undo.
define input parameter p_lotedited as logical no-undo.
define input parameter p_qty_change like mfc_logical no-undo.
define input parameter p_update_instructions as character no-undo.

define shared variable eff_date as date.
define shared variable ref like glt_det.glt_ref.
define shared variable so_recno as recid.
define shared variable trlot like tr_lot.
define shared variable sod_recno as recid.
define variable trqty like tr_qty_chg no-undo.
define variable qty_left like tr_qty_chg no-undo.
define  shared frame bi.
define  shared stream bi.
define  shared variable amd as character.

define variable site like sod_site no-undo.

define shared variable location like sod_loc.
define shared variable lotser like sod_serial.
define shared variable lotrf like sr_ref.

define shared variable exch_rate like exr_rate.

define shared variable trgl_recno as recid.
define shared variable sct_recno as recid.
define shared variable tr_recno as recid .
define shared variable sod_entity like en_entity.

define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable transtype as character.
define variable prev_found like mfc_logical no-undo.
define variable glcost like sct_cst_tot no-undo.
define variable assay like tr_assay no-undo.
define variable grade like tr_grade no-undo.
define variable expire like tr_expire no-undo.
define variable site_change as logical no-undo.
define variable pend_inv as logical initial yes no-undo.

define variable ec_ok as logical no-undo.
define variable in_update_instructions as character no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable base-price      like tr_price no-undo.
define variable gl_tmp_amt as decimal no-undo.
define variable gl_amt like glt_amt no-undo.
define variable dr_acct like sod_acct no-undo.
define variable dr_sub like sod_sub no-undo.
define variable dr_cc   like sod_cc no-undo.
define variable from_entity like en_entity no-undo.
define variable icx_acct like sod_acct no-undo.
define variable icx_sub like sod_sub no-undo.
define variable icx_cc like sod_cc no-undo.
define variable l_lotedited like mfc_logical no-undo.
define variable l_qty_change like mfc_logical no-undo.
define variable using_shipment_perf like mfc_logical no-undo.

define buffer   soddet     for sod_det.

/* CONSIGNMENT VARIABLES. THESE ARE USED IN mfivtr.i */
{socnvars.i}
{socnvar2.i}
define variable io_first_time as logical initial yes no-undo.

assign
   site_change  = p_site_change
   l_lotedited  = p_lotedited
   l_qty_change = p_qty_change
   l_rmks = getTermLabel("CONSIGNED",12).


/* FIND ALL TABLES & FIELDS FOR REFERENCE */

for first gl_ctrl fields(gl_rnd_mthd) no-lock:
end.

for first so_mstr
      fields(so_curr so_cust so_rev so_ship_date)
      no-lock where recid(so_mstr) = so_recno:
end.

for first sod_det no-lock where recid(sod_det) = sod_recno:
end.

for first si_mstr
      fields(si_cur_set si_entity si_gl_set si_site si_status)
      where si_site = sod_site no-lock:
end.

sod_entity = si_entity.

for first pt_mstr
      fields(pt_abc pt_avg_int pt_cyc_int pt_loc pt_part pt_prod_line
      pt_rctpo_active pt_rctpo_status pt_rctwo_active
      pt_rctwo_status pt_shelflife pt_um)
      where pt_part = sod_part no-lock:
end.

if available pt_mstr then

for first pl_mstr

      fields(pl_inv_acct pl_inv_sub pl_inv_cc pl_prod_line)
      where pl_prod_line = pt_prod_line no-lock:
end.

/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}

FORM /*GUI*/ 
   sod_det
with frame bi width 80 THREE-D /*GUI*/.


{mfivtr.i "input frame bi" p_update_instructions}
