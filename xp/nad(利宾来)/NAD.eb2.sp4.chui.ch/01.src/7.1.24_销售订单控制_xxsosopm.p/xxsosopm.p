/* sosopm.p - SALES ORDERS PARAMETER MAINTENANCE                              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.48.3.1 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 05/12/86   BY: PML */
/* REVISION: 7.3      LAST MODIFIED: 08/27/92   BY: tjs *G033**/
/* REVISION: 7.3      LAST MODIFIED: 09/21/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692**/
/* REVISION: 7.4      LAST MODIFIED: 09/21/93   BY: WUG *H140**/
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: CDT *H086**/
/* REVISION: 7.4      LAST MODIFIED: 10/19/93   BY: dpm *H067**/
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: CDT *H184**/
/* REVISION: 7.4      LAST MODIFIED: 11/09/93   BY: dgh *H214**/
/* REVISION: 7.4      LAST MODIFIED: 11/30/93   BY: dgh *H247**/
/* REVISION: 7.4      LAST MODIFIED: 03/03/94   BY: CDT *H289**/
/* REVISION: 7.4      LAST MODIFIED: 03/09/94   BY: CDT *H292**/
/* REVISION: 7.4      LAST MODIFIED: 04/13/94   BY: WUG *H341**/
/* REVISION: 7.4      LAST MODIFIED: 04/25/94   BY: cdt *GJ56**/
/* REVISION: 7.4      LAST MODIFIED: 05/27/94   BY: qzl *H375**/
/* REVISION: 7.4      LAST MODIFIED: 07/27/94   BY: bcm *H462**/
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510**/
/* REVISION: 7.4      LAST MODIFIED: 10/18/94   BY: ljm *GN36**/
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   BY: dgh *H590**/
/* REVISION: 7.4      LAST MODIFIED: 04/03/95   BY: dxk *H0CD**/
/* REVISION: 8.5      LAST MODIFIED: 03/15/95   BY: DAH *J042**/
/* REVISION: 7.4      LAST MODIFIED: 05/02/95   BY: jxz *G0LS**/
/* REVISION: 7.4      LAST MODIFIED: 05/31/95   BY: kjm *G0NP**/
/* REVISION: 7.4      LAST MODIFIED: 01/22/96   BY: ais *G1KM**/
/* REVISION: 7.4      LAST MODIFIED: 02/05/96   BY: ais *G0NX**/
/* REVISION: 8.5      LAST MODIFIED: 07/19/95   BY: gwm *J049**/
/* REVISION: 8.5      LAST MODIFIED: 04/05/96   BY: gwm *J0FQ**/
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017*                */
/* REVISION: 8.6      LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 11/20/96   BY: *K025* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 01/03/97   BY: *J1CR* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 02/27/97   BY: *K06F* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 03/14/97   BY: *J1KZ* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 03/28/97   BY: *K098* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 05/20/97   BY: *K0D8* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/23/97   BY: *K0DH* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 10/16/97   BY: *K0N1* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 12/31/97   BY: *K1FH* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 01/05/98   BY: *K1FJ* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J2FG* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 11/11/98   BY: *M00R* Sue Poland         */
/* REVISION: 9.0      LAST MODIFIED: 12/17/98   BY: *M03R* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 07/10/00   BY: *N0FD* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/18/00   BY: *N0MC* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 11/19/00   BY: *M0WC* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 10/17/00   BY: *N0WT* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *N0BG*                    */
/* Revision: 1.39        BY: Vandna Rohira        DATE: 05/14/01  ECO: *N0YM* */
/* Revision: 1.40        BY: Russ Witt            DATE: 06/01/01  ECO: *P00J* */
/* Revision: 1.41        BY: Jean Miller          DATE: 08/01/01  ECO: *M11Z* */
/* Revision: 1.42        BY: Jean Miller          DATE: 09/07/01  ECO: *N122* */
/* Revision: 1.43        BY: Russ Witt            DATE: 09/21/01  ECO: *P01H* */
/* Revision: 1.44        BY: Ed van de Gevel      DATE: 04/16/02  ECO: *N1GP* */
/* Revision: 1.45        BY: Jean Miller          DATE: 05/07/02  ECO: *P066* */
/* Revision: 1.46        BY: Ashish M.            DATE: 05/14/02  ECO: *P06M* */
/* Revision: 1.47        BY: Jean Miller          DATE: 06/03/02  ECO: *P065* */
/* Revision: 1.48        BY: Katie Hilbert        DATE: 09/05/02  ECO: *P0HK* */
/* $Revision: 1.48.3.1 $         BY: Jyoti Thatte       DATE: 08/29/03 ECO: *P106* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110104.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "110104.1"}
{cxcustom.i "SOSOPM.P"}

define variable del-yn          like mfc_logical initial no.
define variable valid_acct      like mfc_logical initial no.
define variable avail_calc      as integer format "9"
   label "Which calculation should be used for Qty Available to Allocate".
define variable soc_pc_line     like mfc_logical
   label "Vary Pricing Date by SO Line".
define variable soc_min_shpamt  like mfc_decimal format ">,>>>,>>9" no-undo
                                label "Minimum Shipment Amount".
define variable soc_pt_req      like mfc_logical label "Price Table Required".
define variable old_avail_calc  like avail_calc.
define variable soc_batch       like mfc_logical.
define variable soc_batch_id    as character.
define variable soc_print_id    as character.
define variable err-msg         as character no-undo.
define variable soc_is_batch    like mfc_logical.
define variable soc_is_dev      as character.
define variable soc_is_batid    as character.

/* Flags to allow user to override defaul EMT Validation Behavior */
define variable soc_emt_pick    like mfc_logical no-undo.
define variable soc_emt_rel     like mfc_logical no-undo.
define variable soc_emt_ship    like mfc_logical no-undo.

