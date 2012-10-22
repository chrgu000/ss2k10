/* xxsoivtra.p - INVOICE SHIPMENT TRANSACTION  WITH MULTI ALLOCATIONS          */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13.1.13.3.1 $       */
/*V8:ConvertMode=Maintenance                                                 */
/* copied from soivtr.p                                                      */
/* REVISION: 7.3      CREATED:       08/30/95   BY: jym *G0VQ*               */
/* REVISION: 7.3      CREATED:       09/25/95   BY: jym *G0Y0*               */
/* REVISION: 7.3      CREATED:       10/05/95   BY: ais *G0YK*               */
/* REVISION: 8.5      CREATED:       03/13/96   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *H0X6* Jim Williams      */
/* REVISION: 8.5      LAST MODIFIED: 01/16/98   BY: *J25N* Aruna Patil       */
/* REVISION: 8.5      LAST MODIFIED: 02/17/98   BY: *H1JP* Aruna Patil       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton      */
/* Old ECO marker removed, but no ECO header exists *B067*                   */
/* Old ECO marker removed, but no ECO header exists *D002*                   */
/* Old ECO marker removed, but no ECO header exists *D443*                   */
/* Old ECO marker removed, but no ECO header exists *D472*                   */
/* Old ECO marker removed, but no ECO header exists *F003*                   */
/* Old ECO marker removed, but no ECO header exists *F190*                   */
/* Old ECO marker removed, but no ECO header exists *F504*                   */
/* Old ECO marker removed, but no ECO header exists *F805*                   */
/* Old ECO marker removed, but no ECO header exists *FT84*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L034* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/99   BY: *F0Y0* Poonam Bahl       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb               */
/* REVISION: 9.1      LAST MODIFIED: 11/09/00   BY: *L15P* Falguni Dalal     */
/* REVISION: 9.1      LAST MODIFIED: 10/09/00 BY: *N0W8* Mudit Mehta         */
/* Revision: 1.13.1.9  BY: Steve Nugent  DATE: 10/15/01  ECO: *P004*     */
/* Revision: 1.13.1.12 BY: Patrick Rowan  DATE: 03/15/02  ECO: *P00G*     */
/* Revision: 1.13.1.13    BY: Veena Lad DATE: 06/26/02  ECO: *N1M4*     */
/* $Revision: 1.13.1.13.3.1 $   BY: Santosh Rao  DATE: 06/25/03  ECO: *N2HN*     */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVTRA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input-output parameter l_qty_change like mfc_logical no-undo.

define shared variable eff_date as date.
define shared variable ref like glt_det.glt_ref.
define shared variable so_recno as recid.
define shared variable trlot like tr_lot.
define shared variable sod_recno as recid.
define variable trqty like tr_qty_chg.
define variable qty_left like tr_qty_chg.
define  shared frame bi.
define  shared stream bi.
define  shared variable amd as character.

define variable site like sod_site.
define variable l_lotedited like mfc_logical no-undo.
define shared variable location like sod_loc.
define shared variable lotser like sod_serial.
define shared variable lotrf like sr_ref.

define shared variable exch_rate like exr_rate.

define shared variable exch_rate2 like exr_rate2.
define shared variable exch_ratetype like exr_ratetype.
define shared variable exch_exru_seq like exru_seq.
define shared variable transtype as character.
define variable prev_found like mfc_logical.
define new shared variable trgl_recno as recid.
define new shared variable sct_recno as recid.
define variable glcost like sct_cst_tot.
define variable assay like tr_assay.
define variable grade like tr_grade.
define variable expire like tr_expire.
define variable site_change as logical.
define variable pend_inv as logical initial yes.
define variable gl_tmp_amt as decimal.
define variable mc-error-number like msg_nbr no-undo.
define variable base-price      like tr_price no-undo.
define variable using_shipment_perf like mfc_logical no-undo.
define variable ec_ok as logical.
define new shared variable tr_recno as recid .
define            variable save_um like sod_um no-undo.
define            variable save_um_conv like sod_um_conv no-undo.
define     shared variable noentries as integer no-undo.
define            variable save_site like sod_site no-undo.
define            variable save_loc like sod_loc no-undo.
define            variable save_lot like sod_lot no-undo.
define            variable save_ref like sod_ref no-undo.
define            variable save_qtychg like sod_qty_chg no-undo.
define            variable save_qtyord like sod_qty_ord no-undo.
define            variable save_qtyship like sod_qty_ship no-undo.
define            variable save_bochg like sod_bo_chg no-undo.
define            variable save_price like sod_price no-undo.
define            variable save_location like location no-undo.
define            variable save_lotser like lotser no-undo.
define            variable save_lotrf like lotser no-undo.
define            variable in_update_instructions as character no-undo.
define            buffer   soddet                 for sod_det.
define new shared variable sod_entity like en_entity.
define variable gl_amt like glt_amt.
define variable dr_acct like sod_acct.
define variable dr_sub  like sod_sub .
define variable dr_cc like sod_cc.
define variable from_entity like en_entity.
define variable icx_acct like sod_acct.
define variable icx_sub  like sod_sub .
define variable icx_cc like sod_cc.
{&SOIVTRA-P-TAG1}

define shared workfile wf-tr-hist
   field trsite like tr_site
   field trloc like tr_loc
   field trlotserial like tr_serial
   field trref like tr_ref
   field trqtychg like tr_qty_chg
   field trum like tr_um
   field trprice like tr_price.


/* DETERMINE IF SHIPMENT PERFORMANCE IS INSTALLED */
for first mfc_ctrl where
      mfc_field = "enable_shipment_perf"    and
      mfc_module = "ADG"                    and
      mfc_logical = yes no-lock:
