/* s9apvniq.p - CUSTOMISED FROM                                         */
/* apvniq.p - ACCOUNTS PAYABLE VENDOR INQUIRY                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.13.1.12 $                                               */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/13/86   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 07/01/91   BY: MLV *D735*          */
/* REVISION: 7.0      LAST MODIFIED: 12/27/91   BY: MLV *F079*          */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: MLV *G042*          */
/* Revision: 7.3          Last edit: 11/19/92   By: jcd *G345*          */
/*                                   04/30/93   By: bcm *GA58*          */
/*                                   11/08/94   BY: str *FT49*          */
/* REVISION: 8.5      LAST MODIFIED: 12/24/95   BY: mwd *J053*          */
/*                                   04/04/96   BY: jzw *G1SC*          */
/*                                   04/05/96   BY: jzw *G1LD*          */
/*                                   09/18/96   BY: jzw *H0MW*          */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ckm *K0SW*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 04/21/98   BY: *H1JY* A. Licha     */
/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *L00S* CPD/EJ       */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L03L* Brenda Milton*/
/* REVISION: 8.6E     LAST MODIFIED: 09/22/98   BY: *L09K* Jeff Wootton */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/24/99   BY: *M0H2* Raphael T          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 08/25/00   BY: *M0RS* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00   BY: *N0MG* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 09/23/00   BY: *N0VN* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 06/19/01   BY: *N0ZX* Ed van de Gevel    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.1.10  BY: Ed van de Gevel  DATE: 11/09/01 ECO: *N15N*       */
/* Revision: 1.13.1.11  BY: Lena Lim         DATE: 06/06/02 ECO: *P07V*       */
/* $Revision: 1.13.1.12 $  BY: Hareesh V.    DATE: 06/21/02 ECO: *N1HY*       */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
   Customised on : 11th May 2004   By *ekDm1*  Kunal D. Malvankar
   Customisation : Allowing Entry of "Entity" in Inquiry Criteria  
   + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + */

/* DISPLAY TITLE */
{mfdtitle.i "1.0e "}          /*ekDm1*/
/****
{cxcustom.i "APVNIQ.P"}
****/
/* ********** Begin Translatable Strings Definitions ********* */

/*** 
&SCOPED-DEFINE apvniq_p_1 "Open Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq_p_2 "Amount Open"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq_p_4 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq_p_5 "Sort Name"
/* MaxLen: Comment: Windows version only */

****/

&SCOPED-DEFINE apvniq_p_1 "仅为未结"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq_p_2 "未结金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq_p_3 "暂停"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq_p_4 "参考"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvniq_p_5 "排序名"
/* MaxLen: Comment: Windows version only */

/* ********** End Translatable Strings Definitions ********* */

define variable vend like ap_vend.
define variable amt_open like ap_amt label {&apvniq_p_2} format "->>>>>>>9.99".
define variable open_only like mfc_logical label {&apvniq_p_1}.
define variable open_ref like mfc_logical.
define variable applied like vo_applied.
{&APVNIQ-P-TAG1}
define variable notes as character format "x(8)".
{&APVNIQ-P-TAG2}
define variable base_rpt like ap_curr.
define variable base_amt like ap_amt.
define variable base_applied like vo_applied.
define variable base_hold_amt like vo_hold_amt.
define variable disp_curr as character format "x(1)" label "C".
define variable curr_tot like vd_balance.
define variable ap_due_date like ap_date no-undo.
define variable disp_due_date as character format "x(8)" no-undo.

define variable mc-rpt-curr like ap_curr no-undo.

{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i}
define variable et_curr_tot      like vd_balance.

define variable et_ap_amt        like ap_amt.
define variable et_vo_applied    like vo_applied.
define variable et_vd_balance    like vd_balance.

/*ekDm1*/ define variable m_entity like en_entity .
/*Et1*/   define variable stdt like ap_date .

find first gl_ctrl no-lock.

{&APVNIQ-P-TAG3}

/***ekDm1*** Commented Out the Original Form & Added "Entity" in
             The Form & re-arranged the fields
form
   vend                   /*V8!   colon 9        */
   vd_sort format "x(25)" /*V8-*/ no-label  /*V8+*/
   /*V8! label {&apvniq_p_5} colon 31 */

   open_only              /*V8!   colon 71       */
   vd_balance             /*V8!   colon 9        */
   base_rpt       skip
   et_report_curr         /*V8-*/ colon 19  /*V8+*/
   /*V8!   colon 17       */

   /*END ADDED CODE                                    */
with frame a width 80 side-labels no-underline no-attr-space.

 ***ekDm1******************************************/
 
 