define variable yn              like mfc_logical.
define variable i               as integer.
define variable j               as integer.
define variable apm-ex-prg      as character format "x(10)" no-undo.
define variable apm-ex-sub      as character format "x(24)" no-undo.
define variable error_flag      like mfc_logical            no-undo.
define variable error_nbr       like msg_nbr                no-undo.
define variable sav-global-site like si_site no-undo.
define variable btb-type        like soc_btb_type format "x(8)" no-undo.
define variable btb-type-desc   like glt_desc     no-undo.
define variable isvalid         like mfc_logical.

/* fname NEEDED FOR SCROLLING WINDOW swlngd.p */
define new shared variable fname like lngd_dataset no-undo initial "EMT".
define variable disp-char12     as character format "x(27)" no-undo.
define variable disp-char6      as character format "x(28)" no-undo.
define variable disp-char21     as character format "x(26)" no-undo.
define variable disp-char1      as character format "x(26)" no-undo.
define variable disp-char4      as character format "x(26)" no-undo.
define variable disp-char23     as character format "x(26)" no-undo.

assign
   disp-char12  = "(" + getTermLabel("ZERO_FOR_NO_ALLOCATIONS",25) + ")"
   disp-char6   = getTermLabel("FORECAST_CONSUMPTION",28)
   disp-char21  = "A-" + getTermLabel("ITEM/SITE",24)
   disp-char1   = "B-" + getTermLabel("ITEM",24)
   disp-char4   = "C-" + getTermLabel("CUSTOMER",24)
   disp-char23  = "D-" + getTermLabel("SALES_ORDER_CONTROL",24).