end.
if available mfc_ctrl then
assign
   using_shipment_perf = yes.

find first gl_ctrl no-lock no-error.

find so_mstr no-lock where recid(so_mstr) = so_recno no-error.
if not available so_mstr then leave.

find sod_det no-lock where recid(sod_det) = sod_recno no-error.
if not available sod_det then leave.

find si_mstr where si_site = sod_site no-lock.
sod_entity = si_entity.

find pt_mstr where pt_part = sod_part no-lock no-error.
if available pt_mstr then
   find pl_mstr where pl_prod_line = pt_prod_line no-lock.

/* FORM DEFINITION FOR HIDDEN FRAME BI */
{sobifrm.i}

FORM /*GUI*/ 
   sod_det
with  frame bi width 80 THREE-D /*GUI*/.


/*        WF-TR-HIST STORES THE QTY SHIPPED FOR EACH SITE/LOCATION/ */
/*        SERIAL-LOT/REFERENCE COMBINATION.                         */
/*        THE SOD_DET RECORD MUST BE TEMPORARILY MADE TO LOOK LIKE  */
/*        EACH BREAK DOWN BY SITE/LOCATION/SER-LOT/REFERENCE.  ONCE */
/*        WE ARE DONE LOOKING AT EACH WF-TR-HIST RECORD, THEN RESTORE*/
/*        THE SOD_DET BACK TO IT'S ORIGINAL STATE.                   */

assign
   save_um = sod_um
   save_um_conv = sod_um_conv
   save_site = sod_site
   save_loc = sod_loc
   save_ref = sod_ref
   save_lot = sod_lot
   save_qtychg = sod_qty_chg
   save_qtyord = sod_qty_ord
   save_bochg = sod_bo_chg
   save_qtyship = sod_qty_ship
   save_price = sod_price.

for each wf-tr-hist:

   assign sod_site = wf-tr-hist.trsite
      sod_um = wf-tr-hist.trum
      sod_um_conv = 1
      sod_loc = wf-tr-hist.trloc
      save_location = location
      save_lotrf = lotrf
      save_lotser = lotser
      location = wf-tr-hist.trloc
      lotrf = wf-tr-hist.trref
      lotser = wf-tr-hist.trlotserial
      sod_lot = wf-tr-hist.trlotserial
      sod_price = wf-tr-hist.trprice
      sod_qty_chg = trqtychg
      sod_qty_ship = (input frame bi sod_qty_ship) *
      (input frame bi sod_um_conv)
      sod_qty_ord =  (input frame bi sod_qty_ord) *
      (input frame bi sod_um_conv)
      sod_bo_chg = 0.

   if amd = "DELETE"
      then in_update_instructions = "no in_qty_req update".
   else
   if amd = "MODIFY"
      then in_update_instructions = "update in_qty_req".

   for first si_mstr
         fields (si_cur_set si_entity si_gl_set si_site si_status)
         where si_site = sod_site no-lock:
   end. /* FOR FIRST si_mstr */
   if available si_mstr
      then
      sod_entity = si_entity.

   if amd = "DELETE" or amd = "MODIFY" then do:
      assign
         l_lotedited  = yes
         l_qty_change = (- sod_qty_chg <> save_qtychg).

      /* CALL mfivtr.i WITHOUT FRAME BI */
      {gprun.i ""xxsoivtr2.p""
               "(input site_change,
                 input l_lotedited,
                 input l_qty_change,
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

   assign
      sod_site = wf-tr-hist.trsite
      sod_loc = wf-tr-hist.trloc
      sod_lot = wf-tr-hist.trlotserial
      sod_qty_chg = -1 * trqtychg
      sod_bo_chg = save_bochg * input frame bi sod_um_conv
      sod_qty_ship = save_qtyship * input frame bi sod_um_conv
      sod_price = save_price / save_um_conv.

   l_qty_change = (sod_qty_chg <> save_qtychg).

   if noentries = 1 then
   assign
      sod_price = save_price
      sod_um = save_um
      sod_um_conv = save_um_conv
      sod_site = save_site
      sod_qty_chg = save_qtychg
      sod_qty_ord = save_qtyord
      sod_bo_chg = save_bochg
      sod_qty_ship = save_qtyship
      location = save_location
      lotser = save_lotser
      lotrf = save_lotrf.

   for first si_mstr
         fields (si_cur_set si_entity si_gl_set si_site si_status)
         where si_site = sod_site no-lock:
   end. /* FOR FIRST si_mstr */
   if available si_mstr
      then
      sod_entity = si_entity.

   if  amd <> "DELETE"
   then do:

      in_update_instructions = "update in_qty_req".
      /* CALL mfivtr.i WITHOUT FRAME BI */
      {gprun.i ""xxsoivtr2.p""
               "(input site_change,
                 input l_lotedited,
                 input l_qty_change,
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

      l_lotedited = no.
   end.

end. /* for each wf-tr-hist */

/* RESTORE THE SOD_DET RECORD TO IT'S ORIGINAL VALUE */
assign sod_site = save_site
   sod_price = save_price
   sod_um = save_um
   sod_um_conv = save_um_conv
   sod_loc = save_loc
   sod_ref = save_ref
   sod_lot = save_lot
   sod_bo_chg = save_bochg
   sod_qty_ord = save_qtyord
   sod_qty_ship = save_qtyship
   sod_qty_chg = save_qtychg.
if noentries <> 1 and sod_um_conv <> 1 then
   assign sod_std_cost = sod_std_cost * sod_um_conv.