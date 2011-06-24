/* woisrc1d.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                   */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.2     LAST MODIFIED: 03/07/95    BY: ais *F0LX*                */
/* REVISION: 8.5     LAST MODIFIED: 07/28/95    BY: tjs *J060*                */
/* REVISION: 8.5     LAST MODIFIED: 10/03/95    BY: tjs *J082*                */
/* REVISION: 7.3     LAST MODIFIED: 12/12/95    BY: rvw *G1G2*                */
/* REVISION: 7.3     LAST MODIFIED: 05/28/96    BY: rvw *G1WF*                */
/* REVISION: 8.6     LAST MODIFIED: 09/09/96    BY: jpm *K00D*                */
/* REVISION: 8.6     LAST MODIFIED: 09/10/96    BY: *G2D9* Julie Milligan     */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown         */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00    BY: *N0L3* Arul Victoria      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13    BY: Veena Lad   DATE: 12/05/00 ECO: *P008*               */
/* $Revision: 1.15 $   BY: Niranjan R.  DATE: 06/25/02 ECO: *P09L*   */
/* By: Neil Gao Date: 20061024 ECO: *ss 20061024.1 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woisrc1d_p_1 "Backflush Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc1d_p_2 "Issue Picked"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc1d_p_3 "Cancel B/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc1d_p_4 "Issue Alloc"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc1d_p_5 "Backflush Method"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc1d_p_10 "Quantity Calculation Method"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter pModifyBackflush as logical no-undo.

define new shared variable avgissue like mfc_logical initial yes.
define new shared variable setd-action as integer.

define shared variable fill_all like mfc_logical
   label {&woisrc1d_p_4} initial no.
define shared variable fill_pick like mfc_logical
   label {&woisrc1d_p_2} initial yes.
define shared variable backflush_qty like wod_qty_chg
   label {&woisrc1d_p_1}.
define shared variable default_cancel like mfc_logical
   label {&woisrc1d_p_3}.

define shared variable wo_recno as recid.
define shared variable base      like mfc_logical initial no.
define shared variable base_id   like wo_base_id.
define shared variable jp        like mfc_logical initial no.
define shared variable back_qty  like sr_qty.

define variable backflush        like bom_mthd.
define variable parent_item      like pt_part.
define variable jp_bflush_mthd   as character format "x(40)".

define variable qty_issued      as logical no-undo.
define variable labour_feedback as logical no-undo.

{woisrc1c.i}       /* shared variables for modified backflush */
{gpfieldv.i}       /* variables for gpfield.p */

define workfile mt_method
   field mt_method_n as integer
   field mt_desc     as character format "x(40)" label {&woisrc1d_p_10}.

define workfile op_options
   field op_option_n as integer
   field op_desc     as character format "x(40)" label {&woisrc1d_p_5}.

/* ss 20061024.1 */ define shared var xlocation like loc_loc .

{ecwndvar.i}       /*scrolling window variables */

/* REPLACEMENT FORM */
form
   wo_qty_ord        colon 30
   wo_qty_comp       colon 30
   backflush_qty     colon 30
/* ss 20061024.1 */   xlocation  colon 30 label "回冲库位"
   jp_bflush_mthd    to 57    no-label
   skip(1)
   fill_all          colon 30
   fill_pick         colon 30
   default_cancel    colon 30
   skip (1)
   mt_method.mt_desc colon 30
   op_desc           colon 30
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

create mt_method.
assign
   mt_method.mt_desc = getTermLabel("COMPONENT_REQUIRED_QUANTITY",40)
   mt_method.mt_method_n = comp_rqd_qty.

create mt_method.
assign
   mt_method.mt_desc = getTermLabel("WORK_ORDER_BILL_QTY_PER",40)
   mt_method.mt_method_n = w_o_bill_qty.

if phantom_first_allowed then do:
   create mt_method.
   assign
      mt_method.mt_desc = getTermLabel("PHANTOMS_FIRST",40)
      mt_method.mt_method_n = phantom_first.
end.
else do:
   find first mt_method where
              mt_method.mt_desc = getTermLabel("PHANTOMS_FIRST",40) and
              mt_method.mt_method_n = phantom_first
   exclusive-lock no-error.
   if available mt_method then
      delete mt_method.
end.