/*ekDm1*/ FORM
           vend                   
           vd_sort format "x(25)"         no-label 
           open_only              
           stdt                  label "Start Dt"
           m_entity                       colon 9 
           base_rpt      
           et_report_curr         
           vd_balance                     colon 9
          WITH FRAME a width 80 side-labels no-underline no-attr-space.

{&APVNIQ-P-TAG4}

/********
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*******/

{wbrp01.i}
repeat:

   if c-application-mode <> 'web' then
   {&APVNIQ-P-TAG5}
   update
      vend
/*ekDm1*/ m_entity
      open_only
      stdt
      base_rpt
      et_report_curr
      with frame a
   editing:

      {&APVNIQ-P-TAG6}

      if frame-field = "vend" then do for ap_mstr:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i ap_mstr vend ap_vend vend ap_vend ap_vend}
         If recno <> ? then do:         
            vend = ap_vend.
            {&APVNIQ-P-TAG7}
            find vd_mstr where vd_addr = vend no-lock.
            display vend vd_sort vd_balance with frame a.
            {&APVNIQ-P-TAG8}
            recno = ?.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.

   end.

   {&APVNIQ-P-TAG13}
   {wbrp06.i &command = update &fields = "  vend open_only base_rpt
        et_report_curr
/*ekDm1*/ m_entity
        " &frm = "a"}
   {&APVNIQ-P-TAG14}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      status input "".
      display "" @ vd_sort with frame a.

      if base_rpt <> "" then
         mc-rpt-curr = base_rpt.
      else mc-rpt-curr = base_curr.

      if et_report_curr <> "" then do:
         {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
            "(input et_report_curr,
              output mc-error-number)"}
         if mc-error-number = 0
            and et_report_curr <> mc-rpt-curr then do:
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input mc-rpt-curr,
                 input et_report_curr,
                 input "" "",
                 input et_eff_date,
                 output et_rate1,
                 output et_rate2,
                 output mc-error-number)"}
         end.  /* if mc-error-number = 0 */

         if mc-error-number <> 0 then do:
            {mfmsg.i mc-error-number 3}
            if c-application-mode = 'web' then return.
            else next-prompt et_report_curr with frame a.
            undo, retry.
         end.  /* if mc-error-number <> 0 */
      end.  /* if et_report_curr <> "" */

      if et_report_curr = "" or et_report_curr = mc-rpt-curr then
         et_report_curr = mc-rpt-curr.

      find vd_mstr where vd_addr = vend no-lock no-error.

      if available vd_mstr then do:

         display vd_sort with frame a.

         {&APVNIQ-P-TAG9}

         if base_rpt = "" then do:

            if et_report_curr <> mc-rpt-curr then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input mc-rpt-curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input vd_balance,
                    input true,  /* ROUND */
                    output et_vd_balance,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {mfmsg.i mc-error-number 2}
         /*       {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}   */
               end.
            end.  /* if et_report_curr <> mc-rpt-curr */
            else
               et_vd_balance = vd_balance.

            display et_vd_balance @ vd_balance with frame a.

         end.

         else do:

            {&APVNIQ-P-TAG10}

            assign et_curr_tot = 0.

            for each ap_mstr no-lock where ap_vend = vend
               and ap_curr = base_rpt, 
               each vo_mstr no-lock where vo_ref = ap_ref
               and vo_confirmed = true:

               if et_report_curr <> mc-rpt-curr then do:
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input ap_amt,
                       input true,  /* ROUND */
                       output et_ap_amt,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
			   {mfmsg.i mc-error-number 2}
                /*   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}  */
                  end.
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input mc-rpt-curr,
                       input et_report_curr,
                       input et_rate1,
                       input et_rate2,
                       input vo_applied,
                       input true,  /* ROUND */
                       output et_vo_applied,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {mfmsg.i mc-error-number 2}
                /*   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}  */
                  end.
               end.  /* if et_report_curr <> mc-rpt-curr */
               else
                  assign
                     et_ap_amt = ap_amt
                     et_vo_applied = vo_applied.

               assign
                  et_curr_tot = et_curr_tot + (et_ap_amt - et_vo_applied).

            end.  /* for each ap_mstr */

            display
               curr_tot    @ vd_balance with frame a.
            display
               et_curr_tot @ vd_balance with frame a.

         end.  /* else do */

      end.  /* if available vd_mstr */

      hide frame b.

   end.  /* if (c-application-mode <> 'web') ... */

    {mfselprt.i "terminal" 80}
   /* OUTPUT DESTINATION SELECTION *****
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
            *******/   

   aploop:
   repeat for ap_mstr with frame b width 80 no-attr-space:

      /* SET EXTERNAL LABELS */
/****
      setFrameLabels(frame b:handle).
****/
      {mfrpchk.i}

      find prev ap_mstr where ap_vend = vend and
         ((ap_curr = base_rpt)   or (base_rpt = ""))