do transaction:

   /* Added Control fields for Discount table required */
   find first mfc_ctrl where mfc_field = "soc_pc_line" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("PRICE_BY_SO_LINE_DUE_DATE",25)
         mfc_field = "soc_pc_line"
         mfc_type = "L"
         mfc_module = "SO"
         mfc_seq = 11
         mfc_logical = no.
   end.
   soc_pc_line = mfc_logical.

   /* Minimum Ship Amount */
   find mfc_ctrl where mfc_field = "soc_min_shpamt" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label  = getTermLabel("MINIMUM_SHIPMENT_AMOUNT",24)
         mfc_field  = "soc_min_shpamt"
         mfc_seq    = 12
         mfc_module = "SO"
         mfc_type   = "DE".
   end.
   soc_min_shpamt = mfc_dec.

   /* Added control field for Price Table Required */
   find first mfc_ctrl where mfc_field = "soc_pt_req" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("PRICE_TABLE_REQUIRED",24)
         mfc_field = "soc_pt_req"
         mfc_type = "L"
         mfc_module = "SO"
         mfc_seq = 17
         mfc_logical = no.
   end.
   soc_pt_req = mfc_logical.

   /* Adding Auto Batch Confirmation Variables */
   find first mfc_ctrl where mfc_field = "soc_batch" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("AUTO_BATCH_CONFIRMATION",24)
         mfc_field = "soc_batch"
         mfc_type = "L"
         mfc_module = "SO"
         mfc_seq = 388
         mfc_logical = no.
   end.

   soc_batch = mfc_logical.

   find first mfc_ctrl where mfc_field = "soc_batch_id" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("CONFIRMATION_BATCH_ID",24)
         mfc_field = "soc_batch_id"
         mfc_type = "C"
         mfc_module = "SO"
         mfc_seq = 389
         mfc_logical = no.
   end.

   soc_batch_id = mfc_char.

   find first mfc_ctrl where mfc_field = "soc_print_id" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("CONFIRMATION_PRINTER",24)
         mfc_field = "soc_print_id"
         mfc_type = "C"
         mfc_module = "SO"
         mfc_seq = 390
         mfc_logical = no.
   end.

   soc_print_id = mfc_char.

   /* We check mfc_seq in the following 3 fields because the custom */
   /* version of the patch used different sequence numbers, which   */
   /* conflict with patch G0NP                                      */
   find first mfc_ctrl where mfc_field = "soc_is_batid" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("SHIPMENT_BATCH_ID",24)
         mfc_field = "soc_is_batid"
         mfc_type = "C"
         mfc_module = "SO"
         mfc_seq = 394.
   end.
   else if mfc_seq <> 394 then
      mfc_seq = 394.

   soc_is_batid = mfc_char.

   find first mfc_ctrl where mfc_field = "soc_is_dev" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("SHIPMENT_BATCH_PRINTER",24)
         mfc_field = "soc_is_dev"
         mfc_type = "C"
         mfc_module = "SO"
         mfc_seq = 393.
   end.
   else if mfc_seq <> 393  then
      mfc_seq = 393.

   soc_is_dev = mfc_char.

   /* Add Batch Shipment Variables */
   find first mfc_ctrl where mfc_field = "soc_is_batch" no-lock no-error.
   if not available mfc_ctrl
   then do:
      create mfc_ctrl.
      assign
         mfc_label = getTermLabel("AUTO_BATCH_SHIPMENT",24)
         mfc_field = "soc_is_batch"
         mfc_type = "L"
         mfc_module = "SO"
         mfc_seq = 392
         mfc_logical = no.
   end.
   else if mfc_seq <> 392  then
      mfc_seq = 392.

   soc_is_batch = mfc_logical.

   /* ADD CHG/DELETE SO PICKED, SHIPPED OR RELEASED TO WO FLAGS */
   find first mfc_ctrl where mfc_field = "soc_emt_pick" no-lock no-error.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_label   = getTermLabel("MOD_DELETE_SO_PICKED",24)
         mfc_field   = "soc_emt_pick"
         mfc_type    = "L"
         mfc_module  = "SO"
         mfc_seq     = 395
         mfc_logical = no.
   end.
   else if mfc_seq <> 395 then
      mfc_seq = 395.

   soc_emt_pick = mfc_logical.

   find first mfc_ctrl where mfc_field = "soc_emt_rel" no-lock no-error.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_label   = getTermLabel("MOD_DELETE_SO_REL_WO",24)
         mfc_field   = "soc_emt_rel"
         mfc_type    = "L"
         mfc_module  = "SO"
         mfc_seq     = 396
         mfc_logical = no.
   end.
   else if mfc_seq <> 396 then
      mfc_seq = 396.
   soc_emt_rel = mfc_logical.

   find first mfc_ctrl where mfc_field = "soc_emt_ship" no-lock no-error.
   if not available mfc_ctrl then do:
      create mfc_ctrl.
      assign
         mfc_label   = getTermLabel("MOD_DELETE_SO_SHIP",24)
         mfc_field   = "soc_emt_ship"
         mfc_type    = "L"
         mfc_module  = "SO"
         mfc_seq     = 397
         mfc_logical = no.
   end.
   else if mfc_seq <> 397 then
      mfc_seq = 397.

   soc_emt_ship = mfc_logical.