create op_options.
assign
   op_desc = getTermLabel("STANDARD_BACKFLUSH",40)
   op_option_n = std_backflush.

create op_options.
assign
   op_desc = getTermLabel("NET_OF_PRIOR_ISSUES_AND_RECEIPTS",40)
   op_option_n = net_backflush.

find wo_mstr no-lock where recid(wo_mstr) = wo_recno.

assign
   backflush_qty = wo_qty_chg + wo_rjct_chg
   parent_item   = wo_part.

if jp then do:

   base = no.

   find wo_mstr where wo_lot = base_id no-lock no-error.

   if available wo_mstr then do:

      find bom_mstr where bom_parent = wo_part no-lock no-error.

      if available bom_mstr then
         backflush = bom_mthd.

      backflush_qty = back_qty.

      /* JP BACKFLUSH METHOD DISPLAYED ONLY FOR JOINT PRODUCT WOs */
      /* GET LABEL FOR bom_mthd FROM SCHEMA */
      {gpfield.i &field_name='"bom_mthd"'}

      if field_found then
         jp_bflush_mthd = field_label + ": " + bom_mthd.
      else
         jp_bflush_mthd = "".

   end.

end.
else
   jp_bflush_mthd = "".

find first op_options no-lock.
find first mt_method no-lock.

/* DO THIS ONLY FOR REGULAR WORK ORDER ATTACHED TO FLOW SCHEDULE */
if (wo_type = " " and (can-find(first flsd_det
                                  where flsd_flow_wo_nbr = wo_nbr
                                  and   flsd_flow_wo_lot = wo_lot)))
then do:

   /* CHECK IF QUANTITY HAS BEEN ISSED TO THIS WORK ORDER */
   {mfwomta.i wo_lot qty_issued labour_feedback}
   if qty_issued then
      /* THIS WILL DEFAULT NET_BACKFLUSH METHOD */
      find next op_options no-lock.
end.

/* IF MODIFY BACKFLUSH THEN UI WILL BE ENABLE */
if pModifyBackflush then do:

   /* DISPLAY */
   do on error undo, retry with frame a:

      display
         wo_qty_ord
         wo_qty_comp
         jp_bflush_mthd
         mt_method.mt_desc
         op_desc.

      /* GET REVISED BACKFLUSH METHOD AND OPTION */
      update
         backflush_qty
/* ss 20061024.1 */ xlocation validate ( can-find(first loc_mstr no-lock where loc_loc = xlocation ),"库位不存在")
         fill_all
         fill_pick
         default_cancel.

      if not batchrun then do:

         prompt-for
            mt_method.mt_desc
         with frame a editing:
            /*FIND NEXT/PREVIOUS RECORD*/
            {mfnp10.i mt_method mt_desc mt_desc mt_desc mt_desc}
            display
               mt_method.mt_desc.
            if mt_method.mt_method_n = phantom_first then
               display
                  " " @ op_desc.
            else
               display
                  op_desc.
         end.

         if recno <> ? then
         find first mt_method where recid(mt_method) = recno no-lock.

         if mt_method.mt_method_n <> phantom_first then do:
            prompt-for
               op_desc
            with frame a editing:
               /*FIND NEXT/PREVIOUS RECORD*/
               {mfnp10.i op_options op_desc op_desc op_desc op_desc}
               display
                  op_desc.
            end.
         end.

         if recno <> ? then
         find first op_options where recid(op_options) = recno
         no-lock.

      end. /*if not batchrun */

      else do
      with frame batch width 80 no-attr-space:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame batch:handle).

         prompt-for
            mt_method.mt_method_n.
         assign
            mt_method.mt_method_n.

         if mt_method.mt_method_n = 3 then
            op_option_n = 1.
         else do:
            prompt-for
               op_option_n.
            assign
               op_option_n.
         end.
      end.

      assign
         quantity-method  = mt_method.mt_method_n
         backflush-method = op_option_n.

      hide frame a no-pause.

   end.
end. /* if pModifyBackFlush */
/* IN CASE OF FLOW WORK ORDER IF UI IS DISABLE THEN DEFAULT THE BACKFLUSH */
/* METHOD */
else
   assign
      quantity-method  = mt_method.mt_method_n
      backflush-method = op_option_n.
