/* GUI CONVERTED from soivtr.p (converter v1.76) Mon Jun 30 07:59:47 2003 */
/* soivtr.p - INVOICE SHIPMENT TRANSACTION                                   */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.27.3.1 $    */
/*                                                                           */
/* REVISION: 4.0      LAST MODIFIED: 10/04/88   BY: emb *A466*               */
/* REVISION: 5.0      LAST MODIFIED: 03/16/89   BY: pml *B067*               */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: MLB *B159*               */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: WUG *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: MLB *D443*               */
/* REVISION: 6.0      LAST MODIFIED: 04/02/91   BY: WUG *D472*               */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 11/06/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 05/12/92   BY: sas *F450*               */
/* REVISION: 7.0      LAST MODIFIED: 06/09/92   BY: tjs *F504*               */
/* REVISION: 7.0      LAST MODIFIED: 07/17/92   BY: tjs *F805*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*               */
/* REVISION: 7.4      LAST MODIFIED: 09/16/93   BY: dpm *H075*               */
/* REVISION: 7.4      LAST MODIFIED: 12/12/94   BY: dpm *FT84*               */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dpm *J044*               */
/* REVISION: 7.3      LAST MODIFIED: 10/05/95   BY: ais *G0YK*               */
/* REVISION: 7.4      LAST MODIFIED: 12/13/95   BY: ais *G1GC*               */
/* REVISION: 8.5      LAST MODIFIED: 10/19/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *H0X6* Jim Williams      */
/* REVISION: 8.5      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *L024* Sami Kureishy     */
/* REVISION: 9.0      LAST MODIFIED: 10/01/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 04/21/99   BY: *F0Y0* Poonam Bahl       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb                 */
/* REVISION: 9.1      LAST MODIFIED: 10/14/00 BY: *N0W8* Mudit Mehta         */
/* Revision: 1.24     BY: Steve Nugent  DATE: 10/15/01  ECO: *P004*      */
/* Revision: 1.27   BY: Patrick Rowan  DATE: 03/15/02  ECO: *P00G*      */
/* $Revision: 1.27.3.1 $  BY: Santosh Rao    DATE: 06/25/03  ECO: *N2HN*      */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                           */
/*V8:ConvertMode=Maintenance                                                 */
/*****************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVTR.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input-output parameter p_qty_change like mfc_logical no-undo.

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

define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable transtype as character.
define variable prev_found like mfc_logical no-undo.
define new shared variable trgl_recno as recid.
define new shared variable sct_recno as recid.
define variable glcost like sct_cst_tot no-undo.
define variable assay like tr_assay no-undo.
define variable grade like tr_grade no-undo.
define variable expire like tr_expire no-undo.
define variable site_change as logical no-undo.
define variable pend_inv as logical initial yes no-undo.

define variable ec_ok as logical no-undo.
define new shared variable tr_recno as recid .
define variable in_update_instructions as character no-undo.
define variable mc-error-number like msg_nbr no-undo.
define variable base-price      like tr_price no-undo.
define variable gl_tmp_amt as decimal no-undo.
define new shared variable sod_entity like en_entity.
define variable gl_amt like glt_amt no-undo.
define variable dr_acct like sod_acct no-undo.
define variable dr_sub like sod_sub no-undo.
define variable dr_cc   like sod_cc no-undo.
define variable from_entity like en_entity no-undo.
define variable icx_acct like sod_acct no-undo.
define variable icx_sub like sod_sub no-undo.
define variable icx_cc like sod_cc no-undo.
define variable l_lotedited like mfc_logical no-undo.
define variable using_shipment_perf like mfc_logical no-undo.

define buffer   soddet     for sod_det.


{&SOIVTR-P-TAG1}

/* DETERMINE IF SHIPMENT PERFORMANCE IS INSTALLED */
for first mfc_ctrl where
      mfc_field = "enable_shipment_perf"    and
      mfc_module = "ADG"                    and
      mfc_logical = yes no-lock:
end.
if available mfc_ctrl then
   using_shipment_perf = yes.

/* FIND GL_CTRL FILE FOR USE IN MFIVTR.I */
for first gl_ctrl fields(gl_rnd_mthd) no-lock:
end.

for first so_mstr
      fields(so_curr so_cust so_rev so_ship_date)
      no-lock where recid(so_mstr) = so_recno:
end.
if not available so_mstr then leave.

for first sod_det no-lock where recid(sod_det) = sod_recno:
end.
if not available sod_det then leave.

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


if amd = "DELETE"
   then in_update_instructions = "no in_qty_req update".
else in_update_instructions = "update in_qty_req".
if amd = "DELETE" or amd = "MODIFY" then do:
   assign
      site_change  = (frame bi sod_site <> sod_site)
      p_qty_change = (frame bi sod_qty_chg <> sod_qty_chg).

   /* CALL mfivtr.i WITH FRAME BI */
   {gprun.i ""xxsoivtr1.p""
            "(input site_change,
              input l_lotedited,
              input p_qty_change,
              input in_update_instructions)"}
/*GUI*/ if global-beam-me-up then undo, leave.

end.
/* Re-initialize the shared variables so that user entered */
/* Sod_loc and sod_serial will be used for reshipment */
assign
   location = ""
   lotser = ""
   lotrf = "".

if amd = "ADD"
   then in_update_instructions = "no in_qty_req update".
else in_update_instructions = "update in_qty_req".
if amd = "ADD" or amd = "MODIFY" then do:

   /* CALL mfivtr.i WITHOUT FRAME BI */
   {gprun.i ""xxsoivtr2.p""
            "(input site_change,
              input l_lotedited,
              input p_qty_change,
              input in_update_instructions)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   /* IF SHIPMENT PERFORMANCE IS INSTALLED */
   /* THEN CALL A SUBPROGRAM TO COLLECT    */
   /* SHIPMENT PERFORMANCE INFORMATION.    */
   if using_shipment_perf then do:
      {gprunmo.i
         &program= ""soshpso.p""
         &module="ASR"
         &param= """(input recid(sod_det),
                     input '',
                     input '',
                     input '',
                     input no,
                     input 0,
                     input yes,
                     input 0,
                     input yes)"""}
   end. /* IF using_shipment_perf */
end.