end. /* read (or create) mfc_ctrl variables for SO */

/* Get error message (ERROR: NOT A VALID COMPANY) for future use */
{pxmsg.i &MSGNUM=28 &ERRORLEVEL=3 &MSGBUFFER=err-msg}

/* DISPLAY SELECTION FORM */
/* mfsopm-a, b */
form
   space(1)
   space(1)
   avail_calc
   skip
   skip
   space(1)
   soc_all_days          label "Allocate Sales Order Lines due in Days"
   disp-char12           no-label
   skip
   space(1)
   soc_all_avl           label "Limit Allocations to Avail to Allocate"
   soc_det_all           colon 65
   soc_atp_enabled       colon 30
   soc_horizon           colon 65
/* SS - 110104.1 - B 
   soc_calc_promise_date colon 65 label "Calculate Promise Date"
   soc_pick              colon 30
   soc_so_pre            colon 65
   soc_print             colon 30
   soc_so                colon 65
   soc_so_hist           colon 30
   soc_inv_pre           colon 65
   SS - 110104.1 - E */
/* SS - 110104.1 - B */
   soc_pick              colon 30
   soc_calc_promise_date colon 65 label "Calculate Promise Date"
   soc_user1             colon 30 label "SZ客户订单前辍" format "x(2)"
   soc_so_pre            colon 65
   soc_user2             colon 30 label "SZ下一个客户订单" format "x(6)"
   soc_so                colon 65
   soc_print             colon 30
   soc_inv_pre           colon 65
   soc_so_hist           colon 30
/* SS - 110104.1 - E */
   soc_inv               colon 65
   soc_shp_lead          colon 30
   soc_ar                colon 65
   soc_company           colon 30
   soc_sa                colon 65
   soc_hcmmts            colon 30
   soc_apm               colon 65
   soc_lcmmts            colon 30
   soc_confirm           colon 65
   soc_ln_inv            colon 30
   soc_fysm              colon 65
   soc_ln_fmt            colon 30
   soc_fob               colon 53
with frame mfsopm-a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame mfsopm-a:handle).

form
   soc_fr_by_site        colon 30
   soc_margin            colon 30
   soc_cr_hold           colon 30
   soc_crtacc_acct       colon 30
   soc_crtacc_sub                 no-label
   soc_crtacc_cc                  no-label
   soc_crtapp_acct       colon 30
   soc_crtapp_sub                 no-label
   soc_crtapp_cc                  no-label
   soc_pt_req            colon 30
   soc_batch             colon 65 label "Auto Batch Confirmation"
   soc_pl_req            colon 30
   soc_pc_line           colon 30
   soc_batch_id          colon 65 label "Confirmation Batch ID"
   soc_min_shpamt        colon 30
   soc_print_id          colon 65 label "Confirmation Printer"
   soc_edit_isb          colon 30
   soc_pim_isb           colon 65 label "Pend Inv Update ISB"
   soc_returns_isb       colon 30 label "SO Returns Update ISB"
   disp-char6                     no-label to 30
   soc_is_batch          colon 65 label "Auto Batch Shipment"
   soc_fcst_fwd          colon 30
   soc_is_batid          colon 65 label "Shipment Batch ID"
   soc_fcst_bck          colon 30
   soc_is_dev            colon 65 label "Shipment Batch Printer"
   soc__qadl02           colon 30
   soc_use_frt_trl_cd    colon 70
   soc_trl_tax[1]        colon 30  soc_trl_ntax[1] colon 70 skip
   soc_trl_tax[2]        colon 30  soc_trl_ntax[2] colon 70 skip
   soc_trl_tax[3]        colon 30  soc_trl_ntax[3] colon 70 skip