/*ekDm1*/ and ((ap_entity = m_entity) or (m_entity = ""))

      no-lock use-index ap_vend.

      if ap_type = "RV" then next.
      if ap_date < stdt and stdt <> ? then 
         next.

      base_amt = ap_amt.
      disp_curr = "".

      if base_rpt = ""
         and ap_curr <> base_curr
      then do:
         assign
            base_amt = ap_base_amt
            disp_curr = "Y".
         /* disp_curr = getTermLabel("YES",1).  */
      end.

      assign
         open_ref = yes
         notes = "".

      if ap_type = "VO" then do:

         find vo_mstr where vo_ref = ap_ref
            and ((vo_curr = base_rpt) or (base_rpt = ""))
         no-lock.

         if not vo_confirmed then
            next aploop.

         assign
            base_applied = vo_applied
            base_hold_amt = vo_hold_amt.

         if base_rpt = "" and ap_curr <> base_curr then
            assign
               base_applied = vo_base_applied
               base_hold_amt = vo_base_hold_amt.

         applied = base_applied.

         if base_amt - applied = 0 then
            open_ref = no.

      end.

      else do:
         applied = base_amt.
         find ck_mstr where ck_ref = ap_ref
            and ((ck_curr = base_rpt) or (base_rpt = ""))
         no-lock.
         if open_only then open_ref = no.
      end.

      amt_open = if available vo_mstr and vo_applied = ap_amt
                 then 0
                 else base_amt - applied.

      if not open_only or open_ref then do:

         display
            ap_date
            ap_ref label {&apvniq_p_4} format "x(8)"
            /* DRAFTS HAVE A DUE DATE (AP__QAD01) */
            (if ap_type = "CK" and ap__qad01 > ""
            then "D"
            else ap_type)
            @ ap_type
            format "x(1)"
         with frame b.

         if ap_type = "VO" then do:

            if base_hold_amt <> 0 then do:
               assign
                  notes = {&apvniq_p_3}
     /*           notes = getTermLabel("HOLD",8)   */
                  amt_open = if vo_applied = ap_amt
                             then 0
                             else base_amt - base_applied.
            end.

            if notes = "" then do:
               find last ckd_det where ckd_voucher = ap_ref
               no-lock no-error.
               if available ckd_det then
               do while available ckd_det:
                  find ck_mstr where ck_ref = ckd_ref no-lock no-error.
                  if ck_status <> "Void" then do:
                     notes = ckd_ref.
                     leave.
                  end.
                  else
                  find prev ckd_det where ckd_voucher = ap_ref
                  no-lock no-error.
               end.
            end.

            if et_report_curr <> mc-rpt-curr then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input mc-rpt-curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_amt,
                    input true,  /* ROUND */
                    output base_amt,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {mfmsg.i mc-error-number 2}
             /*   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2} */
               end.
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input mc-rpt-curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input amt_open,
                    input true,  /* ROUND */
                    output amt_open,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {mfmsg.i mc-error-number 2}
               /* {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2} */
               end.
            end.  /* if et_report_curr <> mc-rpt-curr */

            display
               vo_invoice    format "x(12)"
               vo_due_date  
               disp_curr
               base_amt
               format "->>>>>>>9.99"
               amt_open
               notes no-label
            with frame b.

         end.

         else do:
            if ap_type = "CK" and ap__qad01 > "" then do:
               /* CONVERT CHARACTER DATE TO DATE FORMAT */
               {gprun.i ""gpchtodt.p""
                  "(input  ap__qad01,
                    output ap_due_date)"}
               disp_due_date = string(ap_due_date).
            end.
            else
               disp_due_date = "".

            if et_report_curr <> mc-rpt-curr then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input mc-rpt-curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_amt,
                    input true,  /* ROUND */
                    output base_amt,
                    output mc-error-number)"}
               if mc-error-number <> 0 then do:
                  {mfmsg.i mc-error-number 2}
              /*  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}  */
               end.
            end.  /* if et_report_curr <> mc-rpt-curr */

            display
               "" @ vo_invoice
               disp_due_date @ vo_due_date  
               disp_curr
               base_amt
               format "->>>>>>>9.99"
               "" @ amt_open
               "" @ notes
            with frame b.

         end.

      end. /* IF NOT OPEN_ONLY */

   end. /* APLOOP: REPEAT */

   {&APVNIQ-P-TAG11}

/*LW {mfreset.i}*/
 /*LW*/ {mfguirex.i }.
 /*LW*/ {mfguitrl.i}.
 /*LW*/ {mfgrptrm.i} .

   {mfmsg.i 8 1}
  
/* {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1} */

end. /* REPEAT */

{wbrp04.i &frame-spec = a}

{&APVNIQ-P-TAG12}