with frame mfsopm-b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame mfsopm-b:handle).

{&SOSOPM-P-TAG1}

form
   soc_use_btb     colon 35
   btb-type        colon 35
   soc_btb_sel     colon 35 disp-char21 no-label       at 50
                            disp-char1  no-label       at 50
                            disp-char4  no-label       at 50
                            disp-char23 no-label       at 50
   soc__qad01      colon 35 label "Auto EMT Processing"
   soc_due_calc    colon 35
   soc_btb_all     colon 35
   soc_dum_loc     colon 35
   soc__qadl03     colon 35 label "Auto Accept Supplier Changes"
   soc__qad02      colon 35 label "Use Customer Currency On PO"
   soc_emt_pick    colon 35 label "Allow Mod/Del When SO Picked"
   soc_emt_rel     colon 35 label "Allow Mod/Del When Released to WO"
   soc_emt_ship    colon 35 label "Allow Mod/Del When Shipped"
with frame mfsopm-c side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame mfsopm-c:handle).

repeat:
   view frame mfsopm-a.
   display
      disp-char12
   with frame mfsopm-a.

   do transaction with frame mfsopm-a:

      find first soc_ctrl exclusive-lock no-error.
      if not available soc_ctrl then
         create soc_ctrl.

      if soc_all then
         avail_calc = 1.
      if soc_all and soc_on_ord then
         avail_calc = 2.
      if soc_req then
         avail_calc = 3.
      if soc_req and soc_on_ord then
         avail_calc = 4.

      old_avail_calc = avail_calc.

      if recid(soc_ctrl) = -1 then .

      display soc_fysm.

      update
         avail_calc
         soc_all_days
         soc_all_avl
         soc_atp_enabled
         soc_pick
         /* SS - 110104.1 - B */
         soc_user1 
         soc_user2
         /* SS - 110104.1 - E */
         soc_print
         soc_so_hist
         soc_shp_lead
         soc_company validate (can-find (ls_mstr where ls_addr = soc_company
                                         and ls_type = "company") or
                                         soc_company = "", err-msg)
         soc_hcmmts
         soc_lcmmts
         soc_ln_inv
         soc_ln_fmt
         soc_det_all
         soc_horizon
         soc_calc_promise_date
         soc_so_pre
         soc_so
         soc_inv_pre
         soc_inv
         soc_ar
         soc_sa
         soc_apm
         soc_confirm
         soc_fob
      with no-validate.

      /* HORIZON CANNOT BE NEGATIVE */
      if soc_horizon < 0 then do:
         /* NEGATIVE AMOUNTS NOT ALLOWED */
         {pxmsg.i &MSGNUM=228 &ERRORLEVEL=3}
         next-prompt soc_horizon with frame mfsopm-a.
         undo, retry.
      end.

      if soc_apm then do:

         /* Future logic will go here to determine subdirectory*/
         assign
            apm-ex-prg = "ifapm063.r"
            apm-ex-sub = "if/".

         if search(apm-ex-sub + apm-ex-prg) = ?
         then do:
            /* APM programs are not currently installed */
            {pxmsg.i &MSGNUM=6311 &ERRORLEVEL=3}
            next-prompt soc_apm.
            undo, retry.
         end.

         {ifapmcon.i "6316" "next-prompt soc_apm. undo, retry"}
         /* CHECK APM DB CONNECTION */

      end.

      /* Update control data if availability calc changed */
      if avail_calc <> old_avail_calc
      then do:
         if avail_calc = 1 then
            assign
               soc_req = no
               soc_all = yes
               soc_on_ord = no.
         if avail_calc = 2 then
            assign
               soc_req = no
               soc_all = yes
               soc_on_ord = yes.
         if avail_calc = 3 then
            assign
               soc_req = yes
               soc_all = no
               soc_on_ord = no.
         if avail_calc = 4 then
            assign
               soc_req = yes
               soc_all = no
               soc_on_ord = yes.
      end.

      /* UPDATE CONTROL FLAGS FOR CUSTOMER SCHEDULES, SHIPPERS */
      {gprun.i ""rcpma.p""}

      if soc_apm
      then do:
         {gprunex.i
            &module = 'APM'
            &subdir = apm-ex-sub
            &program = 'ifapm063.p'
            &params = "(input global_userid,
                        output error_flag,
                        output error_nbr
                       )" }
         if error_flag
         then do:
            /* Unable to access APM */
            {pxmsg.i &MSGNUM=error_nbr &ERRORLEVEL=3}
            next-prompt soc_apm.
            undo, retry.
         end.
      end.
   end. /* update with frame mfsopm-a.*/

   hide frame mfsopm-a.

   do transaction:

      find first soc_ctrl exclusive-lock no-error.
      /* GET DEFAULT BTB TYPE FROM lngd_det */
      {gplngn2a.i &file = ""emt""
         &field = ""btb-type""
         &code  = soc_btb_type
         &mnemonic = btb-type
         &label = btb-type-desc}
   end.       /* do transaction for default BTB type */

   {&SOSOPM-P-TAG2}
   view frame mfsopm-c.

   display
      disp-char21
      disp-char1
      disp-char4
      disp-char23
      soc_use_btb
      btb-type
      soc_btb_sel
      soc__qad01
      soc_due_calc
      soc_btb_all
      soc_dum_loc
      soc__qadl03
      soc__qad02
      soc_emt_pick
      soc_emt_rel
      soc_emt_ship
   with frame mfsopm-c.
   {&SOSOPM-P-TAG3}

   setc:
   do transaction with frame mfsopm-c:

      find first soc_ctrl exclusive-lock no-error.
      sav-global-site = global_site.
      global_site = "".

      set soc_use_btb
      with frame mfsopm-c.

      setd:
      do with frame mfsopm-c on error undo, leave setd:

         set
            btb-type     when (soc_use_btb)
            soc_btb_sel  when (soc_use_btb)
            soc__qad01   when (soc_use_btb)
            soc_due_calc when (soc_use_btb)
            soc_btb_all  when (soc_use_btb)
            soc_dum_loc  when (soc_use_btb)
            soc__qadl03  when (soc_use_btb)
            soc__qad02   when (soc_use_btb)
            soc_emt_pick when (soc_use_btb)
            soc_emt_rel  when (soc_use_btb)
            soc_emt_ship when (soc_use_btb)
         with frame mfsopm-c.

         if soc_use_btb then do:
            find first mfc_ctrl where mfc_field = "soc_emt_pick"
            exclusive-lock no-error.
            if available mfc_ctrl then
               mfc_logical = soc_emt_pick.
            find first mfc_ctrl where mfc_field = "soc_emt_rel"
            exclusive-lock no-error.
            if available mfc_ctrl then
               mfc_logical = soc_emt_rel.
            find first mfc_ctrl where mfc_field = "soc_emt_ship"
            exclusive-lock no-error.
            if available mfc_ctrl then
               mfc_logical = soc_emt_ship.
         end. /* if soc_use_btb */

         if soc_use_btb entered and soc_use_btb = no
         then do:

            /* YOU ARE ABOUT TO TURN OFF EMT FUNCTIONALITY. PLEASE CONFIRM */
            {pxmsg.i &MSGNUM=2826 &ERRORLEVEL=2 &CONFIRM=yn}
            if not yn then do:
               assign
                  soc_use_btb = yes.
               display
                  soc_use_btb
               with frame mfsopm-c.
               next-prompt soc_use_btb.
               undo setc, retry setc.
            end.

            if yn then do:
               soc__qad01 = no.
               if btb-type <> "" then do:
                  assign
                     btb-type = "".
                  display
                     btb-type
                     soc_use_btb
                     soc__qad01
                  with frame mfsopm-c.
                  next-prompt btb-type.
                  undo setd, retry setd.
               end. /* if btb-type = "NON-EMT" */
            end. /* if yn */

         end.

         if soc_use_btb = no and soc__qad01 = yes
         then do:
            soc__qad01 = no.
            display soc__qad01 with frame mfsopm-c.
            /* Auto EMT processing is turned off */
            {pxmsg.i &MSGNUM=2936 &ERRORLEVEL=2}
            pause.
         end.

         if soc_use_btb then do:
            /* VALIDATE EMT TYPE - MUST BE IN lngd_det */
            {gplngv.i
               &file     = ""emt""
               &field    = ""btb-type""
               &mnemonic = btb-type
               &isvalid  = isvalid}
            if not isvalid
            then do:
               /* Invalid Mneumonic btb-type */
               {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
               next-prompt btb-type.
               undo setd, retry setd.
            end.

            /* PICK UP NUMERIC FOR BTB TYPE CODE FROM MNEMONIC */
            {gplnga2n.i &file  = ""emt""
               &field = ""btb-type""
               &mnemonic = btb-type
               &code = soc_btb_type
               &label = btb-type-desc}
         end. /* if soc_use_btb */
         else
            soc_btb_type = "".

         do i = 1 to 4:
            do j = 1 to 4:
               if (substring(soc_btb_sel,i,1) =
                   substring(soc_btb_sel,j,1) and i <> j) or
                  index("ABCD",substring(soc_btb_sel,i,1)) = 0
               then do:
                  /* Invalid Sequence */
                  {pxmsg.i &MSGNUM=2818 &ERRORLEVEL=3}
                  next-prompt soc_btb_sel.
                  undo, retry.
               end.
            end. /* do j = 1 to 4 */
         end. /* do i = 1 to 4  */

         if soc_use_btb then do:
            find first loc_mstr where loc_loc = soc_dum_loc
            no-lock no-error.
            if not available loc_mstr
            then do:
               /* Location does not exist */
               {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
               next-prompt soc_dum_loc.
               undo,retry.
            end.

            find first is_mstr where is_status = loc_status
               and is_nettable = no no-lock no-error.
            if not available is_mstr
            then do:
               /* DUMMY LOCATION MUST HAVE A NON NETTABLE INVENTORY STATUS */
               {pxmsg.i &MSGNUM=2841 &ERRORLEVEL=3}
               next-prompt soc_dum_loc.
               undo,retry.
            end.

            /* Issue warning if a "reserved" location found...*/
            if can-find (first locc_det where locc_loc = soc_dum_loc)
            then do:
               del-yn = no.
               /* RESERVED LOCATION DATA EXISTS FOR THIS */
               /* LOCATION. CONTINUE?                    */
               {pxmsg.i &MSGNUM=3345 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn = no then do:
                  next-prompt soc_dum_loc.
                  undo, retry.
               end.
            end.  /* if can-find... */


         end. /* if use btb*/

      end. /* setd */
      {&SOSOPM-P-TAG5}

      global_site = sav-global-site.

   end.   /*setc*/

   {&SOSOPM-P-TAG4}
   hide frame mfsopm-c.

   view frame mfsopm-b.

   display
      disp-char6
      soc_fr_by
      soc_margin
      soc_cr_hold
      soc_crtacc_acct
      soc_crtacc_sub
      soc_crtacc_cc
      soc_crtapp_acct
      soc_crtapp_sub
      soc_crtapp_cc
      soc_pt_req
      soc_pl_req label "Disc Table Required"
      soc_batch
      soc_batch_id
      soc_print_id
      soc_pc_line
      soc_min_shpamt
      soc_pim_isb
      soc_edit_isb
      soc_returns_isb
      soc_is_batch
      soc_is_batid
      soc_is_dev
      soc_fcst_fwd
      soc_fcst_bck
      soc__qadl02
      soc_use_frt_trl_cd
      soc_trl_tax
      soc_trl_ntax
   with frame mfsopm-b.

   /* Update frame mfsopm-b */
   setb:
   do transaction with frame mfsopm-b:

      find first soc_ctrl exclusive-lock no-error.

      set
         soc_fr_by
         soc_margin
         soc_cr_hold
         soc_crtacc_acct
         soc_crtacc_sub
         soc_crtacc_cc
         soc_crtapp_acct
         soc_crtapp_sub
         soc_crtapp_cc
         soc_pt_req
         soc_batch
         soc_pl_req   label "Disc Table Required"
         soc_pc_line
         soc_batch_id
         soc_min_shpamt
         soc_print_id
         soc_edit_isb
         soc_pim_isb
         soc_returns_isb
         soc_is_batch
         soc_fcst_fwd
         soc_is_batid
         soc_fcst_bck
         soc_is_dev
         soc__qadl02
         soc_use_frt_trl_cd
         soc_trl_tax
         soc_trl_ntax .

      if soc_returns_isb then do:

         for first svc_ctrl
            fields (svc_ship_isb)
         no-lock: end.

         if not available svc_ctrl or
            (available svc_ctrl and not svc_ship_isb)
         then do:
            /* SHIPMENTS DO NOT AUTOMATICALLY UPDATE THE INSTALLED BASE */
            {pxmsg.i &MSGNUM=1696 &ERRORLEVEL=2}
         end.
      end.     /* if soc_returns_isb */

      if soc_pt_req then do:
         find first pic_ctrl no-lock no-error.
         if available pic_ctrl and not pic_so_linpri
         then do:
            /* PRICE LIST REQUIRED AND NO LINE PRICING NOT ALLOWED */
            {pxmsg.i &MSGNUM=1277 &ERRORLEVEL=3}
            next-prompt soc_pt_req.
            undo, retry.
         end.
      end.

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}
      /* SET PROJECT VERIFICATION TO NO */
      {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input  soc_crtacc_acct,
           input  soc_crtacc_sub,
           input  soc_crtacc_cc,
           input  """",
           output valid_acct)"}

      if valid_acct = no then do:
         next-prompt soc_crtacc_acct with frame mfsopm-b.
         undo setb, retry.
      end.

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}
      /* SET PROJECT VERIFICATION TO NO */
      {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input  soc_crtapp_acct,
           input  soc_crtapp_sub,
           input  soc_crtapp_cc,
           input  """",
           output valid_acct)"}

      if valid_acct = no then do:
         next-prompt soc_crtapp_acct with frame mfsopm-b.
         undo setb, retry.
      end.

      if soc_fcst_fwd < 0 or soc_fcst_fwd > 26
      then do:
         /* Cannot exceed 26 */
         {pxmsg.i &MSGNUM=68 &ERRORLEVEL=3}
         next-prompt soc_fcst_fwd.
         undo, retry.
      end.

      if soc_fcst_bck < 0 or soc_fcst_bck > 26
      then do:
         /* Cannot exceed 26 */
         {pxmsg.i &MSGNUM=68 &ERRORLEVEL=3}
         next-prompt soc_fcst_bck.
         undo, retry.
      end.

      {gptrlval.i &code=soc_trl_tax[1]}
      {gptrlval.i &code=soc_trl_tax[2]}
      {gptrlval.i &code=soc_trl_tax[3]}
      {gptrlval.i &code=soc_trl_ntax[1]}
      {gptrlval.i &code=soc_trl_ntax[2]}
      {gptrlval.i &code=soc_trl_ntax[3]}

      /* UPDATE MFC_CTRL RECORDS */
      find first mfc_ctrl where mfc_field = "soc_pc_line"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_logical = soc_pc_line.

      find mfc_ctrl where mfc_field = "soc_min_shpamt"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_dec = soc_min_shpamt.

      find first mfc_ctrl where mfc_field = "soc_pt_req"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_logical = soc_pt_req.

      find first mfc_ctrl where mfc_field = "soc_batch"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_logical = soc_batch.

      find first mfc_ctrl where mfc_field = "soc_batch_id"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_char = soc_batch_id.

      find first mfc_ctrl where mfc_field = "soc_print_id"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_char = soc_print_id.

      find first mfc_ctrl where mfc_field = "soc_is_batch"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_logical = soc_is_batch.

      find first mfc_ctrl where mfc_field = "soc_is_dev"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_char = soc_is_dev.

      find first mfc_ctrl where mfc_field = "soc_is_batid"
      exclusive-lock no-error.
      if available mfc_ctrl then
         mfc_char = soc_is_batid.

   end.

   hide message.
   hide frame mfsopm-b.

   release mfc_ctrl.

end.

status input.
